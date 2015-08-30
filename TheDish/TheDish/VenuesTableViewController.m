//
//  VenuesTableViewController.m
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "VenuesTableViewController.h"
#import "FourSquareAPI.h"
#import "Venue.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>

NSString *const REUSE_ID = @"venueRID";

@interface VenuesTableViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *venues;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)setupProgressHUD;
- (void)setupVenueData;

@end

@implementation VenuesTableViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.venues = [@[] mutableCopy];
    [self setupProgressHUD];
    [self getCurrentLocation];
}

#pragma mark - Setting Up View

- (void)setupProgressHUD
{
    [SVProgressHUD setBackgroundColor:[UIColor lightGrayColor]];         // default is [UIColor whiteColor]
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];             // default is [UIColor blackColor]
    [SVProgressHUD setRingThickness:2.0];                                // default is 4 pt

    // set up pull down refresh progress spinner
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    self.refreshControl.tintColor = [UIColor colorWithRed:50.0/255.0 green:0 blue:1 alpha:1];
    [self.refreshControl addTarget:self
                            action:@selector(getCurrentLocation)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)setupVenueData
{
    [self.venues removeAllObjects];
    
    NSString *latLong = [NSString stringWithFormat:@"%.2f, %.2f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    NSLog(@"Lat Long: %@", latLong);

    [FourSquareAPI getVenuesWithLatLong:latLong Completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            NSLog(@"Success!!!");
            for (NSDictionary *venueObject in responseObject) {
                Venue *venue = [[Venue alloc] initWithVenue:venueObject];
                [self.venues addObject:venue];
            }
            [self.tableView reloadData]; // must reload the table when info is fetched
            [SVProgressHUD dismiss];  // dismiss progress animation
            [self.refreshControl endRefreshing];  // end refresh animation
        } else {
            NSLog(@"Error: %@", error.description);
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
    [self.locationManager stopUpdatingLocation];
    [self setupVenueData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    [SVProgressHUD show];  // show progress animation

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Venues count: %li", self.venues.count);

    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID forIndexPath:indexPath];
    
    // Configure the cell...
    Venue *venue = self.venues[indexPath.row];
    cell.textLabel.text = venue.name;
    
    NSString *address = [venue.address componentsJoinedByString:@", "];
    cell.detailTextLabel.text = address;
    
    return cell;
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
