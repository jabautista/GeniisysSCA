//Gzelle 11.27.2013 Inland Vehicle Maintenance
function showGIISS050(){
	new Ajax.Request(contextPath + "/GIISVesselController", {
	    parameters : {action : "showGiiss050"},
	    onCreate: showNotice("Retrieving Inland Vehicle Maintenance, Please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					if (objMKGlobal.callingForm == "GIIMM009") { //added by steven 12.09.2013
						$("quoteInfoDiv").update(response.responseText);
					}else if (objUWGlobal.callingForm == "GIPIS007" || objUWGlobal.callingForm == "GIPIS076"){						
						$("maintainDiv").update(response.responseText);
						$("maintainDiv").show();
						$("parInfoMenu").hide();
						$("carrierInfoMainDiv").hide();
					} else {
						$("dynamicDiv").update(response.responseText);
					}
				}
			} catch(e){
				showErrorMessage("showGIISS050 - onComplete : ", e);
			}								
		} 
	});
}