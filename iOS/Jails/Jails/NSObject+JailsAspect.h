@interface NSObject(JailsAspect)

+ (void)_jails_swizzleMethod:(SEL)orig_sel withMethod:(SEL)alt_sel;

@end
