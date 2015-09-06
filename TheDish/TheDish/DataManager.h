//
//  DataManager.h
//  TheDish
//
//  Created by Gan Chau on 9/3/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableArray *venuesList;
@property (nonatomic, strong) NSArray *personalVenuesList;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedDataManager;
- (void)saveContext;


@end
