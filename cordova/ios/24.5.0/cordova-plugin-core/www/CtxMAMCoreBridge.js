var exec = require('cordova/exec');
const MAMCoreClass = 'CtxMAMCoreBridge';

exports.initializeSDKs = function (onInitializeSDKsSuccess, onInitializeSDKsError,...cordovaPlugins) {
    for (var i = 0; i < cordovaPlugins.length; i++) {
            if(cordovaPlugins[i] && cordovaPlugins[i].initialize) {
                cordovaPlugins[i].initialize();
            }
    }
    exec(onInitializeSDKsSuccess, onInitializeSDKsError, MAMCoreClass, 'initializeSDKs');
};

exports.registerProxyServerSettingDetected = function (onProxyServerSettingDetected) {
    exec(onProxyServerSettingDetected, null, MAMCoreClass, 'proxyServerSettingDetected');
};

exports.registerSdksInitializedAndReady = function (onSdksInitializedAndReady) {
    exec(onSdksInitializedAndReady, null, MAMCoreClass, 'sdksInitializedAndReady');
};

exports.getConfigurationForKey = function (config, value, onGetConfigurationForKeySuccess, onGetConfigurationForKeyFailure) {
    const type = getType(value);
    switch (type) {
        case 'Number':
          if (Number.isNaN(value) || !Number.isFinite(value)) {
              throw new TypeError(`Expected a valid, finite numerical value`);
          }
          if (Number.isInteger(value)) {
             exec(onGetConfigurationForKeySuccess, onGetConfigurationForKeyFailure, MAMCoreClass, 'getConfigurationAsIntegerForKey', [config, value]);
          }
          else {
            exec(onGetConfigurationForKeySuccess, onGetConfigurationForKeyFailure, MAMCoreClass, 'getConfigurationAsDoubleForKey', [config, value]);
          }
          break;
        case 'Boolean':
            exec(onGetConfigurationForKeySuccess, onGetConfigurationForKeyFailure, MAMCoreClass, 'getConfigurationAsBoolForKey', [config, value]);
            break;
        case 'String':
            exec(onGetConfigurationForKeySuccess, onGetConfigurationForKeyFailure, MAMCoreClass, 'getConfigurationAsStringForKey', [config, value]);
            break;
        case 'Object':
            exec(onGetConfigurationForKeySuccess, onGetConfigurationForKeyFailure, MAMCoreClass, 'getConfigurationForKey', [config, value]);
            break;
        default:
          throw new TypeError(
            `Unable to retrieve a value that with key ${config} that matches your default value type: ${type}`,
          );
      }
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsStringForKey = function (config, stringValue, onGetConfigurationAsStringForKeySuccess, onGetConfigurationAsStringForKeyFailure) {
    exec(onGetConfigurationAsStringForKeySuccess, onGetConfigurationAsStringForKeyFailure, MAMCoreClass, 'getConfigurationAsStringForKey', [config, stringValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsNumberForKey = function (config, numberValue, onGetConfigurationAsNumberForKeySuccess, onGetConfigurationAsNumberForKeyFailure) {
    exec(onGetConfigurationAsNumberForKeySuccess, onGetConfigurationAsNumberForKeyFailure, MAMCoreClass, 'getConfigurationAsNumberForKey', [config, numberValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsDataForKey = function (config, dataValue, onGetConfigurationAsDataForKeySuccess, onGetConfigurationAsDataForKeyFailure) {
    exec(onGetConfigurationAsDataForKeySuccess, onGetConfigurationAsDataForKeyFailure, MAMCoreClass, 'getConfigurationAsDataForKey', [config, dataValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsDictionaryForKey = function (config, dictValue, onGetConfigurationAsDictionaryForKeySuccess, onGetConfigurationAsDictionaryForKeyFailure) {
    exec(onGetConfigurationAsDictionaryForKeySuccess, onGetConfigurationAsDictionaryForKeyFailure, MAMCoreClass, 'getConfigurationAsDictionaryForKey', [config, dictValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsIntegerForKey = function (config, intValue, onGetConfigurationAsIntegerForKeySuccess, onGetConfigurationAsIntegerForKeyFailure) {
    exec(onGetConfigurationAsIntegerForKeySuccess, onGetConfigurationAsIntegerForKeyFailure, MAMCoreClass, 'getConfigurationAsIntegerForKey', [config, intValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsDoubleForKey = function (config, doubleValue, onGetConfigurationAsDoubleForKeySuccess, onGetConfigurationAsDoubleForKeyFailure) {
    exec(onGetConfigurationAsDoubleForKeySuccess, onGetConfigurationAsDoubleForKeyFailure, MAMCoreClass, 'getConfigurationAsDoubleForKey', [config, doubleValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsBoolForKey = function (config, boolValue, onGetConfigurationAsBoolForKeySuccess, onGetConfigurationAsBoolForKeyFailure) {
    exec(onGetConfigurationAsBoolForKeySuccess, onGetConfigurationAsBoolForKeyFailure, MAMCoreClass, 'getConfigurationAsBoolForKey', [config, boolValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getConfigurationAsObjectForKey = function (config, objectValue, onGetConfigurationAsObjectForKeySuccess, onGetConfigurationAsObjectForKeyFailure) {
    exec(onGetConfigurationAsObjectForKeySuccess, onGetConfigurationAsObjectForKeyFailure, MAMCoreClass, 'getConfigurationAsObjectForKey', [config, objectValue]);
};

exports.setConfigurationForKey = function (config, value, onSetConfigurationForKeySuccess, onSetConfigurationForKeyFailure) {
    const type = getType(value);
    switch (type) {
        case 'Number':
          if (Number.isNaN(value) || !Number.isFinite(value)) {
              throw new TypeError(`Expected a valid, finite numerical value`);
          }
          if (Number.isInteger(value)) {
            exec(onSetConfigurationForKeySuccess, onSetConfigurationForKeyFailure, MAMCoreClass, 'setConfigurationForIntKey', [config, value]);
          }
          else {
            exec(onSetConfigurationForKeySuccess, onSetConfigurationForKeyFailure, MAMCoreClass, 'setConfigurationForDoubleKey', [config, value]);
          }
          break;
        case 'Boolean':
            exec(onSetConfigurationForKeySuccess, onSetConfigurationForKeyFailure, MAMCoreClass, 'setConfigurationForBoolKey', [config, value]);
            break;
        case 'String':
            exec(onSetConfigurationForKeySuccess, onSetConfigurationForKeyFailure, MAMCoreClass, 'setConfigurationForStringKey', [config, value]);
            break;
        case 'Object':
            exec(onSetConfigurationForKeySuccess, onSetConfigurationForKeyFailure, MAMCoreClass, 'setConfigurationForKey', [config, value]);
            break;
        default:
          throw new TypeError(
            `Unable to store a value of type: ${type} in key ${config}`,
          );
      }
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForStringKey = function (config, stringValue, onSetConfigurationForStringKeySuccess, onSetConfigurationForStringKeyFailure) {
    exec(onSetConfigurationForStringKeySuccess, onSetConfigurationForStringKeyFailure, MAMCoreClass, 'setConfigurationForStringKey', [config, stringValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForNumberKey = function (config, numberValue, onSetConfigurationForNumberKeySuccess, onSetConfigurationForNumberKeyFailure) {
    exec(onSetConfigurationForNumberKeySuccess, onSetConfigurationForNumberKeyFailure, MAMCoreClass, 'setConfigurationForNumberKey', [config, numberValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForDataKey = function (config, dataValue, onSetConfigurationForDataKeySuccess, onSetConfigurationForDataKeyFailure) {
    exec(onSetConfigurationForDataKeySuccess, onSetConfigurationForDataKeyFailure, MAMCoreClass, 'setConfigurationForDataKey', [config, dataValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForDictKey = function (config, dictValue, onSetConfigurationForDictKeySuccess, onSetConfigurationForDictKeyFailure) {
    exec(onSetConfigurationForDictKeySuccess, onSetConfigurationForDictKeyFailure, MAMCoreClass, 'setConfigurationForDictKey', [config, dictValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForIntKey = function (config, intValue, onSetConfigurationForIntKeySuccess, onSetConfigurationForIntKeyFailure) {
    exec(onSetConfigurationForIntKeySuccess, onSetConfigurationForIntKeyFailure, MAMCoreClass, 'setConfigurationForIntKey', [config, intValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForDoubleKey = function (config, doubleValue, onSetConfigurationForDoubleKeySuccess, onSetConfigurationForDoubleKeyFailure) {
    exec(onSetConfigurationForDoubleKeySuccess, onSetConfigurationForDoubleKeyFailure, MAMCoreClass, 'setConfigurationForDoubleKey', [config, doubleValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForBoolKey = function (config, boolValue, onSetConfigurationForBoolKeySuccess, onSetConfigurationForBoolKeyFailure) {
    exec(onSetConfigurationForBoolKeySuccess, onSetConfigurationForBoolKeyFailure, MAMCoreClass, 'setConfigurationForBoolKey', [config, boolValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setConfigurationForObjectKey = function (config, objectValue, onSetConfigurationForObjectKeySuccess, onSetConfigurationForObjectKeyFailure) {
    exec(onSetConfigurationForObjectKeySuccess, onSetConfigurationForObjectKeyFailure, MAMCoreClass, 'setConfigurationForObjectKey', [config, objectValue]);
};

exports.removeConfigurationForKey = function (config, onRemoveConfigurationForKeySuccess, onRemoveConfigurationForKeyFailure) {
    exec(onRemoveConfigurationForKeySuccess, onRemoveConfigurationForKeyFailure, MAMCoreClass, 'removeConfigurationForKey', [config]);
};

exports.getSharedConfigurationForKey = function (config, value, onGetSharedConfigurationForKeySuccess, onGetSharedConfigurationForKeyFailure) {
    const type = getType(value);
    switch (type) {
        case 'Number':
          if (Number.isNaN(value) || !Number.isFinite(value)) {
              throw new TypeError(`Expected a valid, finite numerical value`);
          }
          if (Number.isInteger(value)) {
            exec(onGetSharedConfigurationForKeySuccess, onGetSharedConfigurationForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsIntegerForKey', [config, value]);
          }
          else {
            exec(onGetSharedConfigurationForKeySuccess, onGetSharedConfigurationForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsDoubleForKey', [config, value]);
          }
          break;
        case 'Boolean':
            exec(onGetSharedConfigurationForKeySuccess, onGetSharedConfigurationForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsBoolForKey', [config, value]);
            break;
        case 'String':
            exec(onGetSharedConfigurationForKeySuccess, onGetSharedConfigurationForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsStringForKey', [config, value]);
            break;
        case 'Object':
            exec(onGetSharedConfigurationForKeySuccess, onGetSharedConfigurationForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsObjectForKey', [config, value]);
            break;
        default:
          throw new TypeError(
            `Unable to retrieve a value that with key ${config} that matches your default value type: ${type}`,
          );
      }
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsStringForKey = function (config, stringValue, onGetSharedConfigurationAsStringForKeySuccess, onGetSharedConfigurationAsStringForKeyFailure) {
    exec(onGetSharedConfigurationAsStringForKeySuccess, onGetSharedConfigurationAsStringForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsStringForKey', [config, stringValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsNumberForKey = function (config, numberValue, onGetSharedConfigurationAsNumberForKeySuccess, onGetSharedConfigurationAsNumberForKeyFailure) {
    exec(onGetSharedConfigurationAsNumberForKeySuccess, onGetSharedConfigurationAsNumberForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsNumberForKey', [config, numberValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsDataForKey = function (config, dataValue, onGetSharedConfigurationAsDataForKeySuccess, onGetSharedConfigurationAsDataForKeyFailure) {
exec(onGetSharedConfigurationAsDataForKeySuccess, onGetSharedConfigurationAsDataForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsDataForKey', [config, dataValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsDictionaryForKey = function (config, dictValue, onGetSharedConfigurationAsDictionaryForKeySuccess, onGetSharedConfigurationAsDictionaryForKeyFailure) {
    exec(onGetSharedConfigurationAsDictionaryForKeySuccess, onGetSharedConfigurationAsDictionaryForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsDictionaryForKey', [config, dictValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsIntegerForKey = function (config, intValue, onGetSharedConfigurationAsIntegerForKeySuccess, onGetSharedConfigurationAsIntegerForKeyFailure) {
    exec(onGetSharedConfigurationAsIntegerForKeySuccess, onGetSharedConfigurationAsIntegerForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsIntegerForKey', [config, intValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsDoubleForKey = function (config, doubleValue, onGetSharedConfigurationAsDoubleForKeySuccess, onGetSharedConfigurationAsDoubleForKeyFailure) {
    exec(onGetSharedConfigurationAsDoubleForKeySuccess, onGetSharedConfigurationAsDoubleForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsDoubleForKey', [config, doubleValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsBoolForKey = function (config, boolValue, onGetSharedConfigurationAsBoolForKeySuccess, onGetSharedConfigurationAsBoolForKeyFailure) {
    exec(onGetSharedConfigurationAsBoolForKeySuccess, onGetSharedConfigurationAsBoolForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsBoolForKey', [config, boolValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.getSharedConfigurationAsObjectForKey = function (config, objectValue, onGetSharedConfigurationAsObjectForKeySuccess, onGetSharedConfigurationAsObjectForKeyFailure) {
    exec(onGetSharedConfigurationAsObjectForKeySuccess, onGetSharedConfigurationAsObjectForKeyFailure, MAMCoreClass, 'getSharedConfigurationAsObjectForKey', [config, objectValue]);
};

exports.setSharedConfigurationForKey = function (config, value, onSetSharedConfigurationForKeySuccess, onSetSharedConfigurationForKeyFailure) {
    const type = getType(value);
    switch (type) {
        case 'Number':
          if (Number.isNaN(value) || !Number.isFinite(value)) {
              throw new TypeError(`Expected a valid, finite numerical value`);
          }
          if (Number.isInteger(value)) {
            exec(onSetSharedConfigurationForKeySuccess, onSetSharedConfigurationForKeyFailure, MAMCoreClass, 'setSharedConfigurationForIntKey', [config, value]);
          }
          else {
            exec(onSetSharedConfigurationForKeySuccess, onSetSharedConfigurationForKeyFailure, MAMCoreClass, 'setSharedConfigurationForDoubleKey', [config, value]);
          }
          break;
        case 'Boolean':
            exec(onSetSharedConfigurationForKeySuccess, onSetSharedConfigurationForKeyFailure, MAMCoreClass, 'setSharedConfigurationForBoolKey', [config, value]);
            break;
        case 'String':
            exec(onSetSharedConfigurationForKeySuccess, onSetSharedConfigurationForKeyFailure, MAMCoreClass, 'setSharedConfigurationForStringKey', [config, value]);
            break;
        case 'Object':
            exec(onSetSharedConfigurationForKeySuccess, onSetSharedConfigurationForKeyFailure, MAMCoreClass, 'setSharedConfigurationForKey', [config, value]);
            break;
        default:
          throw new TypeError(
            `Unable to store a value of type: ${type} in key ${config}`,
          );
      }
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForStringKey = function (config, stringValue, onSetSharedConfigurationForStringKeySuccess, onSetSharedConfigurationForStringKeyFailure) {
    exec(onSetSharedConfigurationForStringKeySuccess, onSetSharedConfigurationForStringKeyFailure, MAMCoreClass, 'setSharedConfigurationForStringKey', [config, stringValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForNumberKey = function (config, numberValue, onSetSharedConfigurationForNumberKeySuccess, onSetSharedConfigurationForNumberKeyFailure) {
    exec(onSetSharedConfigurationForNumberKeySuccess, onSetSharedConfigurationForNumberKeyFailure, MAMCoreClass, 'setSharedConfigurationForNumberKey', [config, numberValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForDataKey = function (config, dataValue, onSetSharedConfigurationForDataKeySuccess, onSetSharedConfigurationForDataKeyFailure) {
    exec(onSetSharedConfigurationForDataKeySuccess, onSetSharedConfigurationForDataKeyFailure, MAMCoreClass, 'setSharedConfigurationForDataKey', [config, dataValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForDictKey = function (config, dictValue, onSetSharedConfigurationForDictKeySuccess, onSetSharedConfigurationForDictKeyFailure) {
    exec(onSetSharedConfigurationForDictKeySuccess, onSetSharedConfigurationForDictKeyFailure, MAMCoreClass, 'setSharedConfigurationForDictKey', [config, dictValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForIntKey = function (config, intValue, onSetSharedConfigurationForIntKeySuccess, onSetSharedConfigurationForIntKeyFailure) {
    exec(onSetSharedConfigurationForIntKeySuccess, onSetSharedConfigurationForIntKeyFailure, MAMCoreClass, 'setSharedConfigurationForIntKey', [config, intValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForDoubleKey = function (config, doubleValue, onSetSharedConfigurationForDoubleKeySuccess, onSetSharedConfigurationForDoubleKeyFailure) {
    exec(onSetSharedConfigurationForDoubleKeySuccess, onSetSharedConfigurationForDoubleKeyFailure, MAMCoreClass, 'setSharedConfigurationForDoubleKey', [config, doubleValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForBoolKey = function (config, objectValue, onSetSharedConfigurationForBoolKeySuccess, onSetSharedConfigurationForBoolKeyFailure) {
    exec(onSetSharedConfigurationForBoolKeySuccess, onSetSharedConfigurationForBoolKeyFailure, MAMCoreClass, 'setSharedConfigurationForBoolKey', [config, objectValue]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.setSharedConfigurationForObjectKey = function (config, objectValue, onSetSharedConfigurationForObjectKeySuccess, onSetSharedConfigurationForObjectKeyFailure) {
    exec(onSetSharedConfigurationForObjectKeySuccess, onSetSharedConfigurationForObjectKeyFailure, MAMCoreClass, 'setSharedConfigurationForObjectKey', [config, objectValue]);
};

exports.removeSharedConfigurationForKey = function (config, onRemoveSharedConfigurationForKeySuccess, onRemoveSharedConfigurationForKeyFailure) {
    exec(onRemoveSharedConfigurationForKeySuccess, onRemoveSharedConfigurationForKeyFailure, MAMCoreClass, 'removeSharedConfigurationForKey', [config]);
};

exports.getPolicyForKey = function (policy, onGetPolicyForKeySuccess, onGetPolicyForKeyFailure) {
    exec(onGetPolicyForKeySuccess, onGetPolicyForKeyFailure, MAMCoreClass, 'getPolicyValueForKey', [policy]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.initializeCitrixLogger = function (onInitializeCitrixLogger) {
    exec(onInitializeCitrixLogger, null, MAMCoreClass, 'ctxMAMLog_Initialize');
};

exports.getCitrixLogger = function () {
    return {
        info: function(source, message, fileName = '', functionName = '', lineNumber = 0) {exec(null, null, MAMCoreClass,'ctxMAMLog_InfoFrom', [source, message, fileName, functionName, lineNumber])},
        detail: function (source, message, fileName = '', functionName = '', lineNumber = 0) {exec(null, null, MAMCoreClass, 'ctxMAMLog_DetailFrom', [source, message, fileName, functionName, lineNumber])},
        warn: function (source, message, fileName = '', functionName = '', lineNumber = 0) {exec(null, null, MAMCoreClass, 'ctxMAMLog_WarningFrom', [source, message, fileName, functionName, lineNumber])},
        error: function (source, message, fileName = '', functionName = '', lineNumber = 0) {exec(null, null, MAMCoreClass, 'ctxMAMLog_ErrorFrom', [source, message, fileName, functionName, lineNumber])},
        critical: function (source, message, fileName = '', functionName = '', lineNumber = 0) {exec(null, null, MAMCoreClass, 'ctxMAMLog_CriticalErrorFrom', [source, message, fileName, functionName, lineNumber])},
      };
}

/**
 * @deprecated since version 1.0.
 * */
exports.logCriticalError = function (source, message, fileName = '', functionName = '', lineNumber = 0) {
    exec(null, null, MAMCoreClass, 'ctxMAMLog_CriticalErrorFrom', [source, message, fileName, functionName, lineNumber]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.logError = function (source, message, fileName = '', functionName = '', lineNumber = 0) {
    exec(null, null, MAMCoreClass, 'ctxMAMLog_ErrorFrom', [source, message, fileName, functionName, lineNumber]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.logWarning = function (source, message, fileName = '', functionName = '', lineNumber = 0) {
    exec(null, null, MAMCoreClass, 'ctxMAMLog_WarningFrom', [source, message, fileName, functionName, lineNumber]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.logInfo = function (source, message, fileName = '', functionName = '', lineNumber = 0) {
    exec(null, null, MAMCoreClass,'ctxMAMLog_InfoFrom', [source, message, fileName, functionName, lineNumber]);
};

/**
 * @deprecated since version 1.0.
 * */
exports.logDetail = function (source, message, fileName = '', functionName = '', lineNumber = 0) {
    exec(null, null, MAMCoreClass, 'ctxMAMLog_DetailFrom', [source, message, fileName, functionName, lineNumber]);
};

exports.registerForNotifications = function (source, onRegisterForNotifications) {
    var contextId = uuidv4();
    exec(onRegisterForNotifications, null, 'CtxMAMCoreBridge', 'registerForNotifications', [source, contextId]);
    return (onDeRegisterNotifications) => {
        exec(onDeRegisterNotifications, null, 'CtxMAMCoreBridge', 'deregisterNotifications', [source, contextId]);
    }
};

/**
 * @deprecated since version 1.0.
 * */
exports.deregisterNotifications = function (source, contextId, onDeRegisterNotifications) {
    exec(onDeRegisterNotifications, null, 'CtxMAMCoreBridge', 'deregisterNotifications', [source, contextId]);
};

function uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
}

const getType = (val) =>
  val === null
    ? 'Null'
    : val === undefined
    ? 'Undefined'
    : Object.prototype.toString.call(val).slice(8, -1);



