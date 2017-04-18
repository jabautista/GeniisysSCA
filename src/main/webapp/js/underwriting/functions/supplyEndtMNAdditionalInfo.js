function supplyEndtMNAdditionalInfo(obj) {
	try {
		$("geogCd").value = (obj == null ? "" : nvl(obj.geogCd, ""));
		geogClassType 	  = (obj == null ? "" : $("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType"));
		
		if(geogClassType != ""){
			for(var i = 1; i < $("vesselCd").options.length; i++){ 
				if (geogClassType == $("vesselCd").options[i].getAttribute("vesselFlag")){
					showOption($("vesselCd").options[i]);
				} else {
					hideOption($("vesselCd").options[i]);
				}
			}
		} else {
			for(var i = 1; i < $("vesselCd").options.length; i++){
				showOption($("vesselCd").options[i]);				
			}	 
		}

		$("vesselCd").value 	= (obj == null ? "" : nvl(obj.vesselCd, ""));
		$("cargoClassCd").value = (obj == null ? "" : nvl(obj.cargoClassCd, ""));
		
		if($("cargoClassCd").value != ""){
			/*for(var i = 1; i < $("cargoType").length; i++){ 
				$("cargoType")[i].hide();
			}*/
			for(var i = 1; i < $("cargoType").options.length; i++){  
				if ($("cargoType").options[i].getAttribute("cargoClassCd") == $("cargoClassCd").value){
					showOption($("cargoType").options[i]);
					//$("cargoType").options[i].show();
				} else {
					hideOption($("cargoType").options[i]);
				}
			}
		}
		
		if ($("vesselCd").value == $("multiVesselCd").value && obj != null) {
			$("listOfCarriersPopup").show();
			computeTotalAmountInTable2("carrierTable","rowCarrier",4,"item",$F("itemNo"),"listOfCarrierTotalAmtDiv");
		} else {
			$("listOfCarriersPopup").hide();
		}
		
		$("cargoType").value 			= (obj == null ? "" : nvl(obj.cargoType, ""));
		$("packMethod").value 			= (obj == null ? "" : nvl(obj.packMethod, ""));
		$("blAwb").value 				= (obj == null ? "" : nvl(obj.blAwb, ""));
		$("transhipOrigin").value 		= (obj == null ? "" : nvl(obj.transhipOrigin, ""));
		$("transhipDestination").value 	= (obj == null ? "" : nvl(obj.transhipDestination, ""));
		$("voyageNo").value 			= (obj == null ? "" : nvl(obj.voyageNo, ""));
		$("lcNo").value 				= (obj == null ? "" : nvl(obj.lcNo, ""));
		$("etd").value 					= (obj == null || nvl(obj.etd, "") == "" ? "" : dateFormat(Date.parse(obj.etd), "mm-dd-yyyy"));
		$("eta").value 					= (obj == null || nvl(obj.eta, "") == "" ? "" : dateFormat(Date.parse(obj.eta), "mm-dd-yyyy"));
		$("printTag").value 			= (obj == null ? "1" : nvl(obj.printTag, ""));
		$("origin").value 				= (obj == null ? "" : nvl(obj.origin, ""));
		$("destn").value 				= (obj == null ? "" : nvl(obj.destn, ""));
		$("invCurrCd").value 			= (obj == null ? "" : nvl(obj.invCurrCd, ""));
		$("invCurrRt").value 			= (obj == null || nvl(obj.invCurrRt, "") == "" ? "" : formatToNineDecimal(obj.invCurrRt));
		$("invoiceValue").value 		= (obj == null || nvl(obj.invoiceValue, "") == "" ? "" : formatCurrency(obj.invoiceValue));
		$("markupRate").value 			= (obj == null || nvl(obj.markupRate, "") == "" ? "" : formatToNineDecimal(obj.markupRate));
		$("deductibleRemarks").value 	= (obj == null ? "" : nvl(obj.deductText, ""));	
		$("recFlagWCargo").value 		= (obj == null ? "A" : "");
		$("deductText").value			= "";
		$("deleteWVes").value			= "";
		$("paramVesselCd").value 		= "";
		
		(obj == null ? showListing($("vesselCd")) : "");
		(obj == null ? hideListing($("cargoType")) : "");
	} catch (e){
		showErrorMessage("supplyEndtMNAdditionalInfo", e);
		//showMessageBox("supplyEndtMNAdditionalInfo : " + e.message);
	}	     
}