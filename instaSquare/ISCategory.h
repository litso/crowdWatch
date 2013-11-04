//
//  ISCategory.h
//  instaSquare
//
//  Created by Robert Manson on 11/3/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISCategory : NSObject

@property(nonatomic, strong) ISCategory* parent;
@property(nonatomic, strong) NSMutableArray* children;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* idValue;

- (ISCategory*) initAsRoot;
- (ISCategory*) initWithDictionary: (NSDictionary*) jsonDictionary;
- (void) addChild: (ISCategory*) child;

- (NSURL*) smallImageUrl;
@end
