//
//  ISFoursquareCategoryManager.h
//  instaSquare
//
//  Created by Robert Manson on 11/3/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISCategory.h"

@interface ISFoursquareCategoryManager : NSObject
+ (ISFoursquareCategoryManager *)sharedManager;
- (ISCategory*) categoryFromId: (NSString*) categoryId;
@end
