//
//  JailsAdjusterTestViewController.h
//  Jails
//
//  Created by Matsuo Keisuke on 2013/04/20.
//  Copyright (c) 2013年 Matzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JailsAdjusterTestViewController : UIViewController<UIWebViewDelegate>
@property BOOL buttonSelectorChanged;
@property BOOL buttonCreated;

@property (strong, nonatomic) IBOutlet UIView *testView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIWebView *web;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)adjustedButtonClicked:(id)sender;
- (IBAction)createdButtonClicked:(id)sender;
- (IBAction)webAdapterSelector;
- (IBAction)webAdapterSelectorWithParam1:(NSString*)p1;
- (IBAction)webAdapterSelectorWithParam1:(NSString*)p1 param2:(NSString*)p2;

- (void)openURL:(NSString*)url;
@end
