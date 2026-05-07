#import <Cordova/CDV.h>

@interface CtxMAMLocalAuthBridge : CDVPlugin

- (void) initialize:(CDVInvokedUrlCommand*)command;
- (void) devicePasscodeRequired:(CDVInvokedUrlCommand*)command;
- (void) maxOfflinePeriodWillExceedWarning:(CDVInvokedUrlCommand*)command;
- (void) maxOfflinePeriodExceeded:(CDVInvokedUrlCommand*)command;


@end
