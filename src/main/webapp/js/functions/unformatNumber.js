// unformat an integer
function unformatNumber(num) {
	num = num == undefined || num == null ? "" :num.toString().replace(/\$|\,/g,'').strip();
	return num;
}