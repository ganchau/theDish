//
//  PersonalVenueTableViewCell.h
//  TheDish
//
//  Created by Gan Chau on 9/6/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalVenueTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *venuePhoto;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;

@end
