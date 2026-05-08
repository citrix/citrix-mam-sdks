
#import "MAMContainmentSDK.h"
#import <CTXMAMContainment/CTXMAMContainment.h>

@interface MAMContainmentSDK () <CTXMAMContainmentSdkDelegate>
@end

@implementation MAMContainmentSDK
+ (MAMContainmentSDK *)sharedInstance 
{
    static MAMContainmentSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MAMContainmentSDK alloc] init];
    });
    return instance;
}

- (BOOL) appIsOutsideGeofencingBoundaryWithDefaultHandlerOption 
{
    if (_isAppIsOutsideGeofencingBoundaryImplemented == YES) 
    {
        //Optional delegate for 'appIsOutsideGeofencingBoundary' implemented by the customer
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId_AppIsOutsideGeofencingBoundary];
    }
    return _isAppIsOutsideGeofencingBoundaryImplemented;
}

- (BOOL) appNeedsLocationServicesEnabledWithDefaultHandlerOption 
{
    if (_isAppNeedsLocationServicesEnabledImplemented == YES) 
    {
        //Optional delegate for 'appNeedsLocationServicesEnabled' implemented by the customer
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId_AppNeedsLocationServicesEnabled];
    }
    return _isAppNeedsLocationServicesEnabledImplemented;
}

@end
