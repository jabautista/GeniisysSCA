<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="statusMainDiv">
	<div id="statusDiv" name="statusDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<table style="margin: 10px;">
			<tr>
				<td class="rightAligned" width="" height="40px">Item </td>
				<td class="leftAligned">
					<input type="text" id="txtStatItemTitle" name="txtStatItemTitle" readonly="readonly" style="width: 230px;" value=""/>
				</td>
				<td class="rightAligned" width="110px">Peril </td>
				<td class="leftAligned">
					<input type="text" id="txtStatPeril" name="txtStatPeril" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" height="40px">Loss Status </td>
				<td class="leftAligned">
					<input type="text" id="txtStatLossStatus" name="txtStatLossStatus" readonly="readonly" style="width: 230px;" value=""/>
				</td>
				<td class="rightAligned">Expense Status </td>
				<td class="leftAligned">
					<input type="text" id="txtStatExpenseStatus" name="txtStatExpenseStatus" readonly="readonly" style="width: 230px;" value=""/>
				</td>
			</tr>
		</table>		
	</div>
	<div align="center">
		<input type="button" class="button" id="btnStatOpen" value="Open" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnStatDeny" value="Deny" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnStatClose" value="Close" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnStatWithdraw" value="Withdraw" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnStatReturn" value="Return" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">	
	$("txtStatItemTitle").value = unescapeHTML2(objCurrGICLItemPeril.dspItemTitle);
	$("txtStatPeril").value =  unescapeHTML2(objCurrGICLItemPeril.dspPerilName);
	$("txtStatLossStatus").value =  unescapeHTML2(objCurrGICLItemPeril.lossStat);
	$("txtStatExpenseStatus").value =  unescapeHTML2(objCurrGICLItemPeril.expStat);
	
	function showConfirmationOverlay(message){
		overlayGICLS024Confirmation = Overlay.show(contextPath+"/GICLClaimReserveController", {
			urlContent: true,
			urlParameters: {action : "showConfirmationOverlay",
							claimId : objCLMGlobal.claimId},								
		    title: "Confirmation",
		    height: 145,
		    width: 500,
		    draggable: true
		});
		overlayGICLS024Confirmation.message = message;
	}
	
	function updateStatus(closeFlag, closeFlag2, message, updateXol){
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			parameters : {
						action : "updateStatus",
						closeFlag : closeFlag,
						closeFlag2 : closeFlag2,
						updateXol : updateXol,
						claimId : objCLMGlobal.claimId,
						itemNo : objCurrGICLItemPeril.itemNo,
						perilCd : objCurrGICLItemPeril.perilCd,
						groupedItemNo : objCurrGICLItemPeril.groupedItemNo,
						distributionDate : objGICLS024.distributionDate == null ? makeDate(dateFormat(
								new Date(), 'mm-dd-yyyy'))
								: objGICLS024.distributionDate, // ilalagay dito yung value kapag nagchange ng distribution date
						lossReserve : $F("txtLossReserve").replace(/,/g, ""),
						expenseReserve : $F("txtExpenseReserve").replace(/,/g, "")},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					
					showClaimReserve();
					overlayGICLS024UpdateStatus.close();
					delete overlayGICLS024UpdateStatus;
					showMessageBox(message, imgMessage.INFO);
					//giclItemPerilTableGrid.refresh();
					//robert
					 if(objGICLClaims.lineCd == "SU"){
						objGICLS024.getSUDetails();
					}else{
						claimReserveTableGrid.refresh();
					}
				}
			}
		});
	}
	
	overlayGICLS024UpdateStatus.showConfirmationOverlay = showConfirmationOverlay;
	overlayGICLS024UpdateStatus.updateStatus = updateStatus;
	
	$("btnStatReturn").observe("click", function(){
		overlayGICLS024UpdateStatus.close();
		delete overlayGICLS024UpdateStatus;
	});	
</script>

