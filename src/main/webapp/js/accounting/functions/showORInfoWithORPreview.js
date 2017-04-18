function showORInfoWithORPreview() {
	new Ajax.Updater("mainContents", contextPath+"/GIACOrderOfPaymentController?action=showORDetails&" ,{
		method: "GET",
		parameters : {
			gaccTranId : objACGlobal.gaccTranId
		},
		asynchronous: false,
		evalScripts: true,
		onCreate: function() {
			showNotice("Loading Transaction Basic Information. Please wait...");
		},
		onComplete: function() {
			hideNotice("");
			showORPreview();
		}
	});
}