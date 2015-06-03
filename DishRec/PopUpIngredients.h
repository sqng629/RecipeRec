//
//  PopUpIngredients.h
//  DishRec
//
//  Created by Sherman Ng on 12/10/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecommendationsVC.h"



@interface PopUpIngredients : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *ingredients;

@property (nonatomic, strong) NSString *dish_name;

@property (nonatomic, strong) NSString *image_name;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) IBOutlet UIButton *exitButton;

@property (nonatomic, strong) IBOutlet UIImageView *dish_image;

@property (nonatomic, strong) IBOutlet UILabel *name_label;

@property (nonatomic, strong) IBOutlet UIView *PopUpView;


@property (nonatomic, strong) IBOutlet UIButton *url_button;

-(IBAction) goToRecipePage:(id)sender;

-(void)presentPopUpView:(UIViewController*)parentVC;

@end
