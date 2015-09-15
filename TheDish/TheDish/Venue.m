//
//  Venues.m
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "Venue.h"
#import "DataManager.h"
#import "PersonalVenue.h"

@interface Venue ()

@property (nonatomic, strong) DataManager *dataManager;

@end

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
        _address = [self formatAddress:venue[@"location"][@"formattedAddress"]];
        _venueID = venue[@"id"];
    }
    
    return self;
}

- (NSString *)formatAddress:(NSArray *)address
{
    __block NSString *formattedAddress = @"";
    
    [address enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            // if it's the first object, just add it to the formatted address
            formattedAddress = (NSString *)obj;
        } else if (idx == address.count - 1) {
            // if it's the last object, ignore it and stop the enumeration
            *stop = YES;
        } else {
            // otherwise append the object to the next line in the formatted address
            formattedAddress = [formattedAddress stringByAppendingString:[NSString stringWithFormat:@"\n%@", (NSString *)obj]];
        }
    }];
    
    return formattedAddress;
}

@end
