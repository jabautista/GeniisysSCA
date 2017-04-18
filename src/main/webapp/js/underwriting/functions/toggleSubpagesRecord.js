/*	Created by	: mark jm 10.20.2010
 * 	Description	: show records related to item_no
 * 	Parameters	: objArray - object array of a certain table
 * 				: objItemList - object of item nos
 * 				: itemNo - selected item no
 * 				: rowName - name of row/div
 * 				: pkColumnList - primary keys of the detail record aside from par_id and item_no
 * 				: tableId - div id that holds all the records
 * 				: totalAmountDiv - div id for total amount
 * 				: totalAmountLabel - label id for total amount
 * 				: tableListing - div id of table listing
 * 				: blnAllow - flag for marine_cargo only (set to true to pass the condition)
 */
function toggleSubpagesRecord(objArray, objItemList, itemNo, rowName, pkColumnList,
	tableId, totalAmountDiv, totalAmountLabel, tableListing, amtColumnName, blnAllow){
	try{		
		$$("div#" + tableId + " .selectedRow").each(function(row){			
			fireEvent($(row.getAttribute("id")), "click");			
		});		
		
		if(objArray != null && ((objItemList.filter(getExistingRecords).size()) > 0 || blnAllow)){			
			var totalAmount = "";
			var show		= false;
			var objPre		= new Object();
			var objSca		= new Object();
			var exist 		= 0;
			var objArr		= [];
			
			// hide first all records not related to the current record			
			($$("div#" + tableListing + " div:not([item='" + itemNo + "'])")).invoke("hide");
			//reloadItemLOV();
			
			// then, show records that are related to the current record			
			objArr = objArray.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == itemNo;	});			
			for(var i=0, length=objArr.length; i < length; i++){
				var idCombination = "";
				var pkList = $w(pkColumnList.trim());
				
				for(var x=0, y=pkList.length; x < y; x++){
					idCombination = idCombination + objArr[i][pkList[x]] + "_";
				}
				
				idCombination = idCombination.substr(0, idCombination.length - 1);
				
				var id = rowName + objArr[i].itemNo + "_" + idCombination;
				
				var amount;
				$(id) != null ? $(id).show() : null;
				amount = ((nvl(objArr[i][amtColumnName], "0.00")).replace(/,/g, "")).split(".");
				objPre[i] = parseInt(amount[0]);
				objSca[i] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));
				show = true;
				exist += 1;		
			}
			
			filterSubpagesLOV(rowName, itemNo);
			
			totalAmount = show ? addSeparatorToNumber(addObjectNumbers(objPre, objSca), ",") : "0.00";			
			
			if (exist > 5) {
				$(tableId).setStyle("height: 217px;");
				$(tableId).down("div",0).setStyle("padding-right: 20px;");
		     	$(tableListing).setStyle("height: 155px; overflow-y: auto;");
		     	$(totalAmountDiv).setStyle("display: block; padding-right: 20px;");
		     	$(totalAmountLabel).update(totalAmount);
		    } else if (exist == 0) {
		     	$(tableListing).setStyle("height: 31px;");
		     	$(tableId).down("div",0).setStyle("padding-right: 0px");
		     	$(totalAmountDiv).setStyle("display: none; padding-right: 0px;");
		     	$(totalAmountLabel).update(totalAmount);
		    } else {
		    	var tableHeight = ((exist + 1) * 31) + 31;
		    	var tableRowHeight = (exist * 31);
		    	
		    	if(tableHeight == 0) {
		    		tableHeight = 31;
		    	}
		    	
		    	$(tableListing).setStyle("height: " + tableRowHeight +"px; overflow: hidden;");
		    	$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;");
		    	$(tableId).down("div",0).setStyle("padding-right: 0px");
		    	$(totalAmountDiv).setStyle("display: block; padding-right: 0px;");
		    	$(totalAmountLabel).update(totalAmount);
		    	$(totalAmountLabel).setAttribute("title", totalAmount);
			}		
			
			(exist == 0) ? Effect.Fade(tableId, {	duration : .001	}) : Effect.Appear(tableId, {	duration : .001	});							
			
			delete objPre, objSca;
		}else{			
			// hide the table instead of looping through each record to hide each record
			// this is a temporary solution to avoid looping			
			if($(tableId) != null){				
				$(tableId).hide();				
			}			
			reloadItemLOV();
		}
	}catch(e){
		showErrorMessage("toggleSubpagesRecord", e);
	}
}