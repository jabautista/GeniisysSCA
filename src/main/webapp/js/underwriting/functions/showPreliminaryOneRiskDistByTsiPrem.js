/**
 * Shows Preliminary One-Risk Distribution by TSI/Prem
 * Module: GIUWS004 - Preliminary One-Risk Distribution by TSI/Prem
 * @author Anthony Santos
 */
function showPreliminaryOneRiskDistByTsiPrem(){
	try{
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
		new Ajax.Updater("parInfoDiv", contextPath+"/GIUWPolDistController?action=showPreliminaryOneRiskDistTsiPrem",{
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
			onCreate: showNotice("Getting Preliminary One-Risk Distribution by Tsi/Prem, please wait..."),
			onComplete: function () {
				hideNotice();
				updateParParameters($F("initialParId"));
				$("globalPackParId").value = packParId;
				if (checkErrorOnResponse(response)){
					setModuleId("GIUWS004");
					//added by d.alcantara,8.25.2012
					hideNotice("");
					Effect.Appear($("parInfoDiv").down("div", 0), { 
						duration: .001
					});
				}	
			}
		});
	}catch(e){
		showErrorMessage("showPreliminaryOneRiskDistByTsiPrem", e);
	}
}