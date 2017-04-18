/**
 * Shows Set-Up Group For Preliminary Distribution
 * Module: GIUWS001 - Set-Up Group For Preliminary Distribution
 * @author Jerome Orio
 * @since 04/12/2011
 */
function showSetUpGroupsForPrelimDist(){
	try{
		/*var parId = objUWGlobal.parId == null ? $F("globalParId") : objUWGlobal.parId;
		var packParId = objUWGlobal.packParId == null ? $F("globalPackParId") : objUWGlobal.packParId;
		var lineCd = objUWGlobal.lineCd == null ? $F("globalLineCd") : objUWGlobal.lineCd;
		var issCd = objUWGlobal.issCd == null ? $F("globalIssCd") : objUWGlobal.issCd;
		
		updateParParameters();*/
		
		if (($F("globalPackParId") != "" || $F("globalPackParId") != null) && $F("globalPackParId") > 0){
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
		
		if (!checkDistMenu("GIUWS001")) return false;
		new Ajax.Updater("parInfoDiv", contextPath+"/GIUWPolDistController?action=showSetUpGroupsForPrelimDist",{
			method: "POST",
			evalScripts: true,
			asynchronous: false,
			parameters:{
				globalParId  : parId,
				globalPackParId: packParId,
				globalLineCd : lineCd,
				globalIssCd  : issCd
			},
			onCreate: showNotice("Getting Set-Up Groups For Preliminary Distribution, please wait..."),
			onComplete: function () {
				if (checkErrorOnResponse(response)){
					setModuleId("GIUWS001");
				}	
			}
		});
	}catch(e){
		showErrorMessage("showSetUpGroupsForPrelimDist", e);
	}
}