//
//  JailsTests.m
//  JailsTests
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsTests.h"

@implementation JailsTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    [Jails breakWithConfURL:[NSURL fileURLWithPath:filePath]];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    
//    self.viewController = [[JailsAdjusterTestViewController alloc] init];
//    self.viewController.testView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 20.0, 20.0)];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBranchNameOfViewController {
    UIViewController *viewController = [[UIViewController alloc] init];
    NSString *result = [Jails branchNameOfViewController:viewController];
    
    NSLog(@"Jails conf:%@", [Jails sharedInstance].conf);
    STAssertEqualObjects(result, @"b", @"branch name is 100% b");
}

@end
