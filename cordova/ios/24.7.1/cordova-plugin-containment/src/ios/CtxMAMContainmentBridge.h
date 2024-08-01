#import <Cordova/CDV.h>

@interface CtxMAMContainmentBridge : CDVPlugin

- (void) initialize:(CDVInvokedUrlCommand*)command;
- (void) appIsOutsideGeofencingBoundary:(CDVInvokedUrlCommand*)command;
- (void) appNeedsLocationServicesEnabled:(CDVInvokedUrlCommand*)command;

@end

