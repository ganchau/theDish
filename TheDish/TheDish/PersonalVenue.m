//
//  PersonalVenue.m
//  TheDish
//
//  Created by Gan Chau on 9/13/15.
//  Copyright © 2015 GC App. All rights reserved.
//

#import "PersonalVenue.h"

@implementation PersonalVenue

// Insert code here to add functionality to your managed object subclass
- (void)fetchVenueLikedOrDislikedWithID:(NSString *)venueID Completion:(void (^)(BOOL, BOOL, BOOL))completionBlock
{
    if ([self.venueID isEqualToString:venueID]) {
        if (self.liked == YES) {
            completionBlock(YES, NO, YES);
        } else if (self.disliked == YES) {
            completionBlock(NO, YES, YES);
        } else {
            completionBlock(NO, NO, nil);
        }
    }
}

@end
