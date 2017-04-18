//MARINE HAUL - CARRIER INFO
function saveQuoteCarrierInfo()	{
	try {		
		if ($$("div[name='rowCarrier']").size() == 1 && $$("div[name='rowCarrier']")[0].down("input", 0).value == "MULTI" && $("quoteId") == null){
				showMessageBox("Another Carrier/Conveyance of must exist when using MULTIVESSEL.");
				$("inputVessel").focus();
		} else {
			new Ajax.Request(contextPath + "/GIPIQuoteVesAirController?action=saveCarrierInfo", {
				method: "POST",
				asynchronous: true,
				postBody: changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("carrierInfoMainForm"))),
				onCreate: function () {
					setCursor("wait");
					//$("carrierInfoMainForm").disable();
					$("btnSave").disable();
					$("btnEditQuotation").disable();
					showNotice("Saving, please wait...");
				}, 
				onComplete: function (response)	{
					hideNotice();
					setCursor("default");
					//$("carrierInfoMainForm").enable();
					$("btnSave").enable();
					$("btnEditQuotation").enable();
					//pAction = pageActions.none;	
					
					if (checkErrorOnResponse(response))	{
						$("forInsertDiv").update("");
						$("forDeleteDiv").update("");							
						setCarrierInfoForm(false, null);
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						lastAction();
						lastAction = "";						
					}										
				}
			});
		}
	} catch (e){
		showErrorMessage("saveQuoteCarrierInfo", e);
	} 
}