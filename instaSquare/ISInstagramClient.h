//
//  ISInstagramClient.h
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ISInstagramClient : AFHTTPClient

+ (ISInstagramClient *)sharedClient;
- (void) imagesAtLatitude:(float) latitude andLongitude:(float) longitude withSuccess:(void (^)(NSArray*))success failure:(void (^)(NSError *))failure;

@end
