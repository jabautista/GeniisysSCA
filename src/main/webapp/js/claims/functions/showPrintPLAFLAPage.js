function showPrintPLAFLAPage(currentView, lineCd){
	try{
		new Ajax.Request(contextPath + "/GICLPrintPLAFLAController", {
		    parameters : {
		    	action : "showPrintPLAFLAPage",
		    	moduleId: "GICLS050",
		    	currentView: nvl(currentView, "P"),
		    	lineCd: nvl(lineCd, "")
		    },
		    onCreate : showNotice("Loading Print PLA/FLA, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showPrintPLAFLA - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("menuPrintPLAFLA : ", e); 
	}	
}