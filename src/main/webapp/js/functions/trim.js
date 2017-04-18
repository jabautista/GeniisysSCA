// removes spaces on both sides of the string
// parameter: str - string to trim
function trim(str) {
	return str.replace(/^\s+|\s+$/g,"");
}