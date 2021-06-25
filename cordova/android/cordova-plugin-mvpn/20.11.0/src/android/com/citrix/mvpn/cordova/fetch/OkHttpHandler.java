package com.citrix.mvpn.cordova.fetch;

import android.content.Context;
import android.util.Log;

import com.citrix.sdk.appcore.api.MamSdk;
import com.citrix.mvpn.api.MicroVPNSDK;
import com.citrix.mvpn.exception.ClientConfigurationException;
import com.citrix.mvpn.exception.NetworkTunnelNotStartedException;
import com.citrix.sdk.logging.api.LoggingAPI;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;

import okhttp3.CacheControl;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Headers;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class OkHttpHandler implements HttpHandler<Request, Response> {

    private static final String TAG = "MVPN-CDV-OkHttpHandler";
    private OkHttpClient httpClient;
    private Context context;
    private LoggingAPI logger = MamSdk.getLogger();

    public OkHttpHandler(OkHttpClient httpClient, Context context) {
        this.httpClient = httpClient;
        this.context = context;
    }

    @Override
    public Response sendRequest(Request request) {
        logger.debug10(TAG, "Within sendRequest()");
        Response response = null;
        try {
            httpClient = (OkHttpClient) MicroVPNSDK.enableOkHttpClientObjectForNetworkTunnel(context, httpClient);
            logger.debug10(TAG, "MicroVPN enableOkHttpClientObject returned");
        } catch (NetworkTunnelNotStartedException e) {
            logger.error(TAG, "Network tunnel exception");
        } catch (ClientConfigurationException e) {
            logger.error(TAG, "ClientConfig Exception" + e.getMessage() + e);
        }

        try {
            if (httpClient != null) {
                response = httpClient.newCall(request).execute();
                return response;
            }
        } catch (IOException e) {
            throw new ApiException("Error sending request to server. Exception: " + e.getMessage());
        }
        return response;
    }

    @Override
    public void sendRequestAsync(Request request, CallbackContext callbackContext) {
        try {
            httpClient = (OkHttpClient) MicroVPNSDK.enableOkHttpClientObjectForNetworkTunnel(context, httpClient);
            logger.debug10(TAG, "MicroVPN enableOkHttpClientObject returned");
        } catch (NetworkTunnelNotStartedException e) {
            logger.error(TAG, "Network tunnel exception");
        } catch (ClientConfigurationException e) {
            logger.error(TAG, "ClientConfig Exception" + e.getMessage() + e);
        }

        if (httpClient != null) {
            Call call = httpClient.newCall(request);
            call.enqueue(new Callback() {
                @Override
                public void onFailure(Call call, IOException throwable) {
                    logger.error(TAG, "Failed OkHttp Request:" + throwable.getMessage());
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, throwable.getMessage()));
                }

                @Override
                public void onResponse(Call call, Response response) {
                    logger.debug5(TAG, "Within onResponse()");
                    JSONObject result = new JSONObject();

                    try {
                        Headers responseHeaders = response.headers();

                        JSONObject allHeaders = new JSONObject();

                        if (responseHeaders != null ) {
                            for (int i = 0; i < responseHeaders.size(); i++) {
                                String headerName = responseHeaders.name(i);
                                String headerValue = responseHeaders.value(i);
                                if (headerName != null && headerName.equalsIgnoreCase(HttpHeaders.SET_COOKIE_HEADER_NAME) &&
                                        allHeaders.has(headerName)) {
                                    allHeaders.put(headerName, allHeaders.get(headerName) + ",\n" + headerValue);
                                } else {
                                    allHeaders.put(headerName, headerValue);
                                }
                            }
                        }
                        result.put("headers", allHeaders);
                        result.put("body", response.body().string());
                        result.put("statusText", response.message());
                        result.put("status", response.code());
                        result.put("url", response.request().url().toString());
                    } catch (Exception e) {
                        logger.error(TAG, "Exception occurred in onResponse() method:" + e.getMessage());
                    }
                    logger.debug5(TAG, "HTTP code: " + response.code());
                    logger.debug5(TAG, "returning: " + result.toString());
                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, result));
                }
            });
        }
    }

    @Override
    public Request buildRequest(HttpParams origRequest) {
        HttpParams.HttpRequestMethod requestMethod = origRequest.getRequestMethod();
        HashMap<String, String> headers = origRequest.getRequestHeaders();

        RequestBody postBody = null;

        if (requestMethod == HttpParams.HttpRequestMethod.POST
                || requestMethod == HttpParams.HttpRequestMethod.PUT
                || requestMethod == HttpParams.HttpRequestMethod.DELETE) {

            if (origRequest.getPostBody() != null) {
                postBody = RequestBody.create(MediaType.parse(origRequest.getContentType()), origRequest.getPostBody());
            } else {
                postBody = RequestBody.create(null, new byte[0]);
            }
        }

        String url = origRequest.getRequestUrl();

        Request.Builder requestBuilder = new Request.Builder()
                .cacheControl(new CacheControl.Builder().noCache().build())
                .url(url)
                .method(requestMethod.getValue(), postBody);

        for (HashMap.Entry<String, String> entry : headers.entrySet()) {
            requestBuilder.header(entry.getKey(), entry.getValue());
        }

        if (origRequest.getContentType() != null) {
            requestBuilder.header(HttpHeaders.CONTENT_TYPE_HEADER_NAME, origRequest.getContentType());
        }

        return requestBuilder.build();
    }
}
