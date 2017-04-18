//Joms 10.18.12
function showGIISS009(){
	try{
		new Ajax.Request(contextPath+"/GIISCurrencyController", {
			method: "GET",
			parameters: {
				action : "showCurrencyList"
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
		showErrorMessage("showCurrency", e);
	}
}