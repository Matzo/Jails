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

#define XCTAssertEqualCGRect(rect1, rect2, ...) \
XCTAssertTrue(rect1.origin.x == rect2.origin.x); \
XCTAssertTrue(rect1.origin.y == rect2.origin.y); \
XCTAssertTrue(rect1.size.width == rect2.size.width); \
XCTAssertTrue(rect1.size.height == rect2.size.height);


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
    [JailsViewAdjuster adjustFrameOfView:self.testVC.testView parent:self.testVC conf:@{
     @"frame":@[@"10",@"20",@"+10",@"+20"],
     }];
    
    
    CGRect expected = CGRectMake(10.0, 20.0, 110.0, 60.0);
    CGRect result = self.testVC.testView.frame;
    XCTAssertTrue(result.origin.x == expected.origin.x);
    
    
    [JailsViewAdjuster adjustFrameOfView:self.testVC.testView parent:self.testVC conf:@{
     @"frame":@[@"-10",@"-20",@"-10",@"-20"],
     }];
    expected = CGRectMake(0.0, 0.0, 100.0, 40.0);
    result = self.testVC.testView.frame;

}

- (void)testAdjustFrameRelative {
    [JailsViewAdjuster adjustFrameOfView:self.testVC.testView parent:self.testVC conf:@{
     @"frame":@[@"label+10",@"label+11",@"label+12",@"label+13"],
     }];
    
    CGRect expected = CGRectMake(110.0, 91.0, 112.0, 53.0);
    CGRect result = self.testVC.testView.frame;
    XCTAssertEqualCGRect(result, expected);
}
- (void)testAdjustFrameRelative2 {
    [JailsViewAdjuster adjustFrameOfView:self.testVC.testView parent:self.testVC conf:@{
     @"frame":@[@"label-10",@"label-11",@"label-12",@"label-13"],
     }];
    
    
    CGRect expected = CGRectMake(-10.0, 29.0, 88.0, 27.0);
    CGRect result = self.testVC.testView.frame;
    XCTAssertEqualCGRect(result, expected);
}

- (void)testAdjustBackgroundColor {
    [JailsViewAdjuster adjustBackgroundOfView:self.testVC.testView parent:self.testVC conf:@{
     @"backgroundColor":@[@255.0,@0.0,@0.0,@1.0],
     }];

    UIColor *result = self.testVC.testView.backgroundColor;
    
    CGFloat r, g, b, a;
    [result getRed:&r green:&g blue:&b alpha:&a];
    XCTAssertTrue(r == 255.0/255.0);
    XCTAssertTrue(g == 0.0/255.0);
    XCTAssertTrue(b == 0.0/255.0);
}
- (void)testAdjustBackgroundHexColor {
    [JailsViewAdjuster adjustBackgroundOfView:self.testVC.testView parent:self.testVC conf:@{
     @"background":@"#FF00FF"
     }];
    
    UIColor *result = self.testVC.testView.backgroundColor;
    
    CGFloat r, g, b, a;
    [result getRed:&r green:&g blue:&b alpha:&a];
    XCTAssertTrue(r == 255.0/255.0);
    XCTAssertTrue(g == 0.0/255.0);
    XCTAssertTrue(b == 255.0/255.0);
}

- (void)testAdjustBackgroundImagePatternColor {
    
    UIColor *before = self.testVC.testView.backgroundColor;
    
    [JailsViewAdjuster adjustBackgroundOfView:self.testVC.testView parent:self.testVC conf:@{
     @"background":@"button1"
     }];
    
    UIColor *after = self.testVC.testView.backgroundColor;

    XCTAssertNotEqual(before, after);

}


- (void)testAdjustBackgroundImagePatternColorURL {
    [JailsViewAdjuster adjustBackgroundOfView:self.testVC.label parent:self.testVC conf:@{
     @"background":@"https://raw.github.com/Matzo/Jails/develop/iOS/Jails/JailsDemo/button1.png"
     }];
    
    UIColor *result = nil;
    while (!result) {
        result = self.testVC.label.backgroundColor;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }

    CGColorSpaceRef colorSpace = [CIColor colorWithCGColor:result.CGColor].colorSpace;
    XCTAssertTrue(CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelPattern, @"remote image pattern color");
}


