function noTaxAllocation2(taxType, recordValidated) {

	/* Recompute premium amount and tax amount based on the collection amount entered */
	if (objAC.preChangedFlag == 'Y') {
		if (objAC.taxPriorityFlag == null) {
			showMessageBox(
					"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
					imgMessage.WARNING);
		}
		if (objAC.taxPriorityFlag == 'P') {
			/*
			 ** Premium amount has higher priority than tax amount
			 */
			if (unformatCurrencyValue(recordValidated.premCollectionAmt) == recordValidated.origCollAmt) {
				recordValidated.directPremAmt = recordValidated.origPremAmt;
				recordValidated.taxAmt = recordValidated.origTaxAmt;
			} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
					.abs(objAC.currentRecord.origPremAmt)) {
				recordValidated.directPremAmt = recordValidated.premCollectionAmt;
				recordValidated.taxAmt = formatCurrency(0);
			} else {
				recordValidated.directPremAmt = recordValidated.origPremAmt;
				recordValidated.taxAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
						- objAC.currentRecord.origPremAmt;
			}
			searchTableGrid.setValueAt(recordValidated.directPremAmt, searchTableGrid.getColumnIndex("premAmt"),recordValidated.selectedIndex);
			searchTableGrid.setValueAt(recordValidated.taxAmt, searchTableGrid.getColumnIndex("taxAmt"),recordValidated.selectedIndex);
		} else {
			/*
			 ** Tax amount has higher priority than premium amount
			 */
			if (unformatCurrencyValue(recordValidated.premCollectionAmt) == recordValidated.origCollAmt) {
				recordValidated.directPremAmt = unformatCurrencyValue(recordValidated.origPremAmt);
				recordValidated.taxAmt = recordValidated.origTaxAmt;
			} else if (Math.abs(unformatCurrencyValue(recordValidated.premCollectionAmt)) <= Math.abs(recordValidated.origTaxAmt)) {
				recordValidated.directPremAmt = formatCurrency(0);
				recordValidated.taxAmt = recordValidated.premCollectionAmt;
			} else {
				recordValidated.directPremAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
						- unformatCurrencyValue(recordValidated.origTaxAmt); //modified by jdiago 08.19.2014 : added unformatCurrencyValue to avoid NaN
				recordValidated.taxAmt = recordValidated.origTaxAmt;
			}
			searchTableGrid.setValueAt(recordValidated.directPremAmt, searchTableGrid.getColumnIndex("premAmt"),recordValidated.selectedIndex);
			searchTableGrid.setValueAt(recordValidated.taxAmt, searchTableGrid.getColumnIndex("taxAmt"),recordValidated.selectedIndex);
		}

		recordValidated.forCurrAmt = unformatCurrencyValue(recordValidated.premCollectionAmt) / parseFloat(recordValidated.currRt);
		//searchTableGrid.setValueAt(recordValidated.forCurrAmt, searchTableGrid.getColumnIndex("forCurrAmt"),recordValidated.selectedIndex);
		return recordValidated;
	}
}