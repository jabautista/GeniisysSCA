/**
 * Shows Update Policy Coverage Page
 * Module: GIUTS027 - Update Policy Coverage
 * @author Marie Kris Felipe 08.22.2013
 */
function showUpdatePolicyCoverage(){
	try{
		new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
			method: "GET",
			parameters: {
				action : "showUpdatePolicyCoverage"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function(){
				showNotice("Loading Update Policy Coverage page, please wait...");
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
		showErrorMessage("showUpdatePolicyCoverage", e);
	}
}