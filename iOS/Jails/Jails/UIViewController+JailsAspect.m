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
@dynamic _jails_webAdapterList;
- (void)_jails_viewDidLoad {
    [self _jails_viewDidLoad];
    
    @try {
        [Jails branch:self];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
- (void)_jails_dealloc {
    [self _jails_dealloc];
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
- (NSMutableArray*)_jails_webAdapterList {
    Jails *jails = [Jails sharedInstance];
    NSMutableArray *adapterList = [jails.webAdapterListDic objectForKey:[self description]];
    
    if (!adapterList) {
        adapterList = [NSMutableArray array];
        [jails.webAdapterListDic setObject:adapterList forKey:[self description]];
    }
    
    return adapterList;
}

@end
