/**
 * Check existence of quote_ves_air records for quotation lines 
 * Marine Hull and Marine Cargo under the Package Quotation.
 * @param quoteId - the quote id
 * @param row - row of the quotation under the Package Quotation
 * @return
 */

function checkIfQuoteVesAirRecExist(quoteId, row){
	new Ajax.Request(contextPath + "/GIPIQuoteVesAirController", {
		method: "GET",
		parameters: {
			action: "checkIfQuoteVesAirRecExist",
			quoteId: quoteId
		},
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				row.setAttribute("isQuoteVesAirExist", response.responseText);
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	 });
}