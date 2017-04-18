// by bonok 03.21.2012
function showPrintExpiryReportRenewalsPage(callingForm){
	new Ajax.Updater("mainContents", contextPath+"/GIEXExpiryController?action=showPrintExpiryReportRenewalsPage",{
		method: "GET",
		evalScripts: true,
		asynchronous: true,
		onCreate: function(){
			showNotice("Loading Print Expiry Reports/Documents, please wait..."); //marco - 04.18.2013
		},
		onComplete: function() {
			hideNotice("");
			objUWGlobal.callingForm = nvl(callingForm,"");
			Effect.Appear($("mainContents").down("div", 0), {duration: .001});
			setDocumentTitle("Print Expiry Reports/Documents");
		}
	});
}