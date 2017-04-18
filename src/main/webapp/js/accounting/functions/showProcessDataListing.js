function showProcessDataListing(){
	try {
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			parameters:{action: "showProcessDataListing"},
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
				}
			}
		});
	} catch (e){
		showErrorMessage("Process Data Listing", e);
	}
}