function validateMortgageeClassCd(payeeClassCd){
	try{
		objCLM.validateMortgageeClassCd = "N"; //added by steven 11/19/2012
		new Ajax.Request(contextPath+"/GICLLossExpPayeesController", {
			asynchronous: false,
			parameters:{
				action : "getLossExpPayeeMortgagees",
				claimId: objCLMGlobal.claimId,
				itemNo:  nvl(objCurrGICLItemPeril.itemNo, 0),
			    perilCd: nvl(objCurrGICLItemPeril.perilCd, 0),
			    payeeType : $("selPayeeType").value,
			    payeeClassCd: payeeClassCd
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var objArray = JSON.parse(response.responseText);
					var length = parseFloat(objArray.length);
					if(length == 1){
						for(var i=0; i<objArray.length; i++){
							checkIfGiclLossPayeesExist(payeeClassCd, objArray[i].payeeNo, objArray[i].payeeLastName, "mortgagee");
							break;
						}
					}else if(length > 1){
						objCLM.validateMortgageeClassCd = "Y"; //added by steven 11/19/2012
						showLossExpMortgageeLov(objCurrGICLItemPeril, payeeClassCd, $("selPayeeType").value);	
						return true;
					}else{
						var varPayeeType = $("selPayeeType").value; //added by kenneth 07212015 SR 19789 #2
						if($("selPayeeType").value == "L"){
							//$("selPayeeType").value = "E";
							//$("selPayeeType").selectedIndex = 1;
							varPayeeType = "E";
						}else{
							//$("selPayeeType").value = "L";
							//$("selPayeeType").selectedIndex = 0;
							varPayeeType = "L";
						}
						
						function contAoOverride(){
							if($("selPayeeType").value == "E"){
								$("selPayeeType").value = "E";
								$("selPayeeType").selectedIndex = 1;
								showLossExpPayeeClassLov();
							}else if($("selPayeeType").value == "L"){
								$("selPayeeType").value = "L";
								$("selPayeeType").selectedIndex = 0;
								if (!validateUserFunc2("AO", "GICLS030")){
									showConfirmBox("User Override.","User is not allowed to change payee class. Would you like to override?","Yes","No",function(){
										showGenericOverride("GICLS030","AO",
											function(ovr, userId, result) {
												if (result == "FALSE") {
													showMessageBox(userId+ " is not allowed to override.",imgMessage.ERROR);
													$("payee").value = "";
													$("payee").setAttribute("payeeNo", "");
													$("payeeClass").value = "";
													$("payeeClass").setAttribute("payeeClassCd", "");
													return false;
												}else if(result == "TRUE"){
													showLossExpPayeeClassLov();
													ovr.close();
													delete ovr;
												}
											}, function() {
												this.close();
												$("payee").value = "";
												$("payee").setAttribute("payeeNo", "");
												$("payeeClass").value = "";
												$("payeeClass").setAttribute("payeeClassCd", "");
											}
										);
									}, function(){
										$("payee").value = "";
										$("payee").setAttribute("payeeNo", "");
										$("payeeClass").value = "";
										$("payeeClass").setAttribute("payeeClassCd", "");
									} );
								}else{
									showLossExpPayeeClassLov();
								}
							}
						}
						
						function noAvailMortgagee(){
							showWaitingMessageBox("There are no available mortgagee for this claim", "I", function(){
								$("payee").value = "";
								$("payee").setAttribute("payeeNo", "");
								$("payeeClass").value = "";
								$("payeeClass").setAttribute("payeeClassCd", "");
							});
						}
						
						if(isGiclMortgExist == "Y"){
							var valMortAvail = validateTextFieldLOV("/ClaimsLOVController?action=getLossExpPayeeMortgList&claimId=" + objCLMGlobal.claimId + "&itemNo=" + nvl(objCurrGICLItemPeril.itemNo, 0) + "&perilCd="
									+ nvl(objCurrGICLItemPeril.perilCd, 0) + "&payeeClassCd=" + payeeClassCd + "&payeeType=" + varPayeeType, "%", "Searching, please wait...");
							
							if(valMortAvail == 0){
								/*showWaitingMessageBox("There are no more available mortgagee for this claim.", "I", function(){
									$("payee").value = "";
									$("payee").setAttribute("payeeNo", "");
									$("payeeClass").value = "";
									$("payeeClass").setAttribute("payeeClassCd", "");
								});*/ //changed by kenneth 07212015 SR 19789 #2
								if(nvl(objCLMGlobal.totalTag, "N") == "Y"){
									isGiclMortgExist = "N";
									contAoOverride();
								}else{
									noAvailMortgagee();
								}
							}else{
								showConfirmBox("Confirmation", "There is no mortgagee assigned in this claim for loss payment type. "+ 
										   "Do you want to create mortgagee for other payment type?", "Yes", "No", 
									       function(){
								showLossExpMortgageeLov(objCurrGICLItemPeril, payeeClassCd, varPayeeType);	
								if($("selPayeeType").value == "L"){
									$("selPayeeType").value = "E";
									$("selPayeeType").selectedIndex = 1;
								}else{
									$("selPayeeType").value = "L";
									$("selPayeeType").selectedIndex = 0;
								}
								return true;
								}, function(){
									if(nvl(objCLMGlobal.totalTag, "N") == "Y"){
										contAoOverride();
									}else{
										showLossExpPayeeClassLov();
									}
								});
							}
					 	}else{
					 		noAvailMortgagee();
					 	}	
					}
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}
			}
		});
	}catch(e){
		showErrorMessage("validateMortgageeClassCd", e);
	}
}