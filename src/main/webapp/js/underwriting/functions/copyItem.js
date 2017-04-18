/*	Created by	: mark jm 10.18.2010
 * 	Description	: creates a copy of the selected object and assign each value to screen  
 */
function copyItem(){
	try{
		var itemNo 		= new Number($F("itemNo"));
		var nextItemNo	= getNextItemNo("itemTable", "row", "label", 0);
		var copyObj		= cloneObject(objCurrItem);		

		fireEvent($("row"+itemNo), "click");
		// andrew - 11.10.2010 - added this function call to trigger the click event, 
		// the commented block of codes below can be deleted
		
		/*
		$("row" + itemNo).removeClassName("selectedRow");		
		
		toggleDeductibleRecords(null, $F("itemNo"), "ded2", "deductiblesTable2", 
				"totalDedAmountDiv2", "totalDedAmount2", "wdeductibleListing2", "2");
		
		setItemForm(null);
		if(objItemNoList != undefined){
			toggleSubpagesRecord(objEndtGroupedItems, objItemNoList, $F("itemNo"), "rowGroupedItem", "groupedItemNo",
					"groupedItemsTable", "groupedItemTotalAmountDiv", "groupedItemTotalAmount", "groupedItemListing");
			toggleSubpagesRecord(objEndtCAPersonnels, objItemNoList, $F("itemNo"), "rowCasualtyPersonnel", "personnelNo",
					"casualtyPersonnelTable", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount", "casualtyPersonnelListing");
		}		
		*/
		
		copyObj.itemNo = nextItemNo;
		copyObj.includeAddl = $("cgCtrlIncludeSw").checked ? true : false;					
		//setItemForm(copyObj);
		setParItemForm(copyObj);
		
		if(copyObj.includeAddl){
			copyObjectDeductibles(objDeductibles, itemNo, nextItemNo, "wdeductibleListing2", "ded",
					"perilCd dedDeductibleCd", "itemDeductible", "txtDeductibles", "2");
			copyAdditionalInfo(itemNo, nextItemNo);			
		}
		if(/*objFormMiscVariables[0].copyPeril*/ objFormMiscVariables.miscCopyPeril == "Y"){
			copyObjectPerils(objGIPIWItemPeril, itemNo, nextItemNo, "perilTableContainerDiv", "rowEndtPeril", "perilCd", "peril", "lblPeril");
		}		
		
		objFormMiscVariables.miscCopy = "Y";
		
		showMessageBox("Item No. " + itemNo.toPaddedString(3) + " successfully copied to Item No. " + nextItemNo.toPaddedString(3) + 
				". Will now go to Item No. " + nextItemNo.toPaddedString(3) + ". Click the Add button to add this copied item to the list."); //andrew - 11.10.2010 - added the last sentence
		
		delete copyObj;
	}catch(e){
		showErrorMessage("copyItem", e);
	}
}