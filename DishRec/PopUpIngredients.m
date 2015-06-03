//
//  PopUpIngredients.m
//  DishRec
//
//  Created by Sherman Ng on 12/10/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "PopUpIngredients.h"
#import "RecipeWebView.h"

@interface PopUpIngredients ()

@end

@implementation PopUpIngredients

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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 200, 80, 90)];
    [scrollView setContentSize:CGSizeMake(80, 25*[_ingredients count])];
    scrollView.backgroundColor = [UIColor yellowColor];
    [scrollView setScrollEnabled:YES];
    
    
    for (int i = 0; i < [_ingredients count]; i++)
    {
        UILabel *ingLabel = [[UILabel alloc] init];
        ingLabel.frame = CGRectMake(0, i*25, 80, 20);
        
        ingLabel.text = [_ingredients objectAtIndex:i];
        
        [ingLabel setFont:[UIFont fontWithName:@"System" size:12]];
        
        //try to fit longer names of labels onto 1 line
        ingLabel.numberOfLines = 1;
        ingLabel.adjustsFontSizeToFitWidth = YES;
        [scrollView addSubview:ingLabel];
        //[_PopUpView addSubview:ingLabel];
        
    }
    [_PopUpView addSubview:scrollView];
    
    //set up pop up view to display metadata of each recipe
    UIImage *image = [UIImage imageNamed:_image_name];
    
   
    
    [_dish_image setImage:image];
    [_name_label setText:_dish_name];
    _name_label.adjustsFontSizeToFitWidth = YES;
    if (!(_url == nil)) {
        [_url_button setTitle:@"URL" forState:UIControlStateNormal];
    }
    else
    {
        [_url_button setTitle:@"no url" forState:UIControlStateNormal];
    }
    
    _PopUpView.layer.cornerRadius = 13.0f;
    [_PopUpView sizeToFit];
    
    //set up the gesture recognizer
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopUp:)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
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

-(IBAction)goToRecipePage:(id)sender
{
    NSLog(@"URL button pressed");
    RecipeWebView *webView = [[RecipeWebView alloc] init];
    
    webView.web_url = _url;
    
    [self presentViewController:webView animated:YES completion:nil];
    
    [self dismissPopUpView];
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}


@end
