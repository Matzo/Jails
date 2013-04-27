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
        
        NSUserDefaults *userDefoulds = [NSUserDefaults standardUserDefaults];
        int seed = 0;
        if ([[[userDefoulds dictionaryRepresentation] allKeys] containsObject:kNSUserDefaultsJailsSeedKey]) {
            seed = [userDefoulds integerForKey:kNSUserDefaultsJailsSeedKey];
        } else {
            srand((unsigned) time(NULL));
            seed = rand() % 100;
            [userDefoulds setInteger:seed forKey:kNSUserDefaultsJailsSeedKey];
        }
        
        self.branchSeed = seed;
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
+(void)breakWithConfURL:(NSURL*)url {
    Jails *jails = [Jails sharedInstance];
    jails.jsonURL = url;
    
    
    NSData *data = [jails loadCache];
    NSError *error = nil;
    
    // use cache first
    if (data) {
        jails.conf = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        if (error) {
            NSLog(@"parse config error:%@", error);
        } else {
            [jails injectAspect];
        }
    }
    
    
    // always load JSON even if it is cached
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [jails loadJSON];
    });
    
    // set reload events
    [jails observeNotification];
}

+(void)breakWithConfURL:(NSURL*)url loadingInterval:(NSTimeInterval)interval {
    Jails *jails = [Jails sharedInstance];
    jails.interval = interval;
    [Jails breakWithConfURL:url];
    
    if (0 < interval) {
        jails.repeatTimer = [NSTimer timerWithTimeInterval:interval
                                                    target:jails
                                                  selector:@selector(loadJSON)
                                                  userInfo:nil
                                                   repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:jails.repeatTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)observeNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    [center addObserver:self selector:@selector(loadJSON) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)loadJSON {
    NSData *data = nil;
    NSError *error = nil;

    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:self.jsonURL
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:5.0];
    NSURLResponse *res = nil;
    data = [NSURLConnection sendSynchronousRequest:req
                                 returningResponse:&res
                                             error:&error];
    if (error) {
        NSLog(@"get config error:%@", error);
        return;
    }
    
    if (data) {
        self.conf = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        if (error) {
            NSLog(@"parse config error:%@", error);
            return;
        } else {
            [self saveCache:data];
            [self injectAspect];
        }
    }
}

-(void)saveCache:(NSData*)data {
    NSString *path = [self cachePath];
    [data writeToFile:path atomically:YES];
}
-(NSData*)loadCache {
    NSString *path = [self cachePath];
    return [NSData dataWithContentsOfFile:path];
}
-(NSString*)cachePath {
    return [NSString stringWithFormat:@"%@_jails_config.cache", NSTemporaryDirectory()];
}

-(void)injectAspect {
    for (NSString *className in [self.conf keyEnumerator]) {
        
        if ([self.aspectedClassSet containsObject:className]) {
            continue;
        }
        
        [NSClassFromString(className) swizzleMethod:@selector(viewDidLoad)
                                         withMethod:@selector(_aspect_viewDidLoad)];
        
        [NSClassFromString(className) swizzleMethod:@selector(viewWillLayoutSubviews)
                                         withMethod:@selector(_aspect_viewWillLayoutSubviews)];
        
        [NSClassFromString(className) swizzleMethod:@selector(viewDidLayoutSubviews)
                                         withMethod:@selector(_aspect_viewDidLayoutSubviews)];
        
        [self.aspectedClassSet addObject:className];
    }
}



#pragma mark - Execute AB
+(void)branchViewController:(UIViewController*)viewController {
    Jails *jails = [Jails sharedInstance];
    NSDictionary *conf = [jails getConfigWithViewController:viewController];
    if (conf) {
        
//        viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSDictionary *property in conf[@"properties"]) {
            SEL propName = NSSelectorFromString(property[@"name"]);
            if ([viewController respondsToSelector:propName]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                UIView *view = [viewController performSelector:propName];
#pragma clang diagnostic pop
                [JailsViewAdjuster updateViewController:viewController view:view conf:property];
            }
        }
    }
}

+(NSString*)branchNameOfViewController:(UIViewController*)viewController {
    Jails *jails = [Jails sharedInstance];
    NSDictionary *conf = [jails getConfigWithViewController:viewController];
    if (conf) {
        return conf[@"name"];
    } else {
        return nil;
    }
}

+(void)stopRepeatLoading {
    Jails *jails = [Jails sharedInstance];
    [jails.repeatTimer invalidate];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:jails];
}

#pragma mark - Private Methods
- (NSDictionary*)getConfigWithViewController:(UIViewController*)viewController {
    NSString *className = NSStringFromClass([viewController class]);
    NSDictionary *conf = nil;
    if (self.conf && (conf = self.conf[className])) {
        NSArray *abList = conf[@"ratio"];
        int range = 0;
        int target = 0;
        for (int i = 0; i < abList.count; i++) {
            NSNumber *percent = abList[i];
            range += [percent intValue];
            if (self.branchSeed < range) {
                target = i;
                break;
            }
        }
        return conf[@"branches"][target];
    } else {
        return nil;
    }
}



@end

