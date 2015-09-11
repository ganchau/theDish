//
//  Venues.h
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL liked;
@property (nonatomic) BOOL disliked;

- (instancetype)initWithVenue:(NSDictionary *)venue;

// make a method that reads core data personal venue id for likes and dislikes to display in table view cell

@end
