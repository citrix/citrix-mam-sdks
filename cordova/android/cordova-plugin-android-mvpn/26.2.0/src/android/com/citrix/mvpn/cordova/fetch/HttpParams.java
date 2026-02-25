package com.citrix.mvpn.cordova.fetch;

import java.util.HashMap;

import lombok.Getter;
import lombok.Value;

@Value
public class HttpParams {
    private HttpRequestMethod requestMethod;
    private String requestUrl;
    private String contentType;
    private HashMap<String, String> requestHeaders;
    private byte[] postBody;

    @Getter
    public enum HttpRequestMethod {
        GET("GET"),
        POST("POST"),
        HEAD("HEAD"),
        PUT("PUT"),
        DELETE("DELETE");

        private String value;

        HttpRequestMethod(String value) {
            this.value = value;
        }
    }
}