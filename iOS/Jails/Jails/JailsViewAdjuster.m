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


+ (void)updateViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    // adjust frame
    [JailsViewAdjuster adjustFrameInViewController:viewController view:view conf:conf];
    
    // adjust color
    [JailsViewAdjuster adjustBackgroundInViewController:viewController view:view conf:conf];
    
    // adjust selector
    [JailsViewAdjuster adjustSelectorInViewController:viewController view:view conf:conf];

    // adjust webViewControl
    [JailsViewAdjuster adjustWebInViewController:viewController view:view conf:conf];
    
    // adjust text
    [JailsViewAdjuster adjustTextInViewController:viewController view:view conf:conf];

    // adjust visivility
    [JailsViewAdjuster adjustHiddenInViewController:viewController view:view conf:conf];
    
    
    [view setNeedsDisplay];

    NSArray *createSubviews = nil;
    if ((createSubviews = conf[@"createSubviews"])) {
        for (NSDictionary *subviewConf in createSubviews) {
            UIView *newView = [JailsViewAdjuster createViewInController:viewController conf:subviewConf];
            if ([newView isMemberOfClass:[UIWebView class]]) {
                UIWebView *web = (UIWebView*)newView;
                web.scrollView.bounces = NO;
            }
            [view addSubview:newView];
        }
    }
}

+ (UIView*)createViewInController:(UIViewController*)viewController conf:(NSDictionary*)conf {
    UIView *newView = [(UIView*)[NSClassFromString(conf[@"class"]) alloc] initWithFrame:CGRectZero];
    [JailsViewAdjuster updateViewController:viewController view:newView conf:conf];
    return newView;
}


+ (void)adjustFrameInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    NSArray *frameObj = conf[@"frame"];
    if (!frameObj) {
        return;
    }

    view.frame = [JailsViewAdjuster newFrameBase:view.frame conf:frameObj];
}

// adjust color
+ (void)adjustBackgroundInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
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
+ (void)adjustSelectorInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
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
            selector = @selector(_jails_openLink:);
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
        // add new action to viewController
        [button addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
    } else if ([view isKindOfClass:[UIWebView class]]) {
        if (url) {
            UIWebView *web = (UIWebView*)view;
            [web loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
}

// adjust text
+ (void)adjustTextInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
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
+ (void)adjustHiddenInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    if (![[conf allKeys] containsObject:@"hidden"]) {
        return;
    }
    
    view.hidden = [conf[@"hidden"] boolValue];
}
//+ (void)adjustImageInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
//    NSString *imageString = conf[@"image"];
//
//    if (imageString && [view isKindOfClass:[UIButton class]]) {
//        UIButton *button = (UIButton*)view;
//        [self adjustImageInViewController:viewController button:button conf:imageString];
//    }
//}
//
//+ (void)adjustImageInViewController:(UIViewController*)viewController button:(UIButton*)button conf:(NSString*)imageString {
//
//    NSRange match = [imageString rangeOfString:URL_PATTERN
//                                       options:NSRegularExpressionSearch];
//    
//    if (match.location != NSNotFound) {
//        // get image from external
//        NSURL *imageURL = [NSURL URLWithString:imageString];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [button addSubview:loading];
//                [loading startAnimating];
//                loading.center = CGPointMake(button.bounds.size.width * 0.5,
//                                             button.bounds.size.height * 0.5);
//            });
//            
//            NSData *data = [JailsHttpUtils syncDownloadFromURL:imageURL cache:YES validation:^BOOL(NSData *data) {
//                return [UIImage imageWithData:data] ? YES : NO;
//            }];
//            
//            if (data) {
//                UIImage *loadedImage = [[UIImage alloc] initWithData:data];
//                if (loadedImage) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [button setBackgroundImage:loadedImage forState:UIControlStateNormal];
//                    });
//                }
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [loading stopAnimating];
//                [loading removeFromSuperview];
//            });
//        });
//        
//    } else {
//        UIImage *image = [UIImage imageNamed:imageString];
//        if (image) {
//            [button setBackgroundImage:image forState:UIControlStateNormal];
//        }
//    }
//}


+ (void)adjustWebInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    if ([view isKindOfClass:[UIWebView class]]) {
        UIWebView *web = (UIWebView*)view;
        JailsWebViewAdapter *adapter = [[JailsWebViewAdapter alloc] init];
        [viewController._aspect_webAdapterList addObject:adapter];
        
        if (web.delegate) {
            adapter.originalDelegate = web.delegate;
        }
        adapter.delegate = viewController;
        web.delegate = adapter;
    }
}

+ (CGRect)newFrameBase:(CGRect)baseFrame conf:(NSArray*)frameObj {
    if (frameObj && frameObj.count == 4) {
        baseFrame.origin.x = [JailsViewAdjuster newValueBase:baseFrame.origin.x conf:frameObj[0]];
        baseFrame.origin.y = [JailsViewAdjuster newValueBase:baseFrame.origin.y conf:frameObj[1]];
        baseFrame.size.width = [JailsViewAdjuster newValueBase:baseFrame.size.width conf:frameObj[2]];
        baseFrame.size.height = [JailsViewAdjuster newValueBase:baseFrame.size.height conf:frameObj[3]];
    }
    return baseFrame;
}

+ (CGFloat)newValueBase:(CGFloat)baseValue conf:(NSString*)confValue {
    if ([confValue rangeOfString:@"+"].location == 0
        || [confValue rangeOfString:@"-"].location == 0) {
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



//+(void)hundleURL:(NSURL*)url {
//    UIApplication *app = [UIApplication sharedApplication];
//    if ([app canOpenURL:url]) {
//        [app openURL:url];
//    }
//}




@end
