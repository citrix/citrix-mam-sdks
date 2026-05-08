/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

#import "ComplianceSDK.h"
#import <CTXMAMCompliance/CTXMAMCompliance.h>

static NSString *const kComplianceErrorCode = @"errorCode";
static NSString *const kComplianceUserInfoMsg = @"userInfoMsg";

@interface ComplianceSDK() <CTXMAMComplianceDelegate>
@end

@implementation ComplianceSDK

+ (ComplianceSDK *) sharedInstance {
    static ComplianceSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ComplianceSDK new];
    });
    return instance;
}

#pragma mark - Compliance SDK: Optional delegates

- (BOOL) handleAdminLockAppSecurityActionForError:(NSError*)error {
    if (_ishandleAdminLockAppSecurityActionForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleAdminLockAppSecurityActionForErrorCallbackId];
    }
    return _ishandleAdminLockAppSecurityActionForErrorDelegateImplemented;
}

- (BOOL) handleAdminWipeAppSecurityActionForError:(NSError*)error {
    if (_ishandleAdminWipeAppSecurityActionForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleAdminWipeAppSecurityActionForErrorCallbackId];
    }
    return _ishandleAdminWipeAppSecurityActionForErrorDelegateImplemented;
}

- (BOOL) handleContainerSelfDestructSecurityActionForError:(NSError*)error {
    if (_ishandleContainerSelfDestructSecurityActionForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleContainerSelfDestructSecurityActionForErrorCallbackId];
    }
    return _ishandleContainerSelfDestructSecurityActionForErrorDelegateImplemented;
}

- (BOOL) handleAppDisabledSecurityActionForError:(NSError*)error {
    if (_ishandleAppDisabledSecurityActionForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleAppDisabledSecurityActionForErrorCallbackId];
    }
    return _ishandleAppDisabledSecurityActionForErrorDelegateImplemented;
}

- (BOOL) handleDateAndTimeChangeSecurityActionForError:(NSError*)error {
    if (_ishandleDateAndTimeChangeSecurityActionForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleDateAndTimeChangeSecurityActionForErrorCallbackId];
    }
    return _ishandleDateAndTimeChangeSecurityActionForErrorDelegateImplemented;
}

- (BOOL) handleUserChangeSecurityActionForError:(NSError*)error {
    if (_ishandleUserChangeSecurityActionForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleUserChangeSecurityActionForErrorCallbackId];
    }
    return _ishandleUserChangeSecurityActionForErrorDelegateImplemented;
}

- (BOOL) handleDevicePasscodeComplianceViolationForError:(NSError*)error {
    if (_ishandleDevicePasscodeComplianceViolationForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleDevicePasscodeComplianceViolationForErrorCallbackId];
    }
    return _ishandleDevicePasscodeComplianceViolationForErrorDelegateImplemented;
}

- (BOOL) handleJailbreakComplianceViolationForError:(NSError*)error {
    if (_ishandleJailbreakComplianceViolationForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleJailbreakComplianceViolationForErrorCallbackId];
    }
    return _ishandleJailbreakComplianceViolationForErrorDelegateImplemented;
}

- (BOOL) handleEDPComplianceViolationForError:(NSError*)error {
    if (_ishandleEDPComplianceViolationForErrorDelegateImplemented) {
        NSDictionary* errorInfoDict = @{ kComplianceErrorCode : [self getComplianceErrorCode:error], kComplianceUserInfoMsg : error.localizedDescription};
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:errorInfoDict];
        [self.commandDelegate sendPluginResult:result callbackId:_handleEDPComplianceViolationForErrorCallbackId];
    }
    return _ishandleEDPComplianceViolationForErrorDelegateImplemented;
}

- (NSString*) getComplianceErrorCode:(NSError*)error {
    NSString* complianceError;
    switch (error.code) {
        case CTXMAMCompliance_SecurityAction_AdminAppLock:
            complianceError = @"CTXMAMCompliance_SecurityAction_AdminAppLock";
            break;
        case CTXMAMCompliance_SecurityAction_AdminAppWipe:
            complianceError = @"CTXMAMCompliance_SecurityAction_AdminAppWipe";
            break;
        case CTXMAMCompliance_SecurityAction_ContainerSelfDestruct:
            complianceError = @"CTXMAMCompliance_SecurityAction_ContainerSelfDestruct";
            break;
        case CTXMAMCompliance_SecurityAction_AppDisabled:
            complianceError = @"CTXMAMCompliance_SecurityAction_AppDisabled";
            break;
        case CTXMAMCompliance_SecurityAction_DateAndTimeChanged:
            complianceError = @"CTXMAMCompliance_SecurityAction_DateAndTimeChanged";
            break;
        case CTXMAMCompliance_SecurityAction_UserChanged:
            complianceError = @"CTXMAMCompliance_SecurityAction_UserChanged";
            break;
        case CTXMAMCompliance_Violation_Jailbroken:
            complianceError = @"CTXMAMCompliance_Violation_Jailbroken";
            break;
        case CTXMAMCompliance_Violation_DevicePasscodeRequired:
            complianceError = @"CTXMAMCompliance_Violation_DevicePasscodeRequired";
            break;
        case CTXMAMCompliance_Violation_EDP_BlockApp:
            complianceError = @"CTXMAMCompliance_Violation_EDP_BlockApp";
            break;
        case CTXMAMCompliance_Violation_EDP_WarnUser:
            complianceError = @"CTXMAMCompliance_Violation_EDP_WarnUser";
            break;
        case CTXMAMCompliance_Violation_EDP_InformUser:
            complianceError = @"CTXMAMCompliance_Violation_EDP_InformUser";
            break;
        case CTXMAMComplianceError_Other:
        default:
            complianceError = @"CTXMAMComplianceError_Other";
            break;
    }
    return complianceError;
}

@end
