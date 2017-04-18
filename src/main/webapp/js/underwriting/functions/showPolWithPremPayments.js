//John Dolon 9.19.2013
function showPolWithPremPayments(){
	try {
		new Ajax.Request(contextPath + "/GIRIBinderController", {
			parameters : {
				action : "showPolWithPremPayments"
			},
			onCreate : function(){
				showNotice("Loading, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showPolWithPremPayments: ", e);
	}
}