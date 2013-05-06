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
    

Android
----
### Require
- AspectJ

### Install
1. install AJDT from Eclipse Marketplace.
2. update your project to AspectJ Project by `Select Project > Configure > Convert to AspectJ Project`.
3. add `jails.jar` and `aspectjrt.jar` (check `AspectJ Runtime Library` at Order and Export in Java Build Path) to your project.
4. add `ActivityAspect.aj` to your project.

### Sample Code
    // MainActivity.java
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
          :
        Jails jails = Jails.getSharedInstance().loadConfig("http://your.domain.com/path/to/conf/jails.json");
          :
    }

Tools
----
- jails.json editor  
http://matzo.github.io/jpon_demo/#jails.json

