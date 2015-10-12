//
//  PhotosCollectionViewController.m
//  TheDish
//
//  Created by Gan Chau on 9/16/15.
//  Copyright © 2015 GC App. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "FourSquareAPI.h"
#import "Constants.h"

NSString *const COLLECTION_RID = @"VenuePhotoRID";

@interface PhotosCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *venuePhotos;
@property (nonatomic, strong) UICollectionViewFlowLayout *CVFlowLayout;

@end

@implementation PhotosCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchVenuePhotosURL];
}

- (void)fetchVenuePhotosURL
{
    self.venuePhotos = [@[] mutableCopy];
    
    [FourSquareAPI getVenuesPhotosWithVenueID:self.venueID
                                   Completion:^(BOOL success, id responseObject, NSError *error) {
                                       if (success) {
                                           for (NSDictionary *object in responseObject[@"items"]) {
                                               NSString *prefix = object[@"prefix"];
                                               NSString *suffix = object[@"suffix"];
                                               NSString *imageURL = [NSString stringWithFormat:@"%@%@%@", prefix, IMAGE_SIZE_MEDIUM, suffix];
                                               
                                               NSLog(@"%@", imageURL);
                                               [self.venuePhotos addObject:imageURL];
                                           }
                                           
                                           [self.collectionView reloadData];
                                       }
                                   }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.venuePhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_RID
                                                                           forIndexPath:indexPath];

    cell.venueImageView.alpha = 0;
//    cell.layer.borderWidth = 1;
//    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [FourSquareAPI setImageWithURL:self.venuePhotos[indexPath.row]
                         ImageView:cell.venueImageView
                        Completion:^(BOOL success, UIImage *image) {
                            if (success) {
                                // image is set
                                NSLog(@"API CALL SUCCESS");
                                [UIView animateWithDuration:0.3
                                                 animations:^{
                                                     cell.venueImageView.alpha = 1;
                                                     [self.view layoutIfNeeded];
                                                 }];
                                [cell setNeedsDisplay];
                            } else {
                                // placeholder image is set
                                NSLog(@"API CALL UNSUCCESSFUL");
                                [UIView animateWithDuration:0.3
                                                 animations:^{
                                                     cell.venueImageView.alpha = 1;
                                                     [self.view layoutIfNeeded];
                                                 }];
                                [cell setNeedsDisplay];
                            }
                        }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = floorf((collectionView.frame.size.width / 3) - 0.5);
    CGFloat height = width;
    
    return CGSizeMake(width, height);
}

@end
