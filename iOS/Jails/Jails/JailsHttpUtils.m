//
//  HttpUtils.m
//  Jails
//
//  Created by Matsuo Keisuke on 2013/05/16.
//  Copyright (c) 2013年 Matzo. All rights reserved.
//

#import "JailsHttpUtils.h"

@implementation JailsHttpUtils
+ (NSData*)syncDownloadFromURL:(NSURL*)url cache:(BOOL)useCache validation:(DownloadFileValidation)validation {
    
    NSString *tmpFileName = [[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"__"];
    NSString *tmpPath = [NSString stringWithFormat:@"%@_jails_%@", NSTemporaryDirectory(), tmpFileName];
    NSData *cache = [[NSData alloc] initWithContentsOfFile:tmpPath];
    
    if (useCache && cache) {
        return cache;
    } else {
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:30.0];
        NSURLResponse *res = nil;
        NSData *data = nil;
        NSError *error = nil;
        data = [NSURLConnection sendSynchronousRequest:req
                                     returningResponse:&res
                                                 error:&error];
        if (error) {
            NSLog(@"get image error:%@", error);
            return nil;
        }
        if (useCache && data) {
            if (validation) {
                if (validation(data)) {
                    [data writeToFile:tmpPath atomically:YES];
                    return data;
                } else {
                    return nil;
                }
            } else {
                [data writeToFile:tmpPath atomically:YES];
                return data;
            }
        }
    }
    
    return nil;
}
@end
