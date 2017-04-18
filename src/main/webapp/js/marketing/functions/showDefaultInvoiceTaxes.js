/**
 * 
 * @param invoiceObj
 */
function showDefaultInvoiceTaxes(invoiceObj){
	try{
		var itemNo			= getSelectedRowId("itemRow");
		var invoiceTaxList	= invoiceObj.invoiceTaxes;
		var defaultTaxList	= invoiceObj.defaultInvoiceTaxes;
		var primarySwitch, perilSwitch, taxCode, rate, taxValue;
		var index = 0;
		var ctr = 0;
		$("selInvoiceTax").childElements().each(function(anOption) { 
			// loop along the invoiceTax options, checking their parameters
			primarySwitch	= anOption.getAttribute("primarySw");
			perilSwitch		= anOption.getAttribute("perilSw");
			taxCode			= anOption.getAttribute("value");
			rate			= parseFloat(anOption.getAttribute("rate"));
			if(rate<=0){
				taxValue = 0; // invoiceObj.premAmt;	// premiumAmount / rate;
			}else{
				taxValue = (rate/100) * invoiceObj.premAmt;	// premiumAmount / rate;
			}
			var invTaxObj = makeInvoiceTaxObject(index);
			
			if(invTaxObj == null){
				
			}else if(invTaxObj == undefined){
				
			}else{
				invTaxObj.taxAmt = taxValue;
			}
			
			// invTaxObj.fixedTaxAllocation; invTaxObj.itemGrp;
			// invTaxObj.taxAllocation; - ignore the FF..
			if(!isInvoiceTaxCodeAlreadyAdded(taxCode)) {
				if(perilSwitch == "Y"){
					if(primarySwitch == "Y"){ // c primary options be deleted?
						if(isRequiredPerilsPresent(taxCode)){
							createInvoiceTaxRow(invTaxObj);
							invoiceObj.invoiceTaxes.push(invTaxObj);
							ctr++;
						}else{
							anOption.hide(); // when it's required peril is not
												// added - disable user from adding
												// this taxCode option
						}
					}else{
						anOption.show();
					}
				}else if(primarySwitch == "Y"){
					createInvoiceTaxRow(invTaxObj);
					invoiceObj.invoiceTaxes.push(invTaxObj);
					ctr++;
				}
			}
			index++;
		});
		
		updateTaxAmountAndAmountDue();
		// compute total taxAmount of invoice
	}catch(e){
		//showMessageBox("showDefaultInvoiceTaxes: " + e, imgMessage.ERROR);
	}
}