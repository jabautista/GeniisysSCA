/**
 * Get the quoteId of selected tableGrid row
 * @return quoteId
 */
function getSelectedQuotationRowQuoteId(){
	try{
		if(quotationTableGrid==null){
			return 0;
		}else{
			if(selectedQuoteListingIndex < 0){
				return 0;
			}else{
				return quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId;
			}
		}
	}catch(e){
		showErrorMessage("getSelectedQuotationRowQuoteId", e);
	}
}