/**
 * Shows District/Block Maintenance Page
 * Module: GIISS007 - Maintain Block
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss007(){
	try{ 
		new Ajax.Request(contextPath+"/GIISBlockController", {
			method: "GET",
			parameters: {
				action : "showGiiss007"
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
		showErrorMessage("showGiiss007",e);
	}	
}