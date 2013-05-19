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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jails-0_2" ofType:@"json"];
    [Jails breakWithConfURL:[NSURL fileURLWithPath:filePath]];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBranchNameOfViewController {
    UIViewController *viewController = [[UIViewController alloc] init];
    NSString *result = [Jails branchNameOfViewController:viewController];
    
    STAssertEqualObjects(result, @"b", @"branch name is 100% b");
}


@end
