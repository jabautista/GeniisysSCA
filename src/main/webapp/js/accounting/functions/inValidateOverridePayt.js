function inValidateOverridePayt() {
	if (objAC.usedAddButton == "Y") {
		clearInvalidPrem();
	} else if (objAC.usedAddButton == "P") { // add thru policy button 
		objAC.policyInvoices.splice(objAC.currentRecord.selectedIndex2, 1);
 		displayInvoicesToRows();
	} else { //added condition to confirm existence of column before setting of value to avoid js error --john 5.10.2016
		if (searchTableGrid.getColumnIndex('insTag') != -1){
			searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('insTag'), searchTableGrid.getCurrentPosition()[1]);
		}
		
		if (searchTableGrid.getColumnIndex('isIncluded') != -1){
			searchTableGrid.setValueAt(false,searchTableGrid.getColumnIndex('isIncluded'), searchTableGrid.getCurrentPosition()[1]);
		}
	}
}