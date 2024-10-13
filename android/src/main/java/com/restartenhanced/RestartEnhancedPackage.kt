package com.restartenhanced

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import com.restartenhanced.LegacyRestartEnhancedModule // Import for the legacy bridge-based module
import com.restartenhanced.RestartEnhancedModule // Import for the new architecture TurboModule

class RestartEnhancedPackage : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    val modules = mutableListOf<NativeModule>()

    // Register the legacy module (for old architecture)
    modules.add(LegacyRestartModule(reactContext))

    // Register the TurboModule (for new architecture)
    val isTurboModule = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
    if (isTurboModule) {
        modules.add(RestartModuleModule(reactContext))
    }

    return modules
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    return emptyList()
  }

  override fun getReactModuleInfoProvider(): ReactModuleInfoProvider {
    return ReactModuleInfoProvider {
      val moduleInfos: MutableMap<String, ReactModuleInfo> = HashMap()
      val isTurboModule: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
      moduleInfos[RestartModuleModule.NAME] = ReactModuleInfo(
          RestartModuleModule.NAME,
          RestartModuleModule.NAME,
          false,  // canOverrideExistingModule
          false,  // needsEagerInit
          true,   // hasConstants
          false,  // isCxxModule
          isTurboModule // isTurboModule
      )
      moduleInfos
    }
  }
}
