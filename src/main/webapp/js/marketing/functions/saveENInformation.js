//added by patrick for menu use only 01.16.2011
//ENGG BASIC INFO
function saveENInformation(){
	new Ajax.Request(contextPath + "/GIPIQuotationEngineeringController?action=saveENInformation" , {
		method: "POST",
		parameters: {
			quoteId: $F("quoteId"),
			enggBasicInfoNum: 1,
			contractProjBussTitle: $F("enProjectName"),
			siteLocation: $F("enSiteLoc"),
			constructStartDate: $F("prompt1"),
			constructEndDate: $F("prompt3"),
			maintainStartDate: $F("prompt2"),
			maintainEndDate: $F("prompt4"),
			weeksTest: $F("weekTest"),
			timeExcess: $F("timeExcess"),
			mbiPolicyNo: $F("mbiPolicyNo"),
			parameters: prepareParameters()
		},
		evalscripts: true,
		asynchronous: false,
		onCreate: showNotice("Saving information, please wait..."),
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				changeTag = 0;
				showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
				lastAction();
				lastAction = "";
				//showMessageBox(response.responseText, imgMessage.SUCCESS);
			}
		}
	});
}