//
//  ISCheckin.h
//  instaSquare
//
//  Created by Sairam Sankaran on 10/23/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISCheckin : NSObject
{
    CGFloat *locationLat;
    CGFloat *locationLng;
    NSUInteger *locationCheckins;
}

@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *locationName;


@end
