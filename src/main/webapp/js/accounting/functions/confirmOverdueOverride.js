function confirmOverdueOverride() {
	if (objAC.usedAddButton == "Y") {
		return;
	} else if (objAC.usedAddButton == "P") {
		objAC.overdueOverride = 1;
		if(objAC.giacs7TG) {
 			objAC.currentRecord.maxCollAmt = objAC.currentRecord.collAmt;
 			objAC.currentRecord.recordStatus = 0;
 			objAC.currentRecord.balanceAmtDue = 0;
			objAC.objGdpc.push(objAC.currentRecord);
			gdpcTableGrid.addBottomRow(objAC.currentRecord);
			changeTag = 1; objAC.formChanged = 'Y';
			computeTotalAmountsGIACS7(unformatCurrencyValue(objAC.currentRecord.collAmt), 
					unformatCurrencyValue(objAC.currentRecord.premAmt), 
					unformatCurrencyValue(objAC.currentRecord.taxAmt), "add");
 		} else {
 			addRecord(objAC.currentRecord);
 		}
 		objAC.policyInvoices.splice(objAC.currentRecord.selectedIndex2, 1);
 		displayInvoicesToRows();
	} else {
		objAC.rowsToAdd.push(searchTableGrid.getRow(searchTableGrid.getCurrentPosition()[1]));
	}
}