<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>

<div id="policyEntryMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%; margin-bottom: 10px; margin-top: 10px;">
	<div class="tableContainer" style="font-size:12px;">
		<div class="tableHeader">
			<label style="width: 30px; margin-left: 13px;">Line</label>
			<label style="width: 55px; margin-left: 10px;">Subline</label>
			<label style="width: 30px; margin-left: 8px;">Iss</label>
			<label style="width: 30px; margin-left: 10px;">Yy</label>
			<label style="width: 70px; margin-left: 5px;">Pol Seq #</label>
			<label style="width: 42px;">Rnew</label>
			<label style="width: 70px; margin-left: 1px;">Ref Pol No</label>
		</div>
	<table border="0" align="left" style="margin-top: 10px;">
		<tr>
			<td>
				<input type="text" id="polLineCd" style="width: 25px; margin-left: 7px;" maxlength="2" class="upper"/>
				<input type="text" id="polSublineCd" style="width: 45px; margin-left: 3px;" maxlength="7" class="upper"/>
				<input type="text" id="polIssCd" style="width: 25px; margin-left: 3px;" maxlength="2" class="upper"/>
				<input class="rightAligned" type="text" id="polIssYy" style="width: 25px; margin-left: 3px;" maxlength="2" />
				<input class="rightAligned" type="text" id="policySeqNo" style="width: 55px; margin-left: 3px;" maxlength="7" />
				<input class="rightAligned" type="text" id="polRenewNo" style="width: 25px; margin-left: 3px;" maxlength="2" />
				<input type="text" id="polRefPolNo" style="width: 120px; margin-left: 3px; margin-bottom: 5px;" maxlength="30" />
			</td>
		</tr>	
		<tr>
			<td><input type="checkbox" id="checkDue" value="N" style="float: left; margin-bottom: 10px; margin-left: 7px;"><label style="float: left;">Include not yet due</label></td>
		</tr>
	</table>
	</div>	
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px;">
	<input type="button" class="button" id="btnPolicyOk" value="Ok" />
	<input type="button" class="button" id="btnPolicyCancel" value="Cancel" />
</div>

