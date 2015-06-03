//
//  RecipeWebView.h
//  DishRec
//
//  Created by Sherman Ng on 9/4/14.
//  Copyright (c) 2014 Sherman Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeWebView : UIViewController<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *back_button;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *web_url;


@end
