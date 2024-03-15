const fs = require('fs');
const path = require('path');
const plist = require('plist');

const common = require('../common');
const log = common.log;

/**
 * JS file to add entitlements
 */
module.exports = function(context) {
	log();
	log('===== ADDING ENTITLEMENTS =====', 'cyan');
	process.chdir(context.opts.projectRoot);

	if (!fs.existsSync(common.PackageJson)) {
		log('No package.json detected. Are you sure this is a Cordova project?', 'red');
		return done();
	}

	let pkg = JSON.parse(fs.readFileSync(common.PackageJson).toString());
	if (!pkg.hasOwnProperty('name')) {
		log('No app identifier set in package.json. Are you sure this is a Cordova project?', 'red');
		return done();
	}
	if (!pkg.hasOwnProperty('displayName')) {
		log('No display name set in package.json. Are you sure this is a Cordova project?', 'red');
		return done();
	}

	let app_id = pkg['name'];
	let app_name = pkg['displayName'];

	let kags = [
		`$(AppIdentifierPrefix)${app_id}`,
		'$(AppIdentifierPrefix)com.citrix.mdx',
	]

	let files = [
		common.Entitlements,
		path.join('platforms', 'ios', app_name, 'Entitlements-Debug.plist'),
		path.join('platforms', 'ios', app_name, 'Entitlements-Release.plist'),
	];

	files.forEach((val, _i, _a) => {
		let file = fs.existsSync(val) ? plist.parse(fs.readFileSync(val).toString()) : {};

		if (!file.hasOwnProperty('keychain-access-groups')) file['keychain-access-groups'] = [];
		let kag = new Set(file['keychain-access-groups']);
		kags.forEach((vv, _ii, _aa) => { kag.add(vv); })

		file['keychain-access-groups'] = [...kag];
		
		fs.writeFileSync(val, plist.build(file));
		log(`Wrote entitlements to ${val}`);
	})

	done();
}

function done() {
	log('===== DONE ADDING ENTITLEMENTS =====', 'cyan');
	return 0;
}
