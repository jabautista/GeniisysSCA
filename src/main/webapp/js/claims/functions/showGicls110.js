function showGicls110(){
	new Ajax.Request(contextPath + "/GICLClmDocsController", {
	    parameters : {action : "showGicls110",
	    			  moduleId : "GICLS110",
	    			  lineCd : "",
	    			  sublineCd : ""
	    			  },
	    onCreate: showNotice("Loading page, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showGicls110 - onComplete : ", e);
			}								
		} 
	});
}