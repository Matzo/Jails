//
//  UIViewController+JailsAspect.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "UIViewController+JailsAspect.h"
#import "Jails.h"

@implementation UIViewController (JailsAspect)
- (void)aspect_viewDidLoad {
    [self aspect_viewDidLoad];
    
    @try {
        [Jails abTestWithViewController:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
- (void)aspect_viewWillLayoutSubviews {
    [self aspect_viewWillLayoutSubviews];
}
- (void)aspect_viewDidLayoutSubviews {
    [self aspect_viewDidLayoutSubviews];
}

@end
