/**
 * Shows Cargo Class Maintenance Page
 * Module: GIISS051 - Maintain Cargo Class
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss051(){
	try{ 
		new Ajax.Request(contextPath+"/GIISCargoClassController", {
			method: "GET",
			parameters: {
				action : "showGiiss051"
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
		showErrorMessage("showGiiss051",e);
	}	
}