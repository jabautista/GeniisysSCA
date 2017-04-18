//moved here from deductible.jsp
function getAmount(dedLevel, itemNo){
	try {
		var amount = 0;
		var rowName = ((objUWGlobal.packParId != null ? objCurrPackPar.parType : $F("globalParType")) == "E" ? "rowEndtPeril" : "row2");
		
		if (dedLevel == 1){
			$$("div[name='hidPeril']").each(function(peril){
				if(peril.down("input", 3).value == "B"){
					amount+= parseFloat(peril.down("input", 2).value.replace(/,/g, ""));
				}
			});
		} else if (dedLevel == 2){
			/*if ($("perilCd") != null){
				$$("div[name='"+rowName+"']").each(function(peril){
					if (peril.down("input", 0).value == itemNo){
						amount+= parseFloat(peril.down("input", 5).value.replace(/,/g, ""));
					}
				});
			} else {
				$$("div[name='hidPeril']").each(function(peril){
					if (peril.down("input", 0).value == itemNo){
						amount+= parseFloat(peril.down("input", 2).value.replace(/,/g, ""));
					}
				});
			}*/
			// andrew - 06.01.2011 - get the total amount from peril total tsi field
			if($F("globalParType") == "P"){
				amount = parseFloat($F("perilTotalTsiAmt").replace(/,/g, ""));
			} else if ($F("globalParType") == "E"){
				amount = parseFloat($F("itemTsiAmt").replace(/,/g, ""));
			}
		} else if (dedLevel == 3){
/*			$$("div[name='"+rowName+"']").each(function(peril){
				if (peril.down("input", 0).value == itemNo && peril.down("input", 3).value == $F("perilCd")){
					amount = parseFloat(peril.down("input", 5).value.replace(/,/g, ""));
				}else if(peril.down("input", 0).value == itemNo && peril.down("input", 1).value == $F("perilCd")){
					amount = parseFloat(peril.down("input", 4).value.replace(/,/g, ""));
				}
			});		*/
			// andrew - 06.01.2011 - get the amount on tsi field of the selected peril
			if($F("globalParType") == "P"){
				amount = parseFloat($F("perilTsiAmt").replace(/,/g, ""));
			} else if ($F("globalParType") == "E"){
				amount = parseFloat($F("inputTsiAmt").replace(/,/g, ""));
			}
		}
		return amount;
	} catch (e){
		showErrorMessage("getAmount", e);
	}
} 