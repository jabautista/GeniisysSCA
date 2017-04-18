function getPostDatedCheckOtherDtls(pdcId) {
	new Ajax.Updater(
			'postDatedChecksDtlsTable',
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=getPostDatedChecksDtls",
			{
				method : "POST",
				parameters : {
					pdcId : pdcId
				},
				evalScripts : true,
				asynchronous : false,
				onCreate : function() {
					// showNotice("Loading post-dated check details. Please
					// wait...");
				},
				onSuccess : function() {
					// hideNotice("");
				}
			});
}