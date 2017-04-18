//John Dolon 9.2.2013
function showPackagePolicyInformation(packPolId){
	new Ajax.Updater("dynamicDiv", contextPath+"/GIPIPolbasicController?action=showPackagePolicyInformation",{
		method: "POST",
		parameters: {
				packPolId : packPolId
			},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Getting View Package Policy Information page, please wait..."),
		onComplete: function () {
			hideNotice();
		}
	});
}