#import "AnnaPlugin.h"
#if __has_include(<anna/anna-Swift.h>)
#import <anna/anna-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "anna-Swift.h"
#endif

@implementation AnnaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnnaPlugin registerWithRegistrar:registrar];
}
@end
