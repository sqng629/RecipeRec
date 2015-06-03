//
//  AddIngredientPopUp.m
//  DishRec
//
//  Created by Sherman Ng on 9/14/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import "AddIngredientPopUp.h"
#import "JSTokenField.h"
#import "JSTokenButton.h"

@interface AddIngredientPopUp () <JSTokenFieldDelegate>

@end

NSMutableArray *added_ingredients;


@implementation AddIngredientPopUp

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
    // Do any additional setup after loading the view from its nib.
    
    added_ingredients = [[NSMutableArray alloc] init];
    
    _ingredients_field = [[JSTokenField alloc] initWithFrame:CGRectMake(10, 100, 150, 31)];
	[[_ingredients_field label] setText:@""];
	[_ingredients_field setDelegate:self];
    _ingredients_field.scrollView = _scrollView;
	[_scrollView addSubview:_ingredients_field];
    
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(0, _ingredients_field.bounds.size.height-1, _ingredients_field.bounds.size.width, 1)];
    [separator1 setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_ingredients_field addSubview:separator1];
    [separator1 setBackgroundColor:[UIColor lightGrayColor]];
    
}

- (void) viewDidLayoutSubviews {
    [_scrollView setContentSize:CGSizeMake(240, 900)];
}

-(void)presentPopUpView:(UIViewController*)parentVC
{
    //self.view.frame = parentVC.view.bounds;
    [parentVC.view addSubview:self.view];
    [parentVC addChildViewController:self];
    [self didMoveToParentViewController:parentVC];
    
    
    CAKeyframeAnimation *frame_animator = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    frame_animator.duration = 0.6;
    frame_animator.delegate = self;
    
    frame_animator.values = @[@0.3, @0.5, @0.75, @1.0];
    frame_animator.keyTimes = @[@0.0, @0.334, @0.666, @1.0];
    
    frame_animator.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.view.layer addAnimation:frame_animator forKey:@"popUpAnimation"];
    
}

-(IBAction)closePopUp:(id)sender
{
    [self dismissPopUpView];
}

-(void)dismissPopUpView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(IBAction)saveIngredients:(id)sender
{
    [self.delegate addIngredientsToDatabase:added_ingredients];
    
    [self dismissPopUpView];
}

//JSToken methods

- (void)tokenField:(JSTokenField *)tokenField didAddToken:(NSString *)title representedObject:(id)obj
{
	NSDictionary *ingredient = [NSDictionary dictionaryWithObject:obj forKey:title];
	[added_ingredients addObject:ingredient];
	NSLog(@"Added token for < %@ : %@ >\n%@", title, obj, added_ingredients);
    
}

- (void)tokenField:(JSTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
	[added_ingredients removeObjectAtIndex:index];
	NSLog(@"Deleted token %d\n%@", index, added_ingredients);
}

- (BOOL)tokenFieldShouldReturn:(JSTokenField *)tokenField {
    NSMutableString *recipient = [NSMutableString string];
	
	NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceCharacterSet] mutableCopy];
	[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
	
    NSString *rawStr = [[tokenField textField] text];
	for (int i = 0; i < [rawStr length]; i++)
	{
		if (![charSet characterIsMember:[rawStr characterAtIndex:i]])
		{
			[recipient appendFormat:@"%@",[NSString stringWithFormat:@"%c", [rawStr characterAtIndex:i]]];
		}
	}
    
    if ([rawStr length])
	{
		[tokenField addTokenWithTitle:rawStr representedObject:recipient];
	}
    
    [tokenField.textField setText:nil];
    
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
