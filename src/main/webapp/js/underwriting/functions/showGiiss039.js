//Vessel Maintenance : shan 12.02.2013
function showGiiss039(){ 
	try{
		new Ajax.Request(contextPath + "/GIISVesselController", {
			parameters : {
				action : "showGiiss039",
			},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
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
						$("mainContents").update(response.responseText);
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss039",e);
	}
}