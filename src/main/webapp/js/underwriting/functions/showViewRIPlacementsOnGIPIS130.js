function showViewRIPlacementsOnGIPIS130(){
	try{
		new Ajax.Request(contextPath+"/GIRIBinderController",{
			parameters: {
				action: "showViewRIPlacements"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					$("viewDistributionStatusMainDiv").style.display = "none";
					$("gipis130TempDiv").style.display = null;
					$("gipis130TempDiv").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showViewRIPlacements", e);
	}
}