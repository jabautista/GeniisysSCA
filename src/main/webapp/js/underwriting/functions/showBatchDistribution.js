function showBatchDistribution(){
	new Ajax.Updater("mainContents", contextPath+"/GIUWPolDistPolbasicVController?action=getGIUWPolDistPolbasicVList",{
		asynchronous: false,
		evalScripts: true,
		onCreate: function(){
			showNotice("Getting Batch Distribution page, please wait...");
		},
		onComplete: function(response){
			hideNotice();
			if(!checkErrorOnResponse(response)){
				showMessageBox(response.responseText, imgMessage.ERROR);
			};
		}
	});
}