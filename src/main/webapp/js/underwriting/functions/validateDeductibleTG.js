/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.16.2011	mark jm			table grid version
 */
function validateDeductibleTG(){
	try {	
		var deductibleFired = false;
		
		if(objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo"); }).length > 0){
			if(objDeductibles.filter(function(obj){	
				return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") &&
					obj.deductibleType == "T" && obj.perilCd == $F("perilCd");	}).length > 0){
				$("deductibleLevel").value = "peril";
				deductibleFired = true;
				//if(itemTablegridSw == "Y"){
					callDeleteDeductiblesAlertTG();
				/*}else{
					callDeleteDeductiblesAlert();
				}*/						
				return false;
			}else if(objDeductibles.filter(function(obj){	
				return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo") &&
					obj.deductibleType == "T" && obj.perilCd == 0;	}).length > 0){ // andrew - 07.26.2012 - added perilCd in condition SR 10175
				$("deductibleLevel").value = "item";
				deductibleFired = true;			
				//if(itemTablegridSw == "Y"){
					callDeleteDeductiblesAlertTG();
				/*}else{
					callDeleteDeductiblesAlert();
				}*/						
				return false;
			}else if(objDeductibles.filter(function(obj){	
				return nvl(obj.recordStatus, 0) != -1 && obj.deductibleType == "T" && obj.itemNo == 0 && obj.perilCd == 0;	}).length > 0){ // andrew - 07.26.2012 - added itemNo and perilCd in condition SR 10175
				$("deductibleLevel").value = "PAR";
				deductibleFired = true;
				//if(itemTablegridSw == "Y"){
					callDeleteDeductiblesAlertTG();
				/*}else{
					callDeleteDeductiblesAlert();
				}*/						
				return false;
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
				validateItemPerilRateTG(); //validateItemPerilRate();
			} else if ("perilTsiAmt" == $F("validateDedCallingElement")){				
				validateItemPerilTsiAmt();
			} else if ("perilBaseAmt" == $F("validateDedCallingElement")){				
				validateBaseAmt();
			} else if ("perilNoOfDays" == $F("validateDedCallingElement")){				
				validateNoOfDays();
			}else if("perilRiCommRate" == $F("validateDedCallingElement")){// added by: Nica 06.15.2012
				$("perilRiCommAmt").value = formatCurrency(($F("premiumAmt")).replace(/,/g, "")*$F("perilRiCommRate")/100);
			}else if("perilRiCommAmt" == $F("validateDedCallingElement")){ // added by: Nica 06.15.2012
				if(unformatCurrencyValue($F("perilRiCommAmt")) > unformatCurrencyValue($F("premiumAmt"))){
					showMessageBox("Peril RI Commission Amount must not be greater than Premium amount.");
					$("perilRiCommAmt").value = "";
					if ($("perilRiCommRate").value != "" || $("perilRiCommRate").value != null){ //edgar 01/12/2015
						$("perilRiCommAmt").value = formatCurrency(($F("premiumAmt")).replace(/,/g, "")*$F("perilRiCommRate")/100);
					}
				}else{
					var perilRiCommRate= $("perilRiCommAmt").value == "" ? 0 : ($F("perilRiCommAmt")).replace(/,/g, "")/($F("premiumAmt").replace(/,/g, ""))*100;
					$("perilRiCommRate").value = formatToNineDecimal(perilRiCommRate);
				}
			}
		}
	} catch(e){
		showErrorMessage("validateDeductibleTG", e);
	}
}