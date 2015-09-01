//
//  VenueTableViewCell.h
//  TheDish
//
//  Created by Gan Chau on 8/31/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *venuePhoto;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@end
