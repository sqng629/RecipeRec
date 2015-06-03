//
//  dishesGalleryCell.h
//  DishRec
//
//  Created by Sherman Ng on 11/2/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dishesGalleryCell : UICollectionViewCell

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *dishName;
@property (nonatomic, strong) NSMutableArray *ingredients;

@property IBOutlet UILabel *recipe_name;

@property IBOutlet UIImageView *outer_label_ingredients;



-(void)updateCell;

-(void)scroll_text;
@end
