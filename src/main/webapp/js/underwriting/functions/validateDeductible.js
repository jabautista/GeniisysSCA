/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateDeductible(){
	try {	
		var deductibleFired = false;
		if ("N" == $F("deductiblesDeleted")){
			/*$$("div[name='ded3']").each(function(ded){
				if (!deductibleFired){
					if ((ded.down("input", 2).value == $("perilCd").value) && (ded.down("input", 0).value == $("itemNo").value)){
						if ("T" == ded.down("input", 13).value){
							$("deductibleLevel").value = "peril";
							deductibleFired = true;
							callDeleteDeductiblesAlert();
							return false;
						}
					}
				}
			});*/
			//check for peril level deductibles
			if (!deductibleFired){
				if(objDeductibles.filter(function(obj){	
					return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") &&
						obj.deductibleType == "T" && obj.perilCd == $F("perilCd");	}).length > 0){
					$("deductibleLevel").value = "peril";
					deductibleFired = true;
					if(itemTablegridSw == "Y"){
						callDeleteDeductiblesAlertTG();
					}else{
						callDeleteDeductiblesAlert();
					}						
					return false;
				}
				/*
				for (var i=0; i<objDeductibles.length; i++){
					if ((objDeductibles[i].itemNo == $F("itemNo")) 
							&& (objDeductibles[i].perilCd == $("perilCd").value)
							&& (objDeductibles[i].deductibleType == "T")
							&& (objDeductibles[i].recordStatus != -1)){
						$("deductibleLevel").value = "peril";
						deductibleFired = true;
						if(databaseName == "GEN10G"){
							callDeleteDeductiblesAlertTG();
						}else{
							callDeleteDeductiblesAlert();
						}						
						return false;
					}
				}
				*/
			}
			/*$$("div[name='ded2']").each(function(ded){
				if (!deductibleFired){
					if (ded.down("input", 0).value == $("itemNo").value){
						if ("T" == ded.down("input", 13).value){
							$("deductibleLevel").value = "item";
							deductibleFired = true;
							callDeleteDeductiblesAlert();
							return false;
						}
					}
				}
			});*/
			//check for item level deductibles
			if (!deductibleFired){
				if(objDeductibles.filter(function(obj){	
					return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") &&
						obj.deductibleType == "T";	}).length > 0){
					$("deductibleLevel").value = "item";
					deductibleFired = true;					
					if(itemTablegridSw == "Y"){
						callDeleteDeductiblesAlertTG();
					}else{
						callDeleteDeductiblesAlert();
					}						
					return false;
				}
				/*
				for (var i=0; i<objDeductibles.length; i++){
					if ((objDeductibles[i].itemNo == $F("itemNo")) 
							&& (objDeductibles[i].deductibleType == "T")
							&& (objDeductibles[i].recordStatus != -1)){
						$("deductibleLevel").value = "item";
						deductibleFired = true;
						if(databaseName == "GEN10G"){
							callDeleteDeductiblesAlertTG();
						}else{
							callDeleteDeductiblesAlert();
						}
						return false;
					}
				}
				*/
			}
			/*$$("div[name='ded1']").each(function(ded){
				if (!deductibleFired){
					if ("T" == ded.down("input", 13).value){
						$("deductibleLevel").value = "PAR";
						deductibleFired = true;
						callDeleteDeductiblesAlert();
						return false;
					}
				}
			});*/
			//checks policy level deductibles
			if (!deductibleFired){
				if(objDeductibles.filter(function(obj){	
					return nvl(obj.recordStatus, 0) != -1 && obj.deductibleType == "T";	}).length > 0){
					$("deductibleLevel").value = "PAR";
					deductibleFired = true;
					if(itemTablegridSw == "Y"){
						callDeleteDeductiblesAlertTG();
					}else{
						callDeleteDeductiblesAlert();
					}						
					return false;
				}
				/*
				for (var i=0; i<objDeductibles.length; i++){
					if ((objDeductibles[i].deductibleType == "T")
							&& (objDeductibles[i].recordStatus != -1)){
						$("deductibleLevel").value = "PAR";
						deductibleFired = true;
						if(databaseName == "GEN10G"){
							callDeleteDeductiblesAlertTG();
						}else{
							callDeleteDeductiblesAlert();
						}
						return false;
					}
				}
				*/
			}
		} 
		if (!deductibleFired){
			if ($F("deleteTag") == "Y"){				
				deleteItemPeril2();//	deleteItemPeril();
			} else if ("perilCd" == $F("validateDedCallingElement")){				
				getPerilDetails();
			} else if ("premiumAmt" == $F("validateDedCallingElement")){	
				validateItemPerilPremAmt();
			} else if ("perilRate" == $F("validateDedCallingElement")){				
				validateItemPerilRate();
			} else if ("perilTsiAmt" == $F("validateDedCallingElement")){				
				validateItemPerilTsiAmt();
			} else if ("perilBaseAmt" == $F("validateDedCallingElement")){				
				validateBaseAmt();
			} else if ("perilNoOfDays" == $F("validateDedCallingElement")){				
				validateNoOfDays();
			} else if ("perilRiCommRate" == $F("validateDedCallingElement")) { // added by d.alcantara, 12-06-2011, temporarily place this here :)
				validateItemPerilCommRate();
			} else if ("perilRiCommAmt" == $F("validateDedCallingElement")) {
				validateItemPerilCommAmt();	
			}
		}
	} catch(e){
		showErrorMessage("validateDeductible", e);
	}
}