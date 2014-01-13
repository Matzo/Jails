//
//  JailsTests.m
//  JailsTests
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsTests.h"


@interface JailsTestsViewController : UIViewController
@property (nonatomic, strong) UIView *testView;
@end

@implementation JailsTestsViewController
- (void)viewDidLoad {
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 50.0, 50.0)];
}
@end



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
    
    STAssertEqualObjects(result, @"b", @"branch name is 100% b");
}

- (void)testBreakWithConfValue {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JailsTests" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *err = nil;
    NSDictionary *confData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&err];
    [Jails breakWithConfData:confData];

    JailsTestsViewController *viewController = [[JailsTestsViewController alloc] init];
    [viewController view];
    CGRect result = viewController.testView.frame;
    
    STAssertEquals(result.origin.x, 20.0f, @"x position");
    STAssertEquals(result.origin.y, 15.0f, @"y position");
    STAssertEquals(result.size.width, 45.0f, @"width");
    STAssertEquals(result.size.height, 44.0f, @"heidht");
}

- (void)testBreakWithConfValueUpdated {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JailsTests" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *err = nil;
    NSMutableDictionary *confData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&err];
    [Jails breakWithConfData:confData];
    
    
    JailsTestsViewController *viewController = [[JailsTestsViewController alloc] init];
    [viewController view];
    CGRect result;
    
    result = viewController.testView.frame;
    
    STAssertEquals(result.origin.x, 20.0f, @"x position");
    STAssertEquals(result.origin.y, 15.0f, @"y position");
    STAssertEquals(result.size.width, 45.0f, @"width");
    STAssertEquals(result.size.height, 44.0f, @"heidht");

    confData[@"JailsTestsViewController"][0][@"properties"][0][@"frame"][0] = @"+15.0";
    confData[@"JailsTestsViewController"][0][@"properties"][0][@"frame"][1] = @"+10.0";
    confData[@"JailsTestsViewController"][0][@"properties"][0][@"frame"][2] = @"-10.0";
    confData[@"JailsTestsViewController"][0][@"properties"][0][@"frame"][3] = @"+10.0";
    
    viewController = [[JailsTestsViewController alloc] init];
    [viewController view];

    [Jails breakWithConfData:confData];
    result = viewController.testView.frame;
    
    STAssertEquals(result.origin.x, 25.0f, @"x position");
    STAssertEquals(result.origin.y, 20.0f, @"y position");
    STAssertEquals(result.size.width, 40.0f, @"width");
    STAssertEquals(result.size.height, 60.0f, @"heidht");
}



@end
