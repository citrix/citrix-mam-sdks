const fs = require('fs');
const path = require('path');

const common = require('../common');
const log = common.log;
var nopt = require('nopt');
/**
 * This hook generates the .mdx file based on the preferences declared in project/mdx.json.
 * Currently it requires all arguments to be declared in the mdx.json
 * file. If an argument is not declared, it prints an error message
 * indicating the missing value and exits, not creating the mdx. The
 * only exception to this is the "run" setting, which is a boolean.
 * In the absence of this setting, the script assumes "true", and
 * so runs the mdx script
 */
module.exports = function(context) {
	log();
	log('===== CREATING MDX FOR ANDROID =====', 'cyan');

	process.chdir(context.opts.projectRoot);

	options = context.opts.options || {};
        options.argv = nopt({
            mdxJarPath: path,
            inputApk: path,
            outputMdx: path,
            appType: String,
            storeUrl: String,
            keystore: path,
            storePassword: String,
            alias: String,
            password: String,
            keystoreType: String
        }, {}, options.argv, 0);

	/** @type {'debug'|'release'} */
	let mode = getBuildVariant(context);

	// the values of the mdx.json file
	let mdx = JSON.parse(fs.readFileSync(common.MdxJson).toString());

	// if the user doesn't have any android preferences, then we cannot do anything
	if (!mdx.hasOwnProperty('android')) {
		log('No android options defined for mdx wrapping. Cannot create mdx file', 'red');
		return done();
	}

	// always prefer the settings for the current build mode (debug or release).
	let mdxJsonParams = mdx['android'][mode];
	if (mdxJsonParams.hasOwnProperty('run')) {
		if (mdxJsonParams['run'] == false) {
			log(`Run flag set to false for ${mode} in mdx.json. Not generating mdx...`, 'yellow');
			done();
		}
	}

	// spawnSync requires the cli program to be the first argument to the function, and the
	// second function argument is a string array with the rest of the cli arguments.
	let cmd = 'java';
	// we're running the wrapper jar. The rest of the args are args to the wrapper
	let args = [
		'-jar', getMdxWrappingProperty(options.argv.mdxJarPath, mdxJsonParams, 'wrapper'),
		        getMdxWrappingProperty('wrap', mdxJsonParams, 'wrapCommand'),
		'-in',  platformRelativePath(getMdxWrappingProperty(options.argv.inputApk, mdxJsonParams, 'apk')),
		'-out', platformRelativePath(getMdxWrappingProperty(options.argv.outputMdx, mdxJsonParams, 'mdx')),
		'-appType', getMdxWrappingProperty(options.argv.appType, mdxJsonParams, 'appType'),
		'-storeUrl', getMdxWrappingProperty(options.argv.storeUrl, mdxJsonParams, 'storeUrl'),
		'-keystore', getMdxWrappingProperty(options.argv.keystore, mdxJsonParams,  'keystore'),
		'-storepass', getMdxWrappingProperty(options.argv.storePassword, mdxJsonParams, 'storePassword'),
		'-keyalias', getMdxWrappingProperty(options.argv.alias, mdxJsonParams, 'alias'),
		'-keypass', getMdxWrappingProperty(options.argv.password, mdxJsonParams, 'password'),
	];

	// if we receive invalid input in any of the args, flip this flag
	let is_err = false;
	args.forEach((val, _i, _a) => {
		// getMdxWrappingProperty returns 0 if an arg isn't listed
		// and platformize_path returns 0 if its arg isn't a string
		// we don't need to print any logs here since get_fatal... does so for us
		if (val === 0) {
		    is_err = true;
		}
	});
	if (is_err) {
	    log(`### Sample mdx.json file as shown below ####`, 'cyan');
	    log(`   {
                 "android": {
                     "debug": {
                         "wrapper": "platforms/android/app/src/main/mdx/managed-app-utility.jar",
                         "wrapCommand": "wrap",
                         "appType": "sdkapp",
                         "storeUrl": "https://play.google.com/store/apps/details?id=com.citrix.cordova.testapp",
                         "keystore": "mdx/debug.keystore",
                         "storePassword": "android",
                         "alias": "androiddebugkey",
                         "password": "android",
                         "apk": "platforms/android/app/build/outputs/apk/debug/app-debug.apk",
                         "mdx": "mdx/android-debug.mdx"
                     },
                     "release": {
                         "wrapper": "platforms/android/app/src/main/mdx/managed-app-utility.jar",
                         "wrapCommand": "wrap",
                         "appType": "sdkapp",
                         "storeUrl": "https://play.google.com/store/apps/details?id=com.citrix.cordova.testapp",
                         "keystore": "<Enter Release Keystore Here>",
                         "storePassword": "<Enter Store Password Here>",
                         "alias": "<Enter Key Alias Here>",
                         "password": "<Enter Key Password Here>",
                         "apk": "platforms/android/app/build/outputs/apk/release/app-release.apk",
                         "mdx": "mdx/android-release.mdx"
                     }
                 }
             }`, 'cyan');
	    return done();
	}

	// print what we are executing
	log(`${cmd} ${args.join(' ')}`);

	// run the full command
	let res = require('child_process').spawnSync(cmd, args);
	// print the stdout of the wrapper
	log(res.stdout.toString());

	// get the return value of the command
	let rv = res.status;
	// if the wrapper successfully wrapped, we are golden
	if (rv === 0) {
	    log('Successfully generated mdx', 'green');
	} else {
		// otherwise, we should print stderr so the user can easily see
        // what any errors are
		log('Could not successfully generate mdx', 'red');
		log('~~~~~ STDERR ~~~~~', 'red');
		log(res.stdout.toString(), 'red');
	}
	return done();
}

