/**
 * Shows Preliminary One-Risk Distribution
 * Module: GIUWS004 - Preliminary One-Risk Distribution
 * @author Jerome Orio
 */
function showPreliminaryOneRiskDist(){
	try{
		/* Commented by Tonio July 11, 2011 For Package Handling
		if (!checkDistMenu("GIUWS004")) return false;
		new Ajax.Updater("parInfoDiv", contextPath+"/GIUWPolDistController?action=showPreliminaryOneRiskDist",{
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			parameters:{
				globalParId  : $F("globalParId"),
				globalLineCd : $F("globalLineCd"),
				globalIssCd  : $F("globalIssCd")
			},
			onCreate: showNotice("Getting Preliminary One-Risk Distribution, please wait..."),
			onComplete: function () {
				hideNotice();
				if (checkErrorOnResponse(response)){
					setModuleId("GIUWS004");
					
				}	
			}
		});
		*/
		var parId; 
		var packParId; 
		var lineCd; 
		var issCd; 
		//edited by d.alcantara, 8.25.2012, wala kasing nakukuhang value sa globaloackparid pag dumaan sa pack. item info 
		//if (($F("globalPackParId") != "" || $F("globalPackParId") != null) && $F("globalPackParId") > 0){
		if ((objUWGlobal.packParId != "" || objUWGlobal.packParId != null) && objUWGlobal.packParId > 0){
			updatePackParParameters();
			//parId = objUWGlobal.parId;
			packParId = objUWGlobal.packParId;
			//lineCd = objUWGlobal.lineCd;
			//issCd = objUWGlobal.issCd;

		}else{
			updateParParameters();
			parId = $F("globalParId");
			packParId = $F("globalPackParId");
			lineCd = $F("globalLineCd");
			issCd = $F("globalIssCd");
		}
		
		if (!checkDistMenu("GIUWS004")) return false;
		var initialParId = $("initialParId") != undefined ? $F("initialParId"): "";
		new Ajax.Updater("parInfoDiv", contextPath+"/GIUWPolDistController?action=showPreliminaryOneRiskDist",{
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			parameters:{
				globalParId  : parId,
				globalLineCd : lineCd,
				globalIssCd  : issCd,
				globalPackParId: packParId,
				initialParSelected : initialParId
			},
			onCreate: showNotice("Getting Preliminary One-Risk Distribution, please wait..."),
			onComplete: function () {
				hideNotice();
				$("globalPackParId").value = packParId;
				if (checkErrorOnResponse(response)){
					setModuleId("GIUWS004");
				}	
				//added by d.alcantara,8.25.2012
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), { 
					duration: .001
				});
			}
		});
	}catch(e){
		showErrorMessage("showPreliminaryOneRiskDist", e);
	}
}