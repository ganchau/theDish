//
//  FourSquareAPI.m
//  TheDish
//
//  Created by Gan Chau on 8/27/15.
//  Copyright (c) 2015 GC App. All rights reserved.
//

#import "FourSquareAPI.h"
#import <AFNetworking.h>
#import "Constants.h"

@implementation FourSquareAPI

+ (void)getVenuesWithCompletion:(void (^)(BOOL, id))completionBlock
{
    NSDictionary *params = @{ @"client_id" : FOURSQUARE_CLIENT_ID,
                              @"client_secret" : FOURSQUARE_CLIENT_SECRET,
                              @"ll" : @"40.7,-74",
                              @"query" : @"pizza",
                              @"v" : @"20150827" };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[FOURSQUARE_BASE_URL stringByAppendingString:@"venues/search"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(YES, responseObject[@"response"][@"venues"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO, nil);
    }];
}

@end
