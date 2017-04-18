// bonok :: 10.08.2013 :: GIPIS179
function showViewRenewal() {
	try {
		new Ajax.Request(contextPath + "/GIEXExpiriesVController", {
			method: "GET",
			parameters : {
				action : "showViewRenewal"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate : showNotice("Loading View Renewal page, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showViewRenewal", e);
	}
}