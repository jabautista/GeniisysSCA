function showGiiss065(){
	try{ 
		new Ajax.Request(contextPath+"/GIISDefaultOneRiskController", {
			method: "GET",
			parameters: {
				action : "showGiiss065"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss065",e);
	}	
}