//
//  ISStubViewController.m
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISStubViewController.h"
#import "ISInstagramClient.h"

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
