//mode = 1 when simply saving of changes in peril info page
//mode = 2 when to fire deductDiscount after saving changes - BRY
function saveWItemPerilPageChanges(mode){	
	if ("Y" == $F("fireDeleteDeductibles")){
		new Ajax.Request(contextPath+"/GIPIWDeductibleController?action=deletePerilDeductibles",{
			method:"GET",
			evalScripts:true,
			asynchronous: true,
			parameters: {
				globalParId : $F("globalParId"),
				globalLineCd : $F("globalLineCd"),
				globalSublineCd : $F("globalSublineCd")
				}
		});
	}
	new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=saveWItemPeril&globalParId="+$F("globalParId")+"&globalPackParId="+$F("globalPackParId")
			+"&globalLineCd="+$F("globalLineCd")+"&globalIssCd="+$F("globalIssCd")+"&globalPackPolFlag="+$F("globalPackPolFlag")+"&deldiscSw="+$F("deldiscSw"),{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		//postBody: Form.serialize("parInformationForm"),
		postBody: Form.serialize("itemInformationForm"),
		onCreate: function () {			
			//$("parInformationForm").disable();
			showNotice("Saving, please wait...");
		},
		onComplete: function (response)	{
			if (checkErrorOnResponse(response)) {
				hideNotice(response.responseText);
				if (mode == "2"){
					deductDiscounts();
				} else if (mode == "1"){
					$("parInformationForm").enable();
				}
			}
		}
	});
}