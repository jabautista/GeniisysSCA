function showIntermediaryProdPerIntm(){
	try {
		new Ajax.Request(contextPath+"/GIACEndOfMonthReportsController",{
			parameters:{action: "showIntermediaryProdPerIntm"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}
		});
	} catch (e){
		showErrorMessage("Intermediary Production Register", e);
	}
}