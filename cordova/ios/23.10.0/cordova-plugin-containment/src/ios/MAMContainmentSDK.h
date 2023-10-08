
#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAMContainmentSDK : NSObject
+ (MAMContainmentSDK *)sharedInstance;

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

@property (nonatomic, assign) BOOL isAppIsOutsideGeofencingBoundaryImplemented;
@property (nonatomic, assign) BOOL isAppNeedsLocationServicesEnabledImplemented;

@property(strong, nonatomic) NSString *callbackId_AppIsOutsideGeofencingBoundary;
@property(strong, nonatomic) NSString *callbackId_AppNeedsLocationServicesEnabled;

@end

NS_ASSUME_NONNULL_END
