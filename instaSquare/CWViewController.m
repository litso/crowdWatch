//
//  CWViewController.m
//  CrowdWatch
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "CWViewController.h"
#import "ISInstagramClient.h"
#import "ISFoursquareClient.h"
#import "ISCheckin.h"
#import "CWMapPoint.h"
#import "UIImageView+AFNetworking.h"
#import "CWInstagramTableVC.h"
#import "CWInstagramCollectionVC.h"

#define NORTH_SOUTH_SPAN 500
#define EAST_WEST_SPAN 500
#define SCROLL_UPDATE_DISTANCE 100


@interface CWViewController ()

@property (nonatomic, strong) NSArray *media;
@property (nonatomic) CLLocationCoordinate2D lastUpdatedLocation;

- (IBAction)onTap:(id)sender;

- (void) didDragMap:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@implementation CWViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"CrowdWatch";
        
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//        [self.locationManager startUpdatingLocation]; //MKMapView takes care of this
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                 target:self
                                                                                 action:@selector(searchButtonCallback)];
    self.navigationItem.rightBarButtonItem = searchButtonItem;

//    UIView *searchView=[[UIView alloc]initWithFrame:CGRectMake(1, 10, 200, 20)];
//    [searchView setBackgroundColor:[UIColor yellowColor]];
//    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
//    [searchTextField setDelegate:self];
//    [searchView addSubview:searchTextField];
//    
//    self.navigationItem.titleView = searchView;
    
    MKUserTrackingBarButtonItem *currentLocationButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.nearbyMap];
    self.navigationItem.leftBarButtonItem = currentLocationButtonItem; // need to know more about the callback of this button
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:121/255.0 blue:190/255.0 alpha:1.0];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"AvenirNextCondensed-DemiBoldItalic" size:21.0], NSFontAttributeName, nil]];
    
    [self.nearbyMap setDelegate:self]; // set the delegate in viewDidLoad instead of init
    [self.nearbyMap setShowsUserLocation:YES];
    [self.nearbyMap setRotateEnabled:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO]; // check this
    
// RMM: TODO Register a custom nib for the custom call out
//    UINib *venueAnnotationNib = [UINib nibWithNibName:@"VenueAnnotation" bundle:nil];
//    [self.view registerNib:venueAnnotationNib forCellReuseIdentifier:@"VenueAnnotation"];


    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panGestureRecognizer setDelegate:self];
    [self.nearbyMap addGestureRecognizer:panGestureRecognizer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma CLLocation Manager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Location manager updated location");
    int indexOfLatestLocation = [locations count] - 1;
    CLLocation *latestLocation = locations[indexOfLatestLocation];
    NSTimeInterval t = [[latestLocation timestamp] timeIntervalSinceNow];
    if (t < -180) {
        return;
    }
    [self foundLocation:latestLocation];
}

#pragma mark - MKMapView Delegate Methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"Map view updated location");
    CLLocationCoordinate2D location = [userLocation coordinate];
    self.lastUpdatedLocation = location;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, NORTH_SOUTH_SPAN, EAST_WEST_SPAN);
    [self.nearbyMap setRegion:region animated:YES]; // zoom into the location
    
    CLLocation *latestLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [self foundLocation:latestLocation]; // user current location found
    [self.nearbyMap setShowsUserLocation:NO]; // tell the map view to stop trying to display the user's current location
    NSLog(@"nearbyMap show user location is off");
    [self findTrendingNearBy:latestLocation];
    [self topPicksNearBy:latestLocation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
//    NSLog(@"mapView:viewForAnnotation:");
    // try to dequeue an existing pin view first

    
    CWMapPoint* mapPoint = (CWMapPoint*)annotation;
    NSString *ISAnnotationIdentifier =  [NSString stringWithFormat:@"%@",[mapPoint.checkin smallImageUrl]];
    
    if (([annotation isKindOfClass:[CWMapPoint class]]) && mapPoint.checkin)
    {
        MKAnnotationView *reusedAnnotationView =
        (MKAnnotationView *) [self.nearbyMap dequeueReusableAnnotationViewWithIdentifier:ISAnnotationIdentifier];
        if (reusedAnnotationView == nil)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:ISAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [mapPoint.checkin smallImageUrl]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    annotationView.image = image;
                });
            });
            
            annotationView.opaque = NO;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            
            return annotationView;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                reusedAnnotationView.annotation = annotation;
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [mapPoint.checkin smallImageUrl]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    reusedAnnotationView.image = image;
                });
            });
            

        }
        
        return reusedAnnotationView;
    }
    else
    {
        // Show the current location as a purple pin for now
        
        // try to dequeue an existing pin view first
        static NSString *CurrentLocationIdentifier = @"currentLocationIdentifier";
            
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.nearbyMap dequeueReusableAnnotationViewWithIdentifier:CurrentLocationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:CurrentLocationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = NO;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    CWMapPoint* annotation = (CWMapPoint*)[view annotation];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @""
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CWInstagramCollectionVC *vc = [[CWInstagramCollectionVC alloc] initWithNibName:@"InstagramCollectionVC" bundle:nil];
        
        [vc initWithLatitude:annotation.coordinate.latitude andLongitude:annotation.coordinate.longitude andTitle:annotation.title];
        
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        CWInstagramTableVC *vc = [[CWInstagramTableVC alloc] initWithLatitude:annotation.coordinate.latitude andLongitude:annotation.coordinate.longitude andTitle:annotation.title];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    NSLog(@"%d", mode);
    NSLog(@"%hhd", animated);
}

