function withTaxAllocation2(taxType, recordValidated) {
	try {
		// setting of tax allocation for the LOV
		/*if ($F("tranType") == "1" || $F("tranType") == "4") {
			if (unformatCurrencyValue(recordValidated.premCollectionAmt) < 0) {
				customShowMessageBox("Negative transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				return;
			}
		} else {
			if (unformatCurrencyValue(recordValidated.premCollectionAmt) > 0) {
				customShowMessageBox("Positive transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				return;
			}
		}*/
		
		/* Recompute premium amount and tax amount based on the collection amount entered */
		//if (objAC.preChangedFlag == 'Y') {
			
			if (objAC.taxPriorityFlag == null) { //$F("taxPriorityFlag") modified by alfie 12.10.2010
				showMessageBox(
						"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
						imgMessage.WARNING);
				return;
			}
			
			if (objAC.taxPriorityFlag == 'P') {
				/*
				 ** Premium amount has higher priority than tax amount
				 */
				if (unformatCurrencyValue(recordValidated.premCollectionAmt) == parseFloat(recordValidated.origCollAmt)) {
					recordValidated.premAmt = recordValidated.origPremAmt;
					//$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt); //$F("origPremAmt");
					recordValidated.taxAmt = recordValidated.origTaxAmt;
				} else if (Math.abs(unformatCurrencyValue(recordValidated.origCollAmt)) <= Math
						.abs(unformatCurrencyValue(recordValidated.origPremAmt))) {
					recordValidated.premAmt = recordValidated.premCollectionAmt;
					recordValidated.taxAmt = formatCurrency(0);
				} else {
					recordValidated.premAmt = formatCurrency(recordValidated.origPremAmt);
					recordValidated.taxAmt = formatCurrency(unformatCurrencyValue(recordValidated.premCollectionAmt)
							- parseFloat(recordValidated.origPremAmt
									.replace(/,/g, "")));
				}
			} else {
				/*
				 ** Tax amount has higher priority than premium amount
				 */
				if (Math.abs(unformatCurrencyValue(recordValidated.premCollectionAmt)) == Math
						.abs(parseFloat(recordValidated.origCollAmt))) {
					recordValidated.premAmt = (recordValidated.origPremAmt);
					recordValidated.taxAmt = recordValidated.origTaxAmt;
					
				} else if (Math.abs(unformatCurrencyValue(recordValidated.premCollectionAmt)) <= Math
						.abs(parseFloat(unformatCurrencyValue(recordValidated.origTaxAmt)))) {
					recordValidated.directPremAmt = formatCurrency(0);
					recordValidated.taxAmt = recordValidated.premCollectionAmt;
				} else {
					recordValidated.directPremAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
							- parseFloat(unformatCurrencyValue(recordValidated.origTaxAmt));
					recordValidated.taxAmt = formatCurrency(unformatCurrencyValue(""+recordValidated.origTaxAmt));
				}
			}
			if (objAC.currentRecord.otherInfo) {
				recordValidated.forCurrAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
						/ parseFloat(recordValidated.currRt);
			} else {
				recordValidated.forCurrAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
						/ parseFloat(recordValidated.currRt);
			}
			
			recordValidated.paramPremAmt = recordValidated.paramPremAmt==null ? recordValidated.maxPremVatable 
					: objAC.currentRecord.paramPremAmt; //gagamitin to sa saving :)
			recordValidated.prevPremAmt = unformatCurrencyValue(recordValidated.origPremAmt);
			recordValidated.prevTaxAmt = unformatCurrencyValue(recordValidated.origTaxAmt);
			
			searchTableGrid.setValueAt(recordValidated.paramPremAmt, searchTableGrid.getColumnIndex("paramPremAmt"),recordValidated.selectedIndex);
			searchTableGrid.setValueAt(recordValidated.prevPremAmt, searchTableGrid.getColumnIndex("prevPremAmt"),recordValidated.selectedIndex);
			searchTableGrid.setValueAt(recordValidated.prevTaxAmt, searchTableGrid.getColumnIndex("prevTaxAmt"),recordValidated.selectedIndex);
			// Call procedure for the tax breakdown 
			if (Math.abs(unformatCurrencyValue(recordValidated.taxAmt)) == 0) {
				recordValidated.premAmt = recordValidated.premCollectionAmt;
				recordValidated.taxAmt = formatCurrency(0);
				
				if(recordValidated.premVatExempt != 0) {
					recordValidated.premVatExempt = unformatCurrencyValue(recordValidated.origPremAmt);
				} else if (recordValidated.premZeroRated != 0){
					recordValidated.premZeroRated = unformatCurrencyValue(recordValidated.origPremAmt);
				}
				
				searchTableGrid.setValueAt(recordValidated.premAmt, searchTableGrid.getColumnIndex("premAmt"),recordValidated.selectedIndex);
				searchTableGrid.setValueAt(recordValidated.premZeroRated, searchTableGrid.getColumnIndex("premZeroRated"),recordValidated.selectedIndex);
				searchTableGrid.setValueAt(recordValidated.premVatable, searchTableGrid.getColumnIndex("premVatable"),recordValidated.selectedIndex);
				searchTableGrid.setValueAt(recordValidated.premVatExempt, searchTableGrid.getColumnIndex("premVatExempt"),recordValidated.selectedIndex);
			} else {
				recordValidated.prevPremAmt = unformatCurrencyValue(recordValidated.origPremAmt); 
				
				getTaxType(taxType, recordValidated, function(result) {
					searchTableGrid.setValueAt(result.collnAmt, searchTableGrid.getColumnIndex("collAmt"),recordValidated.selectedIndex);
					searchTableGrid.setValueAt(result.premAmt, searchTableGrid.getColumnIndex("premAmt"),recordValidated.selectedIndex);
					searchTableGrid.setValueAt(result.taxAmt, searchTableGrid.getColumnIndex("taxAmt"),recordValidated.selectedIndex);
					searchTableGrid.setValueAt(result.premVatExempt, searchTableGrid.getColumnIndex("premVatExempt"),recordValidated.selectedIndex);
				});
				
				var premVatExempt = searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("premVatExempt"), recordValidated.selectedIndex);
				var premAmt = unformatCurrencyValue(searchTableGrid.getValueAt(searchTableGrid.getColumnIndex("premAmt"), recordValidated.selectedIndex));
				premVatExempt = premVatExempt==null ? recordValidated.premVatExempt : premVatExempt;
				
				if(recordValidated.premZeroRated == 0) {
					if(((premAmt) - (premVatExempt)) == 0) {
						recordValidated.premVatable = 0;
					} else if(((premAmt) - (premVatExempt)) != 0) {//robert 01.23.2013
						if(nvl(recordValidated.tranType, "") == 1 || nvl(recordValidated.tranType, "") == 3){ //marco - 09.18.2014 - added condition
							recordValidated.premVatable = premAmt - premVatExempt;
						}else{
							recordValidated.premVatable = (premAmt - premVatExempt) * -1;
						}
					}
				} else {
					recordValidated.premZeroRated = premAmt;
					recordValidated.premVatable = 0;
					recordValidated.premVatExempt = 0;
				}
				
				searchTableGrid.setValueAt(recordValidated.premZeroRated, searchTableGrid.getColumnIndex("premZeroRated"),recordValidated.selectedIndex);
				searchTableGrid.setValueAt(recordValidated.premVatable, searchTableGrid.getColumnIndex("premVatable"),recordValidated.selectedIndex);
				searchTableGrid.setValueAt(recordValidated.premVatExempt, searchTableGrid.getColumnIndex("premVatExempt"),recordValidated.selectedIndex);
			}
			//objAC.preChangedFlag = 'N';
		//}
		return recordValidated;
	} catch(e) {
		showErrorMessage("withTaxAllocation2", e);
	}
}