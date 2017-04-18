function getPolPerilAmounts(perilCd){
	try {
		//Check if the peril to be added is existing in the policy item peril records.
		//Get the annualized tsi and annualized premium if existing.
		var exists = false;
		
/*		if(undefined != objCurrItemPeril || null != objCurrItemPeril) {
			for(var i=0; i<objGIPIItemPeril.length; i++){	
				if(objGIPIItemPeril[i].itemNo == objCurrItemPeril.itemNo && objGIPIItemPeril[i].perilCd == objCurrItemPeril.perilCd){
					$("inputPremiumRate").value 	= formatToNineDecimal(nvl(objGIPIItemPeril[i].premiumRate, "0"));
					$("inputAnnTsiAmt").value 		= formatCurrency(nvl(objGIPIItemPeril[i].annTsiAmount, "0"));
					$("inputAnnPremiumAmt").value 	= formatCurrency(nvl(objGIPIItemPeril[i].annPremiumAmount, "0"));
					annTsiAmountCopy 				= objGIPIItemPeril[i].annTsiAmount;
					annPremiumAmountCopy 			= objGIPIItemPeril[i].annPremAmount;
					exists = true;
				}
			}
		} else {*/
			for(var i=0; i<objGIPIItemPeril.length; i++){				
				if(objGIPIItemPeril[i].itemNo == $F("itemNo") && objGIPIItemPeril[i].perilCd == $F("perilCd")){					
					$("inputPremiumRate").value 	= formatToNineDecimal(nvl(objGIPIItemPeril[i].premiumRate, "0"));
					$("inputAnnTsiAmt").value 		= formatCurrency(nvl(objGIPIItemPeril[i].annTsiAmount, "0"));
					$("inputAnnPremiumAmt").value 	= formatCurrency(nvl(objGIPIItemPeril[i].annPremiumAmount, "0"));										
					annTsiAmountCopy 				= objGIPIItemPeril[i].annTsiAmount;
					annPremiumAmountCopy 			= objGIPIItemPeril[i].annPremiumAmount;					
					exists = true;
					$("inputRiCommRate").value 		= formatToNineDecimal(nvl(objGIPIItemPeril[i].riCommRate, "0"));
					$("inputRiCommAmt").value		= formatCurrency((nvl(objGIPIItemPeril[i].riCommRate, 0) * nvl($F("inputPremiumAmt").replace(/,/g, ""), 0)) / 100);
					$("inputNoOfDays").value 		= objGIPIItemPeril[i].noOfDays == null ? null : objGIPIItemPeril[i].noOfDays == "" ? "" : parseInt(objGIPIItemPeril[i].noOfDays); //remove by steven 9/11/2012 formatCurrency(objGIPIItemPeril[i].noOfDays);
					$("inputBaseAmt").value			= formatCurrency(objGIPIItemPeril[i].baseAmount);
					break;
				}
			}
		//}
		
		if (!exists){			
			setEndtPerilFields(null);
						
			annTsiAmountCopy 	 = 0;
			annPremiumAmountCopy = 0;
		
			if ($F("globalCtplCd") == perilCd && (objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN)){				
				/*var dfltTsi = $("perilCd").options[$("perilCd").selectedIndex].getAttribute("dfltTsi");
				$("inputTsiAmt").value 		= formatCurrency(nvl(dfltTsi, "0"));			
				$("inputAnnTsiAmt").value 	= formatCurrency(nvl($F("inputTsiAmt"), "0"));*/
			}
			
		}

		if (parseFloat($F("inputTsiAmt")) == 0
			&& parseFloat($F("inputPremiumAmt")) == 0
			&& parseFloat($F("inputAnnTsiAmt")) == 0
			&& parseFloat($F("inputPremiumRate")) == 0 
		    && objGIPIWPolbas.issCd != "RI" //hardcoded muna
		    //&& $("perilCd").options[$("perilCd").selectedIndex].getAttribute("defaultTag") == "Y"
		    	){					
			   //$("inputPremiumRate").value = formatToNineDecimal($("perilCd").options[$("perilCd").selectedIndex].getAttribute("defaultRate"));				   
		} 
		
		if ((objUWGlobal.lineCd == objLineCds.MN 
				|| objUWGlobal.menuLineCd == objLineCds.MN)
			 && $F("perilCd") != ""
			 && $F("btnAddPeril") == "Add" 
		     && parseFloat($F("inputPremiumRate")) == 0 
		     && objGIPIWPolbas.issCd != "RI"){ //hardcoded

			getFireTariff();
		}					
		
		if ($F("globalCtplCd") == perilCd && ($F("globalLineCd") == objLineCds.MC || objUWGlobal.menuLineCd == objLineCds.MC)){		
			var prorateFlag  = parseFloat($F("prorateFlag")); 
			var premAmt		 = computePerilPremAmount(prorateFlag, $F("ctplDfltTsiAmt"), $("inputPremiumRate").value);
			if (objUWParList.issCd != "RI"){
				//edited by d.alcantara, to retrieve MC line when in package
				if(nvl($F("inputTsiAmt"), "0.00") == "0.00") {
					$("inputTsiAmt").value 		= formatCurrency($("ctplDfltTsiAmt").value);
					$("inputAnnTsiAmt").value 	= $("inputTsiAmt").value;
					$("inputPremiumAmt").value  = premAmt;
					$("inputAnnPremiumAmt").value = premAmt;
				}
			}
		}
		
		hidTsiAmount = $F("inputTsiAmt");
		hidPremiumAmount = $F("inputPremiumAmt");
		hidAnnTsiAmount	= $F("inputAnnTsiAmt");
		hidAnnPremiumAmount	= $F("inputAnnPremiumAmt");
	} catch (e) {
		showErrorMessage("getPolPerilAmounts", e);
	}		
}