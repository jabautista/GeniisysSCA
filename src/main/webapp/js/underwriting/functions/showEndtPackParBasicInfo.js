//emman 11.09.2010
function showEndtPackParBasicInfo(){
/*	var parId = objUWGlobal.packParId == null ? "" : objUWGlobal.packParId;
	var lineCd =objUWGlobal.lineCd == null ? "" : objUWGlobal.lineCd;
	var issCd = objUWGlobal.issCd == null ? "" : objUWGlobal.issCd;
	var parType = objUWGlobal.parType == null ? "E" : objUWGlobal.parType; // modified by: nica 02.04.2011	
	var sublineCd = objUWGlobal.sublineCd == null ? "" : objUWGlobal.sublineCd;
	var issueYY = objUWGlobal.issueYy == null ? "" : objUWGlobal.issueYy.toString();
	var polSeqNo = objUWGlobal.polSeqNo == null ? "" : objUWGlobal.polSeqNo.toString();
	var renewNo = objUWGlobal.renewNo == null? "" : objUWGlobal.renewNo.toString();
*/
	// andrew - 09.08.2011
	var parId = objUWGlobal.packParId;
	var lineCd = objUWGlobal.lineCd;
	var issCd = (objUWGlobal.issCd != null ? objUWGlobal.issCd : (objTempUWGlobal == null ? "" : objTempUWGlobal.issCd));
	var parType = (objUWGlobal.parType != null ? objUWGlobal.parType : (objTempUWGlobal == null ? "E" : objTempUWGlobal.parType));	
	var sublineCd = (objUWGlobal.sublineCd != null ? objUWGlobal.sublineCd : (objTempUWGlobal == null ? "" : objTempUWGlobal.sublineCd));
	var issueYY = (objUWGlobal.issueYy != null ? objUWGlobal.issueYy.toString() : (objTempUWGlobal == null ? "" : objTempUWGlobal.issueYy));
	var polSeqNo = (objUWGlobal.polSeqNo != null ? objUWGlobal.polSeqNo.toString() : (objTempUWGlobal == null ? "" : objTempUWGlobal.polSeqNo));
	var renewNo = (objUWGlobal.renewNo != null? objUWGlobal.renewNo.toString() : (objTempUWGlobal == null ? "" : objTempUWGlobal.renewNo));
	var temp="";
	
	if (!lineCd.blank() && !sublineCd.blank() && !issCd.blank() && !issueYY.blank() && !polSeqNo.blank() && !renewNo.blank()) {
		getPackBasicInfo();
	} else {
		// andrew - 07.07.2011 - changed to Overlay
		overlayPolicyNumber = Overlay.show(contextPath+"/GIPIPackParInformationController", {
									urlContent: true,
									urlParameters: {action 		: "showPackPolicyNo",
													parId 		: parId, 
													lineCd 		: lineCd,
													issCd		: issCd,
													sublineCd	: sublineCd,
													polSeqNo	: temp,
													issueYy		: temp,
													renewNo		: temp},
								    title: "Policy Number",
								    height: 100,
								    width: 440,
								    draggable: true
								});
		
		/*showOverlayContent2(contextPath+"/GIPIPackParInformationController?action=showPackPolicyNo&parId="+parId+"&lineCd="
				+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+temp+"&issueYy="+temp+"&renewNo="+temp,
				"Policy Number", 490, "");*/
	}

	/*
	if(sublineCd == null || issueYY.blank() && polSeqNo.blank() && renewNo.blank()){
		showOverlayContent2(contextPath+"/GIPIPackParInformationController?action=showPackPolicyNo&parId="+parId+"&lineCd="
				+lineCd+"&issCd="+issCd+"&sublineCd="+sublineCd+"&polSeqNo="+temp+"&issueYy="+temp+"&renewNo="+temp,
				"Policy Number", 490, "");
	} else {
		/*new Ajax.Updater("parInfoDiv", contextPath+"/GIPIPackParInformationController",{
			parameters: {
				packParId: objUWGlobal.packParId,
				lineCd: objUWGlobal.lineCd,
				issCd: objUWGlobal.issCd,
				action: "showEndtPackParBasicInfo"
			},
			asynchronous: true,
			evalScripts: true,
			onCreate: function(){
				showNotice("Getting Endt Package PAR Basic Information, please wait...");
			},
			onComplete:function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					Effect.Fade("packParListingMainDiv",{
						duration: 0.001,
						afterFinish: function(){
							$("parInfoMenu").show();
							Effect.Appear("parInfoDiv",{
								duration: 0.001,
								afterFinish: function(){
									if ($("message").innerHTML == "SUCCESS"){
										//updateParParameters();
									} else {
										showMessageBox($("message").innerHTML, imgMessage.ERROR);
										//$("basicInformationForm").disable();
										//$("basicInformationFormButton").disable();
									}
								}
							});
					   }
					});
				}
			}
		});	
		getPackBasicInfo();
	}*/
}