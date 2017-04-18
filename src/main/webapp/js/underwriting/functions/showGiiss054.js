/**
 * Shows Tariff Zone Maintenance Page
 * Module: GIISS011 - Maintain Tariff Zone
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss054(){
	try{ 
		new Ajax.Request(contextPath+"/GIISTariffZoneController", {
			method: "GET",
			parameters: {
				action : "showGiiss054"
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
		showErrorMessage("showGiiss054",e);
	}	
}