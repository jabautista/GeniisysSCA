function showQuotationInformation014() {
	try{
		new Ajax.Request(contextPath + "/GIPIQuoteController", {
		    parameters : {action : "viewQuotationInformation"
		    			 },
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("viewQuotationInformation - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("viewQuotationInformation : ", e); 
	}				
};