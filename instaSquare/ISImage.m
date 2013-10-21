//
//  ISImage.m
//  instaSquare
//
//  Created by Robert Manson on 10/20/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISImage.h"

@interface ISImage()

@property(nonatomic, strong) NSString* url;

@end

@implementation ISImage

- (instancetype) initWithImageUrl: (NSString*) url
{
    self = [super init];
    
    if (self)
    {
        self.url = url;
    }
    
    return self;
}

+ (NSArray*) imagesFromArray: (NSArray*) dictionaries
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries)
    {
        NSMutableDictionary *jsonImage = [dictionary mutableCopy];
        if (jsonImage)
        {
            for (id key in jsonImage.allKeys)
            {
                if ([jsonImage[key] isKindOfClass:[NSNull class]])
                {
                    [jsonImage removeObjectForKey:key];
                }
            }
        }
        NSString* url = jsonImage[@"images"][@"low_resolution"][@"url"];
        
        NSString* caption = nil;
        
        if (jsonImage[@"caption"] && jsonImage[@"caption"][@"text"])
        {
            caption = jsonImage[@"caption"][@"text"];
        }
        
        ISImage *image = [[ISImage alloc] initWithImageUrl: url];
        
        if (caption)
        {
            image.caption = caption;
        }
        [array addObject:image];
    }
    return array;
}

- (UIImage *)image {
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.url]];
    UIImage *myImage = [UIImage imageWithData:data];
    return myImage;
}
@end
