/**
 * Shows Accessory Maintenance Page
 * Module: GIISS107 - Maintain Accessories
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss107(){
	try{ 
		new Ajax.Request(contextPath+"/GIISAccessoryController", {
			method: "GET",
			parameters: {
				action : "showGiiss107"
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
		showErrorMessage("showGiiss107",e);
	}	
}