function setDefaultValues(){
	try {
		$$("input[type=text]").each(
			function(elem){
				if(elem.hasClassName("money") || elem.hasClassName("money1")){
					elem.value = "0.00";
				} else if(elem.hasClassName("moneyRate")){
					elem.value  = formatToNineDecimal("1.00");
				} else if (elem.hasClassName("percentRate")) {
					elem.value  = formatToNineDecimal("0");
				} else if (elem.id != "parNo" && elem.id != "policyNo" && elem.id != "assuredName"){
					elem.value = "";
				}
			}
		);

		$$("textarea").each(function(ta){
			ta.value = "";
		});
		
		$$("select").each(
			function(elem){
				elem.value = "";
			}
		);
		
		$("currency").value 		= 1;		
		$("invCurrRt").value 		= ""; 
		$("invoiceValue").value 	= "";
		$("markupRate").value 		= "";
		$("recFlagWCargo").value 	= "A";
		$("cpiRecNo").value		 	= "";
		$("cpiBranchCd").value		= "";
		$("deductText").value		= "";
		$("deleteWVes").value		= "";
		$("printTag").value 		= "1";
		showListing($("vesselCd"));
		hideListing($("cargoType"));
		$("listOfCarriersPopup").hide();
		$("paramVesselCd").value    = "";
		$("deductibleRemarks").value = "";
			
		$$("div#itemTable div[name='row']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		
		$("recFlag").value = "A";
	} catch (e) {
		showErrorMessage("setDefaultValues", e);
		//showMessageBox("setDefaultValues : " + e.message);
	}
}