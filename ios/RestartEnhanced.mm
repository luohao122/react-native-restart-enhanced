#import "RestartEnhanced.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTRootView.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>

@implementation RestartEnhanced

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(restart:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the key window and root view controller
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow == nil) {
            keyWindow = [UIApplication sharedApplication].delegate.window;
        }

        if (keyWindow == nil) {
            reject(@"NO_WINDOW", @"No key window available", nil);
            return;
        }

        UIViewController *rootViewController = keyWindow.rootViewController;

        // Fallback if no root view controller is found
        if (rootViewController == nil) {
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.isKeyWindow) {
                    rootViewController = window.rootViewController;
                    if (rootViewController != nil) {
                        break;
                    }
                }
            }
        }

        // Ensure the root view controller is valid and is a RCTRootView
        if (rootViewController != nil && [rootViewController.view isKindOfClass:[RCTRootView class]]) {
            @try {
                // Get the bridge from the RCTRootView
                RCTRootView *rootView = (RCTRootView *)rootViewController.view;
                RCTBridge *bridge = rootView.bridge;

                // Use the same module name from the current RCTRootView
                NSString *moduleName = rootView.appProperties[@"moduleName"];
                if (moduleName == nil) {
                    moduleName = @"RestartEnhancedExample";  // Replace with your actual app name
                }

                // Create a new root view and replace the existing one to simulate restart
                RCTRootView *newRootView = [[RCTRootView alloc] initWithBridge:bridge
                                                                     moduleName:moduleName
                                                              initialProperties:nil];
                rootViewController.view = newRootView;

                // Make the key window visible to ensure layout is updated
                [keyWindow makeKeyAndVisible];

                resolve(nil); // Successfully restarted
            } @catch (NSException *exception) {
                reject(@"RESTART_ERROR", @"Failed to restart the app", nil);
            }
        } else {
            reject(@"NO_ACTIVITY", @"No root view controller available to restart", nil);
        }
    });
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRestartEnhancedSpecJSI>(params);
}
#endif

@end
