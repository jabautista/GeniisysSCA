//Pol Cruz 4.11.2013
/*function showGIPIS131(){ 
	new Ajax.Updater("dynamicDiv", contextPath+"/GIPIPolbasicController?action=showGIPIS131",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting View PAR Status page, please wait..."),
		onComplete: function () {
			hideNotice();
			//setDocumentTitle("View PAR Status");
		}
	});
	
}*/
//replaced by john 8.25.2015; SR#18645
function showGIPIS131() {
	try {
		dateAsOf = getCurrentDate();
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
				parameters : {
					action : "showGIPIS131",
					dateAsOf: dateAsOf
				},
				onCreate : showNotice("Retrieving Users Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGIPIS131", e);
	}
}