/**
 * Executed when a basic color from list of values is selected Note: This is
 * being used in quotation, policy issuance and endt policy issuance
 * 
 * @author andrew
 * @date 05.18.2011
 */
function onBasicColorSelected(row) {
	try {
		if (row.basicColorCd != $F("basicColorCd")) {
			$("basicColorCd").value = row.basicColorCd;
			$("basicColor").value = unescapeHTML2(row.basicColor);
			$("color").value = "";
			$("colorCd").value = "";
		}
	} catch (e) {
		showErrorMessage("onBasicColorSelected", e);
	}
}