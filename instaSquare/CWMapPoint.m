//
//  CWMapPoint.m
//  CrowdWatch
//
//  Created by Sairam Sankaran on 10/26/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "CWMapPoint.h"

@interface CWMapPoint ()

@end

@implementation CWMapPoint

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