<!-- Open -->
<script type="text/javascript">
	function validateOpenClm(){
		var closeFlag = nvl(objCurrGICLItemPeril.closeFlag, "AP");
		var closeFlag2 = nvl(objCurrGICLItemPeril.closeFlag2, "AP");
		var newCloseFlag = "";				            
		var newCloseFlag2 = "";
		
		if((closeFlag == "DN" || closeFlag == "WD" || closeFlag == "DC") && (closeFlag2 == "DN" || closeFlag2 == "WD" || closeFlag2 == "DC")){
			if($F("txtLossReserve").trim() != "" || $F("txtExpenseReserve").trim() != ""){
				overlayGICLS024UpdateStatus.stat = "AP";
				overlayGICLS024UpdateStatus.showConfirmationOverlay("Reserve has been set-up for this item peril, activating it means creating new distribution record for the reserve. "+
										"<br/><br/>Which reserve do you want to activate?");
			} if($F("txtLossReserve").trim() == "" && $F("txtExpenseReserve").trim() == ""){
				overlayGICLS024UpdateStatus.stat = "AP";
				overlayGICLS024UpdateStatus.showConfirmationOverlay("Which reserve do you want to activate?");
			}
		} else if((closeFlag == "CP" || closeFlag == "CC") && (closeFlag2 != "CP" && closeFlag2 != "CC")){
			if(closeFlag2 == "WD" || closeFlag2 == "DN" || closeFlag2 == "DC"){
				overlayGICLS024UpdateStatus.stat = "AP";
				overlayGICLS024UpdateStatus.showConfirmationOverlay("Reserve has been set-up for this item peril, activating it means creating new distribution record for the reserve. "+
										"<br/><br/>Which reserve do you want to activate?");
			} else if(closeFlag2 == "AP"){
				showConfirmBox("Confirmation", "Reserve has been set-up for the loss of this item peril, activating it means creating new distribution record for the reserve. Are you sure you want to activate the loss reserve of this peril?", "Yes", "No",
								function(){
									// added by Kris 06.11.2014 for AUII SR 16009
									newCloseFlag = "AP";
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully activated and a new distribution record has been created.");
								}, 
								"");				
			}
		} else if((closeFlag != "CP" && closeFlag != "CC") && (closeFlag2 == "CP" || closeFlag2 == "CC")){
			if(closeFlag == "WD" || closeFlag == "DN" || closeFlag == "DC"){
				overlayGICLS024UpdateStatus.stat = "AP";
				overlayGICLS024UpdateStatus.showConfirmationOverlay("Reserve has been set-up for this item peril, activating it means creating new distribution record for the reserve. "+
	            						"<br/><br/>Which reserve do you want to activate?");
			} else if(closeFlag == "AP"){
				showConfirmBox("Confirmation", "Reserve has been set-up for the expense of this item peril, activating it means creating new distribution record for the reserve. Are you sure you want to activate the expense reserve of this peril?", "Yes", "No",
								function(){
									newCloseFlag2 = "AP";
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully activated and a new distribution record has been created.");
								}, 
								"");
			}
		} else if((closeFlag == "CP" || closeFlag == "CC") && (closeFlag2 == "CP" || closeFlag2 == "CC")){
			overlayGICLS024UpdateStatus.stat = "AP";
			overlayGICLS024UpdateStatus.showConfirmationOverlay("Reserve has been set-up for this item peril, activating it means creating new distribution record for the reserve. "+
									"<br/><br/>Which reserve do you want to activate?");
		} else if(closeFlag == "AP" && closeFlag2 == "AP"){
			showMessageBox("Item peril is already Open.", imgMessage.INFO);			
		} else if(closeFlag == "AP" && (closeFlag2 == "WD" || closeFlag2 == "DN" || closeFlag2 == "DC")){
			if($F("txtLossReserve").trim() != "" || $F("txtExpenseReserve").trim() != ""){ // Kris 06.04.2014 [AUII SR 15949]: changed && to || so records with either null loss reserve or null expense reserve are handled.
				showConfirmBox("Confirmation", "Reserve has been set-up for the expense of this item peril, activating it means creating new distribution record for the reserve. "+
								"Are you sure you want to activate the expense reserve of this peril?", "Yes", "No", 
								function(){
									newCloseFlag2 = "AP";
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully activated and a new distribution record has been created.");
								}, 
								"");			
			} else if($F("txtLossReserve").trim() == "" && $F("txtExpenseReserve").trim() == ""){
				showConfirmBox("Confirmation", "Are you sure you want to activate the expense reserve of this peril?", "Yes", "No", 
								function(){
									newCloseFlag2 = "AP";
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully activated and a new distribution record has been created.");
								}, 
								"");
			}
		} else if((closeFlag == "WD" || closeFlag == "DN" || closeFlag == "DC") && closeFlag2 == "AP"){
			if($F("txtLossReserve").trim() != "" || $F("txtExpenseReserve").trim() != ""){ // Kris 06.04.2014 [AUII SR 15949]: changed && to || so records with either null loss reserve or null expense reserve are handled.
				showConfirmBox("Confirmation", "Reserve has been set-up for the loss of this item peril, activating it means creating new distribution record for the reserve. "+
		                		"Are you sure you want to activate the loss reserve of this peril?", "Yes", "No", 
								function(){
									newCloseFlag = "AP";
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully activated and a new distribution record has been created.");
								}, 
								"");
			} else if($F("txtLossReserve").trim() == "" && $F("txtExpenseReserve").trim() == ""){
				showConfirmBox("Confirmation", "Are you sure you want to activate the loss reserve of this peril?", "Yes", "No", 
								function(){
									newCloseFlag = "AP";
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully activated and a new distribution record has been created.");
								}, 
								"");
			}
		}
	}

	$("btnStatOpen").observe("click", validateOpenClm);
