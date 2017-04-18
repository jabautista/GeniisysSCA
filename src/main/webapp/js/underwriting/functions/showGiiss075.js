/**
 * Shows Co-Intermediary Type Maintenance Page
 * Module: GIISS075 - Maintain Co-Intermediary Types
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss075(){
	try{ 
		new Ajax.Request(contextPath+"/GIISCoIntrmdryTypesController", {
			method: "GET",
			parameters: {
				action : "showGiiss075"
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
		showErrorMessage("showGiiss075",e);
	}	
}
