function showPrintCollectionLetter(){
	//var refresh = (objSOA.prevParams != null && objSOA.prevParams.prevPage == "printCollectionLetter") ? "1" : "0";
	var intmOrAssd = nvl(objSOA.prevParams.intmOrAssdNo, 0);
	try {
		new Ajax.Request(
				contextPath + "/GIACCreditAndCollectionReportsController",
				{
					parameters : {
						action : "showPrintCollectionLetter",
						viewType : objSOA.prevParams.viewType,
						intmOrAssdNo : intmOrAssd
					},
					onCreate : function() {
						showNotice("Loading Print Collection Letter page, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showPrintCollectionLetter", e);
	}
}