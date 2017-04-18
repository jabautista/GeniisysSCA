/**
 * Shows Reinsurer Type Maintenance Page
 * Module: GIISS025 - Maintain Reinsurer Type
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss025(){
	try{ 
		new Ajax.Request(contextPath+"/GIISReinsurerTypeController", {
			method: "GET",
			parameters: {
				action : "showGiiss025"
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
		showErrorMessage("showGiiss025",e);
	}	
}