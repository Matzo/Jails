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

+ (void)adjustFrameInParent:(id)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustBackgroundInParent:(id)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustSelectorInParent:(id)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustTextInParent:(id)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustHiddenInParent:(id)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustWebInParent:(id)viewController view:(UIView*)view conf:(NSDictionary*)conf;

+(NSURL*)urlFromString:(NSString*)urlString;
+(UIColor*)colorFromHex:(NSString *)hex alpha:(CGFloat)a;

@end
