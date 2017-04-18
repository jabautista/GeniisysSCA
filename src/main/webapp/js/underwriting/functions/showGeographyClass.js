/**
 * Shows Geography Class Maintenance Page
 * Module: GIISS080 - Geography Class Maintenance
 * @author Ildefonso Ellarina Jr
 * */
function showGeographyClass(){
	try{ 
		new Ajax.Request(contextPath+"/GIISGeogClassController", {
			method: "GET",
			parameters: {
				action : "showGeographyClass"
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
		showErrorMessage("showGeographyClass",e);
	}	
}