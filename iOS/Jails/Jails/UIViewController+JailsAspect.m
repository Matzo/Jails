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
    NSLog(@"before viewDidLoad in %@", NSStringFromClass(self.class));
    [self aspect_viewDidLoad];
    NSLog(@"after viewDidLoad in %@", NSStringFromClass(self.class));
    
    [Jails abTestWithViewController:self];
}
- (void)aspect_viewWillLayoutSubviews {
    NSLog(@"before aspect_viewWillLayoutSubviews in %@", NSStringFromClass(self.class));
    [self aspect_viewWillLayoutSubviews];
    NSLog(@"after aspect_viewWillLayoutSubviews in %@", NSStringFromClass(self.class));
}
- (void)aspect_viewDidLayoutSubviews {
    NSLog(@"before aspect_viewDidLayoutSubviews in %@", NSStringFromClass(self.class));
    [self aspect_viewDidLayoutSubviews];
    NSLog(@"after aspect_viewDidLayoutSubviews in %@", NSStringFromClass(self.class));
}


@end
