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
- (void)_aspect_viewDidLoad {
    [self _aspect_viewDidLoad];
    
    @try {
        [Jails branchViewController:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
- (void)_aspect_viewWillLayoutSubviews {
    [self _aspect_viewWillLayoutSubviews];
}
- (void)_aspect_viewDidLayoutSubviews {
    [self _aspect_viewDidLayoutSubviews];
}

- (void)_jails_openLink:(id)sender {
    
    UIApplication *app = [UIApplication sharedApplication];
    Jails *jails = [Jails sharedInstance];
    NSString *key = [sender description];
    NSURL *url = jails.linkDic[key];
    
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}

@end
