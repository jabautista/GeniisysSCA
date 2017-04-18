/**
 * Shows Cargo Type Maintenance Page
 * Module: GIISS080 - Cargo Type Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showCargoClass(){
	try{ 
		new Ajax.Request(contextPath+"/GIISCargoTypeController", {
			method: "GET",
			parameters: {
				action : "showCargoClass"
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
		showErrorMessage("showCargoClass",e);
	}
}