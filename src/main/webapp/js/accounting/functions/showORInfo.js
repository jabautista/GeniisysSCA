function showORInfo() {
	new Ajax.Updater(
			"mainContents",
			contextPath + "/GIACOrderOfPaymentController?action=showORDetails&",
			{
				method : "GET",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading Transaction Basic Information. Please wait...");
				},
				onComplete : function() {
					hideNotice("");
					// showDirectPremiumCollns(); // remove comment when
					// transBasicInformation converstion to ajaxtabs is complete
					// getDirectPremiumCollns(); //alfie
					loadDirectPremCollnsForm();
				}
			});
}