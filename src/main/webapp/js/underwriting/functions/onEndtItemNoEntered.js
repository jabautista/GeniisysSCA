/**
 * Function executed when an item no for endt is entered
 * @author andrew
 * @date 02.25.2011
 * @param objEndtItem
 */
function onEndtItemNoEntered(objEndtItem){
	try{	
		setCursor("wait");
		
		setParItemForm(objEndtItem);
		//clearItemPerilFields();
				
		var lineCd = getLineCd();
		
		if(lineCd == "MC"){
			toggleSubpagesRecord(objMortgagees, objItemNoList, $F("itemNo"), "rowMortg", "mortgCd",
					"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeListing", "amount", false);			
			toggleSubpagesRecord(objGIPIWMcAcc, objItemNoList, $F("itemNo"), "rowAcc", "accessoryCd",
					"accessoryTable", "accTotalAmountDiv", "accTotalAmount", "accListing", "accAmt", false);			
		}else if(lineCd == "FI"){
			toggleSubpagesRecord(objMortgagees, objItemNoList, $F("itemNo"), "rowMortg", "mortgCd",
					"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeListing", "amount", false);
		}else if(lineCd == "AH"){
			clearBenListing();
			loadBenListing($F("itemNo"));
		}else if(lineCd == "CA"){
			toggleSubpagesRecord(objGIPIWGroupedItems, objItemNoList, $F("itemNo"), "rowGroupedItem", "groupedItemNo",
					"groupedItemsTable", "groupedItemTotalAmountDiv", "groupedItemTotalAmount", "groupedItemListing", "amountCovered", false);
			toggleSubpagesRecord(objGIPIWCasualtyPersonnel, objItemNoList, $F("itemNo"), "rowCasualtyPersonnel", "personnelNo",
					"casualtyPersonnelTable", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount", "casualtyPersonnelListing", "amountCovered", false);
		}else if(lineCd == "MN"){
			toggleSubpagesRecord(objGIPIWCargoCarrier, objItemNoList, $F("itemNo"), "rowCargoCarrier", "vesselCd",
					"cargoCarrierTable", "cargoCarrierTotalAmountDiv", "cargoCarrierTotalAmount", "cargoCarrierListing", "vesselLimitOfLiab", false);
		}
		
		toggleDeductibleRecords(objDeductibles, $F("itemNo"), "ded2", "deductiblesTable2", 
				"totalDedAmountDiv2", "totalDedAmount2", "wdeductibleListing2", "2");
		setCursor("default");
	}catch(e){
		showErrorMessage("clickParItemRow", e);
	}	
}