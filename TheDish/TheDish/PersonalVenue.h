//
//  PersonalVenue.h
//  TheDish
//
//  Created by Gan Chau on 9/13/15.
//  Copyright © 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalVenue : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)fetchVenueLikedOrDislikedWithID:(NSString *)venueID Completion:(void (^)(BOOL liked, BOOL disliked, BOOL result))completionBlock;

@end

NS_ASSUME_NONNULL_END

#import "PersonalVenue+CoreDataProperties.h"
