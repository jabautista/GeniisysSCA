function prepareCollectionLetterParams(funcName, isSelectedAll, allRowsToPrint, rowsToPrint) { // previously saveCollectionLetter(funcName)
	var functionToExecute = funcName;
	var action = objSOA.currentPage == "printCollectionLetter" ? "saveCollectionLetterParams" : "fetchReprintCollnLetParams";
	try {
		var objParams = new Object();
		objParams.setRows = isSelectedAll ? getModifiedJSONObjects(allRowsToPrint) : getModifiedJSONObjects(rowsToPrint);

		new Ajax.Request(contextPath + "/GIACCreditAndCollectionReportsController?action=" + action, {	
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParams)//, 
				//isSelectedAll : isSelectedAll
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				changeTag = 0;
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)) {
					var printList = JSON.parse(response.responseText);
					functionToExecute(printList);
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	} catch (e) {
		showErrorMessage("prepareCollectionLetterParams", e);
	}
}