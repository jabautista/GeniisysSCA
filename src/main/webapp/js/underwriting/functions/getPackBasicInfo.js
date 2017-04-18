/**
 * Show Pack Basic Info page
 * Modified by : andrew  09.08.2011 - added conditions for parameters to consider objTempUWGlobal
 * @return
 */
function getPackBasicInfo(){
	try {
		var action = "";
		var fromPolicyNo = "";
		
		if(objUWGlobal.parType == "P"){
			var parId 		= objUWGlobal.packParId;
			var lineCd 		= objUWGlobal.lineCd;
			var sublineCd 	= objUWGlobal.sublineCd;
			var issCd 		= objUWGlobal.issCd;
			var issueYy 	= objUWGlobal.issueYy;
			var renewNo 	= objUWGlobal.renewNo;
			action 			= "showPackParBasicInfo";
			fromPolicyNo 	= "N";
		} else{
			var parId 		= objUWGlobal.packParId;
			var lineCd 		= $("polParId") != null ? $F("polLineCd") : objUWGlobal.lineCd;
			var sublineCd 	= $("polParId") != null ? $F("polSublineCd") : (objUWGlobal.sublineCd != null ? objUWGlobal.sublineCd : objTempUWGlobal.sublineCd);
			var issCd 		= $("polParId") != null ? $F("polIssCd") : (objUWGlobal.issCd != null ? objUWGlobal.issCd : objTempUWGlobal.issCd);
			var issueYy 	= $("polParId") != null ? ($F("polIssueYy").blank() ? (objUWGlobal.issueYy != null ? objUWGlobal.issueYy : objTempUWGlobal.issueYy) : $F("polIssueYy")) : (objUWGlobal.issueYy != null ? objUWGlobal.issueYy : objTempUWGlobal.issueYy);
			var polSeqNo 	= (objUWGlobal.parType != "E" ? "" : $("polParId") != null ? ($F("polPolSeqNo").blank() ? (objUWGlobal.polSeqNo != null ? objUWGlobal.polSeqNo : objTempUWGlobal.polSeqNo) : $F("polPolSeqNo")) : (objUWGlobal.polSeqNo != null ? objUWGlobal.polSeqNo : objTempUWGlobal.polSeqNo));
			var renewNo 	= $("polParId") != null ? ($F("polRenewNo").blank() ? (objUWGlobal.renewNo != null ? objUWGlobal.renewNo : objTempUWGlobal.renewNo) : $F("polRenewNo")) : (objUWGlobal.renewNo != null ? objUWGlobal.renewNo : objTempUWGlobal.renewNo);
			action 			= objUWGlobal.parType == "P" ? "showPackParBasicInfo" : "showEndtPackParBasicInfo";
			fromPolicyNo 	= (objUWGlobal.parStatus <= 2 && ($("polParId") != null || objTempUWGlobal != null) ? "Y" : "N");
		}
		
		//replaced by robert 04.18.2013 sr 12794
		/*var url = contextPath+"/GIPIPackParInformationController?action="+action+"&issCd="+issCd+"&lineCd="+lineCd+"&parId="+parId+
					"&sublineCd="+escapeHTML2(sublineCd)+"&issueYy="+issueYy+"&polSeqNo="+polSeqNo+"&renewNo="+renewNo+
					"&fromPolicyNo="+fromPolicyNo;*/
		
		/*new Ajax.Updater("parInfoDiv", url, {
			asynchronous: true,
			evalScripts: true,
			onCreate: function () {
				//$("parInfoDiv").writeAttribute("url", url);
				var info = $F("globalParType")=="E" ? "Pack Endt Basic Information" : "Pack PAR Basic Information";
				showNotice("Getting " + info +", please wait...");
			},
			onComplete: function (response)	{
				hideNotice("");
				if(checkErrorOnResponse(response)){
					setParMenus(parseInt($F("globalParStatus")), objUWGlobal.lineCd, objUWGlobal.sublineCd, $F("globalOpFlag"), objUWGlobal.issCd);
					var infoDiv = $F("parType") == "E" ? "endtBasicInformationDiv" : "basicInformationMainDiv";
					//if (!Object.isUndefined($("parCreationMainDiv"))) {
					//	Effect.Fade("parCreationMainDiv", {duration: .3});
					//}
					if ($("parListingMainDiv").getAttribute("module") == "parCreation"){ //nok 
						//Effect.Fade("parCreationMainDiv", {duration: .001});
						$("parCreationMainDiv").update(""); //nok kc pag galing creation ung mga naming ng item is my kaparehas so nasisira ung observe. 09.15.10
					}	
					Effect.Fade("parListingMainDiv", {
						duration: .001,
						afterFinish: function () {						
							$("parInfoMenu").show();
							Effect.Appear("parInfoDiv", {				
								duration: .001,
								afterFinish: function () {
									if ($("message").innerHTML == "SUCCESS" ){
										//if($F("parType")== "E"){
											//updateEndtParParameters();
										//} else{
											//$("underwritingMainMenu").hide();
											//$("parMenu").show();
											//$("parListingMenu").hide();
											initializeMenu();
											updateParParameters();
									} else{
										if($F("parType") == "E"){
											return true;
										}else{
											showMessageBox($("message").innerHTML, imgMessage.ERROR);
											$("basicInformationForm").disable();
											$("basicInformationFormButton").disable();
										}								
									}							
								}
							});
						}
					});			
				}		
			}			
		});*/
		//replaced by robert 04.18.2013 sr 12794
		/*new Ajax.Updater("parInfoDiv", url, {// contextPath+"/GIPIPackParInformationController",{
			parameters: {
				packParId: objUWGlobal.packParId,
				lineCd: lineCd,
				issCd: issCd,
				action: "showEndtPackParBasicInfo"
			},*/
		//jmm SR-22834
		if(validatePolNo2 != "Y" || validatePolNo2 == ""){
			new Ajax.Updater("parInfoDiv", contextPath+"/GIPIPackParInformationController",{
				parameters: {
					action: action,
					issCd: issCd,
					lineCd: lineCd,
					parId: parId,
					sublineCd: sublineCd,
					issueYy: issueYy,
					polSeqNo: polSeqNo,
					renewNo: renewNo,
					fromPolicyNo: fromPolicyNo,
					globalAssdNo: globalAssdNo,
					confirmResult: globalAssdNo == null || globalAssdNo == "" ? 2 : 1, // bonok :: 1.5.2017 :: SR 23641, 22834
					globalAddress1: globalAddress1,
					globalAddress2: globalAddress2,
					globalAddress3: globalAddress3
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function(){
					showNotice("Getting "+(objUWGlobal.parType == "P" ? "" : "Endt ")+ "Package PAR Basic Information, please wait...");
				},
				onComplete:function(response){
					try {
						hideNotice("");
						if(checkErrorOnResponse(response)){
							if(creationFlag){ // to indicate that the procedure came from the packPar/endtPackPar creation page - irwin
								$("packPackCreationDiv").update("");
								Effect.Fade("packPackCreationDiv",{
									duration: 0.001,
									afterFinish: function(){
										Effect.Appear("parInfoDiv",{
											duration: 0.001,
											afterFinish: function(){
												$("parInfoMenu").show(); // andrew - 07.11.2011 - trasferred to this line, fix for distorted menu
												if ($("message").innerHTML == "SUCCESS"){
													initializeMenu();
													updatePackParParameters(); // added by: nica 04.12.2011 - to update global parameters												
													//initializePackPARBasicMenu(); // comment out by andrew - 04.12.2011 - transferred to savePackPAR function
												} else {
													showMessageBox($("message").innerHTML, imgMessage.ERROR);
												}
											}
										});
								   }
								});
							}else{
								Effect.Fade("packParListingTableGridMainDiv",{
									duration: 0.001,
									afterFinish: function(){
										$("parInfoMenu").show();
										Effect.Appear("parInfoDiv",{
											duration: 0.001,
											afterFinish: function(){
												if ($("message").innerHTML == "SUCCESS"){
													initializeMenu();
													updatePackParParameters(); // added by: nica 04.12.2011 - to update global parameters
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
					} catch (e){
						showErrorMessage("getPackBasicInfo", e);
					}
				}
			});
		}else{
			//jmm SR-22834
			globalPolNo = "(" + lineCd + "-" + sublineCd + "-" + issCd + "-" + issueYy + "-" + polSeqNo + "-" + renewNo + ")";
	     	var msg = "Ceding company and/or assured entered does not tally with the policy for endorsement entered. Do you want to proceed? Pressing 'Yes' will update the ceding company and assured on the policy entered " + globalPolNo;

			
			validatePolNo2 = "";
			showConfirmBox("Confirmation", msg, "Yes", "No", 
			function(){
				new Ajax.Updater("parInfoDiv", contextPath+"/GIPIPackParInformationController",{
					parameters: {
						action: action,
						issCd: issCd,
						lineCd: lineCd,
						parId: parId,
						sublineCd: sublineCd,
						issueYy: issueYy,
						polSeqNo: polSeqNo,
						renewNo: renewNo,
						fromPolicyNo: fromPolicyNo,
						globalAssdNo: globalAssdNo,
						confirmResult: globalAssdNo == null || globalAssdNo == "" ? 2 : 1, // bonok :: 1.5.2017 :: SR 23641, 22834
						globalAddress1: globalAddress1,
						globalAddress2: globalAddress2,
						globalAddress3: globalAddress3
					},
					asynchronous: true,
					evalScripts: true,
					onCreate: function(){
						showNotice("Getting "+(objUWGlobal.parType == "P" ? "" : "Endt ")+ "Package PAR Basic Information, please wait...");
					},
					onComplete:function(response){
						try {
							hideNotice("");
							if(checkErrorOnResponse(response)){
								if(creationFlag){ // to indicate that the procedure came from the packPar/endtPackPar creation page - irwin
									$("packPackCreationDiv").update("");
									Effect.Fade("packPackCreationDiv",{
										duration: 0.001,
										afterFinish: function(){
											Effect.Appear("parInfoDiv",{
												duration: 0.001,
												afterFinish: function(){
													$("parInfoMenu").show(); // andrew - 07.11.2011 - trasferred to this line, fix for distorted menu
													if ($("message").innerHTML == "SUCCESS"){
														initializeMenu();
														updatePackParParameters(); // added by: nica 04.12.2011 - to update global parameters												
														//initializePackPARBasicMenu(); // comment out by andrew - 04.12.2011 - transferred to savePackPAR function
													} else {
														showMessageBox($("message").innerHTML, imgMessage.ERROR);
													}
												}
											});
									   }
									});
								}else{
									Effect.Fade("packParListingTableGridMainDiv",{
										duration: 0.001,
										afterFinish: function(){
											$("parInfoMenu").show();
											Effect.Appear("parInfoDiv",{
												duration: 0.001,
												afterFinish: function(){
													if ($("message").innerHTML == "SUCCESS"){
														initializeMenu();
														updatePackParParameters(); // added by: nica 04.12.2011 - to update global parameters
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
						} catch (e){
							showErrorMessage("getPackBasicInfo", e);
						}
					}
				});		
			},
			function(){
				notEqualRiCd = false
				validatePolNo2 = "";
				postValidate = "";
			});
			
		}
	} catch (e){
		showErrorMessage("getPackBasicInfo", e);
	}
}
