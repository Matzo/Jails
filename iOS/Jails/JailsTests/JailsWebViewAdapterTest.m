//
//  JailsWebViewAdapterTest.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 5/10/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "JailsWebViewAdapterTest.h"

@implementation JailsWebViewAdapterTest
- (void)setUp {
    [super setUp];

    // do something
    
    self.adapter = [[JailsWebViewAdapter alloc] init];
}
- (void)tearDown
{
    // do something
    
    [super tearDown];
}


- (void)testSelectorFromURLAndParams {
    NSURL *url;
    NSDictionary *params;
    SEL selector;
    NSDictionary *expect;
    
    url = [NSURL URLWithString:@"jails://?action=aaa:bbb:&param1=1&param2=2"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{@"param1":@"1",@"param2":@"2"};
    STAssertEquals(selector, @selector(aaa:bbb:), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");
    

    url = [NSURL URLWithString:@"jails://?action=bbb:&param1=1"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{@"param1":@"1"};
    STAssertEquals(selector, @selector(bbb:), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");

    
    url = [NSURL URLWithString:@"jails://?action=ccc"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{};
    STAssertEquals(selector, @selector(ccc), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");
}


@end
