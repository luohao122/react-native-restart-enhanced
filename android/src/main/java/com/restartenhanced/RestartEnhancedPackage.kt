package com.restartenhanced

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.restartenhanced.LegacyRestartEnhancedModule

class RestartEnhancedPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        val modules = mutableListOf<NativeModule>()

        val isTurboModuleEnabled = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
        if (isTurboModuleEnabled) {
            // For the new architecture, the TurboModule is automatically registered via codegen.
            // Do not add it manually here.
        } else {
            // Register the legacy module for the old architecture
            modules.add(LegacyRestartEnhancedModule(reactContext))
        }

        return modules
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }
}
