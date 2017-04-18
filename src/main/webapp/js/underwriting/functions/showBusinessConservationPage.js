function showBusinessConservationPage(){
	new Ajax.Updater("mainContents", contextPath+"/GIEXBusinessConservationController?action=showBusinessConservationPage",{
		method: "GET",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Loading Business Conservation Page, please wait..."),
		onComplete: function() {
			hideNotice("");
			Effect.Appear($("mainContents").down("div", 0), {duration: .001});
			setDocumentTitle("Business Conservation");
		}
	});
}