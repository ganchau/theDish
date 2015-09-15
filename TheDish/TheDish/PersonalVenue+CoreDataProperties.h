//
//  PersonalVenue+CoreDataProperties.h
//  TheDish
//
//  Created by Gan Chau on 9/15/15.
//  Copyright © 2015 GC App. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PersonalVenue.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalVenue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nonatomic) BOOL disliked;
@property (nullable, nonatomic, retain) NSData *image;
@property (nonatomic) BOOL liked;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *venueID;

@end

NS_ASSUME_NONNULL_END
