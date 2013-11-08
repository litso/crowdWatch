//
//  CWMapPoint.h
//  CrowdWatch
//
//  Created by Sairam Sankaran on 10/26/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ISCheckin.h"

@interface CWMapPoint : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) ISCheckin* checkin;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

@end
