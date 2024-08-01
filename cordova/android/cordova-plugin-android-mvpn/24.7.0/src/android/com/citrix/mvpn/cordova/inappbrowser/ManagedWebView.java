package com.citrix.mvpn.cordova.inappbrowser;

import android.content.Context;
import android.util.AttributeSet;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.citrix.mvpn.cordova.webviewowner.MvpnWebViewOwnerImpl;
import com.citrix.mvpn.cordova.webviewowner.OwnedMvpnWebView;
import com.citrix.mvpn.cordova.webviewrequests.LoadData;
import com.citrix.mvpn.cordova.webviewrequests.LoadUrl;
import com.citrix.mvpn.cordova.webviewrequests.PostUrl;
import com.citrix.sdk.logging.api.Logger;

import java.util.Arrays;
import java.util.Map;

public class ManagedWebView extends WebView implements OwnedMvpnWebView {
        private static final String TAG = "CEM-ManagedWebView";
        private Object messageObject;
        private WebViewClient mClient;

        private Logger logger = Logger.getLogger(TAG);

        public ManagedWebView(Context context) {
            super(context);
        }

        public ManagedWebView(Context context, AttributeSet attributeSet) {
            super(context, attributeSet);
        }

        public ManagedWebView(Context context, AttributeSet attributeSet, int firstInt) {
            super(context, attributeSet, firstInt);
        }

        @Override
        public void loadBlank() {
            logger.debug9(TAG, "ManagedWebView: Loading blank url");
            super.loadUrl("about:blank");
        }

        @Override
        public void loadUrl(String url) {
            logger.debug9(TAG, String.format("ManagedWebView: loadUrl(%s)", url));
            MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadUrl(this, url));
        }

        @Override
        public void loadUrl(String url, Map<String, String> additionalHeaders) {
            logger.debug9(TAG, String.format("ManagedWebView: loadUrl(%s, %s)", url, additionalHeaders));
            MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadUrl(this, url, additionalHeaders));
        }

        @Override
        public void loadData(String data, String mimeType, String encoding) {
            logger.debug9(TAG, String.format("ManagedWebView: loadData(%s, %s, %s)", data, mimeType, encoding));
            MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadData(this, data, mimeType, encoding));
        }

        @Override
        public void loadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String failUrl) {
            logger.debug9(TAG, String.format("ManagedWebView: loadDataWithBaseURL(%s, %s, %s, %s, %s)", baseUrl, data, mimeType, encoding, failUrl));
            MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadData(this, baseUrl, data, mimeType, encoding, failUrl));
        }

        @Override
        public void postUrl(String url, byte[] postData) {
            logger.debug9(TAG, String.format("ManagedWebView: postData(%s, %s)", url, Arrays.toString(postData)));
            MvpnWebViewOwnerImpl.getInstance().processRequest(new PostUrl(this, url, postData));
        }

        @Override
        public void tunnelRunningLoadUrl(String url) {
            logger.debug9(TAG, String.format("ManagedWebView: tunnel running: loadUrl(%s)", url));
            super.loadUrl(url);
        }

        @Override
        public void tunnelRunningLoadUrl(String url, Map<String, String> additionalHeaders) {
            logger.debug9(TAG, String.format("ManagedWebView: tunnel running: loadUrl(%s, %s)", url, additionalHeaders));
            super.loadUrl(url, additionalHeaders);
        }

        @Override
        public void tunnelRunningLoadData(String data, String mimeType, String encoding) {
            logger.debug9(TAG, String.format("ManagedWebView: tunnel running: loadData(%s, %s, %s)", data, mimeType, encoding));
            super.loadData(data, mimeType, encoding);
        }

        @Override
        public void tunnelRunningLoadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String failUrl) {
            logger.debug9(TAG, String.format("ManagedWebView: tunnel running: loadDataWithBaseURL(%s, %s, %s, %s, %s)", baseUrl, data, mimeType, encoding, failUrl));
            super.loadDataWithBaseURL(baseUrl, data, mimeType, encoding, failUrl);
        }

        @Override
        public void tunnelRunningPostUrl(String url, byte[] postData) {
            logger.debug9(TAG, String.format("ManagedWebView: tunnel running: postData(%s, %s)", url, Arrays.toString(postData)));
            super.postUrl(url, postData);
        }

        @Override
        public void acceptMessageObject(Object o) {
            logger.debug9(TAG, "Accepted message object");
            messageObject = o;
        }

        @Override
        public Object getMessageObject() {
            logger.debug9(TAG, "Something requested message object");
            return messageObject;
        }

        @Override
        public void setWebViewClient(WebViewClient client) {
            logger.debug9(TAG, "Setting client");
            mClient = client;
            super.setWebViewClient(client);
        }

        @Override
        public WebViewClient getWebViewClient() {
            logger.debug9(TAG, "Something requested client");
            return mClient;
        }

        @Override
        public WebView getWebView() {
            logger.debug9(TAG, "Something requested me");
            return this;
        }
    }