// assured maintenance
function showMaintainAssuredForm(assuredNo) {
	new Ajax.Updater("mainContents", contextPath+"/GIISAssuredController?action=maintainAssured", {
		method: "GET",
		parameters: {
			assuredNo: assuredNo
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function () {
			Effect.Fade($("mainContents").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					if (assuredNo.blank()) {
						showNotice("Creating form, please wait...");
					} else {
						showNotice("Getting assured information, please wait...");
					}
				}
			});
		},
		onComplete: function ()	{
			setDocumentTitle("Assured Maintenance");
			hideNotice("");
			Effect.Appear($("mainContents").down("div", 0), {
				duration: .001,
				afterFinish: function () {
					initializeAccordion();
					addStyleToInputs();
					initializeAll();
				}
			});
		}
	});
}