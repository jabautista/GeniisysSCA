/** 
 * Prepares content of quote invoice tax row 
 * @param invTaxObj - JSON Object that contains the quote invoice tax information
 */

function prepareQuoteInvTaxTable(invTaxObj){
	var taxDesc = invTaxObj.taxDescription == null || invTaxObj.taxDescription == "" ? "---" : unescapeHTML2(invTaxObj.taxDescription);  
	var taxAmt = invTaxObj.taxAmt == null || invTaxObj.taxAmt == "" ? "---" : formatCurrency(invTaxObj.taxAmt);
	
	var invTaxInfo = '<label style="width: 40%; margin-left: 10%; text-align: left;">' + taxDesc + '</label>'
					+'<label style="width: 30%; text-align: right;" class="money">' + taxAmt + '</label>';
	return invTaxInfo; 
}