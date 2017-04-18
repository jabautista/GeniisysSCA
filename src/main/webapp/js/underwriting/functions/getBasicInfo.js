function getBasicInfo(){
	try {
		var action = "";
	    var parId 		= $F("globalParId");
		var lineCd 		= $("polParId") != null ? $F("polLineCd") : $F("globalLineCd");
		var sublineCd 	= $("polParId") != null ? $F("polSublineCd").replace(/&/g, '%26') : $F("globalSublineCd");
		var issCd 		= $("polParId") != null ? $F("polIssCd") : $F("globalIssCd");
		var issueYy 	= $("polParId") != null ? ($F("polIssueYy").blank() ? $F("globalIssueYy") : $F("polIssueYy")) : $F("globalIssueYy");
		var polSeqNo 	= $("polParId") != null ? ($F("polPolSeqNo").blank() ? $F("globalPolSeqNo") : $F("polPolSeqNo")) : $F("globalPolSeqNo");
		var renewNo 	= $("polParId") != null ? ($F("polRenewNo").blank() ? $F("globalRenewNo") : $F("polRenewNo")) : $F("globalRenewNo");
		var action 		= $F("globalParType")== "P" ? "showBasicInfo" : (endtBasicInfoSw == "Y" ? "showEndtBasicInfo01" : "showEndtBasicInfo");
	
		var url = "";
		if (validatePolNo2 != "Y" || validatePolNo2 == ""){ // jmm SR-22834 added params, ifelse and confirmbox
			
			//shan : added encodeURIComponent in sublineCd for escaping & [RSIC SR-13508]
			var url = contextPath+"/GIPIParInformationController?action="+action+"&issCd="+issCd+"&lineCd="+lineCd+"&parId="+parId+
						"&sublineCd="+encodeURIComponent(sublineCd)+"&issueYy="+issueYy+"&polSeqNo="+polSeqNo+"&renewNo="+renewNo+
						"&fromPolicyNo="+($("polParId") != null ? "Y" : "N");
			
			new Ajax.Updater("parInfoDiv", url, {
				method:"GET",
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					var info = $F("globalParType")=="E" ? "Endt Basic Information" : "Basic Information";
					showNotice("Getting " + info +", please wait...");
				},
				onComplete: function (response)	{
					hideNotice();
					if(checkErrorOnResponse(response)){
						setParMenus(parseInt($F("globalParStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd")); // andrew - 10.04.2010 - added this line
						var infoDiv = objUWParList.parType == "E" ? "endtBasicInformationDiv" : "basicInformationMainDiv";
						if ($("parListingMainDiv").getAttribute("module") === "parCreation"){ //nok 
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
											initializeMenu();
										} else{
											initializeMenu();
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
			});
		}else if(validatePolNo2 == "Y"){
			globalPolNo = "(" + lineCd + "-" + sublineCd + "-" + issCd + "-" + issueYy + "-" + polSeqNo + "-" + renewNo + ")";
	     	var msg = "Ceding company and/or assured entered does not tally with the policy for endorsement entered. Do you want to proceed? Pressing 'Yes' will update the ceding company and assured on the policy entered " + globalPolNo;
			
			validatePolNo2 = "";
			var url = contextPath+"/GIPIParInformationController?action="+action+"&issCd="+issCd+"&lineCd="+lineCd+"&parId="+parId+"&globalAssdName="+unescapeHTML2(globalAssdName)+"&globalAssdNo="+globalAssdNo+
			"&sublineCd="+encodeURIComponent(sublineCd)+"&issueYy="+issueYy+"&polSeqNo="+polSeqNo+"&renewNo="+renewNo+"&confirmResult=1"+"&address1="+globalAddress1+"&address2="+globalAddress2+"&address3="+globalAddress3+
			"&fromPolicyNo="+($("polParId") != null ? "Y" : "N");
			
			showConfirmBox("Confirmation", msg, "Yes", "No", 
			function(){
				
				new Ajax.Updater("parInfoDiv", url, {
					method:"GET",
					asynchronous: true,
					evalScripts: true,
					onCreate: function () {
						var info = $F("globalParType")=="E" ? "Endt Basic Information" : "Basic Information";
						showNotice("Getting " + info +", please wait...");
					},
					onComplete: function (response)	{
						hideNotice();
						if(checkErrorOnResponse(response)){
							setParMenus(parseInt($F("globalParStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd")); // andrew - 10.04.2010 - added this line
							var infoDiv = objUWParList.parType == "E" ? "endtBasicInformationDiv" : "basicInformationMainDiv";
							if ($("parListingMainDiv").getAttribute("module") === "parCreation"){ //nok 
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
												initializeMenu();
											} else{
												initializeMenu();
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
				});
			},
			function(){
				notEqualRiCd = false
				validatePolNo2 = "";
				postValidate = "";
			});
		}else{
			validatePolNo2 = "";
			//shan : added encodeURIComponent in sublineCd for escaping & [RSIC SR-13508]
			var url = contextPath+"/GIPIParInformationController?action="+action+"&issCd="+issCd+"&lineCd="+lineCd+"&parId="+parId+
						"&sublineCd="+encodeURIComponent(sublineCd)+"&issueYy="+issueYy+"&polSeqNo="+polSeqNo+"&renewNo="+renewNo+
						"&fromPolicyNo="+($("polParId") != null ? "Y" : "N");
			
			new Ajax.Updater("parInfoDiv", url, {
				method:"GET",
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					var info = $F("globalParType")=="E" ? "Endt Basic Information" : "Basic Information";
					showNotice("Getting " + info +", please wait...");
				},
				onComplete: function (response)	{
					hideNotice();
					if(checkErrorOnResponse(response)){
						setParMenus(parseInt($F("globalParStatus")), $F("globalLineCd"), $F("globalSublineCd"), $F("globalOpFlag"), $F("globalIssCd")); // andrew - 10.04.2010 - added this line
						var infoDiv = objUWParList.parType == "E" ? "endtBasicInformationDiv" : "basicInformationMainDiv";
						if ($("parListingMainDiv").getAttribute("module") === "parCreation"){ //nok 
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
											initializeMenu();
										} else{
											initializeMenu();
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
			});
		}
	}catch (e){
		showErrorMessage("getBasicInfo", e);
	}
	
}
//end cris