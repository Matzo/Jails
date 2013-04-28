//
//  JailsViewAdjuster.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailsViewAdjuster : NSObject

+ (void)updateViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (UIView*)createViewInController:(UIViewController*)viewController conf:(NSDictionary*)conf;


//+ (void)updateView:(UIView*)view conf:(NSDictionary*)conf;

+ (void)adjustFrameInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustBackgroundColorInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustSelectorInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustTextInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustHiddenInViewController:(UIViewController*)viewController view:(UIView*)view conf:(NSDictionary*)conf;

+(NSURL*)urlFromString:(NSString*)urlString;

//+ (void)adjustFrameTo:(UIView*)view conf:(NSDictionary*)conf;
//+ (void)adjustBackgroundColorTo:(UIView*)view conf:(NSDictionary*)conf;
//+ (void)adjustSelectorTo:(UIView*)view conf:(NSDictionary*)conf;
//+ (void)adjustTextTo:(UIView*)view conf:(NSDictionary*)conf;
//+ (void)adjustHiddenTo:(UIView*)view conf:(NSDictionary*)conf;



@end
