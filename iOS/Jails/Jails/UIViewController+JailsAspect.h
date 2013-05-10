//
//  UIViewController+JailsAspect.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JailsAspect)
@property (readonly) NSMutableArray *_aspect_webAdapterList;
- (void)_aspect_viewDidLoad;
- (void)_aspect_viewWillLayoutSubviews;
- (void)_aspect_viewDidLayoutSubviews;
- (void)_aspect_dealloc;
@end
