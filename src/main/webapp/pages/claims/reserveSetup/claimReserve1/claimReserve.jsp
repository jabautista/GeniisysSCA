<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="claimReserveMainDiv" name="claimReserveMainDiv" >
	<form id="claimReserveForm" name="claimReserveForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="subPages/itemInformation.jsp"></jsp:include>		
		<div class="buttonsDiv" >
			<input id="distDtlsBtn" name="distDtlsBtn" class="button" type="button" value="Distribution Details" style="" title="Distribution Details">
			<input id="updateStatusBtn" name="updateStatusBtn" class="button" type="button" value="Update Status" style="" title="Update Status">
			<input id="availmentsBtn" name="availmentsBtn" class="button" type="button" value="Availments" style="" title="Availments">
			<input id="paymentHistoryBtn" name="paymentHistoryBtn" class="button" type="button" value="Payment History" style="" title="Payment History"> 
			<input id="reserveHistoryBtn" name="reserveHistoryBtn" class="button" type="button" value="Reserve History" style="" title="Reserve History"> 
			<input id="redistributeBtn" name="redistributeBtn" class="button" type="button" value="Redistribute" style="" title="Redistribute">
			<input id="distributionDateBtn" name="distributionDateBtn" class="button" type="button" value="Distribution Date" style="" title="Distribution Date"> 
			<input id="btnSaveReserve" name="btnSaveReserve" class="button" type="button" value="Save" style="" title="Save">		
		</div>
	</form>
