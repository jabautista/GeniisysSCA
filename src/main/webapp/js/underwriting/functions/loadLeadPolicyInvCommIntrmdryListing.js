function loadLeadPolicyInvCommIntrmdryListing(){
	if($("lpInvCommDiv").innerHTML != ""){
		$("lpInvoiceInfoMainSectionDiv").hide();
		$("lpInvButtonsDiv").hide();
		$("lpInvCommDiv").show();
	}else{
		new Ajax.Updater("lpInvCommDiv", contextPath+"/GIPILeadPolicyController",{
			parameters: {
				parId: $F("globalParId"),
				action: "showLeadPolicyIntrmdryListing"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Loading lead policy Invoice Commission..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					//loadLeadPolicyCommInvPerilListing();
					$$("div[name='lpItemGrpRow']").invoke("removeClassName", "selectedRow");
					$("lpInvoiceInfoMainSectionDiv").hide();
					$("lpInvButtonsDiv").hide();
					$("lpInvCommDiv").show();
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
}