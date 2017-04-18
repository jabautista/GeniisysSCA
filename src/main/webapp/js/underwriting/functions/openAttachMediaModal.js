//mrobes 01.04.10 shows media attachment modal
/* MODE LEGEND:
 *   par 	 = GIPI_WPICTURES
 *   policy	 = GIPI_PICTURES
 *   extract = GIXX_PICTURES
 * */
function openAttachMediaModal(uploadMode){
	try {
		var id = getGenericId(uploadMode);
		
		Modalbox.show(contextPath+"/FileController", {
			method: "GET",
			title: "Attach Media",
			width: 525,
			params: {genericId:  id,
					 itemNo: 	 $("itemNo") ? $F("itemNo") :$F("txtItemNo"),
					 uploadMode: uploadMode,
					 action: 	 "showAttachMediaPage"},
			beforeHide: function () {
				$("forDeletionDiv").update("");
				deleteUpload(uploadMode);
			},
			afterHide: function () {
				if (updater != undefined) {
					updater.stop();
				}
				
				new Ajax.Request(contextPath+"/FileController?action=deleteFilesFromServer", {
					asynchronous: true,
					evalScripts: true
				});
			}
		});
	} catch (e) {
		showErrorMessage("openAttachMediaModal", e);
	}
}