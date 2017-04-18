function getTableGridLOVs() {
	var returnLOVObj = new Object();
	new Ajax.Request(contextPath
			+ "/GIACAcknowledgmentReceiptsController?action=getTableGridLOVs",
			{
				method : "GET",
				evalScripts : true,
				asynchronous : false,
				onSuccess : function(response) {
					if (checkErrorOnResponse(response)) {
						tempChkClassObj = JSON.parse(response.responseText);
					}
				}
			});

	returnLOVObj.bankListingLOV = prepareLOVForTableGrid(
			tempChkClassObj.bankListingLOV, "bankCd", "bankSname");
	returnLOVObj.checkClassLOV = prepareLOVForTableGrid(
			tempChkClassObj.checkClassLOV, "rvLowValue", "rvMeaning");
	returnLOVObj.currencyListingLOV = prepareLOVForTableGrid(
			tempChkClassObj.currencyListingLOV, "code", "shortName");
	returnLOVObj.transactionTypeLOV = prepareLOVForTableGrid(
			tempChkClassObj.transactionTypeLOV, "rvLowValue", "rvLowValue");
	returnLOVObj.paymentModeLOV = prepareLOVForTableGrid(
			tempChkClassObj.paymentModeLOV, "rvLowValue", "rvLowValue");

	return returnLOVObj;
}