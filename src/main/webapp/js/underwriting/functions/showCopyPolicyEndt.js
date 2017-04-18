function showCopyPolicyEndt(){
	try {
		new Ajax.Updater("mainContents", contextPath+"/CopyUtilitiesController?action=showCopyPolicyEndt",{
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (){
				hideNotice();
			}
		});
	} catch (e){
		showErrorMessage("showCopyPolicyEndt", e);
	}
}