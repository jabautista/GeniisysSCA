/**
 * Shows System Parameter Maintenance Page
 * Module: GIISS085 - Maintain User Parameter Screen
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss085(){
	try{ 
		new Ajax.Request(contextPath+"/GIISParameterController", {
			method: "GET",
			parameters: {
				action : "showGiiss085"
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
		showErrorMessage("showGiiss085",e);
	}	
}