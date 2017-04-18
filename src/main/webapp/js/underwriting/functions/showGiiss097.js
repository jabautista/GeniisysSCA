/**
 * Shows Occupancy Maintenance Page
 * Module: GIISS097 - Maintain Occupancy
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss097(){
	try{ 
		new Ajax.Request(contextPath+"/GIISFireOccupancyController", {
			method: "GET",
			parameters: {
				action : "showGiiss097"
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
		showErrorMessage("showGiiss097",e);
	}	
}