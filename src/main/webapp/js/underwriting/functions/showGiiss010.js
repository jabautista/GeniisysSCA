//Deductible Maintenance : shan 10.24.2013
function showGiiss010(){ 
	try{
		new Ajax.Request(contextPath + "/GIISDeductibleDescController", {
			parameters : {
				action : "showGiiss010",
			},
			onCreate : showNotice("Loading Deductible Maintenance, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss010",e);
	}
}