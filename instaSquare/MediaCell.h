//
//  MediaCell.h
//  instaSquare
//
//  Created by Jaayden on 10/28/13.
//  Copyright (c) 2013 Robert & Sairam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mediaImage;

@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UILabel *dateCreated;
@end
