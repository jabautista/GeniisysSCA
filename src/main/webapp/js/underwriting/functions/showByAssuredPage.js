/**
 * Description - shows the byAssured.jsp, contains
 * 				 list of policies by assured
 * created by - mosesBC
 * 
 */
function showByAssuredPage(){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	
	new Ajax.Updater(div, contextPath+"/GIPIPolbasicController?action=showByAssuredPage",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting by Assured page, please wait..."),
		onComplete: function () {
			//hideNotice();
			setDocumentTitle("Policies by Assured");
		}
	});
	
}