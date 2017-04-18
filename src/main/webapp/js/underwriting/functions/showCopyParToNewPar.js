function showCopyParToNewPar(){
	try {
	    new Ajax.Updater("mainContents", contextPath+"/CopyUtilitiesController?action=showCopyParToNewPar",{
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Loading Page, please wait..."),
			onComplete: function (){
				hideNotice("");
			}
		});
	} catch (e){
		showErrorMessage("showCopyParToNewPar", e);
	}
}