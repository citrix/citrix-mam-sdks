package com.citrix.mvpn.cordova.webviewrequests;

import android.webkit.WebView;

import com.citrix.mvpn.cordova.webviewowner.OwnedMvpnWebView;
import com.citrix.mvpn.cordova.webviewrequests.WebViewRequest;

import java.lang.ref.WeakReference;

/**
 * Represents a call to a {@link OwnedMvpnWebView}'s
 * {@code loadData(String, String, String)} or 
 * {@code loadDataWithBaseUrl(String, String, String, String)}. 
 * Stores WebView as a {@link WeakReference} to ensure that 
 * it gets garbage collected if it needs to.
 */
public class LoadData implements WebViewRequest {
    protected static final String TAG = "MVPN-CDV-LoadData";
    private final WeakReference<OwnedMvpnWebView> webViewRef;
    private final String mBaseUrl, mData, mMimeType, mEncoding, mFailUrl;

    public LoadData(OwnedMvpnWebView webView, String data, String mimeType, String encoding) {
        this(webView, null, data, mimeType, encoding, null);
    }

    public LoadData(OwnedMvpnWebView webView, String baseUrl, String data, String mimeType, String encoding, String failUrl) {
        webViewRef = new WeakReference<OwnedMvpnWebView>(webView);
        mBaseUrl = baseUrl;
        mData = data;
        mMimeType = mimeType;
        mEncoding = encoding;
        mFailUrl = failUrl;
    }

    public void perform() {
        OwnedMvpnWebView view = webViewRef.get();

        if (view == null) return;
        else if (mBaseUrl == null && mFailUrl == null) {
            view.tunnelRunningLoadData(mData, mMimeType, mEncoding);
        } else {
            view.tunnelRunningLoadDataWithBaseURL(mBaseUrl, mData, mMimeType, mEncoding, mFailUrl);
        }
    }

    public OwnedMvpnWebView getWebView() {
        return webViewRef.get();
    }
}