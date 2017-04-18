function showUnidentifiedCollection() {
	new Ajax.Updater(
			"transBasicInfoSubpage",
			contextPath
					+ "/GIACUnidentifiedCollnsController?action=showUnidentifiedCollection",
			{
				method : "GET",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId,
					fundCd : objACGlobal.fundCd
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Unidentified Collections...");
				},
				onComplete : function() {
					hideNotice("");
				}
			});
}