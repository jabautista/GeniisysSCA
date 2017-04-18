/**
 * @author andrew robes
 * @date 02.16.2011
 * @description escapes HTML tags and replaces single and double quotes with its corresponding html component
 * @param str - string to be escaped
 * added escape tag for vertical bar 10.09.2013
 */
function escapeHTML2(str){
	if(nvl(str,null) != null){
		return str.replace(/&/g,'&#38;').replace(/</g,'&#60;').replace(/>/g,'&#62;').replace(/\'/g, "&#039;").replace(/\"/g, "&#34;").replace(/\u00f1/g, "&#241;").replace(/\u00D1/g, "&#209;").replace(/\|/g, "&#124;").replace(/\\/g, "&#92;"); //added by steven 11.26.2013; .replace(/\\/g, "&#92;")
	}else{
		return "";
	}
}