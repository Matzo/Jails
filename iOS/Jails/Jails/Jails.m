//
//  Jails.m
//  Jails
//
//  Created by Matsuo, Keisuke | Matzo | TRVDD on 4/19/13.
//  Copyright (c) 2013 Matzo. All rights reserved.
//

#import "Jails.h"
#import "NSObject+JailsAspect.h"
#import "JailsViewAdjuster.h"

@implementation Jails

- (id)init {
    self = [super init];
    if (self) {
        
        NSUserDefaults *userDefoults = [NSUserDefaults standardUserDefaults];
        int seed = 0;
        if ([[[userDefoults dictionaryRepresentation] allKeys] containsObject:kNSUserDefaultsJailsSeedKey]) {
            seed = [userDefoults integerForKey:kNSUserDefaultsJailsSeedKey];
        } else {
            srand((unsigned) time(NULL));
            seed = rand() % 100;
            [userDefoults setInteger:seed forKey:kNSUserDefaultsJailsSeedKey];
        }
        
        self.branchSeed = seed;
        self.aspectedClassSet = [NSMutableSet set];
        self.webAdapterListDic = [NSMutableDictionary dictionary];
        self.linkDic = [NSMutableDictionary dictionary];
    }
    return self;
}

+(Jails*)sharedInstance {
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
    [jails loadJSON];
    
    // set reload events
    [jails observeNotification];
}

+(void)breakWithConfURL:(NSURL*)url loadingInterval:(NSTimeInterval)interval {
    Jails *jails = [Jails sharedInstance];
    jails.interval = interval;
    [Jails breakWithConfURL:url];
    
    if (0 < interval && !jails.repeatTimer) {
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    });
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
        Class class = NSClassFromString(className);
        if ([class isSubclassOfClass:[UIViewController class]]) {
            [class _jails_swizzleMethod:@selector(viewDidLoad)
                             withMethod:@selector(_jails_viewDidLoad)];
            
//            [class _jails_swizzleMethod:@selector(viewDidLayoutSubviews)
//                             withMethod:@selector(_aspect_viewDidLayoutSubviews)];
        } else if ([class isSubclassOfClass:[UIView class]]) {
            [class _jails_swizzleMethod:@selector(layoutSubviews)
                             withMethod:@selector(_jails_layoutSubviews)];
        }
        
        [self.aspectedClassSet addObject:className];
    }
}



#pragma mark - Execute AB
+(void)branch:(id)parent {
    Jails *jails = [Jails sharedInstance];
    NSDictionary *conf = [jails getConfigWithClass:[parent class]];
    if (conf) {
        
        for (NSDictionary *property in conf[@"properties"]) {
            SEL propName = NSSelectorFromString(property[@"name"]);
            if ([parent respondsToSelector:propName]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                UIView *childView = [parent performSelector:propName];
#pragma clang diagnostic pop
                
                [JailsViewAdjuster updateView:childView parent:parent conf:property];
            }
        }
    }
}

+(NSString*)branchNameOfViewController:(UIViewController*)viewController {
    Jails *jails = [Jails sharedInstance];
    NSDictionary *conf = [jails getConfigWithClass:[viewController class]];
    if (conf) {
        return conf[@"branchName"];
    } else {
        return nil;
    }
}

+(void)stopRepeatLoading {
    Jails *jails = [Jails sharedInstance];
    [jails.repeatTimer invalidate];
    jails.repeatTimer = nil;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:jails];
}

#pragma mark - Private Methods
- (NSDictionary*)getConfigWithClass:(Class)class {
    NSString *className = NSStringFromClass([class class]);
    NSArray *abList = nil;
    if (self.conf && (abList = self.conf[className])) {
        int range = 0;
        int target = 0;
        for (int i = 0; i < abList.count; i++) {
            NSNumber *percent = abList[i][@"ratio"];
            range += [percent intValue];
            if (self.branchSeed < range) {
                target = i;
                break;
            }
        }
        return abList[target];
    } else {
        return nil;
    }
}

@end

