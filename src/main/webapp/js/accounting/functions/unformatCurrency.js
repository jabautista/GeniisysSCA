// edit by jerome orio 10.11.2010 added if condition
function unformatCurrency(paramField) {
	var unformattedValue = "";
	if ($(paramField).value.replace(/,/g, "") != ""
			&& !isNaN(parseFloat($(paramField).value.replace(/,/g, "")))) {
		unformattedValue = parseFloat($(paramField).value.replace(/,/g, ""));
	}
	return unformattedValue;
}