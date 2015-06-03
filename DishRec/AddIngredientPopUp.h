//
//  AddIngredientPopUp.h
//  DishRec
//
//  Created by Sherman Ng on 9/14/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSToken/JSTokenField.h"

@protocol AddIngredientsDelegate <NSObject>

@required

-(void) addIngredientsToDatabase:(NSMutableArray*) ingredients;

@end

@interface AddIngredientPopUp : UIViewController

@property (nonatomic, assign) id<AddIngredientsDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (nonatomic, weak) IBOutlet UIButton *exitButton;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *popUpView;

@property (strong, nonatomic) JSTokenField *ingredients_field;

-(void)presentPopUpView:(UIViewController*)parentVC;

@end
