//
//  Venues.m
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "Venue.h"

@implementation Venue

- (instancetype)init
{
    return [self initWithVenue:nil];
}

- (instancetype)initWithVenue:(NSDictionary *)venue
{
    self = [super init];
    
    if (self) {
        _name = venue[@"name"];
        _address = venue[@"location"][@"formattedAddress"];
        _venueID = venue[@"id"];
    }
    
    return self;
}

@end
