//
//  ISMapPoint.m
//  instaSquare
//
//  Created by Sairam Sankaran on 10/26/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISMapPoint.h"

@interface ISMapPoint ()

@end

@implementation ISMapPoint

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {

    self = [super init];
    if (self){
        self.coordinate = coordinate;
        self.title = title;
    }
    return self;
}

- (id)init {
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32) title:@"Hometown"];
}

@end
