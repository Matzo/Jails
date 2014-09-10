//
//  JailsViewAdjuster.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailsViewAdjuster : NSObject

+ (void)updateView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;
+ (UIView*)createViewInParent:(id)parent conf:(NSDictionary*)conf;

+ (void)adjustFrameOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;
+ (void)adjustBackgroundOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;
+ (void)adjustSelectorOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;
+ (void)adjustTextOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;
+ (void)adjustHiddenOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;
+ (void)adjustWebOfView:(UIView*)view parent:(id)parent conf:(NSDictionary*)conf;


+(NSURL*)urlFromString:(NSString*)urlString;
+(UIColor*)colorFromHex:(NSString *)hex alpha:(CGFloat)a;

@end
