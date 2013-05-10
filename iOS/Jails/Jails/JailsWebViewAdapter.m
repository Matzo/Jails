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
        NSURL *url = request.URL;
        
        if ([url.scheme isEqualToString:@"jails"]) {
            NSDictionary *params = nil;
            SEL selector = [self selectorFromURL:url params:&params];
            if ([self.delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                switch (params.count) {
                    case 0: {
                        [self.delegate performSelector:selector];
                    } break;
                    case 1: {
                        [self.delegate performSelector:selector
                                            withObject:params[@"param1"]];
                    } break;
                    case 2:
                    default: {
                        [self.delegate performSelector:selector
                                            withObject:params[@"param1"]
                                            withObject:params[@"param2"]];
                    } break;
                }
#pragma clang diagnostic pop
                return false;
            }
        }
        return true;
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
    self.didFinishLoad = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.originalDelegate) {
        [self.originalDelegate webView:webView didFailLoadWithError:error];
    }
}

- (SEL)selectorFromURL:(NSURL*)url params:(NSDictionary**)params {
    NSString *query = url.query;
    NSArray *keyValueList = [query componentsSeparatedByString:@"&"];
    SEL selector = nil;
    NSMutableDictionary *_params = [NSMutableDictionary dictionary];

    for (NSString* keyValue in keyValueList) {
        NSArray *kv = [keyValue componentsSeparatedByString:@"="];
        NSString *key = kv[0];
        NSString *value = kv[1];
        if ([key isEqualToString:@"action"]) {
            selector = NSSelectorFromString(value);
        }
        if ([key isEqualToString:@"param1"] || [key isEqualToString:@"param2"]) {
            [_params setObject:value forKey:key];
        }
    }
    
    *params = [NSDictionary dictionaryWithDictionary:_params];
    
    return selector;
}

@end
