//
//  JailsViewAdjuster.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsViewAdjuster.h"
#import "Jails.h"
#import "JailsWebViewAdapter.h"
#import "UIViewController+JailsAspect.h"
#import "JailsHttpUtils.h"

#define URL_PATTERN @"(https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+)"
#define HEX_COLOR_PATTERN @"^#[a-fA-F0-9]{6}$"

@implementation JailsViewAdjuster

+ (void)updateView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {

    if ([parent isKindOfClass:[UIViewController class]] || [parent isKindOfClass:[UIView class]]) {
        // adjust frame
        [JailsViewAdjuster adjustFrameOfView:view parent:parent conf:conf];
        
        // adjust color
        [JailsViewAdjuster adjustBackgroundOfView:view parent:parent conf:conf];
        
        // adjust selector
        [JailsViewAdjuster adjustSelectorOfView:view parent:parent conf:conf];
        
        // adjust webViewControl
        [JailsViewAdjuster adjustWebOfView:view parent:parent conf:conf];
        
        // adjust text
        [JailsViewAdjuster adjustTextOfView:view parent:parent conf:conf];
        
        // adjust visivility
        [JailsViewAdjuster adjustHiddenOfView:view parent:parent conf:conf];
        
        
        [view setNeedsDisplay];
        
        NSArray *createSubviews = nil;
        if ((createSubviews = conf[@"createSubviews"])) {
            for (NSDictionary *subviewConf in createSubviews) {
                UIView *newView = [JailsViewAdjuster createViewInParent:parent conf:subviewConf];
                if ([newView isMemberOfClass:[UIWebView class]]) {
                    UIWebView *web = (UIWebView*)newView;
                    web.scrollView.bounces = NO;
                }
                [view addSubview:newView];
            }
        }
    }
}



+ (UIView*)createViewInParent:(id)parent conf:(NSDictionary*)conf {
    UIView *newView = [(UIView*)[NSClassFromString(conf[@"class"]) alloc] initWithFrame:CGRectZero];
    [JailsViewAdjuster updateView:newView parent:parent conf:conf];
    return newView;
}


+ (void)adjustFrameOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {
    NSArray *frameObj = conf[@"frame"];
    if (!frameObj) {
        return;
    }

    view.frame = [JailsViewAdjuster newFrameFromBaseFrame:view.frame parent:parent conf:frameObj];
}

// adjust color
+ (void)adjustBackgroundOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {
    NSArray *rgba = conf[@"backgroundColor"];

    if (!rgba || rgba.count != 4) {
        
        NSString *background = conf[@"background"];
        if (!background) {
            return;
        } else {

            if ([background rangeOfString:HEX_COLOR_PATTERN
                                  options:NSRegularExpressionSearch].location != NSNotFound) {
                NSString *hexString = [background substringFromIndex:1];
                view.backgroundColor = [self colorFromHex:hexString alpha:1.0];
            } else {
            
                NSURL *url = [self urlFromString:background];
                if (url) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSData *data = [JailsHttpUtils syncDownloadFromURL:url cache:YES validation:^BOOL(NSData *d) {
                            return [UIImage imageWithData:d] ? YES : NO;
                        }];

                        if (data) {
                            UIImage *image = [UIImage imageWithData:data];
                            if (image) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if ([view isKindOfClass:[UIButton class]]) {
                                        UIButton *button = (UIButton*)view;
                                        [button setBackgroundImage:image forState:UIControlStateNormal];
                                    } else {
                                        view.backgroundColor = [UIColor colorWithPatternImage:image];
                                    }
                                });
                            }
                        }
                    });
                    return;
                } else {
                    UIImage *image = [UIImage imageNamed:background];
                    if (image) {
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton *button = (UIButton*)view;
                            [button setBackgroundImage:image forState:UIControlStateNormal];
                        } else {
                            view.backgroundColor = [UIColor colorWithPatternImage:image];
                        }
                    }
                }
            }
        }
    } else {
        view.backgroundColor = [UIColor colorWithRed:[rgba[0] floatValue]/255.0
                                               green:[rgba[1] floatValue]/255.0
                                                blue:[rgba[2] floatValue]/255.0
                                               alpha:[rgba[3] floatValue]];
    }
}

