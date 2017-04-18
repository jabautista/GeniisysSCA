function displayInvoicesToRows() {
	for(var i=0; i<objAC.policyInvoices.length; i++) {
		objAC.currentRecord = new Object();
		objAC.currentRecord = objAC.policyInvoices[i];
		objAC.currentRecord.selectedIndex2 = i;
		
		var invoiceRowId = objACGlobal.gaccTranId + 
		objAC.currentRecord.issCd + objAC.currentRecord.premSeqNo +
		objAC.currentRecord.instNo + objAC.currentRecord.tranType;
		if (getObjectFromArrayOfObjects(objAC.objGdpc, 
			    "gaccTranId issCd premSeqNo instNo tranType",
			    invoiceRowId) == null) {
			validateGIACS007Policy(objAC.currentRecord.premSeqNo, objAC.currentRecord.instNo, 
					objAC.currentRecord.issCd, objAC.currentRecord.tranType);
		}
		break;
	}
	if(objAC.policyInvoices.length == 0) {
		objAC.overdueOverride = null;
		objAC.claimsOverride = null;
		objAC.cancelledOverride = null;
	}
	//computeTotalAmountsGIACS7();
}