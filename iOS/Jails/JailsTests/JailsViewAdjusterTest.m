//
//  JailsViewAdjusterTest.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsViewAdjusterTest.h"
#import "JailsViewAdjuster.h"
#import "NSObject+JailsAspect.h"

#import "ViewController.h"
#import "JailsWebViewAdapter.h"
#import <CoreImage/CoreImage.h>

#import "JailsAdjusterTestCell.h"

@implementation JailsViewAdjusterTest

- (void)setUp {
    [super setUp];
    
    self.testVC = [[JailsAdjusterTestViewController alloc] initWithNibName:@"JailsAdjusterTestViewController"
                                                                    bundle:nil];
    [self.testVC loadView];
    
    self.isFinished = YES;
}

- (void)tearDown
{
    // テストが終了するまで待機
    while (!self.isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    [super tearDown];
}

- (void)testAdjustFrame {
    [JailsViewAdjuster adjustFrameInParent:self.testVC view:self.testVC.testView conf:@{
     @"frame":@[@"10",@"20",@"+10",@"+20"],
     }];
    
    
    CGRect expected = CGRectMake(10.0, 20.0, 110.0, 60.0);
    CGRect result = self.testVC.testView.frame;
    STAssertEquals(result, expected, @"adjust frame");
    
    
    [JailsViewAdjuster adjustFrameInParent:self.testVC view:self.testVC.testView conf:@{
     @"frame":@[@"-10",@"-20",@"-10",@"-20"],
     }];
    expected = CGRectMake(0.0, 0.0, 100.0, 40.0);
    result = self.testVC.testView.frame;
    STAssertEquals(result, expected, @"adjust frame");

}

- (void)testAdjustFrameRelative {
    [JailsViewAdjuster adjustFrameInParent:self.testVC view:self.testVC.testView conf:@{
     @"frame":@[@"label+10",@"label+11",@"label+12",@"label+13"],
     }];
    
    CGRect expected = CGRectMake(110.0, 91.0, 112.0, 53.0);
    CGRect result = self.testVC.testView.frame;
    STAssertEquals(result, expected, @"adjust frame relative");
}
- (void)testAdjustFrameRelative2 {
    [JailsViewAdjuster adjustFrameInParent:self.testVC view:self.testVC.testView conf:@{
     @"frame":@[@"label-10",@"label-11",@"label-12",@"label-13"],
     }];
    
    
    CGRect expected = CGRectMake(-10.0, 29.0, 88.0, 27.0);
    CGRect result = self.testVC.testView.frame;
    STAssertEquals(result, expected, @"adjust frame relative");
}

- (void)testAdjustBackgroundColor {
    [JailsViewAdjuster adjustBackgroundInParent:self.testVC view:self.testVC.testView conf:@{
     @"backgroundColor":@[@255.0,@0.0,@0.0,@1.0],
     }];

    UIColor *expected = [UIColor colorWithRed:255.0/255.0
                                        green:0.0/255.0
                                         blue:0.0/255.0
                                        alpha:1.0];
    UIColor *result = self.testVC.testView.backgroundColor;
    STAssertEqualObjects(result, expected, @"adjust background color");
}
- (void)testAdjustBackgroundHexColor {
    [JailsViewAdjuster adjustBackgroundInParent:self.testVC view:self.testVC.testView conf:@{
     @"background":@"#FF0010"
     }];
    
    UIColor *expected = [UIColor colorWithRed:255.0/255.0
                                        green:0.0/255.0
                                         blue:16.0/255.0
                                        alpha:1.0];
    UIColor *result = self.testVC.testView.backgroundColor;
    STAssertEqualObjects(result, expected, @"adjust background color");
}

- (void)testAdjustBackgroundImagePatternColor {
    [JailsViewAdjuster adjustBackgroundInParent:self.testVC view:self.testVC.testView conf:@{
     @"background":@"button1"
     }];
    
    UIColor *result = self.testVC.testView.backgroundColor;
    UIColor *expect = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button1"]];
    STAssertTrue(CGColorEqualToColor(result.CGColor, expect.CGColor), @"local image color");

}


- (void)testAdjustBackgroundImagePatternColorURL {
    [JailsViewAdjuster adjustBackgroundInParent:self.testVC view:self.testVC.label conf:@{
     @"background":@"https://raw.github.com/Matzo/Jails/develop/iOS/Jails/JailsDemo/button1.png"
     }];
    
    UIColor *result = nil;
    while (!result) {
        result = self.testVC.label.backgroundColor;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }

    CGColorSpaceRef colorSpace = [CIColor colorWithCGColor:result.CGColor].colorSpace;
    STAssertTrue(CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelPattern, @"remote image pattern color");
}


- (void)testAdjustSelector {
    [JailsViewAdjuster adjustSelectorInParent:self.testVC view:self.testVC.button conf:@{
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
    [JailsViewAdjuster adjustTextInParent:self.testVC view:self.testVC.label conf:@{
     @"text":@"foo!",
     }];
    STAssertEqualObjects(self.testVC.label.text, @"foo!", @"label is chanded");
    
    
    [JailsViewAdjuster adjustTextInParent:self.testVC view:self.testVC.button conf:@{
     @"text":@"bar!",
     }];
    STAssertEqualObjects([self.testVC.button titleForState:UIControlStateNormal], @"bar!", @"button title was chanded");
    
}
- (void)testAdjustHidden {
    [JailsViewAdjuster adjustHiddenInParent:self.testVC view:self.testVC.testView conf:@{
     @"hidden":@YES,
     }];
    
    
    STAssertTrue(self.testVC.testView.hidden, @"view was hidden");
}


- (void)testCreateNewView {

    UIView *created = (UIView*)[JailsViewAdjuster createViewInParent:self.testVC conf:@{
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
    
    UILabel *created = (UILabel*)[JailsViewAdjuster createViewInParent:self.testVC conf:@{
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
    
    UIWebView *created = (UIWebView*)[JailsViewAdjuster createViewInParent:self.testVC conf:@{
                                  @"frame":@[@"120", @"120", @"60", @"60"],
                                  @"text":@"aaaaawaaaa",
                                  @"class":@"UIWebView",
                                  }];
    
    JailsWebViewAdapter *webAdapter = [[JailsWebViewAdapter alloc] init];
    created.delegate = webAdapter;
    [self.testVC.view addSubview:created];

    STAssertTrue([created isMemberOfClass:[UIWebView class]], @"created class is UIWebView");
    STAssertEquals(created.frame, CGRectMake(120.0, 120.0, 60.0, 60.0), @"frame created");
    

}

- (void)testCreateNewButton {
    
    UIButton *created = (UIButton*)[JailsViewAdjuster createViewInParent:self.testVC conf:@{
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


}


- (void)testAdjustFrameInView {
    static NSString *cellIdentifier = @"testAdjustFrameInView";
    JailsAdjusterTestCell *cell = [[JailsAdjusterTestCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                               reuseIdentifier:cellIdentifier];
    cell.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
    [self.testVC.view addSubview:cell];
//    [cell layoutSubviews];
    
    UILabel *titleLabel = cell.textLabel;
    UILabel *subtitleLabel = cell.detailTextLabel;
    
    [JailsViewAdjuster adjustFrameInParent:cell view:titleLabel conf:@{
     @"frame":@[@"10",@"20",@"100",@"20"]
     }];
    
    
    CGRect expected = CGRectMake(10.0, 20.0, 100.0, 20.0);
    CGRect result = titleLabel.frame;
    STAssertEquals(result, expected, @"adjust frame");
    
    
    [JailsViewAdjuster adjustFrameInParent:cell view:subtitleLabel conf:@{
     @"frame":@[@"textLabel+10",@"textLabel+10",@"textLabel+10",@"textLabel+10"],
     }];

    expected = CGRectMake(120.0, 50.0, 110.0, 30.0);
    result = subtitleLabel.frame;
    STAssertEquals(result, expected, @"adjust frame");

}


@end

