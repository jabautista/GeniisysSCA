function setEndtPerilForm(objRowEndtPeril)	{
	try {	
		var itemCount = countItem("A");
		
		if(objRowEndtPeril == null){
			$("perilCd").value = "";
			$("hidPerilRecFlag").value = "";
		} else {
			$("perilCd").value = objRowEndtPeril.perilCd;
			$("txtPerilName").value = unescapeHTML2(objRowEndtPeril.perilName);
		}

		//if($("inputDeductible3") != null){
			var tempPerilCd = null;

			$$("div[name='rowEndtPeril']").each(function(row){
				if (row.hasClassName("selectedRow")){
					tempPerilCd = row.down("input", 1).value;
				}
			});

			toggleEndtPerilDeductibles($F("itemNo"), ($F("perilCd") == "" ? tempPerilCd : $F("perilCd")));					
		//}
		
		if(objRowEndtPeril == null){
			$("txtPerilName").value = "";
			$("perilCd").value = "";
		} else {
			var tariffs = $("inputPerilTariff"+$F("perilCd"));
			if(nvl(tariffs, null) != null){ //marco - 04.14.2014 - added condition to handle lines without tariff
				for (var k=0; k < tariffs.length; k++) {
					if (tariffs.options[k].value == objRowEndtPeril.tarfCd){						
						tariffs.selectedIndex = k;
					}
				}
			}
		}			
		//robert 10.09.2012 added condition for cancel tag
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("perilCd").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputPremiumRate").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputTsiAmt").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputPremiumAmt").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputAnnPremiumAmt").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputCompRem").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputAnnTsiAmt").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputRiCommRate").disable() : "");			
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputPerilTariff").disable() : "");
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? $("inputCompRem").setStyle({backgroundColor: "white"}) : $("inputCompRem").setStyle({backgroundColor: ""}));
		(objGIPIWPolbas.polFlag == "4" || objUWGlobal.cancelTag == "Y" ? disableButton("btnAddPeril") : "");
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? $("btnAddPeril").value = (objRowEndtPeril == null ? "Add" : "Update") : "");			
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? (objRowEndtPeril == null ? disableButton("btnDeletePeril") : enableButton("btnDeletePeril")) : disableButton("btnDeletePeril"));
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? (objRowEndtPeril == null ? $("perilCd").enable() : $("perilCd").disable()) : "");			
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? (itemCount > 1 && $$("div[name='rowEndtPeril']").size() > 0 ? enableButton("btnCopyPeril") : disableButton("btnCopyPeril")) : disableButton("btnCopyPeril"));
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? ($$("div[name='rowEndtPeril']").size() > 0 ? enableButton("btnCommission") : disableButton("btnCommission")) : disableButton("btnCommission"));

		var discExist = checkEndtPerilDiscount(objGIPIWItemPeril);
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? (discExist == true ? enableButton("btnDeleteDiscounts") : disableButton("btnDeleteDiscounts")) : disableButton("btnDeleteDiscounts"));											
		(objGIPIWPolbas.polFlag != "4" && nvl(objUWGlobal.cancelTag, "N") == "N" ? enableButton("btnRetrievePerils") : disableButton("btnRetrievePerils"));
					
		getPolPerilAmounts($F("perilCd"));
		togglePerilTariff($F("perilCd"));
		
		if($("riSwitch") != null && $F("riSwitch") == "Y"){
			setEndtPerilRIFormLabels();
		}
	} catch(e){
		showErrorMessage("setEndtPerilForm", e);
	}
}