</script>

<!-- Deny -->
<script type="text/javascript">
	function validateDenyClm(params){	
		if(params.advLflag == "TRUE" && params.advEflag == "TRUE"){
			showMessageBox("Item peril cannot be Denied. Advice has already been generated.", imgMessage.INFO);
			overlayGICLS024UpdateStatus.close();
			delete overlayGICLS024UpdateStatus;
		}
		
		if(params.xolShareType == null){
			showMessageBox("No existing XOL_TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.", imgMessage.INFO);
			params.xolShareType = 4;
		}
		
		var closeFlag = nvl(objCurrGICLItemPeril.closeFlag, "AP");
		var closeFlag2 = nvl(objCurrGICLItemPeril.closeFlag2, "AP");
		var wdDnDesc = "";
		var updateXol = ""; 
		var newCloseFlag = "";				            
		var newCloseFlag2 = "";
		
		if((closeFlag != "DN" && closeFlag != "WD") && (closeFlag == "DN" || closeFlag == "WD")){ // this condition is based on WHEN-BUTTON-PRESSED trigger of DENY_CLM button 
																								  // IF NVL (:c007.close_flag, 'AP') NOT IN ('DN', 'WD') AND NVL (:c007.close_flag, 'AP') IN ('DN', 'WD')
			if(params.xolExists == "Y"){
				if(closeFlag == "WD"){
					wdDnDesc = "Withdrawing";
				} else if(closeFlag == "DN"){
					wdDnDesc = "Denying";
				}
				
				if(params.catCd == null){
					showConfirmBox("Confirmation", "This claim has been distributed for the Excess of Loss. "+ 
									wdDnDesc + " will mean redistributing the records under this claim. Do you want to continue?", "Yes", "No",
						function(){
							updateXol = "Y";
							showMessageBox("Note: Please redistribute the reserve of all active peril records under this claim .", imgMessage.INFO);
						},
						"");
				} else {
					showConfirmBox("Confirmation", "The catastrophic event to which this record is included has been distributed for the Excess of Loss. " + 
									wdDnDesc + " will mean redistributing the records under its event. Do you want to continue?", "Yes", "No",
						function(){
							updateXol = "Y";
							showMessageBox("Note: Note: Please redistribute the the records under the catastrophic event in which this peril record is included "+ 
											"(Catastrophic Event code: "+params.catCd +").", imgMessage.INFO);							
						},
						"");
				}
				overlayGICLS024UpdateStatus.updateStatus(closFlag, closeFlag2, "Peril was successfully denied.", updateXol);
			} else if(closeFlag == "DN" || closeFlag == "WD"){
				showConfirmBox("Confirmation", "Are you sure you want this peril Denied?", "Yes", "No",
					function(){
						if(params.currExists == "Y"){
							updateXol = "Y";
							overlayGICLS024UpdateStatus.updateStatus(closFlag, closeFlag2, "Peril was successfully denied.", updateXol);
						} else {
							newCloseFlag = 'DN';			            
							newCloseFlag2 = 'DN';
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully denied.");
						}
					},
					"");
			} 
		} else if(closeFlag == "AP" && closeFlag2 == "AP"){
			if(params.advLflag != "TRUE" && params.advEflag != "TRUE"){
				if($F("txtLossReserve").trim() == "" || $F("txtExpenseReserve").trim() == ""){
					overlayGICLS024UpdateStatus.stat = "DN";
					overlayGICLS024UpdateStatus.showConfirmationOverlay("Claim has no reserve yet. Peril may be deleted instead." +
							"<br/><br/>Which reserve do you want to deny?");
				} else {
					overlayGICLS024UpdateStatus.stat = "DN";
					overlayGICLS024UpdateStatus.showConfirmationOverlay("Which reserve do you want to deny?");
				}
			} else if(params.advLflag != "TRUE" && params.advEflag == "TRUE"){
				showConfirmBox("Confirmation", "Are you sure you want to deny the loss reserve of this peril?", "Yes", "No",
						function(){
							newCloseFlag = 'DN';
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully denied.");
						},
						"");
			} else if(params.advLflag == "TRUE" && params.advEflag != "TRUE"){
				showConfirmBox("Confirmation", "Are you sure you want to deny the expense reserve of this peril?", "Yes", "No",
						function(){
							newCloseFlag2 = 'DN';
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully denied.");
						},
						"");
			}
		} else if(closeFlag == "DN" && closeFlag2 == "DN"){
			showMessageBox("Item peril was already denied.", imgMessage.INFO);
		} else if(closeFlag == "WD" && closeFlag2 == "WD"){
			showMessageBox("Item peril was already withdrawn.", imgMessage.INFO);
		} else if(closeFlag == "AP" && closeFlag2 != "AP"){
			if(params.advLflag != "TRUE"){
				var message = "";
				if($F("txtLossReserve").trim() == "" || $F("txtExpenseReserve").trim() == ""){
					message = "Claim has no reserve yet. Are you sure you want to deny the loss reserve of this peril?";
				} else {
					message = "Are you sure you want to deny the loss reserve of this peril?";
				}
				
				showConfirmBox("Confirmation", message, "Yes", "No",
						function(){
							newCloseFlag = 'DN';
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully denied.");
						},
						"");
			} else if(params.advLflag == "TRUE"){
				showMessageBox("Item peril cannot be Denied.", imgMessage.INFO);
			}
		} else if(closeFlag != "AP" && closeFlag2 == "AP"){				
			if(params.advEflag != "TRUE"){
				var message = "";
				if($F("txtLossReserve").trim() == "" || $F("txtExpenseReserve").trim() == ""){
					message = "Claim has no reserve yet. Are you sure you want to deny the expense reserve of this peril?";
				} else {
					message = "Are you sure you want to deny the expense reserve of this peril?";
				}
				
				showConfirmBox("Confirmation", message, "Yes", "No",
						function(){
							newCloseFlag2 = 'DN';
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully denied.");
						},
						"");
			} else if(params.advEflag == "TRUE"){
				showMessageBox("Item peril cannot be Denied.", imgMessage.INFO);
			}
		} else {
			showMessageBox("Item peril cannot be Denied.", imgMessage.INFO);
		}
	}
	
	function getPreValidationParams(){		
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			parameters: {action : "getPreValidationParams",
						 claimId : objCLMGlobal.claimId,
						 itemNo : objCurrGICLItemPeril.itemNo,
						 perilCd : objCurrGICLItemPeril.perilCd,
						 groupedItemNo : objCurrGICLItemPeril.groupedItemNo},
			onComplete : function(response){				
				if(checkErrorOnResponse(response)){
					var params = JSON.parse(response.responseText);
					validateDenyClm(params);
				}
			}
		});
	}
	
	$("btnStatDeny").observe("click", getPreValidationParams);
