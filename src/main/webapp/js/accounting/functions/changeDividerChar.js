function changeDividerChar(str) {
	var withQuotes = "";
	var withoutDividers = "";
	withQuotes = (str.replace(/'/g, "&#039;")).replace(/"/g, "&quot;");
	withoutDividers = withQuotes.replace(/\|/g, "&#124;");
	return withoutDividers;
}