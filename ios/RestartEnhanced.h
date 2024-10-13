
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNRestartEnhancedSpec.h"

@interface RestartEnhanced : NSObject <NativeRestartEnhancedSpec>
#else
#import <React/RCTBridgeModule.h>

@interface RestartEnhanced : NSObject <RCTBridgeModule>
#endif

@end
