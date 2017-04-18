function showEndtBondBasicInfo(){
	updateParParameters(); 
	/*
	var lineCd = $F("globalLineCd");
	var issCd = $F("globalIssCd");
	
	var sublineCd = $F("globalSublineCd");
	var issueYY = $F("globalIssueYy");
	var polSeqNo = $F("globalPolSeqNo");
	var renewNo = $F("globalRenewNo");*/
	
	var parId 		= $F("globalParId");
	var lineCd 		= $("polParId") != null ? $F("polLineCd") : $F("globalLineCd");
	var sublineCd 	= $("polParId") != null ? $F("polSublineCd") : $F("globalSublineCd");
	var issCd 		= $("polParId") != null ? $F("polIssCd") : $F("globalIssCd");
	var issueYY 	= $("polParId") != null ? ($F("polIssueYy").blank() ? $F("globalIssueYy") : $F("polIssueYy")) : $F("globalIssueYy");
	var polSeqNo 	= $("polParId") != null ? ($F("polPolSeqNo").blank() ? $F("globalPolSeqNo") : $F("polPolSeqNo")) : $F("globalPolSeqNo");
	var renewNo 	= $("polParId") != null ? ($F("polRenewNo").blank() ? $F("globalRenewNo") : $F("polRenewNo")) : $F("globalRenewNo");
	var fromPolicyNo= $("polParId") != null ? "Y" : "N";
	var temp="";
	if(sublineCd.blank() || issCd.blank() || issueYY.blank() || polSeqNo.blank() || renewNo.blank()){ 
		overlayPolicyNumber = Overlay.show(contextPath+"/GIPIParInformationController", {
								urlContent: true,
								urlParameters: {action : "showPolicyNo",
												parId : parId,
												lineCd : lineCd,
												issCd : issCd,
												sublineCd : sublineCd},
							    title: "Policy Number",
							    height: 100,
							    width: 440,
							    draggable: true
							});
	} else {
		var msg = "Ceding company and/or assured entered does not tally with the policy for endorsement entered. Do you want to proceed? Pressing 'Yes' will update the ceding company and assured on the policy entered " + globalPolNo;
		if(validatePolNo2 == "Y"){
		validatePolNo2 = "";
		fromPolicyNo= $("polParId") != null ? "Y" : "N";
		showConfirmBox("Confirmation", msg, "Yes", "No",
				function(){
					new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWBondBasicController", {
						parameters: {
							parId: parId,
							lineCd: lineCd,
							issCd: issCd,
							sublineCd: sublineCd,
							issueYy: issueYY,
							polSeqNo: polSeqNo,
							renewNo: renewNo,
							fromPolicyNo : fromPolicyNo,
							globalAssdNo: globalAssdNo,
							globalAssdName : globalAssdName,
							confirmResult: 1,
							globalAddress1: globalAddress1,
							globalAddress2: globalAddress2,
							globalAddress3: globalAddress3,
							action: "showEndtBondBasicInfo"
						},
						evalScripts: true,
						asynchronous: true,
						onCreate: function (){
							showNotice("Getting Endt Bond Basic Information. Please wait...");
						},
						onComplete: function (){
							hideNotice("");
							if ($("parListingMainDiv").getAttribute("module") == "parCreation"){ //nok 
								//Effect.Fade("parCreationMainDiv", {duration: .001});
								$("parCreationMainDiv").update(""); //nok
							}
							Effect.Fade("parListingMainDiv", {
								duration: .001,
								afterFinish: function () {
									$("parInfoMenu").show();
									Effect.Appear("parInfoDiv", { //bondBasicInformationMainDiv
										duration: .001,
										afterFinish: function () {
											initializeMenu();
											$("samplePolicy").innerHTML = "Sample Endorsement";
											/*
											if ($("message").innerHTML == "SUCCESS" ){
												initializeMenu();
												//updateParParameters(); commented by: nica 02.07.2011
												$("sublineCd").focus();
											} else{
												showMessageBox($("message").innerHTML, imgMessage.ERROR);
												$("basicInformationForm").disable();
												$("basicInformationFormButton").disable();
											}*/
										}
									});
								}
							});
						}
					});
			},
			function(){
				notEqualRiCd = false
				validatePolNo2 = "";
				postValidate = "";
			});
		
		}else{
			fromPolicyNo= $("polParId") != null ? "Y" : "N";
			new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWBondBasicController", {
				parameters: {
					parId: parId,
					lineCd: lineCd,
					issCd: issCd,
					sublineCd: sublineCd,
					issueYy: issueYY,
					polSeqNo: polSeqNo,
					renewNo: renewNo,
					fromPolicyNo : fromPolicyNo,
					action: "showEndtBondBasicInfo"
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: function (){
					showNotice("Getting Endt Bond Basic Information. Please wait...");
				},
				onComplete: function (){
					hideNotice("");
					// bonok :: 1.12.2017 :: UCPB SR 23618 :: to display error message when msgAlert in GIPIWBondBasicController is not null in ACTION = showEndtBondBasicInfo
					//										  message is from search_for_policy.prc OUT parameter p_msg_alert
					if($("parInfoDiv").innerHTML.trim() == "Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition."){
						showMessageBox($("parInfoDiv").innerHTML.trim(), "E");
						return false;
					} 
					
					if ($("parListingMainDiv").getAttribute("module") == "parCreation"){ //nok 
						//Effect.Fade("parCreationMainDiv", {duration: .001});
						$("parCreationMainDiv").update(""); //nok
					}
					Effect.Fade("parListingMainDiv", {
						duration: .001,
						afterFinish: function () {
							$("parInfoMenu").show();
							Effect.Appear("parInfoDiv", { //bondBasicInformationMainDiv
								duration: .001,
								afterFinish: function () {
									initializeMenu();
									$("samplePolicy").innerHTML = "Sample Endorsement";
									/*
									if ($("message").innerHTML == "SUCCESS" ){
										initializeMenu();
										//updateParParameters(); commented by: nica 02.07.2011
										$("sublineCd").focus();
									} else{
										showMessageBox($("message").innerHTML, imgMessage.ERROR);
										$("basicInformationForm").disable();
										$("basicInformationFormButton").disable();
									}*/
								}
							});
						}
					});
				}
			});
		}
	}	
}