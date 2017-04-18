function checkUnpaidPremiums2(canvas){
	try{
		/*if(canvas == "CSL"){
			mainCSLGrid.releaseKeys();
		}else{
			loaTableGrid.releaseKeys();
		}
		*/
		new Ajax.Request(contextPath+"/GICLClaimsController", {
			asynchronous: false,
			parameters:{
				action: "checkUnpaidPremiums2",
				claimId	  : mcMainObj.claimId,
				evalId	  : selectedMcEvalObj.evalId,
				lineCd    : mcMainObj.lineCd,
				sublineCd : mcMainObj.sublineCd,
				polIssCd  : mcMainObj.polIssCd,
				clmFileDate : mcMainObj.clmFileDate,
				issueYy   : mcMainObj.polIssueYy,
				polSeqNo  : mcMainObj.polSeqNo,
				renewNo   : mcMainObj.polRenewNo
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var jsonObj = JSON.parse(response.responseText);
					if(jsonObj.printFl == "N"){
						var message = canvas +" was succesfully generated but you are not allowed to print it. What would you like to do?";
						
						showConfirmBox4("Confirmation", message, "Override", "Request Override", "Cancel Printing", 
						        function(){
								    showGicls030Override("GICLS070", "LO", 
													 function(ovr, userId, result){
														if(result.toString() == "FALSE"){
															showMessageBox("User is not allowed for override.", "E");
														}else{
															showGenericPrintDialog("Print "+canvas, function(){
																if(canvas == "CSL"){
																	printCSL(tempArrForPrint,"GICLS070");
																}else if(canvas == "LOA"){
																	printLOA(tempArrForPrint,"GICLS070");
																}
																
															});
															ovr.close();
														}
													 }, 
													 function(){
														null;
													 });
								}, 
						        function(){
									showGicls070OverrideRequest(canvas);
								},
								function(){
									
								}
							);
						
						
						
					}else{
						showGenericPrintDialog("Print CSL", function(){
							if(canvas == "CSL"){
								printCSL(tempArrForPrint,"GICLS070");
							}else if(canvas == "LOA"){
								printLOA(tempArrForPrint,"GICLS070");
							}
						});
					}
					
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("checkUnpaidPremiums2", e);	
	}
}