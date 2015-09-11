//
//  FourSquareAPI.h
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FourSquareAPI : NSObject

+ (void)getVenuesWithLatLong:(NSString *)latLong Completion:(void (^)(BOOL success, id responseObject, NSError *error))completionBlock;

+ (void)getVenuesPhotosWithVenueID:(NSString *)venueID Completion:(void (^)(BOOL success, id responseObject, NSError *error))completionBlock;

+ (void)getImageWithURL:(NSString *)URLString Completion:(void (^)(BOOL success, UIImage *image, NSError *error))completionBlock;

+ (void)setImageWithURL:(NSString *)URLString ImageView:(UIImageView *)imageView Completion:(void (^)(BOOL success, UIImage *image))completionBlock;

@end
