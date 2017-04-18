function loadLeadPolicyTaxesListing(){
	if($("lpTaxesDiv").innerHTML != ""){
		$("lpInvoiceInfoMainSectionDiv").hide();
		$("lpInvButtonsDiv").hide();
		$("lpTaxesDiv").show();
	}else{
		new Ajax.Updater("lpTaxesDiv", contextPath+"/GIPILeadPolicyController",{
			parameters: {
				parId: $F("globalParId"),
				lineCd: $F("globalLineCd"),
				issCd: $F("globalIssCd"),
				dspRate: $F("hidRate"),
				action: "showLeadPolicyTaxesListing"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading lead policy taxes listing..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$$("div[name='lpItemGrpRow']").invoke("removeClassName", "selectedRow");
					$("lpInvoiceInfoMainSectionDiv").hide();
					$("lpInvButtonsDiv").hide();
					$("lpTaxesDiv").show();
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
}