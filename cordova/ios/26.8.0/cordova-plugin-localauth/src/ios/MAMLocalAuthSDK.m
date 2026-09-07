
#import "MAMLocalAuthSDK.h"
#import <CTXMAMLocalAuth/CTXMAMLocalAuth.h>

@interface MAMLocalAuthSDK () <CTXMAMLocalAuthSdkDelegate>
@end

@implementation MAMLocalAuthSDK
+ (MAMLocalAuthSDK *)sharedInstance
{
    static MAMLocalAuthSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MAMLocalAuthSDK alloc] init];
    });
    return instance;
}

#pragma mark - Local Auth SDK: Optional delegates
- (BOOL) maxOfflinePeriodWillExceedWarning:(NSTimeInterval) secondsToExpire 
{
    if (_isMaxOfflinePeriodWillExceedWarningDelegateImplemented == YES) 
    {
        //Optional delegate for 'maxOfflinePeriodWillExceedWarning' implemented by the customer
        // Timeinterval in seconds is being sent via callback to the cordova app.
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK  messageAsDouble:secondsToExpire];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId_MaxOfflinePeriodWillExceedWarning];
    }
    return _isMaxOfflinePeriodWillExceedWarningDelegateImplemented;
}

- (BOOL) maxOfflinePeriodExceeded 
{
    if (_isMaxOfflinePeriodExceededDelegateImplemented == YES) 
    {
        //Optional delegate for 'maxOfflinePeriodExceeded' implemented by the customer
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId_MaxOfflinePeriodExceeded];
    }
    return _isMaxOfflinePeriodExceededDelegateImplemented;
}

- (BOOL) devicePasscodeRequired 
{
    if (_isDevicePasscodeRequiredDelegateImplemented == YES) 
    {
        //Optional delegate for 'devicePasscodeRequired' implemented by the customer
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId_DevicePasscodeRequired];
    }
    return _isDevicePasscodeRequiredDelegateImplemented;
}

@end
