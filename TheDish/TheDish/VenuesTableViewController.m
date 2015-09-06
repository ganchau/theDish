//
//  VenuesTableViewController.m
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "VenuesTableViewController.h"
#import "VenueTableViewCell.h"
#import "DataManager.h"
#import "FourSquareAPI.h"
#import "Venue.h"
#import "PersonalVenue.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

NSString *const REUSE_ID = @"venueRID";

@interface VenuesTableViewController () <CLLocationManagerDelegate, VenueTableViewCellDelegate>

@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *venuesImages;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)setupProgressHUD;
- (void)setupVenueData;

@end

@implementation VenuesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initialSetup];
    [self setupProgressHUD];
    [self getCurrentLocation];
}

#pragma mark - Initial Setup for view controller
- (void)initialSetup
{
    self.dataManager = [DataManager sharedDataManager];
    self.venuesImages = [@[] mutableCopy];
    
    // set up the navigation bar properties
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0
                                                                        green:61.0/255.0
                                                                         blue:127.0/255.0
                                                                        alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"The Dish";

}

#pragma mark - Setting Up Progress View

- (void)setupProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];         // default is [UIColor whiteColor]
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];             // default is [UIColor blackColor]
    [SVProgressHUD setRingThickness:2.0];                                // default is 4 pt
    
    // set up pull down refresh progress spinner
    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:255.0/255.0
                                                    green:61.0/255.0
                                                     blue:127.0/255.0
                                                    alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(getCurrentLocation)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)setupVenueData
{
    [SVProgressHUD show];  // show progress animation
    
    [self.dataManager.venuesList removeAllObjects];
    [self.venuesImages removeAllObjects];
    
    NSString *latLong = [NSString stringWithFormat:@"%.2f, %.2f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    NSLog(@"Lat Long: %@", latLong);
    
    [FourSquareAPI getVenuesWithLatLong:latLong Completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            NSLog(@"Success!!!");
            for (NSDictionary *venueObject in responseObject) {
                Venue *venue = [[Venue alloc] initWithVenue:venueObject];

                [self.dataManager.venuesList addObject:venue];
            }
            [self.tableView reloadData]; // must reload the table when info is fetched
            [SVProgressHUD dismiss];  // dismiss progress animation
            [self.refreshControl endRefreshing];  // end refresh animation
        } else {
            NSLog(@"Error getting venue: %@", error.description);
            [SVProgressHUD dismiss];  // dismiss progress animation
            [self.refreshControl endRefreshing];  // end refresh animation
        }
    }];
}

#pragma mark - Core Location Manager

- (void)getCurrentLocation;
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]) {
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"CLLocationManager didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Location updated");
    [self.locationManager stopUpdatingLocation];
    [self setupVenueData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Venues count: %li", self.dataManager.venuesList.count);
    
    return self.dataManager.venuesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VenueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID forIndexPath:indexPath];
    cell.delegate = self;
    
    // Configure the cell...
    NSUInteger currentRow = indexPath.row;
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    cell.venuePhoto.image = placeholderImage;
    Venue *venue = self.dataManager.venuesList[currentRow];
    cell.venueName.text = venue.name;
    
    if (self.venuesImages.count > currentRow) {
        cell.venuePhoto.image = self.venuesImages[currentRow];
    } else {
        cell.venuePhoto.alpha = 0;
        [FourSquareAPI getVenuesPhotosWithVenueID:venue.venueID
                                       Completion:^(BOOL success, id responseObject, NSError *error) {
                                           if (success) {
                                               NSString *prefixURL = [responseObject[@"items"] firstObject][@"prefix"];
                                               NSString *suffixURL = [responseObject[@"items"] firstObject][@"suffix"];
                                               if (prefixURL != nil && suffixURL != nil) {
                                                   NSString *imageURL = [NSString stringWithFormat:@"%@%@%@", prefixURL, IMAGE_SIZE, suffixURL];
                                                   NSLog(@"URL for photo: %@", imageURL);
                                                   
                                                   [FourSquareAPI getImageWithURL:imageURL
                                                                       Completion:^(BOOL success, UIImage *image, NSError *error) {
                                                                           if (success) {
                                                                               [self.venuesImages addObject:image];
                                                                               cell.venuePhoto.image = image;
                                                                               
                                                                               [UIView animateWithDuration:0.3
                                                                                                animations:^{
                                                                                                    cell.venuePhoto.alpha = 1;
                                                                                                    [self.view layoutIfNeeded];
                                                                                                }];
                                                                           } else {
                                                                               NSLog(@"Error getting image: %@", error.description);
                                                                               [self.venuesImages addObject:placeholderImage];
                                                                               
                                                                               [UIView animateWithDuration:0.3
                                                                                                animations:^{
                                                                                                    cell.venuePhoto.alpha = 1;
                                                                                                    [self.view layoutIfNeeded];
                                                                                                }];
                                                                           }
                                                                       }];
                                               } else {
                                                   NSLog(@"Venue has no photo.");
                                                   [self.venuesImages addObject:placeholderImage];
                                                   
                                                   [UIView animateWithDuration:0.3
                                                                    animations:^{
                                                                        cell.venuePhoto.alpha = 1;
                                                                        [self.view layoutIfNeeded];
                                                                    }];
                                               }
                                               
                                           } else {
                                               NSLog(@"Error getting photo data from venue: %@", error.description);
                                           }
                                       }];
    }
    
    NSString *address = [venue.address componentsJoinedByString:@", "];
    cell.venueAddress.text = address;
    
    return cell;
}

