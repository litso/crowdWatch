//
//  CWInstagramCollectionVC.m
//  CrowdWatch
//
//  Created by Jaayden on 11/4/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "CWInstagramCollectionVC.h"
#import "ISInstagramClient.h"
#import "ISImage.h"
#import "CWMediaCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface CWInstagramCollectionVC ()

@property (nonatomic, strong) NSArray *media;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@end

@implementation CWInstagramCollectionVC

- (id)initWithLatitude:(float)latitude andLongitude:(float)longitude andTitle:(NSString*)title
{
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.title = title;
        [self getMedia];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[CWMediaCollectionViewCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    
    [flow setItemSize:CGSizeMake(245, 245)];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flow];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0 green:121/255.0 blue:190/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.media.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWMediaCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    ISImage *mediaObject = self.media[indexPath.row];
    cell.mediaImage.image = nil;
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    [cell.mediaImage setImageWithURL: [NSURL URLWithString:mediaObject.url] placeholderImage:placeholderImage];
    
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (void)getMedia {
    
    ISInstagramClient * client = [ISInstagramClient sharedClient];
    [client imagesAtLatitude:self.latitude
                andLongitude:self.longitude
                 withSuccess:^(NSArray * images) {
                     NSLog(@"Fetched Images");
                     self.media = images;
                     [self.collectionView reloadData];
                 } failure:^(NSError * error) {
                     NSLog(@"problems...");
                 }];
}

@end
