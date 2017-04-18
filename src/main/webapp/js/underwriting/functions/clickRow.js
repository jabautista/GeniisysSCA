/*	Modified by		: mark jm 09.27.2010
 * 	Modification	: Added new parameter objEndtItems
 * 					: Replaced objEndtMNItems to objEndtItems to be used by other lines
 */
function clickRow(row, objEndtItems) {
	try{
		row.toggleClassName("selectedRow");
		$("perilExists").value = "N";
		var click = false;
		
		if(row.hasClassName("selectedRow")){
			$$("div#itemTable div[name='row']").each(
				function(r){
					if(row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
						//return false;
					}
				});
			
			var tempItemNo = row.getAttribute("item");
			
			for(var i=0; i<objEndtItems.length; i++) {
				if (objEndtItems[i].itemNo == tempItemNo) {
					objCurrEndtItem = objEndtItems[i];
					click = true;
					break;					
				}	
			}			
			setItemForm(objCurrEndtItem);
			var divId = "";
			if (objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
				divId = "itemAndAdditionalInfoDiv";
				clearChangeAttribute(divId);
			}
		} else {		
			setItemForm(null);
			click = false;
		}
		//toggleDeductibles(2, $F("itemNo"), 0);
		if (objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN) {
			toggleEndtMNCarriers(objCargoCarriers, $F("itemNo"), "rowCarrier", "carrierTable", "lblTotalLimit", "carrierListing");
		}
		
		toggleDeductibleRecords((click ? objDeductibles : null), $F("itemNo"), "ded2", "deductiblesTable2", 
				"totalDedAmountDiv2", "totalDedAmount2", "wdeductibleListing2", "2");
		
		if(objItemNoList != undefined){			
			toggleSubpagesRecord((click ? objEndtGroupedItems : null), objItemNoList, $F("itemNo"), "rowGroupedItem", "groupedItemNo",
					"groupedItemsTable", "groupedItemTotalAmountDiv", "groupedItemTotalAmount", "groupedItemListing", "amountCovered", false);
			toggleSubpagesRecord((click ? objEndtCAPersonnels : null), objItemNoList, $F("itemNo"), "rowCasualtyPersonnel", "personnelNo",
					"casualtyPersonnelTable", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount", "casualtyPersonnelListing", "amountCovered", false);
		}	
		toggleEndtItemPeril(objCurrEndtItem.itemNo, objGIPIWItemPeril, objGIPIItemPeril);
	}catch(e){
		showErrorMessage("clickRow", e);
	}
}