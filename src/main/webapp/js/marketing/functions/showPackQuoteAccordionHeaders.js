/**
 * Shows or hides accordion headers for Package Quotation Information
 * 
 */

function showPackQuoteAccordionHeaders(){
	var selected = getSelectedRowId("row");
	
	if(selected == 0){
		$$("div.optionalInformation").each(function(info){
			info.hide();
		});
	}else {
		$$("div.optionalInformation").each(function(info){
			info.show();
			if(info.id == "invoiceInformationMotherDiv"){
				$("invoiceAccordionLbl").innerHTML = "Show";
				info.down("div", 0).hide();
			}
		});
	}
}