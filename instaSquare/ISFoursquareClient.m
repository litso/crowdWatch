//
//  ISFoursquareClient.m
//  instaSquare
//
//  Created by Sairam Sankaran on 10/23/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISFoursquareClient.h"
#import "AFNetworking.h"

#define FOURSQUARE_BASE_URL [NSURL URLWithString:@"https://api.foursquare.com/v2/"]
#define FOURSQUARE_CLIENT_ID @"WQM5FIRZCEW11TWWPL04YEOPJBZHTTH0QM3GY1CG0EIQ5YX5"
#define FOURSQUARE_CLIENT_SECRET @"3KAA23TODBEP02RUDSDLNRTXDSOIJ5AYTKVHVWMAQM3PXKMB"

@implementation ISFoursquareClient

+ (ISFoursquareClient *)sharedFSClient
{
    static dispatch_once_t once;
    static ISFoursquareClient *sharedFSClient;
    dispatch_once(&once, ^{
        sharedFSClient = [[ISFoursquareClient alloc] init];
    });
    return sharedFSClient;
}

- (id)init {
    self = [super initWithBaseURL:FOURSQUARE_BASE_URL];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

#pragma mark - API Calls

- (void) checkinsAtLatitude:(float)latitude
               andLongitude:(float)longitude
                withSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"ll":[NSString stringWithFormat:@"%0.2f,%0.2f",latitude,longitude],
                                                    @"client_id":FOURSQUARE_CLIENT_ID,
                                                    @"client_secret":FOURSQUARE_CLIENT_SECRET
                                                    }
     ];
    [self getPath:@"venues/trending"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              //NSLog(@"%@",response);
              NSDictionary *responseDictionary = [response objectForKey:@"response"];
              NSArray *venuesArray = [responseDictionary objectForKey:@"venues"];
              success(operation, venuesArray);
          }
          failure:failure
     ];
}

@end
