function showGeneratePLAFLAPage(currentView, lineCd){
	try{
		new Ajax.Request(contextPath + "/GICLGeneratePLAFLAController", {
		    parameters : {
		    	action : "showGeneratePLAFLAPage",
		    	moduleId: "GICLS051",
		    	currentView: nvl(currentView, "P"),
		    	lineCd: nvl(lineCd, "")
		    },
		    onCreate : showNotice("Loading Generate PLA/FLA, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showGeneratePLAFLA - onComplete : ", e);
				}								
			} 
		});
	}catch(e){
		showErrorMessage("menuGeneratePLAFLA : ", e); 
	}	
}