/**
 * A version of checkIfValidDate, using row from lov
 * @author andrew
 * @date 05.06.2011
 * @params row - selected record in quotation lov
 */
function checkIfValidDate2(row){
	try {
		var quoteId = row.quoteId;
		if ((quoteId == null)||(quoteId == "0")){
			showMessageBox("Please select a quotation.", imgMessage.ERROR);
		} else {
			var today = new Date();
			var validDate = Date.parse(row.validDate);
			if (validDate < today){
				showConfirmBox("Validity Date Verification", "Validity Date has expired.  Would you like to continue?", "OK", "Cancel", function(){setOverride2(row);}, "");
			} else {
				getIssCdForSelectedQuote2("save", row);
			}
		} 
	} catch(e){
		showErrorMessage("checkIfValidDate2", e);
	}
}