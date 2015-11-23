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
                              @"limit" : SEARCH_LIMIT,
                              @"categoryId" : SEARCH_FOOD_CATEGORY,
                              @"radius" : SEARCH_RADIUS,
                              @"intent" : @"checkin",
                              @"v" : [self formatDate] };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URLString = [FOURSQUARE_BASE_URL stringByAppendingString:@"venues/search"];
    
    [manager GET:URLString
      parameters:params
         success:^(NSURLSessionTask *task, id responseObject) {
             completionBlock(YES, responseObject[@"response"][@"venues"], nil);
         } failure:^(NSURLSessionTask *task, NSError *error) {
             completionBlock(NO, nil, error);
         }];
}

+ (void)getVenuesPhotosWithVenueID:(NSString *)venueID Completion:(void (^)(BOOL, id, NSError *))completionBlock
{
    NSDictionary *params = @{ @"client_id" : FOURSQUARE_CLIENT_ID,
                              @"client_secret" : FOURSQUARE_CLIENT_SECRET,
                              @"v" : [self formatDate] };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *URLString = [FOURSQUARE_BASE_URL stringByAppendingString:[NSString stringWithFormat:@"venues/%@/photos", venueID]];
    
    [manager GET:URLString
      parameters:params
         success:^(NSURLSessionTask *task, id responseObject) {
             completionBlock(YES, responseObject[@"response"][@"photos"], nil);
         } failure:^(NSURLSessionTask *task, NSError *error) {
             completionBlock(NO, nil, error);
         }];
}

//+ (void)getImageWithURL:(NSString *)URLString Completion:(void (^)(BOOL, UIImage *, NSError *))completionBlock
//{
//    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
//    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:URLRequest];
//    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
//    
//    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        completionBlock(YES, responseObject, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        completionBlock(NO, nil, error);
//    }];
//    
//    [requestOperation start];
//}

+ (void)setImageWithURL:(NSString *)URLString ImageView:(UIImageView *)imageView Completion:(void (^)(BOOL, UIImage *))completionBlock
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
    __weak UIImageView *weakImageView = imageView;
    
    [imageView setImageWithURLRequest:request
                     placeholderImage:placeholder
                              success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
                                  weakImageView.image = image;
                                  completionBlock(YES, image);
                              } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
                                  completionBlock(NO, placeholder);
                              }];
}

+ (NSString *)formatDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    
    return formattedDateString;
}

@end
