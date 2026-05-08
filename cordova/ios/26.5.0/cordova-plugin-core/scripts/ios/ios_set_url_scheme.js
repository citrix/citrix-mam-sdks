const fs = require('fs');
const path = require('path');
const plist = require('plist');

const common = require('../common');
const log = common.log;

/**
 * Sets the url scheme in the project's info file.
 */
module.exports = function(context) {
	log();
	log('===== SETTING URL SCHEME =====', 'cyan');

	process.chdir(context.opts.projectRoot);

	// if package.json doesn't exist, this isn't a Cordova project
	if (!fs.existsSync(common.PackageJson)) {
		log('No package.json detected. Are you sure this is a Cordova project?', 'red');
		return done();
	}

	let pkg = JSON.parse(fs.readFileSync(common.PackageJson).toString());
	if (!pkg.hasOwnProperty('displayName')) {
		log('No display name defined in package.json. Are you sure this is a Cordova project?', 'red');
		return done();
	}
	if (!pkg.hasOwnProperty('name')) {
		log('No app identifier defined in package.json. Are you sure this is a Cordova project?', 'red');
		return done();
	}
	let app_name = pkg['displayName'];
	let app_id = pkg['name'];
	
	let uuid = null;
	// get the UUID from build.json, if it exists
	if (fs.existsSync(common.BuildJson)) {
		let contents = JSON.parse(fs.readFileSync(common.BuildJson));
		if (contents.hasOwnProperty('ios')) {
			contents = contents['ios'];
			if (contents.hasOwnProperty('debug')) {
				let tmp = contents['debug'];
				if (tmp.hasOwnProperty('uuid')) {
					tmp = tmp['uuid'];
				if (tmp !== '') {uuid = tmp};
				}
			}
		}
	}

    
	if (uuid === null) {
		log('Could not find your Apple Developer Team ID in mdx.json or build.json. Cannot set url scheme until this is done', 'yellow');
		return done();
	}

	let app_scheme = `com.citrix.sso.${uuid}`;

	let file = path.join('platforms', 'ios', app_name, `${app_name}-Info.plist`);
	if (!fs.existsSync(file)) {
		log(`Could not find ${file}. Invalid iOS platform!!!`, 'red');
		return done();
	}

	let contents = plist.parse(fs.readFileSync(file).toString());
	if (!contents.hasOwnProperty('CFBundleURLTypes')) contents['CFBundleURLTypes'] = [];

	let has_app_scheme = false;
	let candidates = [];
	let to_use = null;

	for (let ii = 0; ii < contents['CFBundleURLTypes'].length; ii++) {
		let cc = contents['CFBundleURLTypes'][ii];
		if (!cc.hasOwnProperty('CFBundleTypeRole')) continue;
		if (!cc.hasOwnProperty('CFBundleURLName')) continue;
		if (!cc.hasOwnProperty('CFBundleURLSchemes')) continue;
		if (cc['CFBundleTypeRole'] !== 'Editor') continue;
		if (cc['CFBundleURLName'] !== app_id) continue;
		candidates.push(cc);
		contents['CFBundleURLTypes'].splice(ii, 1);
		ii--;
	}
	
	if (candidates.length !== 0) {
		for (let ii = 0; ii < candidates.length; ii++) {
			/** @type {string[]} */
			let schemes = candidates[ii]['CFBundleURLSchemes'];
			for (let jj = 0; jj < schemes.length; jj++) {
				let scheme = schemes[jj];
				let is_to_use = false;
				if (!scheme.startsWith('com.citrix.sso.')) continue;
				if (scheme.startsWith('com.citrix.sso.' + uuid)) {
					has_app_scheme = true;
					is_to_use = true;
				}
				if (is_to_use) {
					to_use = candidates[ii];
					candidates.splice(ii, 1);
				}
			}
			if (to_use !== null) break;
		}
		contents['CFBundleURLTypes'].push(...candidates);
	}


    if (to_use === null) {
        to_use = {
            'CFBundleTypeRole': 'Editor',
            'CFBundleURLName': app_id,
            'CFBundleURLSchemes': [],
        };
    }

    if (!has_app_scheme) to_use['CFBundleURLSchemes'].push(app_scheme);
    else log('URL scheme already defined', 'green');
    contents['CFBundleURLTypes'].push(to_use);
    fs.writeFileSync(file, plist.build(contents));
    return done();

	let url_schemes = new Set(...to_use['CFBundleURLSchemes']);
	url_schemes.add(app_scheme);
	to_use['CFBundleURLSchemes'] = [...url_schemes];

	contents['CFBundleURLTypes'].push(to_use);

	fs.writeFileSync(file, plist.build(contents));

	return done();
}

function done() {
	log('===== DONE SETTING URL SCHEME =====', 'cyan');
	return 0;
}
