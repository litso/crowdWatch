//
//  ISCheckin.m
//  instaSquare
//
//  Created by Sairam Sankaran on 10/23/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import "ISCheckin.h"
#import "ISFoursquareCategoryManager.h"

@interface ISCheckin()
@property (nonatomic, strong) NSString* categoryId;
@end

@implementation ISCheckin

+ (NSMutableArray *)checkinsWithArray:(NSArray *)venueArray {
    NSMutableArray *checkins = [[NSMutableArray alloc] initWithCapacity:venueArray.count];
    for (NSDictionary *venue in venueArray) {
        ISCheckin *checkin = [[ISCheckin alloc] init];
        
        NSString *venueId = [venue valueForKey:@"id"];
        NSString *venueName = [venue valueForKey:@"name"];
        NSNumber *venueCheckins = [[venue valueForKey:@"hereNow"] valueForKey:@"count"];
        NSDecimalNumber *venueLatitude = [[venue valueForKey:@"location"] valueForKey:@"lat"];
        NSDecimalNumber *venueLongitude = [[venue valueForKey:@"location"] valueForKey:@"lng"];
        
        checkin.venueId = venueId;
        checkin.venueName = venueName;
        checkin.venueCheckins = venueCheckins;
        checkin.venueLatitude = venueLatitude;
        checkin.venueLongitude = venueLongitude;
        checkin.categoryId = [venue valueForKey:@"categories"][0][@"id"];
        
//        NSLog(@"%@", [checkin description]);
        
        [checkins addObject:checkin];
    }
    return checkins;
}

- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"%@ at %@, %@ currently trending with %@ checkins",
                                   self.venueName,
                                   self.venueLatitude,
                                   self.venueLongitude,
                                   self.venueCheckins];
    return descriptionString;
}

- (NSURL*) smallImageUrl
{
    ISCategory* category = [[ISFoursquareCategoryManager sharedManager] categoryFromId:self.categoryId];    
    return [category smallImageUrl];
}

@end
