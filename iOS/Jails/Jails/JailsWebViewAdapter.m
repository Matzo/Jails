//
//  JailsWebViewAdapter.m
//  Jails
//
//  Created by Matsuo Keisuke on 2013/05/06.
//  Copyright (c) 2013年 Matzo. All rights reserved.
//

#import "JailsWebViewAdapter.h"

@implementation JailsWebViewAdapter

// UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.originalDelegate) {
        return [self.originalDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return false;
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.originalDelegate) {
        [self.originalDelegate webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.originalDelegate) {
        [self.originalDelegate webViewDidFinishLoad:webView];
    }
    NSLog(@"webViewDidFinishLoad:%@", webView);
    self.didFinishLoad = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.originalDelegate) {
        [self.originalDelegate webView:webView didFailLoadWithError:error];
    }
}

@end
