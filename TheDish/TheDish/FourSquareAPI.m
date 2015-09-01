//
//  FourSquareAPI.m
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "FourSquareAPI.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "Constants.h"

@implementation FourSquareAPI

+ (void)getVenuesWithLatLong:(NSString *)latLong Completion:(void (^)(BOOL, id, NSError *))completionBlock
{
    NSDictionary *params = @{ @"client_id" : FOURSQUARE_CLIENT_ID,
                              @"client_secret" : FOURSQUARE_CLIENT_SECRET,
                              @"ll" : latLong,
                              @"categoryId" : SEARCH_FOOD_CATEGORY,
                              @"radius" : SEARCH_RADIUS,
                              @"v" : [self formatDate] };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [FOURSQUARE_BASE_URL stringByAppendingString:@"venues/search"];
    
    [manager GET:URLString
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completionBlock(YES, responseObject[@"response"][@"venues"], nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completionBlock(NO, nil, error);
         }];
}

+ (void)getVenuesPhotosWithVenueID:(NSString *)venueID Completion:(void (^)(BOOL, id, NSError *))completionBlock
{
    NSDictionary *params = @{ @"client_id" : FOURSQUARE_CLIENT_ID,
                              @"client_secret" : FOURSQUARE_CLIENT_SECRET,
                              @"v" : [self formatDate] };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [FOURSQUARE_BASE_URL stringByAppendingString:[NSString stringWithFormat:@"venues/%@/photos", venueID]];
    
    [manager GET:URLString
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             completionBlock(YES, responseObject[@"response"][@"photos"], nil);
         } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
             completionBlock(NO, nil, error);
         }];
}

+ (void)setImageView:(UIImageView *)imageView WithURL:(NSString *)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    [imageView setImageWithURL:URL];
}

+ (NSString *)formatDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    NSLog(@"DATE = %@", formattedDateString);
    return formattedDateString;
}

@end
