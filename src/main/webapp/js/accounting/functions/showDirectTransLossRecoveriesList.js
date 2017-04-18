/**
 * Show Direct Trans Loss Recoveries table listing in module GIACS010
 * 
 * @author Jerome Orio 10.06.2010
 * @version 1.0
 * @param object
 *            array to be use
 * @return
 */
function showDirectTransLossRecoveriesList(objArray) {
	try {
		var tableContainer = $("directTransLossRecoveriesListing");
		for ( var a = 0; a < objArray.length; a++) {
			var content = prepareDirectTransLossRecoveries(objArray[a]);
			var newDiv = new Element("div");
			objArray[a].divCtrId = a;
			objArray[a].recordStatus = null;
			newDiv.setAttribute("id", "rowDirectTransLossRecoveries" + a);
			newDiv.setAttribute("name", "rowDirectTransLossRecoveries");
			newDiv.addClassName("tableRow");
			newDiv.update(content);
			tableContainer.insert({
				bottom : newDiv
			});
		}
	} catch (e) {
		showErrorMessage("showDirectTransLossRecoveriesList", e);
		// showMessageBox("Error generating Loss Recoveries List, "+e.message,
		// imgMessage.ERROR);
	}
}
