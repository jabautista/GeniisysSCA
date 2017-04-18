function printPackageQuotation(){
	try{
		
		if(objMKGlobal.packQuoteId == null){
			showMessageBox("There is no quotation selected.", imgMessage.ERROR);
			return;
		}
		
		Modalbox.show(contextPath + "/PrintController?action=showPrintOptions&ajaxModal=1&isPack=Y&quoteId="+objMKGlobal.packQuoteId, {
			title : "Print Quotation",
			width : 400
		});
		
	}catch(e){
		showErrorMessage("printPackageQuotation",e);
	}
}