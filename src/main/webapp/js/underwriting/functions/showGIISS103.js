function showGIISS103(){
	try{
		new Ajax.Request(contextPath + "/GIISMcMakeController", {
			parameters : {
				action : "showGIISS103"
			},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(objUWGlobal.callingForm, "") == "GIPIS010"){
						$("parInfoMenu").hide();
						$("parInfoDiv").update(response.responseText);
					}else{
						$("mainContents").update(response.responseText);
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIISS103",e);
	}
}