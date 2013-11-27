//
//  ISFoursquareClient.h
//  instaSquare
//
//  Created by Sairam Sankaran on 10/23/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ISFoursquareClient : AFHTTPClient

+ (ISFoursquareClient *)sharedFSClient;
- (void) checkinsAtLatitude:(float)latitude
               andLongitude:(float)longitude
                withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) topPicksAtLatitude:(float)latitude
               andLongitude:(float)longitude
                withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
