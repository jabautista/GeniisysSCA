<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="claimAdviceMainDiv" name="claimAdviceMainDiv">
	<form id="claimAdviceForm" name="claimAdviceForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/generateAdvice/generateAdvice/subPages/claimAdviceDetails.jsp"></jsp:include>
		<jsp:include page="/pages/claims/generateAdvice/generateAdvice/subPages/historyDetails.jsp"></jsp:include>
	</form>
	<div class="buttonsDiv" style="height: 90px; float: left;">
		<input type="button" class="button" id="btnGenerateAdvice" name="btnGenerateAdvice" value="Generate Advice" style="margin: 10px 2px 0 110px; float: left;" tabindex="300">
		<input type="button" class="button" id="btnCancelAdvice" name="btnCancelAdvice" value="Cancel Advice" style="margin: 10px 2px 0 2px; float: left;" tabindex="301">
		<input type="button" class="button" id="btnPrintCsr" name="btnPrintCsr" value="Print CSR" style="margin: 10px 2px 0 2px; float: left;" tabindex="302">
		<img id="btnAccountingEntries" alt="" title="Accounting Entries" src="${pageContext.request.contextPath}/images/misc/masterDetail.png" style="outline-style: ridge; border: 1px solid transparent; background-color: lightgray; margin: 5px 8px 0 8px; cursor: pointer; float: left;" tabindex="303">
		<input type="button" class="button" id="btnApproveCsr" name="btnApproveCsr" value="Approve CSR" style="margin: 10px 2px 0 2px; float: left;" tabindex="304">
		<input type="button" class="button" id="btnGenerateAcc" name="btnGenerateAcc" value="Generate AE." style="margin: 10px 2px 0 2px; float: left;" tabindex="305">
		<img id="btnCsr" alt="" title="Payment Request Details" src="${pageContext.request.contextPath}/images/misc/DESC.ICO" style="outline-style: ridge; border: 1px solid transparent; background-color: lightgray; margin: 5px 8px 0 8px; cursor: pointer; float: left;" tabindex="306">
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="margin: 10px 2px 0 2px; float: left;" tabindex="307">
	</div>
