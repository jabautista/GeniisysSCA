// Joms 10.17.12
function updateAcceptanceInfo() {
	try {
		new Ajax.Request(contextPath+"/GIRIBinderController?action=updateAcceptanceInfo", {
			method: "POST",
			asynchronous: true,
			parameters: {policyId : $F("txtPolicyId"),
						 riEndtNo : $F("txtRIEndtNo"),
						 riPolicyNo : $F("txtRIPolicyNo"),
						 riBinderNo : $F("txtRIBinderNo"),
						 //origTSIAmount : $F("txtOrigTSIAmount"),
						 origPremAmount : $F("txtOrigPremAmount"),
						 origTSIAmount : unformatCurrencyValue($F("txtOrigTSIAmount")),
						 origPremAmount : unformatCurrencyValue($F("txtOrigPremAmount")),
						 remarks : $F("txtRemarks")
						 },	
			onCreate: function() {
				$("btnSave").disable();
				$("btnCancel").disable();
				showNotice("Saving, please wait...");
			},
			onComplete: function(response) {
				changeTag = 0;
				hideNotice("");
				$("btnSave").enable();
				$("btnCancel").enable();
				if(checkErrorOnResponse(response)) {
					if(objGIUTS012.exitTag == "Y"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							objGIUTS012.exitTag = "N";
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});						
					} else {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);	
					}
					$("oldOrigTSIAmt").value = $F("txtOrigTSIAmount");
					$("oldOrigPremAmt").value = $F("txtOrigPremAmount");
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});	
	} catch(e) {
		showErrorMessage("updateAcceptanceInfo", e);
	}
}