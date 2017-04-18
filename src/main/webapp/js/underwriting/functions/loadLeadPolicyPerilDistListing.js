function loadLeadPolicyPerilDistListing(){
	if($("lpPerilDistDiv").innerHTML != ""){
		$("lpInvoiceInfoMainSectionDiv").hide();
		$("lpInvButtonsDiv").hide();
		$("lpPerilDistDiv").show();
	}else{
		new Ajax.Updater("lpPerilDistDiv", contextPath+"/GIPILeadPolicyController",{
			parameters: {
				parId: $F("globalParId"),
				lineCd: $F("globalLineCd"),
				dspRate: $F("hidRate"),
				action: "showLeadPolicyInvPerlListing"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading lead policy Peril Distribution listing..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$$("div[name='lpItemGrpRow']").invoke("removeClassName", "selectedRow");
					$("lpInvoiceInfoMainSectionDiv").hide();
					$("lpInvButtonsDiv").hide();
					$("lpPerilDistDiv").show();
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
}