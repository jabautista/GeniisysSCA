/**
 * @author rey
 * @date 08.11.2011
 * policy by assure in acct of
 */
function showByAssuredAcctOfPage(){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	
	new Ajax.Updater(div, contextPath+"/GIPIPolbasicController?action=showByAssuredAcctOfPage",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting by Assured in Account Of page, please wait..."),
		onComplete: function () {
			hideNotice();
			setDocumentTitle("Policies by Assured in Account Of");
		}
	});
	
}