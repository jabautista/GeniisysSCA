function checkUnpaidPremiums(obj, canvas, checkboxId){
	try{
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			asynchronous: false,
			parameters:{
				action: "checkUnpaidPremiums",
				claimId	  : objCLMGlobal.claimId,
				evalId	  : obj.evalId,
				clmLossId : obj.clmLossId,
				payeeClassCd : obj.payeeClassCd,
				payeeCd	  : obj.payeeCd,
				lineCd    : objCLMGlobal.lineCode,
				sublineCd : objCLMGlobal.sublineCd,
				polIssCd  : objCLMGlobal.policyIssueCode,
				clmFileDate : objCLMGlobal.strClaimFileDate,
				issueYy   : objCLMGlobal.issueYy,
				polSeqNo  : objCLMGlobal.policySequenceNo,
				renewNo   : objCLMGlobal.renewNo
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var jsonObj = JSON.parse(response.responseText);
					if(jsonObj.printFl == "N"){
						disableButton("btnGenerate"+canvas);
						if(jsonObj.ovrdExist == "5"){
							showConfirmBox("Confirmation", "There is an existing override request for the current record that is not yet approved.  Would you like to create a new request?", 
											"Ok", "Cancel", 
											function(){
												showGicls030OverrideRequest("Y", canvas);
											}, 
											function(){
												deselectGenerateTag(checkboxId);
												if(canvas == "LOA"){
													enableDisableGenerateLoaBtn();
												}else if(canvas == "CSL"){
													enableDisableGenerateCslBtn();
												}
											}
							);
						}else{
							var message = "Policy has an unpaid premium. You are not allowed to print "+canvas+
							          	  ". What would you like to do?";
							showConfirmBox4("Confirmation", message, "Override", "Request Override", "Cancel Printing", 
									        function(){
											    showGicls030Override("GICLS030", "LO", //GICLS070 - Changed to GICLS030. Jerome Bautista. 05.26.2015 SR 3648
																 function(ovr, userId, result){
																	if(result.toString() == "FALSE"){
																		showMessageBox("User is not allowed for override.", "E");
																		disableButton("btnGenerate"+canvas);
																		//deselectGenerateTag(checkboxId);
																	}else{
																		enableButton("btnGenerate"+canvas);
																		ovr.close();
																	}
																 }, 
																 function(){
																	 deselectGenerateTag(checkboxId);
																	 if(canvas == "LOA"){
																		 loaTableGrid.rows[obj.rowNum-1][loaTableGrid.getColumnIndex('generateTag')] = 'N'; //added by kenneth 12022014
																			enableDisableGenerateLoaBtn();
																	 }else if(canvas == "CSL"){
																		enableDisableGenerateCslBtn();
																	 }
																 });
											}, 
									        function(){
												showGicls030OverrideRequest("N", canvas);
											},
											function(){
												deselectGenerateTag(checkboxId);
											}
							);
						}
					}else{
						if(canvas == "LOA"){
							enableDisableGenerateLoaBtn();
						}else if(canvas == "CSL"){
							enableDisableGenerateCslBtn();
						}
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("checkUnpaidPremiums", e);	
	}
}