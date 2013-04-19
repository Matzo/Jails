//
//  JailsViewAdjuster.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JailsViewAdjuster : NSObject

+ (void)adjustFrameTo:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustBackgroundColorTo:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustSelectorTo:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustTitleTo:(UIView*)view conf:(NSDictionary*)conf;
+ (void)adjustHiddenTo:(UIView*)view conf:(NSDictionary*)conf;

@end
