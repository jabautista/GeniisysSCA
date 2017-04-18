/*	Created by	: mark jm 10.01.2010
 * 	Description	: Create div for table listing
 * 	Parameters	: objArray - object/s that contains the listing
 * 				: destinationTableId - id of the element where the listing will be added
 * 				: rowName - name of each div in the listing
 * 				: tableId - id of the div that contains the table listing
 * 				: idList - space-delimited string containing the list of attributes that will be used for element id
 * 				: subpageName - name of the subpage where the table listing is located
 */
function setTableList(objArray, destinationTableId, rowName, tableId, idList, subpageName){
	try{
		var table = $(destinationTableId);
		
		for(var index=0, length=objArray.length; index < length; index++){			
			var content = getSubpageContent(subpageName, objArray[index]);
			var newDiv = new Element("div");
			
			var idCombination 	= "";
			var idListing		= $w(idList);
			
			for(var i=0, length2=idListing.length; i < length2; i++){
				idCombination = idCombination + objArray[index][idListing[i]] + "_";
				newDiv.setAttribute(idListing[i], objArray[index][idListing[i]]);
			}
			
			idCombination = idCombination.substr(0, idCombination.length - 1);
			
			newDiv.setAttribute("id", rowName + idCombination/*objArray[index].itemNo*/);
			newDiv.setAttribute("name", rowName);
			newDiv.setAttribute("item", objArray[index].itemNo);
			newDiv.setStyle("display : block");
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			table.insert({bottom : newDiv});
		}	
		
		//checkIfToResizeTable(destinationTableId, rowName);
		//checkTableIfEmpty(rowName, tableId);
		
		$(tableId).hide();
		
	}catch(e){
		showErrorMessage("setTableList", e);
		//showMessageBox("setTableList : " + e.message);
	}	
}