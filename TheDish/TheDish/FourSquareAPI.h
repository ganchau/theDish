//
//  FourSquareAPI.h
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareAPI : NSObject

+ (void)getVenuesWithLatLong:(NSString *)latLong Completion:(void (^)(BOOL success, id responseObject))completionBlock;

@end
