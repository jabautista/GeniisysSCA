// by bonok :: 02.21.2013
function showSpoilPostedPolicy(){
	try{
		new Ajax.Request(contextPath+"/SpoilageReinstatementController", {
			method: "GET",
			parameters: {
				action : "showSpoilPostedPolicy"
			},
			evalScripts:true,
			asynchronous: true,
			onComplete: function (response)	{
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});			
	} catch (e){
		showErrorMessage("showSpoilPostedPolicy", e);
	}
}