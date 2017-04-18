/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.11.2011	mark jm			copy item process
 */
function parCopyItemTG(){
	try{
		var lineCd		= getLineCd();
		var itemNo		= parseInt($F("itemNo"));
		var nextItemNo	= getNextItemNoFromObj();//getNextItemNo("itemTable", "row", "label", 0);		
		var copyObj		= cloneObject(objCurrItem);		
		
		copyObj.itemNo 		= nextItemNo;
		copyObj.discountSw	= "N";
		copyObj.riskNo 		= lineCd != "FI" ? null : copyObj.riskNo;
		copyObj.riskItemNo	= lineCd != "FI" ? null : /*copyObj.riskItemNo == null ? null :*/ getNextRiskItemNoFromObj(copyObj.riskNo);
		copyObj.includeAddl = $("cgCtrlIncludeSw").checked ? true : false;
		
		 var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
		 
		 if((copyObj.fromDate != null || copyObj.fromDate != undefined) && !(dateformatting.test(copyObj.fromDate))){			 
			 copyObj.fromDate = dateFormat(copyObj.fromDate, "mm-dd-yyyy");
		 }
		 
		 if((copyObj.toDate != null || copyObj.toDate != undefined) && !(dateformatting.test(copyObj.toDate))){
			 copyObj.toDate = dateFormat(copyObj.toDate, "mm-dd-yyyy");
		 }		 
		
		//fireEvent($("row" + itemNo), "click");
		($$("#itemInfoTableGrid .selectedRow")).invoke("removeClassName", "selectedRow");
		
		if(lineCd == "MC"){			
			copyObj.gipiWVehicle.motorCoverage 	= null;
			copyObj.gipiWVehicle.origin 		= null;
			copyObj.gipiWVehicle.destination 	= null;
			copyObj.gipiWVehicle.plateNo 		= null;
			copyObj.gipiWVehicle.mvFileNo 		= null;
			copyObj.gipiWVehicle.cocSerialNo 	= null;
			copyObj.gipiWVehicle.serialNo 		= null;
			copyObj.gipiWVehicle.motorNo 		= null;
			copyObj.gipiWVehicle.cocSerialSw 	= "N";
		}else if(lineCd == "FI"){
			if(!(copyObj.includeAddl)){
				copyObj.fromDate 	= null;
				copyObj.toDate		= null;
			}
			copyObj.gipiWFireItm.riskCd	= null;			
		}else if(lineCd == "MN"){
			retrieveCargoCarriers(copyObj.parId, copyObj.itemNo);
		}else if(lineCd == "MH"){
			copyObj.gipiWItemVes = null;
		}
		
		setParItemFormTG(copyObj);
		
		if(copyObj.includeAddl){			
			//var objDeductiblesPercentTsi = objDeductibles.filter(function(obj){	return obj.deductibleType == "T" && nvl(obj.recordStatus, 0) != -1;	});
			
			//if(objDeductiblesPercentTsi.length < 1){				
				copyObjectDeductiblesTG(objDeductibles, itemNo, nextItemNo, "2");
				
				if(checkDeductibleType(objDeductibles, 1, "T") && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){					
					objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
				}		
			//}			
			
			copyAdditionalInfoTG(itemNo, nextItemNo);
			
			$("cgCtrlIncludeSw").checked = false;
		}		
		
		if(objFormMiscVariables.miscCopyPeril == "Y"){			
			copyPerilTG(objGIPIWItemPeril, itemNo, nextItemNo);
			objFormMiscVariables.miscCopyPeril = "N";
		}		
		
		objFormMiscVariables.miscCopy = "Y";
		
		//if(checkDeductibleType(objDeductibles, 1, "T") && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
		//	objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		//}		
		
		//showMessageBox("Item No. " + itemNo.toPaddedString(3) + " successfully copied to Item No. " + nextItemNo.toPaddedString(3) + 
		//		". Click the Add button to add this copied item to the list.");
		
		showMessageBox("Item No. " + itemNo.toPaddedString(3) + " successfully copied to Item No. " + nextItemNo.toPaddedString(3) + 
				". Will now go to Item No. " + nextItemNo.toPaddedString(3) + ". Click the Add button to add this copied item to the list.");
		
		delete copyObj;
	}catch(e){
		showErrorMessage("parCopyItemTG", e);
	}
}