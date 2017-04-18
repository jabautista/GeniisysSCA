/**
 * Shows Intermediary Type Maintenance Page
 * Module: GIISS083 - Intermediary Type Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showIntermediaryTypeMaintenance(){
	try{ 
		new Ajax.Request(contextPath+"/GIISIntmTypeController", {
			method: "GET",
			parameters: {
				action : "showIntmType"
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
		showErrorMessage("showIntermediaryTypeMaintenance",e);
	}	
}