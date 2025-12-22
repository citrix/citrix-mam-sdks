/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

#import "MAMCoreSDK.h"
#import <CTXMAMCore/CTXMAMCore.h>

@interface MAMCoreSDK() <CTXMAMCoreSdkDelegate>
@end

@implementation MAMCoreSDK

+ (MAMCoreSDK *) sharedInstance {
    static MAMCoreSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MAMCoreSDK alloc] init];
    });
    return instance;
}

- (BOOL) proxyServerSettingDetectedWithDefaultHandlerOption {
    if (_isProxyServerSettingDelegateImplemented) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:_proxyServerSettingDelegateCallbackId];
    }
    return _isProxyServerSettingDelegateImplemented;
}

- (void) sdksInitializedAndReady:(BOOL)online {
//TODO: deprecate function
    if (_isSdksInitializedAndReadyDelegateImplemented) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:online];
        [self.commandDelegate sendPluginResult:result callbackId:_sdksInitializedAndReadyDelegateCallbackId];
    }
}

@end
