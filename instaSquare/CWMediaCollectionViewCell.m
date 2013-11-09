//
//  CWMediaCollectionViewCell.m
//  CrowdWatch
//
//  Created by Jaayden on 11/6/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "CWMediaCollectionViewCell.h"

@implementation CWMediaCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaImage = [[UIImageView alloc] initWithFrame:self.bounds];
        self.mediaImage.contentMode = UIViewContentModeScaleAspectFill;
        self.mediaImage.clipsToBounds = YES;
        [self.contentView addSubview:self.mediaImage];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
