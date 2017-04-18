//Pol Cruz 4.16.2013
function showGIPIS132(){
	new Ajax.Updater("dynamicDiv", contextPath+"/GIPIPolbasicController?action=showGIPIS132",{
		method: "POST",
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Getting View Policy Status page, please wait..."),
		onComplete: function () {
			hideNotice();
			//setDocumentTitle("View PAR Status");
		}
	});
	
}