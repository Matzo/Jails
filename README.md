Jails
=====

AB testing framework for iOS and Android native apps

iOS
----
### Install

1. open project on Xcode.
2. Select Jails scheme then [Project] -> [Build].
3. copy built `libJails.a` and `Jails.h` into your project.
4. add `-ObjC -all_load` to `Other Linker Flags` of Build Setting.

### Sample Code
    // AppDelegate.m
    
    #import "Jails.h"
    
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
         :
        [Jails breakWithConfURL:[NSURL URLWithString:@"http://your.domain.com/path/to/conf/jails.json"]];
         :
    }
    

Android (Draft)
----
### Require
- AspectJ

### Install
1. install AJDT from Eclipse Marketplace

Tools
----
- jails.json editor  
http://matzo.github.io/jpon_demo/#jails.json

