/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAMCoreSDK : NSObject

@property(nonatomic, assign) BOOL isProxyServerSettingDelegateImplemented;
@property(nonatomic, assign) BOOL isSdksInitializedAndReadyDelegateImplemented;
@property(strong, nonatomic) NSString *sdksInitializedAndReadyDelegateCallbackId;
@property(strong, nonatomic) NSString *proxyServerSettingDelegateCallbackId;

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

+ (MAMCoreSDK *) sharedInstance;

@end

NS_ASSUME_NONNULL_END
