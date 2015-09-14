//
//  PersonalVenue+CoreDataProperties.h
//  TheDish
//
//  Created by Gan Chau on 9/13/15.
//  Copyright © 2015 GC App. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PersonalVenue.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalVenue (CoreDataProperties)

@property (nonatomic) BOOL disliked;
@property (nonatomic) BOOL liked;
@property (nullable, nonatomic, retain) NSString *venueID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSData *image;

@end

NS_ASSUME_NONNULL_END
