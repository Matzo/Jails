//
//  HttpUtils.h
//  Jails
//
//  Created by Matsuo Keisuke on 2013/05/16.
//  Copyright (c) 2013年 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^DownloadFileValidation)(NSData *data);

@interface JailsHttpUtils : NSObject
+ (NSData*)syncDownloadFromURL:(NSURL*)url cache:(BOOL)useCache validation:(DownloadFileValidation)validation;
@end
