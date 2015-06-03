//
//  RecommendationsVC.m
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "RecommendationsVC.h"
#import "dishesGalleryCell.h"
#import "PopUpIngredients.h"

@interface RecommendationsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dishNames;

@property (nonatomic, weak) IBOutlet UICollectionView *dishesCollectionView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *dishPaths;
@property (nonatomic, strong) NSMutableArray *dishes_from_file;
@property (nonatomic, strong) NSMutableArray *dishes_to_display;

@property (nonatomic, strong) PopUpIngredients *popupCtrl;

//@property (nonatomic) NSNumber *imageIndx;

@end


NSFetchedResultsController *ingredientsResultsController;


@implementation RecommendationsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    
    _searchBar.showsCancelButton = YES;
    
    //load images of pictures to display on front page
    
    _dishNames = [[NSMutableArray alloc] init];
    
    _dishPaths = [[NSMutableArray alloc] init];
    
    
    NSString *databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    databasePath = [databasePath stringByAppendingPathComponent:@"Recipes.plist"];
    
    _dishes_from_file = [NSMutableArray arrayWithContentsOfFile:databasePath];
    
    NSLog(@"%d\n",[_dishes_from_file count]);
    //only load part of all the images in the database
    _dishes_to_display = [[NSMutableArray alloc] init];
    
    //_imageIndx = 5;
    _imageIndx = [_dishes_from_file count]-1;
    for (int i = 0; i <= _imageIndx; i++) {
        [_dishes_to_display addObject:[_dishes_from_file objectAtIndex:i]];
    }
    
    
    
    NSString *imageName;
    NSString *dishName;
    
    NSDictionary *dish_obj;
    for (int i = 0; i < [_dishes_from_file count]; i++)
    {
        dish_obj = [_dishes_from_file objectAtIndex:i];
        imageName = dish_obj[@"Image"];
        dishName = dish_obj[@"Name"];
        
        [_dishNames addObject:dishName];
        
        [_dishPaths addObject:imageName];
        
    }
    
    [self prepareCollectionView];
    
}



- (IBAction)btnMovePanelRight:(id)sender
{
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            
            UIView *spinner_overlay_view = [[UIView alloc] initWithFrame:self.view.frame];
            
            [spinner_overlay_view setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.7]];
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2.0-30, self.view.frame.size.height/2.0-30, 60, 60)];
            
            [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
            
            [spinner_overlay_view addSubview: spinner];
            
            [self.view addSubview: spinner_overlay_view];
            
            [spinner startAnimating];
            
            
            //update recipe table according to the available ingredients
            [self updateRecipes];
            
            //terminate spinner
            NSMutableDictionary* spinner_overlay_object = [[NSMutableDictionary alloc] init];
            
            spinner_overlay_object[@"overlay_view"] = spinner_overlay_view;
            spinner_overlay_object[@"spinner"] = spinner;
            
            [self performSelector:@selector(terminate_spinner:) withObject:spinner_overlay_object afterDelay:3.0];
            
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}


-(void) updateRecipes
{
    NSMutableSet *available_ingredients;
    NSArray *ingredient_objects = [ingredientsResultsController fetchedObjects];
    
    IngredientEntity *ingEnt;
    
    for (int i = 0; i < [ingredient_objects count]; i++)
    {
        ingEnt = [ingredient_objects objectAtIndex:i];
        [available_ingredients addObject:ingEnt.name];
    }

    NSString *databasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    databasePath = [databasePath stringByAppendingPathComponent:@"Recipes.plist"];
    
    NSMutableArray *stored_recipes = [[NSMutableArray alloc] initWithContentsOfFile:databasePath];
    
    NSDictionary *stored_recipe;
    
    for (int i = 0; i < [stored_recipes count]; i++) {
        stored_recipe = [stored_recipes objectAtIndex:i];
        NSMutableArray *ingredients = stored_recipe[@"Ingredients"];
        
        //check whether or not to keep recipe
        BOOL toInclude = false;
        
        
        for (int j = 0; j < [ingredients count]; j++)
        {
            if ([available_ingredients containsObject:[ingredients objectAtIndex:j]]) {
                toInclude = true;
            }
        }
        
        if (toInclude == false) {
            [stored_recipes removeObjectAtIndex:i];
        }
        
    }
    
    
}



-(void) terminate_spinner:(NSDictionary*)spinner_and_overlay
{
    UIActivityIndicatorView *spinner = spinner_and_overlay[@"spinner"];
    UIView *overlay_view = spinner_and_overlay[@"overlay_view"];
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    [overlay_view removeFromSuperview];
    
}

