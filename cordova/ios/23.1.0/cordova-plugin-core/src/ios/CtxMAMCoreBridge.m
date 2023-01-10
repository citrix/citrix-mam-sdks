/*
Copyright (c) Citrix Systems, Inc.
All rights reserved.
Use and support of this software is governed by the terms
and conditions of the software license agreement and support
policy of Citrix Systems, Inc. and/or its subsidiaries.
*/

#import "CtxMAMCoreBridge.h"
#import <CTXMAMCore/CTXMAMCore.h>
#import "MAMCoreSDK.h"

static NSString *const CTXLog_SourceName = @"CorePlugin";
static NSString *const kCoreErrorCode = @"errorCode";
static NSString *const kCoreUserInfoMsg = @"errorMessage";

static NSMutableDictionary *registeredEventBlocks = nil;

@interface CtxMAMCoreBridge ()
@end

@implementation CtxMAMCoreBridge

- (void) initializeSDKs:(CDVInvokedUrlCommand*)command {
    CTXMAMLOG_Info(CTXLog_SourceName, @"Core SDK delegate set.");
    [CTXMAMCore setDelegate:(id<CTXMAMCoreSdkDelegate>) [MAMCoreSDK sharedInstance]]; //TODO: nonnull check or log

    CTXMAMLOG_Info(CTXLog_SourceName, @"Invoking initialized sdks from plugin.");
    __block CDVPluginResult* result;
    [CTXMAMCore initializeSDKsWithCompletionBlock: ^(NSError * nilOrError) {
        CTXMAMLOG_Info(CTXLog_SourceName, @"initializeSDKsWithCompletionBlock nilOrError : %@",[nilOrError localizedDescription]);
        if (!nilOrError) {
           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        else {
           NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(nilOrError.code), kCoreUserInfoMsg : nilOrError.localizedDescription};
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
        }
    }];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

#pragma mark - Core SDK: Optional delegate setup using codova supporting APIs
- (void) proxyServerSettingDetected:(CDVInvokedUrlCommand*)command {
    [MAMCoreSDK sharedInstance].isProxyServerSettingDelegateImplemented = YES;
    [MAMCoreSDK sharedInstance].proxyServerSettingDelegateCallbackId = command.callbackId;
}

- (void) sdksInitializedAndReady:(CDVInvokedUrlCommand*)command {
    [MAMCoreSDK sharedInstance].isSdksInitializedAndReadyDelegateImplemented = YES;
    [MAMCoreSDK sharedInstance].sdksInitializedAndReadyDelegateCallbackId = command.callbackId;
}

#pragma mark Local Configuration Storage APIs
- (void) getConfigurationForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id defaultValue = [command.arguments objectAtIndex:1];
    id idResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsObjectForKey:config defaultValue:defaultValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:idResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsStringForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSString* stringValue = [command.arguments objectAtIndex:1];
    NSString* stringResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsStringForKey:config defaultValue:stringValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:stringResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsNumberForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* numberValue = [numberFormatter numberFromString:[command.arguments objectAtIndex:1]];
    NSNumber* numberResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsNumberForKey:config defaultValue:numberValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:numberResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsDataForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSData* dataValue = [[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    NSData* dataResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsDataForKey:config defaultValue:dataValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:dataResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsDictionaryForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    NSDictionary* dictValue = [array objectAtIndex:0];
    NSDictionary* dictionaryResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsDictionaryForKey:config defaultValue:dictValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:dictionaryResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsIntegerForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSInteger intValue = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger integerResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsIntegerForKey:config defaultValue:intValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:integerResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsDoubleForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    double doubleValue = [[command.arguments objectAtIndex:1] doubleValue];
    double doubleResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsDoubleForKey:config defaultValue:doubleValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:doubleResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsBoolForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    BOOL boolValue = [[command.arguments objectAtIndex:1] boolValue];
    BOOL boolResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsBoolForKey:config defaultValue:boolValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:boolResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getConfigurationAsObjectForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id objectValue = [command.arguments objectAtIndex:1];
    id idResult = [[CTXMAMConfigManager sharedConfigManager] getConfigurationAsObjectForKey:config defaultValue:objectValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:idResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id objectValue = [command.arguments objectAtIndex:1];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config objectValue:objectValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForStringKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSString* stringValue = [command.arguments objectAtIndex:1];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config stringValue:stringValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForNumberKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* numberValue = [numberFormatter numberFromString:[command.arguments objectAtIndex:1]];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config numberValue:numberValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForDataKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSData* dataValue = [[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config dataValue:dataValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForDictKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    NSDictionary* dictValue = [array objectAtIndex:0];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config dictValue:dictValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForIntKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSInteger intValue = [[command.arguments objectAtIndex:1] integerValue];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config intValue:intValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForDoubleKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    double doubleValue = [[command.arguments objectAtIndex:1] doubleValue];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config doubleValue:doubleValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForBoolKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    BOOL boolValue = [[command.arguments objectAtIndex:1] boolValue];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config boolValue:boolValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setConfigurationForObjectKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id objectValue = [command.arguments objectAtIndex:1];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setConfigurationForKey:config objectValue:objectValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) removeConfigurationForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id returnVal = [[CTXMAMConfigManager sharedConfigManager] removeConfigurationForKey:config outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

#pragma mark Shared Configuration Storage APIs
- (void) getSharedConfigurationForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id defaultValue = [command.arguments objectAtIndex:1];
    id idResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsObjectForKey:config defaultValue:defaultValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:idResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsStringForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSString* stringValue = [command.arguments objectAtIndex:1];
    NSString* stringResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsStringForKey:config defaultValue:stringValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else{
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:stringResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsNumberForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* numberValue = [numberFormatter numberFromString:[command.arguments objectAtIndex:1]];
    NSNumber* numberResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsNumberForKey:config defaultValue:numberValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else { 
        NSArray* arrayObject = [NSArray arrayWithObject:numberResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsDataForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSData* dataValue = [[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    NSData* dataResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsDataForKey:config defaultValue:dataValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:dataResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsDictionaryForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    NSDictionary* dictValue = [array objectAtIndex:0];
    NSDictionary* dictionaryResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsDictionaryForKey:config defaultValue:dictValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:dictionaryResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsIntegerForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSInteger intValue = [[command.arguments objectAtIndex:1] integerValue];
    NSInteger integerResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsIntegerForKey:config defaultValue:intValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:integerResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsDoubleForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSInteger defaultValue = [[command.arguments objectAtIndex:1] doubleValue];
    double doubleResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsDoubleForKey:config defaultValue:defaultValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:doubleResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsBoolForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    BOOL defaultValue = [[command.arguments objectAtIndex:1] boolValue];
    BOOL boolResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsBoolForKey:config defaultValue:defaultValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:boolResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) getSharedConfigurationAsObjectForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id objectValue = [command.arguments objectAtIndex:1];
    id idResult = [[CTXMAMConfigManager sharedConfigManager] getSharedConfigurationAsObjectForKey:config defaultValue:objectValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        NSArray* arrayObject = [NSArray arrayWithObject:idResult];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsMultipart:arrayObject];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id objectValue = [command.arguments objectAtIndex:1];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config objectValue:objectValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForStringKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSString* stringValue = [command.arguments objectAtIndex:1];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config stringValue:stringValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForNumberKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* numberValue = [numberFormatter numberFromString:[command.arguments objectAtIndex:1]];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config numberValue:numberValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForDataKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSData* dataValue = [[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config dataValue:dataValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForDictKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[[command.arguments objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    NSDictionary* dictValue = [array objectAtIndex:0];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config dictValue:dictValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForIntKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    NSInteger intValue = [[command.arguments objectAtIndex:1] integerValue];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config intValue:intValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForDoubleKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    double doubleValue = [[command.arguments objectAtIndex:1] doubleValue];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config doubleValue:doubleValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForBoolKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    BOOL boolValue = [[command.arguments objectAtIndex:1] boolValue];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config boolValue:boolValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setSharedConfigurationForObjectKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id objectValue = [command.arguments objectAtIndex:1];
    BOOL returnVal = [[CTXMAMConfigManager sharedConfigManager] setSharedConfigurationForKey:config objectValue:objectValue outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) removeSharedConfigurationForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* config = [command.arguments objectAtIndex:0];
    id returnVal = [[CTXMAMConfigManager sharedConfigManager] removeSharedConfigurationForKey:config outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:returnVal];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
#pragma mark Custom Policy APIs
- (void) getPolicyValueForKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = nil;
    NSError* err = nil;
    NSString* policy = [command.arguments objectAtIndex:0];
    id idResult = [[CTXMAMConfigManager sharedConfigManager] getPolicyValueForKey:policy outError:&err];
    if (err) {
        NSDictionary* errorInfoDict = @{ kCoreErrorCode : @(err.code), kCoreUserInfoMsg : err.localizedDescription};
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorInfoDict];
    }
    else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:idResult];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ctxMAMLog_Initialize:(CDVInvokedUrlCommand*)command {
    [CTXMAMLogger CTXMAMLog_Initialize];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    CTXMAMLOG_Info(CTXLog_SourceName, @"Citrix Logger Initialized");
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ctxMAMLog_CriticalErrorFrom:(CDVInvokedUrlCommand*)command {
    NSString* source = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    NSString* fileName = [command.arguments objectAtIndex:2];
    NSString* functionName = [command.arguments objectAtIndex:3];
    int lineNumber = [[command.arguments objectAtIndex:4] intValue];
    
    [CTXMAMLogger CTXMAMLog_CriticalErrorFrom:source andFile:fileName andFunction:functionName atLine:lineNumber withFormat:message];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ctxMAMLog_ErrorFrom:(CDVInvokedUrlCommand*)command {
    NSString* source = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    NSString* fileName = [command.arguments objectAtIndex:2];
    NSString* functionName = [command.arguments objectAtIndex:3];
    int lineNumber = [[command.arguments objectAtIndex:4] intValue];
    
    [CTXMAMLogger CTXMAMLog_ErrorFrom:source andFile:fileName andFunction:functionName atLine:lineNumber withFormat:message];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ctxMAMLog_WarningFrom:(CDVInvokedUrlCommand*)command {
    NSString* source = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    NSString* fileName = [command.arguments objectAtIndex:2];
    NSString* functionName = [command.arguments objectAtIndex:3];
    int lineNumber = [[command.arguments objectAtIndex:4] intValue];
    
    [CTXMAMLogger CTXMAMLog_WarningFrom:source andFile:fileName andFunction:functionName atLine:lineNumber withFormat:message];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ctxMAMLog_InfoFrom:(CDVInvokedUrlCommand*)command {
    NSString* source = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    NSString* fileName = [command.arguments objectAtIndex:2];
    NSString* functionName = [command.arguments objectAtIndex:3];
    int lineNumber = [[command.arguments objectAtIndex:4] intValue];
    
    [CTXMAMLogger CTXMAMLog_InfoFrom:source andFile:fileName andFunction:functionName atLine:lineNumber withFormat:message];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) ctxMAMLog_DetailFrom:(CDVInvokedUrlCommand*)command {
    NSString* source = [command.arguments objectAtIndex:0];
    NSString* message = [command.arguments objectAtIndex:1];
    NSString* fileName = [command.arguments objectAtIndex:2];
    NSString* functionName = [command.arguments objectAtIndex:3];
    int lineNumber = [[command.arguments objectAtIndex:4] intValue];
    
    [CTXMAMLogger CTXMAMLog_DetailFrom:source andFile:fileName andFunction:functionName atLine:lineNumber withFormat:message];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

#pragma mark Notification methods

-(void)registerForNotifications:(CDVInvokedUrlCommand*)command {
    NSString* source = [command.arguments objectAtIndex:0];
    NSString* contextId = [command.arguments objectAtIndex:1];
    __block NSString* notificationCallbackId = command.callbackId;
    [self initRegisteredEventsBlocks];
    
    CTXMAMNotificationEventBlock notificationCallback = ^(CTXMAMNotification * _Nonnull notification)
    {
        NSMutableDictionary *notificationCallbackDict = [NSMutableDictionary dictionary];

        notificationCallbackDict[@"source"] = notification.Source;
        notificationCallbackDict[@"message"] = notification.Message;
        notificationCallbackDict[@"errorCode"] = [NSNumber numberWithInteger:notification.Error.code];
        notificationCallbackDict[@"errorDomain"] = notification.Error.domain;
        notificationCallbackDict[@"errorLocalizedDescription"] = notification.Error.localizedDescription;
        notificationCallbackDict[@"errorLocalizedFailureReason"] = notification.Error.localizedFailureReason;
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:notificationCallbackDict];
        [self.commandDelegate sendPluginResult:result callbackId:notificationCallbackId];
    };
    
    [self registerEventBlocks:contextId callBackBlock:(CTXMAMNotificationEventBlock) notificationCallback];
    
    [[CTXMAMNotificationCenter mainNotificationCenter] registerForNotificationsFromSource:source usingNotificationBlock:[registeredEventBlocks objectForKey:contextId]];
}

-(void)deregisterNotifications:(CDVInvokedUrlCommand*)command {
    NSString* source = command.arguments[0];
    NSString* contextId = [command.arguments objectAtIndex:1];
    CDVPluginResult* result = nil;
    CTXMAMNotificationEventBlock eventBlock = [self deregisterEventBlock:contextId];
    if (eventBlock != nil) {
        [[CTXMAMNotificationCenter mainNotificationCenter] deregisterBlock:eventBlock forNotificationsFromSource:source];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void)registerEventBlocks:(NSString*)contextId callBackBlock:(CTXMAMNotificationEventBlock) notificationBlock {
    [registeredEventBlocks setObject:notificationBlock forKey:contextId];
}

- (CTXMAMNotificationEventBlock) deregisterEventBlock:(NSString*) contextId {
    if (registeredEventBlocks != nil) {
        CTXMAMNotificationEventBlock callBackBlock = [registeredEventBlocks objectForKey:contextId];
        [registeredEventBlocks removeObjectForKey:contextId];
        return callBackBlock;
    }
    return nil;
}

-(void)initRegisteredEventsBlocks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registeredEventBlocks = [[NSMutableDictionary alloc] init];
    });
}
@end
