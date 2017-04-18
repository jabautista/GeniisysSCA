//Casualty Location Maintenance : fons 11.06.2013
function showGiiss217(){
	try{ 
		new Ajax.Request(contextPath+"/GIISCaLocationController", {
			method: "GET",
			parameters: {
				action : "showGiiss217"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Loading, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(nvl(objUWGlobal.callingForm, "") == "GIPIS011"){	//added by Gzelle 12172014
					$("parInfoMenu").hide();
					$("parInfoDiv").update(response.responseText);
				}else {
					$("mainContents").update(response.responseText);
					Effect.Appear($("mainContents").down("div", 0), {
						duration: .001
					});
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGiiss217",e);
	}	
}