//kenneth 10.16.2012
function showPaymentTerm(){
	try{
		new Ajax.Request(contextPath+"/GIISPayTermController", {
			method: "GET",
			parameters: {action : "getPaymentTerm",
						 ajax : "1"},
			onCreate: showNotice("Loading Payment Term Maintenance, please wait..."),
			onComplete: function (response)	{
				hideNotice("");
				$("mainContents").update(response.responseText);
				Effect.Appear($("mainContents").down("div", 0), {
					duration: .001
				});
			}
		});			
	} catch (e){
		showErrorMessage("showPaymentTerm", e);
	}
}