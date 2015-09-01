//
//  VenueTableViewCell.m
//  TheDish
//
//  Created by Gan Chau on 8/31/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "VenueTableViewCell.h"

@interface VenueTableViewCell ()

@property (nonatomic) BOOL isLiked;

@end

@implementation VenueTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.isLiked = NO;
    self.likeButton.layer.cornerRadius = 15;
    self.dislikeButton.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonTapped:(id)sender
{
    if (self.isLiked) {
        self.likeButton.backgroundColor = [UIColor clearColor];
        self.isLiked = NO;
    } else {
        self.likeButton.backgroundColor = [UIColor greenColor];
        self.dislikeButton.backgroundColor = [UIColor clearColor];
        self.isLiked = YES;
    }
    
}

- (IBAction)dislikeButtonTapped:(id)sender
{
    if (self.isLiked) {
        self.dislikeButton.backgroundColor = [UIColor redColor];
        self.likeButton.backgroundColor = [UIColor clearColor];
        self.isLiked = NO;
    } else {
        self.dislikeButton.backgroundColor = [UIColor clearColor];
        self.isLiked = YES;
    }
    
}

@end