#pragma mark - VenueTableViewCell delegate methods

- (void)likeButtonWasTapped:(VenueTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block BOOL venueExists = NO;
    
    // currently selected venue
    Venue *currentVenue = self.dataManager.venuesList[indexPath.row];

    // fetch arrays of personal venue from persistent data
    NSFetchRequest *personalVenueFetch = [[NSFetchRequest alloc] initWithEntityName:@"PersonalVenue"];
    self.dataManager.personalVenuesList = [self.dataManager.managedObjectContext executeFetchRequest:personalVenueFetch
                                                                                               error:nil];
    NSLog(@"personal venue list: %@", self.dataManager.personalVenuesList);
    [self.dataManager.personalVenuesList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PersonalVenue *personalVenue = (PersonalVenue *)obj;
        
        if ([personalVenue.venueID isEqualToString:currentVenue.venueID]) {
            venueExists = YES;
            NSLog(@"personal venue exists");
            
            if (personalVenue.liked == YES) {
                [self.dataManager.managedObjectContext deleteObject:personalVenue];
                cell.likeButton.backgroundColor = [UIColor clearColor];
            } else {
                cell.likeButton.backgroundColor = [UIColor greenColor];
                cell.dislikeButton.backgroundColor = [UIColor clearColor];
                personalVenue.liked = YES;
            }
            *stop = YES;
        }
    }];
    
    if (!venueExists) {
        NSLog(@"no personal venue exists");
        PersonalVenue *personalVenue = [NSEntityDescription insertNewObjectForEntityForName:@"PersonalVenue"
                                                                     inManagedObjectContext:self.dataManager.managedObjectContext];
        personalVenue.liked = YES;
        personalVenue.venueID = currentVenue.venueID;
        NSLog(@"inserted into managed context: %@", personalVenue);
    }
    
    [self.dataManager saveContext];
}

- (void)dislikeButtonWasTapped:(VenueTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    __block BOOL venueExists = NO;
    
    // currently selected venue
    Venue *currentVenue = self.dataManager.venuesList[indexPath.row];
    
    // fetch arrays of personal venue from persistent data
    NSFetchRequest *personalVenueFetch = [[NSFetchRequest alloc] initWithEntityName:@"PersonalVenue"];
    self.dataManager.personalVenuesList = [self.dataManager.managedObjectContext executeFetchRequest:personalVenueFetch
                                                                                               error:nil];
    NSLog(@"personal venue list: %@", self.dataManager.personalVenuesList);
    [self.dataManager.personalVenuesList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PersonalVenue *personalVenue = (PersonalVenue *)obj;
        
        if ([personalVenue.venueID isEqualToString:currentVenue.venueID]) {
            venueExists = YES;
            NSLog(@"personal venue exists");
            
            if (personalVenue.disliked == YES) {
                [self.dataManager.managedObjectContext deleteObject:personalVenue];
                cell.dislikeButton.backgroundColor = [UIColor clearColor];
            } else {
                cell.likeButton.backgroundColor = [UIColor clearColor];
                cell.dislikeButton.backgroundColor = [UIColor redColor];
                personalVenue.disliked = YES;
            }
            *stop = YES;
        }
    }];
    
    if (!venueExists) {
        NSLog(@"no personal venue exists");
        PersonalVenue *personalVenue = [NSEntityDescription insertNewObjectForEntityForName:@"PersonalVenue"
                                                                     inManagedObjectContext:self.dataManager.managedObjectContext];
        personalVenue.disliked = YES;
        personalVenue.venueID = currentVenue.venueID;
        NSLog(@"inserted into managed context: %@", personalVenue);
    }
    
    [self.dataManager saveContext];
    
    
    // ...do something to trigger venue dislike on or off
//    if (self.isLiked) {
//        self.dislikeButton.backgroundColor = [UIColor redColor];
//        self.likeButton.backgroundColor = [UIColor clearColor];
//        self.isLiked = NO;
//    } else {
//        self.dislikeButton.backgroundColor = [UIColor clearColor];
//        self.isLiked = YES;
//    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
