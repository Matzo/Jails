Jails
=====

AB testing framework for native apps of iOS and Android.

iOS
----
### Require
- iOS 5.0 and later

### Install

1. Open project on Xcode.
2. Select scheme `Jails > iOS Device` then `Project > Build`.
3. Select scheme `Jails > iPhone 5.0 Simulator` then `Project > Build`.
4. Copy built `libJails.a` and `Jails.h` from `Release-universal or Debug-universal` into your project.
5. Add `-ObjC -all_load` to `Other Linker Flags` of Build Setting.

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
1. Install AJDT from Eclipse Marketplace.
2. Update your project to AspectJ Project by `Select Project > Configure > Convert to AspectJ Project`.
3. Add `jails.jar` and `aspectjrt.jar` (check `AspectJ Runtime Library` at Order and Export in Java Build Path) to your project.
4. Add `ActivityAspect.aj` to your project.

### Sample Code
    // MainActivity.java
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
          :
        Jails.breakWithConfURL("http://your.domain.com/path/to/conf/jails.json");
          :
    }

Tools
----
- jails.json editor  
http://matzo.github.io/jpon_demo/#jails-0_2.json

