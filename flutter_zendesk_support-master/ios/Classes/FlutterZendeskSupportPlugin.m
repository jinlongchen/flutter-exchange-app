#import "FlutterZendeskSupportPlugin.h"
#import <flutter_zendesk_support/flutter_zendesk_support-Swift.h>

@implementation FlutterZendeskSupportPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterZendeskSupportPlugin registerWithRegistrar:registrar];
}
@end
