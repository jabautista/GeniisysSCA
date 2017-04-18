/**
 * Shows Typhoon Zone Maintenance
 * Module: GIISS052 - Typhoon Zone Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showTyphoonZoneMaintenance(){
	try{ 
		new Ajax.Request(contextPath+"/GIISTyphoonZoneController", {
			method: "GET",
			parameters: {
				action : "showTyphoonZoneMaintenance"
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
		showErrorMessage("showTyphoonZoneMaintenance",e);
	}
}