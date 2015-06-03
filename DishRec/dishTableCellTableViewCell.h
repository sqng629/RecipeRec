//
//  dishTableCellTableViewCell.h
//  DishRec
//
//  Created by Sherman Ng on 8/21/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dishTableCellTableViewCell : UITableViewCell


@property IBOutlet UIImageView* recipe_image;
@property IBOutlet UILabel* recipe_name;
@property IBOutlet UILabel* recipe_ingredients;

@end
