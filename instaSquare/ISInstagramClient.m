//
//  ISInstagramClient.m
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISInstagramClient.h"
#import "AFNetworking.h"
#import "ISImage.h"

NSString *const kAPIErrorJsonKey = @"ISInstagramErrorJsonKey";
NSString *const kAPIErrorDomain = @"ISInstagramAPIErrorDomain";
NSInteger kInstagramResponseOk = 200;


@implementation ISInstagramClient

+ (ISInstagramClient *)sharedClient
{
    static dispatch_once_t once;
    static ISInstagramClient *sharedClient;
    dispatch_once(&once, ^{
        sharedClient = [[ISInstagramClient alloc] init];
    });
    return sharedClient;
}

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString: @"https://api.instagram.com/v1/"]];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (void) imagesAtLatitude:(float) latitude andLongitude:(float) longitude withSuccess:(void (^)(NSArray*))success failure:(void (^)(NSError *))failure
{
    [self getPath:@"media/search"
       parameters:@{@"client_id": @"ef7f664be3cc40c3b88d096fe7f1a25b",
                    @"lat": [NSString stringWithFormat: @"%f", latitude],
                    @"lng": [NSString stringWithFormat: @"%f", longitude],
                    @"distance": @"20.0"
                    }
          success:^(AFHTTPRequestOperation *operation, id json) {
              
            if ([self responseCodeFromJson: json] == kInstagramResponseOk)
            {
                NSArray *rawImages = [json objectForKey:@"data"];
                NSArray *images = [ISImage imagesFromArray: rawImages];

                success(images);
            }
            else
            {
                if (failure)
                {
                    failure([self errorParsingDictionary:json]);
                }
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

# pragma mark - Private

- (NSInteger) responseCodeFromJson: (NSDictionary*) dictionary
{
    NSInteger code = -1;
    
    if (dictionary[@"meta"])
    {
        dictionary = dictionary[@"meta"];
    }
    
    if ([dictionary[@"code"] isKindOfClass:[NSNumber class]])
    {
        code = [dictionary[@"code"] integerValue];
    }
    return code;
}


- (NSError *)errorParsingDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (dictionary[@"error_message"])
    {
        userInfo[NSLocalizedDescriptionKey] = dictionary[@"error_message"];
    }
    
    NSInteger code = [self responseCodeFromJson: dictionary];

    if (dictionary[@"error_type"])
    {
        userInfo[NSLocalizedFailureReasonErrorKey] = dictionary[@"error_type"];
    }

    if (dictionary)
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:0
                                                             error:nil];
        if (jsonData)
        {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            userInfo[kAPIErrorJsonKey] = jsonString;
        }
    }
    
    NSError *error = [NSError errorWithDomain:kAPIErrorDomain
                                         code:code
                                     userInfo:userInfo];
    return error;
}

@end
