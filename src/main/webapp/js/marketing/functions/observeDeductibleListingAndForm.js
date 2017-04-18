/**
 * 
 * @author Veronica V. Raymundo
 * @return
 */
function observeDeductibleListingAndForm(){
	if($("addDeductibleForm")!=null){
		clearDeductibleForm();
		setQuoteDeductibleDescLov();
		setQuoteDeductibleItemLov();
		setQuoteDeductiblePerilLov();
		showSelectedItemDeductibleListing();
	}
}