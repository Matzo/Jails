//
//  JailsWebViewAdapterTest.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 5/10/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JailsWebViewAdapter.h"

@interface JailsWebViewAdapterTest : XCTestCase
@property (nonatomic, strong) JailsWebViewAdapter *adapter;
@property (assign) BOOL delegateAction1Called;
@property (assign) BOOL delegateAction2Called;
@property (assign) BOOL delegateAction3Called;

@end
