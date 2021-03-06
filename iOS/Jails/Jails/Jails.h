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
@property (nonatomic, assign) NSInteger branchSeed;
@property (strong) NSURL *jsonURL;
@property (strong) NSTimer *repeatTimer;
@property (strong) NSDictionary *conf;
@property (strong) NSMutableSet *aspectedClassSet;
@property (strong) NSMutableDictionary *webAdapterListDic;
@property NSTimeInterval interval;
@property (strong) NSMutableDictionary *linkDic;

+(Jails*)sharedInstance;
+(void)breakWithConfURL:(NSURL*)url;
+(void)breakWithConfURL:(NSURL*)url loadingInterval:(NSTimeInterval)interval;
+(void)stopRepeatLoading;

+(void)breakWithConfData:(NSDictionary*)config;

+(void)branch:(id)parent;
+(NSString*)branchNameOfViewController:(UIViewController*)viewController;


//- (NSDictionary*)getConfigWithViewController:(UIViewController*)viewController;
//- (void)updateView:(UIView*)view conf:(NSDictionary*)conf;

@end
