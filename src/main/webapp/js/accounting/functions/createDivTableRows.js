/**
 * Function that will createDivRowsForTaxes
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */
function createDivTableRows(objArray, tableListContainer, rowIdPrefix, rowName, uniqueKeyList, prepareRecordsFunction) {
	try {
		var tableContainer = $(tableListContainer);
		for(var i=0; i<objArray.length; i++) {
			var content = prepareRecordsFunction(objArray[i]);							
			var newDiv = new Element("div");
			
			var keyList = $w(uniqueKeyList);

			newDiv.setAttribute("id", rowIdPrefix);
			
			for (var k=0; k < keyList.length; k++) {
				newDiv.setAttribute("id", newDiv.getAttribute("id") + objArray[i][keyList[k]]);
			}
			
			newDiv.setAttribute("name", rowName);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			tableContainer.insert({bottom: newDiv});
		}
		
	} catch (e) {
		showErrorMessage("createDivTableRows", e);
		// showMessageBox("createDivTableRows : " + e.message);
	}
}