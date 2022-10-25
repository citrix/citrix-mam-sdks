package com.citrix.mvpn.cordova.webviewowner;

import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.util.Map;

/**
 * A WebView that needs to be enabled for the MVPN tunnel. Works with
 * {@link MvpnWebViewOwner} to make sure all requests are processed
 * through the MVPN.
 */
public interface OwnedMvpnWebView {
    /**
     * Loads a blank web page
     */
    void loadBlank();

    /**
     * Called by a 
     * {@link com.citrix.mvpn.cordova.webviewrequests.WebViewRequest WebViewRequest}. 
     * Called only after the WebView has been enabled for the tunnel.
     * 
     * {@see android.webkit.WebView#loadUrl(String) WebView#loadUrl}
     */
    void tunnelRunningLoadUrl(String url);

    /**
     * Called by a 
     * {@link com.citrix.mvpn.cordova.webviewrequests.WebViewRequest WebViewRequest}. 
     * Called only after the WebView has been enabled for the tunnel.
     * 
     * {@see android.webkit.WebView#loadUrl(String, Map<String, String>) WebView#loadUrl}
     */
    void tunnelRunningLoadUrl(String url, Map<String, String> additionalHeaders);

    /**
     * Called by a 
     * {@link com.citrix.mvpn.cordova.webviewrequests.WebViewRequest WebViewRequest}. 
     * Called only after the WebView has been enabled for the tunnel.
     * 
     * {@see android.webkit.WebView#loadData(String, String, String) WebView#loadData}
     */
    void tunnelRunningLoadData(String data, String mimeType, String encoding);

    /**
     * Called by a 
     * {@link com.citrix.mvpn.cordova.webviewrequests.WebViewRequest WebViewRequest}. 
     * Called only after the WebView has been enabled for the tunnel.
     * 
     * {@see android.webkit.WebView#loadDataWithBaseUrl(String, String, String, String, String) WebView#LoadDataWithBaseUrl}
     */
    void tunnelRunningLoadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String failUrl);

    /**
     * Called by a 
     * {@link com.citrix.mvpn.cordova.webviewrequests.WebViewRequest WebViewRequest}. 
     * Called only after the WebView has been enabled for the tunnel.
     * 
     * {@see android.webkit.WebView#postUrl(String, byte[]) WebView#postUrl}
     */
    void tunnelRunningPostUrl(String url, byte[] postData);

    /**
     * Accept an Object that the {@link MvpnWebViewOwner owner} passes to
     * track tunnel enabling.
     * 
     * @param o the object received from the owner
     */
    void acceptMessageObject(Object o);

    /**
     * @return the last Object that the {@link MvpnWebViewOwner owner} has
     *          passed to this
     */
    Object getMessageObject();

    /**
     * @return the current instance of the {@link android.webkit.WebViewClient WebViewClient}
     *          that is stored by this
     */
    WebViewClient getWebViewClient();

    /**
     * @return an instance of the {@link android.webkit.WebView} that this represents
     */
    WebView getWebView();
}