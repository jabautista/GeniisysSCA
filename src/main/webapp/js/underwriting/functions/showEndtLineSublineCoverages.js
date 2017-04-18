/**
 * Created By: Robert 07.21.2011
 * Modified by: andrew 09.08.2011 - parameters condition for objTempUWGlobal
 */
function showEndtLineSublineCoverages(){
	try{
		new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWPackLineSublineController",{
			method: "POST",
			parameters: {
				packParId: objUWGlobal.packParId,
				lineCd: objUWGlobal.lineCd,
				sublineCd: (objUWGlobal.sublineCd != null ? objUWGlobal.sublineCd : objTempUWGlobal.sublineCd),
				issCd: (objUWGlobal.issCd != null ? objUWGlobal.issCd : objTempUWGlobal.issCd),
				issueYy: (objUWGlobal.issueYy != null ? objUWGlobal.issueYy : objTempUWGlobal.issueYy),
				polSeqNo: (objUWGlobal.polSeqNo != null ? objUWGlobal.polSeqNo : objTempUWGlobal.polSeqNo),
				renewNo: (objUWGlobal.renewNo != null ? objUWGlobal.renewNo : objTempUWGlobal.renewNo),
				action: "showEndtLineSublineCoverages"
			},
			evalScripts: true,
			asynchronous: true,
			onCreate: function() {
				showNotice("Getting Endt Line and Subline coverages, please wait...");
			},
			onComplete: function () {
				hideNotice("");
				Effect.Appear($("parInfoDiv").down("div", 0), {
					duration: .001,
					afterFinish: function (){
					} 
				});
			}
		});	
	}catch(e){
		showErrorMessage("showEndtLineSublineCoverages", e);
	}
}