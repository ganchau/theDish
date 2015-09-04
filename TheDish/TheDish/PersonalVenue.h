//
//  PersonalVenue.h
//  TheDish
//
//  Created by Gan Chau on 9/4/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonalVenue : NSManagedObject

@property (nonatomic, retain) NSString * venueID;
@property (nonatomic) BOOL liked;
@property (nonatomic) BOOL disliked;

@end
