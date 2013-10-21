//
//  ISImage.h
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISImage : NSObject

@property (nonatomic, readonly) UIImage* image;
@property (nonatomic, strong) NSString* caption;

+ (NSArray*) imagesFromArray: (NSArray*) dictionaries;

- (instancetype) initWithImageUrl: (NSString*) url;
@end
