//Take-Up Term Maintenance : shan 10.24.2013
function showGiiss211(){ 
	try{
		new Ajax.Request(contextPath + "/GIISTakeupTermController", {
			parameters : {
				action : "showGiiss211",
			},
			onCreate : showNotice("Loading Take-Up Term Maintenance, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss211",e);
	}
}