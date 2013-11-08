//
//  CWInstagramCollectionVC.h
//  CrowdWatch
//
//  Created by Jaayden on 11/4/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWInstagramCollectionVC : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

- (id)initWithLatitude:(float) latitude andLongitude:(float)longitude andTitle:(NSString*)title;

@end
