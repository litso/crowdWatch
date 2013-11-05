//
//  ISFoursquareCategoryManager.m
//  instaSquare
//
//  Created by Robert Manson on 11/3/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISFoursquareCategoryManager.h"
#import "ISCategory.h"

@interface ISFoursquareCategoryManager()

@property(nonatomic, strong) ISCategory* root;
@property(nonatomic, strong) NSMutableDictionary* idToCategory;

@end

@implementation ISFoursquareCategoryManager

+ (ISFoursquareCategoryManager *)sharedManager
{
    static dispatch_once_t once;
    static ISFoursquareCategoryManager *sharedManager;
    dispatch_once(&once, ^{
        sharedManager = [[ISFoursquareCategoryManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.idToCategory = [[NSMutableDictionary alloc] init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fs_categories" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSDictionary* response = (NSDictionary*)json[@"response"];
        self.root = [[ISCategory alloc] initAsRoot];

        for (NSDictionary* category in response[@"categories"])
        {
            [self.root addChild: [self makeTreeWithRoot: self.root withJson: category]];
        }
    }
    return self;
}

- (ISCategory*) categoryFromId: (NSString*) categoryId
{
    return self.idToCategory[categoryId];
}

#pragma mark - Private

- (ISCategory*) makeTreeWithRoot: (ISCategory*) root withJson: (NSDictionary*) json
{
    ISCategory* tree = [[ISCategory alloc] initWithDictionary:json];
    tree.parent = root;
    
    self.idToCategory[tree.idValue] = tree;
    for (NSDictionary* category in json[@"categories"])
    {
        [tree addChild: [self makeTreeWithRoot: tree withJson: category]];
    }
    
    return tree;
}

@end
