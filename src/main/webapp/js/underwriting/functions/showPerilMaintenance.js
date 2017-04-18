/**
 * Shows Peril Maintenance
 * Module: GIIS003 - Peril Maintenance
 * @author Cherrie
 */
function showPerilMaintenance(){
	try{ 
		new Ajax.Request(contextPath+"/GIISSPerilMaintenanceController", {
			method: "GET",
			parameters: {
				action : "getPerilMaintenanceDisplay",
				ajax : 1	
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
		showErrorMessage("showPerilMaintenance",e);
	}
}