</script>

<!-- Close -->
<script type="text/javascript">
	function validateCloseClm(){
		var closeFlag = nvl(objCurrGICLItemPeril.closeFlag, "AP");
		var closeFlag2 = nvl(objCurrGICLItemPeril.closeFlag2, "AP");
		var newCloseFlag = "";				            
		var newCloseFlag2 = "";
		
		if($F("txtLossesPaid").trim() == "" && $F("txtExpensesPaid").trim() == ""){
			showMessageBox("Item peril without payments cannot be closed.", imgMessage.INFO);
		} else if($F("txtLossesPaid").trim() != "" || $F("txtExpensesPaid").trim() != ""){
			if((closeFlag == "DN" || closeFlag == "WD") && (closeFlag2 == "DN" || closeFlag2 == "WD")){
				showMessageBox("Item peril was denied and/or widthrawn.", imgMessage.INFO);
			} else if(closeFlag == "CP" && closeFlag2 == "CP"){
				showMessageBox("Item peril is already Closed.", imgMessage.INFO);
			} else if(closeFlag == "AP" && closeFlag2 == "AP"){
				if($F("txtLossesPaid").trim() != "" && $F("txtExpensesPaid").trim() != ""){
					overlayGICLS024UpdateStatus.stat = "CP";
					overlayGICLS024UpdateStatus.showConfirmationOverlay("Loss and Expense has payment. Which reserve do you want to close?");
				} else if($F("txtLossesPaid").trim() != "" && $F("txtExpensesPaid").trim() == ""){
					showConfirmBox("Confirmation","Are you sure you want to close the loss reserve of this peril?", "Yes", "No", //Modified by Jerome Bautista 06.22.2015 SR 4261
						function(){
							newCloseFlag = "CP";
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully closed.");
						},
					//	    function(){ Commented out by Jerome Bautista SR 4261 06.22.2015
					//		newCloseFlag = "CP";
					//		newCloseFlag2 = "CP";
					//		overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully closed.");
					//	},
						"");
				} else if($F("txtLossesPaid").trim() == "" && $F("txtExpensesPaid").trim() != ""){
					showConfirmBox("Confirmation","Are you sure you want to close the expense reserve of this peril?", "Yes", "No", //Modified by Jerome Bautista 06.22.2015 SR 4261
							function(){
								newCloseFlag2 = "CP";
								overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully closed.");
							},
					//		    function(){ Commented out by Jerome Bautista SR 4261 06.22.2015
					//			newCloseFlag = "CP";
					//			newCloseFlag2 = "CP";
					//			overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully closed.");
					//		},
							"");
				} else if($F("txtLossesPaid").trim() != "" && $F("txtExpensesPaid").trim() != ""){ //Added by Jerome Bautista 06.22.2015 SR 4261
					soverlayGICLS024UpdateStatus.stat = "CP";
					overlayGICLS024UpdateStatus.showConfirmationOverlay("Which reserve do you want to close?");
				}
			} else if(closeFlag == "AP" && closeFlag2 != "AP"){
				if($F("txtLossesPaid").trim() != ""){
					showConfirmBox("Confirmation", "Are you sure you want to close the loss reserve of this peril?", "Yes", "No", 
						function(){
							newCloseFlag = "CP";
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully closed.");
						},
						"");
				} else if($F("txtLossesPaid").trim() == ""){
					showMessageBox("Item peril without payments cannot be closed.", imgMessage.INFO);
				}
			} else if(closeFlag != "AP" && closeFlag2 == "AP"){
				if($F("txtExpensesPaid").trim() != ""){
					showConfirmBox("Confirmation", "Are you sure you want to close the expense reserve of this peril?", "Yes", "No", 
						function(){
							newCloseFlag2 = "CP";
							overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully closed.");
						},
						"");
				} else if($F("txtExpensesPaid").trim() == ""){
					showMessageBox("Item peril without payments cannot be closed.", imgMessage.INFO);
				}
			}
		}
	}
	
	$("btnStatClose").observe("click", validateCloseClm);	
