function showPreliminaryPerilDist(){
	try{
		/*var parId = objUWGlobal.parId == null ? $F("globalParId") : objUWGlobal.parId;
		var packParId = objUWGlobal.packParId == null ? $F("globalPackParId") : objUWGlobal.packParId;
		var lineCd = objUWGlobal.lineCd == null ? $F("globalLineCd") : objUWGlobal.lineCd;
		var issCd = objUWGlobal.issCd == null ? $F("globalIssCd") : objUWGlobal.issCd;
		
		updateParParameters();*/
		
		var parId; 
		var packParId; 
		var lineCd; 
		var issCd; 

		//edited by d.alcantara, 8.25.2012, wala kasing nakukuhang value sa globaloackparid pag dumaan sa pack. item info 
		//if (($F("globalPackParId") != "" || $F("globalPackParId") != null) && $F("globalPackParId") > 0){
		if ((objUWGlobal.packParId != "" || objUWGlobal.packParId != null) && objUWGlobal.packParId > 0){
			updatePackParParameters();
			parId = objUWGlobal.parId;
			packParId = objUWGlobal.packParId;
			lineCd = objUWGlobal.lineCd;
			issCd = objUWGlobal.issCd;

		}else{
			updateParParameters();
			parId = $F("globalParId");
			packParId = $F("globalPackParId");
			lineCd = $F("globalLineCd");
			issCd = $F("globalIssCd");
		}
		
		if (!checkDistMenu("GIUWS003")) return false;
		/*
		// mark jm 04.19.2011 @UCPBGEN show user that prelim peril dist is under construction
		showMessageBox("Page is under construction.", imgMessage.INFO);
		return false;*/ // temporarily removed, module is being tested (emman 05.26.2011)	
		new Ajax.Updater("parInfoDiv", contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action : "showPreliminaryPerilDist",
				globalParId : parId,
				globalLineCd : lineCd,
				globalIssCd : issCd,
				globalPackParId: packParId
				//initialParSelected : initialParId  // andrew - 10.07.201
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : showNotice("Getting Preliminary Peril Distribution, please wait ...."),
			onComplete : function(response){
				hideNotice();
				//added by d.alcantara,8.25.2012
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), { 
					duration: .001
				});
			}
		});
	}catch(e){
		showErrorMessage("showPreliminaryPerilDist", e);
	}
}