package com.restartenhanced;

import android.app.Activity;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

public class LegacyRestartEnhancedModule extends ReactContextBaseJavaModule {

    public LegacyRestartEnhancedModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RestartEnhanced";
    }

    @ReactMethod
    public void restart(Promise promise) {
        Activity activity = getCurrentActivity();
        if (activity != null) {
            activity.runOnUiThread(() -> {
                try {
                    activity.recreate(); // Restart the current activity
                    promise.resolve(null); // Resolve the promise if successful
                } catch (Exception e) {
                    promise.reject("RESTART_ERROR", "Failed to restart the activity", e);
                }
            });
        } else {
            promise.reject("NO_ACTIVITY", "No current activity to restart");
        }
    }
}
