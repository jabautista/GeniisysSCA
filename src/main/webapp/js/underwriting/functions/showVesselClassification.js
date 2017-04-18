/**
 * Shows Vessel Classification Maintenance Page
 * Module: GIISS047 - Vessel Classification Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showVesselClassification(){
	try{ 
		new Ajax.Request(contextPath+"/GIISVessClassController", {
			method: "GET",
			parameters: {
				action : "showVesselClassification"
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
		showErrorMessage("showVesselClassification",e);
	}	
}