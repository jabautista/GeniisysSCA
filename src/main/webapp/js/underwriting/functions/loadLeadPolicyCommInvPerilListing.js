function loadLeadPolicyCommInvPerilListing(){
	new Ajax.Updater("lpInvCommPerilDiv", contextPath+"/GIPILeadPolicyController",{
		parameters: {
			parId: $F("globalParId"),
			lineCd: $F("globalLineCd"),
			dspRate: $F("hidRate"),
			action: "showLeadPolicyCommInvPerilListing"
		},
		asynchronous: true,
		evalScripts: true,
		onCreate: showNotice("Loading lead policy Invoice Commission Peril Listing..."),
		onComplete: function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				/*$("lpInvoiceInfoMainSectionDiv").hide();
				$("lpInvButtonsDiv").hide();
				$("lpInvCommDiv").show();*/
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}