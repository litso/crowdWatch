//
//  ISCategory.m
//  instaSquare
//
//  Created by Robert Manson on 11/3/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISCategory.h"

@interface ISCategory()
@property (nonatomic, strong) NSString* iconPrefix;
@end

@implementation ISCategory

- (ISCategory*) initAsRoot
{
    self = [super init];
    
    if (self)
    {
        self.parent = nil;
        self.idValue = @"rootCategory";
        _name = @"Root Category";
    }
    return self;
}

- (ISCategory*) initWithDictionary: (NSDictionary*) jsonDictionary
{
    self = [super init];
    
    if (self)
    {
        self.idValue = jsonDictionary[@"id"];
        self.name = jsonDictionary[@"name"];
        self.iconPrefix = jsonDictionary[@"icon"][@"prefix"];
    }
    return self;
}

- (void) addChild:(ISCategory *)child
{
    if (!self.children)
    {
        self.children = [[NSMutableArray alloc] init];
    }
    
    [self.children addObject: child];
}

- (NSURL*) smallImageUrl
{
    NSString* url = [NSString stringWithFormat:@"%@32.png", self.iconPrefix];
    return [NSURL URLWithString:url];
}
@end
