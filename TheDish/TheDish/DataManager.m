//
//  DataManager.m
//  TheDish
//
//  Created by Gan Chau on 9/3/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)sharedDataManager
{
    static DataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.venuesList = [@[] mutableCopy];
    }
    
    return self;
}

@end
