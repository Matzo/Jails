//
//  JailsWebViewAdapter.h
//  Jails
//
//  Created by Matsuo Keisuke on 2013/05/06.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailsWebViewAdapter : NSObject<UIWebViewDelegate>
@property (weak, nonatomic) id<NSObject> delegate;
@property (weak, nonatomic) id<UIWebViewDelegate> originalDelegate;
@property (assign) BOOL didFinishLoad;

// UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (SEL)selectorFromURL:(NSURL*)url params:(NSDictionary**)paramList;
@end
