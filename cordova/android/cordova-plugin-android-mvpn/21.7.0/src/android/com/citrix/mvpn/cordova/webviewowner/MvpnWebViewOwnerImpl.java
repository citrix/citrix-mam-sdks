package com.citrix.mvpn.cordova.webviewowner;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.VisibleForTesting;

import com.citrix.mvpn.api.MicroVPNSDK;
import com.citrix.mvpn.api.ResponseStatusCode;
import com.citrix.mvpn.cordova.webviewrequests.WebViewRequest;
import com.citrix.sdk.logging.api.Logger;

import java.util.LinkedList;
import java.util.List;

// TODO: add proper behavior to make sure that constant session expiration doesn't result in infinite loop.
// TODO: update to fix breaking changes from MVPNSDK

/**
 * Default implementation of a {@link MvpnWebViewOwner}. Manages
 * {@link OwnedMvpnWebView}s to ensure that their network requests
 * use the MVPN. Uses a Boolean to track whether a WebView has been
 * enabled. Tracks all network requests that have not gone through
 * the MVPN tunnel yet, and until the tunnel starts, tells owned
 * WebViews to load a blank url. Also acts as the Handler for the
 * MVPNSDK. Is a singleton to ensure that this is the only Handler
 * for the MVPNSDK, and to ensure that all {@link WebViewRequest requests}
 * are eventually performed, without being garbage collected.
 */
public class MvpnWebViewOwnerImpl extends Handler implements MvpnWebViewOwner {
    private static final String TAG = "MVPN-CDV-WebViewOwner";
    private static MvpnWebViewOwnerImpl instance;
    private final Activity mActivity;
    private final List<WebViewRequest> requests;
    private Logger logger = Logger.getLogger(TAG);

    /**
     * Requires an {@link android.app.Activity Activity} for the
     * MVPNSDK. Passes the main looper to the Handler's constructor
     * to make sure that it doesn't get garbage collected.
     *
     * @param activity the Activity that this app is running in
     */
    private MvpnWebViewOwnerImpl(Activity activity) {
        super(Looper.getMainLooper());
        mActivity = activity;
        requests = new LinkedList<>();
        instance = this;

        this.runStartTunnel();
    }

    @VisibleForTesting
    public static void setInstance(MvpnWebViewOwnerImpl input) {
        instance = input;
    }

    @VisibleForTesting
    public void removeRequests() {
        if (requests != null && requests.size() > 0) {
            requests.remove(0);
        }
    }
    /**
     * Creates an instance of this if it doesn't already exist. The
     * {@link android.content.Context Context} is supposed to be an
     * {@link android.app.Activity Activity}, since that is required
     * by the MVPNSDK. Luckily,
     * {@link org.apache.cordova.CordovaActivity CordovaActivity}
     * passes itself indirectly to this method as the Context.
     *
     * @param context the Activity that the application is running in
     * @return the instance of this
     */
    public static MvpnWebViewOwnerImpl createOrInstance(Context context) {
        if (instance != null) {
            return instance;
        }
        if (!(context instanceof Activity)) {
            throw new IllegalArgumentException("Expected Activity for WebViewOwner");
        }
        instance = new MvpnWebViewOwnerImpl((Activity)context);
        return instance;
    }

    /**
     * @return the instance of this
     */
    public static MvpnWebViewOwnerImpl getInstance() {
        return instance;
    }

    /**
     * Starts the MVPN tunnel. Needs to be run in a separate Thread
     * so that the main {@link android.os.Looper Looper} doesn't get
     * blocked, a requirement of the MVPNSDK.
     */
    private void runStartTunnel() {
        logger.debug1(TAG, "Calling startTunnel");
        MicroVPNSDK.startTunnel(mActivity, new Messenger(instance));
        logger.debug1(TAG, "Finished startTunnel call");
    }

    /**
     * Called once the network tunnel is running. Performs all stored {@link WebViewRequest requests}
     * that have been attempted by Web Views. If the WebView doesn't succeed in being enabled, puts it
     * at the end of the queue to try again later. Doesn't stop running until all requests have been
     * processed.
     */
    @VisibleForTesting
    public void catchUp() {
        WebViewRequest request = null;
        while (requests.size() > 0) {
            request = requests.remove(0);
            this.processRequest(request);
        }
    }

