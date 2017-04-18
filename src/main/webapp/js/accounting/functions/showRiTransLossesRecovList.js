/**
 * Show Ri Trans Loss Recov from RI (GIACS009) table listing
 * 
 * @author Jerome Orio 10.27.2010
 * @version 1.0
 * @param object
 *            array to be used
 * @return
 */
function showRiTransLossesRecovList(objArray) {
	try {
		var tableContainer = $("riTransLossesRecovListing");
		for ( var a = 0; a < objArray.length; a++) {
			var content = prepareRiTransLossesRecov(objArray[a]);
			var newDiv = new Element("div");
			objArray[a].divCtrId = a;
			objArray[a].recordStatus = null;
			newDiv.setAttribute("id", "rowRiTransLossesRecov" + a);
			newDiv.setAttribute("name", "rowRiTransLossesRecov");
			newDiv.addClassName("tableRow");
			newDiv.update(content);
			tableContainer.insert({
				bottom : newDiv
			});
		}
	} catch (e) {
		showErrorMessage("showRiTransLossesRecovList", e);
		// showMessageBox("Error showRiTransLossesRecovList, "+e.message,
		// imgMessage.ERROR);
	}
}