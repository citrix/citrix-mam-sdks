
#import <Cordova/CDV.h>
#import "CtxMAMContainmentBridge.h"
#import <CTXMAMContainment/CTXMAMContainment.h>
#import "MAMContainmentSDK.h"
#import <CTXMAMCore/CTXMAMCore.h>

static NSString *const CTXLog_SourceName = @"ContainmentPlugin";

@interface CtxMAMContainmentBridge ()
@end

@implementation CtxMAMContainmentBridge

/*!
 @brief Register the delegate to receive Containment Auth SDK callbacks.
 */
- (void) initialize:(CDVInvokedUrlCommand*)command
{
    // Setting the containment SDK delegate
    [CTXMAMContainment setDelegate:(id<CTXMAMContainmentSdkDelegate>) [MAMContainmentSDK sharedInstance]];
    [MAMContainmentSDK sharedInstance].commandDelegate = self.commandDelegate;
    CTXMAMLOG_Info(CTXLog_SourceName, @"Containment SDK delegate set.");
}

#pragma mark - Containment SDK: Optional delegate setup using codova supporting APIs
- (void) appIsOutsideGeofencingBoundary:(CDVInvokedUrlCommand*)command
{
    [MAMContainmentSDK sharedInstance].isAppIsOutsideGeofencingBoundaryImplemented = true;
    [MAMContainmentSDK sharedInstance].callbackId_AppIsOutsideGeofencingBoundary = command.callbackId;
}

- (void) appNeedsLocationServicesEnabled:(CDVInvokedUrlCommand*)command 
{
    [MAMContainmentSDK sharedInstance].isAppNeedsLocationServicesEnabledImplemented = true;
    [MAMContainmentSDK sharedInstance].callbackId_AppNeedsLocationServicesEnabled = command.callbackId;
}

@end