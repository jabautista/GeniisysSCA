function savePackQuoteENInfo(){
	try{
		if(objCurrPackQuote != null){
			fireEvent($("btnUpdateENInfo"), "click");
		}
		
		var addedENDetailsRows = getAddedJSONObjects(objQuoteENDetailList);
		var modifiedENDetailsRows = getModifiedJSONObjects(objQuoteENDetailList);
		var delENDetailsRows = getDeletedJSONObjects(objQuoteENDetailList);
		var setENDetailsRows = addedENDetailsRows.concat(modifiedENDetailsRows);

		var addedPrincipalRows = getAddedJSONObjectList(objQuotePrincipalList);
		var modifiedPrincipalRows = getModifiedJSONObjects(objQuotePrincipalList);
		var delPrincipalRows = getDeletedJSONObjects(objQuotePrincipalList);
		var setPrincipalRows = addedPrincipalRows.concat(modifiedPrincipalRows);
		
		var objParameters = new Object();
		
		objParameters.setENDetailsRows 	= prepareJsonAsParameter(setENDetailsRows);
		objParameters.delENDetailsRows 	= prepareJsonAsParameter(delENDetailsRows);
		objParameters.setPrincipalRows	= prepareJsonAsParameter(setPrincipalRows);
		objParameters.delPrincipalRows	= prepareJsonAsParameter(delPrincipalRows);

		new Ajax.Request(contextPath+"/GIPIQuotationEngineeringController",{
			method: "POST",
			asynchronous: true,
			parameters:{
				action: "saveENInfoForPackQuote",
				parameters: JSON.stringify(objParameters)
			},
			onCreate:function(){
				showNotice("Saving Engineering Basic Information, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						clearObjectRecordStatus(objQuoteENDetailList);
						clearObjectRecordStatus(objQuotePrincipalList);
						changeTag = 0;
					}else{
						showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
					}
				}else{
					showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
				}
			}
		});
		
	}catch(e){
		showErrorMessage("savePackQuoteENInfo", e);
	}
}