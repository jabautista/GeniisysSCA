<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div id="policyEntryMainDiv" class="sectionDiv" style="text-align: center; width: 99.6%; margin-bottom: 10px;">
	<div class="tableContainer" style="font-size:12px;">
		<div class="tableHeader">
			<label style="width: 45px; margin-left: 13px;">Line</label>
			<label style="width: 70px; margin-left: 10px;">Subline</label>
			<label style="width: 45px; margin-left: 8px;">Iss</label>
			<label style="width: 45px; margin-left: 10px;">Yy</label>
			<label style="width: 85px; margin-left: 5px;">Pol Seq #</label>
			<label style="width: 57px;">Rnew</label>
			<label style="width: 85px; margin-left: 1px;">Ref Pol No</label>
		</div>
	<table border="0" align="left" style="margin-top: 10px;">
		<tr>
			<td>
				<input type="text" id="polLineCd" style="width: 40px; margin-left: 7px;" maxlength="2"  class="upper"/>
				<input type="text" id="polSublineCd" style="width: 60px; margin-left: 3px;" maxlength="7" class="upper"/>
				<input type="text" id="polIssCd" style="width: 40px; margin-left: 3px;" maxlength="2" class="upper"/>
				<input class="rightAligned" type="text" id="polIssYy" style="width: 40px; margin-left: 3px;" maxlength="2" />
				<input class="rightAligned" type="text" id="policySeqNo" style="width: 70px; margin-left: 3px;" maxlength="7" />
				<input class="rightAligned" type="text" id="polRenewNo" style="width: 40px; margin-left: 3px;" maxlength="2" />
				<input type="text" id="polRefPolNo" style="width: 85px; margin-left: 3px; margin-bottom: 5px;" maxlength="30" />
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

