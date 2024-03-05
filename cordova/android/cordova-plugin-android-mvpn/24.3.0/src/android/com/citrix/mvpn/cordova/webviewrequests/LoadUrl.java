package com.citrix.mvpn.cordova.webviewrequests;

import com.citrix.mvpn.cordova.webviewowner.OwnedMvpnWebView;

import java.lang.ref.WeakReference;
import java.util.Map;

/**
 * Represents a call to a {@link OwnedMvpnWebView}'s
 * {@code loadUrl(String)} or 
 * {@code loadUrl(String, Map<String, String>)}. Stores
 * WebView as a {@link WeakReference} to ensure that it
 * gets garbage collected if it needs to.
 */
public class LoadUrl implements WebViewRequest {
    private static final String TAG = "MVPN-CDV-LoadUrl";
    private final WeakReference<OwnedMvpnWebView> mViewRef;
    private final String mUrl;
    private final Map<String, String> mAdditionalHeaders;

    public LoadUrl(OwnedMvpnWebView webView, String url, Map<String, String> additionalHeaders) {
        if (url == null) {
            throw new IllegalArgumentException("Can't load null url");
        }

        mViewRef = new WeakReference<>(webView);
        mUrl = url;
        mAdditionalHeaders = additionalHeaders;
    }

    public LoadUrl(OwnedMvpnWebView webView, String url) {
        this(webView, url, null);
    }

    @Override
    public void perform() {
        OwnedMvpnWebView view = mViewRef.get();
        
        if (view == null) return;
        else if (mAdditionalHeaders == null) {
            view.tunnelRunningLoadUrl(mUrl);
        } else {
            view.tunnelRunningLoadUrl(mUrl, mAdditionalHeaders);
        }
    }

    @Override
    public OwnedMvpnWebView getWebView() {
        return mViewRef.get();
    }
}