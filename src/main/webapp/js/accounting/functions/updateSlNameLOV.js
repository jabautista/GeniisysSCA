/**
 * Populate SL Name LOV in module GIACS039
 * 
 * @author Jerome Orio 10.04.2010
 * @version 1.0
 * @param objArray -
 *            object array for slName listing
 * @return
 */
function updateSlNameLOV(objArray) {
	removeAllOptions($("selVatSlCdInputVat"));
	var opt = document.createElement("option");
	opt.value = "";
	opt.text = "";
	opt.setAttribute("slName", "");
	opt.setAttribute("itemNo", "");
	$("selVatSlCdInputVat").options.add(opt);
	for ( var a = 0; a < objArray.length; a++) {
		if (objArray[a].itemNo == $F("selItemNoInputVat")) {
			var opt = document.createElement("option");
			opt.value = objArray[a].slCd;
			opt.text = objArray[a].slCd + " - "
					+ unescapeHTML2(objArray[a].slName);
			opt.setAttribute("slName", unescapeHTML2(objArray[a].slName));
			opt.setAttribute("itemNo", objArray[a].itemNo);
			$("selVatSlCdInputVat").options.add(opt);
		}
	}
}