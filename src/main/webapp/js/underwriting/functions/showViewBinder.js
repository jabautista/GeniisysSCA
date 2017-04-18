function showViewBinder(){
	try{
		new Ajax.Request(contextPath+"/GIRIBinderController",{
			parameters: {
				action: "showViewBinder"
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					if(nvl(objGipis130.callSw, "") == "Y"){ //benjo 07.20.2015 UCPBGEN-SR-19626 added if condition
						$("gipis130TempDiv").update(response.responseText);
					} else {
						$("mainContents").update(response.responseText);
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("showViewBinder", e);
	}
}