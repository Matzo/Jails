//
//  JailsViewAdjusterTest.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsViewAdjusterTest.h"
#import "JailsViewAdjuster.h"
#import "NSObject+Swizzle.h"

#import "ViewController.h"
#import "JailsWebViewAdapter.h"

@implementation JailsViewAdjusterTest

- (void)setUp {
    [super setUp];
    
    self.testVC = [[JailsAdjusterTestViewController alloc] initWithNibName:@"JailsAdjusterTestViewController"
                                                                    bundle:nil];
    [self.testVC loadView];
    [self.testVC viewDidLoad];
    
//    self._isFinished = YES;
}
//- (void)tearDown
//{
//    // Tear-down code here.
//    
//    [super tearDown];
//}

- (void)tearDown
{
    // テストが終了するまで待機
//    do {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
//    } while (!self._isFinished);
    [super tearDown];
}

- (void)testAdjustFrame {
    [JailsViewAdjuster adjustFrameInViewController:self.testVC view:self.testVC.testView conf:@{
     @"frame":@[@"10",@"20",@"+10",@"+20"],
     }];
    
    
    CGRect expected = CGRectMake(10.0, 20.0, 110.0, 60.0);
    CGRect result = self.testVC.testView.frame;
    STAssertEquals(result, expected, @"adjust frame");
    
    
    [JailsViewAdjuster adjustFrameInViewController:self.testVC view:self.testVC.testView conf:@{
     @"frame":@[@"-10",@"-20",@"-10",@"-20"],
     }];
    expected = CGRectMake(0.0, 0.0, 100.0, 40.0);
    result = self.testVC.testView.frame;
    STAssertEquals(result, expected, @"adjust frame");

}
- (void)testAdjustBackgroundColor {
    [JailsViewAdjuster adjustBackgroundColorInViewController:self.testVC view:self.testVC.testView conf:@{
     @"backgroundColor":@[@255.0,@0.0,@0.0,@1.0],
     }];

    UIColor *expected = [UIColor colorWithRed:255.0/255.0
                                        green:0.0/255.0
                                         blue:0.0/255.0
                                        alpha:1.0];
    UIColor *result = self.testVC.testView.backgroundColor;
    STAssertEqualObjects(result, expected, @"adjust background color");
}
- (void)testAdjustSelector {
    [JailsViewAdjuster adjustSelectorInViewController:self.testVC view:self.testVC.button conf:@{
     @"action":@"adjustedButtonClicked:",
     }];
    
    [self.testVC.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    STAssertTrue(self.testVC.buttonSelectorChanged, @"button selector was changed");
}

- (void)testAdjustURL {
    NSURL *url = [JailsViewAdjuster urlFromString:@"http://www.google.com/"];
    STAssertEqualObjects(url, [NSURL URLWithString:@"http://www.google.com/"], @"made URL");

    url = [JailsViewAdjuster urlFromString:@"someSelector;"];
    STAssertEqualObjects(url, nil, @"made URL");
    
    url = [JailsViewAdjuster urlFromString:nil];
    STAssertEqualObjects(url, nil, @"made URL");
}


- (void)testAdjustText {
    [JailsViewAdjuster adjustTextInViewController:self.testVC view:self.testVC.label conf:@{
     @"text":@"foo!",
     }];
    STAssertEqualObjects(self.testVC.label.text, @"foo!", @"label is chanded");
    
    
    [JailsViewAdjuster adjustTextInViewController:self.testVC view:self.testVC.button conf:@{
     @"text":@"bar!",
     }];
    STAssertEqualObjects([self.testVC.button titleForState:UIControlStateNormal], @"bar!", @"button title was chanded");
    
    
//    [JailsViewAdjuster adjustTextTo:self.testVC.web conf:@{
//     @"text":@"<html>aaaa <b>bbbb</b> cccc</html>",
//     }];
//    [self.testVC.web loadHTMLString:@"<html>aaaa <b>bbbb</b> cccc</html>" baseURL:nil];
//    
//    self.testVC.web.delegate = self;
//    
//    NSString *result = [self.testVC.web stringByEvaluatingJavaScriptFromString:@"(function() { return document.documentElement.innerHTML})();"];
//    STAssertEqualObjects(result, @"aaaa <b>bbbb</b> cccc", @"button title was chanded");
//
}
- (void)testAdjustHidden {
    [JailsViewAdjuster adjustHiddenInViewController:self.testVC view:self.testVC.testView conf:@{
     @"hidden":@YES,
     }];
    
    
    STAssertTrue(self.testVC.testView.hidden, @"view was hidden");
}

- (void)testAdjustImage {
    [JailsViewAdjuster adjustImageInViewController:self.testVC view:self.testVC.button conf:@{
     @"image":@"button1"
     }];
    
    UIImage *result = [self.testVC.button backgroundImageForState:UIControlStateNormal];
    UIImage *expect = [UIImage imageNamed:@"button1"];
    
    STAssertEqualObjects(result, expect, @"button1.png");
}


- (void)testCreateNewView {

    UIView *created = (UIView*)[JailsViewAdjuster createViewInController:self.testVC conf:@{
                                @"frame":@[@"100", @"100", @"40", @"40"],
                                @"class":@"UIView",
                                @"backgroundColor":@[@200.0,@201.0,@202.0,@1.0],
                                }];
    [self.testVC.view addSubview:created];

    STAssertTrue([created isMemberOfClass:[UIView class]], @"created class is UIView");
    STAssertEquals(created.frame, CGRectMake(100.0, 100.0, 40.0, 40.0), @"frame created");
    STAssertEqualObjects(created.backgroundColor, [UIColor colorWithRed:200.0/255.0
                                                                  green:201.0/255.0
                                                                   blue:202.0/255.0
                                                                  alpha:1.0], @"backgoundColor");
}

- (void)testCreateNewLabel {
    
    UILabel *created = (UILabel*)[JailsViewAdjuster createViewInController:self.testVC conf:@{
                                @"frame":@[@"110", @"110", @"50", @"50"],
                                @"text":@"aaaaawaaaa",
                                @"class":@"UILabel",
                                }];
    [self.testVC.view addSubview:created];
    
    STAssertTrue([created isMemberOfClass:[UILabel class]], @"created class is UILabel");
    STAssertEquals(created.frame, CGRectMake(110.0, 110.0, 50.0, 50.0), @"frame created");
    STAssertEqualObjects(created.text, @"aaaaawaaaa", @"label text");
}

- (void)testCreateNewWeb {
    
    UIWebView *created = (UIWebView*)[JailsViewAdjuster createViewInController:self.testVC conf:@{
                                  @"frame":@[@"120", @"120", @"60", @"60"],
                                  @"text":@"aaaaawaaaa",
                                  @"class":@"UIWebView",
                                  }];
    
    JailsWebViewAdapter *webAdapter = [[JailsWebViewAdapter alloc] init];
    created.delegate = webAdapter;
    [self.testVC.view addSubview:created];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [self.testVC.view addSubview:created];
//    });
    
    STAssertTrue([created isMemberOfClass:[UIWebView class]], @"created class is UIWebView");
    STAssertEquals(created.frame, CGRectMake(120.0, 120.0, 60.0, 60.0), @"frame created");
    
    
//    __block BOOL loaded = NO;
//    while (loaded == NO) {
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center addObserverForName:@"UIWebViewNotificationDidFinishLoad"
//                            object:created
//                             queue:[NSOperationQueue mainQueue]
//                        usingBlock:^(NSNotification *note) {
//                            NSLog(@"view did finish load");
//                            loaded = YES;
//                            self._isFinished = YES;
//                            
//                        }];
//        NSLog(@"webview:%@", [created stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
//        sleep(1);
//    }
}

- (void)testCreateNewButton {
    
    UIButton *created = (UIButton*)[JailsViewAdjuster createViewInController:self.testVC conf:@{
                                    @"frame":@[@"200", @"200", @"80", @"40"],
                                    @"class":@"UIButton",
                                    @"text":@"new button",
                                    @"action":@"createdButtonClicked:"
                                    }];
    [self.testVC.view addSubview:created];
    
    [created sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    STAssertEqualObjects([created titleForState:UIControlStateNormal], @"new button", @"button text");
    STAssertTrue([created isMemberOfClass:[UIButton class]], @"created class is UIButton");
    STAssertTrue(self.testVC.buttonCreated, @"button was created");

//    dispatch_sync(dispatch_get_main_queue(), ^{
//        <#code#>
//    });
}



//#pragma mark - UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//}


@end

//
//@implementation JailsAdjusterTestViewController(Mock)
//- (void)_jails_openLink:(id)sender {
//}
//@end
