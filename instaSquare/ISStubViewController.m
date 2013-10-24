//
//  ISStubViewController.m
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISStubViewController.h"
#import "ISInstagramClient.h"
#import "ISFoursquareClient.h"

@interface ISStubViewController ()

@end

@implementation ISStubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //    ISInstagramClient * client = [ISInstagramClient sharedClient];
        [[ISInstagramClient sharedClient] imagesAtLatitude:48.858844
                                              andLongitude:2.294351
                                               withSuccess:^(NSArray * images) {
            NSLog(@"Fetched Images");
        } failure:^(NSError * error) {
            NSLog(@"problems...");
        }];
//        ISFoursquareClient *client = [ISFoursquareClient sharedFSClient];
        [[ISFoursquareClient sharedFSClient] checkinsAtLatitude:37.384242
                                                 andLongitude:-122.031973
                                                  withSuccess:^(AFHTTPRequestOperation *operation, id response) {
                                                      NSLog(@"%@", response);
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                                                      message:@"Fetched Checkins"
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:nil
                                                                                            otherButtonTitles:nil];
                                                      [alert show];
                                                      [alert dismissWithClickedButtonIndex:0 animated:YES];
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      NSLog(@"%@", error);
                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                      message:[error localizedDescription]
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:@"OK"
                                                                                            otherButtonTitles:nil];
                                                      [alert show];
                                                  }
         ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
