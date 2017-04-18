function showLimitsOfLiabilitiesPage(){
	new Ajax.Updater("mainContents", contextPath+"/GIPIWOpenLiabController?action=showLimitsofLiabilitiesPage&"+Form.serialize("uwParParametersForm"),{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Getting Limits of liabilities page, please wait..."),
		onComplete: function () {
			updateParParameters();
			Effect.Appear($("mainContents").down(), {duration: .001});
			hideNotice();
		}
	});
}