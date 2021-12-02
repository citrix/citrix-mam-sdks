package com.citrix.mvpn.cordova.webview;

import android.content.Context;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.citrix.mvpn.cordova.webviewowner.MvpnWebViewOwner;
import com.citrix.mvpn.cordova.webviewowner.MvpnWebViewOwnerImpl;
import com.citrix.mvpn.cordova.webviewowner.OwnedMvpnWebView;
import com.citrix.mvpn.cordova.webviewrequests.LoadData;
import com.citrix.mvpn.cordova.webviewrequests.LoadUrl;
import com.citrix.mvpn.cordova.webviewrequests.PostUrl;
import com.citrix.sdk.logging.api.Logger;

import org.apache.cordova.engine.SystemWebView;

import java.util.Arrays;
import java.util.Map;

/**
 * The WebView that contains everything in a Cordova application.
 * <br>
 * This WebView gets owned by an instance of a {@link MvpnWebViewOwner},
 * which process all requests of this WebView. Every normal method for
 * loading data in the webview instead gets deferred to the owner, which
 * will call the tunnelRunning{methodName} method once the owner is ready
 * to load the data here.
 * <br>
 * This file depends on Cordova's SystemWebView. If anything there gets
 * broken or changes, make sure to update here to fix.
 * <br>
 * This code does not have an external origin.
 */
public class CEMWebView extends SystemWebView implements OwnedMvpnWebView {
    protected static final String TAG = "MVPN-CDV-WebView";
    private static final String BLANK_URL = "about:blank";
    private Logger logger = Logger.getLogger(TAG);

    /**
     * Object that the Owner passes to this webview to track whether the
     * Owner has enabled this WebView for the MVPN tunnel yet.
     */
    private Object ownerMessage;

    /**
     * Keep track of this for the Owner, which needs it so that the
     * MVPNSDK can create an instance of a subclass of this for
     * compatibility reasons and to maintain functionality.
     */
    private WebViewClient mClient;

    public CEMWebView(Context context) {
        super(context);
        // make sure that the Owner exists
        MvpnWebViewOwner owner = MvpnWebViewOwnerImpl.createOrInstance(context);
        // attempt to have this WebView enabled with the MVPNSDK
        owner.registerWebView(this);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void loadBlank() {
        logger.debug10(TAG, "CEMWebView: Loading blank page");
        super.loadUrl(BLANK_URL);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void loadUrl(String url) {
        if (!shouldTunnel(url)) {
            super.loadUrl(url);
            return;
        }

        logger.debug10(TAG, String.format("CEMWebView: loadUrl(%s)", url));
        MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadUrl(this, url));
    }

    private boolean shouldTunnel(String url) {
        if(url != null && !url.equals(BLANK_URL)) {
            return true;
        }
        return false;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void loadUrl(String url, Map<String, String> additionalHeaders) {
        if (!shouldTunnel(url)) {
            super.loadUrl(url, additionalHeaders);
            return;
        }

        logger.debug10(TAG, String.format("CEMWebView: loadUrl(%s, %s)", url, additionalHeaders.toString()));
        MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadUrl(this, url, additionalHeaders));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void loadData(String data, String mimeType, String encoding) {
        logger.debug10(TAG, String.format("CEMWebView: loadData(%s, %s, %s)", data, mimeType, encoding));
        MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadData(this, data, mimeType, encoding));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void loadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String failUrl) {
        logger.debug10(TAG, String.format("CEMWebView: loadDataWithBaseUrl(%s, %s, %s, %s, %s)", baseUrl, data, mimeType, encoding, failUrl));
        MvpnWebViewOwnerImpl.getInstance().processRequest(new LoadData(this, baseUrl, data, mimeType, encoding, failUrl));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void postUrl(String url, byte[] postData) {
        logger.debug10(TAG, String.format("CEMWebView: postUrl(%s, %s)", url, Arrays.toString(postData)));
        MvpnWebViewOwnerImpl.getInstance().processRequest(new PostUrl(this, url, postData));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void tunnelRunningLoadUrl(String url) {
        logger.debug10(TAG, String.format("CEMWebView: Tunnel running: loadUrl(%s)", url));
        super.loadUrl(url);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void tunnelRunningLoadUrl(String url, Map<String, String> additionalHeaders) {
        logger.debug10(TAG, String.format("CEMWebView: Tunnel running: loadUrl(%s, %s)", url, additionalHeaders.toString()));
        super.loadUrl(url, additionalHeaders);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void tunnelRunningLoadData(String data, String mimeType, String encoding) {
        logger.debug10(TAG, String.format("CEMWebView: Tunnel running: loadData(%s, %s, %s)", data, mimeType, encoding));
        super.loadData(data, mimeType, encoding);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void tunnelRunningLoadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String failUrl) {
        logger.debug10(TAG, String.format("CEMWebView: Tunnel running: loadDataWithBaseURL(%s, %s, %s, %s, %s)", baseUrl, data, mimeType, encoding, failUrl));
        super.loadDataWithBaseURL(baseUrl, data, mimeType, encoding, failUrl);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void tunnelRunningPostUrl(String url, byte[] postData) {
        logger.debug10(TAG, String.format("CEMWebView: Tunnel running: postUrl(%s, %s)", url, Arrays.toString(postData)));
        super.postUrl(url, postData);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void acceptMessageObject(Object o) {
        logger.debug10(TAG, "Accepted object from owner");
        this.ownerMessage = o;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Object getMessageObject() {
        logger.debug10(TAG, "Something requested message object");
        return this.ownerMessage;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public WebViewClient getWebViewClient() {
        logger.debug10(TAG, "Something requested client");
        return mClient;
    }

    /**
     * @return this as an instance of a WebView
     */
    @Override
    public WebView getWebView() {
        logger.debug10(TAG, "Something requested me");
        return this;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void setWebViewClient(WebViewClient client) {
        logger.debug10(TAG, "Setting client");
        mClient = client;
        super.setWebViewClient(client);
    }
}