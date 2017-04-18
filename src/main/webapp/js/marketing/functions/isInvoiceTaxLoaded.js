/**
 * Check if invoiceTax is loaded -- check only the visible
 * 
 * @return
 */
function isInvoiceTaxLoaded(invoiceTaxObj){	
	var ito = $("invoiceTaxRow" + invoiceTaxObj.taxCd);
	if(ito==null){
		return false;
	}else if(ito==undefined){
		return false;
	}else{
		return true;
	}
}