/*	Created by	: mark jm 05.30.2011
 * 	Description : show/hide records used in accident
 * 	Parameters	: objArray - record list
 * 				: tableId - record list holder
 * 				: tableListing - record listing
 * 				: itemNo - current item
 * 				: grpItemNo - current grouped Item No
 */
function cascadeAccidentGroup(objArray, tableId, tableListing, itemNo, grpItemNo){
	try{		
		if(($$("div#" + tableId + " .selectedRow")).length > 0){
			fireEvent(($$("div#" + tableId + " .selectedRow"))[0], "click");
		}
		
		if(($$("div#accidentGroupedItemsTable .selectedRow")).length > 0){										
			var selectedRow = ($$("div#accidentGroupedItemsTable .selectedRow"))[0];
			var itemNo = selectedRow.getAttribute("item");
			var grpItemNo = selectedRow.getAttribute("grpItem");
			
			if(objArray != null && (objArray.filter(function(obj){	return obj.itemNo == itemNo && obj.groupedItemNo == grpItemNo;	})).length > 0){
				($$("div#" + tableListing + " div:not([grpItem='" + grpItemNo + "'])")).invoke("hide");
				($$("div#" + tableListing + " div[grpItem='" + grpItemNo + "']")).invoke("show");
				resizeTableBasedOnVisibleRows(tableId, tableListing);
				
				//if(tableListing == "coverageListing"){					
				//	filterItemLOV("coverageTable", "grpItem", grpItemNo, "cPerilCd", "perilCd");
				//}
			}else{				
				$(tableId).hide();	
			}
		}else{			
			$(tableId).hide();				
		}
	}catch(e){
		showErrorMessage("cascadeAccidentGroup", e);
	}				
}