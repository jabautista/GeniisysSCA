/**
 *  show attached media overlay
 */

function openAttachMediaOverlay(uploadMode) {
	try {
		var genericId = getGenericId(uploadMode);
		var itemNo = $("itemNo") ? $F("itemNo") : $F("txtItemNo");
		
		attachMediaOverlay = Overlay.show(contextPath + "/FileController", {
			urlContent: true,
			urlParameters: {
				action: "showAttachMediaPage2",
				genericId: genericId,
				itemNo: itemNo,
				uploadMode: uploadMode
			},
			title: "Attach Media",
			height: 380,
			width: 620,
			draggable: true,
			showNotice: true
		});
	} catch(e) {
		showErrorMessage("openAttachMediaOverlay", e);
	}
}

function openAttachMediaOverlay2(uploadMode, genericId, itemNo) {
	try {
		attachMediaOverlay = Overlay.show(contextPath + "/FileController", {
			urlContent: true,
			urlParameters: {
				action: "showAttachMediaPage2",
				genericId: genericId ? genericId : 0,
				itemNo: itemNo ? itemNo : 0,
				uploadMode: uploadMode
			},
			title: "Attach Media",
			height: 380,
			width: 620,
			draggable: true,
			showNotice: true
		});
	} catch(e) {
		showErrorMessage("openAttachMediaOverlay2", e);
	}
}