-(void) prepareCollectionView
{
    [self.dishesCollectionView registerClass:[dishesGalleryCell class] forCellWithReuseIdentifier:@"cellID"];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.dishesCollectionView setPagingEnabled:YES];
    [self.dishesCollectionView setCollectionViewLayout:flowLayout];
    
    self.dishesCollectionView.frame = CGRectMake(0, 63, self.dishesCollectionView.frame.size.width, self.dishesCollectionView.frame.size.height);
    
    [self.view addSubview:self.dishesCollectionView];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(230, 280);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dishes_to_display count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    dishesGalleryCell *cell = (dishesGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    NSString *imageName = [_dishPaths objectAtIndex:indexPath.row];
    NSString *dishName = [_dishNames objectAtIndex:indexPath.row];
    [cell setImageName:imageName];
    [cell setDishName:dishName];
    
    NSDictionary *recipe_dict = [_dishes_to_display objectAtIndex:indexPath.row];
    [cell setIngredients:recipe_dict[@"Ingredients"]];
    
    UIButton *dish_button = [[UIButton alloc] init];
    
    dish_button.frame = cell.contentView.bounds;
    
    [dish_button addTarget:self action:@selector(OnClickOfButton:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:dish_button];

    [cell updateCell];
    
    return cell;
}


-(void) OnClickOfButton:(id)sender event:(id)event
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    
    UIButton *button_pressed = (UIButton*)sender;
    //[button_pressed setEnabled:NO];
    UICollectionViewCell *cvCell = (UICollectionViewCell*)[[button_pressed superview] superview];
    
    NSIndexPath *indxpth = [_dishesCollectionView indexPathForCell:cvCell];
    
    NSDictionary *selected_dish = [_dishes_to_display objectAtIndex:indxpth.row];
    
    
    _popupCtrl = [[PopUpIngredients alloc] initWithNibName:@"PopUpIngredients" bundle:nil];
    
    _popupCtrl.dish_name = selected_dish[@"Name"];
    _popupCtrl.ingredients = selected_dish[@"Ingredients"];
    _popupCtrl.image_name = selected_dish[@"Image"];
    _popupCtrl.url = selected_dish[@"URL"];
    
    NSLog(@"pressed image button %d\n", indxpth.row);
    
    [_popupCtrl presentPopUpView:self];
    
    
    
}

/*-(void)backToRecScreen
{

    CGRect mainrect = [[UIScreen mainScreen] bounds];
    CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
    
    [UIView animateWithDuration:0.5 animations:^
    {
        _popupCtrl.view.frame = newRect;
        
    } completion:^(BOOL finished)
    {
        [_popupCtrl.view removeFromSuperview];
        _popupCtrl = nil;

    }];
    
    
}*/


#pragma mark UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self filterSearchedImages:searchBar.text];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
        
}

-(void)filterSearchedImages:(NSString*)search_phrase
{
    NSDictionary* dish_obj;
    NSString* dishName;
    NSMutableArray* selected_dishes;
    
    selected_dishes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_dishes_from_file count]; i++)
    {
        dish_obj = [_dishes_from_file objectAtIndex:i];
        dishName = dish_obj[@"Name"];
        
        //check to see if search string is in name
        NSRange dishNameRange = [dishName rangeOfString:search_phrase options:NSCaseInsensitiveSearch];
        
        //check to see if search string is an ingredient
        NSString *ingredients_string = @"";
        NSMutableArray *array_of_ingredients = dish_obj[@"Ingredients"];
        
        for (int u = 0; u < [array_of_ingredients count]; u++) {
            ingredients_string = [ingredients_string stringByAppendingString:[array_of_ingredients objectAtIndex:u]];
            ingredients_string = [ingredients_string stringByAppendingString:@","];
        }
        
        NSRange ingredientsNameRange = [ingredients_string rangeOfString:search_phrase options: NSCaseInsensitiveSearch];
        
        if (dishNameRange.location != NSNotFound)
        {
            [selected_dishes addObject:dish_obj];
        }
        else if (ingredientsNameRange.location != NSNotFound)
        {
            [selected_dishes addObject:dish_obj];
        }
        
    }
    
    [_dishes_to_display removeAllObjects];
    [_dishNames removeAllObjects];
    [_dishPaths removeAllObjects];
    for (int u = 0; u < [selected_dishes count]; u++)
    {
        NSDictionary* added_dish = [selected_dishes objectAtIndex:u];
        [_dishes_to_display addObject:added_dish];
        [_dishNames addObject:added_dish[@"Name"]];
        [_dishPaths addObject:added_dish[@"Image"]];
    }
    
    [UIView animateWithDuration:0.5 animations:^
    {
        [_dishesCollectionView reloadData];
    
    }];

}


//infinite scrolling implementation
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    NSLog(@"imageindx:%d\n", _imageIndx);
    if (bottomEdge >= scrollView.contentSize.height) {
        //load in some more images
        
        if (_imageIndx + 1 < [_dishes_from_file count])
        {
            _imageIndx++;
            NSLog(@"%d %d\n", _imageIndx, [_dishes_from_file count]);
            [_dishes_to_display addObject:[_dishes_from_file objectAtIndex:_imageIndx]];
            [_dishesCollectionView reloadData];
        }
        
    }
}


-(NSFetchedResultsController*) ingredientsResultsController
{
    if (ingredientsResultsController == nil)
    {
        NSFetchRequest *fReq = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *ctxt = [IngredientModel sharedInstance].managedObjectContext;
        
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"IngredientEntity" inManagedObjectContext:ctxt];
        fReq.entity = ent;
        
        NSSortDescriptor *sDesc = [[NSSortDescriptor alloc] initWithKey:@"ing_amount" ascending:YES];
        
        NSArray *sDescs = [[NSArray alloc] initWithObjects:sDesc, nil];
        fReq.sortDescriptors = sDescs;
        
        ingredientsResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fReq managedObjectContext:ctxt sectionNameKeyPath:nil cacheName:nil];
        
        ingredientsResultsController.delegate = self;
        NSError *error = nil;
        
        if (![self.ingredientsResultsController performFetch:&error])
        {
            NSLog(@"fetched results error: %@ %@", error, [error userInfo]);
            abort();
        }
    }
    
    return ingredientsResultsController;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
