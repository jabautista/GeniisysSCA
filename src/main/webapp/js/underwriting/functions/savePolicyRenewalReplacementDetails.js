function savePolicyRenewalReplacementDetails(){
	var result = false;
	try {
		//if (renewalIsChanged == true) {
			new Ajax.Request(contextPath+"/GIPIWPolnrepController?action=saveWPolnrep&polFlag="+$F("policyStatus")+"&globalParId="+$F("globalParId"), {
				method: "POST",
				asynchronous: true,
				postBody: Form.serialize("basicInformationForm"),
				onCreate: function() {
					showNotice("Saving Renewal/Replacement Details, please wait...");
				}, 
				onComplete: function (response)	{
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS") {
							result = true;
						}
					}
				}
			});
		//}
	} catch (e) {
		showErrorMessage("savePolicyRenewalReplacementDetails", e);
		//showMessageBox(e.message, imgMessage.ERROR);
	}
	return result;
}