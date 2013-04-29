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
`[Jails breakWithConfURL:[NSURL URLWithString:@"http://your.domain.com/path/to/conf/jails.json"]];`


Tools
----
- jails.json editor  
http://matzo.github.io/jpon_demo/#jails.json
