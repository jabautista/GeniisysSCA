/**
 * @author rey
 * @date 07-14-2011
 * @returns
 * select the quoteId
 */
function getSelectedQuotationRowQuoteId2(){
	try{
		if(quotationTableGridListing==null){
			return 0;
		}else{
			if(selectedQuoteListingIndex2 < 0){
				return 0;
			}else{
				return quotationTableGridListing.geniisysRows[selectedQuoteListingIndex2].quoteId;
			}
		}
	}catch(e){
		showErrorMessage("getSelectedQuotationRowQuoteId2", e);
	}	
}