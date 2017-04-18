function showGIPIS190() {
	try {
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
			method: "GET",
			parameters : {
				action : "showDiscountSurcharge"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate : showNotice("Loading page, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showDiscountSurcharge", e);
	}
}