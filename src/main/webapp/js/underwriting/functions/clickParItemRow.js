/*
 * Created By	: mark jm
 * Date			: 12.13.2010
 * Description	: set form display
 * Parameter	: row - the selected row/div
 * 				: objParItems - object array containing the records 
 */
function clickParItemRow(row, objParItems){
	try{
		var itemArr = [];
		
		setCursor("wait");
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")){	
			($$("div#itemTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
			itemArr = objParItems.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	});
			for(var i=0, length=itemArr.length; i < length; i++){				
				if(itemArr[i].itemNo == row.getAttribute("item")){					
					objCurrItem = itemArr[i];					
					break;
				}
			}
			
			setParItemForm(objCurrItem);

			if(/*$F("globalParType")*/ objUWParList.parType == "P"){
				loadSelectedItemRowOnPerilProcedures(row.getAttribute("item"));
				clearItemPerilFields();
			} else if (/*$F("globalParType")*/ objUWParList.parType == "E"){
				/*$("itemAnnTsiAmt").writeAttribute("origItemAnnTsiAmt", objCurrItem.annTsiAmt);
				$("itemAnnPremiumAmt").writeAttribute("origItemAnnPremAmt", objCurrItem.annPremAmt);*/
				setEndtPerilForm(null);
				setEndtPerilFields(null);
				toggleEndtItemPeril(objCurrItem.itemNo, objGIPIWItemPeril, objGIPIItemPeril);
				checkIfCancelledEndorsement(); // added by: Nica 07.23.2012 - to check if to disable fields if PAR is a cancelled endt		
				objUWGlobal.selectedItemCond = "Y"; //added by steven 2/22/2013; use as a condition in adding peril in endorsement;endtPerilInformation.jsp.
			}
		}else{			
			setParItemForm(null);
			if(/*$F("globalParType")*/ objUWParList.parType == "P"){
				setDefaultItemForm();
				loadUnselectedItemRowOnPerilProcedures();
			} else if (/*$F("globalParType")*/ objUWParList.parType == "E"){
				toggleEndtItemPeril(null, objGIPIWItemPeril, objGIPIItemPeril);
				setEndtPerilForm(null);
				setEndtPerilFields(null);
				checkIfCancelledEndorsement(); // added by: Nica 07.23.2012 - to check if to disable fields if PAR is a cancelled endt
				objUWGlobal.selectedItemCond = "N"; //added by steven 2/22/2013; use as a condition in adding peril in endorsement;endtPerilInformation.jsp.
			}
		}
		
		var lineCd = getLineCd();
		
		if(lineCd == "MC"){
			toggleSubpagesRecord(objMortgagees, objItemNoList, $F("itemNo"), "rowMortg", "mortgCd",
					"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeListing", "amount", false);			
			toggleSubpagesRecord(objGIPIWMcAcc, objItemNoList, $F("itemNo"), "rowAcc", "accessoryCd",
					"accessoryTable", "accTotalAmountDiv", "accTotalAmount", "accListing", "accAmt", false);			
		}else if(lineCd == "FI"){
			validateZoneType();		//Gzelle 05252015 SR4347
			toggleSubpagesRecord(objMortgagees, objItemNoList, $F("itemNo"), "rowMortg", "mortgCd",
					"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeListing", "amount", false);
		}else if(lineCd == "AC"){ //AH 
			clearBenListing();
			loadBenListing($F("itemNo"));
			if (objUWParList.parType == 'P'){ //belle 06132011
				if ('Y' == $F("itmperlGroupedExists")){
					disableButton("btnAddItemPeril");
				}
			}
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