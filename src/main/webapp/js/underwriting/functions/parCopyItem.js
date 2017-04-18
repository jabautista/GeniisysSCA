function parCopyItem(){
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
		
		fireEvent($("row" + itemNo), "click"); 
		
		if(lineCd == "MC"){			
			copyObj.gipiWVehicle.motorCoverage 	= null;
			copyObj.gipiWVehicle.origin 		= null;
			copyObj.gipiWVehicle.destination 	= null;
			copyObj.gipiWVehicle.plateNo 		= null;
			copyObj.gipiWVehicle.mvFileNo 		= null;
			copyObj.gipiWVehicle.cocSerialNo 	= null;
			copyObj.gipiWVehicle.serialNo 		= null;
			//copyObj.gipiWVehicle.motorNo 		= null; //belle 040112011
			copyObj.gipiWVehicle.cocSerialSw 	= "N";
		}else if(lineCd == "FI"){
			if(!(copyObj.includeAddl)){
				copyObj.fromDate 	= null;
				copyObj.toDate		= null;
			}
			copyObj.gipiWFireItm.riskCd	= null;			
		}
		
		setParItemForm(copyObj);
		
		if(copyObj.includeAddl){
			var objDeductiblesPercentTsi = objDeductibles.filter(function(obj){	return obj.deductibleType == "T" && nvl(obj.recordStatus, 0) != -1;	});
			
			if(objDeductiblesPercentTsi.length < 1){
				copyObjectDeductibles(objDeductibles, itemNo, nextItemNo, "wdeductibleListing2", "ded",
						"perilCd dedDeductibleCd", "itemDeductible", "txtDeductibles", "2");
			}			
			
			copyAdditionalInfo(itemNo, nextItemNo);
		}		
		
		if(objFormMiscVariables.miscCopyPeril == "Y"){
			//copyObjectPerils(objGIPIWItemPeril, itemNo, nextItemNo, "parItemPerilTable", "row2", "perilCd", "peril", "lblPeril");
			copyPeril(objGIPIWItemPeril, itemNo, nextItemNo, "parItemPerilTable", "perilCd", "peril");
			objFormMiscVariables.miscCopyPeril = "N";
		}		
		
		objFormMiscVariables.miscCopy = "Y";
		
		//if(checkDeductibleType(objDeductibles, 1, "T") && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
		//	objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		//}
		
		showMessageBox("Item No. " + itemNo.toPaddedString(3) + " successfully copied to Item No. " + nextItemNo.toPaddedString(3) + 
				". Will now go to Item No. " + nextItemNo.toPaddedString(3) + ". Click the Add button to add this copied item to the list.");
		
		delete copyObj;
	}catch(e){
		showErrorMessage("parCopyItem", e);
		//showMessageBox("parCopyItem : " + e.message);
	}
}