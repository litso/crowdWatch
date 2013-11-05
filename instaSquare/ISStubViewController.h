//
//  ISStubViewController.h
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ISStubViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *nearbyMap;
@property (nonatomic, strong) IBOutlet UITextField *locationTextField;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)findLocation;
- (void)foundLocation:(CLLocation *)loc;
- (void)searchLocation;
- (void)findTrendingNearBy:(CLLocation *)loc;

@end
