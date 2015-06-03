//
//  RecommendationsVC.h
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpIngredients.h"
#import "CoreViewController.h"
#import "IngredientModel.h"
#import "IngredientEntity.h"

@protocol centViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;

@end

@interface RecommendationsVC : CoreViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>


@property (nonatomic, assign) id<centViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (assign) int imageIndx;

@end
