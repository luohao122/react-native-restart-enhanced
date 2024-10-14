#import "RestartEnhanced.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTRootView.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>

@implementation RestartEnhanced

RCT_EXPORT_MODULE()

// Helper method to find RCTRootView in the view hierarchy
- (RCTRootView *)findRCTRootViewFromView:(UIView *)view {
    if (!view) return nil;
    if ([view isKindOfClass:[RCTRootView class]]) {
        return (RCTRootView *)view;
    }
    for (UIView *subview in view.subviews) {
        RCTRootView *rctRootView = [self findRCTRootViewFromView:subview];
        if (rctRootView) {
            return rctRootView;
        }
    }
    return nil;
}

RCT_EXPORT_METHOD(restart:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the key window
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].delegate.window;

        if (!keyWindow) {
            NSLog(@"No key window available.");
            reject(@"NO_WINDOW", @"No key window available", nil);
            return;
        }

        // Get the root view controller
        UIViewController *rootViewController = keyWindow.rootViewController;

        // Fallback if no root view controller is found
        if (!rootViewController) {
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.isKeyWindow) {
                    rootViewController = window.rootViewController;
                    if (rootViewController) {
                        break;
                    }
                }
            }
        }

        if (!rootViewController) {
            NSLog(@"No root view controller found.");
            reject(@"NO_ACTIVITY", @"No root view controller available to restart", nil);
            return;
        }

        // Find the RCTRootView
        RCTRootView *rootView = [self findRCTRootViewFromView:rootViewController.view];
        if (!rootView) {
            NSLog(@"No RCTRootView found in the view hierarchy.");
            reject(@"NO_RCTROOTVIEW", @"No RCTRootView found in root view controller", nil);
            return;
        }

        @try {
            // Get the bridge from the RCTRootView
            RCTBridge *bridge = rootView.bridge;
            NSString *moduleName = rootView.moduleName ?: @"RestartEnhancedExample";  // Replace with your actual app name

            NSLog(@"Restarting with moduleName: %@", moduleName);

            // Create a new root view and replace the existing one to simulate restart
            RCTRootView *newRootView = [[RCTRootView alloc] initWithBridge:bridge
                                                                 moduleName:moduleName
                                                          initialProperties:nil];

            // Replace the root view in the view hierarchy
            rootViewController.view = newRootView;

            // Make the key window visible
            [keyWindow makeKeyAndVisible];

            NSLog(@"Restart successful.");
            resolve(nil); // Successfully restarted
        } @catch (NSException *exception) {
            NSLog(@"Exception caught during restart: %@", exception);
            reject(@"RESTART_ERROR", @"Failed to restart the app", nil);
        }
    });
}

@end
