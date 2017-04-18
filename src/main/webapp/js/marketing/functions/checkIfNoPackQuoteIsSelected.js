/**
 * Prompts a message whenever there is no Package quote selected.
 * 
 */

function checkIfNoPackQuoteIsSelected(){
	if(objCurrPackQuote == null){
		showMessageBox("There is no quotation selected.");
		return false;
	}
}