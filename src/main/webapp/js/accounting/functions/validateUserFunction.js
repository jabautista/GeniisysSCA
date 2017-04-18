/* same with validateUserFunc
 * but nirename ko kasi di pumapasok sa validateUserFunc o_o
 * robert 10.16.2013
 */
function validateUserFunction(functionCode, modName, reqType, optionalParam){
	try {
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateUserFunc", { 
			method: "GET",
			parameters: {
				funcCode: functionCode,
				moduleName: modName	
			},
			evalScripts: true,
			asynchrounous: false,
			onComplete: function (response){
				var result = response.responseText;
					if (result == "FALSE"){
						if (reqType == "cancelled"/* && objAC.cancelledOverride != 1*/) {
							showConfirmBox("Premium Collections", "User is not allowed to process "+
									"payment for cancelled policies. Would you like to override?", "Yes", "No", 
									function() {
										showGenericOverride("GIACS007","AP",
												function(ovr, userId, result) {
													if (result == "FALSE") {
														showMessageBox(userId+ " is not allowed to process payment for cancelled policies.",imgMessage.ERROR);
														//robert 01.16.2013
														//inValidateOverridePayt(); 
														return false;
													} else if (result == "TRUE"){ //robert 01.16.2013
														ovr.close();
														delete ovr;
														objAC.overideCalled = "Y";
														objAC.cancelledOverride = 1;
														contValidationCheckForClaim(optionalParam);
													}
												}, function() {
													inValidateOverridePayt();
													this.close();
												});
									},
									function() {
										inValidateOverridePayt();
									});
						} else if(reqType == "cancelled2"/* && objAC.cancelledOverride != 1*/) {
							showConfirmBox("Premium Collections", "User is not allowed to process "+
									"payment for cancelled policies. Would you like to override?", "Yes", "No", 
									function() {
										showGenericOverride("GIACS007","AP",
												function(ovr, userId, result) {
													if (result == "FALSE") {
														showMessageBox(userId+ " is not allowed to process payment for cancelled policies.",imgMessage.ERROR);
														//robert 01.16.2013
														//inValidateOverridePayt(); 
														return false;
													} else if (result == "TRUE"){ //robert 01.16.2013
														ovr.close();
														delete ovr;
														objAC.overideCalled = "Y";
														objAC.cancelledOverride = 1;
													}
												}, function() {
													clearInvalidPrem();
													this.close();
												});
									},
									function() {
										inValidateOverridePayt();
									});
						} else if (reqType == "overdue"/* && objAC.overdueOverride != 1*/) {
	                    	showConfirmBox("Premium Collections", "User is not allowed to process "+
	                    			"premium collections for overdue bill. Would you like to override?", "Yes", "No", 
	                            			function () {
												showGenericOverride("GIACS007","AO",
														function(ovr, userId, result) {
															if(objAC.overdueOverride != 1) {
																if (result == "FALSE") {
																	showMessageBox(userId+ " is not allowed to process collections for overdue bill.",imgMessage.ERROR);
																	//robert 01.16.2013
																	//inValidateOverridePayt(); 
																	return false;
																} else if (result == "TRUE"){ //robert 01.16.2013
																	ovr.close();
																	delete ovr;
																	objAC.overideCalled = "Y";
																	objAC.overdueOverride = 1;
																	confirmOverdueOverride();
																}
															}
														}, function() {
															inValidateOverridePayt();
															this.close();
														});
	                            			}, function () {
	                            				inValidateOverridePayt();
	                        			   });
						}else if (reqType == "claim"/*&& objAC.claimsOverride != 1*/) {
							showConfirmBox("Premium Collections", "User is not allowed to process policy that has an existing claim. Would you like to override?", "Yes", "No", 
											function () {
												showGenericOverride("GIACS007","CC",
														function(ovr, userId, result) {
															if (result == "FALSE") {
																showMessageBox(userId+ " is not allowed to process collections for policies with existing claims.",imgMessage.ERROR);
																//robert 01.16.2013
																//inValidateOverridePayt(); 
																return false;
															} else if (result == "TRUE"){ //robert 01.16.2013
																ovr.close();
																delete ovr;
																objAC.overideCalled = "Y";
																objAC.claimsOverride = 1;
																contValidationCheckForOverdue(optionalParam);
															}
														}, function() {
															inValidateOverridePayt();
															this.close();
														});							
											}, function () {
												inValidateOverridePayt();
											});
						}
					}else{//modified by robert 01.17.2013
						//confirmOverdueOverride();
						if (reqType == "cancelled") {
							contValidationCheckForClaim(optionalParam);
						} else if (reqType == "overdue") {
							confirmOverdueOverride();
						}else if (reqType == "claim") {
							contValidationCheckForOverdue(optionalParam);
						}
					}
				}
			});
	} catch(e) {
		showErrorMessage("validateUserFunc", e);
	}
}