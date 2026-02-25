package com.citrix.mvpn.cordova.webviewrequests;

import android.util.Log;
import android.webkit.WebView;

import com.citrix.mvpn.cordova.webviewowner.OwnedMvpnWebView;
import com.citrix.mvpn.cordova.webviewrequests.WebViewRequest;

import java.lang.ref.WeakReference;
import java.util.Arrays;

/**
 * Represents a call to a {@link OwnedMvpnWebView}'s
 * {@code postUrl(String, byte[])}. Stores WebView
 * as a {@link WeakReference} to ensure that it
 * gets garbage collected if it needs to.
 */
public class PostUrl implements WebViewRequest {
    private static final String TAG = "MVPN-CDV-PostUrl";
    private final WeakReference<OwnedMvpnWebView> mViewRef;
    private final String mUrl;
    private final byte[] mPostData;

    public PostUrl(OwnedMvpnWebView webView, String url, byte[] postData) {
        mViewRef = new WeakReference<>(webView);
        mUrl = url;
        mPostData = postData;
    }

    @Override
    public void perform() {
        OwnedMvpnWebView view = mViewRef.get();
        if (view == null) return;

        view.tunnelRunningPostUrl(mUrl, mPostData);
    }

    @Override
    public OwnedMvpnWebView getWebView() {
        return mViewRef.get();
    }
}