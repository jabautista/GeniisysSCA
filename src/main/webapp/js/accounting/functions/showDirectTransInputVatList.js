/**
 * Show Input Vat table listing in module GIACS039
 * 
 * @author Jerome Orio 09.21.2010
 * @version 1.0
 * @param JSONArray
 *            to be used in listing
 * @return
 */
function showDirectTransInputVatList(objArray) {
	try {
		var tableContainer = $("directTransInputVatListing");
		for ( var a = 0; a < objArray.length; a++) {
			var content = prepareDirectTransInputVat(objArray[a]);
			var newDiv = new Element("div");
			objArray[a].divCtrId = a;
			objArray[a].recordStatus = null;
			newDiv.setAttribute("id", "rowDirectTransInputVat" + a);
			newDiv.setAttribute("name", "rowDirectTransInputVat");
			newDiv.addClassName("tableRow");
			newDiv.update(content);
			tableContainer.insert({
				bottom : newDiv
			});
		}
	} catch (e) {
		showErrorMessage("showDirectTransInputVatList", e);
		// showMessageBox("Error generating Input Vat List, " + e.message,
		// imgMessage.ERROR);
	}
}