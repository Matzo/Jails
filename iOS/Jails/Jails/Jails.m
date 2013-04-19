//
//  Jails.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "Jails.h"
#import "NSObject+Swizzle.h"
#import "JailsViewAdjuster.h"

@implementation Jails

- (id)init {
    self = [super init];
    if (self) {
        srand((unsigned) time(NULL));
        self.abSeed = rand() % 100;

        self.aspectedClassSet = [NSMutableSet set];
    }
    return self;
}

+(id)sharedInstance {
    static Jails* instance = nil;
    if (instance == nil) {
        instance = [[Jails alloc] init];
    }
    
    return instance;
}

#pragma mark - Prepare AB test
+(void)startABTest {
    NSURL *abConfURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test"
                                                                                          ofType:@"json"]];
    [Jails loadJSONFromURL:abConfURL];
    
    // after load
    [Jails aspectAB];
}

+(void)loadJSON:(NSString*)url {
    [Jails loadJSONFromURL:[NSURL URLWithString:url]];
}

+(void)loadJSONFromURL:(NSURL*)url {
    Jails *jails = [Jails sharedInstance];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:5.0];
    
    //    [NSURLConnection sendAsynchronousRequest:req
    //                                       queue:[NSOperationQueue mainQueue]
    //                           completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
    //                               NSLog(@"data:%@",data);
    //                               NSLog(@"error:%@",error);
    //                               jails.json = [[NSString alloc] initWithData:data
    //                                                                  encoding:NSUTF8StringEncoding];
    //                               NSLog(@"jails.json:%@", jails.json);
    //                           }];
    
    NSURLResponse *res = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:req
                                         returningResponse:&res
                                                     error:&error];
    jails.json = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
    if (data) {
        jails.abConf = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
    }
}

+(void)aspectAB {
    Jails *j = [Jails sharedInstance];
    NSDictionary *abTargetDic = [j.abConf objectForKey:@"ab"];
    for (NSString *className in [abTargetDic keyEnumerator]) {
        
        if ([j.aspectedClassSet containsObject:className]) {
            continue;
        }
        NSLog(@"aspect to class:%@", className);
        //        NSDictionary *target = [abTargetDic objectForKey:key];
        
        [NSClassFromString(className) swizzleMethod:@selector(viewDidLoad)
                                         withMethod:@selector(aspect_viewDidLoad)];
        
        [NSClassFromString(className) swizzleMethod:@selector(viewWillLayoutSubviews)
                                         withMethod:@selector(aspect_viewWillLayoutSubviews)];
        
        [NSClassFromString(className) swizzleMethod:@selector(viewDidLayoutSubviews)
                                         withMethod:@selector(aspect_viewDidLayoutSubviews)];
        
        [j.aspectedClassSet addObject:className];
    }
}



#pragma mark - Execute AB
+(void)abTestWithViewController:(UIViewController*)viewController {
    Jails *jails = [Jails sharedInstance];
    NSDictionary *conf = [jails getConfigWithViewController:viewController];
    if (conf) {
        NSLog(@"conf:%@", conf);
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSDictionary *property in conf[@"properties"]) {
            SEL propName = NSSelectorFromString(property[@"name"]);
            if ([viewController respondsToSelector:propName]) {
                UIView *view = [viewController performSelector:propName];
                NSLog(@"view:%@", view);
                [jails updateView:view conf:property];
            }
        }
    }
}

+(NSString*)abNameWithViewController:(UIViewController*)viewController {
    Jails *jails = [Jails sharedInstance];
    NSDictionary *conf = [jails getConfigWithViewController:viewController];
    if (conf) {
        return conf[@"name"];
    } else {
        return nil;
    }
}

#pragma mark - Private Methods
- (NSDictionary*)getConfigWithViewController:(UIViewController*)viewController {
    NSString *className = NSStringFromClass([viewController class]);
    NSDictionary *conf = nil;
    if (self.abConf && (conf = self.abConf[@"ab"][className])) {
        NSArray *abList = conf[@"assign"];
        int range = 0;
        int target = 0;
        for (int i = 0; i < abList.count; i++) {
            NSNumber *percent = abList[i];
            range += [percent intValue];
            if (self.abSeed < range) {
                target = i;
                break;
            }
        }
        return conf[@"view"][target];
    } else {
        return nil;
    }
}

- (void)updateView:(UIView*)view conf:(NSDictionary*)conf {
    // adjust frame
    [JailsViewAdjuster adjustFrameTo:view conf:conf];
    
    // adjust color
    [JailsViewAdjuster adjustBackgroundColorTo:view conf:conf];

    // adjust selector
    [JailsViewAdjuster adjustSelectorTo:view conf:conf];

    // adjust title
    [JailsViewAdjuster adjustTitleTo:view conf:conf];

    // adjust visivility
    [JailsViewAdjuster adjustHiddenTo:view conf:conf];

    
    NSArray *createSubviews = nil;
    if ((createSubviews = conf[@"createSubviews"])) {
        for (NSDictionary *subviewConf in createSubviews) {
            UIView *newView = [self createView:view conf:subviewConf];
            [view addSubview:newView];
        }
    }
}

- (UIView*)createView:(UIView*)view conf:(NSDictionary*)conf {
    UIView *newView = [(UIView*)[NSClassFromString(conf[@"class"]) alloc] initWithFrame:CGRectZero];
    [self updateView:newView conf:conf];
    
    return newView;
}


@end

