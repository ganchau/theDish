//
//  Venues.h
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, strong) NSString *venueID;

- (instancetype)initWithVenue:(NSDictionary *)venue;

@end
