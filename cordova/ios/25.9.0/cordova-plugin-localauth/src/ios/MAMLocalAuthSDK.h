
#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAMLocalAuthSDK : NSObject
+ (MAMLocalAuthSDK *)sharedInstance;

@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

@property (nonatomic, assign) BOOL isMaxOfflinePeriodWillExceedWarningDelegateImplemented;
@property (nonatomic, assign) BOOL isMaxOfflinePeriodExceededDelegateImplemented;
@property (nonatomic, assign) BOOL isDevicePasscodeRequiredDelegateImplemented;

@property(strong, nonatomic) NSString *callbackId_MaxOfflinePeriodWillExceedWarning;
@property(strong, nonatomic) NSString *callbackId_MaxOfflinePeriodExceeded;
@property(strong, nonatomic) NSString *callbackId_DevicePasscodeRequired;

@end

NS_ASSUME_NONNULL_END
