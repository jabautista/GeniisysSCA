function changeBackDividerChar(str) {
	var withDividers = "";
	if (str != null) {
		withDividers = str.replace(/&#124;/g, "|");

	}
	return withDividers;
}