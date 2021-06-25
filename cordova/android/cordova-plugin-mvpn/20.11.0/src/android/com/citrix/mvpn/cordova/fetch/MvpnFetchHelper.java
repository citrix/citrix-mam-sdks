package com.citrix.mvpn.cordova.fetch;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import com.citrix.sdk.appcore.api.MamSdk;
import com.citrix.sdk.logging.api.LoggingAPI;

public class MvpnFetchHelper {

    private static final String LOG_TAG = "MVPN-CDV-FetchHelper";
    private static LoggingAPI logger = MamSdk.getLogger();

    public static HttpParams getFetchRequest(JSONArray data) throws ApiException {
        logger.debug10(LOG_TAG, "Within getFetchRequest()");
        HttpParams fetchRequest = null;
        try {
            if(data == null || data.length() < 4) {
                throw new ApiException("Bad data in JSONArray");
            }
            String method = data.getString(0);
            String urlString = data.getString(1);
            String postBody = data.getString(2);
            JSONObject headers = data.getJSONObject(3);
            String contentType = "application/json";
            HashMap<String, String> headerMap = new HashMap<>();

            if (headers.has("map") && headers.getJSONObject("map") != null) {
                headers = headers.getJSONObject("map");
            }

            if (headers != null && headers.names() != null && headers.names().length() > 0) {
                for (int i = 0; i < headers.names().length(); i++) {
                    String headerName = headers.names().getString(i);
                    JSONArray headerValues = headers.getJSONArray(headerName);

                    if (headerValues != null && headerValues.length() > 0) {
                        String headerValue = headerValues.getString(0);
                        Log.d(LOG_TAG, "key = " + headerName + " value = " + headerValue);
                        headerMap.put(headerName, headerValue);
                    }
                }
                if (headers.has(HttpHeaders.CONTENT_TYPE_HEADER_NAME)) {
                    JSONArray contentTypeHeaders = headers.getJSONArray(HttpHeaders.CONTENT_TYPE_HEADER_NAME);
                    contentType = contentTypeHeaders.getString(0);
                }
            }

            fetchRequest = new HttpParams(HttpParams.HttpRequestMethod.valueOf(method),
                    urlString, contentType, headerMap, postBody.getBytes());
            logRequest(fetchRequest);
        } catch (JSONException e) {
            logger.error(LOG_TAG, "JSONException occurred:" + e.getMessage());
        }
        return fetchRequest;
    }

    private static void logRequest(HttpParams fetchRequest) {
        if(fetchRequest != null) {
            logger.debug10(LOG_TAG, "execute: method = " + fetchRequest.getRequestMethod());
            logger.debug10(LOG_TAG, "execute: urlString = " + fetchRequest.getRequestUrl());
            logger.debug10(LOG_TAG, "execute: postBody = " + fetchRequest.getPostBody());
            logger.debug10(LOG_TAG, "execute: contentType = " + fetchRequest.getContentType());
            logger.debug10(LOG_TAG, "execute: headers = " + fetchRequest.getRequestHeaders());
        }
    }
}