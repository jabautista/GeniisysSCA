/**
* Build listing of Quote Invoice Tax from a JSON Array 
* containing quote invoice tax information
* @param objArray - JSON Array
*/

function showQuoteInvoiceTaxListing(objArray){
	try {
		var quoteTaxChargesTable = $("quoteInvTaxTableContainer");
		quoteTaxChargesTable.update("");
		
		if(objArray != null){
			objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
			for(var i=0; i<objArray.length; i++) {			
				var newDiv = createQuoteInvTaxRow(objArray[i]);
				quoteTaxChargesTable.insert({bottom : newDiv});
				setQuoteInvTaxRowObserver(newDiv);
			}
		}
		
		checkIfToResizeTable("quoteInvTaxTableContainer", "invoiceTaxRow");
		checkTableIfEmpty("invoiceTaxRow", "quoteInvTaxTable");
		
	}catch(e){
		showErrorMessage("showQuoteInvoiceTaxListing", e);
	}
}