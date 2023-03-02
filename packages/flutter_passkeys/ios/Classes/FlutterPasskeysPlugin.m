#import "FlutterPasskeysPlugin.h"
#if __has_include(<flutter_passkeys/flutter_passkeys-Swift.h>)
#import <flutter_passkeys/flutter_passkeys-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_passkeys-Swift.h"
#endif

@implementation FlutterPasskeysPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPasskeysPlugin registerWithRegistrar:registrar];
}
@end
