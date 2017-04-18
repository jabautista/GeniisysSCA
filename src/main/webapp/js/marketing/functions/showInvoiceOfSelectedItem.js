/**
 * Displays Invoice of currently selected/highlighted items
 * @return
 */
function showInvoiceOfSelectedItem(){
	var itemNo = getSelectedRowId("itemRow");
	try{
		var invoiceToBeDisplayed = null;
		if(itemNo != "" ){
			if(hasPerils() && $("invoiceAccordionLbl").innerHTML=="Show"){
				if($("selInvoiceTax") == null){//if(objGIPIQuoteInvoiceList==null ){
					//showNotice("Loading Invoice Information...");
					
					if(loadInvoiceInformationAccordion()){	// empty statement - DO NOT ERASE
						
					}
					
					//hideNotice("");
					if(objGIPIQuoteInvoiceList==null){
						objGIPIQuoteInvoiceList = new Array();
						invoiceToBeDisplayed = showDefaultInvoiceValues(); // <-- remove?...since there's another one below
					}
				}
				
				var invoiceForThisItem = pluckInvoiceFromList();

				if(invoiceForThisItem == null){
					invoiceToBeDisplayed = showDefaultInvoiceValues(); 
				}else{
					invoiceToBeDisplayed = invoiceForThisItem;
				}
				
				if(objGIPIQuoteInvoiceList==null){	
					// trigger a delay if page is STILL not yet loaded
					pauseJs(5000);
				}else{
					
				}
				
				displayInvoice(invoiceToBeDisplayed);
				showInvoice();
			}else if($("invoiceAccordionLbl").innerHTML=="Hide"){
				hideInvoice();
			}else{
				showMessageBox("Item has no perils", imgMessage.ERROR);
			}
		}else{
			hideInvoice();
		}
	}catch(e){
		showMessageBox("showInvoiceOfSelectedItem: " + e, imgMessage.ERROR); 
	}	
}