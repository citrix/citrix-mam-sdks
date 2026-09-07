var exec = require('cordova/exec');
const MAMComplianceClass = 'CtxMAMComplianceBridge';


exports.initialize = function () {
    exec(null, null, MAMComplianceClass, 'initialize');
};

exports.checkComplianceErrors = function (onCheckComplianceErrors) {
    exec(onCheckComplianceErrors, null, MAMComplianceClass, 'checkCompliance');
};

exports.performLogonWithErrorContext = function (complianceErrorCode, onPerformLogonWithErrorContext) {
    exec(onPerformLogonWithErrorContext, null, MAMComplianceClass, 'performLogonWithErrorContext', [complianceErrorCode]);
};

exports.registerAdminLockAppSecurityActionForError = function (onAdminLockAppSecurityActionForError) {
    exec(onAdminLockAppSecurityActionForError, null, MAMComplianceClass, 'handleAdminLockAppSecurityActionForError');
};

exports.registerAdminWipeAppSecurityActionForError = function (onAdminWipeAppSecurityActionForError) {
    exec(onAdminWipeAppSecurityActionForError, null, MAMComplianceClass, 'handleAdminWipeAppSecurityActionForError');
};

exports.registerContainerSelfDestructSecurityActionForError = function (onContainerSelfDestructSecurityActionForError) {
    exec(onContainerSelfDestructSecurityActionForError, null, MAMComplianceClass, 'handleContainerSelfDestructSecurityActionForError');
};

exports.registerAppDisabledSecurityActionForError = function (onAppDisabledSecurityActionForError) {
    exec(onAppDisabledSecurityActionForError, null, MAMComplianceClass, 'handleAppDisabledSecurityActionForError');
};

exports.registerDateAndTimeChangeSecurityActionForError = function (onDateAndTimeChangeSecurityActionForError) {
    exec(onDateAndTimeChangeSecurityActionForError, null, MAMComplianceClass, 'handleDateAndTimeChangeSecurityActionForError');
};

exports.registerUserChangeSecurityActionForError = function (onUserChangeSecurityActionForError) {
    exec(onUserChangeSecurityActionForError, null, MAMComplianceClass, 'handleUserChangeSecurityActionForError');
};

exports.registerDevicePasscodeComplianceViolationForError = function (onDevicePasscodeComplianceViolationForError) {
    exec(onDevicePasscodeComplianceViolationForError, null, MAMComplianceClass, 'handleDevicePasscodeComplianceViolationForError');
};

exports.registerJailbreakComplianceViolationForError = function (onJailbreakComplianceViolationForError) {
    exec(onJailbreakComplianceViolationForError, null, MAMComplianceClass, 'handleJailbreakComplianceViolationForError');
};

exports.registerEDPComplianceViolationForError = function (onEDPComplianceViolationForError) {
    exec(onEDPComplianceViolationForError, null, MAMComplianceClass, 'handleEDPComplianceViolationForError');
};
