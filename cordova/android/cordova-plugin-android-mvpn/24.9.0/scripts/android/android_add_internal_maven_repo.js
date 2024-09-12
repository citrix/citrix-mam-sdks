const fs = require('fs');
const path = require('path');

const common = require('../common');
const log = common.log;

module.exports = function(context) {
    log();
    log('===== START ADDING INTERNAL MAVEN REPO FOR ANDROID =====', 'cyan');

    process.chdir(context.opts.projectRoot);

    var root = context.opts.projectRoot;
    var platformRoot = path.join(root, 'platforms', 'android');
    var gradlePath = path.join(platformRoot, 'CordovaLib', 'cordova.gradle');

    if (fs.existsSync(gradlePath)) {
        var gradleContent = fs.readFileSync(gradlePath, 'utf-8');
        var mavenRepo = 'maven { url "https://mia-repo.citrite.net/xm-virtual-maven"}';
        var newGradleContent = gradleContent.replace(/(repositories \{)/, '$1\n        ' + mavenRepo);
        fs.writeFileSync(gradlePath, newGradleContent, 'utf-8');
    }

    return done();
}

function done() {
	log('===== FINISHED ADDING INTERNAL MAVEN REPO FOR ANDROID =====', 'cyan');
	return 0;
}