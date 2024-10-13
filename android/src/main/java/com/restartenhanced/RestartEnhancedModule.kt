package com.restartenhanced

import android.app.Activity
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class RestartEnhancedModule internal constructor(context: ReactApplicationContext) :
  RestartEnhancedSpec(context) {

  override fun getName(): String {
    return NAME
  }

  override fun restart(promise: Promise) {
    val activity: Activity? = currentActivity
    if (activity != null) {
      activity.runOnUiThread {
        try {
          activity.recreate() // Restart the current activity
          promise.resolve(null) // Resolve the promise if successful
        } catch (e: Exception) {
          promise.reject("RESTART_ERROR", "Failed to restart the activity", e)
        }
      }
    } else {
      promise.reject("NO_ACTIVITY", "No current activity to restart")
    }
  }

  companion object {
    const val NAME = "RestartEnhanced"
  }
}
