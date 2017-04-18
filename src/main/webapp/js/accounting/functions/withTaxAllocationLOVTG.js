function withTaxAllocationLOVTG(taxType, recordValidated) {
	try {		
		if (objAC.taxPriorityFlag == null) { 
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
		// Call procedure for the tax breakdown 
		if (Math.abs(unformatCurrencyValue(recordValidated.taxAmt)) == 0) {
			recordValidated.premAmt = recordValidated.premCollectionAmt;
			recordValidated.taxAmt = formatCurrency(0);
			
			if(recordValidated.premVatExempt != 0) {
				//recordValidated.premVatExempt = unformatCurrencyValue(recordValidated.origPremAmt);
				recordValidated.premVatExempt = recordValidated.premVatExempt; //mikel 09.03.2015; UCPBGEN SR 20211
			} else if (recordValidated.premZeroRated != 0){
				//recordValidated.premZeroRated = unformatCurrencyValue(recordValidated.origPremAmt); 
				recordValidated.premZeroRated = recordValidated.premZeroRated; //mikel 09.03.2015; UCPBGEN SR 20211
			}
			
			getTaxType(taxType, recordValidated, function(result) {
				searchTableGrid.setValueAt(result.collnAmt, searchTableGrid.getColumnIndex("collAmt"),recordValidated.selectedIndex);
			});
			
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
				} else if(((premAmt) - (premVatExempt)) != 0) { //robert 01.23.2013
					if(nvl(recordValidated.tranType, "") == 1 || nvl(recordValidated.tranType, "") == 3){ //marco - 09.18.2014 - added condition
						recordValidated.premVatable = premAmt - premVatExempt;
					}else{
						recordValidated.premVatable = (premAmt - premVatExempt) * -1;
					}
				}
			} else {
				//recordValidated.premZeroRated = premAmt; //marco - 02.05.2014 - replaced
				if(recordValidated.tranType == 1 || recordValidated.tranType == 3){
					recordValidated.premZeroRated = premAmt;
				}else{
					recordValidated.premZeroRated = parseFloat(premAmt) <= 0 ? premAmt : (-1*premAmt);
				}
				recordValidated.premVatable = 0;
				recordValidated.premVatExempt = 0;
			}
		}

		return recordValidated;
	} catch(e) {
		showErrorMessage("withTaxAllocation2", e);
	}
}