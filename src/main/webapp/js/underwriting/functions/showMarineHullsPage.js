/**
 * Description - shows the marineHulls.jsp,contains
 * 				 a list of marine hull policies
 * created by  - mosesBC
 */
function showMarineHullsPage(){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	
	new Ajax.Updater(div, contextPath+"/GIPIItemVesController?action=showMarineHullsPage",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Marine Hulls page, please wait..."),
		onComplete: function () {
			//hideNotice();
			setDocumentTitle("Marine Hulls");
		}
	});

}