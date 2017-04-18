// irwin. 5.06.11
function savePackQuotationMortgagee(){
	try{
		strParametersPackMortg = '';
		var modRows = getModifiedJSONObjects(objPackQuoteMortgagee);
		var addRows = getAddedJSONObjects(objPackQuoteMortgagee);
		var objParameters = new Object();
		objParameters.addRows = addRows;
		objParameters.modRows = modRows;
		strParametersPackMortg = JSON.stringify(objParameters);
			new Ajax.Request(contextPath+"/GIPIQuotationMortgageeController?action=savePackQuotationMortgagee", {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					packQuoteId 	: $F("packQuoteId"),
					issCd: objMKGlobal.issCd,
					parameter: strParametersPackMortg
				},onCreate: function(){
					showNotice("Saving Mortgagee..");
					$("createPackQuotationForm").disable();
				},onComplete: function (response)	{
					if (checkErrorOnResponse(response)){
						hideNotice(response.responseText);
						$("createPackQuotationForm").enable();
						//showMessageBox(response.responseText, imgMessage.SUCCESS);
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag=0;
						$("mortgChanges").value = "N";
					}	
				}
			});

	}catch(e){
		showErrorMessage("savePackQuotationMortgagee", e);
	}
	
}