function done() {
	log('===== DONE CREATING MDX FOR ANDROID =====', 'cyan');
	return 0;
}

/**
 * Uses highly complex and very unintuitive algorithm for determining
 * the form of build the user is creating, either 'debug' or 'release'.
 * @param {object} context the context from cordova
 * @returns {'debug'|'release'}
 */
function getBuildVariant(context) {
	if (context.cmdLine.indexOf('release') >= 0) {
	    return 'release';
	}
	return 'debug';
}

/**
 * Returns the value of a field given a preferred and fallback object.
 * If it doesn't exist or is empty, returns 0.
 * @param {object} cliOption is the preferred object
 * @param {object} buildJsonParams the fallback object
 * @param {string} name the name of the field to get
 * @returns {string|0} the value of the field, or 0 if it does not exist or is empty
 */
function getMdxWrappingProperty(cliOption, mdxJsonParams, name, cordovaName) {
	 if(!!cliOption) {
	    return cliOption;
	} else if (mdxJsonParams.hasOwnProperty(name) && mdxJsonParams[name] !== '') {
        return mdxJsonParams[name];
    } else if(!!process.env[name]) {
        return process.env[name];
    }
	log(`${name} not defined. Either pass the --${name}=<value> as command line argument or update the value inside build.json or mdx.json file!`, 'red');
	return 0;
}

/**
 * This method returns platform specific path. For example, on Windows, if the input is
 * '/hello/world', then this will return 'C:/hello/world'. Likewise
 * will be viceversa in the opposite scenario.
 * @param {string} the path to platformize
 * @returns {string|0}
 */
function platformRelativePath(pp) {
	if (typeof pp !== 'string') return 0;
	// we need to respect absolution
	let is_absolute = path.isAbsolute(pp);
	let absolute_base;
	if (process.platform === 'win32') {
		// since Windows is special, we need to get the drive letter
		absolute_base = pp.split('\\')[0];
	} else {
		// pretty much every other possible platform uses / as root
		absolute_base = '/';
	}
	// split using both / and \ as delimiters
	let tmp = pp.split(/\\\//);
	// recreate the path using current platform's delimiters
	let res = path.join(...tmp);
	// return the normalized path (ie foo/bar/baz/.. becomes foo/bar)
	if (is_absolute) {
		res = path.join(absolute_base, res);
	}
	return path.normalize(res);
}
