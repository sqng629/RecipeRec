//
//  dishesGalleryCell.m
//  DishRec
//
//  Created by Sherman Ng on 11/2/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "dishesGalleryCell.h"


@interface dishesGalleryCell ()

@end


NSTimer *text_timer;

NSString *ingredients_string;




@implementation dishesGalleryCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"dishesGalleryCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        text_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scroll_text) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:text_timer forMode:NSRunLoopCommonModes];
      
    }
    
    return self;
}

-(void)updateCell
{
    
    UIImage *image = [UIImage imageNamed:self.imageName];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    CGPoint frame_origin = self.contentView.frame.origin;
    CGSize frame_size = self.contentView.frame.size;
    
    imageView.frame = CGRectMake(frame_origin.x, frame_origin.y + frame_size.height/4, frame_size.width, frame_size.height*3/4);
    
    [imageView setImage:image];
    
  
    
    _recipe_name.text = _dishName;
    _recipe_name.textColor = [UIColor whiteColor];
    [_recipe_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    
    _recipe_name.adjustsFontSizeToFitWidth = YES;
    
    
    [self.contentView addSubview:imageView];
    
    //set the ingredients string
    
    ingredients_string = @"";
    for (int i = 0; i < [_ingredients count]; i++)
    {
        if (![ingredients_string isEqualToString:@""])
        {
            ingredients_string = [ingredients_string stringByAppendingString:@", "];
        }
        
        ingredients_string = [ingredients_string stringByAppendingString:[_ingredients objectAtIndex:i]];
    }
    
    
    _outer_label_ingredients.clipsToBounds = YES;
    
    UILabel *recipe_ingredients = (UILabel*)[_outer_label_ingredients viewWithTag:50];
    
    
    if (recipe_ingredients == nil)
    {
        
        //calculate expected size of UILabel
        
        CGSize ingredient_label_size = [ingredients_string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:CGSizeMake(1000.0, _outer_label_ingredients.frame.size.height)];
        
        recipe_ingredients = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ingredient_label_size.width, ingredient_label_size.height)];
        
        recipe_ingredients.textColor = [UIColor whiteColor];
        [recipe_ingredients setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        
        recipe_ingredients.tag = 50;
        [_outer_label_ingredients addSubview:recipe_ingredients];
    }
    else
    {
        CGSize ingredient_label_size = [ingredients_string sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:CGSizeMake(1000.0, _outer_label_ingredients.frame.size.height)];
        
        [recipe_ingredients setFrame:CGRectMake(recipe_ingredients.frame.origin.x, recipe_ingredients.frame.origin.y, ingredient_label_size.width, ingredient_label_size.height)];
        
    }
    
    recipe_ingredients.text = ingredients_string;
    
   
}

-(void)scroll_text
{
    UILabel *recipe_ingredients = (UILabel*)[_outer_label_ingredients viewWithTag:50];
    
    
    
    if((recipe_ingredients.frame.origin.x+recipe_ingredients.frame.size.width) > 0)
    {
        
        
        CGPoint end_pos = CGPointMake(recipe_ingredients.frame.origin.x-10, recipe_ingredients.frame.origin.y);
    
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [recipe_ingredients setFrame:CGRectMake(end_pos.x, end_pos.y, recipe_ingredients.frame.size.width, recipe_ingredients.frame.size.height)];
                     } completion:nil];
    
    }
    else
    {
        [recipe_ingredients setFrame:CGRectMake(_outer_label_ingredients.frame.size.width, 0, recipe_ingredients.frame.size.width, _outer_label_ingredients.frame.size.height)];
    }
}

@end
