//
//  InstagramMediaVC.m
//  instaSquare
//
//  Created by Jaayden on 10/28/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "InstagramMediaVC.h"
#import "MediaCell.h"
#import "ISInstagramClient.h"
#import "ISImage.h"
#import "UIImageView+AFNetworking.h"

@interface InstagramMediaVC ()

@property (nonatomic, strong) NSArray *media;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@end

@implementation InstagramMediaVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Instagram";
    }
    return self;
}

- (id)initWithLatitude:(float)latitude andLongitude:(float)longitude
{
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
        [self getMedia];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UINib *mediaNib = [UINib nibWithNibName:@"MediaCell" bundle:nil];
    [self.tableView registerNib:mediaNib forCellReuseIdentifier:@"MediaCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.media.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MediaCell";
    MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ISImage *mediaObject = self.media[indexPath.row];
    cell.mediaImage.image = nil;
    [cell.mediaImage setImageWithURL: [NSURL URLWithString:mediaObject.url]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 335;
}

- (void)getMedia {
    
    ISInstagramClient * client = [ISInstagramClient sharedClient];
    [client imagesAtLatitude:self.latitude
                andLongitude:self.longitude
                 withSuccess:^(NSArray * images) {
                     NSLog(@"Fetched Images");
                     self.media = images;
                     [self.tableView reloadData];
                 } failure:^(NSError * error) {
                     NSLog(@"problems...");
                 }];
}

@end
