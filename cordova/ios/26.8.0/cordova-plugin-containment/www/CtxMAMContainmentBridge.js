var exec = require('cordova/exec');

exports.initialize = function () {
    exec(null, null, 'CtxMAMContainmentBridge', 'initialize');
};

exports.registerAppIsOutsideGeofencingBoundary = function (onAppIsOutsideGeofencingBoundary) {
    exec(onAppIsOutsideGeofencingBoundary, null, 'CtxMAMContainmentBridge', 'appIsOutsideGeofencingBoundary');
};

exports.registerAppNeedsLocationServicesEnabled = function (onAppNeedsLocationServicesEnabled) {
    exec(onAppNeedsLocationServicesEnabled, null, 'CtxMAMContainmentBridge', 'appNeedsLocationServicesEnabled');
};

