/**
 * Shows/Hides Other Information 
 * (Additional Information, MortgageeInformation, DeductibleInformation, InvoiceInformation)
 * @author rencela
 */
function showAccordionHeaders(){
	var selected = getSelectedRowId("itemRow");
	if(selected == 0){
		$$("div.optionalInformation").each(function(info){
			info.hide();
		});
	}else {
		$$("div.optionalInformation").each(function(info){
			if(info.id != "invoiceInformationMotherDiv"){
				info.show();
			}
		});
	}
}