function showByEndorsementTypePage(){ //Rey 07-19-2011
	//var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	$("polMainInfoDiv").hide();
	$("viewPolInfoMainDiv").hide();
	new Ajax.Updater("endtTypeDiv", contextPath+"/GIPIPolbasicController?action=showByEndorsementTypePage",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting by Endorsement page, please wait..."),
		onComplete: function () {
			//hideNotice();
			setDocumentTitle("Policies by Endorsement");
		}
	});
	
}