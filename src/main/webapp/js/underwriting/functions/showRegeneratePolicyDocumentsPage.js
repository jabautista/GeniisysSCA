function showRegeneratePolicyDocumentsPage(){
	new Ajax.Updater("mainContents", contextPath+"/PrintPolicyController?action=showRegeneratePolicyDocumentsPage",{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Getting Regenerate Policy Documents page, please wait..."),
		onComplete: function () {
			hideNotice("");
			Effect.Appear($("mainContents").down("div", 0), {duration: .001}); //"mainContents"
			setDocumentTitle("Regenerate Policy Documents");
		}
	});
}