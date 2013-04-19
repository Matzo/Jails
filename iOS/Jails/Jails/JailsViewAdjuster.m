//
//  JailsViewAdjuster.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsViewAdjuster.h"

@implementation JailsViewAdjuster


+ (void)adjustFrameTo:(UIView*)view conf:(NSDictionary*)conf {
    NSArray *frameObj = conf[@"frame"];
    view.frame = [JailsViewAdjuster newFrameBase:view.frame conf:frameObj];
}

// adjust color
+ (void)adjustBackgroundColorTo:(UIView*)view conf:(NSDictionary*)conf {
}

// adjust selector
+ (void)adjustSelectorTo:(UIView*)view conf:(NSDictionary*)conf {
}

// adjust title
+ (void)adjustTitleTo:(UIView*)view conf:(NSDictionary*)conf {
}

// adjust visivility
+ (void)adjustHiddenTo:(UIView*)view conf:(NSDictionary*)conf {
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

//
//+ (CGRect)newBackgroundColorBase:(UIColor*)baseColor conf:(NSArray*)colorObj {
//}

@end
