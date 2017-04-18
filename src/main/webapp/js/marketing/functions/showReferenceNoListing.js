function showReferenceNoListing(){
	try{
		Modalbox.show(contextPath+"/GIPIPackQuoteController?action=showPackBankRefNo&ajaxModal=1",  
				  {title: "Search Bank Reference Number.", 
				  width: 900,
				  asynchronous: false});
	}catch(e){
		showErrorMessage("showReferenceNoListing",e);
	}  
}