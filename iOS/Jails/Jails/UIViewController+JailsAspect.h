//
//  UIViewController+JailsAspect.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JailsAspect)
@property (readonly) NSMutableArray *_jails_webAdapterList;
- (void)_jails_viewDidLoad;
- (void)_jails_dealloc;
@end
