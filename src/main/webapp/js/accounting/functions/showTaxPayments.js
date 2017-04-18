// marco - 06.06.2013
function showTaxPayments() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACTaxPaymentsController", {
		method : "GET",
		parameters : {
			action : "showTaxPayments",
			gaccTranId : objACGlobal.gaccTranId
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Tax Payments...");
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}