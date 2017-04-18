//john dolon 10.29.2013
function showGIISS049(){
	try{ 
		new Ajax.Request(contextPath+"/GIISVesselController", {
			method: "GET",
			parameters: {
				action : "showGIISS049"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate: function (){
				showNotice("Retrieving Aircraft Maintenance, please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if (objMKGlobal.callingForm == "GIIMM009") { //added by steven 12.09.2013
					$("quoteInfoDiv").update(response.responseText);
				}else if (objUWGlobal.callingForm == "GIPIS007" || objUWGlobal.callingForm == "GIPIS076"){						
					$("maintainDiv").update(response.responseText);
					$("maintainDiv").show();
					$("parInfoMenu").hide();
					$("carrierInfoMainDiv").hide();
				}  else {
					$("mainContents").update(response.responseText);
				}
			}
		});		
	}catch(e){
		showErrorMessage("showGIISS049",e);
	}	
}
