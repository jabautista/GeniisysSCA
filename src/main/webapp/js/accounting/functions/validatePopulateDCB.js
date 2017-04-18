// Tonio 12/8/2010
function validatePopulateDCB() {
	new Ajax.Request("GIACOrderOfPaymentController?action=checkDCB", {
		method : "GET",
		parameters : {
			fundCd : objACGlobal.fundCd,
			branchCd : $F("branchCd") == "" ? objACGlobal.branchCd
					: $F("branchCd"),
			tranDate : $F("orDate")
		},
		evalScripts : true,
		asynchronous : false,
		onComplete : function(response) {
			var result = response.responseText.toQueryParams();
			$("existingDCBNo").value = result.dcbDetailNo;
			$("newDCBNo").value = result.newDCBNo;
			$("dcbYear").value = dateFormat($F("orDate"), "yyyy"); // set DCB
																	// Year
																	// after
																	// retrieving
																	// new DCB
																	// Number by
																	// MAC
																	// 01/11/2013
			showDCBReminderDetails();
		}
	});
}