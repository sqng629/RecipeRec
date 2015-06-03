//
//  RecipeWebView.m
//  DishRec
//
//  Created by Sherman Ng on 9/4/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import "RecipeWebView.h"

@interface RecipeWebView ()

@end

@implementation RecipeWebView

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
    
    NSURL *url = [NSURL URLWithString:_web_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    _webView.delegate = self;
    
    
    
}


-(IBAction)go_back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