</div>
<script type="text/javascript">
	objGICLClaims = JSON.parse('${objGICLClaims}');
	objGICLS024.vars = JSON.parse('${vars}');
	var  bkngDateExist = '${bkngDateExist}';
	var  orCnt = '${orCnt}';
	var redistributeSw = 'N';
	objGICLClaims.lossRsrvFlag = "N";
	objGICLS024.claimReserveChanged == "N";
	objGICLS024.overrideOk = "N";
	
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeMenu();
	makeInputFieldUpperCase();
	
	window.scrollTo(0, 0);
	hideNotice("");
	setModuleId("GICLS024");
	setDocumentTitle("Reserve Set-up");
	
	disableButton("distDtlsBtn");
	disableButton("paymentHistoryBtn");
	disableButton("updateStatusBtn");
	disableButton("reserveHistoryBtn");
	disableButton("redistributeBtn");
	disableButton("distributionDateBtn");
	disableButton("availmentsBtn");
	disableButton("btnSaveReserve");
	
	observeReloadForm("reloadForm", showClaimReserve);	
	objCurrGICLItemPeril = {};
	
	var triggerType; //1 for btnSaveReserve; to automatically distributes the claim after override
	
	function showUpdateStatus() {
		try {
			if (changeTag == 1) {
				showMessageBox(
						"Save the changes first before updating the peril status.",
						imgMessage.INFO);
			} else {
				overlayGICLS024UpdateStatus = Overlay.show(contextPath
						+ "/GICLClaimReserveController", {
					urlContent : true,
					urlParameters : {
						action : "showUpdateStatusOverlay",
						claimId : objCLMGlobal.claimId
					},
					title : "Update Loss/Expense Status",
					height : 168,
					width : 700,
					draggable : true
				});
			}
		} catch (e) {
			showErrorMessage("showUpdateStatus", e);
		}
	}

	$("updateStatusBtn").observe("click", showUpdateStatus);
	
	$("availmentsBtn").observe(
			"click",
			function() {
				if (JSON.stringify(objCurrGICLItemPeril) == "{}") {
					showMessageBox("Select a record first.");
					return;
				}
				overlayGICLS024Availments = Overlay.show(contextPath
						+ "/GICLClaimReserveController", {
					urlContent : true,
					urlParameters : {
						action : "showAvailmentsOverlay",
						claimId : objCLMGlobal.claimId,
						itemNo : objCurrGICLItemPeril.itemNo,
						groupedItemNo : objCurrGICLItemPeril.groupedItemNo,
						perilCd : objCurrGICLItemPeril.perilCd,
						lineCd : objGICLClaims.lineCd
					},
					title : "Listing of Availments",
					height : 378,
					width : 675,
					draggable : true
				});
			});

	$("distributionDateBtn").observe("click", function() {
		if (JSON.stringify(objCurrGICLItemPeril) == "{}") {
			showMessageBox("Select a record first.");
			return;
		}
		showDistDateOverlay();
	});
	
	function showReserveHistoryOverlay(){
		distDtlsOverlay = Overlay.show(contextPath+"/GICLClaimReserveController", {
			urlContent: true,
			draggable: true,
			urlParameters: {
				action    	  : "showResHistOverlay",
				claimId    : objCLMGlobal.claimId,
				itemNo   : objCurrGICLItemPeril.itemNo,
			    perilCd	 : objCurrGICLItemPeril.perilCd
			},
		    title: "Reserve History",
		    height: 300,
		    width: 680
		}); 
	}
	
	$("reserveHistoryBtn").observe("click", function() {
		if (JSON.stringify(objCurrGICLItemPeril) == "{}") {
			showMessageBox("Select a record first.");
			return;
		}
		showReserveHistoryOverlay();
	});
	
	function showDistDtlsOverlay(){
		distDtlsOverlay = Overlay.show(contextPath+"/GICLClaimReserveController", {
			urlContent: true,
			draggable: true,
			urlParameters: {
				action     		: "showDistDtlsOverlay",
				claimId    		: objCLMGlobal.claimId,
				clmResHistId	: objCurrGICLItemPeril.giclClmResHist.clmResHistId,
				itemNo			: objCurrGICLItemPeril.giclClmResHist.itemNo,
				perilCd			: objCurrGICLItemPeril.giclClmResHist.perilCd
			},
		    title: "Distribution Details",
		    height: 520,
		    width: 755
		});
	}
	
	$("distDtlsBtn").observe("click", showDistDtlsOverlay);
	
	$("paymentHistoryBtn").observe(
		"click",
		function() {
			if (JSON.stringify(objCurrGICLItemPeril) == "{}") {
				showMessageBox("Select a record first.");
				return;
			}
			overlayGICLS024PaymentHistory = Overlay.show(contextPath
					+ "/GICLClaimReserveController", {
				urlContent : true,
				urlParameters : {
					action : "showPaymentHistOverlay",
					claimId : objCLMGlobal.claimId,
					itemNo : objCurrGICLItemPeril.itemNo,
					groupedItemNo : objCurrGICLItemPeril.groupedItemNo,
					perilCd : objCurrGICLItemPeril.perilCd
				},
				title : "Payment History",
				height : 340,
				width : 680,
				draggable : true
			});
		});
	
	function continueRedistribution() {
		try {			
			var distDate = (objGICLS024.distributionDate == null ? dateFormat(new Date(), 'mm-dd-yyyy') : ("0"+(objGICLS024.distributionDate.getMonth()+1)).slice(-2)+ "-" +("0" + objGICLS024.distributionDate.getDate()).slice(-2)  + "-" +objGICLS024.distributionDate.getFullYear()); //SR 22277 Aliza
			new Ajax.Request(
					contextPath + "/GICLClaimReserveController",
					{
						method : "GET",
						parameters : {
							action : "redistributeReserve",
							claimId : objGICLClaims.claimId,
							perilCd : objCurrGICLItemPeril.dspPerilCd,
							itemNo : objCurrGICLItemPeril.itemNo,
							groupedItemNo : objCurrGICLItemPeril.groupedItemNo,
							//distributionDate : objGICLS024.distributionDate == null ? dateFormat( SR 22277 Aliza replaced by code below
							distDate : objGICLS024.distributionDate == null ? dateFormat(		
									new Date(), 'mm-dd-yyyy')
								//: objGICLS024.distributionDate, //SR 22277 Aliza replaced by code below
								:distDate,
							lossReserve : $F("txtLossReserve") == "" ? "0"
									: unformatCurrency("txtLossReserve"),
							expenseReserve : $F("txtExpenseReserve") == "" ? "0"
									: unformatCurrency("txtExpenseReserve"),
							lineCd : objGICLClaims.lineCd,
							currencyCd : objCurrGICLItemPeril.giclClmResHist.currencyCd,
							convertRate : objCurrGICLItemPeril.giclClmResHist.convertRate,
							lossesPaid : unformatCurrency("txtLossesPaid"),
							expensesPaid : unformatCurrency("txtExpensesPaid")
						},
						asynchronous : false,
						evalScripts : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								changeTag = 0;
								objGICLS024 = {};
								showWaitingMessageBox(response.responseText,(response.responseText == "Distribution was not successful." ? "E": "S"), showClaimReserve);
							}
						}
					});
		} catch (e) {
			showErrorMessage("continueRedistribution", e);
		}
	}
	
	function checkPerilStatusGICLS024() {
		try {
			new Ajax.Request(
					contextPath + "/GICLItemPerilController",
					{
						method : "GET",
						parameters : {
							action : "checkPerilStatus",
							claimId : objCurrGICLItemPeril.claimId,
							perilCd : objCurrGICLItemPeril.dspPerilCd,
							itemNo : objCurrGICLItemPeril.itemNo,
							groupedItemNo : objCurrGICLItemPeril.groupedItemNo
						},
						evalScripts : true,
						asynchronous : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var res = JSON.parse(response.responseText);
								objGICLS024.vars.closeFlag = res.closeFlag;
								objGICLS024.vars.closeFlag2 = res.closeFlag2;
								if (res.closeFlag != "AP") {
									showMessageBox("Record cannot be redistributed. Peril has been closed/withdrawn/denied.");
								} else {
									showConfirmBox(
											"Confirm",
											"Are you sure you want to redistribute?",
											"Yes", "No",
											continueRedistribution, null);
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkPerilStatusGICLS024", e);
		}
	}
	
	function checkUWDistGICLS024() {
		try {
			new Ajax.Request(contextPath + "/GICLClaimReserveController",
			{
				method : "GET",
				parameters : {
					action : "checkUWDist",
					claimId : objGICLClaims.claimId,
					lineCd : objGICLClaims.lineCd,
					sublineCd : objGICLClaims.sublineCd,
					polIssCd : objGICLClaims.polIssCd,
					issueYy : objGICLClaims.issueYy,
					polSeqNo : objGICLClaims.polSeqNo,
					renewNo : objGICLClaims.renewNo,
					polEffDate : objGICLClaims.polEffDate,
					expiryDate : objGICLClaims.expiryDate,
					dspLossDate : objGICLClaims.dspLossDate,
					perilCd : objCurrGICLItemPeril.dspPerilCd,
					itemNo : objCurrGICLItemPeril.itemNo
				},
				evalScripts : true,
				asynchronous : true,
				onComplete : function(response) {
					if (response.responseText == "SUCCESS") {
						checkPerilStatusGICLS024();
					} else {
						showMessageBox(response.responseText,
								"I");
						//checkPerilStatusGICLS024();
					}
				}
			});
		} catch (e) {
			showErrorMessage("checkUWDistGICLS024", e);
		}
	}
	
	//added by: Nica 12.26.2012 - check if claim's policy is distributed before allowing user to set reserve
	function validateExistingDistGICLS024() {
		try {
			new Ajax.Request(contextPath + "/GICLClaimReserveController",{
				method : "GET",
				parameters : {
					action 	: "validateExistingDistGICLS024",
					claimId : objCLMGlobal.claimId,
					lineCd 	: objCLMGlobal.lineCode,
					sublineCd : objCLMGlobal.sublineCd,
					polIssCd  : objCLMGlobal.policyIssueCode,
					issueYy : objCLMGlobal.issueYy,
					polSeqNo: objCLMGlobal.polSeqNo,
					renewNo : objCLMGlobal.renewNo
				},
				evalScripts : true,
				asynchronous : true,
				onComplete : function(response) {
					if(checkErrorOnResponse(response)){
						var resp = JSON.parse(response.responseText);
						if(nvl(resp.message, "") != ""){
							showWaitingMessageBox(unescapeHTML2(resp.message), "E", function(){
								if(resp.callModule == "GICLS010"){
									showClaimBasicInformation();
								}else{
									showClaimListing();
								}
							});							
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});
		} catch (e) {
			showErrorMessage("validateExistingDistGICLS024", e);
		}
	}
	
	function createRequestGICLS024() {
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			method : "POST",
			parameters : {
				action : "createOverrideRequest",
				claimId : objGICLClaims.claimId,
				lineCd : objGICLClaims.lineCd,
				issCd : objGICLClaims.issCd,
				ovrRemarks : $F("txtOverrideRequestRemarks")
			},
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS") {
						showWaitingMessageBox("Override Request was successfully created.", "S", function(){
							$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
							$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
							recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
							overlayOverrideRequest.close();
							delete overlayOverrideRequest;
						});
					}
				}
			}
		});
	}
	
	function saveClaimReserve(){
		try{
			var claimId = objGICLClaims.claimId;
			var itemNo = objCurrGICLItemPeril.itemNo;
			var perilCd = objCurrGICLItemPeril.perilCd;
			var groupedItemNo = objCurrGICLItemPeril.groupedItemNo;
			var lossReserve = $F("txtLossReserve") == "" ? "0" : unformatCurrency("txtLossReserve");
			var expReserve = $F("txtExpenseReserve") == "" ? "0" : unformatCurrency("txtExpenseReserve");
			//var distDate = (orbjGICLS024.distributionDate == null ? dateFormat(new Date(), 'mm-dd-yyyy') : dateFormat((objGICLS024.distributionDate, 'mm-dd-yyyy')));
			var distDate = (objGICLS024.distributionDate == null ? dateFormat(new Date(), 'mm-dd-yyyy') : ("0"+(objGICLS024.distributionDate.getMonth()+1)).slice(-2)+ "-" +("0" + objGICLS024.distributionDate.getDate()).slice(-2)  + "-" +objGICLS024.distributionDate.getFullYear()); //SR 22277 Aliza			
			var histSeqNo =  $F("txtHistoryNumber")!= "" ? $F("txtHistoryNumber") : 0;
			var currencyCd = objCurrGICLItemPeril.giclClmResHist.currencyCd;
			var convertRate = objCurrGICLItemPeril.giclClmResHist.convertRate;
			//changed booking month and year kenneth SR 5163 11.05.2015
			//var bookingMonth = $F("txtBookingMonth") != "" ? $F("txtBookingMonth") : getCurrentMonthWord();
			//var bookingYear = $F("txtBookingYear") != "" ? $F("txtBookingYear") : getCurrentYear();
			var bookingCondition = ($F("txtBookingMonth") == $("txtBookingMonth").getAttribute("pre-text") && $F("txtBookingYear") == $("txtBookingYear").getAttribute("pre-text"));
			var bookingMonth = $F("txtBookingMonth") != "" ? (bookingCondition ? getCurrentMonthWord() : $F("txtBookingMonth")) : getCurrentMonthWord();
			var bookingYear = $F("txtBookingYear") != "" ? (bookingCondition ? getCurrentYear() : $F("txtBookingYear")) : getCurrentYear();
			//alert( ("0"+(objGICLS024.distributionDate.getMonth()+1)).slice(-2)+ "-" +("0" + objGICLS024.distributionDate.getDate()).slice(-2)  + "-" +objGICLS024.distributionDate.getFullYear() );
			//alert(bookingMonth);
			//alert(bookingYear);
			
			var remarks = escapeHTML2($F("txtRemarks"));
			
			new Ajax.Request(contextPath
					+ "/GICLClaimReserveController", {
				method : "POST",
				parameters : {
					action : "saveClaimReserve",
					claimId : claimId,
					itemNo : itemNo,
					perilCd : perilCd,
					groupedItemNo : groupedItemNo,
					histSeqNo : histSeqNo,
					lossReserve : lossReserve,
					expenseReserve : expReserve,
					currencyCd : currencyCd,
					convertRate : convertRate,
					bookingMonth : bookingMonth,
					bookingYear : bookingYear,
					distDate : distDate,
					lineCd : objGICLClaims.lineCd, 
					vRedistSw : objGICLClaims.redistributeSw,
					lossesPaid : unformatCurrency("txtLossesPaid"),
					expensesPaid : unformatCurrency("txtExpensesPaid"),
					remarks : remarks
				},
				onCreate : function() {
					showNotice("Saving, please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						changeTag = 0;
						objGICLS024 = {};
						if(histSeqNo == 0 && response.responseText == "Reserve has now been redistributed."){
							showWaitingMessageBox("Reserve has now been distributed.", "S", showClaimReserve);
						}else{
							showWaitingMessageBox(response.responseText,(response.responseText == "Distribution was not successful." ? "E": "S"), showClaimReserve);
						}
						$("txtBookingMonth").setAttribute("pre-text", "");	//kenneth SR 5163 11.05.2015
						$("txtBookingYear").setAttribute("pre-text", "");	//kenneth SR 5163 11.05.2015
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});
		}catch(e){
			showErrorMessage("saveClaimReserve",e);
		}
	}
	
	function gicls024OverrideExpense(user) {
		try {
			var proceed = false;
			new Ajax.Request(contextPath + "/GICLClaimReserveController", {
				method : "GET",
				parameters : {
					action : "gicls024OverrideExpense",
					user : user,
					lineCd : objGICLClaims.lineCd,
					issCd : objGICLClaims.issCd,
					lossReserve : $F("txtLossReserve") == "" ? "0"
							: unformatCurrency("txtLossReserve")
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						if (response.responseText == ""
								|| response.responseText == null) {
							proceed = true;
						} else {
							showMessageBox(response.responseText);
						}
					}
				}
			});

			return proceed;
		} catch (e) {
			showErrorMessage("gicls024OverrideExpense", e);
		}
	}
	
	function checkLossReserve() {
		try {
			new Ajax.Request(contextPath + "/GICLClaimReserveController", {
				method : "GET",
				parameters : {
					action : "gicls024ChckLossRsrv",
					claimId : objGICLClaims.claimId,
					itemNo : objCurrGICLItemPeril.itemNo,
					perilCd : objCurrGICLItemPeril.dspPerilCd,
					groupedItemNo : objCurrGICLItemPeril.groupedItemNo,
					lineCd : objGICLClaims.lineCd,
					//issCd : objGICLClaims.polIssCd, // andrew - 12.7.2012 - use claim issCd
					issCd : objGICLClaims.issCd,
					lossReserve : unformatCurrencyValue(nvl($F("txtLossReserve"),'0')), //nvl(objCurrGICLItemPeril.giclClaimReserve.lossReserve,0),
					expenseReserve : unformatCurrencyValue(nvl($F("txtExpenseReserve"),'0')),//nvl(objCurrGICLItemPeril.giclClaimReserve.expenseReserve,0),
					convertRate : unformatCurrencyValue(nvl($F("txtConvertRate"),'0'))//nvl(objCurrGICLItemPeril.giclClmResHist.convertRate,0)
				},
				evalScripts : true,
				asynchronous : true,
				onComplete : function(response) {
					var msg = response.responseText;
					if (msg == "SUCCESS" || objGICLS024.overrideOk == "Y"){
						if(objGICLClaims.lossRsrvFlag == "Y"){
							objGICLClaims.lossRsrvFlag = "N";		
							return false;
						}else{
							if (($F("txtExpenseReserve") == "" || unformatCurrency("txtExpenseReserve") == 0)
									&& ($F("txtLossReserve") == "" || unformatCurrency("txtLossReserve") == 0)) {
								showMessageBox("Loss Reserve Amount and Expense Reserve Amount cannot be both zero.","I");
								return false;
							}else if (nvl(objCurrGICLItemPeril.expStat, "OPEN") != "OPEN") {
								showMessageBox("Loss reserve cannot be updated. Peril has been closed/withdrawn/denied.");
								return false;
							}else{
								if (redistributeSw == "Y"){
									checkUWDistGICLS024();
								}else{
									saveClaimReserve();
								}
							}
						} 
					}else if(msg == "1"){
						if(objGICLClaims.lossRsrvFlag == "Y"){
							objGICLClaims.lossRsrvFlag = "N";		
						}
						$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
						$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
						recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
						showMessageBox("VALIDATE_RESERVE_LIMITS not found in giis_parameters", "I");
						return false;
					}else if(msg == "2"){
						if(objGICLClaims.lossRsrvFlag == "Y"){
							objGICLClaims.lossRsrvFlag = "N";		
						}
						showMessageBox("User is not allowed to make a reserve, please refer to the reserve maintenance", "E");
						$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
						$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
						recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
						return false;
					}else if(msg == "3"){
						if(objGICLClaims.lossRsrvFlag == "Y"){
							objGICLClaims.lossRsrvFlag = "N";		
						}
						showConfirmBox4(
							"Confirmation",
							"Reserve amount exceeds the allowable amount for this user. Do you want to override?",
							"Yes",
							"Request Override",
							"No",
							function() {
								showGenericOverride("GICLS024","RO",
										function(ovr, userId, result) {
											if (result == "FALSE") {
												showMessageBox(userId+ " is not allowed to override.",imgMessage.ERROR);
												$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
												$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
												recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
												ovr.close();
												delete ovr;
											} else {
												if (gicls024OverrideExpense($F("txtOverrideUserName"))) {
													recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
													objGICLS024.overrideOk = "Y";
													if(triggerType == 1) checkLossReserve();
													triggerType = 0;
													ovr.close();
													delete ovr;
												}
											}
										}, function() {
											$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
											$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
											recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
											this.close();
										});
							},
							function(){
								if(orCnt == "Y"){
									showConfirmBox(
											"Confirm",
											"Override request already exists, continue?",
											"Yes",
											"Cancel",
											function() {
												showGenericOverrideRequest(
														"GICLS024",
														"RO",
														createRequestGICLS024,
														function(){
															$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
															$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
															recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
															overlayOverrideRequest.close();
														});
														},
											function(){
												$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
												$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
												recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
											});
								}else{
									showGenericOverrideRequest(
										"GICLS024",
										"RO",
										createRequestGICLS024,
										function(){
											$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
											$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
											recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
											overlayOverrideRequest.close();
										});
								}
							},
							function() {
								$("txtLossReserve").value = formatCurrency(objGICLS024.vars.origLossReserve);
								$("txtExpenseReserve").value = formatCurrency(objGICLS024.vars.origExpenseReserve);
								recomputeTotalReserve($F("txtExpenseReserve"), $F("txtLossReserve"), $("txtTotalReserve"),"Y");
								this.close();
							});
					}
				}
			});
		} catch (e) {
			showErrorMessage("checkLossReserve", e);
		}
	}

	$("redistributeBtn").observe("click",
					function() {
						if (objGICLS024.hasPendingRecords) {
							showMessageBox("You have changes in Claim Reserve portion. Press Update button first to apply changes otherwise unselect the Item Information record to clear changes.","I");
							return;
						} else {
							if (($F("txtExpenseReserve") == "" || unformatCurrency("txtExpenseReserve") == 0)
									&& ($F("txtLossReserve") == "" || unformatCurrency("txtLossReserve") == 0)) {
								showMessageBox("Loss Reserve Amount and Expense Reserve Amount cannot be both zero.","I");
							} else {
								objGICLS024.vars.fromRedistBtn = "Y";
								redistributeSw = "Y";
								checkLossReserve();
							}
						}
					});

	function setClmResHistory(obj) {
		$("txtRemarks").value = nvl(obj, null) != null ? unescapeHTML2(obj.remarks): null;
		$("txtConvertRate").value = nvl(obj, null) != null ? formatToNineDecimal(obj.convertRate): null;
		$("txtBookingMonth").value = nvl(obj, null) != null ? unescapeHTML2(obj.bookingMonth): null;
		$("txtBookingYear").value = nvl(obj, null) != null ? obj.bookingYear: null;
		if ($("lblDistType").innerHTML = nvl(obj, null) != null ? unescapeHTML2(obj.nbtDistTypeDesc): null);
		if ($("lblCurrency").innerHTML = nvl(obj, null) != null ? unescapeHTML2(obj.dspCurrencyDesc): null);
		if (JSON.stringify(objCurrGICLItemPeril) != "{}") {
			enableSearch("bookDateLOV");
			$("editRemarks").show();
			enableInputField("txtBookingMonth");
			enableInputField("txtBookingYear");
			enableInputField("txtRemarks");
			$("txtHistoryNumber").value = nvl(obj.histSeqNo, null) != null ? obj.histSeqNo.toPaddedString(3) : null;
		} else {
			$("txtHistoryNumber").value = null;
			disableSearch("bookDateLOV");
			$("editRemarks").hide();
			disableInputField("txtBookingMonth");
			disableInputField("txtBookingYear");
			disableInputField("txtRemarks");
		}
		$("txtBookingMonth").setAttribute("pre-text", $F("txtBookingMonth"));		//kenneth SR 5163 11.05.2015
		$("txtBookingYear").setAttribute("pre-text", $F("txtBookingYear"));		//kenneth SR 5163 11.05.2015
	}
	
	function preCommit() {
		try {
			if (objGICLS024.hasPendingRecords) {
				showMessageBox("You have changes in Claim Reserve portion. Press Update button first to apply changes otherwise unselect the Item Information record to clear changes.","I");
				return false;
			}
			/* if($F("txtBookingMonth") == ""){
				showWaitingMessageBox("Booking Month cannot be null.", "I", function(){
					$("txtBookingMonth").focus();
					return false;
				});
			}
			if($F("txtBookingYear") == ""){
				showWaitingMessageBox("Booking Year cannot be null.", "I", function(){
					$("txtBookingYear").focus();
					return false;
				});
			} */
			if(objGICLS024.claimReserveChanged == "Y"){
				if(  nvl($F("txtHistoryNumber") ,"") != ""){
					showConfirmBox(
							"Information",
							"Saving the changes you have made will negate the previously distributed loss \n"
									+ "and expense reserve. The new loss and expense reserves will become the distributed reserves.\n"
									+ "Do you wish to continue?", "Yes",
							"No", function(){
								checkLossReserve();
							}, function(){objGICLS024.redistSW = 'N';},
							"SaveReserve");
				}else{
					checkLossReserve();
				}
			}else{
				checkLossReserve();
			}
		} catch (e) {
			showErrorMessage("preSave", e);
		}
	}
	
	observeSaveForm("btnSaveReserve", function(){preCommit(); triggerType = 1;});

	objGICLS024.setClmResHistory = setClmResHistory;
	objGICLS024.checkLossReserve = checkLossReserve;
	objGICLS024.preCommit = preCommit;
	objGICLS024.validateExistingDistGICLS024 = validateExistingDistGICLS024; 
	initializeChangeAttribute();
	validateExistingDistGICLS024(); // added by: Nica 12.26.2012
	
	if ('${lineCd}' == "SU") {
		objGICLS024.SU = JSON.parse('${objItemtemPerilSU}');
		objGICLS024.getSUDetails();
		disableMenu("clmItemInformation");
	}
	
</script>