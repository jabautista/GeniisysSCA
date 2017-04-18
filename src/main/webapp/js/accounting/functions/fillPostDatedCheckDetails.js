function fillPostDatedCheckDetails(apdcId) {
	new Ajax.Updater(
			"postDatedChecksTableGridDiv",
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=getPostDatedChecks",
			{
				method : "POST",
				parameters : {
					apdcId : apdcId
				},
				evalScripts : true,
				asynchronous : false,
				onCreate : function() {
					// showNotice("Getting post dated checks. Please wait...");
				},
				onComplete : function() {
					getPostDatedCheckOtherDtls("0");
				}
			});
}