/**
 * Shows Reinsurer Maintenance Page
 * Module: GIISS030 - Reinsurer Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showReinsurer(){
	try{ 
		new Ajax.Request(contextPath+"/GIISReinsurerController", {
			method: "GET",
			parameters: {
				action : "showGiiss030"
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
		showErrorMessage("showReinsurer",e);
	}	
}