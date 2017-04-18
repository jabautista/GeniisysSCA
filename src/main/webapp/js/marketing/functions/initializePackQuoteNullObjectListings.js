/**
 * Sets null lists under Package Quotation to  
 * new Array() to prevent errors in saving
 * 
 */

function initializePackQuoteNullObjectListings(){
	if(objPackQuoteItemList==null){
	   objPackQuoteItemList = new Array();
	}
	
	if(objPackQuoteItemPerilList==null){
	   objPackQuoteItemPerilList = new Array();
	}
	
	if(objPackQuoteDeductiblesList==null){
	   objPackQuoteDeductiblesList = new Array();
	}
	
	if(objPackQuoteMortgageeList==null){
	   objPackQuoteMortgageeList = new Array();
	}
	
	if(objPackQuoteInvoiceList==null){
		objPackQuoteInvoiceList = new Array();
	}
}