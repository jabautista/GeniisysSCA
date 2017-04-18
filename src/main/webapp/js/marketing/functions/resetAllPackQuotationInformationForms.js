/**
 * Reset all forms shown in the Package Quotation Information.
 *
 */

function resetAllPackQuotationInformationForms(){
	setQuoteItemInfoForm(null);
	setQuoteItemPerilInfoForm(null);
	if($("addDeductibleForm")!= null){setQuoteDeductibleInfoForm(null);}
	if($("addMortgageeForm")!= null){setQuoteMortgageeInfoForm(null);}
	if($("attachedMediaForm")!=null){resetPackQuoteAttachedMediaUploadForm();};
	if($("addTaxInvoiceDiv")!= null){
		setQuoteInvoiceInfoForm(null);
		setQuoteInvTaxForm(null);
	}
	
}