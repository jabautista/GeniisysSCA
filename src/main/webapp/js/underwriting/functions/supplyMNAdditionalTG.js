/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.20.2011	mark jm			Fill-up fields with values in marine cargo
 */
function supplyMNAdditionalTG(obj){
	try{
		$("geogCd").value				= (obj == null ? "" : unescapeHTML2(nvl(obj.geogCd, "")));
		$("cargoType").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoType, "")));
		$("cargoTypeDesc").value		= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoTypeDesc, "")));
		$("cargoClassCd").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoClassCd, "")));
		$("cargoClass").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoClassDesc, "")));
		$("packMethod").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.packMethod, "")));
		$("blAwb").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.blAwb, "")));
		$("transhipOrigin").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.transhipOrigin, "")));
		$("transhipDestination").value 	= (obj == null ? "" : unescapeHTML2(nvl(obj.transhipDestination, "")));
		$("voyageNo").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.voyageNo, "")));
		$("lcNo").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.lcNo, "")));
		//$("etd").value 					= (obj == null || nvl(obj.etd, "") == "" ? "" : dateFormat(Date.parse(obj.etd), "mm-dd-yyyy"));
		//$("eta").value 					= (obj == null || nvl(obj.eta, "") == "" ? "" : dateFormat(Date.parse(obj.eta), "mm-dd-yyyy"));
		$("printTag").value 			= (obj == null ? "1" : unescapeHTML2(nvl(obj.printTag, "")));
		$("origin").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.origin, "")));
		$("destn").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.destn, "")));
		$("invCurrCd").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.invCurrCd, "")));
		$("invCurrRt").value 			= (obj == null || nvl(obj.invCurrRt, "") == "" ? "" : formatToNineDecimal(obj.invCurrRt));
		$("invoiceValue").value 		= (obj == null || nvl(obj.invoiceValue, "") == "" ? "" : formatCurrency(obj.invoiceValue));
		$("markupRate").value 			= (obj == null || nvl(obj.markupRate, "") == "" ? "" : formatToNineDecimal(obj.markupRate));
		//$("deductibleRemarks").value 	= (obj == null ? "" : nvl(obj.deductText, ""));	
		$("recFlagWCargo").value 		= (obj == null ? "A" : "");
		
		//marco - 04.12.2013 - disable currency rate text field when currency is PHP
		if(nvl($("invCurrCd").value, "") == objFormParameters.paramDefaultCurrency){
			disableInputField("invCurrRt");
		}else{
			enableInputField("invCurrRt");
		}
		
		//fireEvent($("geogCd"), "change");
		
		$("vesselCd").value				= (obj == null) ? "" : unescapeHTML2(nvl(obj.vesselCd, ""));		
		
		function innerFunc(){
			var geogClassType = ($("geogCd").options[$("geogCd").selectedIndex]).getAttribute("geogClassType");

			$("geogCd").hide();

			if($F("geogCd").empty()){
				(($("vesselCd").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
			}else{
				(($$("select#vesselCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
				(($$("select#vesselCd option:not([vesselFlag='" + geogClassType + "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");

				$("vesselCd").options[0].show();
				$("vesselCd").options[0].disabled = false;
			}		
					
			$("geogCd").show();
		}
		
		if(obj != null){
			if(obj.vesselCd == null || obj.vesselCd != objFormVariables.varVMultiCarrier){
				$("listOfCarriersPopup").hide();
			}else{
				$("listOfCarriersPopup").show();
			}
			
			if(obj.geogCd != null){
				innerFunc();
			}
			
			var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
			 
			if((obj.etd != null || obj.etd != undefined) && !(dateformatting.test(obj.etd))){			 
				$("etd").value = dateFormat(obj.etd, "mm-dd-yyyy");
			}else{
				$("etd").value = "";
			}
			
			if((obj.eta != null || obj.eta != undefined) && !(dateformatting.test(obj.eta))){			 
				$("eta").value = dateFormat(obj.eta, "mm-dd-yyyy");
			}else{
				$("eta").value = "";
			}
		}else{
			$("listOfCarriersPopup").hide();
			innerFunc();
			
			$("etd").value = "";
			$("eta").value = "";
		}
		
		//($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		
		$("etd").setAttribute("lastValidValue", $F("etd").blank() ? "" : $F("etd"));
		$("eta").setAttribute("lastValidValue", $F("eta").blank() ? "" : $F("eta"));
		
		obj != null ? null : setMNAddlFormDefault();
				
	}catch(e){
		showErrorMessage("supplyMNAdditionalTG", e);
	}	
}