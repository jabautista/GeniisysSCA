function showIntermediaryProdPerLine(){
	try {
		new Ajax.Request(contextPath+"/GIACEndOfMonthReportsController",{
			parameters:{action: "showIntermediaryProdPerLine"},
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
		showErrorMessage("Agent Production", e);
	}
}