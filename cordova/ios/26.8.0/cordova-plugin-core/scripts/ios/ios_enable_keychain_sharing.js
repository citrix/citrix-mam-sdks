const fs = require('fs');
const path = require('path');

const common = require('../common');
const log = common.log;

/**
 * JS file to add Keychain access groups
 */
module.exports = function(context) {
	log();
	log('===== ENABLING KEYCHAIN SHARING =====', 'cyan');
	
	process.chdir(context.opts.projectRoot);

	if (!fs.existsSync(common.PackageJson)) {
		log('No package.json detected. Are you sure you are in a Cordova project?', 'red');
		return done();
	}

	let package_json = JSON.parse(fs.readFileSync(common.PackageJson).toString());
	if (!package_json.hasOwnProperty('displayName')) {
		log('No display name set in package.json. Invalid Cordova project!!!', 'red');
		return done();
	}

	/** @type {string} */
	let app_name = package_json['displayName'];

	let pbxproj_location = path.join('platforms', 'ios', `${app_name}.xcodeproj`, 'project.pbxproj');
	if (!fs.existsSync(pbxproj_location)) {
		log(`project.pbxproj not available in ${pbxproj_location}. Invalid iOS platform!`, 'red');
		return done();
	}
	log(`Editing project file at ${pbxproj_location}`)

	let lines = fs.readFileSync(pbxproj_location).toString().split('\n');

	let root_project_id;
	for (let ii = lines.length - 1; ii >= 0; ii--) {
		if (lines[ii].indexOf('rootObject = ') >= 0) {
			root_project_id = lines[ii].split(' ')[2];
			break;
		}
	}

	let ii = 0;
	let tmp = 0;
	for (; ii !== lines.length && lines[ii] !== '/* Begin PBXNativeTarget section */'; ii++);
	if (ii === lines.length) {
		log('No PBXNativeTargets defined. Invalid iOS platform!!!', 'red');
		return done();
	}
	for (; ii !== '/* End PBXNativeTarget section */'; ii++) {
		let line = lines[ii].split(' ');
		if (!/[0123456789ABCDEF]{24}/.test(line[0])) continue;
		if (line[1] !== '/*') continue;
		if (line[2] !== app_name) continue;
		if (line[3] !== '*/') continue;
		if (line[4] !== '=') continue;
		if (line[5] !== '{') continue;
		break;
	}
	if (lines[ii] === '/* End PBXNativeTarget section */') {
		log('No native targets defined in pbxproject file. Invalid iOS platform!!!', 'red');
		return done();
	}
	let target_hash = lines[ii].split(' ')[0].trim();

	let end_of_section = '/* End PBXProject section */';
	for (; ii !== lines.length && lines[ii] !== '/* Begin PBXProject section */'; ii++);
	if (ii === lines.length) {
		log('No PBXProject section in your pbxproject file. Invalid iOS platform!', 'red');
		return done();
	}
	for (; lines[ii] !== end_of_section && lines[ii].trim() !== `${root_project_id} /* Project object */ = {`; ii++);
	if (lines[ii] === end_of_section) {
		log('No details provided for project object in PBXProject section of your project.pbxproj file. Invalid iOS platform!!!', 'red');
		return done();
	}

	for (; lines[ii] !== end_of_section && lines[ii].trim() !== 'attributes = {'; ii++);
	if (lines[ii] === end_of_section) {
		log('No attributes provided for project object in project.pbxproj file. Invalid iOS platform!!!', 'red');
		return done();
	}

	for (; lines[ii] !== end_of_section && lines[ii].trim() !== 'TargetAttributes = {'; ii++);
	if (lines[ii] === end_of_section) {
		log('No Target Attributes provided for project object in project.pbxproj file. Invalid iOS platform!!!', 'red');
		return done();
	}

	for (; lines[ii] !== end_of_section && lines[ii] !== '\t\t\t\t\t' + target_hash + ' = {'; ii++);
	if (lines[ii] === end_of_section) {
		log('No Target Attributes defined in project.pbxproj file. Invalid iOS platform!!!', 'red');
		return done();
	}
	tmp = ii;
	for (; lines[ii] !== end_of_section && lines[ii] !== '\t\t\t\t\t\tSystemCapabilities = {'; ii++);
	if (lines[ii] === end_of_section) {
		log('No SystemCapabilities defined for target. Adding...');
		ii = tmp;
		ii++;
		lines.splice(ii, 0, '\t\t\t\t\t\tSystemCapabilities = {', '\t\t\t\t\t\t};');
	}
	tmp = ii;
	for (; lines[ii] !== end_of_section && lines[ii] !== '\t\t\t\t\t\t\tcom.apple.Keychain = {'; ii++);
	if (lines[ii] === end_of_section) {
		log('No Keychain setting set in SystemCapabilities for target. Setting...');
		ii = tmp;
		ii++;
		lines.splice(ii, 0, '\t\t\t\t\t\t\tcom.apple.Keychain = {', '\t\t\t\t\t\t\t\tenabled = 1;', '\t\t\t\t\t\t\t};');
	}

	ii++;
	let line = lines[ii].split(' ');
	line[2] = '1;';
	lines[ii] = line.join(' ');

	fs.writeFileSync(pbxproj_location, lines.join('\n'));
	done();
}

function done() {
	log('===== DONE ENABLING KEYCHAIN SHARING =====', 'cyan');
	return 0;
}