<script type="text/javascript">
	var objPolicyDtls = new Object();
	var policyInvoices = new Array();
	makeInputFieldUpperCase();
	initializeAll();
	$("polLineCd").focus();
	
	$("btnPolicyCancel").observe("click", function(){
		objAC.overideCalled = 'N';
		hideOverlay();
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
	
	$("polIssYy").observe("blur", function() {
		if(!isNaN($F("polIssYy")) && $F("polIssYy")!="") {
			$("polIssYy").value = parseInt($F("polIssYy")).toPaddedString(2);	
			getRefPolNo();
		} else {
			$("polIssYy").value = "";
		}
	});
	
	$("policySeqNo").observe("blur", function() {
		if(!isNaN($F("policySeqNo")) && $F("policySeqNo")!="") {
			$("policySeqNo").value = parseInt($F("policySeqNo")).toPaddedString(6);	
			getRefPolNo();
		} else {
			$("policySeqNo").value = "";
		}
	});
	
	$("polRenewNo").observe("blur", function() {
		if(!isNaN($F("polRenewNo")) && $F("polRenewNo")!="") {
			$("polRenewNo").value = parseInt($F("polRenewNo")).toPaddedString(2);
			if(checkIfPackage()){
				if(checkIfBillsSettled()){
					showWaitingMessageBox("Bills for this policy have been settled.", "I", clearValues);
				}else{
					showWaitingMessageBox("This is a package policy. Select from the list of invoices you would want to settle.", "I", function(){
						$("btnPolicyOk").value = "Show Invoices";
					});
				}
			}else{
				var exists = !validateRenewNo() ? true :false;
				if(exists){
					getRefPolNo();
				}
			}
		} else {
			$("polRenewNo").value = "";
		}
	});
	
	function getRefPolNo() {
		try {
			if($F("polLineCd") != "" && $F("polSublineCd") != "" && $F("polIssCd") != "" &&
					$F("polIssYy") != "" && $F("policySeqNo") != "" && $F("polRenewNo") != "") {
				new Ajax.Request(contextPath+"/GIPIPolbasicController", {
					method: "GET",
					parameters: {		
						action: "getRefPolNo",
						lineCd: $F("polLineCd"),
						sublineCd: $F("polSublineCd"),	
						issCd: $F("polIssCd"),
						issueYy: removeLeadingZero($F("polIssYy")),
						polSeqNo: removeLeadingZero($F("policySeqNo")),
						renewNo: removeLeadingZero($F("polRenewNo"))
					},
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							$("polRefPolNo").value = response.responseText;
						}
					}
				});	
			}
		} catch(e) {
			showErrorMessage("getRefPolNo", e);
		}
	}
	
	function clearValues(){
		$("polLineCd").value = null;
		$("polSublineCd").value = null;	
		$("polIssCd").value = null;	
		$("polIssYy").value = null;	
		$("policySeqNo").value = null;	
		$("polRenewNo").value = null;	
		$("polRefPolNo").value = null;	
		$("checkDue").value = null;	 
	}
	
	function validateRenewNo(){
		var ok = true;
		new Ajax.Request(contextPath+"/GICLClaimsController",{
			parameters:{
				action: 	"validateRenewNoGIACS007",
				lineCd			: $F("polLineCd"),
				sublineCd		: $F("polSublineCd"),
				polIssCd		: $F("polIssCd"),
				issueYy			: $F("polIssYy"),
				polSeqNo		: $F("policySeqNo"),
				renewNo		: $F("polRenewNo"),
				refPolNo		: $F("polRefPolNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)) {
					if(response.responseText != 'X'){
						ok = false;
					}else{
						showConfirmBox("Confirmation","This policy has an existing claim. Would you like to continue with the premium collections?", "Yes", "No",
								function(){
								if(objAC.hasCCFunction == "TRUE" || objAC.overideCalled == "Y"){
									getRefPolNo();
								}else if(objAC.overideCalled == "N"){
									showConfirmBox("Premium Collections", "User is not allowed to process policy that has an existing claim. Would you like to override?", "Yes", "No", 
											function () {
													showGenericOverride("GIACS007","CC",
															function(ovr, userId, result) {
																if (result == "FALSE") {
																	showMessageBox(userId+ " is not allowed to override.",imgMessage.ERROR);
																	$("polRenewNo").focus();
																} else {
																	ovr.close();
																	delete ovr;
																	objAC.overideCalled = "Y";
																	getRefPolNo();
																}
															}, function() {
																this.close();
															});
											}, function () {
												clearValues();
												$("polLineCd").focus();
											});
								}
						}, 	clearValues);
					}
				}
			}
		});	
		return ok;
	}
	
	function getIncTagForAdvPremPayts(issCd, premSeqNo){
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController", {
				method: "GET",
				parameters: {
					action: "getIncTagForAdvPremPayts",
					tranId: objACGlobal.gaccTranId,
					premSeqNo: premSeqNo,
					issCd: issCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						objAC.currentRecord.incTag = nvl(response.responseText, "N") == "Y" ? "Y" : "N";
					}
				}
			});
		} catch(e) {
			showErrorMessage("getIncTagForAdvPremPayts", e);
		}
	}
	
	function computeTotalAmounts(){
		var totalCollAmt = 0;
		var totalPremAmt = 0;
		var totalTaxAmt = 0;
		for(var i = 0; i < objAC.objGdpc.length; i++){
			if(objAC.objGdpc[i].recordStatus != -1){
				totalCollAmt += parseFloat(objAC.objGdpc[i].collAmt);
				totalPremAmt += parseFloat(objAC.objGdpc[i].premAmt);
				totalTaxAmt += parseFloat(objAC.objGdpc[i].taxAmt);
			}
		}
		$("txtTotalCollAmt").value = formatCurrency(totalCollAmt);
		$("txtTotalPremAmt").value = formatCurrency(totalPremAmt);
		$("txtTotalTaxAmt").value = formatCurrency(totalTaxAmt);
	}
	
	function addRecordsInPaidList(newRecordsList) {
		changeTag = 0;
		var objArray = eval('[]');
		for (var index1=0; index1<newRecordsList.length; index1++) {
			
			var newPremCollnRowId = objACGlobal.gaccTranId + 
						newRecordsList[index1].issCd + newRecordsList[index1].premSeqNo +
						newRecordsList[index1].instNo + newRecordsList[index1].tranType;
			
			objAC.currentRecord.incTag = "N";
			getIncTagForAdvPremPayts(newRecordsList[index1].issCd, newRecordsList[index1].premSeqNo);
			var rowObj = new Object();
			rowObj = newRecordsList[index1];
			rowObj.gaccTranId = objACGlobal.gaccTranId;
			
			if (getObjectFromArrayOfObjects(objAC.objGdpc, 
							    "gaccTranId issCd premSeqNo instNo tranType",
			    				newPremCollnRowId)==null) {
				rowObj.recordStatus = 0;
				rowObj.maxCollAmt = newRecordsList[index1].collAmt;
				rowObj.balanceAmtDue = 0;
				objAC.objGdpc.push(rowObj);
				gdpcTableGrid.addBottomRow(rowObj);
			} else {
				var jsonReplacementRecord = getObjectFromArrayOfObjects(objAC.objGdpc, "gaccTranId issCd premSeqNo instNo tranType",
								newPremCollnRowId);
				rowObj.recordStatus = 2;
				gdpcTableGrid.updateRowAt(rowObj, jsonReplacementRecord.index-1);
			}
		}
		objAC.overideCalled = 'N';
		objAC.formChanged = 'Y';
		changeTag = 1;
		computeTotalAmounts();
		gdpcTableGrid.onRemoveRowFocus();
	}
	
	function getTaxType(taxType, recordValidated){
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
				method: "GET",
				parameters: {
					tranId: 		objACGlobal.gaccTranId,	
					tranType: 		taxType,
					tranSource: 	$F("tranSource") == "" ? recordValidated.issCd : $F("tranSource"),
					premSeqNo: 		recordValidated.premSeqNo ? recordValidated.premSeqNo : $F("billCmNo"),
					instNo: 		recordValidated.instNo 	 ? recordValidated.instNo 	: $F("instNo"),
					fundCd: 		objACGlobal.fundCd,
					taxAmt: 		unformatCurrencyValue(recordValidated.taxAmt),
					paramPremAmt: 	unformatCurrencyValue(recordValidated.origPremAmt),
					premAmt: 		unformatCurrencyValue(recordValidated.origPremAmt),
					collnAmt: 		unformatCurrencyValue(recordValidated.premCollectionAmt),
					premVatExempt:  unformatCurrencyValue(nvl(recordValidated.premVatExempt,'0')),
					revTranId:	    recordValidated.revGaccTranId,			
					taxType: 		taxType
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						objAC.jsonTaxCollnsNew = JSON.parse(result.giacTaxCollnCur);
						var createTaxSet = true;
						for(var h=0; h<objAC.jsonTaxCollnsNewRecordsList.length; h++) {
							var tempArr = objAC.jsonTaxCollnsNewRecordsList[h];
							for(var i=0; i<objAC.jsonTaxCollnsNew.length; i++) {
								var exists = false;
								for(var j=0; j<tempArr.length; j++) {
									if(tempArr[j].instNo == objAC.jsonTaxCollnsNew[i].instNo &&
											tempArr[j].b160TaxCd == objAC.jsonTaxCollnsNew[i].b160TaxCd &&
											tempArr[j].b160IssCd == objAC.jsonTaxCollnsNew[i].b160IssCd &&
											tempArr[j].transactionType == objAC.jsonTaxCollnsNew[i].transactionType &&
											tempArr[j].b160PremSeqNo == objAC.jsonTaxCollnsNew[i].b160PremSeqNo) {
										exists = true;
										break;
									}
								}
								if(exists) {
									createTaxSet = false;
									break;
								}
							}
						}
						var rIndex = 0;
						if(createTaxSet) {
							if (objAC.jsonTaxCollnsNewRecordsList.length > 0) {
								rIndex = objAC.jsonTaxCollnsNewRecordsList.length - 1;
							}
							objAC.jsonTaxCollnsNewRecordsList.splice(rIndex, 0, objAC.jsonTaxCollnsNew);
						}
						objAC.sumGtaxAmt = result.taxAmt;
						recordValidated.collAmt = result.collnAmt;
						recordValidated.premAmt = result.premAmt;
						recordValidated.taxAmt = result.taxAmt;
						recordValidated.premVatExempt = result.premVatExempt;
						
						if(recordValidated.premZeroRated == 0) {
							if((unformatCurrencyValue(recordValidated.premAmt) - unformatCurrencyValue(recordValidated.premVatExempt)) == 0) {
								recordValidated.premVatable = 0;
							} else if((unformatCurrencyValue(recordValidated.premAmt) - unformatCurrencyValue(recordValidated.premVatExempt)) > 0) {
								recordValidated.premVatable = unformatCurrencyValue(recordValidated.premAmt) - unformatCurrencyValue(recordValidated.premVatExempt);
							}
						} else {
							recordValidated.premZeroRated = unformatCurrencyValue(recordValidated.premAmt);
							recordValidated.premVatable = 0;
							recordValidated.premVatExempt = 0;
						}
						
					}
				}
			});
		} catch(e) {
			 showMessageBox(e.message);
		}
	}
	
	function withTaxAllocation2(taxType, recordValidated) {
			if (objAC.taxPriorityFlag == null) { 
				showMessageBox(
						"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
						imgMessage.WARNING);
				return;
			}

			if (objAC.taxPriorityFlag == 'P') {
				/*
				 ** Premium amount has higher priority than tax amount
				 */
				if (unformatCurrencyValue(recordValidated.premCollectionAmt) == parseFloat(recordValidated.origCollAmt)) {
					recordValidated.directPremAmt = recordValidated.origPremAmt;
					//$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt); //$F("origPremAmt");
					recordValidated.taxAmt = recordValidated.origTaxAmt;
				} else if (Math.abs(unformatCurrencyValue(recordValidated.origCollAmt)) <= Math
						.abs(unformatCurrencyValue(recordValidated.origPremAmt))) {
					recordValidated.directPremAmt = recordValidated.premCollectionAmt;
					recordValidated.taxAmt = formatCurrency(0);
				} else {
					recordValidated.directPremAmt = formatCurrency(recordValidated.origPremAmt);
					recordValidated.taxAmt = formatCurrency(unformatCurrencyValue(recordValidated.premCollectionAmt)
							- parseFloat(recordValidated.origPremAmt
									.replace(/,/g, "")));
				}
			} else {
				/*
				 ** Tax amount has higher priority than premium amount
				 */
				if (Math.abs(unformatCurrencyValue(recordValidated.premCollectionAmt)) == Math
						.abs(parseFloat(recordValidated.origCollAmt))) {
					recordValidated.directPremAmt = (recordValidated.origPremAmt);
					recordValidated.taxAmt = recordValidated.origTaxAmt;
					
				} else if (Math.abs(unformatCurrencyValue(recordValidated.premCollectionAmt)) <= Math
						.abs(parseFloat(unformatCurrencyValue(recordValidated.origTaxAmt)))) {
					recordValidated.directPremAmt = formatCurrency(0);
					recordValidated.taxAmt = recordValidated.premCollectionAmt;
				} else {
					recordValidated.directPremAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
							- parseFloat(unformatCurrencyValue(recordValidated.origTaxAmt));
					recordValidated.taxAmt = formatCurrency(unformatCurrencyValue(""+recordValidated.origTaxAmt));
				}
			}
			if (objAC.currentRecord.otherInfo) {
				recordValidated.forCurrAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
						/ parseFloat(recordValidated.currRt);
			} else {
				recordValidated.forCurrAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
						/ parseFloat(recordValidated.currRt);
			}
			// Call procedure for the tax breakdown 
			if (Math.abs(unformatCurrencyValue(recordValidated.taxAmt)) == 0) {
				recordValidated.directPremAmt = recordValidated.premCollectionAmt;
				recordValidated.taxAmt = formatCurrency(0);
				
				if(recordValidated.premZeroRated == 0) {
					recordValidated.premVatExempt = unformatCurrencyValue(recordValidated.origPremAmt);
				} else {
					recordValidated.premZeroRated = unformatCurrencyValue(recordValidated.origPremAmt);
				}
			} else {
				recordValidated.prevPremAmt = unformatCurrencyValue(recordValidated.origPremAmt); //gagamitin to sa saving :)
				getTaxType(taxType, recordValidated);
			}
			policyInvoices.push(recordValidated);
			addRecordsInPaidList(policyInvoices);
			hideOverlay();
	}


	function noTaxAllocation2(taxType, recordValidated) {

		/* Recompute premium amount and tax amount based on the collection amount entered */
		if (objAC.preChangedFlag == 'Y') {
			if (objAC.taxPriorityFlag == null) {
				showMessageBox(
						"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
						imgMessage.WARNING);
			}
			if (objAC.taxPriorityFlag == 'P') {
				/*
				 ** Premium amount has higher priority than tax amount
				 */
				if (unformatCurrencyValue(recordValidated.premCollectionAmt) == recordValidated.origCollAmt) {
					recordValidated.directPremAmt = recordValidated.origPremAmt;
					recordValidated.taxAmt = recordValidated.origTaxAmt;
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
						.abs(objAC.currentRecord.origPremAmt)) {
					recordValidated.directPremAmt = recordValidated.premCollectionAmt;
					recordValidated.taxAmt = formatCurrency(0);
				} else {
					recordValidated.directPremAmt = recordValidated.origPremAmt;
					recordValidated.taxAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
							- objAC.currentRecord.origPremAmt;
				}
			} else {
				/*
				 ** Tax amount has higher priority than premium amount
				 */
				if (unformatCurrencyValue(recordValidated.premCollectionAmt) == recordValidated.origCollAmt) {
					recordValidated.directPremAmt = unformatCurrencyValue(recordValidated.origPremAmt);
					recordValidated.taxAmt = recordValidated.origTaxAmt;
				} else if (Math.abs(unformatCurrencyValue(recordValidated.premCollectionAmt)) <= Math.abs(recordValidated.origTaxAmt)) {
					recordValidated.directPremAmt = formatCurrency(0);
					recordValidated.taxAmt = recordValidated.premCollectionAmt;
				} else {
					recordValidated.directPremAmt = unformatCurrencyValue(recordValidated.premCollectionAmt)
							- recordValidated.origTaxAmt;
					recordValidated.taxAmt = recordValidated.origTaxAmt;
				}
			}

			recordValidated.forCurrAmt = unformatCurrencyValue(recordValidated.premCollectionAmt) / parseFloat(recordValidated.currRt);
		}

		policyInvoices.push(recordValidated);
		addRecordsInPaidList(policyInvoices);
		hideOverlay();
	}
	
	function validateBillNo(premSeqNo, issCd) {
		try{
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateBillNo2", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						premSeqNo: premSeqNo,
						issCd :         issCd
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							if(result.msgAlert != 'Ok'){
								showMessageBox(result.msgAlert, "E");
							}else{
								objPolicyDtls.policyNo = result.policyNo;
								objPolicyDtls.policyId = result.policyId;
								objPolicyDtls.lineCd = result.lineCd;
								objPolicyDtls.sublineCd = result.sublineCd;
								objPolicyDtls.issCd = result.issCd;
								objPolicyDtls.issueYear = result.issueYear;
								objPolicyDtls.polSeqNo = result.polSeqNo;
								objPolicyDtls.endtType = result.endtType;
								objPolicyDtls.assdNo = result.assdNo;
								objPolicyDtls.assdName = result.assdName;
								
								objPolicyDtls.premCollectionAmt	 = formatCurrency(objPolicyDtls.collAmt);
								objPolicyDtls.origCollAmt			 = formatCurrency(objPolicyDtls.collAmt);
								objPolicyDtls.origPremAmt			 = formatCurrency(objPolicyDtls.premAmt);
								objPolicyDtls.origTaxAmt			 = formatCurrency(objPolicyDtls.taxAmt);
								
								if (objAC.taxAllocationFlag == "Y"){
									withTaxAllocation2(($F("tranType")=="" ? objPolicyDtls.tranType : $F("tranType")), 
											objPolicyDtls);
								} else {
									noTaxAllocation2(($F("tranType")=="" ? objPolicyDtls.tranType : $F("tranType")), 
											objPolicyDtls);
								}
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("validateBillNo", e);
		}
	}
	
	function continueFunc(row){
		/* var selectedPol = row.tranType + row.issCd + row.premSeqNo + row.instNo; 
		if (getObjectFromArrayOfObjects(objAC.objGdpc, "tranType issCd premSeqNo instNo", selectedPol)) {
			
		} */

		if (parseFloat(row.balAmtDue) > 0){
			objPolicyDtls.tranType = '1';
		}else{
			objPolicyDtls.tranType = '3';
		}
		objPolicyDtls.gaccTranId = objACGlobal.gaccTranId;
		objPolicyDtls.issCd = row.issCd;
		objPolicyDtls.premSeqNo = row.premSeqNo;
		objPolicyDtls.instNo = row.instNo;
		objPolicyDtls.collAmt = row.balAmtDue;
		objPolicyDtls.premAmt = row.premBalDue;
		objPolicyDtls.taxAmt = row.taxBalDue;
		objPolicyDtls.maxCollAmt = nvl(objPolicyDtls.collAmt,0);
		objPolicyDtls.maxPremAmt = nvl(objPolicyDtls.premAmt,0);
		objPolicyDtls.maxTaxAmt = nvl(objPolicyDtls.taxAmt,0);
		objPolicyDtls.commission = 0;
		objPolicyDtls.wholdingTax = 0;
		objPolicyDtls.currCd = row.currencyCd;
		objPolicyDtls.currRt = row.convertRate;
		objPolicyDtls.convRate = row.convertRate;
		objPolicyDtls.currDesc = row.currencyDesc; 
		validateBillNo(row.premSeqNo, row.issCd);
	}
	
	function validatePolEntries(){
		var isValid = true;
		if ($F("polLineCd").empty() || $F("polSublineCd").empty() || $F("polIssCd").empty() || $F("polIssYy").empty() || $F("policySeqNo").empty() || $F("polRenewNo").empty()){    
			showMessageBox("Please enter a valid policy no.", imgMessage.ERROR);
			isValid = false;
		}else{
			try{
				new Ajax.Request(contextPath+"/GIACAgingSoaDetailController?action=getPolicyDtlsGIACS007", {
						evalScripts: true,
						asynchronous: false,
						method: "GET",
						parameters: {
							lineCd			: $F("polLineCd"),
							sublineCd		: $F("polSublineCd"),
							issCd				: $F("polIssCd"),
							issueYy			: $F("polIssYy"),
							polSeqNo		: $F("policySeqNo"),
							renewNo		: $F("polRenewNo"),
							refPolNo		: $F("polRefPolNo"),
							nbtDue			:  $("checkDue").checked == true ? 'Y' : 'N' 
						},
						onComplete: function(response) {
							if (checkErrorOnResponse(response)) {
								var result = response.responseText.toQueryParams();
								if (result.premSeqNo == ""){
									showMessageBox("Bills for this policy have been settled.", "I");
									return false;
								}
								if(result.msgAlert == "Premium payment for Special Policy is not allowed."){
									showMessageBox(result.msgAlert, "I");
									return false;
								}else if(result.msgAlert == "This is a Special Policy."){
									showWaitingMessageBox(result.msgAlert, "I", 
											function(){
												continueFunc(result);
											});
								}else{
									continueFunc(result);
								}
							} else {
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}
					});
			}catch(e) {
				showErrorMessage("postQueryGIEXS004", e);
			}
		}
	}
	
	function checkIfPackage(){
		var exist = false;
		try{
			new Ajax.Request(contextPath+"/GIPIPackPolbasicController?action=checkIfPackGIACS007", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						lineCd			: $F("polLineCd"),
						sublineCd		: $F("polSublineCd"),
						issCd				: $F("polIssCd"),
						issueYy			: $F("polIssYy"),
						polSeqNo		: $F("policySeqNo"),
						renewNo		: $F("polRenewNo")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result= response.responseText;
							if (result == "X"){
								exist = true;
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			return exist;
		}catch(e) {
			showErrorMessage("checkIfPackage", e);
		}
	}
	
	function checkIfBillsSettled(){
		var exist = false;
		try{
			new Ajax.Request(contextPath+"/GIPIPackPolbasicController?action=checkIfBillsSettledGIACS007", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						nbtDue			: $("checkDue").checked == true ? 'Y' : 'N' ,
						lineCd			: $F("polLineCd"),
						sublineCd		: $F("polSublineCd"),
						issCd				: $F("polIssCd"),
						issueYy			: $F("polIssYy"),
						polSeqNo		: $F("policySeqNo"),
						renewNo		: $F("polRenewNo")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText;
							if (result == "true"){
								exist = true;
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			return exist;
		}catch(e) {
			showErrorMessage("checkIfPackage", e);
		}
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
				checkDue: $("checkDue").checked == true ? 'Y' : 'N' 
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response){
				objAC.invoicesOfPolicy = eval(response.responseText);
				if (objAC.invoicesOfPolicy) {
					hideOverlay();
					Modalbox.show(contextPath+"/GIACDirectPremCollnsController?action=showInvoicesOfPolicy", 
							  {title: "Invoice", 
							  width: 590,
							  height: 330,
							  asynchronous: false});
				}else {
					showMessageBox("Policy does not exist.", imgMessage.INFO);
				}
			}	
		});
	}
	
	$("btnPolicyOk").observe("click", function(){
		if($F("btnPolicyOk") == "Ok"){
			validatePolEntries();
		}else{
			getPolicyEntryDetails();
		}
	});
	
	//added cancelOtherOR by robert 10302013 
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){ // andrew - 08.14.2012
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