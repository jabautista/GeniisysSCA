function showByObligeePage(){
	var div = objGIPIS100.callingForm == "GIPIS000" ? "mainContents" : "dynamicDiv"; // added by: Nica 05.23.2012
	
	new Ajax.Updater(div, contextPath+"/GIPIPolbasicController?action=showByObligeePage",{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting by Obligee page, please wait..."),
		onComplete: function () {
			//hideNotice();
			setDocumentTitle("Policies by Obligee");
		}
	});
}