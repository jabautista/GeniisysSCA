function showCLMBatchRedistribution(currentView, lineCd){
	try{
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			parameters : {
				action : "showCLMBatchRedistribution",
				moduleId: "GICLS038",
				currentView: nvl(currentView, "R"),
				lineCd: nvl(lineCd, "")
			},
			onCreate : showNotice("Loading Batch Redistribution, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showCLMBatchRedistribution - onComplete : ", e);
				}	
			}
		});
	}catch(e){
		showErrorMessage("showCLMBatchRedistribution - Menu : ", e); 
	}	
}