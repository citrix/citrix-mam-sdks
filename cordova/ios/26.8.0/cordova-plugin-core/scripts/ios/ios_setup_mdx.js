const fs = require('fs');
const path = require('path');

const common = require('../common');
const log = common.log;

/**
 * Sets up mdx.json with the minimum required settings to 
 * generate an mdx file.
 */
module.exports = function(context) {
	log('===== START CREATING mdx.json FILE FOR IOS =====', 'cyan');
	process.chdir(context.opts.projectRoot);
	if (!fs.existsSync(common.PackageJson)) {
		log('No package.json detected. Are you sure this is a Cordova project?');
		return done();
	}

	let the_default = get_default();

	if (the_default === 0) return done();
	let result = the_default;
	if (fs.existsSync(common.BuildJson)) result = read_build(result);
	if (result === 0) result = the_default;
	the_default = result;
	if (fs.existsSync(common.MdxJson)) result = read_mdx(result);
	if (result === 0) result = the_default;
	result = cleanup(result);
	if (result === 0) return done();
	// write the result
	fs.writeFileSync(common.MdxJson, JSON.stringify(result, null, 4));
	return done();
}

function done() {
	log('===== FINISHED CREATING mdx.json FILE FOR IOS =====', 'cyan');
	return 0;
}

/**
 * @param {object} obj 
 * @returns {object|0} 
 */
function cleanup(obj) {
	if (!(
		obj.hasOwnProperty('ios')
		&& (obj['ios'].hasOwnProperty('default')
		&& obj['ios'].hasOwnProperty('debug')
		&& obj['ios'].hasOwnProperty('release'))
	)) {
		log('Corruption detected creating mdx file...', 'red');
		return 0;
	}

	let keys = [
		'toolkit_dir',
		'appType',
		'storeUrl',
		'app',
		'mdx',
		'packageId',
		'entitlements',
		'appIdPrefix',
		'minPlatform'
	];

	let dbg = obj['ios']['debug'];
	let rls = obj['ios']['release'];

	for (let ii = 0; ii < keys.length; ii++) {
		let key = keys[ii];

		let dbg_val = dbg.hasOwnProperty(key) ? dbg[key] : '';
		let rls_val = rls.hasOwnProperty(key) ? rls[key] : '';

		let is_keep_default = false;
		if (dbg_val === '') {
			delete obj['ios']['debug'][key];
			is_keep_default = true;
		}
		if (rls_val === '') {
			delete obj['ios']['release'][key];
			is_keep_default = true;
		}
		if (is_keep_default) continue;

		if (dbg_val === rls_val) {
			obj['ios']['default'][key] = dbg_val;
			delete obj['ios']['debug'][key];
			delete obj['ios']['release'][key];
		}
		else if (obj['ios']['default'][key] === '') delete obj['ios']['default'][key];
	}
	return obj;
}

/**
 * @param {object} src 
 * @param {object} tgt
 * @returns {object}
 */
function override_props_but_retain(src, tgt) {
	let keys = Object.keys(src);
	for (let ii = 0; ii < keys.length; ii++) {
		let key = keys[ii];
		if (typeof src[key] === 'object') {
			tgt[key] = override_props_but_retain(src[key], tgt.hasOwnProperty(key) ? tgt[key]: {});
		} else if (typeof tgt[key] !== 'object') {
			tgt[key] = src[key];
		}
	}
	return tgt;
}

function read_mdx(obj) {
	let mdx = JSON.parse(fs.readFileSync(common.MdxJson).toString());
	if (!mdx.hasOwnProperty('ios')) {
		obj = override_props_but_retain(mdx, obj);
		return obj;
	}

	if (mdx['ios'].hasOwnProperty('default')) {
		let keys = Object.keys(mdx['ios']['default']);
		for (let ii = 0; ii < keys.length; ii++) {
			let key = keys[ii];
			if (mdx['ios']['default'][key] !== '') {
				delete obj['ios']['debug'][key];
				delete obj['ios']['release'][key];
			}
		}
	}

	return override_props_but_retain(mdx, obj);
}

function read_build(obj) {
	let build = JSON.parse(fs.readFileSync(common.BuildJson).toString());
	if (!build.hasOwnProperty('ios')) return obj;
	build = build['ios'];
	let dbg = {
		'appIdPrefix': '',
	};
	let rls = { ...dbg };
	let def = { ...dbg };

	if (build.hasOwnProperty('debug')) {
		let tmp = build['debug'];
		if (tmp.hasOwnProperty('developmentTeam')) {
			dbg['appIdPrefix'] = tmp['developmentTeam'];
		}
		if (tmp.hasOwnProperty('uuid')){
			dbg['packageId'] = tmp['uuid'];
		}
		if (tmp.hasOwnProperty('storeUrl')){
			dbg['storeUrl'] = tmp['storeUrl'];
		}
	}
	if (build.hasOwnProperty('release')) {
		let tmp = build['release'];
		if (tmp.hasOwnProperty('developmentTeam')) {
			rls['appIdPrefix'] = tmp['developmentTeam'];
		}
		if (tmp.hasOwnProperty('uuid')){
			rls['packageId'] = tmp['uuid'];
		}
		if (tmp.hasOwnProperty('storeUrl')){
			rls['storeUrl'] = tmp['storeUrl'];
		}
	}

	let keys = Object.keys(dbg);
	for (let ii = 0; ii < keys.length; ii++) {
		let key = keys[ii];
		if (dbg[key] === rls[key]) def[key] = dbg[key];
	}

	obj['ios']['default'] = override_props_but_retain(def, obj['ios']['default']);
	obj['ios']['debug'] = override_props_but_retain(def, obj['ios']['debug']);
	obj['ios']['release'] = override_props_but_retain(def, obj['ios']['release']);

	return obj;
}

function get_default() {
	let pkg = JSON.parse(fs.readFileSync(common.PackageJson).toString());
	if (!pkg.hasOwnProperty('displayName')) {
		log('No display name defined in package.json. Are you sure this is a Cordova project?', 'red');
		return 0;
	}
	let app_name = pkg['displayName'];
	return {
		'ios': {
			'default': {
				'toolkit_dir':'platforms/ios/Tools/CGAppCLPrepTool',
				'app': 'platforms/ios/build/emulator/${app_name}.app',
				'mdx': '',
				'storeUrl': '',
				'appType': 'sdkapp',
				'packageId': '',
				'entitlements': 'platforms/ios/mdx.entitlements',
				'appIdPrefix': '',
				'minPlatform': '11.0',
			},
			'debug': {
				'toolkit_dir':'',
				'app': '',
				'mdx': 'mdx/ios-debug.mdx',
				'storeUrl': '',
				'appType': '',
				'packageId': '',
				'entitlements': '',
				'appIdPrefix': '',
				'minPlatform': '',
			},
			'release': {
				'toolkit_dir':'',
				'app': '',
				'mdx': 'mdx/ios-release.mdx',
				'storeUrl': '',
				'appType': '',
				'packageId': '',
				'entitlements': '',
				'appIdPrefix': '',
				'minPlatform': '',
			}
		}
	}
}