#pragma mark - UITextField Delegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Textfield returned");
    NSLog(@"Text entered = %@", textField.text);
    //[self findLocation];
    [textField resignFirstResponder];
    [self searchLocation];
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Gesture Actions

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    // when user taps on map
    if (self.navigationController.navigationBarHidden) { // if the navigation bar is hidden, make it visible
        //[[self navigationController] setNavigationBarHidden:NO  animated:YES];
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO]; // check this
    } else { // if the navigation bar is visible, make it hidden
        //[[self navigationController] setNavigationBarHidden:YES  animated:YES];
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES]; // check this
    }
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"Drag ended");
        CLLocationCoordinate2D center = [self.nearbyMap centerCoordinate];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
        [self.activityIndicator startAnimating];
        [self findTrendingNearBy:newLocation];
    }
}

#pragma mark - View Controller Methods

- (void)findLocation {
    NSLog(@"Find location");
    // find user location and when found call delegate method locationManager:didUpdateLocations:
    [self.locationManager startUpdatingLocation];
    [self.activityIndicator startAnimating];
    [self.locationTextField setHidden:YES];
    
}

- (void)foundLocation:(CLLocation *)loc {
    NSLog(@"Found location");
    CLLocationCoordinate2D coordinate = [loc coordinate];
    // create annotation for coordinate
    CWMapPoint *mp = [[CWMapPoint alloc] initWithCoordinate:coordinate title:@"Current Location"];

    // Don't add current location as an annotation
    [self.nearbyMap addAnnotation:mp];
}

- (void) searchButtonCallback {
    if (!self.locationTextField.isFirstResponder) { // keyboard is not active. bring it up
        [self.locationTextField becomeFirstResponder];
        return; // do not perform search. wait for user to type something.
    }
    
    if (self.locationTextField.isFirstResponder && (self.locationTextField.text.length > 0)) { // keyboard active and user has entered text. go search for it.
        [self searchLocation];
    }
    
    if (self.locationTextField.isFirstResponder && (self.locationTextField.text.length <= 0)) { // keyboard active but user has not entered text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Specify location to search"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              ];
        [alert show];
    }
}

// To search the location specified by the user in the search box
- (void)searchLocation {
    [self.view endEditing:YES]; // remove keyboard
    
    NSLog(@"Searching for location %@...", self.locationTextField.text);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.locationTextField.text;
    request.region = self.nearbyMap.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search
     startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
         if (response.mapItems.count == 0)
             NSLog(@"No Matches");
         else
             for (MKMapItem *item in response.mapItems) {
                 NSLog(@"name = %@", item.name);
                 NSLog(@"center lat = %f", item.placemark.coordinate.latitude);
                 NSLog(@"center lng = %f", item.placemark.coordinate.longitude);
                 CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:item.placemark.coordinate.latitude
                                                                      longitude:item.placemark.coordinate.longitude];
                 [self.activityIndicator startAnimating];
                 [self findTrendingNearBy:newLocation];
                 
                 MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([newLocation coordinate], NORTH_SOUTH_SPAN, EAST_WEST_SPAN);
                 [self.nearbyMap setRegion:region animated:YES]; // zoom into the location
                 break;
             }
     }
     ];
}

- (void)displayTrendingVenues:(NSArray *)checkins {
   // NSLog(@"%@", checkins);

    
    if ([self.nearbyMap annotations].count > 50) {
//        for (id<MKAnnotation> annotation in self.nearbyMap.annotations) {
            [self.nearbyMap removeAnnotations:self.nearbyMap.annotations];
        NSLog(@"REMOVIG...");
  //      }
    }
    
    for (ISCheckin *checkin in checkins) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:checkin.venueLatitude.doubleValue longitude:checkin.venueLongitude.doubleValue];
        CLLocationCoordinate2D coordinate = [loc coordinate];
        CWMapPoint *mp = [[CWMapPoint alloc] initWithCoordinate:coordinate title:checkin.venueName];
        mp.checkin = checkin;
        [self.nearbyMap addAnnotation:mp];
    }
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
    }
}


- (void)findTrendingNearBy:(CLLocation *)loc {
    NSLog(@"Find trending near by ...");
    CLLocationCoordinate2D coordinate = [loc coordinate];
    [[ISFoursquareClient sharedFSClient] checkinsAtLatitude:coordinate.latitude
                                               andLongitude:coordinate.longitude
                                                withSuccess:^(AFHTTPRequestOperation *operation, id response) {
                                                    NSLog(@"Fetched trending venues nearby");
                                                    NSMutableArray *checkins = [ISCheckin checkinsWithArray:response];
//                                                    NSLog(@"%@", checkins);
                                                    [self displayTrendingVenues:checkins];
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    NSLog(@"%@", error);
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                    message:[error localizedDescription]
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:@"OK"
                                                                                          otherButtonTitles:nil
                                                                          ];
                                                    [alert show];
                                                }
     ];
}

- (void)topPicksNearBy:(CLLocation *)loc {
    NSLog(@"Find top picks near by ...");
    CLLocationCoordinate2D coordinate = [loc coordinate];
    [[ISFoursquareClient sharedFSClient] topPicksAtLatitude:coordinate.latitude
                                               andLongitude:coordinate.longitude
                                                withSuccess:^(AFHTTPRequestOperation *operation, id response) {
                                                    NSLog(@"Fetched top picks nearby");
                                                    NSMutableArray *checkins = [ISCheckin checkinsWithArray:response];
                                                    NSLog(@"TOP PICKS: %@", checkins);
                                                    //[self displayTrendingVenues:checkins];
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    NSLog(@"%@", error);
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                    message:[error localizedDescription]
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:@"OK"
                                                                                          otherButtonTitles:nil
                                                                          ];
                                                    [alert show];
                                                }
     ];
}

@end
















