package com.citrix.mvpn.cordova.fetch;

import org.apache.cordova.CallbackContext;

public interface HttpHandler<T, R> {

    T buildRequest(HttpParams origRequest);

    R sendRequest(T request);

    void sendRequestAsync(T request, CallbackContext callbackContext);
}
