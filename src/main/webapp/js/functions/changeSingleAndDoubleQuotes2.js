function changeSingleAndDoubleQuotes2(str) {
	return (str.replace(/'/g, "&#039;")).replace(/"/g, "&#34;");
}