function showBinderList(){ //pol cruz
	try{
		new Ajax.Request(contextPath + "/GIRIInpolbasController", {
			parameters : {
				action : "showBinderList",
				moduleId : "GIUTS030",
				status : 6
			},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showBinderList",e);
	}
}