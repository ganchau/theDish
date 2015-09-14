//
//  LikedVenuesTableViewController.m
//  TheDish
//
//  Created by Gan Chau on 9/3/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "LikedVenuesTableViewController.h"
#import "PersonalVenueTableViewCell.h"
#import "DataManager.h"
#import "FourSquareAPI.h"
#import "PersonalVenue+CoreDataProperties.h"
#import "Constants.h"

NSString *const MY_REUSE_ID = @"myVenueRID";

@interface LikedVenuesTableViewController ()

@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *venuesImages;

@end

@implementation LikedVenuesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupPersonalVenueData];
}

- (void)initialSetup
{
    self.venuesImages = [@[] mutableCopy];

    // set up the navigation bar properties
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0
                                                                           green:61.0/255.0
                                                                            blue:127.0/255.0
                                                                           alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = NO;
    //self.navigationItem.title = @"The Dish";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupPersonalVenueData
{
    NSFetchRequest *personalVenueFetch = [[NSFetchRequest alloc] initWithEntityName:@"PersonalVenue"];
    self.dataManager = [DataManager sharedDataManager];
    self.dataManager.personalVenuesList = [self.dataManager.managedObjectContext executeFetchRequest:personalVenueFetch
                                                                                               error:nil];
    NSLog(@"what is in here? %@", self.dataManager.personalVenuesList);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataManager.personalVenuesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalVenueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_REUSE_ID forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSUInteger currentRow = indexPath.row;
    
    PersonalVenue *personalVenue = self.dataManager.personalVenuesList[currentRow];
    
    cell.venueName.text = personalVenue.name;
    cell.venueID = personalVenue.venueID;
    cell.venueAddress.text = personalVenue.address;
    cell.venuePhoto.alpha = 0;
    
    if (personalVenue.image) {
        cell.venuePhoto.alpha = 1;
        cell.venuePhoto.image = [UIImage imageWithData:personalVenue.image];
    } else {
        [FourSquareAPI getVenuesPhotosWithVenueID:personalVenue.venueID
                                       Completion:^(BOOL success, id responseObject, NSError *error) {
                                           if (success) {
                                               // check if current venue id and cell's venue id gets out of sync
                                               if(![cell.venueID isEqualToString:personalVenue.venueID]) {
                                                   NSLog(@"Ah! The cell got changed out from underneath us!");
                                                   return;
                                               }
                                               
                                               NSString *prefixURL = [responseObject[@"items"] firstObject][@"prefix"];
                                               NSString *suffixURL = [responseObject[@"items"] firstObject][@"suffix"];
                                               
                                               NSString *imageURL = [NSString stringWithFormat:@"%@%@%@", prefixURL, IMAGE_SIZE, suffixURL];
                                               __weak PersonalVenueTableViewCell *weakCell = cell;
                                               
                                               [FourSquareAPI setImageWithURL:imageURL
                                                                    ImageView:cell.venuePhoto
                                                                   Completion:^(BOOL success, UIImage *image) {
                                                                       if (success) {
                                                                           personalVenue.image = UIImagePNGRepresentation(image);
                                                                           [UIView animateWithDuration:0.3
                                                                                            animations:^{
                                                                                                weakCell.venuePhoto.alpha = 1;
                                                                                                [self.view layoutIfNeeded];
                                                                                            }];
                                                                           [weakCell setNeedsDisplay];
                                                                       } else {
                                                                           // if completion block is not successful, it will return a placholder image
                                                                           personalVenue.image = UIImagePNGRepresentation(image);
                                                                           [UIView animateWithDuration:0.3
                                                                                            animations:^{
                                                                                                weakCell.venuePhoto.alpha = 1;
                                                                                                [self.view layoutIfNeeded];
                                                                                            }];
                                                                           [weakCell setNeedsDisplay];
                                                                       }
                                                                   }];
                                           }
                                       }];
    }
    
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
