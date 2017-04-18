//Joms 10.16.12
function showUpdateInitialAcceptance(){
	try{
		new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
			method: "GET",
			parameters: {
				action : "showUpdateInitialAcceptance"
			},
			evalScripts:true,
			asynchronous: true,
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});			
	} catch (e){
		showErrorMessage("showUpdateInitialAcceptance", e);
	}
}