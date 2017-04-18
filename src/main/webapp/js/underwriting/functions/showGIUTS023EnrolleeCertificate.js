function showGIUTS023EnrolleeCertificate() {
	try {
		new Ajax.Updater("mainContents", contextPath + "/GIUTS023BeneficiaryInfoController", {
			parameters : {
				action : "showGIUTS023BeneficiaryInfo"
			},
			asynchronous : true,
			evalScripts : true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response) {
				hideNotice();
			}
		});
	} catch (e) {
		showErrorMessage("enrolleeCertificate", e);
	}
}