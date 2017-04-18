function showPolicyCertificatesPage(){
	new Ajax.Updater("mainContents", contextPath+"/PrintPolicyCertificatesController?action=showPolicyCertPrintingPage",{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Getting Policy Certificates page, please wait..."),
		onComplete: function () {
			hideNotice("");
			Effect.Appear($("mainContents").down("div", 0), {duration: .001}); //"mainContents"
			setDocumentTitle("Generate Policy Certificates");
			setModuleId("GIPIS159");
		}
	});
}