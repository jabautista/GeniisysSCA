function showConvertFile(){
	try {
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			parameters:{action: "showConvertFile"},
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
		showErrorMessage("Convert File", e);
	}
}