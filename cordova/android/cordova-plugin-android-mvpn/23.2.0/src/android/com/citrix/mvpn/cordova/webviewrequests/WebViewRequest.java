package com.citrix.mvpn.cordova.webviewrequests;

import com.citrix.mvpn.cordova.webviewowner.OwnedMvpnWebView;

/**
 * A network request that is supposed to be run in a WebView.
 */
public interface WebViewRequest {
    /**
     * Performs this request.
     */
    void perform();

    /**
     * @return the {@link OwnedMvpnWebView} that this request is supposed to run on
     */
    OwnedMvpnWebView getWebView();
}