const path = require('path');
const uuidgen = require('uuid/v4');

// these locations are just for consistency
module.exports.MdxJson = 'mdx.json';
module.exports.BuildJson = 'build.json';
module.exports.PackageJson = 'package.json';
module.exports.Entitlements = path.join('platforms', 'ios', 'mdx.entitlements');

// function that just generates a random number
module.exports.rand = () => uuidgen().split('-').join('');

/**
 * Possibly prints a message, possibly in a certain color, but definitely prints a new line.
 * @param {string} [message=] the message to print
 * @param {'white'|'red'|'yellow'|'green'|'cyan'} [color=] the color to print with
 */
function log(message, color) {
	if (message === undefined) {
		console.log(); 
		return;
	}
	if (color === undefined) {
		console.log(message);
		return;
	}
	let color_code = get_color_code(color);
	console.log('%s%s\x1b[0m', color_code, message);
}
module.exports.log = log;

/**
 * Gets a color code for a certain color
 * @param {'red'|'yellow'|'green'|'white'|'cyan'} [color='white'] the color
 */
function get_color_code(color) {
	if (color === 'red') return '\x1b[31m';
	if (color === 'yellow') return '\x1b[33m';
	if (color === 'green') return '\x1b[32m';
	if (color === 'cyan') return '\x1b[36m';
	return '\x1b[37m';
}
