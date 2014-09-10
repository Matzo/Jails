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


Jails.json
----
    {"ClassNameOfViewController": [
      { "ratio": 0 },   // A: 0%
      { "ratio": 100,   // B: 100%
        "branchName": "b",
        "properties": [{
          "name": "scrollView",
          "frame": ["+0", "+44", "+0", "-44"]
        },
        {
          "name": "view",
          "createSubviews": [{
            "class": "UIButton",
            "background": "http://button/image.png",
            "frame": ["0", "0", "320", "44"],
            "action": "http://open/this/url/"
          }]
        }]
      }
    ]}


| Key | required | Description |
|:-----------|:---:|:-----------|
| ClassNameOfViewController | o | This class name can be changed. You can specified subclasses of UIViewController or UIView. |
| ratio      | o | Percentage for A/B test. |
| branchName | - | You can use this name as parameter for your analytics tools. |
| properties | - | You can change each properties with specified name. |


| Key for properties or createSubviews | required | Description |
|:-----------|:---:|:-----------|
| name       | o | variable name as a property |
| background | - | If you specified as URL of image, draw as pattern tile. Or, draw color if you specified HEX color code. |
| frame      | - | UIView's frame for iOS. You can specify relatively position. |
| text       | - | For UILabel: changing labes's text. For UIButton: change buttons title. For UIWebView: change html contents. |
| action     | - | For UIWebView: you can specify URL for HTML contetnts. For UIButton: you can specify URL for to call openURL:, or selector for addTarget:action:forControlEvents: |
| hidden     | - | Change visibility of UI perts. |
| createSubview | - | You can use this param for original properties. So you cannot build tree hierarchy. |


Tools
----
- jails.json editor  
http://matzo.github.io/jpon_demo/#jails-0_2.json

