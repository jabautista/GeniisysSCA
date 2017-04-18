/**
 * Executed when a color from list of values is selected Note: This is being
 * used in quotation, policy issuance and endt policy issuance
 * 
 * @author andrew
 * @date 05.18.2011
 */
function onColorSelected(row) {
	try {
		if (row.colorCd != $F("colorCd")) {
			$("color").value =  unescapeHTML2(row.color); //unescapeHTML2 added by jeffdojello 11.04.2013 GENQA SR: 706
			$("colorCd").value = row.colorCd;

			if ($F("basicColorCd") == "") {
				$("basicColorCd").value = row.basicColorCd;
				$("basicColor").value = unescapeHTML2(row.basicColor); //unescapeHTML2 added by jeffdojello 11.04.2013 GENQA SR: 706
			}
		}
	} catch (e) {
		showErrorMessage("onColorSelected", e);
	}
}