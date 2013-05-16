//
//  JailsViewAdjusterTest.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "JailsAdjusterTestViewController.h"

@interface JailsViewAdjusterTest : SenTestCase
@property (assign) BOOL isFinished;
@property (strong, nonatomic) JailsAdjusterTestViewController *testVC;
@end