// adjust selector
+ (void)adjustSelectorOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {
    NSString *selectorString = conf[@"action"];
    if (!selectorString) {
        return;
    }
    
    Jails *jails = [Jails sharedInstance];
    NSURL *url = [self urlFromString:selectorString];
    SEL selector;
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)view;

        if (url) {
            NSString *key = [button description];
            jails.linkDic[key] = url;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            selector = NSSelectorFromString(@"_jails_openLink:");
#pragma clang diagnostic pop
        } else {
            selector = NSSelectorFromString(selectorString);
        }

        if (!selector) {
            return;
        }

        NSSet *targets = [button allTargets];

        // remove all action
        for (id target in targets) {
            NSArray *actions = [button actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            
            for (NSString *currentSelectorString in actions) {
                [button removeTarget:target
                              action:NSSelectorFromString(currentSelectorString)
                    forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        // add new action to parent(UIViewController or UIView)
        [button addTarget:parent action:selector forControlEvents:UIControlEventTouchUpInside];
    } else if ([view isKindOfClass:[UIWebView class]]) {
        if (url) {
            UIWebView *web = (UIWebView*)view;
            [web loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
}

// adjust text
+ (void)adjustTextOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {
    NSString *text = conf[@"text"];
    if (!text) {
        return;
    }
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel*)view;
        label.text = text;
        
    } else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)view;
        [button setTitle:text forState:UIControlStateNormal];
    } else if ([view isKindOfClass:[UIWebView class]]) {
        UIWebView *web = (UIWebView*)view;
        [web loadHTMLString:text baseURL:nil];
    }
}

// adjust visivility
+ (void)adjustHiddenOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {
    if (![[conf allKeys] containsObject:@"hidden"]) {
        return;
    }
    
    view.hidden = [conf[@"hidden"] boolValue];
}

+ (void)adjustWebOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf {
    if ([view isKindOfClass:[UIWebView class]] && [parent isKindOfClass:[UIViewController class]]) {
        UIWebView *web = (UIWebView*)view;
        UIViewController *viewController = (UIViewController*)parent;
        JailsWebViewAdapter *adapter = [[JailsWebViewAdapter alloc] init];
        [viewController._jails_webAdapterList addObject:adapter];
        if (web.delegate) {
            adapter.originalDelegate = web.delegate;
        }
        adapter.delegate = viewController;
        web.delegate = adapter;
    }
}

+ (CGRect)newFrameFromBaseFrame:(CGRect)baseFrame parent:(id)parent conf:(NSArray*)frameObj {
    if (frameObj && frameObj.count == 4) {

        for (int i = 0; i < 4; i++) {
            UIView *relativeView = nil;
            NSString *confValue = frameObj[i];
            
            NSString *operator = nil;
            NSRange operatorRange = [confValue rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-"]];
            if (operatorRange.location != NSNotFound) {
                NSString *property = [confValue substringToIndex:operatorRange.location];
                operator = [confValue substringWithRange:operatorRange];
                confValue = [confValue substringFromIndex:operatorRange.location];
                
                SEL propName = NSSelectorFromString(property);
                if ([parent respondsToSelector:propName]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    relativeView = [parent performSelector:propName];
#pragma clang diagnostic pop
                }
            }

            CGFloat baseValue = 0.0;
            CGFloat *target;

            switch (i) {
                case 0:
                    baseValue = relativeView ?
                        [operator isEqualToString:@"+"] ? CGRectGetMaxX(relativeView.frame)
                                                        : CGRectGetMinX(relativeView.frame)
                        : baseFrame.origin.x;
                    target = &baseFrame.origin.x;
                    break;

                case 1:
                    baseValue = relativeView ?
                        [operator isEqualToString:@"+"] ? CGRectGetMaxY(relativeView.frame)
                                                        : CGRectGetMinY(relativeView.frame)
                        : baseFrame.origin.y;
                    target = &baseFrame.origin.y;
                    break;

                case 2:
                    baseValue = relativeView? CGRectGetWidth(relativeView.frame) : baseFrame.size.width;
                    target = &baseFrame.size.width;
                    break;
                    
                case 3:
                    baseValue = relativeView? CGRectGetHeight(relativeView.frame) : baseFrame.size.height;
                    target = &baseFrame.size.height;
                    break;
            }
            
            *target = [JailsViewAdjuster newValueBase:baseValue conf:confValue];

        }
    }
    return baseFrame;
}

+ (CGFloat)newValueBase:(CGFloat)baseValue conf:(NSString*)confValue {
    NSRange operatorRange = [confValue rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-"]];
    if (operatorRange.location != NSNotFound) {
        return baseValue + [confValue floatValue];
    } else {
        return [confValue floatValue];
    }
}

// hundle URL
+(NSURL*)urlFromString:(NSString*)urlString {
    NSRange match = [urlString rangeOfString:URL_PATTERN
                                     options:NSRegularExpressionSearch];

    if (match.location != NSNotFound) {
//        NSLog(@"%@", [urlString substringWithRange:match]);
        return [NSURL URLWithString:urlString];
    } else {
        return nil;
    }
}

+(UIColor*)colorFromHex:(NSString *)hex alpha:(CGFloat)a {
	NSScanner *colorScanner = [NSScanner scannerWithString:hex];
	unsigned int color;
	[colorScanner scanHexInt:&color];
	CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
	CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
	CGFloat b =  (color & 0x0000FF) /255.0f;
	//NSLog(@"HEX to RGB >> r:%f g:%f b:%f a:%f\n",r,g,b,a);
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