</script>

<!-- Withdraw -->
<script type="text/javascript">
	function validateWithdrawClm(params){
		if(params.advLflag == "TRUE" && params.advEflag == "TRUE"){
			showMessageBox("Item peril cannot be Withdrawn. Advice has already been generated.", imgMessage.INFO);
			overlayGICLS024UpdateStatus.close();
			delete overlayGICLS024UpdateStatus;
		}
		
		if(params.xolShareType == null){
			showMessageBox("No existing XOL_TRTY_SHARE_TYPE parameter on GIAC_PARAMETERS.", imgMessage.INFO);
			params.xolShareType = 4;
		}
		
		var closeFlag = nvl(objCurrGICLItemPeril.closeFlag, "AP");
		var closeFlag2 = nvl(objCurrGICLItemPeril.closeFlag2, "AP");
		var wdDnDesc = "";
		var updateXol = ""; 
		var newCloseFlag = "";				            
		var newCloseFlag2 = "";

		if ((closeFlag != "DN" && closeFlag != "WD")
					&& (closeFlag == "DN" || closeFlag == "WD")) { // this condition is based on WHEN-BUTTON-PRESSED trigger of DENY_CLM button 
																	// IF NVL (:c007.close_flag, 'AP') NOT IN ('DN', 'WD') AND NVL (:c007.close_flag, 'AP') IN ('DN', 'WD')
				if (params.xolExists == "Y") {
					if (closeFlag == "WD") {
						wdDnDesc = "Withdrawing";
					} else if (closeFlag == "DN") {
						wdDnDesc = "Denying";
					}
	
					if (params.catCd == null) {
						showConfirmBox(
								"Confirmation",
								"This claim has been distributed for the Excess of Loss. "
										+ wdDnDesc
										+ " will mean redistributing the records under this claim. Do you want to continue?",
								"Yes",
								"No",
								function() {
									updateXol = "Y";
									showMessageBox(
											"Note: Please redistribute the reserve of all active peril records under this claim .",
											imgMessage.INFO);
								}, "");
					} else {
						showConfirmBox(
								"Confirmation",
								"The catastrophic event to which this record is included has been distributed for the Excess of Loss. "
										+ wdDnDesc
										+ " will mean redistributing the records under its event. Do you want to continue?",
								"Yes",
								"No",
								function() {
									updateXol = "Y";
									showMessageBox(
											"Note: Note: Please redistribute the the records under the catastrophic event in which this peril record is included "
													+ "(Catastrophic Event code: "
													+ params.catCd + ").",
											imgMessage.INFO);
								}, "");
					}
					
					overlayGICLS024UpdateStatus.updateStatus(closFlag, closeFlag2, "Peril was successfully withdrawn.", updateXol);
				} else if (closeFlag == "DN" || closeFlag == "AP") {
					showConfirmBox("Confirmation",
							"Are you sure you want this peril Withdrawn?", "Yes",
							"No", function() {
								if (params.currExists == "Y") {
									updateXol = "Y";
									
									overlayGICLS024UpdateStatus.updateStatus(closFlag, closeFlag2, "Peril was successfully withdrawn.", updateXol);
								} else {
									newCloseFlag = "WD";				            
									newCloseFlag2 = "WD";
									
									overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully withdrawn.");
								}
							}, "");
				}
			} else if (closeFlag == "AP" && closeFlag2 == "AP") {
				if (params.advLflag != "TRUE" && params.advEflag != "TRUE") {
					if ($F("txtLossReserve").trim() == "" || $F("txtExpenseReserve").trim() == "") {
						overlayGICLS024UpdateStatus.stat = "WD";
						overlayGICLS024UpdateStatus.showConfirmationOverlay("Claim has no reserve yet. Peril may be deleted instead."
										+ "<br/><br/>Which reserve do you want to withdraw?");
					} else {
						overlayGICLS024UpdateStatus.stat = "WD";
						overlayGICLS024UpdateStatus.showConfirmationOverlay("Which reserve do you want to withdraw?");
					}
				} else if (params.advLflag != "TRUE" && params.advEflag == "TRUE") {
					showConfirmBox(
							"Confirmation",
							"Are you sure you want to withdraw the loss reserve of this peril?",
							"Yes", "No", function() {
								newCloseFlag = "WD";
								
								overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully withdrawn.");
							}, "");
				} else if (params.advLflag == "TRUE" && params.advEflag != "TRUE") {
					showConfirmBox(
							"Confirmation",
							"Are you sure you want to withdraw the expense reserve of this peril?",
							"Yes", "No", function() {
								newCloseFlag2 = "WD";
								
								overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully withdrawn.");
							}, "");
				}
			} else if (closeFlag == "DN" && closeFlag2 == "DN") {
				showMessageBox("Item peril was already denied.", imgMessage.INFO);
			} else if (closeFlag == "WD" && closeFlag2 == "WD") {
				showMessageBox("Item peril was already withdrawn.", imgMessage.INFO);
			} else if (closeFlag == "AP" && closeFlag2 != "AP") {
				if (params.advLflag != "TRUE") {
					var message = "";
					if ($F("txtLossReserve").trim() == ""
							|| $F("txtExpenseReserve").trim() == "") {
						message = "Claim has no reserve yet. Are you sure you want to withdraw the loss reserve of this peril?";
					} else {
						message = "Are you sure you want to withdraw the loss reserve of this peril?";
					}
	
					showConfirmBox("Confirmation", message, "Yes", "No",
							function() {
								newCloseFlag = "WD";
								
								overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully withdrawn.");
							}, "");
				} else if (params.advLflag == "TRUE") {
					showMessageBox("Item peril cannot be Withdrawn.", imgMessage.INFO);
				}
			} else if (closeFlag != "AP" && closeFlag2 == "AP") {
				if (params.advEflag != "TRUE") {
					var message = "";
					if ($F("txtLossReserve").trim() == ""
							|| $F("txtExpenseReserve").trim() == "") {
						message = "Claim has no reserve yet. Are you sure you want to withdraw the expense reserve of this peril?";
					} else {
						message = "Are you sure you want to withdraw the expense reserve of this peril?";
					}
	
					showConfirmBox("Confirmation", message, "Yes", "No",
							function() {
								newCloseFlag2 = "WD";
								
								overlayGICLS024UpdateStatus.updateStatus(newCloseFlag, newCloseFlag2, "Peril was successfully withdrawn.");
							}, "");
				} else if (params.advEflag == "TRUE") {
					showMessageBox("Item peril cannot be Withdrawn.", imgMessage.INFO);
				}
			} else {
				showMessageBox("Item peril cannot be Withdrawn.", imgMessage.INFO);
			}
	}

	function getPreValidationParams() {
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			parameters : {
				action : "getPreValidationParams",
				claimId : objCLMGlobal.claimId,
				itemNo : objCurrGICLItemPeril.itemNo,
				perilCd : objCurrGICLItemPeril.perilCd,
				groupedItemNo : objCurrGICLItemPeril.groupedItemNo
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					var params = JSON.parse(response.responseText);
					validateWithdrawClm(params);
				}
			}
		});
	}

	$("btnStatWithdraw").observe("click", getPreValidationParams);
</script>