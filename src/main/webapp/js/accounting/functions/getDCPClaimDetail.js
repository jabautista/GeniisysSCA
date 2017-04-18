function getDCPClaimDetail(claimId) {
	try {
		new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
			method: "GET",
			parameters: {
				action: "getClaimDetail",
				claimId: claimId
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				var res = JSON.parse(response.responseText);
				$("txtClaimNumber").value 	= res.claimNo;
				$("txtPolicyNumber").value	= res.policyNo;
				$("txtAssuredName").value 	= res.assured;
			}
		});
	} catch(e) {
		showErrorMessage("getDCPClaimDetail", e);
	}
}