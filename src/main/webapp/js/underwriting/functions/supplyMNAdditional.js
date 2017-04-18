/*	Created by	: mark jm 03.02.2011
 * 	Description	: Fill-up fields with values in marine cargo
 * 	Parameters	: obj - the object that contains the details
 */
function supplyMNAdditional(obj){
	try{
		$("geogCd").value				= (obj == null ? "" : unescapeHTML2(nvl(obj.geogCd, "")));
		$("cargoType").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoType, "")));
		$("cargoTypeDesc").value 	= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoTypeDesc, ""))); //robert 9.18.2012
		$("cargoClassCd").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoClassCd)));
		$("cargoClass").value			= (obj == null ? "" : unescapeHTML2(nvl(obj.cargoClassDesc)));
		$("packMethod").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.packMethod, "")));
		$("blAwb").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.blAwb, "")));
		$("transhipOrigin").value 		= (obj == null ? "" : unescapeHTML2(nvl(obj.transhipOrigin, "")));
		$("transhipDestination").value 	= (obj == null ? "" : unescapeHTML2(nvl(obj.transhipDestination, "")));
		$("voyageNo").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.voyageNo, "")));
		$("lcNo").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.lcNo, "")));
		$("etd").value 					= (obj == null || nvl(obj.etd, "") == "" ? "" : dateFormat(obj.etd, "mm-dd-yyyy")); //edited by d.alcantara, removed Parse.date
		$("eta").value 					= (obj == null || nvl(obj.eta, "") == "" ? "" : dateFormat(obj.eta, "mm-dd-yyyy")); //edited by d.alcantara, removed Parse.date
		$("printTag").value 			= (obj == null ? "1" : unescapeHTML2(nvl(obj.printTag, "")));
		$("origin").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.origin, "")));
		$("destn").value 				= (obj == null ? "" : unescapeHTML2(nvl(obj.destn, "")));
		$("invCurrCd").value 			= (obj == null ? "" : unescapeHTML2(nvl(obj.invCurrCd, "")));
		$("invCurrRt").value 			= (obj == null || nvl(obj.invCurrRt, "") == "" ? "" : formatToNineDecimal(obj.invCurrRt));
		$("invoiceValue").value 		= (obj == null || nvl(obj.invoiceValue, "") == "" ? "" : formatCurrency(obj.invoiceValue));
		$("markupRate").value 			= (obj == null || nvl(obj.markupRate, "") == "" ? "" : formatToNineDecimal(obj.markupRate));
		//$("deductibleRemarks").value 	= (obj == null ? "" : nvl(obj.deductText, ""));	
		$("recFlagWCargo").value 		= (obj == null ? "A" : "");
		
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
		}else{
			$("listOfCarriersPopup").hide();
			innerFunc();
		}
		
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");		
	}catch(e){
		showErrorMessage("supplyMNAdditional", e);
	}	
}