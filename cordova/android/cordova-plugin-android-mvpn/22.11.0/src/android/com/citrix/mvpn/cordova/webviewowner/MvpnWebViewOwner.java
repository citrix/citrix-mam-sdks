package com.citrix.mvpn.cordova.webviewowner;

import com.citrix.mvpn.cordova.webviewrequests.WebViewRequest;

/**
 * Something that 'owns' {@link OwnedMvpnWebView WebViews}. Processes
 * all network requests and ensures that the requests use the MVPN tunnel.
 */
public interface MvpnWebViewOwner {
    /**
     * Enable a {@link android.webkit.WebView WebView} to use the MVPN tunnel.
     * 
     * @param toRegister the WebView to enable
     */
    boolean registerWebView(OwnedMvpnWebView toRegister);

    /**
     * A {@link WebViewRequest WebViewRequest} to process. Determines when to
     * perform the request.
     * 
     * @param request the request from an owned webview
     */
    void processRequest(WebViewRequest request);
}