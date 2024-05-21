/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

#import <Cordova/CDV.h>

@interface CtxMAMCoreBridge : CDVPlugin

- (void)initializeSDKs:(CDVInvokedUrlCommand*)command;

#pragma mark - Core SDK: Optional delegates

- (void)proxyServerSettingDetected:(CDVInvokedUrlCommand*)command;
- (void)sdksInitializedAndReady:(CDVInvokedUrlCommand*)command;

#pragma mark Local Configuration Storage APIs

- (void)getConfigurationAsStringForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsNumberForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsDataForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsDictionaryForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsIntegerForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsDoubleForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsBoolForKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationAsObjectForKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForStringKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForNumberKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForDataKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForDictKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForIntKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForDoubleKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForBoolKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForObjectKey:(CDVInvokedUrlCommand*)command;
- (void)getConfigurationForKey:(CDVInvokedUrlCommand*)command;
- (void)setConfigurationForKey:(CDVInvokedUrlCommand*)command;
- (void)removeConfigurationForKey:(CDVInvokedUrlCommand*)command;

#pragma mark Shared Configuration Storage APIs

- (void)getSharedConfigurationAsStringForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsNumberForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsDataForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsDictionaryForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsIntegerForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsDoubleForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsBoolForKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationAsObjectForKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForStringKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForNumberKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForDataKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForDictKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForIntKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForDoubleKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForBoolKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForObjectKey:(CDVInvokedUrlCommand*)command;
- (void)getSharedConfigurationForKey:(CDVInvokedUrlCommand*)command;
- (void)setSharedConfigurationForKey:(CDVInvokedUrlCommand*)command;
- (void)removeSharedConfigurationForKey:(CDVInvokedUrlCommand*)command;

#pragma mark Logging Methods

- (void)ctxMAMLog_Initialize:(CDVInvokedUrlCommand*)command;
- (void)ctxMAMLog_CriticalErrorFrom:(CDVInvokedUrlCommand*)command;
- (void)ctxMAMLog_ErrorFrom:(CDVInvokedUrlCommand*)command;
- (void)ctxMAMLog_WarningFrom:(CDVInvokedUrlCommand*)command;
- (void)ctxMAMLog_InfoFrom:(CDVInvokedUrlCommand*)command;
- (void)ctxMAMLog_DetailFrom:(CDVInvokedUrlCommand*)command;


#pragma mark Notification methods

-(void)registerForNotifications:(CDVInvokedUrlCommand*)command;
-(void)deregisterNotifications:(CDVInvokedUrlCommand*)command;

@end
