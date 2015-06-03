//
//  CoreViewController.m
//  DishRec
//
//  Created by Sherman Ng on 1/15/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import "CoreViewController.h"

@interface CoreViewController ()

@end

@implementation CoreViewController

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
    
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *background_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_image.png"]];
    [self.view insertSubview:background_image atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
