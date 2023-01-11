
#import <Cordova/CDV.h>
#import "CtxMAMLocalAuthBridge.h"
#import "MAMLocalAuthSDK.h"
#import <CTXMAMLocalAuth/CTXMAMLocalAuth.h>
#import <CTXMAMCore/CTXMAMCore.h>

static NSString *const CTXLog_SourceName = @"LocalAuthPlugin";

@interface CtxMAMLocalAuthBridge ()
@end

@implementation CtxMAMLocalAuthBridge

/*!
 @brief Register the delegate to receive Local Auth SDK callbacks.
 */
- (void)initialize:(CDVInvokedUrlCommand*)command
{
    // Setting the local auth SDK delegate
    [CTXMAMLocalAuth setDelegate: (id<CTXMAMLocalAuthSdkDelegate>) [MAMLocalAuthSDK sharedInstance]];
    [MAMLocalAuthSDK sharedInstance].commandDelegate = self.commandDelegate;
    CTXMAMLOG_Info(CTXLog_SourceName, @"Local Auth SDK delegate set.");
}

#pragma mark - Local Auth SDK: Optional delegate setup using codova supporting APIs
- (void) devicePasscodeRequired:(CDVInvokedUrlCommand*)command
{
    [MAMLocalAuthSDK sharedInstance].isDevicePasscodeRequiredDelegateImplemented = true;
    [MAMLocalAuthSDK sharedInstance].callbackId_DevicePasscodeRequired = command.callbackId;
}

- (void) maxOfflinePeriodWillExceedWarning:(CDVInvokedUrlCommand*)command 
{
    [MAMLocalAuthSDK sharedInstance].isMaxOfflinePeriodWillExceedWarningDelegateImplemented = true;
    [MAMLocalAuthSDK sharedInstance].callbackId_MaxOfflinePeriodWillExceedWarning = command.callbackId;
}

- (void) maxOfflinePeriodExceeded:(CDVInvokedUrlCommand*)command 
{
    [MAMLocalAuthSDK sharedInstance].isMaxOfflinePeriodExceededDelegateImplemented = true;
    [MAMLocalAuthSDK sharedInstance].callbackId_MaxOfflinePeriodExceeded = command.callbackId;
}

@end