<script>
	objAC.policyInvoices = new Array();
	makeInputFieldUpperCase();
	initializeAll();
	$("btnPolicyOk").observe("click", validatePolEntries);
	$("polLineCd").focus();	
	
	function closePolicyEntry(){
		giacs007PolicyOverlay.close();
		delete giacs007PolicyOverlay;
	}
	
	$("btnPolicyCancel").observe("click", 
		function() {
			objAC.usedAddButton = null;
			objAC.overdueOverride = null;
			objAC.claimsOverride = null;
			objAC.cancelledOverride = null;
			objAC.policyInvoices = null;
			objAC.fromPolOk = "N";
			closePolicyEntry(); //hideOverlay(); --marco - 09.16.2014 - replaced
	});

	/* $("polLineCd").observe("keyup", function(){
		$("polLineCd").value = $("polLineCd").value.toUpperCase();
	});

	$("polSublineCd").observe("keyup", function(){
		$("polSublineCd").value = $("polSublineCd").value.toUpperCase();
	});

	$("polIssCd").observe("keyup", function(){
		$("polIssCd").value = $("polIssCd").value.toUpperCase();
	}); */
	
	function showPackageInvoices(){
		// start SR-20000 : shan 08.10.2015
		objGIACS007 = new Object();
		objGIACS007.lineCd = $F("polLineCd");
		objGIACS007.sublineCd = $F("polSublineCd");
		objGIACS007.issCd = $F("polIssCd")
		objGIACS007.issYear = $F("polIssYy");
		objGIACS007.polSeqNo = $F("policySeqNo");
		objGIACS007.renewNo = $F("polRenewNo");
		objGIACS007.checkDue = $("checkDue").checked == true ? 'Y' : 'N';
		// end SR-20000 
		
		distDtlsOverlay = Overlay.show(contextPath+"/GIACDirectPremCollnsController", {
			asynchronous : true,
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     		: "getPackInvoices",
				lineCd			: $F("polLineCd"),
				sublineCd		: $F("polSublineCd"),	
				issCd			: $F("polIssCd"),
				issYear			: $F("polIssYy"),
				polSeqNo		: $F("policySeqNo"),
				renewNo			: $F("polRenewNo"),
				dueTag			: $("checkDue").checked == true ? 'Y' : 'N'
			},
		    title: "List Of Invoice",
		    height: 320,
		    width: 550
		});
	}
	
	function getPolicyEntryDetails() {
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=getPolicyEntryDetails" , {
			method: "GET",
			parameters: {		
				lineCd: $F("polLineCd"),
				sublineCd: $F("polSublineCd"),	
				issCd: $F("polIssCd"),
				issYear: $F("polIssYy"),
				polSeqNo: $F("policySeqNo"),
				renewNo: $F("polRenewNo"),
				refPolNo: $F("polRefPolNo"),
				checkDue: $("checkDue").checked == true ? 'Y' : 'N' /*$F("checkDue") == null ? 'Y' : $F("checkDue")*/
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response){
				objAC.invoicesOfPolicy = eval(response.responseText);
				if (objAC.invoicesOfPolicy) {
					closePolicyEntry(); //hideOverlay(); --marco - 09.16.2014 - replaced
					Modalbox.show(contextPath+"/GIACDirectPremCollnsController?action=showInvoicesOfPolicy", 
							  {title: "Invoice", 
							  width: 590,
							  height: 330,
							  asynchronous: false});

				}else {
					showMessageBox("Please enter a valid policy no.", imgMessage.INFO);
				}
			}	
		});
	}
	
	function isPolExist() {
		try {
			var result = false;
			new Ajax.Request(contextPath
					+ "/GIPIWOpenPolicyController?action=isPolExist", {
				method : "POST",
				evalScripts : true,
				asynchronous : false,
				parameters : {
					globalLineCd : $F("polLineCd"),
					opSublineCd : $F("polSublineCd"),
					opIssCd : $F("polIssCd"),
					opIssYear : $F("polIssYy"),
					opPolSeqNo : $F("policySeqNo"),
					opRenewNo : $F("polRenewNo")
				},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						if ("Y" == response.responseText) {
							result = true;
						} else {
							showMessageBox("Please enter a valid policy no.", imgMessage.ERROR);
						}
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("isPolExist", e);
		}
	}
	
	function checkExistInList(paramGaccTranId, paramTranSource, paramBillCmNo,
			paramInstNo, paramTranType) {
		var exist = false;
		if (getObjectFromArrayOfObjects(objAC.objGdpc,
				"gaccTranId issCd premSeqNo instNo tranType", paramGaccTranId
						+ paramTranSource + paramBillCmNo + paramInstNo
						+ paramTranType) != null) {
			exist = true;
		}
		return exist;
	}
	
	//marco - 09.16.2014
	function checkOpenPolicy(obj){
		if(nvl(obj.openProceed, "") == "N"){
			closePolicyEntry();
			showMessageBox(obj.openMessage, "E");
		}else if(nvl(obj.openProceed, "") == "Y"){
			showWaitingMessageBox(obj.openMessage, "I", function(){
				retrievePolicyInvoices();
			});
		}else{
			retrievePolicyInvoices();
		}
	}
	
	//marco - 09.16.2014
	function checkSpecialPolicy(obj){
		if(nvl(obj.specProceed, "") == "N"){
			closePolicyEntry();
			showMessageBox(obj.specMessage, "E");
		}else if(nvl(obj.specProceed, "") == "Y"){
			showWaitingMessageBox(obj.specMessage, "I", function(){
				checkOpenPolicy(obj);
			});
		}else{
			checkOpenPolicy(obj);
		}
	}
	
	//marco - 09.16.2014
	function validatePolicy(){
		new Ajax.Request(contextPath + "/GIACDirectPremCollnsController", {
			method: "GET",
			parameters: {
				action: "validatePolicy",
				lineCd: $F("polLineCd"),
				sublineCd: $F("polSublineCd"),
				issCd: $F("polIssCd"),
				issueYy: $F("polIssYy"),
				polSeqNo: $F("policySeqNo"),
				renewNo: $F("polRenewNo"),
				refPolNo: $F("polRefPolNo"),
				checkDue : $("checkDue").checked ? 'Y' : 'N'
			},
			evalScripts : true,
			asynchronous : false,
			onComplete : function(response) {
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					
					if(nvl(obj.endtProceed, "") == "" && nvl(obj.specProceed, "") == "" && nvl(obj.openProceed, "") == ""){
						retrievePolicyInvoices();
					}else{
						if(nvl(obj.endtProceed, "") == "N"){
							closePolicyEntry();
							showMessageBox(obj.endtMessage, "E");
						}else if(nvl(obj.endtProceed, "") == "Y"){
							showConfirmBox("Confirmation", obj.endtMessage, "Yes", "No", function(){
								checkSpecialPolicy(obj);
							}, null, "");
						}else{
							checkSpecialPolicy(obj);
						}
					}
				}
			}
		});
	}

	function retrievePolicyInvoices() {
		try {
			new Ajax.Request(contextPath + "/GIACDirectPremCollnsController", {
				method : "GET",
				parameters : {
					action : "getPolicyInvoices",
					lineCd : $F("polLineCd"),
					sublineCd : $F("polSublineCd"),
					issCd : $F("polIssCd"),
					issYear : $F("polIssYy"),
					polSeqNo : $F("policySeqNo"),
					renewNo : $F("polRenewNo"),
					refPolNo : $F("polRefPolNo"),
					checkDue : $("checkDue").checked == true ? 'Y' : 'N'
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function(response) {
					objAC.usedAddButton = "P";
					objAC.policyInvoices = eval(response.responseText);
					/* for(var i=0, length=objAC.invoicesOfPolicy.length; i<length; i++) {
						objAC.currentRecord = objAC.invoicesOfPolicy[i];
						objAC.currentRecord = validateGIACS007Policy(objAC.currentRecord.premSeqNo, objAC.currentRecord.instNo, 
								objAC.currentRecord.issCd, objAC.currentRecord.tranType, objAC.currentRecord, null);
						objAC.policyInvoices.push(objAC.currentRecord);
					} */
					//addRecordsInPaidList(policyInvoices);
					if (objAC.policyInvoices.length < 1) {
						//showMessageBox("Policy does not exist.", imgMessage.INFO);
						if(isPolExist()){
							if (checkIfBillsSettled()) {
								showWaitingMessageBox(
										"Bills for this policy have been settled.",
										"I", clearValues);
								return false;
							}
						}
					} else {
						if ((checkExistInList(objACGlobal.gaccTranId, objAC.policyInvoices[0].issCd, objAC.policyInvoices[0].premSeqNo, objAC.policyInvoices[0].instNo, objAC.policyInvoices[0].tranType))) {
							showMessageBox("Bill No. "+objAC.policyInvoices[0].issCd+"-"+objAC.policyInvoices[0].premSeqNo+"-"+objAC.policyInvoices[0].instNo+" is existing.", "I");
							return false;
						}else{
							rowPremCollnDeselectedFnTG();
							displayInvoicesToRows();
						}
					}
				}
			});

			closePolicyEntry(); //hideOverlay(); --marco - 09.16.2014 - replaced
		} catch (e) {
			showErrorMessage("retrievePolicyInvoices", e);
		}
	}

	function validatePolEntries() {
		if ($F("polLineCd").empty() || $F("polSublineCd").empty()
				|| $F("polIssCd").empty() || $F("polIssYy").empty()
				|| $F("policySeqNo").empty() || $F("polRenewNo").empty()) {
			showMessageBox("Please enter a valid policy no.", imgMessage.ERROR);
			return;
		} else {
			if ($F("btnPolicyOk") == "Ok") {
				//retrievePolicyInvoices(); --marco - 09.16.2014 - moved to validatePolicy
				validatePolicy();
			} else {
				showPackageInvoices();
				closePolicyEntry(); //hideOverlay(); --marco - 09.16.2014 - replaced
				//showPackageInvoices();	// moved above closePolicyEntry ::: SR-20000 : shan 08.10.2015
			}
			//getPolicyEntryDetails();
			//retrievePolicyInvoices();
		}
	}

	function execFireEvent() {
		closePolicyEntry(); //hideOverlay(); --marco - 09.16.2014 - replaced
		fireEvent($("billCmNo"), "blur");
		clearValues();
	}

	function checkIfPackage() {
		var exist = false;
		try {
			new Ajax.Request(contextPath
					+ "/GIPIPackPolbasicController?action=checkIfPackGIACS007",
					{
						evalScripts : true,
						asynchronous : false,
						method : "GET",
						parameters : {
							lineCd : $F("polLineCd"),
							sublineCd : $F("polSublineCd"),
							issCd : $F("polIssCd"),
							issueYy : $F("polIssYy"),
							polSeqNo : $F("policySeqNo"),
							renewNo : $F("polRenewNo")
						},
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var result = response.responseText;
								if (result == "X") {
									exist = true;
								}
							} else {
								showMessageBox(response.responseText,
										imgMessage.ERROR);
							}
						}
					});
			return exist;
		} catch (e) {
			showErrorMessage("checkIfPackage", e);
		}
	}

	function checkIfBillsSettled() {
		var exist = false;
		try {
			new Ajax.Request(
					contextPath
							+ "/GIPIPackPolbasicController?action=checkIfBillsSettledGIACS007",
					{
						evalScripts : true,
						asynchronous : false,
						method : "GET",
						parameters : {
							nbtDue : $("checkDue").checked == true ? 'Y' : 'N',
							lineCd : $F("polLineCd"),
							sublineCd : $F("polSublineCd"),
							issCd : $F("polIssCd"),
							issueYy : $F("polIssYy"),
							polSeqNo : $F("policySeqNo"),
							renewNo : $F("polRenewNo")
						},
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var result = response.responseText;
								if (result == "TRUE") { //modified by robert 12.27.12
									exist = true;
								}
							} else {
								showMessageBox(response.responseText,
										imgMessage.ERROR);
							}
						}
					});
			return exist;
		} catch (e) {
			showErrorMessage("checkIfPackage", e);
		}
	}

	function validateRenewNo() {
		//var ok = true;
		new Ajax.Request(
				contextPath + "/GICLClaimsController",
				{
					parameters : {
						action : "validateRenewNoGIACS007",
						lineCd : $F("polLineCd"),
						sublineCd : $F("polSublineCd"),
						polIssCd : $F("polIssCd"),
						issueYy : $F("polIssYy"),
						polSeqNo : $F("policySeqNo"),
						renewNo : $F("polRenewNo"),
						refPolNo : $F("polRefPolNo")
					},
					asynchronous : false,
					evalScripts : true,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							if (response.responseText != 'X') {
								//ok = false;
								getRefPolNo(); //marco - 09.16.2014
							} else {
								showConfirmBox(
										"Confirmation",
										"This policy has an existing claim. Would you like to continue with the premium collections?",
										"Yes",
										"No",
										function() {
											if (objAC.hasCCFunction == "Y" || objAC.overideCalled == "Y") {
												objAC.overideCalled = "Y";
												objAC.fromPolOk = "Y";
												getRefPolNo();
											} else if (objAC.overideCalled == "N") {
												showConfirmBox(
														"Premium Collections",
														"User is not allowed to process policy that has an existing claim. Would you like to override?",
														"Yes",
														"No",
														function() {
															showGenericOverride(
																"GIACS007",
																"CC",
																function(ovr, userId, result){
																	if (result == "FALSE") {
																		showMessageBox(userId + " is not allowed to override.", imgMessage.ERROR);
																		$("polRenewNo").focus();
																		clearValues();
																		objAC.overideCalled = "N"; //marco - 01.21.2015 - reset entered User is invalid
																		ovr.close();
																		delete ovr;
																	}else if(result == "TRUE"){
																		ovr.close();
																		delete ovr;
																		objAC.overideCalled = "Y";
																		objAC.fromPolOk = "Y"; //marco - 09.16.2014
																		getRefPolNo();
																	}
																},
																function(){
																	this.close();
																	clearValues();
																}, null);
														}, function() {
															clearValues();
															$("polLineCd").focus();
														});
											}
										}, clearValues);
							}
						}
					}
				});
		//return ok;
	}

	function clearValues() {
		$("polLineCd").value = null;
		$("polSublineCd").value = null;
		$("polIssCd").value = null;
		$("polIssYy").value = null;
		$("policySeqNo").value = null;
		$("polRenewNo").value = null;
		$("polRefPolNo").value = null;
		$("checkDue").value = null;

		//jsonDirectPremCollnsHiddenInfo.requery = "false"; robert 12.28.12
	}

	/* function getRefPolNo() {
		try {
			if ($F("polLineCd") != "" && $F("polSublineCd") != ""
					&& $F("polIssCd") != "" && $F("polIssYy") != ""
					&& $F("policySeqNo") != "" && $F("polRenewNo") != "") {
				new Ajax.Request(contextPath + "/GIPIPolbasicController", {
					method : "GET",
					parameters : {
						action : "getRefPolNo",
						lineCd : $F("polLineCd"),
						sublineCd : $F("polSublineCd"),
						issCd : $F("polIssCd"),
						issueYy : removeLeadingZero($F("polIssYy")),
						polSeqNo : removeLeadingZero($F("policySeqNo")),
						renewNo : removeLeadingZero($F("polRenewNo"))
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							$("polRefPolNo").value = response.responseText;
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("getRefPolNo", e);
		}
	} */
	
	function getRefPolNo(){
		try {
			if ($F("polLineCd") != "" && $F("polSublineCd") != ""
					&& $F("polIssCd") != "" && $F("polIssYy") != ""
					&& $F("policySeqNo") != "" && $F("polRenewNo") != "") {
				new Ajax.Request(contextPath + "/GIPIWOpenPolicyController", {
					method : "GET",
					parameters : {
						action : "getRefPolNo2",
						globalLineCd : $F("polLineCd"),
						opSublineCd : $F("polSublineCd"),
						opIssCd : $F("polIssCd"),
						opIssYear : removeLeadingZero($F("polIssYy")),
						opPolSeqNo : removeLeadingZero($F("policySeqNo")),
						opRenewNo : removeLeadingZero($F("polRenewNo"))
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							$("polRefPolNo").value = response.responseText;
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("getRefPolNo", e);
		}
	}

	$("polIssYy").observe(
			"change",
			function() {
				if ($F("polIssYy") == "" || isNaN($F("polIssYy"))
						|| parseInt($F("polIssYy")) < 0) {
					$("polIssYy").value = "";
				} else {
					$("polIssYy").value = parseInt($F("polIssYy"))
							.toPaddedString(2);
					getRefPolNo();
				}
			});

	$("policySeqNo").observe(
			"change",
			function() {
				if ($F("policySeqNo") == "" || isNaN($F("policySeqNo"))
						|| parseInt($F("policySeqNo")) < 0) {
					$("policySeqNo").value = "";
				} else {
					$("policySeqNo").value = parseInt($F("policySeqNo"))
							.toPaddedString(6);
					getRefPolNo();
				}
			});

	$("polRenewNo")
			.observe(
					"change",
					function() {
						if (!isNaN($F("polRenewNo")) && $F("polRenewNo") != "") {
							$("polRenewNo").value = parseInt($F("polRenewNo"))
									.toPaddedString(2);
							if (checkIfPackage()) {
								if (checkIfBillsSettled()) {
									showWaitingMessageBox(
											"Bills for this policy have been settled.",
											"I", clearValues);
								} else {
									showWaitingMessageBox(
											"This is a package policy. Select from the list of invoices you would want to settle.",
											"I",
											function() {
												$("btnPolicyOk").value = "Show Invoices";
												$("btnPolicyOk").focus();
											});
								}
							} else {
								/* var exists = !validateRenewNo() ? true : false;
								if (exists) {
									getRefPolNo();
								} */
								validateRenewNo(); //marco - 09.16.2014
							}
						} else {
							$("polRenewNo").value = "";
						}

						/* if($F("polRenewNo") == "" || isNaN($F("polRenewNo")) || parseInt($F("polRenewNo")) < 0) {
							$("polRenewNo").value = "";
						} else {
							$("polRenewNo").value = parseInt($F("polRenewNo")).toPaddedString(2);	
							getRefPolNo();
						} */
					});
	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y") { // andrew - 08.14.2012
		$("polLineCd").readOnly = true;
		$("polSublineCd").readOnly = true;
		$("polIssCd").readOnly = true;
		$("polIssYy").readOnly = true;
		$("policySeqNo").readOnly = true;
		$("polRenewNo").readOnly = true;
		$("polRefPolNo").readOnly = true;
		$("checkDue").disable();
	}
</script> 