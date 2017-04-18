/**
 * Set the visibility of the table 
 * - combines the functions of checkIfToResizeTable & checTableIfEmpty 
 * - :tableContainerDiv and :tableId MAY or MAY NOT refer to the same div element
 * @generic
 * @param tableContainerDivId
 *            containerDivId - the div that contains the header tableDiv and the
 *            div(having id:tableId) of rows(having name:rowName) just set the
 *            tableContainerDivId to null if no such layer is used.
 * @param tableId
 *            of the tableDiv that DIRECTLY contains the rowDivs
 * @param name
 *            attribute of the table rows
 * @author rencela
 */
function resetTableStyle(tableContainerDivId, tableId, rowName){
	var rowLength = $$("div[name="+ rowName + "]").size();	
	var style = "height: 31px; display: none;";
	var willShowContainer = false;
	$(tableId).hide();
	if(rowLength>0){
		if(rowLength>0 && rowLength<5){	// 1-5
			var height = 31 + ((rowLength-1)*31);
			style = "height: " + height + "px; overflow: hidden;";
		}else if (rowLength >= 5) {
		 	style = "height: 155px; overflow: auto; width: 100%;";
		}
		$(tableId).show();
		willShowContainer = true;
	}
	
	if(tableContainerDivId!=null){	// checks if string is null
		try{ 						// block non-existent id's
			if(willShowContainer){
				$(tableContainerDivId).show();
			}else{
				$(tableContainerDivId).hide();
			}
		}catch(e){
			showErrorMessage("resetTableStyle", e);
		}
	}
	
	$(tableId).setStyle(style);
}