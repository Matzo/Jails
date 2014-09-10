//
//  UIView+JailsAspect.m
//  Jails
//
//  Created by Matsuo Keisuke on 2013/05/19.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "UIView+JailsAspect.h"
#import "Jails.h"

@implementation UIView (JailsAspect)
- (void)_jails_layoutSubviews {
    [self _jails_layoutSubviews];

    @try {
        [Jails branch:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

@end
