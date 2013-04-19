//
//  Jails.h
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Jails : NSObject
@property (nonatomic, assign) int abSeed;
@property (strong) NSString *json;
@property (strong) NSDictionary *abConf;
@property (strong) NSMutableSet *aspectedClassSet;

+(id)sharedInstance;

+(void)startABTest;

+(void)loadJSON:(NSString*)url;
+(void)abTestWithViewController:(UIViewController*)viewController;
+(NSString*)abNameWithViewController:(UIViewController*)viewController;



//- (NSDictionary*)getConfigWithViewController:(UIViewController*)viewController;
//- (void)updateView:(UIView*)view conf:(NSDictionary*)conf;

@end
