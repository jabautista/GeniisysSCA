function validatePopulateDCBWithoutMessage() {
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
			if ($F("existingDCBNo") != 0) {
				showDCBNo();
			}
		}
	});
}