function showPrintCheckDVPage(objDV, gaccTranId) {
	try {
		overlayGIACS052 = Overlay.show(contextPath
				+ "/GIACChkDisbursementController", {
			urlContent : true,
			urlParameters : {
				action : "showGIACS052",
				tranId : gaccTranId
			},
			showNotice : true,
			title : "Print Check/DV",
			height : 410,
			width : 700,
			draggable : true
		});
	} catch (e) {
		showErrorMessage("showPrintCheckDVPage: " + e);
	}
}