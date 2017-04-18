function deleteAllMediaInServerInstallationDirectory() {
	try{
		if (updater != undefined) {
			updater.stop();
		}
		if($("mainContents").down("input", 0) != undefined){// added by irwin
			new Ajax.Request(contextPath
					+ "/FileUploadController?action=deleteAllMedia&quoteId="
					+ $("mainContents").down("input", 0).value, {
				asynchronous : true,
				evalScripts : true
			});	
		}	
	}catch(e){
		showErrorMessage("deleteAllMediaInServerInstallationDirectory",e);
	}
}