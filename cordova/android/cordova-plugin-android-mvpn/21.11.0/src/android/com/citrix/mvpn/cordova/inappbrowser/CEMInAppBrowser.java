package com.citrix.mvpn.cordova.inappbrowser;

import android.annotation.SuppressLint;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.inappbrowser.InAppBrowser;
import org.json.JSONArray;
import org.json.JSONException;

import com.citrix.sdk.logging.api.Logger;

@SuppressLint("SetJavaScriptEnabled")
public class CEMInAppBrowser extends InAppBrowser {
    protected static final String TAG = "MVPN-CDV-CEMInAppBrowser";
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Logger.getLogger(TAG).debug10(TAG, "Within CEMInAppBrowser.execute()");
        return super.execute(action, args, callbackContext);
    }
}
