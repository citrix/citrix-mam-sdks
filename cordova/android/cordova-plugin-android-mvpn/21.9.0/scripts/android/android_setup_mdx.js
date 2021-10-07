const fs = require('fs');
const path = require('path');

const common = require('../common');
const log = common.log;

/**
 * Sets up project/mdx.json with default wrapping arguments for android
 * builds. Tries to get the keystore and keystore arguments from build.json,
 * but just places an empty string if they aren't specified there.
 */
module.exports = function(context) {
	log();
	log('===== START CREATING mdx.json FILE FOR ANDROID =====', 'cyan');

	process.chdir(context.opts.projectRoot);

	// if project/package.json does not exist here, then this shouldn't be a cordova project
	if (!fs.existsSync(common.PackageJson)) {
		log('No package.json detected. Are you sure this is a Cordova project?', 'red');
		return done();
	}

	// get the default arguments
	let defaultProperties = getMdxWrappingDefaultProperties();
	if (defaultProperties === 0) {
	    return done();
	}
	// store the defaults as the result to use
	let mdxWrappingProperties = defaultProperties;
	// if project/build.json exists, try to get arguments from there
	if (fs.existsSync(common.BuildJson)) {
	    mdxWrappingProperties = readBuildJson(defaultProperties);
	}
	// if there was an issue reading from build.json, restore the last successful object
	if (mdxWrappingProperties === 0) {
	    mdxWrappingProperties = defaultProperties;
	}
	// re-cache the current result
	defaultProperties = mdxWrappingProperties;
	// if we have mdx.json, get any arguments declared there.
	// doing this after the other two methods allows us to keep whatever is
	// defined in mdx.json, but add arguments in case they aren't defined
	if (fs.existsSync(common.MdxJson)) {
	    mdxWrappingProperties = readMdxJson(mdxWrappingProperties);
	}
	// if unsuccessful, restore from the cached object
	if (mdxWrappingProperties === 0) {
	    mdxWrappingProperties = defaultProperties;
	}

	// write the result
	fs.writeFileSync(common.MdxJson, JSON.stringify(mdxWrappingProperties, null, 4));
	return done();
}

function done() {
	log('===== FINISHED CREATING mdx.json FILE FOR ANDROID =====', 'cyan');
	return 0;
}

/**
 * Copies all keys from src to tgt recursively. However, does not delete/override keys from tgt
 * if src does not have them
 * @param {object} src the object to copy values from
 * @param {object} tgt the object to receive values from
 * @returns {object}
 */
function overrideMdxWrappingProperties(src, tgt) {
	// get all of the keys from src
	let keys = Object.keys(src);
	for (let ii = 0; ii < keys.length; ii++) {
		let key = keys[ii];
		// if the field is an object, recursively call this function
		if (typeof src[key] === 'object') {
			tgt[key] = overrideMdxWrappingProperties(src[key], tgt.hasOwnProperty(key) ? tgt[key] : {});
		} else if (typeof tgt[key] !== 'object') {
			// otherwise, copy the value
			tgt[key] = src[key];
		}
	}
	return tgt;
}

/**
 * Adds all values from mdx.json, overriding the values in obj.
 * @param {object} obj the object to build on
 */
function readMdxJson(mdxWrappingProperties) {
	// read from mdx.json
	let mdxJson = JSON.parse(fs.readFileSync(common.MdxJson).toString());
	// if there is no android, just get the other build settings for retention and return out
	if (!mdxJson.hasOwnProperty('android')) {
		obj = overrideMdxWrappingProperties(mdxJson, mdxWrappingProperties);
		return obj;
	}
	// retain mdx.json values and return
	return overrideMdxWrappingProperties(mdxJson, mdxWrappingProperties);
}

/**
 * Tries to read any useful data from build.json.
 * @param {object} obj the object to build on
 */
function readBuildJson(defaultProperties) {
	// get build.json
	let build = JSON.parse(fs.readFileSync(common.BuildJson).toString());
	// if no android values, we don't care what's here so quit
	if (!build.hasOwnProperty('android')) {
	    return defaultProperties;
	}
	// for convenience
	build = build['android'];

	let release = {};
	let debug = {};

	if (build.hasOwnProperty('debug')) {
		let mdxDebugProperties = build['debug'];
		// i ask you a question. if you answer correctly, i'm content
		if (mdxDebugProperties.hasOwnProperty('keystore')) {
		    debug['keystore'] = mdxDebugProperties['keystore'];
		}
		if (mdxDebugProperties.hasOwnProperty('storePassword')) {
		    debug['storePassword'] = mdxDebugProperties['storePassword'];
		}
		if (mdxDebugProperties.hasOwnProperty('alias')) {
		    debug['alias'] = mdxDebugProperties['alias'];
		}
		if (mdxDebugProperties.hasOwnProperty('password')) {
		    debug['password'] = mdxDebugProperties['password'];
		}
	}
	if (build.hasOwnProperty('release')) {
		let mdxReleaseProperties = build['release'];
		if (mdxReleaseProperties.hasOwnProperty('keystore')) {
		    release['keystore'] = mdxReleaseProperties['keystore'];
		}
		if (mdxReleaseProperties.hasOwnProperty('storePassword')) {
		    release['storePassword'] = mdxReleaseProperties['storePassword'];
		}
		if (mdxReleaseProperties.hasOwnProperty('alias')) {
		    release['alias'] = mdxReleaseProperties['alias'];
		}
		if (mdxReleaseProperties.hasOwnProperty('password')) {
		    release['password'] = mdxReleaseProperties['password'];
		}
	}

	// store the values
	defaultProperties['android']['debug'] = overrideMdxWrappingProperties(debug, defaultProperties['android']['debug']);
	defaultProperties['android']['release'] = overrideMdxWrappingProperties(release, defaultProperties['android']['release']);

	return defaultProperties;
}

/**
 * Returns the default values of an mdx.json file that only contains android options
 */
function getMdxWrappingDefaultProperties() {
	let pkg = JSON.parse(fs.readFileSync(common.PackageJson).toString());
	if (!pkg.hasOwnProperty('name')) {
		log('No app identifier defined in package.json. Are you sure this is a Cordova project?', 'red');
		return 0;
	}
	let app_id = pkg['name'];
	// just a quite note: I don't declare run, since it's implied to be true. But you can change that if you want :)
	return {
		'android': {
			'debug': {
				'wrapper': 'platforms/android/app/src/main/mdx/managed-app-utility.jar',
				'wrapCommand': 'wrap',
				'appType': 'sdkapp',
				'storeUrl': `https://play.google.com/store/apps/details?id=${app_id}`,
				'keystore': '',
				'storePassword': '',
				'alias': '',
				'password': '',
				'apk': 'platforms/android/app/build/outputs/apk/debug/app-debug.apk',
				'mdx': 'mdx/android-debug.mdx',
			},
			'release': {
				'wrapper': 'platforms/android/app/src/main/mdx/managed-app-utility.jar',
                'wrapCommand': 'wrap',
                'appType': 'sdkapp',
                'storeUrl': `https://play.google.com/store/apps/details?id=${app_id}`,
				'keystore': '',
				'storePassword': '',
				'alias': '',
				'password': '',
				'apk': 'platforms/android/app/build/outputs/apk/release/app-release.apk',
				'mdx': 'mdx/android-release.mdx',
			}
		}
	}
}
