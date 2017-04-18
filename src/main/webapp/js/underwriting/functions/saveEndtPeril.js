//mrobes 07.13.2010
//Saves the the endt item peril
function saveEndtPeril(){
	try {
		new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=saveEndtPerils&globalParType="+$F("globalParType")
						+"&globalLineCd="+$F("globalLineCd")
						+"&globalSublineCd="+$F("globalSublineCd")
						+"&globalParId="+$F("globalParId")
						+"&globalPackParId="+$F("globalPackParId")
//						+"&packLineCd="+packLineCd
						+"&globalIssCd="+$F("globalIssCd"), {
			method: "POST",
			postBody: changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("itemInformationForm"))),
			onCreate: function() {
				setCursor("wait");
				showNotice("Saving Endorsement Item Perils, please wait...");
			}, 
			onComplete: function (response)	{					
				if (checkErrorOnResponse(response)) {
					hideNotice("");
					$("forDeleteDiv").update("");
					$("forInsertDiv").update("");
					$("delDiscounts").value = "N";
					$("delPercentTsiDeductibles").value = "N";
					$("updateEndtTax").value = "N";
				}
				setCursor("default");
			}
		});
	} catch (e) {
		showErrorMessage("saveEndtPeril", e);
	}	
}