//Edison 10.15.2012
function showUpdateAddWarrantiesAndClauses(){
	try{
		new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
			method: "GET",
			parameters: {
				action : "showUpdateAddWarrantiesAndClauses"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate : showNotice("Processing request, please wait..."),
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});			
	} catch (e){
		showErrorMessage("showUpdateAddWarrantiesAndClauses", e);
	}
}