//mrobes 01.15.10 save deductibles
function saveDeductible(dedLevel){
	new Ajax.Request(contextPath+"/GIPIWDeductibleController?action=saveDeductibles&globalLineCd="+$F("globalLineCd")+"&globalSublineCd="+$F("sublineCd")+"&globalParId="+$F("globalParId")+"&dedLevel="+dedLevel, {
		method: "POST",
		postBody: (dedLevel == 1 ? Form.serialize("basicInformationForm") : Form.serialize("itemInformationForm")),
		onCreate: function() {
			showNotice("Saving Deductible Details, please wait...");
		}, 
		onComplete: function (response)	{
			hideNotice("");
			checkErrorOnResponse(response);
			//if (checkErrorOnResponse(response)) {
				//if (response.responseText == "SUCCESS") {
					//hideNoticeInPopup(response.responseText);
					//Modalbox.hide();
				//}
			//}			
		}
	});	
}