</div>
<script type="text/javascript">
	setDocumentTitle("Claim Advice");
	setModuleId("GICLS032");
	initializeAll();
	initializeAccordion();
	observeReloadForm("reloadForm",showClaimAdvice);	
	
	objGICLS032 = {};
	objGICLS032.tempPayeeNameArray = []; //Added by: Jerome Bautista 05.20.2015
	
	objGICLS032.vars = JSON.parse('${vars}');
	if(objGICLS032.vars.messageType == "INFO"){
		if(objGICLS032.vars.message != "SUCCESS"){
			showMessageBox(objGICLS032.vars.message, imgMessage.INFO);
		}
	} else if (objGICLS032.vars.messageType == "ERROR" && objGICLS032.vars.message != "SUCCESS"){
		showMessageBox(objGICLS032.vars.message, imgMessage.ERROR);
	}
	
	function testFunc(){
		new Ajax.Request(contextPath + "/GICLAdviceController", {
			method: "POST",
			parameters: {action : "testFunction",
						 claimId : objCLMGlobal.claimId,
						 adviceId : (objGICLS032.objCurrGICLAdvice == null ? null : objGICLS032.objCurrGICLAdvice.adviceId)
				}
		});
	}
	
	function createRequest(){
		new Ajax.Request(contextPath + "/GICLAdviceController", {
			method: "POST",
			parameters: {action : "createOverrideRequest",
					     claimId : objCLMGlobal.claimId,
					     adviceId : (objGICLS032.objCurrGICLAdvice == null ? null : objGICLS032.objCurrGICLAdvice.adviceId),					     
					     functionCode : objGICLS032.vars.functionCode,
					     remarks : $F("txtOverrideRequestRemarks")
					     },
			onComplete : function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						overlayOverrideRequest.close();
						delete overlayOverrideRequest;
					}
				}
			}
		});
	}
	
	function checkRequestExists(){
		new Ajax.Request(contextPath + "/GICLAdviceController", {
			parameters : {action : "gicls032CheckRequestExists",
						  claimId : objCLMGlobal.claimId,
						  adviceId : (objGICLS032.objCurrGICLAdvice != null ? objGICLS032.objCurrGICLAdvice.adviceId : null),
						  functionCode : objGICLS032.vars.functionCode},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var request = parseInt(response.responseText);
					if(request > 0){
						showConfirmBox("Confirmation", "Override Request already exists, continue?", "Yes", "Cancel", 
								function() {
									showGenericOverrideRequest("GICLS032", objGICLS032.vars.functionCode,
										createRequest,
										objGICLS032.refresh);
								},
							"");
					} else {
						showGenericOverrideRequest("GICLS032", objGICLS032.vars.functionCode,
							createRequest,
							objGICLS032.refresh);
					}
				}
			}
		});
	}	
	
	function checkConfirmOverrideMessageOnResponse(response) {
		var result = true;
		if (response.responseText.include("CONFIRM_AC_OVERRIDE")){
			objGICLS032.vars.functionCode = "AC";
			var message = response.responseText.split("#"); 
			showConfirmBox4("Confirmation", message[2], "Override", "Override Request", "Cancel", 
				function(){
					this.close(); 					
					showGenericOverride(
						"GICLS032",
						objGICLS032.vars.functionCode,
						function(ovr, userId, result){
							if(result == "FALSE"){
								showMessageBox(userId + " is not allowed to approve CSR.", imgMessage.ERROR);
								$("txtOverrideUserName").clear();
								$("txtOverridePassword").clear();
								$("txtOverrideUserName").focus();
								return false;
							} else if(result == 'TRUE') {	// somehow pag naka else lang, pumapasok parin lol - irwin	
								if(objGICLS032.objCurrGICLAdvice == null) {
									generateAdvice($F("txtOverrideUserName"), $F("txtOverridePassword"));
								} else {
									objGICLS032.acUserName = $F("txtOverrideUserName");															
									approveCsr("Y");
								}
								ovr.close();
								delete ovr;
							}								
						},
						function(){
							if(objGICLS032.objCurrGICLAdvice == null){
								objGICLS032.refresh();
							} else {
								objGICLS032.acUserName = null;
								objGICLS032.rpUserName = null;
							}
						});
				},
				checkRequestExists,
				function(){
					this.close();
					objGICLS032.refresh();
				});
			result = false;
		} else if (response.responseText.include("CONFIRM_RP_OVERRIDE")){
				objGICLS032.vars.functionCode = "RP";
				var message = response.responseText.split("#"); 
				showConfirmBox4("Confirmation", message[2], "Override", "Override Request", "Cancel", 
					function(){
						this.close();
						showGenericOverride(
							"GICLS032",
							objGICLS032.vars.functionCode,
							function(ovr, userId, result){
								if(result == "FALSE"){
									showMessageBox(userId + " is not allowed to approve reserve less than payment.", imgMessage.ERROR);
									$("txtOverrideUserName").clear();
									$("txtOverridePassword").clear();
									$("txtOverrideUserName").focus();
									return false;
								} else if(result == 'TRUE') {	
									if(objGICLS032.objCurrGICLAdvice == null) {
										generateAdvice($F("txtOverrideUserName"), $F("txtOverridePassword"));
									} else {
										objGICLS032.rpUserName = $F("txtOverrideUserName");															
										approveCsr("Y");
									}
									ovr.close();
									delete ovr;
								}								
							},
							function(){
								if(objGICLS032.objCurrGICLAdvice == null){
									objGICLS032.refresh();
								} else {
									objGICLS032.acUserName = null;
									objGICLS032.rpUserName = null;
								}
							});
					},
					checkRequestExists,
					function(){
						this.close();
						objGICLS032.refresh();
					});
				result = false;
		} else if(response.responseText.include("CONFIRM_RANGE_OVERRIDE")){
			var message = response.responseText.split("#");			
			showConfirmBox("Confirmation", message[2], "Yes", "No", 
				function(){
					showGenericOverride(
						"GICLS032",
						"AC",
						function(ovr, userId, ovrResult){
							if(ovrResult == "FALSE"){
								showWaitingMessageBox(userId + " is not allowed to approve advice amount.", imgMessage.ERROR, function(){
									$("txtOverrideUserName").value = "";
									$("txtOverridePassword").value = "";
									$("txtOverrideUserName").focus();
									
								});
							} else if(ovrResult == "TRUE"){
								new Ajax.Request(contextPath+"/GICLAdvLineAmtController", {
									parameters: {action : "getRangeTo",
												 userId : $F("txtOverrideUserName"), 
												 lineCd : objCLMGlobal.lineCd,
												 issCd : objCLMGlobal.issCd,
												},
									onComplete : function(response){
										if(checkErrorOnResponse(response)){
											var overrideUserRangeTo = response.responseText;
											if(nvl(overrideUserRangeTo, 0) > 0){
												if(parseFloat($F("txtAdviceAmount").replace(/,/g, "")) > parseFloat(nvl(overrideUserRangeTo, 0))){
													showWaitingMessageBox("Override failed. Advice amount exceeds the range allowable for " + userId + ".", imgMessage.ERROR, function(){
														$("txtOverrideUserName").value = "";
														$("txtOverridePassword").value = "";
														$("txtOverrideUserName").focus();
													});
												} else if(parseFloat($F("txtAdviceAmount").replace(/,/g, "")) <= parseFloat(nvl(overrideUserRangeTo, 0))){
													generateAdvice($F("txtOverrideUserName"), $F("txtOverridePassword"), $F("txtOverrideUserName"));
													
													ovr.close();
													delete ovr;
												}
											} else if (nvl(overrideUserRangeTo, 0) == 0){
												generateAdvice($F("txtOverrideUserName"), $F("txtOverridePassword"), $F("txtOverrideUserName"));
												
												ovr.close();
												delete ovr;
											}
										}
									}									
								});								
							}							
						},
						"");
				},
				"");
			result = false;
		} else {
			result = checkCustomErrorOnResponse(response);
		}
		return result;
	}
	
	function checkConfirmAcctEntMessageOnResponse(response) {
		var result = true;
		if (response.responseText.include("CONFIRM_ACCT_ENT")){
			var message = response.responseText.split("#");			
			showWaitingMessageBox(message[2], message[1], function(){
				showConfirmBox("Confirmation", message[5], "Yes", "No", 
						function(){
							showAccountingEntries();
							result = false;
						}, 
						function(){
							result = true;
						});
			});
		}
		return result;
	}
	
	function showAccountingEntries(){
		if(objGICLS032.objCurrGICLClmLossExp != null){
			overlayGICLAcctEntries = Overlay.show(contextPath+"/GICLAcctEntriesController", {
				urlContent: true,
				urlParameters: {action : "getGICLAcctEntriesList",
								claimId : objGICLS032.objCurrGICLClmLossExp.claimId,
								adviceId : objGICLS032.objCurrGICLClmLossExp.adviceId,
								payeeCd : objGICLS032.objCurrGICLClmLossExp.payeeCd,
								payeeClassCd : objGICLS032.objCurrGICLClmLossExp.payeeClassCd,
								ajax : "1"},
			    title: "Accounting Entries",
			    height: 450,
			    width: 750,
			    draggable: true
			});
		} else {
			showMessageBox("Please select a history details record first.", imgMessage.INFO);
		}
	}
	
	function showPaymentReqDetails(){
		overlayGIACPaytReqDtls = Overlay.show(contextPath+"/GIACPaytRequestDtlController", {
					urlContent: true,
					urlParameters: {action : "getGICLS032GIACPaytRequestDtlList",
									claimId : objGICLS032.objCurrGICLAdvice.claimId,
									adviceId : objGICLS032.objCurrGICLAdvice.adviceId,									
									ajax : "1"},
				    title: "Payment Request Details",
				    height: 425,
				    width: 750,
				    draggable: true
				});
	}
	
	function disableImageButton(id){
		$(id).stopObserving("click");
		$(id).style.opacity = "0.5";
		$(id).style.cursor = "default";
	}
	
	function enableImageButton(id, func){
		$(id).observe("click", func);
		$(id).style.opacity = "1";
		$(id).style.cursor = "pointer";
	}
	
	function disableEnableButtons(){
		try {			
			if(objGICLS032.objCurrGICLAdvice != null){
				new Ajax.Request(contextPath + "/GICLAdviceController", {
					parameters: {action : "gicls032EnableDisableButtons", 
								 claimId : objCLMGlobal.claimId,
								 adviceId : objGICLS032.objCurrGICLAdvice.adviceId},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							var buttons = JSON.parse(response.responseText);						
							buttons.btnCancelAdv == "enable" ? enableButton("btnCancelAdvice") : disableButton("btnCancelAdvice");
							buttons.btnPrintCsr	== "enable" ? enableButton("btnPrintCsr") : disableButton("btnPrintCsr");
							buttons.btnAcctEnt == "enable" ? enableImageButton("btnAccountingEntries", showAccountingEntries) : disableImageButton("btnAccountingEntries");
							buttons.btnAppCsr == "enable" ? enableButton("btnApproveCsr") : disableButton("btnApproveCsr");
							buttons.btnGenAcc == "enable" ? enableButton("btnGenerateAcc") : disableButton("btnGenerateAcc");
							buttons.btnCsr == "enable" ? enableImageButton("btnCsr", showPaymentReqDetails) : disableImageButton("btnCsr");
							buttons.btnGenAdv == "enable" ? enableButton("btnGenerateAdvice") : disableButton("btnGenerateAdvice");
							
							$("btnPrintCsr").value = buttons.btnLblPrintCsr;
						}
					}
				});
			} else {
				disableButton("btnGenerateAdvice");
				disableButton("btnCancelAdvice");
				disableButton("btnPrintCsr");
				$("btnPrintCsr").value = "Print CSR";
				disableImageButton("btnAccountingEntries");				
				disableButton("btnApproveCsr");
				disableButton("btnGenerateAcc");
				disableImageButton("btnCsr");
			}
		} catch (e) {
			showErrorMessage("disableEnableButtons", e);
		}
	}
	
	function setClaimAdviceForm(obj){
		try {
			$("txtAdviceNo").value = obj == null ? "" : obj.adviceNo;
			$("txtAdviceDate").value = obj == null ? "" : obj.adviceDate;
			$("selCurrency").value = obj == null ? "" : obj.currencyCd;
			$("txtConvertRate").value = obj == null ? "" : formatToNineDecimal(obj.convertRate);
			$("txtConvertRate").writeAttribute("oldConvertRate", obj == null ? "" : formatToNineDecimal(obj.convertRate));
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);
			$("txtPaidAmount").value = obj == null ? "" : formatCurrency(obj.paidAmt);
			$("txtNetAmount").value = obj == null ? "" : formatCurrency(obj.netAmt);
			$("txtAdviceAmount").value = obj == null ? "" : formatCurrency(obj.adviceAmt);
			$("hidPaidFcurrAmt").value = obj == null ? "" : formatCurrency(obj.paidFcurrAmt);
			$("hidNetFcurrAmt").value = obj == null ? "" : formatCurrency(obj.netFcurrAmt);
			$("hidAdvFcurrAmt").value = obj == null ? "" : formatCurrency(obj.advFcurrAmt);
			$("txtPayeeRemarks").value = obj == null ? "" : unescapeHTML2(obj.payeeRemarks);
			$("lblBatchNo").innerHTML = obj != null && obj.batchNo != null ? obj.batchNo : "&nbsp;";					
			
			obj == null ? disableButton("btnLocalCurrency") : enableButton("btnLocalCurrency");
			
			if(obj != null){	
				if(obj.batchNo != null){
					$("txtRemarks").writeAttribute("readonly");
				}else{
					$("txtRemarks").removeAttribute("readonly");
				}
				$("selCurrency").disabled = true;
				$("txtConvertRate").writeAttribute("readonly");
				$("txtPayeeRemarks").writeAttribute("readonly");
			} else {
				disableButton("btnAdviceUpdate");
				$("selCurrency").disabled = false;
				$("txtConvertRate").removeAttribute("readonly");
				$("txtConvertRate").removeClassName("required");
				$("txtPayeeRemarks").removeAttribute("readonly");
				$("selCurrency").value = "";
				$("txtConvertRate").value = ""; 
			}
		} catch (e){
			showErrorMessage("setClaimAdviceForm", e);
		}
	}
	
	function refresh(){
		objGICLS032.objCurrGICLAdvice = null;
		objGICLS032.objCurrGICLClmLossExp = null;
		objGICLS032.setClaimAdviceForm(null);
		objGICLS032.vars.selectedClmLoss = null;
		objGICLS032.selectedRows = [];
		tbgClaimAdvice._refreshList();
		tbgClaimAdviceHistory.url = contextPath+"/GICLClaimLossExpenseController?action=getGICLClmLossExpList&claimId="+objCLMGlobal.claimId+"&lineCd="+objCLMGlobal.lineCd;
		tbgClaimAdviceHistory._refreshList();		
		objGICLS032.disableEnableButtons();
		objGICLS032.acUserName = null;
		objGICLS032.rpUserName = null;
		objGICLS032.vars.vSwitch = null;
		
		if(tbgClaimAdvice.geniisysRows.length > 0){
			enableMenu("clmGenerateFLA");
		} else {
			disableMenu("clmGenerateFLA");
		}
	}	
	
	function createAdvice(){
		try {
			var objNewAdvice = new Object();
			objNewAdvice.currencyCd = $F("selCurrency");
			objNewAdvice.convertRate = $F("txtConvertRate");
			objNewAdvice.netAmt = $F("txtNetAmount").replace(/,/g, "");
			objNewAdvice.paidAmt = $F("txtPaidAmount").replace(/,/g, "");
			objNewAdvice.adviseAmt = $F("txtAdviceAmount").replace(/,/g, "");
			objNewAdvice.netFcurrAmt = $F("hidNetFcurrAmt");
			objNewAdvice.paidFcurrAmt = $F("hidPaidFcurrAmt");
			objNewAdvice.advFcurrAmt = $F("hidAdvFcurrAmt");
			objNewAdvice.remarks = escapeHTML2($F("txtRemarks")); //added escapeHTML2 christian 04/19/2013
			objNewAdvice.payeeRemarks = escapeHTML2($F("txtPayeeRemarks"));
			
			if(objGICLS032.vars.adviceCurrency != objGICLS032.vars.localCurrency){
				objNewAdvice.origCurrCd = objGICLS032.vars.adviceCurrency;
				objNewAdvice.origCurrRate = objGICLS032.vars.adviceRate;
			}
			
			return objNewAdvice;
		} catch (e){
			showErrorMessage("createAdvice", e);
		}
	}
	
	function generateAdvice(userName, password, ovrRangeUserName, ovr){
		if($F("txtConvertRate") == "" || /*parseInt*/formatToNineDecimal($F("txtConvertRate")) == 0){//edgar 11/07/2014 : modified to formatToNineDecimal from parseInt to consider below 0 convert rates.
			//showMessageBox("Cannot proceed with Advice Generation. Please enter a value for Convert Rate.", imgMessage.INFO);
			showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, function(){
				$("txtConvertRate").focus();
			});
			return false;
		}
		
		var objNewAdvice = createAdvice();
		new Ajax.Request(contextPath+"/GICLAdviceController", {
			method: "POST",
			parameters : {action : "gicls032GenerateAdvice",
						  claimId : objCLMGlobal.claimId,
						  advice : prepareJsonAsParameter(objNewAdvice),
						  selectedClmLoss : objGICLS032.vars.selectedClmLoss,
						  userName : userName,
						  password : password,
						  ovrRangeUserName : ovrRangeUserName
						},
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(objGICLS032.vars.disallowPymt == "O"){
					objGICLS032.vars.functionCode = "RP";
				}
				if(checkErrorOnResponse(response) && checkConfirmOverrideMessageOnResponse(response)){
					showMessageBox(response.responseText, imgMessage.INFO);
					objGICLS032.tempPayeeNameArray = []; //Added by: Jerome Bautista 05.20.2015
					objGICLS032.refresh();
					objGICLS032.vars.vSwitch = null;	
				}
			}				
		});
	}
	
	function cancelAdvice(){
		new Ajax.Request(contextPath+"/GICLAdviceController", {
			parameters: {action : "gicls032CancelAdvice",
						 claimId : objCLMGlobal.claimId,
				 		 adviceId : objGICLS032.objCurrGICLAdvice.adviceId,
				 		 functionCode : objGICLS032.vars.functionCode},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						try {
							showMessageBox("Advice has been cancelled.", imgMessage.INFO);						
							objGICLS032.refresh();													
						} catch(e){
							showErrorMessage("cancelAdvice - Request", e);
						}
					}
				}
			}
		});
	}
	
	function validateCancelAdvice(){
		try {
			var closeFlag;
			var tranId;
			var vSwitch;
			var closeFlag2 = ""; //Added by Jerome Bautista 05.28.2015 SR 4083
			for(var i=0; i<tbgClaimAdviceHistory.geniisysRows.length; i++){
				closeFlag = tbgClaimAdviceHistory.geniisysRows[i].closeFlag;
				closeFlag2 = tbgClaimAdviceHistory.geniisysRows[i].closeFlag2; //Added by Jerome Bautista 05.28.2015 SR 4083
				tranId = tbgClaimAdviceHistory.geniisysRows[i].tranId;
				vSwitch = 1;
			}

			if(closeFlag != "AP" && closeFlag2 != "AP"){ //&& closeFlag2 != "AP" - Added by Jerome Bautista 05.28.2015 SR 4083
				showMessageBox("Cannot cancel advice, Peril has been closed/withdrawn/denied.", imgMessage.INFO);
				return false;
			}
			
			if(tranId != null && vSwitch == 1){			
				showMessageBox("Cannot cancel advice, CSR has already been printed.", imgMessage.INFO);
				return false;
			} else if(tranId == null && vSwitch == 1){
				if(objGICLS032.objCurrGICLAdvice.advFlaId != null){
					showConfirmBox("Confirmation", "FLA has already been printed.  Do you really want to cancel this advice?", "Yes", "No",
						cancelAdvice, ""
					);
				} else {
					showConfirmBox("Confirmation", "Do you really want to cancel this advice?", "Yes", "No", 
						cancelAdvice, ""
					);
				}
			}
		} catch (e){
			showErrorMessage("validateCancelAdvice", e);
		}
	}
	
	function generateAccEntries(){
		try {
			var closeFlag = null;
			for(var i=0; i<tbgClaimAdviceHistory.geniisysRows.length; i++){
				closeFlag = tbgClaimAdviceHistory.geniisysRows[i].closeFlag;
			}
	
			if(closeFlag != null && closeFlag != "AP"){
				showMessageBox("Cannot generate accounting entry, Peril has been closed/withdrawn/denied.", imgMessage.INFO);
				return false;
			}
	
			overlayGenerateAcc = Overlay.show(contextPath+"/GICLAdviceController", {
				urlContent: true,
				urlParameters: {action : "gicls032GenerateAcc",
								claimId : objCLMGlobal.claimId,
								adviceId : objGICLS032.objCurrGICLAdvice.adviceId,
								lineCd : objCLMGlobal.lineCd,
								issCd : objCLMGlobal.issueCode,
								adviceRate : $F("txtConvertRate"),					
								progressBarLength : 318,
								ajax : "1"},
			    title: "Generate Accounting Entries",
			    showNotice: true,
			    noticeMessage: "Processing, please wait...",
			    height: 160,
			    width: 363,
			    draggable: true
			});
		} catch (e){
			showErrorMessage("generateAccEntries", e);
		}
	}
	
	function approveCsr(overrideSw){
		try {
			var closeFlag = ""; //Modified by Jerome Bautista 08.25.2015 SR 4651 / 12213
			var closeFlag2 = ""; //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
			var payeeType = ""; //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
			for(var i=0; i<tbgClaimAdviceHistory.geniisysRows.length; i++){
				closeFlag = tbgClaimAdviceHistory.geniisysRows[i].closeFlag;
				closeFlag2 = tbgClaimAdviceHistory.geniisysRows[i].closeFlag2; //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
                payeeType = tbgClaimAdviceHistory.geniisysRows[i].payeeType; //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
			}

            if(payeeType == "L"){ //Added by Jerome Bautista 08.25.2015 SR 4651 / 12213
				if(closeFlag != "AP"){
					showMessageBox("CSR cannot be approved, Peril has been closed/withdrawn/denied.", imgMessage.INFO);
					return false;
				}
            }else if (payeeType == "E"){
            	if(closeFlag2 != "AP"){
            		showMessageBox("CSR cannot be approved, Peril has been closed/withdrawn/denied.", imgMessage.INFO);
					return false;
            	}
            }
			
			objGICLS032.vars.functionCode = "AC";
			
			new Ajax.Request(contextPath + "/GICLAdviceController", {
				method: "POST",
				parameters: {action : "gicls032ApproveCsr",
							 claimId : objCLMGlobal.claimId,
							 adviceId : objGICLS032.objCurrGICLAdvice.adviceId,
							 acUserName : objGICLS032.acUserName,
							 rpUserName : objGICLS032.rpUserName,
							 overrideSw : overrideSw},
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkConfirmAcctEntMessageOnResponse(response) && checkConfirmOverrideMessageOnResponse(response)){
						objGICLS032.acUserName = "";
						objGICLS032.rpUserName = "";
						objGICLS032.disableEnableButtons();
					}
				}
			});
		} catch(e){
			showErrorMessage("approveCsr", e);
		}
	}
	
	function printCsr(){
		try {
			if($F("btnPrintCsr") == "Print CSR"){
				var reportId = "GICLR031";
				var reportTitle = "Preliminary Claim Settlement Request";
			} else if ($F("btnPrintCsr") == "Final CSR") {
				var reportId = "GICLR032";
				var reportTitle = "Claim Settlement Request";
			}
			
			var content = contextPath+"/GICLAdvicePrintController?action=printAdviceReport&claimId="+objCLMGlobal.claimId
							+"&adviceId="+objGICLS032.objCurrGICLAdvice.adviceId
							+"&reportId="+reportId+"&reportTitle="+reportTitle
							+"&printerName="+$F("selPrinter");	
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, reportTitle);
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
// 						checkErrorOnResponse(response);
						if (checkErrorOnResponse(response)){ //added by steven 11/26/2012
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "FILE"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printCsr", e);
		}
	}
	
	function saveClaimAdvice(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		} else {
			var setRows = tbgClaimAdvice.getModifiedRows();
			new Ajax.Request(contextPath+"/GICLAdviceController", {
				method: "POST",
				parameters : {action : "gicls032SaveRemarks",
						 	  setRows : prepareJsonAsParameter(setRows)},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						changeTag = 0;
						tbgClaimAdvice._refreshList();
						disableButton("btnSave");
					}
				}
			});
		}
	}	
		
	$("btnAccountingEntries").observe("mousedown", function(){
		$("btnAccountingEntries").style.borderColor = "gray"; 
	});
	$("btnAccountingEntries").observe("mouseup", function(){
		$("btnAccountingEntries").style.borderColor = "transparent"; 
	});
		
	$("btnCsr").observe("mousedown", function(){
		$("btnCsr").style.borderColor = "gray"; 
	});
	$("btnCsr").observe("mouseup", function(){
		$("btnCsr").style.borderColor = "transparent"; 
	});
		
	$("btnGenerateAdvice").observe("click", generateAdvice);	
	$("btnCancelAdvice").observe("click", validateCancelAdvice);
	$("btnPrintCsr").observe("click", function(){showGenericPrintDialog("Print Claim Settlement Request", printCsr);});
	$("btnAccountingEntries").observe("click", showAccountingEntries);
	$("btnApproveCsr").observe("click", approveCsr);	
	$("btnGenerateAcc").observe("click", generateAccEntries);	
	$("btnCsr").observe("click", showPaymentReqDetails);
	$("btnSave").observe("click", saveClaimAdvice);
	
	changeTag = 0;
	objGICLS032.objCurrGICLAdvice = null;
	objGICLS032.objCurrGICLClmLossExp = null;
	objGICLS032.setClaimAdviceForm = setClaimAdviceForm;
	objGICLS032.disableEnableButtons = disableEnableButtons;
	objGICLS032.refresh = refresh;
	objGICLS032.disableEnableButtons();	
	objGICLS032.setClaimAdviceForm();
	
	initializeChangeTagBehavior(saveClaimAdvice);
	disableButton("btnGenerateAdvice");
	disableButton("btnSave");
</script>