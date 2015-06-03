//
//  EditRecipe.h
//  DishRec
//
//  Created by Sherman Ng on 9/10/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreViewController.h"

@interface EditRecipe : CoreViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *recipe_table;


@end
