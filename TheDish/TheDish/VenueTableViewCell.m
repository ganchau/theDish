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
    self.likeButton.layer.cornerRadius = 15;
    self.dislikeButton.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonTapped:(id)sender
{
    [self.delegate likeButtonWasTapped:self];
}

- (IBAction)dislikeButtonTapped:(id)sender
{
    [self.delegate dislikeButtonWasTapped:self];
}

@end
