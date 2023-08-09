/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

/********* Cordova Plugin Implementation for Compliance SDK*******/

#import <Cordova/CDV.h>

@interface CtxMAMComplianceBridge : CDVPlugin 

- (void) initialize:(CDVInvokedUrlCommand*)command;
- (void) checkCompliance:(CDVInvokedUrlCommand*)command;
- (void) performLogonWithErrorContext:(CDVInvokedUrlCommand*)command;
- (void) handleAdminLockAppSecurityActionForError:(CDVInvokedUrlCommand*)command;
- (void) handleAdminWipeAppSecurityActionForError:(CDVInvokedUrlCommand*)command;
- (void) handleContainerSelfDestructSecurityActionForError:(CDVInvokedUrlCommand*)command;
- (void) handleAppDisabledSecurityActionForError:(CDVInvokedUrlCommand*)command;
- (void) handleDateAndTimeChangeSecurityActionForError:(CDVInvokedUrlCommand*)command;
- (void) handleUserChangeSecurityActionForError:(CDVInvokedUrlCommand*)command;
- (void) handleDevicePasscodeComplianceViolationForError:(CDVInvokedUrlCommand*)command;
- (void) handleJailbreakComplianceViolationForError:(CDVInvokedUrlCommand*)command;
- (void) handleEDPComplianceViolationForError:(CDVInvokedUrlCommand*)command;
@end

