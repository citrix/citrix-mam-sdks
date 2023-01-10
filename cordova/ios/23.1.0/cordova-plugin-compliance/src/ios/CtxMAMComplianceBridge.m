/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

#import "CtxMAMComplianceBridge.h"
#import <Cordova/CDV.h>
#import "ComplianceSDK.h"
#import <CTXMAMCompliance/CTXMAMCompliance.h>
#import <CTXMAMCore/CTXMAMCore.h>

static NSString *const CTXLog_SourceName = @"CompliancePlugin";

@interface CtxMAMComplianceBridge ()
@end

@implementation CtxMAMComplianceBridge

/*!
 @brief Register the delegate to receive Compliance SDK callbacks.
 */
- (void) initialize:(CDVInvokedUrlCommand*)command
{
    [CTXMAMCompliance sharedInstance].delegate =  (id<CTXMAMComplianceDelegate>) [ComplianceSDK sharedInstance];
    [ComplianceSDK sharedInstance].commandDelegate = self.commandDelegate;
    CTXMAMLOG_Info(CTXLog_SourceName, @"Compliance SDK delegate set.");
}

- (void) checkCompliance:(CDVInvokedUrlCommand*)command
{
    NSArray *complianceErrors =[[CTXMAMCompliance sharedInstance] checkCompliance];
    NSMutableArray *complianceErrorArray = [NSMutableArray new];
    for (NSError *complianceError in complianceErrors) {
        [complianceErrorArray addObject:complianceError.localizedDescription];
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:complianceErrorArray];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) performLogonWithErrorContext:(CDVInvokedUrlCommand*)command
{
    NSString *errorCode = [command.arguments objectAtIndex: 0];
    NSError  *error = [NSError errorWithDomain:CTXMAMComplianceErrorDomain
                                          code:[self getComplianceErrorCode:errorCode]
                                     userInfo:@{}];
    [[CTXMAMCompliance sharedInstance] performLogonWithErrorContext:error completionHandler:^(BOOL success) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:success];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

#pragma mark - Compliance SDK: Optional delegate setup using codova supporting APIs
- (void) handleAdminLockAppSecurityActionForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleAdminLockAppSecurityActionForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleAdminLockAppSecurityActionForErrorCallbackId = command.callbackId;
}

- (void) handleAdminWipeAppSecurityActionForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleAdminWipeAppSecurityActionForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleAdminWipeAppSecurityActionForErrorCallbackId = command.callbackId;
}

- (void) handleContainerSelfDestructSecurityActionForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleContainerSelfDestructSecurityActionForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleContainerSelfDestructSecurityActionForErrorCallbackId = command.callbackId;
}

- (void) handleAppDisabledSecurityActionForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleAppDisabledSecurityActionForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleAppDisabledSecurityActionForErrorCallbackId = command.callbackId;
}

- (void) handleDateAndTimeChangeSecurityActionForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleDateAndTimeChangeSecurityActionForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleDateAndTimeChangeSecurityActionForErrorCallbackId = command.callbackId;
}

- (void) handleUserChangeSecurityActionForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleUserChangeSecurityActionForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleUserChangeSecurityActionForErrorCallbackId = command.callbackId;
}

- (void) handleDevicePasscodeComplianceViolationForError:(CDVInvokedUrlCommand*)command {
    [ComplianceSDK sharedInstance].ishandleDevicePasscodeComplianceViolationForErrorDelegateImplemented = YES;
    [ComplianceSDK sharedInstance].handleDevicePasscodeComplianceViolationForErrorCallbackId = command.callbackId;
}

- (void) handleJailbreakComplianceViolationForError:(CDVInvokedUrlCommand*)command {
   [ComplianceSDK sharedInstance].ishandleJailbreakComplianceViolationForErrorDelegateImplemented = YES;
   [ComplianceSDK sharedInstance].handleJailbreakComplianceViolationForErrorCallbackId = command.callbackId; 
}

- (void) handleEDPComplianceViolationForError:(CDVInvokedUrlCommand*)command {
   [ComplianceSDK sharedInstance].ishandleEDPComplianceViolationForErrorDelegateImplemented = YES;
   [ComplianceSDK sharedInstance].handleEDPComplianceViolationForErrorCallbackId = command.callbackId; 
}

- (NSInteger) getComplianceErrorCode:(NSString*) error {
    
    NSInteger complianceErrorCode = CTXMAMComplianceError_Other;
    if ([error isEqualToString:@"CTXMAMCompliance_SecurityAction_AdminAppLock"]) {
        complianceErrorCode = CTXMAMCompliance_SecurityAction_AdminAppLock;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_SecurityAction_AdminAppWipe"]) {
        complianceErrorCode = CTXMAMCompliance_SecurityAction_AdminAppWipe;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_SecurityAction_ContainerSelfDestruct"]) {
        complianceErrorCode = CTXMAMCompliance_SecurityAction_ContainerSelfDestruct;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_SecurityAction_AppDisabled"]) {
        complianceErrorCode = CTXMAMCompliance_SecurityAction_AppDisabled;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_SecurityAction_DateAndTimeChanged"]) {
        complianceErrorCode = CTXMAMCompliance_SecurityAction_DateAndTimeChanged;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_SecurityAction_UserChanged"]) {
        complianceErrorCode = CTXMAMCompliance_SecurityAction_UserChanged;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_Violation_Jailbroken"]) {
        complianceErrorCode = CTXMAMCompliance_Violation_Jailbroken;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_Violation_DevicePasscodeRequired"]) {
        complianceErrorCode = CTXMAMCompliance_Violation_DevicePasscodeRequired;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_Violation_EDP_BlockApp"]) {
        complianceErrorCode = CTXMAMCompliance_Violation_EDP_BlockApp;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_Violation_EDP_WarnUser"]) {
        complianceErrorCode = CTXMAMCompliance_Violation_EDP_WarnUser;
    }
    else if ([error isEqualToString:@"CTXMAMCompliance_Violation_EDP_InformUser"]) {
        complianceErrorCode = CTXMAMCompliance_Violation_EDP_InformUser;
    }
    else {
        complianceErrorCode = CTXMAMComplianceError_Other;
    }
    return complianceErrorCode;
}

@end