- (void)testAdjustSelector {
    [JailsViewAdjuster adjustSelectorOfView:self.testVC.button parent:self.testVC conf:@{
     @"action":@"adjustedButtonClicked:",
     }];
    
    [self.testVC.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    XCTAssertTrue(self.testVC.buttonSelectorChanged, @"button selector was changed");
}

- (void)testAdjustURL {
    NSURL *url = [JailsViewAdjuster urlFromString:@"http://www.google.com/"];
    XCTAssertEqualObjects(url, [NSURL URLWithString:@"http://www.google.com/"], @"made URL");

    url = [JailsViewAdjuster urlFromString:@"someSelector;"];
    XCTAssertEqualObjects(url, nil, @"made URL");
    
    url = [JailsViewAdjuster urlFromString:nil];
    XCTAssertEqualObjects(url, nil, @"made URL");
}


- (void)testAdjustText {
    [JailsViewAdjuster adjustTextOfView:self.testVC.label parent:self.testVC conf:@{
     @"text":@"foo!",
     }];
    XCTAssertEqualObjects(self.testVC.label.text, @"foo!", @"label is chanded");
    
    
    [JailsViewAdjuster adjustTextOfView:self.testVC.button parent:self.testVC conf:@{
     @"text":@"bar!",
     }];
    XCTAssertEqualObjects([self.testVC.button titleForState:UIControlStateNormal], @"bar!", @"button title was chanded");
    
}
- (void)testAdjustHidden {
    [JailsViewAdjuster adjustHiddenOfView:self.testVC.testView parent:self.testVC conf:@{
     @"hidden":@YES,
     }];
    
    
    XCTAssertTrue(self.testVC.testView.hidden, @"view was hidden");
}


- (void)testCreateNewView {

    UIView *created = (UIView*)[JailsViewAdjuster createViewInParent:self.testVC conf:@{
                                @"frame":@[@"100", @"100", @"40", @"40"],
                                @"class":@"UIView",
                                @"backgroundColor":@[@200.0,@201.0,@202.0,@1.0],
                                }];
    [self.testVC.view addSubview:created];

    XCTAssertTrue([created isMemberOfClass:[UIView class]], @"created class is UIView");
    XCTAssertEqualCGRect(created.frame, CGRectMake(100.0, 100.0, 40.0, 40.0));

    XCTAssertEqualObjects(created.backgroundColor, [UIColor colorWithRed:200.0/255.0
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
    
    XCTAssertTrue([created isMemberOfClass:[UILabel class]], @"created class is UILabel");
    XCTAssertEqualCGRect(created.frame, CGRectMake(110.0, 110.0, 50.0, 50.0));
    XCTAssertEqualObjects(created.text, @"aaaaawaaaa", @"label text");
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

    XCTAssertTrue([created isMemberOfClass:[UIWebView class]], @"created class is UIWebView");
    XCTAssertEqualCGRect(created.frame, CGRectMake(120.0, 120.0, 60.0, 60.0));

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
    
    XCTAssertEqualObjects([created titleForState:UIControlStateNormal], @"new button", @"button text");
    XCTAssertTrue([created isMemberOfClass:[UIButton class]], @"created class is UIButton");
    XCTAssertTrue(self.testVC.buttonCreated, @"button was created");


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
    
    [JailsViewAdjuster adjustFrameOfView:titleLabel parent:cell conf:@{
     @"frame":@[@"10",@"20",@"100",@"20"]
     }];
    
    
    CGRect expected = CGRectMake(10.0, 20.0, 100.0, 20.0);
    CGRect result = titleLabel.frame;
    XCTAssertEqualCGRect(result, expected);
    
    
    [JailsViewAdjuster adjustFrameOfView:subtitleLabel parent:cell conf:@{
     @"frame":@[@"textLabel+10",@"textLabel+10",@"textLabel+10",@"textLabel+10"],
     }];

    expected = CGRectMake(120.0, 50.0, 110.0, 30.0);
    result = subtitleLabel.frame;
    XCTAssertEqualCGRect(result, expected);

}


@end

