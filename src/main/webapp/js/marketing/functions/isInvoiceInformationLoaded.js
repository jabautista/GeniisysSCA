/**
 * Checks if the invoice information has been loaded from other
 * item
 * @author rencela
 * @return
 */
function isInvoiceInformationLoaded(){
	var isLoaded = false;
	
	if($("invoiceInformationDiv")==undefined){
		isLoaded = false;
	}else{
		isLoaded = true;
	}
	return isLoaded;
}