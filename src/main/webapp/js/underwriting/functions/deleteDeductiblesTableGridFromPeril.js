/*	Created by	: steven 10.21.2012
 * 	function	: to delete deductibles in the table grid,if the deductibleType == "T".
 */
function deleteDeductiblesTableGridFromPeril(deleteTag){
	$("fireDeleteDeductibles").value = "Y";
	$("deductiblesDeleted").value = "Y";
	var totalAmt = unformatCurrency("perilAmtTotal");
	var itemTotalAmt = unformatCurrency("itemAmtTotal");
	var perilCd = $F("perilCd");
	var itemNo = $F("itemNo");
	for(var i = 0; i<objDeductibles.length; i++){
		var delObj = new Object();
		delObj.parId			= objDeductibles[i].parId; 
		delObj.dedLineCd		= objDeductibles[i].dedLineCd; 
		delObj.dedSublineCd		= objDeductibles[i].dedSublineCd; 
		delObj.userId			= objDeductibles[i].userId; 
		delObj.itemNo			= objDeductibles[i].itemNo; 
		delObj.perilCd			= objDeductibles[i].perilCd; 
		delObj.dedDeductibleCd	= objDeductibles[i].dedDeductibleCd; 
		delObj.deductibleTitle	= objDeductibles[i].deductibleTitle; 
		delObj.deductibleAmount	= objDeductibles[i].deductibleAmount; 
		delObj.deductibleRate	= objDeductibles[i].deductibleRate; 
		delObj.deductibleText	= objDeductibles[i].deductibleText; 
		delObj.aggregateSw		= objDeductibles[i].aggregateSw; 
		delObj.ceilingSw		= objDeductibles[i].ceilingSw; 
		delObj.deductibleType	= objDeductibles[i].deductibleType; 
		delObj.minimumAmount	= objDeductibles[i].minimumAmount; 
		delObj.maximumAmount	= objDeductibles[i].maximumAmount; 
		delObj.rangeSw 			= objDeductibles[i].rangeSw; 
		if (deleteTag == "Y"){
			if ((objDeductibles[i].recordStatus != -1)
					&& (objDeductibles[i].perilCd == perilCd)
					&& (objDeductibles[i].itemNo == itemNo)){
				totalAmt = 0;
				delObj.recordStatus = -1;
				objDeductibles.splice(i, 1, delObj);
				for ( var j = 0; j < tbgPerilDeductible.geniisysRows.length; j++) {
					if((objDeductibles[i].deductibleTitle == tbgPerilDeductible.geniisysRows[j].deductibleTitle)
							&& (objDeductibles[i].deductibleType == tbgPerilDeductible.geniisysRows[j].deductibleType)
							&& (objDeductibles[i].dedDeductibleCd == tbgPerilDeductible.geniisysRows[j].dedDeductibleCd)){
						tbgPerilDeductible.deleteRow(j);
					}
				}
			}
		}else{
			if ((objDeductibles[i].deductibleType == "T")
					&& (objDeductibles[i].perilCd == perilCd)
					&& (objDeductibles[i].itemNo == itemNo)
					&& (objDeductibles[i].recordStatus != -1)){
				totalAmt = totalAmt - unformatCurrencyValue(objDeductibles[i].deductibleAmount);
				delObj.recordStatus = -1;
				objDeductibles.splice(i, 1, delObj);
				for ( var j = 0; j < tbgPerilDeductible.geniisysRows.length; j++) {
					if((objDeductibles[i].deductibleTitle == tbgPerilDeductible.geniisysRows[j].deductibleTitle)
							&& (objDeductibles[i].deductibleType == tbgPerilDeductible.geniisysRows[j].deductibleType)
							&& (objDeductibles[i].dedDeductibleCd == tbgPerilDeductible.geniisysRows[j].dedDeductibleCd)){
						tbgPerilDeductible.deleteRow(j);
					}
				}
			}
		}
		//marco - 04.24.2013 - added for item level deductibles
		if ((objDeductibles[i].deductibleType == "T")
				&& (objDeductibles[i].perilCd == 0)
				&& (objDeductibles[i].itemNo == itemNo)
				&& (objDeductibles[i].recordStatus != -1)){
			itemTotalAmt = itemTotalAmt - unformatCurrencyValue(objDeductibles[i].deductibleAmount);
			delObj.recordStatus = -1;
			objDeductibles.splice(i, 1, delObj);
			for ( var j = 0; j < tbgItemDeductible.geniisysRows.length; j++) {
				if((objDeductibles[i].deductibleTitle == tbgItemDeductible.geniisysRows[j].deductibleTitle)
						&& (objDeductibles[i].deductibleType == tbgItemDeductible.geniisysRows[j].deductibleType)
						&& (objDeductibles[i].dedDeductibleCd == tbgItemDeductible.geniisysRows[j].dedDeductibleCd)){
					tbgItemDeductible.deleteRow(j);
					tbgItemDeductible.geniisysRows[tbgItemDeductible.getCurrentPosition().toString().split(",")[1]].recordStatus = -1;
				}
			}
		}
		//marco - 04.24.2013 - added for item level deductibles
		if ((objDeductibles[i].deductibleType == "T")
				&& (objDeductibles[i].perilCd == 0)
				&& (objDeductibles[i].itemNo == 0)
				&& (objDeductibles[i].recordStatus != -1)){
			delObj.recordStatus = -1;
			objDeductibles.splice(i, 1, delObj);
		}
		
		changeTag = 1;
		objUW.hidObjGIPIS010.perilChangeTag = 1;
	}
	$("perilAmtTotal").value = formatCurrency(totalAmt).truncate(13, "...");
	$("itemAmtTotal").value = formatCurrency(itemTotalAmt).truncate(13, "...");
	if ($F("deleteTag") == "Y"){		
		deleteItemPeril2();
		$("deleteTag").value = "N";
	} else if ("Y" == $F("copyPerilTag")){
		//checkIfItemHasExistingPeril();
		showCopyPerilOverlay();
		$("copyPerilTag").value = "N";
	} else if ("perilCd" == $F("validateDedCallingElement")){				
		getPerilDetails();
	} else if ("premiumAmt" == $F("validateDedCallingElement")){	
		validateItemPerilPremAmt();
	} else if ("perilRate" == $F("validateDedCallingElement")){				
		validateItemPerilRateTG(); //validateItemPerilRate(); //edited by d.alcantara, 8.24.2012
	} else if ("perilTsiAmt" == $F("validateDedCallingElement")){				
		validateItemPerilTsiAmt();
	} else if ("perilBaseAmt" == $F("validateDedCallingElement")){				
		validateBaseAmt();
	}
}