    /**
     * Takes {@link android.os.Message messages} from the MVPNSDK service. If the
     * tunnel indicates it is done loading and is ready to process network requests,
     * this will call {@link MvpnWebViewOwnerImpl#catchUp}. If the MVPN session has
     * expired, starts the tunnel again automatically. Anything else is weird or bad.
     *
     * @param msg the Message from the MVPN service
     */
    @Override
    public void handleMessage(Message msg) {
        Log.d(TAG, "handling message: " + msg.toString());
        ResponseStatusCode code = ResponseStatusCode.fromId(msg.what);
        switch (code) {
            case START_TUNNEL_SUCCESS:
                logger.info(TAG, "Tunnel successfully started");
                MvpnWebViewOwnerImpl.instance.catchUp();
                break;
            case START_TUNNEL_FAILED:
                logger.error(TAG, "Tunnel failed to start.");
                break;
            case TUNNEL_ALREADY_RUNNING:
                logger.warning(TAG, "Tunnel already running. Continuing...");
                break;
            case SESSION_EXPIRED:
                logger.error(TAG, "Tunnel session expired");
                this.runStartTunnel();
                break;
            case FOUND_NON_WEBSSO_MODE:
                logger.error(TAG, "Cannot start tunnel for NetworkAccess mode other than Tunneled - Web SSO!!!");
                break;
            case FOUND_NON_MANAGED_APP:
                logger.error(TAG, "Could not retrieve policies!!! \n This could be because of the following reasons: \n\t 1. SecureHub is not installed.\n\t 2. SecureHub enrollment is not completed.\n\t 3. App is not managed through CEM.");
                break;
            case NO_NETWORK_CONNECTION:
                logger.error(TAG, "No network connection detected by MVPNSDK. Showing toast...");
                Toast.makeText(mActivity, "No network connection detected. Please re-connect to the internet and try again.", Toast.LENGTH_LONG).show();
                break;
            default:
                logger.error(TAG, "Received unrecognized message from MVPN service: " + code);
                super.handleMessage(msg);
        }
    }

    /**
     * Registers a {@link OwnedMvpnWebView WebView} for use with the MVPN.
     * If successful, passes a Boolean object to the WebView to indicate
     * whether it has been enabled. Doesn't attempt to enable the WebView
     * if it has already been enabled.
     *
     * @param toRegister the WebView to enable
     * @return true if the WebView has been enabled for the MVPN
     */
    @Override
    public boolean registerWebView(OwnedMvpnWebView toRegister) {
        logger.debug5(TAG, "registering WebView");
        // pass true if the WebView is null. This is because there
        // is nothing that the Owner can do to enable a null WebView.
        // If the WebView has been extracted from a WebViewRequest, then
        // the request is expected to know what to do with the null WV.
        if (toRegister == null) {
            return true;
        }

        Boolean isAlreadyRegistered = (Boolean)toRegister.getMessageObject();
        if (isAlreadyRegistered == null) {
            isAlreadyRegistered = Boolean.FALSE;
            toRegister.acceptMessageObject(Boolean.FALSE);
        }

        if (isAlreadyRegistered) {
            return true;
        }

        logger.debug5(TAG, "Registering WebView for MVPN");
        try {
            if(MicroVPNSDK.isNetworkTunnelRunning(mActivity)) {
                if(toRegister.getWebViewClient() != null && !(toRegister.getWebViewClient().getClass().getName().contains("InAppBrowser$"))) {
                    MicroVPNSDK.enableWebViewObjectForNetworkTunnel(mActivity, toRegister.getWebView(), toRegister.getWebViewClient());
                } else {
                    MicroVPNSDK.enableWebViewObjectForNetworkTunnel(mActivity, toRegister.getWebView());
                }
                logger.debug5(TAG, "Successfully enabled Web View for the Micro VPN");
                toRegister.acceptMessageObject(Boolean.TRUE);
                return true;
            }
            return false;
        } catch (Exception e) {
            logger.error(TAG, "Error enabling Web View for MVPN. The Web View shouldn't load anything yet.");
            toRegister.acceptMessageObject(Boolean.FALSE);
            return false;
        }
    }

    /**
     * Process a {@link WebViewRequest}. Performs the request on an
     * enabled WebView. If the WebView isn't enabled, stores the
     * request to process later.
     *
     * @param request the WebViewRequest to process
     */
    @Override
    public void processRequest(WebViewRequest request) {
        OwnedMvpnWebView wv = request.getWebView();
        if (registerWebView(wv)) {
            request.perform();
        } else {
            requests.add(request);
            logger.debug10(TAG, "Queued Request Size:" + requests.size());
        }
    }
}