/**
 * Shows Preliminary Peril Distribution by TSI/Prem
 * Module: GIUWS006 - Preliminary Peril Distribution by TSI/Prem
 * @author Jerome Orio
 */
function showPreliminaryPerilDistByTsiPrem(){
	try{
		/* Commented by Tonio for Package Handling July 13, 2011
		updateParParameters();
		if (!checkDistMenu("GIUWS006")) return false;
		new Ajax.Updater("parInfoDiv", contextPath + "/GIUWPolDistController", {
			method : "POST",
			parameters : {
				action : "showPreliminaryPerilDistByTsiPrem",
				globalParId : $F("globalParId"),
				globalLineCd : $F("globalLineCd"),
				globalIssCd : $F("globalIssCd")
			},
			evalScripts : true,
			asynchronous : false,
			onCreate : showNotice("Getting Preliminary Peril Distribution by TSI/Prem, please wait ...."),
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					setModuleId("GIUWS006");
				}
			}
		});*/
		
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

		if (!checkDistMenu("GIUWS006")) return false;
		var initialParId = $("initialParId") != undefined ? $F("initialParId"): "";
		new Ajax.Updater("parInfoDiv", contextPath+"/GIUWPolDistController?action=showPreliminaryPerilDistByTsiPrem",{
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
			onCreate: showNotice("Getting Preliminary Peril Distribution by TSI/Prem, please wait ...."),
			onComplete: function () {
				hideNotice();
				//updateParParameters($F("initialParId"));
				$("globalPackParId").value = packParId;
				if (checkErrorOnResponse(response)){
					setModuleId("GIUWS006");
					//added by d.alcantara,8.25.2012
					hideNotice("");
					Effect.Appear($("parInfoDiv").down("div", 0), { 
						duration: .001
					});
				}	
			}
		});
	}catch(e){
		showErrorMessage("showPreliminaryPerilDistByTsiPrem", e);
	}
}