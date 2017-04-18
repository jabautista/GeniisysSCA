/**
 * Shows the records in the subPages that dependent to the item row.
 * @param row - item row that is selected.
 * 
 */

function showQuoteItemChildRecordDetails(row){
	
	/* Quote Additional Information */
	populatePackQuoteAdditionalInfo();
		
	/* Quote Item Peril Records*/
	($$("div#itemPerilTable div[name='perilRow']")).invoke("removeClassName", "selectedRow");
	($$("div#itemPerilTable div[name='perilRow']")).invoke("show");
	($$("div#quoteItemPerilTableContainer div:not([quoteId='" + row.getAttribute("quoteId") + "'])")).invoke("hide");
	($$("div#quoteItemPerilTableContainer div:not([itemNo='" + row.getAttribute("itemNo") + "'])")).invoke("hide");
	resizeTableBasedOnVisibleRows("itemPerilTable", "quoteItemPerilTableContainer");
	
	/* Quote Deductibles Records*/
	if($("addDeductibleForm")!= null){
		($$("div#quoteDeductiblesTable div[name='deductibleRow']")).invoke("removeClassName", "selectedRow");
		($$("div#quoteDeductiblesTable div[name='deductibleRow']")).invoke("show");
		($$("div#quoteDeductibleTableContainer div:not([quoteId='" + row.getAttribute("quoteId") + "'])")).invoke("hide");
		($$("div#quoteDeductibleTableContainer div:not([itemNo='" + row.getAttribute("itemNo") + "'])")).invoke("hide");
		resizeTableBasedOnVisibleRowsWithTotalAmount("quoteDeductiblesTable", "quoteDeductibleTableContainer");
		$("totalDeductibleAmount").innerHTML = computeTotalDeductibleAmountForPackageQuotation();
		$("txtItemDisplay").value 	= $("txtItemTitle").value;
		$("txtItemDisplay").writeAttribute("itemNo", $("txtItemNo").value);
		setPackQuoteDeductiblePerilLov();
	}
	
	/*Quote Mortgagee records*/
	if($("addMortgageeForm")!= null){
		($$("div#quoteMortgageeTable div[name='mortgageeRow']")).invoke("removeClassName", "selectedRow");
		($$("div#quoteMortgageeTable div[name='mortgageeRow']")).invoke("show");
		($$("div#quoteMortgageeTableContainer div:not([quoteId='" + row.getAttribute("quoteId") + "'])")).invoke("hide");
		($$("div#quoteMortgageeTableContainer div:not([itemNo='" + row.getAttribute("itemNo") + "'])")).invoke("hide");
		resizeTableBasedOnVisibleRows("quoteMortgageeTable", "quoteMortgageeTableContainer");
		$("txtMortgageeItemNo").value 	= $("txtItemNo").value;
		filterPackMortgageeLOV();
	}
	
	/*Quote Invoice Records*/
	if($("addTaxInvoiceDiv") != null){
		showPackQuoteInvoiceInfo();
	}
	
	/*Quote Attached Media Records*/
	if($("attachedMediaForm")!= null){
		showPackQuoteAttachedMediaPerItem();
	}
}