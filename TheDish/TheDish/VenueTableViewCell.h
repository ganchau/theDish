//
//  VenueTableViewCell.h
//  TheDish
//
//  Created by Gan Chau on 8/31/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VenueTableViewCell;

@protocol VenueTableViewCellDelegate
@optional
- (void)likeButtonWasTapped:(VenueTableViewCell *)cell;
- (void)dislikeButtonWasTapped:(VenueTableViewCell *)cell;
@end

@interface VenueTableViewCell : UITableViewCell

@property (weak, nonatomic) id<VenueTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *venuePhoto;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (strong, nonatomic) NSString *venueID;

@end


