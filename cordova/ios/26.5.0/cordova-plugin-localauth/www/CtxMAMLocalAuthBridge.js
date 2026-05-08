var exec = require('cordova/exec');

exports.initialize = function () {
    exec(null, null, 'CtxMAMLocalAuthBridge', 'initialize');
};

exports.registerDevicePasscodeRequired = function (onDevicePasscodeRequired) {
    exec(onDevicePasscodeRequired, null, 'CtxMAMLocalAuthBridge', 'devicePasscodeRequired');
};

exports.registerMaxOfflinePeriodWillExceedWarning = function (onMaxOfflinePeriodWillExceedWarning) {
    exec(onMaxOfflinePeriodWillExceedWarning, null, 'CtxMAMLocalAuthBridge', 'maxOfflinePeriodWillExceedWarning');
};

exports.registerMaxOfflinePeriodExceeded = function (onMaxOfflinePeriodExceeded) {
    exec(onMaxOfflinePeriodExceeded, null, 'CtxMAMLocalAuthBridge', 'maxOfflinePeriodExceeded');
};

