/**
 * Shows Car Color Maintenance Page
 * Module: GIISS114 - Maintain Motor Car Color
 * @author Ildefonso Ellarina Jr
 * */
function showGiiss114(){
	try{ 
		new Ajax.Request(contextPath+"/GIISMCColorController", {
			method: "GET",
			parameters: {
				action : "showGiiss114BasicColor"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(objUWGlobal.callingForm == "GIPIS010"){					
					$("parInfoMenu").hide();					
					$("parInfoDiv").update(response.responseText);
					Effect.Appear($("parInfoDiv").down("div", 0), {
						duration: .001
					});
				}else{
					$("mainContents").update(response.responseText);
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});
				}
				
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss114",e);
	}	
}