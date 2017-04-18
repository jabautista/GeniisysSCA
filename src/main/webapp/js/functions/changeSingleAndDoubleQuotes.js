// change single and double quotes in a string 
// parameters:
// str: string to do action on
function changeSingleAndDoubleQuotes(str) {
	if(str != null && str != "")
		return (str.replace(/&#039;/g, "'")).replace(/&#34;/g, "\"");
	else
		return "";
}