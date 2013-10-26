//
//  ISCheckin.h
//  instaSquare
//
//  Created by Sairam Sankaran on 10/23/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISCheckin : NSObject

@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSNumber *venueCheckins;
@property (nonatomic, strong) NSDecimalNumber *venueLatitude;
@property (nonatomic, strong) NSDecimalNumber *venueLongitude;

+ (NSMutableArray *)checkinsWithArray:(NSArray *)array;
    
@end
