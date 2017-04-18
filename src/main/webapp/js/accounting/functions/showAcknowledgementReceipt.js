/**
 * Show acknowledgement receipts
 * 
 * @author Angelo Pagaduan 01.27.2011
 */
function showAcknowledgementReceipt(branchCd, moduleId) {
	new Ajax.Updater("mainContents", contextPath
			+ "/GIACAcknowledgmentReceiptsController", {
		// method: "POST",
		asynchronous : true,
		evalScripts : true,
		parameters : {
			// action : "showAcknowledgmentReceipt",
			action : "showGIACApdcPayt",
			branchCd : (branchCd == null ? "HO" : branchCd),
			moduleId : moduleId || "",
			apdcId : (objGIACApdcPayt == null ? "" : objGIACApdcPayt.apdcId)
		},
		onCreate : function() {
			showNotice("Loading acknowledgement receipt. Please wait...");
		},
		onComplete : function(response) {
			hideNotice("");
			if (checkErrorOnResponse(response)) {
				$("acExit").show(); // added by andrew - 02.18.2011
			}
		}
	});
}