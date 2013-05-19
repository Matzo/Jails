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
    self.adapter.delegate = self;
    
    self.delegateAction1Called = NO;
    self.delegateAction2Called = NO;
    self.delegateAction3Called = NO;
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
    
    url = [NSURL URLWithString:@"jails://?action=aaa:bbb:&p1=1&p2=2"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{@"p1":@"1",@"p2":@"2"};
    STAssertEquals(selector, @selector(aaa:bbb:), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");
    

    url = [NSURL URLWithString:@"jails://?action=bbb:&p1=1"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{@"p1":@"1"};
    STAssertEquals(selector, @selector(bbb:), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");

    
    url = [NSURL URLWithString:@"jails://?action=ccc"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{};
    STAssertEquals(selector, @selector(ccc), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");
    
    
    url = [NSURL URLWithString:@"jails://?action=crash:"];
    params = nil;
    selector = [self.adapter selectorFromURL:url params:&params];
    expect = @{};
    STAssertEquals(selector, @selector(crash:), @"selector from URL");
    STAssertEqualObjects(params, expect, @"params from URL");
}

- (void)testWebViewDelegateLinkClicked1 {
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"jails://?action=delegateAction1"]];
    [self.adapter webView:nil shouldStartLoadWithRequest:req navigationType:UIWebViewNavigationTypeLinkClicked];
    STAssertTrue(self.delegateAction1Called, @"delegateAction1Called");
}

- (void)testWebViewDelegateLinkClicked2 {
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"jails://?action=delegateAction2WithParam1:&p1=1&p2=2"]];
    [self.adapter webView:nil shouldStartLoadWithRequest:req navigationType:UIWebViewNavigationTypeLinkClicked];
    STAssertTrue(self.delegateAction2Called, @"delegateAction2Called");
}

- (void)testWebViewDelegateLinkClicked3 {
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"jails://?action=delegateAction3WithParam1:param2:&p1=1&p2=2"]];
    [self.adapter webView:nil shouldStartLoadWithRequest:req navigationType:UIWebViewNavigationTypeLinkClicked];
    STAssertTrue(self.delegateAction3Called, @"delegateAction3Called");
    
    
}
- (void)testWebViewDelegateLinkClicked4 {
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"jails://?action=delegateAction3WithParam1:param2:"]];
    [self.adapter webView:nil shouldStartLoadWithRequest:req navigationType:UIWebViewNavigationTypeLinkClicked];
    STAssertTrue(self.delegateAction3Called, @"delegateAction3Called");

}
- (void)testWebViewDelegateLinkClicked5 {
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"jails://?action=delegateAction3WithDecodedParam1:param2:&p1=https%3A%2F%2Fwww.google.co.jp%2Fsearch%3Fq%3Dtest%2Bis%2Bok%26aq%3Df%26oq%3Dtest%2Bis%2Bok%26aqs%3Dchrome.0.57j0l2j62.5401j0%26sourceid%3Dchrome%26ie%3DUTF-8&p2=bbb"]];
    [self.adapter webView:nil shouldStartLoadWithRequest:req navigationType:UIWebViewNavigationTypeLinkClicked];
    STAssertTrue(self.delegateAction3Called, @"delegateAction3Called");
    
}


- (void)delegateAction1 {
    self.delegateAction1Called = YES;
}

- (void)delegateAction2WithParam1:(NSString*)param1 {
    self.delegateAction2Called = YES;
}

- (void)delegateAction3WithParam1:(NSString*)param1 param2:(NSString*)param2 {
    self.delegateAction3Called = YES;
}
- (void)delegateAction3WithDecodedParam1:(NSString*)param1 param2:(NSString*)param2 {
    NSURL *url = [NSURL URLWithString:param1];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        STFail(@"p1 can not open");
    }
    
    self.delegateAction3Called = YES;
}



@end
