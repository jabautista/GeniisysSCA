/**
 * Shows Earthquake Zone Maintenance Page
 * Module: GIISS011 - Maintain Earthquake Zone
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss011(){
	try{ 
		new Ajax.Request(contextPath+"/GIISEQZoneController", {
			method: "GET",
			parameters: {
				action : "showGiiss011"
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
		showErrorMessage("showGiiss011",e);
	}	
}