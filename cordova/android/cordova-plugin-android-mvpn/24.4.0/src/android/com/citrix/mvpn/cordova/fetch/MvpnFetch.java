package com.citrix.mvpn.cordova.fetch;

import android.content.Context;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;

import okhttp3.OkHttpClient;
import okhttp3.Request;

import com.citrix.sdk.logging.api.Logger;

public class MvpnFetch extends CordovaPlugin {
    public static final String LOG_TAG = "MVPN-CDV-MvpnFetch";
    private Logger logger = Logger.getLogger(LOG_TAG);

    @Override
    public boolean execute(final String action, final JSONArray data, final CallbackContext callbackContext) {
        logger.debug10(LOG_TAG, "Within MvpnFetch.execute()");
        if (action.equals("fetch")) {
            if(data == null || data.length() < 4) {
                logger.error(LOG_TAG, "Invalid JSON Data.");
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return false;
            }
            HttpParams fetchRequest = MvpnFetchHelper.getFetchRequest(data);
            Context appContext = this.cordova.getActivity().getApplicationContext();
            OkHttpClient okHttpClient = new OkHttpClient();
            OkHttpHandler handler = new OkHttpHandler(okHttpClient, appContext);
            Request request = handler.buildRequest(fetchRequest);
            handler.sendRequestAsync(request, callbackContext);
            logger.debug10(LOG_TAG, "Sent request successful!!!");
            return true;
        } else {
            logger.error(LOG_TAG, "Invalid action : " + action);
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.INVALID_ACTION));
            return false;
        }
    }
}
