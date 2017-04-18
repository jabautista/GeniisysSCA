/*
 * Created by	: andrew
 * Date			: November 2, 2010
 * Description	: Shows/Hides cargo carrier records depending on the selected item
 * Parameters	: objArray - array of cargo carrier objects
 * 				  itemNo - selected item number
 * 				  rowName - name of row in table list
 * 				  tableId - id of table list
 * 				  totalAmoundDiv - id of div containing the total amount
 * 				  totalAmountLabel - id of total amount label
 * 				  tableListing - id of div containing the cargo carrier rows  
 */
function toggleEndtMNCarriers(objArray, itemNo, rowName, tableId, totalAmountLabel, tableListing){
	try {		
		if(objArray != null){			
			var totalAmount = "";
			var show		= false;
			var objPre		= new Object();
			var objSca		= new Object();
			var id 			= null;
			var amount 		= null;

			for(var i=0, length=objArray.length; i < length; i++){
				id = rowName + objArray[i].itemNo + objArray[i].vesselCd.trim();
				if ($(id) == null) {
					id = rowName + objArray[i].itemNo + "_" + objArray[i].vesselCd.trim();
				}
				if(objArray[i].itemNo == itemNo){
					$(id).show();
					if (objArray[i].vesselLimitOfLiab != null){
						amount = ((objArray[i].vesselLimitOfLiab).replace(/,/g, "")).split(".");
						objPre[i] = parseInt(amount[0]);
						objSca[i] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));
					}
					show = true;
				}else{
					if($(id) != undefined){
						$(id).hide();
					}
				}
			}
			
			if(show){
				totalAmount = addSeparatorToNumber(addObjectNumbers(objPre, objSca), ",");
				$(tableId).show();
				//$(totalAmountDiv).show();
				$(totalAmountLabel).update(totalAmount);
				$(totalAmountLabel).setAttribute("title", totalAmount);
			}else{
				$(tableId).hide();
			}
			
			checkTableIfEmpty2(rowName, tableId);
			checkIfToResizeTable2(tableListing, rowName);
			filterLOV3("carrier", rowName, "carrCd", "item", itemNo);
			
			delete objPre, objSca;
		} else {
			if($(tableId) != null){
				$(tableId).hide();
			}
		}
	} catch (e) {
		showErrorMessage("toggleEndtMNCarriers", e);
		//showMessageBox("toggleEndtMNCarriers : " + e.message);
	}
}