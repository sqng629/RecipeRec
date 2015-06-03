//
//  MainVC.m
//  DishRec
//
//  Created by Sherman Ng on 10/21/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

//concepts for slide out navigation panel taken from:
//www.raywenderlich.com/32054/how-to-create-a-slide-out-navigation-like-facebook-and-path
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.

#import "MainVC.h"

#import "IngredientsVC.h"
#import <QuartzCore/QuartzCore.h>

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainVC () <centViewControllerDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, assign) BOOL showingLeftPanel;

@property (nonatomic, assign) BOOL showPanel;


@end


IngredientsVC *ingViewController;


@implementation MainVC



- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	_recViewController = [[RecommendationsVC alloc] initWithNibName:@"RecommendationsVC" bundle:nil];
    _recViewController.view.tag = CENTER_TAG;
    _recViewController.delegate = self;
    _recViewController.leftButton.tag = 1;
    
    [self.view addSubview:_recViewController.view];
    [self addChildViewController:_recViewController];
    [_recViewController didMoveToParentViewController:self];
    
    [self setupGestures];
    
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [_recViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_recViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_recViewController.view.layer setShadowOpacity:0.8];
        [_recViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else
    {
        [_recViewController.view.layer setCornerRadius:0.0f];
        [_recViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    
}

- (void)resetMainView
{
    // remove left view and reset variables, if needed
    if (ingViewController != nil)
    {
        [ingViewController.view removeFromSuperview];
        ingViewController = nil;
        
        _recViewController.leftButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}


- (UIView *)getLeftView
{
    if (ingViewController == nil)
    {
        ingViewController = [[IngredientsVC alloc] initWithNibName:@"IngredientsVC" bundle:nil];
        ingViewController.view.tag = LEFT_PANEL_TAG;
        
        [self.view addSubview:ingViewController.view];
        
        [self addChildViewController:ingViewController];
        [ingViewController didMoveToParentViewController:self];
        
        ingViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    [self showCenterViewWithShadow:YES withOffset:-2];
    UIView *view = ingViewController.view;
    
    return view;
}

- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _recViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _recViewController.leftButton.tag = 0;
                         }
                     }];
}



- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _recViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
    
}


-(void) setupGestures
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_recViewController.view addGestureRecognizer:panRecognizer];
}


-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0)
        {
            if (!_showingLeftPanel)
            {
                childView = [self getLeftView];
            }
        }
        else if (velocity.x <= 0)
        {
            
        }
        
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        }
        else
        {
            if (_showingLeftPanel)
            {
                [self movePanelRight];
            }
            else
            {
                [self movePanelToOriginalPosition];
            }
            
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        
        _showPanel = abs([sender view].center.x - _recViewController.view.frame.size.width/2) > _recViewController.view.frame.size.width/2;
        
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
