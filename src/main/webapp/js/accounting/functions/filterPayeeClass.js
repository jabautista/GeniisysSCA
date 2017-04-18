function filterPayeeClass(lineCd, adviceId, claimId) {
	new Ajax.Updater("payeeClassDiv", "GIACDirectClaimPaymentController?action=filterPayeeClass", {
		method:			"GET",
		parameters:	{
			transType:		$F("selTransactionType"),
			lineCd:			lineCd,
			adviceId:		adviceId,
			claimId:		claimId
		},
		evalScripts:	true,
		asynchronous:	true,
		onComplete: function(){
			$("txtClaimNumber").value 	= $F("tempClaimNo");
			$("txtPolicyNumber").value	= $F("tempPolicyNo");
			$("txtAssuredName").value 	= $F("tempAssured");
			$("selPayeeClass").enable();
		}
	});
}