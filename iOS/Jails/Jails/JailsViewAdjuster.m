//
//  JailsViewAdjuster.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsViewAdjuster.h"

@implementation JailsViewAdjuster


+ (void)updateViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    // adjust frame
    [JailsViewAdjuster adjustFrameInViewController:viewController view:view conf:conf];
    
    // adjust color
    [JailsViewAdjuster adjustBackgroundColorInViewController:viewController view:view conf:conf];
    
    // adjust selector
    [JailsViewAdjuster adjustSelectorInViewController:viewController view:view conf:conf];
    
    // adjust title
    [JailsViewAdjuster adjustTextInViewController:viewController view:view conf:conf];
    
    // adjust visivility
    [JailsViewAdjuster adjustHiddenInViewController:viewController view:view conf:conf];
    
    [view setNeedsDisplay];
    
    NSArray *createSubviews = nil;
    if ((createSubviews = conf[@"createSubviews"])) {
        for (NSDictionary *subviewConf in createSubviews) {
            UIView *newView = [JailsViewAdjuster createViewInController:viewController conf:subviewConf];
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
+ (void)adjustBackgroundColorInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    NSArray *rgba = conf[@"backgroundColor"];
    if (!rgba || rgba.count != 4) {
        return;
    }
    
    UIColor *newColor = [UIColor colorWithRed:[rgba[0] floatValue]/255.0
                                        green:[rgba[1] floatValue]/255.0
                                         blue:[rgba[2] floatValue]/255.0
                                        alpha:[rgba[3] floatValue]];
    view.backgroundColor = newColor;
}

// adjust selector
+ (void)adjustSelectorInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf {
    NSString *selectorString = conf[@"selector"];
    if (!selectorString) {
        return;
    }
    
    SEL selector = NSSelectorFromString(selectorString);
    if (!selector) {
        return;
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)view;
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


@end
