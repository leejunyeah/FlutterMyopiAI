#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#import "MyopiaPlugin.h"
#import "SettingsPlugin.h"
#import "MyopiaToFlutterPlugin.h"

@implementation AppDelegate {
    
}

static MyopiaToFlutterPlugin* _timerChannel;

static NSString *const END_CHANNEL = @"com.myopia.flutter_myopia_ai/end_record_plugin";
static NSString *const LIGHT_CHANNEL = @"com.myopia.flutter_myopia_ai/light_plugin";
static NSString *const LIGHT_WARNING_CHANNEL = @"com.myopia.flutter_myopia_ai/light_warning_plugin";
static NSString *const TIMER_CHANNEL = @"com.myopia.flutter_myopia_ai/timer_plugin";

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    [MyopiaPlugin registerWithRegistrar:[self registrarForPlugin:(@"MyopiaPlugin")]];
    [SettingsPlugin registerWithRegistrar:[self registrarForPlugin:(@"SettingsPlugin")]];
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    [MyopiaToFlutterPlugin registChannel:END_CHANNEL binaryMessenger:controller];
    [MyopiaToFlutterPlugin registChannel:LIGHT_CHANNEL binaryMessenger:controller];
    [MyopiaToFlutterPlugin registChannel:LIGHT_WARNING_CHANNEL binaryMessenger:controller];
    _timerChannel = [MyopiaToFlutterPlugin registChannel:TIMER_CHANNEL binaryMessenger:controller];
    
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

+ (void)updateTimer:(NSNumber *)timer {
    if (_timerChannel) {
        if (_timerChannel.eventSink) {
            _timerChannel.eventSink(timer);
        }
    }
}

@end
