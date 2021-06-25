package com.citrix.mvpn.cordova.webview;

import android.content.Context;
import android.util.Log;

import org.apache.cordova.CordovaPreferences;
import org.apache.cordova.engine.SystemWebViewEngine;

import com.citrix.sdk.appcore.api.MamSdk;
/**
 * Creates an instance of a {@link CEMWebView CEMWebView}. This extends the
 * {@link org.apache.cordova.engine.SystemWebViewEngine SystemWebViewEngine}
 * since all other WebViewEngine functionalities are the same.
 * <br>
 * This class gets used by the application since we modify {@code config.xml} 
 * to use this class instead of the {@code SystemWebViewEngine}. 
 * {@link org.apache.cordova.CordovaWebViewImpl#createEngine(Context, CordovaPreferences) createEngine}
 * reads the canonical name of this class to create an instance
 * using reflection over the default {@code SystemWebViewEngine}.
 * However, this does depend on SystemWebViewEngine, so if anything
 * breaks there, make sure to fix here.
 * <br>
 * This code does not have an external origin.
 */
public final class CEMWebViewEngine extends SystemWebViewEngine {
    protected static final String TAG = "MVPN-CDV-WebViewEngine";

    /**
     * Used by CordovaWebViewImpl to be created, uses a {@link CEMWebView} instead of {@link org.apache.cordova.engine.SystemWebView}.
     * @param context this is android context
     * @param preferences
     */
    public CEMWebViewEngine(Context context, CordovaPreferences preferences) {
        super(new CEMWebView(context), preferences);
        MamSdk.getLogger().debug(TAG, "created");
    }
}