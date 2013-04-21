//
//  Jails.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNSUserDefaultsJailsSeedKey @"kNSUserDefaultsJailsSeedKey"

@interface Jails : NSObject
@property (nonatomic, assign) int branchSeed;
@property (strong) NSURL *jsonURL;
@property (strong) NSTimer *repeatTimer;
@property (strong) NSDictionary *conf;
@property (strong) NSMutableSet *aspectedClassSet;
@property NSTimeInterval interval;

+(id)sharedInstance;
+(void)breakWithConfURL:(NSURL*)url;
+(void)breakWithConfURL:(NSURL*)url loadingInterval:(NSTimeInterval)interval;
+(void)stopRepeatTimer;

+(void)branchViewController:(UIViewController*)viewController;
+(NSString*)branchNameOfViewController:(UIViewController*)viewController;



//- (NSDictionary*)getConfigWithViewController:(UIViewController*)viewController;
//- (void)updateView:(UIView*)view conf:(NSDictionary*)conf;

@end
