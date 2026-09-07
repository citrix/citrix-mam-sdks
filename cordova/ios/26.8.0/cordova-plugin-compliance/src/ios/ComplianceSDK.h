
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

@interface ComplianceSDK : NSObject

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

@property(strong, nonatomic) NSString *handleAdminLockAppSecurityActionForErrorCallbackId;
@property(strong, nonatomic) NSString *handleAdminWipeAppSecurityActionForErrorCallbackId;
@property(strong, nonatomic) NSString *handleContainerSelfDestructSecurityActionForErrorCallbackId;
@property(strong, nonatomic) NSString *handleAppDisabledSecurityActionForErrorCallbackId;
@property(strong, nonatomic) NSString *handleDateAndTimeChangeSecurityActionForErrorCallbackId;
@property(strong, nonatomic) NSString *handleUserChangeSecurityActionForErrorCallbackId;
@property(strong, nonatomic) NSString *handleDevicePasscodeComplianceViolationForErrorCallbackId;
@property(strong, nonatomic) NSString *handleJailbreakComplianceViolationForErrorCallbackId;
@property(strong, nonatomic) NSString *handleEDPComplianceViolationForErrorCallbackId;

@property(nonatomic, assign) BOOL ishandleAdminLockAppSecurityActionForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleAdminWipeAppSecurityActionForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleContainerSelfDestructSecurityActionForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleAppDisabledSecurityActionForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleDateAndTimeChangeSecurityActionForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleUserChangeSecurityActionForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleDevicePasscodeComplianceViolationForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleJailbreakComplianceViolationForErrorDelegateImplemented;
@property(nonatomic, assign) BOOL ishandleEDPComplianceViolationForErrorDelegateImplemented;

+ (ComplianceSDK *) sharedInstance;

@end

NS_ASSUME_NONNULL_END




