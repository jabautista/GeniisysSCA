/*	Created by	: mark jm 10.21.2010
 * 	Description	: show deductible records related to item_no
 * 	Parameters	: objArray - object array of a certain table
 * 				: itemNo - selected item no
 * 				: rowName - name of row/div
 * 				: tableId - div id that holds all the records
 * 				: totalAmountDiv - div id for total amount
 * 				: totalAmountLabel - label id for total amount
 * 				: tableListing - div id of table listing
 * 				: dedLevel - deductible level
 */
function toggleDeductibleRecords(objArray, itemNo, rowName, tableId, 
	totalAmountDiv, totalAmountLabel, tableListing, dedLevel){
	try{		
		if(objArray != null && $(tableId) != null){ // andrew - 10.26.2010 - added '$(tableId) != null' condition
			
			var totalAmount = "";
			var show		= false;
			var objPre		= new Object();
			var objSca		= new Object();
			
			for(var i=0, length=objArray.length; i < length; i++){
				var id = rowName + objArray[i].itemNo + nvl(objArray[i].perilCd, 0) + objArray[i].dedDeductibleCd;
				
				if(objArray[i].itemNo == itemNo && nvl(objArray[i].perilCd, 0) == 0){
					var amount;					
					$(id) != null ? $(id).show() : null;
					if (objArray[i].deductibleAmount != null){ // andrew - 10.20.2010 - added condition to check if deductibleAmount is null
						amount = ((objArray[i].deductibleAmount).replace(/,/g, "")).split(".");
						objPre[i] = parseInt(amount[0]);
						objSca[i] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));
					}
					show = true;
				}else{					
					if($(id) != null){
						$(id).hide();						
					}
				}
			}
			
			if(show){				
				totalAmount = addSeparatorToNumber(addObjectNumbers(objPre, objSca), ",");				
				$(tableId).show();
				$(totalAmountDiv).show();
				$(totalAmountLabel).update(totalAmount);
				$(totalAmountLabel).setAttribute("title", totalAmount);
			}else{				
				$(tableId).hide();
			}
			
			checkTableIfEmpty2(rowName, tableId);
			checkIfToResizeTable2(tableListing, rowName);
			
			delete objPre, objSca;
		}else{			
			if($(tableId) != null){
				$(tableId).hide();
			}
		}		
	}catch(e){
		showErrorMessage("toggleDeductibleRecords", e);
	}
}