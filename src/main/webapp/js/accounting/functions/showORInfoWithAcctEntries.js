function showORInfoWithAcctEntries() {
	var dvId = objGIACS002.fromGIACS054 ? "dvDetailsDiv" : "mainContents";	// shan 09.26.2014
	if (objGIACS002.fromGIACS054) { //added by steven 10.09.2014
		$("disbursementVoucherMainDiv").hide();
		$("dvDetailsDiv").show();
	}
	new Ajax.Updater(dvId, contextPath+"/GIACOrderOfPaymentController?action=showORDetails&" ,{
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
			showAcctEntries(); 
		}
	});
}