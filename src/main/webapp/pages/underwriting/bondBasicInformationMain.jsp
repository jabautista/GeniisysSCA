<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<!-- added by Jerome Orio 11.24.2010 -->
<script type="text/javascript">
	objUW.hidObjGIPIS017 = {};
	objUW.hidObjGIPIS017.ora2010Sw			= ('${ora2010Sw}');
	if (objUW.hidObjGIPIS017.ora2010Sw == "Y"){
	objUW.hidObjGIPIS017.companyLOV			= JSON.parse('${companyListingJSON}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIPIS017.employeeLOV		= JSON.parse('${employeeListingJSON}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIPIS017.bancTypeCdLOV		= JSON.parse('${bancTypeCdListingJSON}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIPIS017.bancAreaCdLOV		= JSON.parse('${bancAreaCdListingJSON}'.replace(/\\/g, '\\\\'));	
	objUW.hidObjGIPIS017.bancBranchCdLOV	= JSON.parse('${bancBranchCdListingJSON}'.replace(/\\/g, '\\\\'));	
	objUW.hidObjGIPIS017.managerCd			= ('${gipiWPolbas.managerCd}');
	}
	objUW.hidObjGIPIS017.forSaving			= false;
	objUW.hidObjGIPIS017.overrideTakeupTerm = ('${overrideTakeupTerm}');
	/*commented by: Nica 03.21.2014 - not in used and only cause error when mortgagees have special characters
	objUW.hidObjGIPIS017.mortgageeListingJSON	= JSON.parse('${mortgageeListingJSON}'.replace(/\\/g, '\\\\'));*/
	objUW.hidObjGIPIS017.isExistGipiWPolbas = ('${isExistGipiWPolbas}');
	objUW.hidObjGIPIS017.reqRefPolNo = ('${reqRefPolNo}');
	objUW.hidObjGIPIS017.reqRefNo = ('${reqRefNo}'); //added by gab 10.10.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
	objUW.hidObjGIPIS017.bookingAdv	 = ('${bookingAdv}');
	objUW.hidObjGIPIS017.updateBooking = ('${updateBooking}');
	objUW.hidObjGIPIS017.allowIssueExpiredBond = ('${allowIssueExpiredBond}');
	
	objUW.hidObjGIPIS017.dispDefaultCredBranch = ('${dispDefaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	objUW.hidObjGIPIS017.defaultCredBranch = ('${defaultCredBranch}'); // Kris 07.04.2013 for UW-SPECS-2013-091
	
</script>
<div id="bondBasicInformationMainDiv" style=" margin-top: 1px; display:block;" changeTagAttr="true">
	<div id="message" style="display:none;">${message}</div>
	<form id="bondBasicInformationForm" name="bondBasicInformationForm">
		<input type="hidden" name="parId" 	id="parId" 		value="<c:if test="${not empty gipiParList}">${gipiParList.parId}</c:if>" />
		<input type="hidden" name="lineCd" 	id="lineCd" 	value="<c:if test="${not empty gipiParList}">${gipiParList.lineCd}</c:if>" />
		<input type="hidden" name="issCd" 	id="issCd" 		value="<c:if test="${not empty gipiParList}">${gipiParList.issCd}</c:if>" />
		<input type="hidden" name="designation" 	id="designation" 	value="${gipiWPolbas.designation}" />
		<input type="hidden" name="packPolFlag" 	id="packPolFlag" 	value="${gipiWPolbas.packPolFlag}" />
		<input type="hidden" name="endtYy" 			id="endtYy" 		value="${gipiWPolbas.endtYy}" />
		<input type="hidden" name="credBranch" 		id="credBranch" 		value="${gipiWPolbas.credBranch}" />
		<input type="hidden" name="endtSeqNo" 		id="endtSeqNo" 		value="${gipiWPolbas.endtSeqNo}" />
		<input type="hidden" name="foreignAccSw" 	id="foreignAccSw" 	value="<c:if test="${empty gipiWPolbas.foreignAccSw}">Y</c:if>${gipiWPolbas.foreignAccSw}" />
		<input type="hidden" name="invoiceSw" 		id="invoiceSw" 		value="<c:if test="${empty gipiWPolbas.invoiceSw}">N</c:if>${gipiWPolbas.invoiceSw}" />
		<input type="hidden" name="quotationPrintedSw" 		id="quotationPrintedSw" 		value="<c:if test="${empty gipiWPolbas.quotationPrintedSw}">N</c:if>${gipiWPolbas.quotationPrintedSw}" />		
		<input type="hidden" name="covernotePrintedSw" 		id="covernotePrintedSw" 		value="<c:if test="${empty gipiWPolbas.covernotePrintedSw}">N</c:if>${gipiWPolbas.covernotePrintedSw}" />
		<input type="hidden" name="provPremTag" 	id="provPremTag" 	value="<c:if test="${empty gipiWPolbas.provPremTag}">N</c:if>${gipiWPolbas.provPremTag}" />
		<input type="hidden" name="coInsuranceSw" 	id="coInsuranceSw" 	value="<c:if test="${empty gipiWPolbas.coInsuranceSw}">1</c:if>${gipiWPolbas.coInsuranceSw}" />
		<input type="hidden" name="updateIssueDate" id="updateIssueDate" value="N" />
		<input type="hidden" name="issueYy" id="issueYy" value="${gipiWPolbas.issueYy }" />
		<input type="hidden" name="deleteWPolnrep" 	id="deleteWPolnrep" value="N" />
		<input type="hidden" name="deleteBillSw" 	id="deleteBillSw" 	value="N" />
		<input type="hidden" name="deleteSw" 		id="deleteSw" 		value="N" />
		<input type="hidden" name="deleteWorkingDistSw" 		id="deleteWorkingDistSw" 		value="N" />
		<input type="hidden" name="gipiWInvoiceExist" 		id="gipiWInvoiceExist" 			value="${isExistGipiWInvoice }" />
		<input type="hidden" name="varVdate" 		id="varVdate" 		value="<c:if test="${empty varVdate}">0</c:if>${varVdate }" />
		<input type="hidden" name="validatedBookingDate" 	id="validatedBookingDate" value="N" />
		<input type="hidden" name="validateAssdName" 	id="validateAssdName" value="N" />
		<input type="hidden" name="validateIfOldBondExist" 	id="validateIfOldBondExist" value="N" />
		<input type="hidden" name="updCredBranch" id="updCredBranch" value="${updCredBranch }" />
		<input type="hidden" name="reqCredBranch" id="reqCredBranch" value="${reqCredBranch }" />
		<jsp:include page="subPages/bondBasicInformation.jsp"></jsp:include>
	</form> 
	
	<div id="bondBasicInfoDiv" name="bondBasicInfoDiv" style="display: none;">
	</div>
	
	<form id="bondBasicInformationFormButton" name="bondBasicInformationFormButton">
	<div class="buttonsDiv" style="float:left; width:100%;">
		<table align="center">
			<tr>
				<td>
					<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 60px;" /></td>
				<td>
					<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 60px;" /></td>
			</tr>
		</table>
	</div>
	</form>
</div>	

<script type="text/JavaScript">
	setModuleId("GIPIS017");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	if(nvl(objUW.hidObjGIPIS017.updateBooking, "Y") == "N"){
		$("bookingMonth").disable(); // added bY: Nica 05.10.2012 - Per Ms VJ, booking month LOV should be disabled if UPDATE_BOOKING is equal to N.
	}
	
	// shan 10.13.2014
	objUW.hidObjGIPIS017.valPeriodUnit = $F("validateTag");
	objUW.hidObjGIPIS017.valPeriod = $F("noOfDays");
	//end 10.13.2014
	
	function prepareParametersGIPIS017(){
		var params = "&ora2010Sw="+objUW.hidObjGIPIS017.ora2010Sw;
		params = params+"&managerCd="+objUW.hidObjGIPIS017.managerCd;
		params += "&deleteCommInvoice=" + objUW.hidObjGIPIS017.deleteCommInvoice;
		
		if($("creditingBranch").disabled){
			params = params+"&creditingBranch="+$F("creditingBranch");
		}
		
		return params;	
	}
	
	/* Apollo Cruz 11.03.2014 - Added confirmation box for bancassurance */
	function saveFuncMain(){
		function save(){
			new Ajax.Request(contextPath+'/GIPIParBondInformationController?action=saveBondBasicInfo', {
				method: "POST",
				postBody: Form.serialize("bondBasicInformationForm")+prepareParametersGIPIS017(), 
				asynchronous: false,
				evalScripts: true,
				onCreate: function () {
					$("bondBasicInformationForm").disable();
					disableButton("btnCancel");
					disableButton("btnSave");
					showNotice("Saving, please wait...");
				},
				onComplete: function (response)	{
					var result = response.responseText.evalJSON();
					hideNotice("");
					if (checkErrorOnResponse(response)){
						if (result.message == "SUCCESS"){
							changeTag = 0;
							updateBondBasicInfoParameters();
							$("globalSublineCd").value = $("sublineCd").value;
							showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
							showBondBasicInfo();
						}
					}else{
						showMessageBox(result.message, imgMessage.ERROR);
					}
				}
			});
		}
		if(validateBeforeSave()){
			if(objUW.hidObjGIPIS017.ora2010Sw == "Y" && $("bancaTag").checked != ($("bancaTag").getAttribute("originalValue") == "Y" ? true : false) && $F("globalParStatus") > 5
					&& ($F("globalSublineCd") == $F("sublineCd"))){
				showConfirmBox("Message", "Commission Invoice will be deleted because Bancassurance Type was changed. Do you want to continue?", "Yes", "No",
						function(){
							objUW.hidObjGIPIS017.deleteCommInvoice = "Y";
							save();
					  	});	
			} else {
				save();
			}
		}
		objUW.hidObjGIPIS017.forSaving = false;
	}

	/*Apollo Cruz 11.03.2014 - Deprecated*/
	function saveFuncMain_(){
		if(validateBeforeSave()){
			new Ajax.Request(contextPath+'/GIPIParBondInformationController?action=saveBondBasicInfo', {
				method: "POST",
				postBody: Form.serialize("bondBasicInformationForm")+prepareParametersGIPIS017(), 
				asynchronous: false, //true, para disabled na talaga pag save amf. nok lol
				evalScripts: true,
				onCreate: function () {
					$("bondBasicInformationForm").disable();
					disableButton("btnCancel");
					disableButton("btnSave");
					showNotice("Saving, please wait...");
				},
				onComplete: function (response)	{
					var result = response.responseText.evalJSON();
					hideNotice("");
					if (checkErrorOnResponse(response)){
						if (result.message == "SUCCESS"){
							changeTag = 0;
							updateBondBasicInfoParameters();
							$("globalSublineCd").value = $("sublineCd").value;
							showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
							showBondBasicInfo();
						}
					}else{
						showMessageBox(result.message, imgMessage.ERROR);
					}
					/* $("bondBasicInformationForm").enable();
					enableButton("btnCancel");
					enableButton("btnSave");
					
					initBondBasic();	
					if (objUW.hidObjGIPIS017.ora2010Sw == "Y"){
						$("bankRefNo").value = result.bankRefNo;
						if ($F("bankRefNo") != ""){
							generateBankRefNo($F("bankRefNo"));
							$("swBankRefNo").value = "Y";
						}
						if (!$("bancaTag").checked){
							$("selBancTypeCd").clear();
							$("selAreaCd").clear();
							$("selBranchCd").clear();
							objUW.hidObjGIPIS017.managerCd = "";
							$("dspManagerCd").clear();
							$("dspManagerName").value = "No managers for the given values.";
						}	
					}	 */
				}
			});	 
		}
		objUW.hidObjGIPIS017.forSaving = false;
		//showBondBasicInfo();
	}	

	observeReloadForm("reloadForm", showBondBasicInfo);
	observeCancelForm("btnCancel", saveFuncMain, goBackToParListing);
	
	$("btnSave").observe("focus", function (){
		objUW.hidObjGIPIS017.forSaving = true;
	});
	
	$("btnSave").observe("click", function (){
		//moved changeTag validation by gab 10.10.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
		//if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); objUW.hidObjGIPIS017.forSaving = false; return;}
		saveFuncMain();
	});

	function validateBeforeSave() {
		var result = true;
		var today = new Date();
		var eff = makeDate($F("issueDate"));
		var incept = makeDate($F("doi"));
		var exp = makeDate($F("doe"));
		
		if ($F("parNo")==""){
			result = false;
			customShowMessageBox("PAR No. is required.", imgMessage.ERROR, "parNo");
			return false;
		} else if ($F('sublineCd')==''){
			result = false;
			customShowMessageBox("Bond type is required.", imgMessage.ERROR, "sublineCd");
			return false;
		//} else if ($F('policyStatus')==''){
		//	result = false;
		//	$('policyStatus').focus();
		//	showMessageBox("Bond Status is required.", imgMessage.ERROR);	
		} else if ($F("issueDate")=="") {
			result = false;
			customShowMessageBox("Issue date is required.", imgMessage.ERROR, "issueDate");
			return false;
		} else if ($F("assuredName")==""){
			result = false;
			customShowMessageBox("Principal is required.", imgMessage.ERROR, "assuredName");
			return false;
		} else if ($F("doi")=="") {
			result = false;
			customShowMessageBox("Inception date is required.", imgMessage.ERROR, "doi");
			return false;
		} else if ($F("doe")=="") {
			result = false;
			customShowMessageBox("Expiry date is required.", imgMessage.ERROR, "doe");
			return false;
		} else if ($F("manualRenewNo") == ""){
			result = false; 
			customShowMessageBox("Manual renew no. is required.", imgMessage.ERROR, "manualRenewNo");
			return false;
		} else if ($("selBondSeqNo").value == "" && $("selBondSeqNo").getStyle("display") != "none"){
			result = false;
			customShowMessageBox("Bond Sequence No. is required.", imgMessage.ERROR, "selBondSeqNo");
		} else if ($F("bookingMonth") =="") {
			result = false; 
			customShowMessageBox("Booking date is required.", imgMessage.ERROR, "bookingMonth");
			return false;
		} else if ($F("takeupTermType") =="") {
			result = false;
			customShowMessageBox("Take-up term cannot be null.", imgMessage.ERROR, "takeupTermType");
			$("takeupTermType").value = $("paramTakeupTermType").value; 	
			return false;
		} else if (($F("policyStatus") == 2) || ($F("policyStatus") == 3)) {
			if ($("oldPolicyId").value == "") {
				result = false;
				showMessageBox("Please complete the Old Bond No.", imgMessage.ERROR);
				return false;
			}else if ($("samePolnoSw").checked){
				if ($F("issCd").toUpperCase() != $F("wpolnrepIssCd").toUpperCase()){
					customShowMessageBox("Issuing source code must be the same with the policy to be renewed if the 'Same Bond No.' option will be used.", imgMessage.ERROR , "wpolnrepIssCd");
					$("samePolnoSw").checked = false;
					result = false;
					return false;
				}
			}else if (($("wpolnrepIssueYy").value == "") || ($("wpolnrepPolSeqNo").value == "") || ($("wpolnrepIssCd").value == "") || ($("wpolnrepRenewNo").value == "") || ($("wpolnrepSublineCd").value == "")) {
				result = false;
				showMessageBox("Please complete the Old Bond No.", imgMessage.ERROR);
				return false;
			}else if (($("wpolnrepIssueYy").value != "") || ($("wpolnrepPolSeqNo").value != "") || ($("wpolnrepIssCd").value != "") || ($("wpolnrepRenewNo").value != "") || ($("wpolnrepSublineCd").value != "")) {
				if ($("validateIfOldBondExist").value == "Y"){
					if (!checkOldBondNoExist(true)){
						result = false;
						return false;
					}		
				}	
			}
		} else if ($F("referencePolicyNo") == "") {
			if (objUW.hidObjGIPIS017.reqRefPolNo == "Y") {
				result = false;
				customShowMessageBox("Reference Bond No. is required.",
						imgMessage.ERROR, "referencePolicyNo");
				return false;
			}
		}
		
		//added by gab 10.10.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
		if ($F("bankRefNo") == "") {
			if (objUW.hidObjGIPIS017.reqRefNo == "Y") {
				customShowMessageBox("Bank Reference Number is required.",
						imgMessage.ERROR, "nbtAcctIssCd");
				result = false;
				return false;
			}
		}
		
		if ($F("reqCredBranch") == "Y"){
			if($F("creditingBranch") == '' || $F("creditingBranch") == null){
				customShowMessageBox(objCommonMessage.REQUIRED,"E", "creditingBranch");
				result = false;
				return false;
			}
		}
		
		//moved changeTag validation by gab 10.10.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); 
			objUW.hidObjGIPIS017.forSaving = false; 
			result = false;
			return false;
		}

		if (result){
			if ((makeDate($("doe").value) < makeDate($("issueDate").value)) && (nvl(objUW.hidObjGIPIS017.allowIssueExpiredBond, "N") != "Y") && ($F("globalIssCd") != $F("globalIssCdRI"))) {
				customShowMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR, "doe");
				result = false;
				return false;
			} else if (makeDate($("doe").value) < makeDate($("doi").value)) {
				result = false;
				customShowMessageBox("A policy cannot expire before the date of its inception.", imgMessage.ERROR ,"doe");
				return false;
			} else if ((exp < eff) && ($F("issCd") == "RI") && (nvl(objUW.hidObjGIPIS017.allowIssueExpiredBond, "N") != "Y")) {
				result = false;
				customShowMessageBox("A policy cannot expire before the date of its issuance.", imgMessage.ERROR , "doe");
				return false;	
			}	
		}	
		if (objUW.hidObjGIPIS017.ora2010Sw == "Y"){
			if ($F("companyCd") != "" && $F("employeeCd") == ""){
				if (result){
					result = false;
					customShowMessageBox("Choose an employee first before proceeding.", imgMessage.INFO, "employeeCd");
					return false;
				}	
			}else if ($F("companyCd") == "" && $F("employeeCd") != ""){
				if (result){
					result = false;
					customShowMessageBox("Company is required.", imgMessage.ERROR, "companyCd");
					return false;
				}	
			}	
			if ($("bancaTag").checked){
				if (result){
					if ($F("selBancTypeCd") == "" || $F("selAreaCd") == "" || $F("selBranchCd") == "" || objUW.hidObjGIPIS017.managerCd == ""){
						result = false;
						customShowMessageBox("Please be advised that information for bank assurance should be complete.", imgMessage.ERROR, "selBancTypeCd");
						return false;
					}	
				}
			}
			if ($F("swBankRefNo") == "N"){
				if ($F("bankRefNo") != ""){	
					if (!validateBankRefNo()){
						result = false;
						return false;
					}else{
						result = true;
					}	
				}else{
					if ($F("nbtAcctIssCd") != "01" || $F("nbtBranchCd") != "0000"){
						$("bankRefNo").value = formatNumberDigits($F("nbtAcctIssCd"),2)+"-"+formatNumberDigits($F("nbtBranchCd"),4)+"-"+formatNumberDigits($F("dspRefNo"),7)+"-"+formatNumberDigits($F("dspModNo"),2);
						if (!validateBankRefNo()){
							result = false;
							return false;
						}else{
							result = true;
						}
					}
				}	
			}
		}
		if (result){
			if ($F("policyStatus") == '2'){ 
				new Ajax.Request(contextPath+"/GIPIParBondInformationController", {
					method: "GET",
					parameters: {action: 			"validateRenewalDuration",
					 			 parId:				$F("globalParId"),
								 lineCd:			$F("globalLineCd"),
								 wpolnrepSublineCd:	$F("wpolnrepSublineCd"),
								 wpolnrepIssCd: 	$F("wpolnrepIssCd"),
								 wpolnrepIssueYy: 	$F("wpolnrepIssueYy"),
								 wpolnrepPolSeqNo:	$F("wpolnrepPolSeqNo"),
								 wpolnrepRenewNo:	$F("wpolnrepRenewNo"),
								 doi:				$F("doi")
								 },
					asynchronous : false,
					evalScripts : true,			 
					onCreate: function(){
						showNotice("Validatiing Renewal duration,please wait...");
						},							 
					onComplete: function (response) {
							hideNotice("");
						if (response.responseText != "") {
							showMessageBox(response.responseText, imgMessage.ERROR);
							result = false;		
						}
					}
				});	
			}	
		}
		return result;	
	}

	function enablePolicyRenewalForm(){
		$("wpolnrepLineCd").enable();
		$("wpolnrepSublineCd").enable();
		$("wpolnrepIssCd").enable();
		$("wpolnrepIssueYy").enable();
		$("wpolnrepPolSeqNo").enable();
		$("wpolnrepRenewNo").enable();
		$("wpolnrepLineCd").addClassName("required");
		$("wpolnrepSublineCd").addClassName("required");
		$("wpolnrepIssCd").addClassName("required");
		$("wpolnrepIssueYy").addClassName("required");
		$("wpolnrepPolSeqNo").addClassName("required");
		$("wpolnrepRenewNo").addClassName("required");
		$("wpolnrepSublineCd").value = $("sublineCd").value;
		$("wpolnrepLineCd").value = $("lineCd").value;
		if ($("policyStatus").value != 2){
			$("samePolnoSw").checked = false;
			$("samePolnoSw").disable();
		}else{
			$("samePolnoSw").enable();
		}
	}
	
	function disablePolicyRenewalForm(){
		$("wpolnrepLineCd").disable();
		$("wpolnrepSublineCd").disable();
		$("wpolnrepIssCd").disable();
		$("wpolnrepIssueYy").disable();
		$("wpolnrepPolSeqNo").disable();
		$("wpolnrepRenewNo").disable();
		$("wpolnrepLineCd").removeClassName("required");
		$("wpolnrepSublineCd").removeClassName("required");
		$("wpolnrepIssCd").removeClassName("required");
		$("wpolnrepIssueYy").removeClassName("required");
		$("wpolnrepPolSeqNo").removeClassName("required");
		$("wpolnrepRenewNo").removeClassName("required");
		$("wpolnrepSublineCd").clear();
		$("wpolnrepLineCd").clear();
	}

	function clearPolicyRenewalForm(){
		$("oldPolicyId").value = "";
		$("wpolnrepIssCd").value = "";
		$("wpolnrepIssueYy").value = "";
		$("wpolnrepPolSeqNo").value = "";
		$("wpolnrepRenewNo").value = "";
	}

	function initBondBasic(){
		if ($F("updCredBranch") != "Y"){
			if ($("creditingBranch").value != ""){
				$("creditingBranch").disable();
			}
		}else if ($F("updCredBranch") == "Y"){
			$("creditingBranch").enable();
		}	
		
		if($F("reqCredBranch") == "Y"){
			$("creditingBranch").addClassName("required");
		}

		if (objUW.hidObjGIPIS017.reqRefPolNo == "Y"){
			$("referencePolicyNo").addClassName("required");
		}
		
		if (($F("policyStatus") == "2") || ($F("policyStatus") == "3")){
			enablePolicyRenewalForm();
		} else {
			disablePolicyRenewalForm();
			clearPolicyRenewalForm();
		}
		if ($("policyStatus").value != 2){
			$("samePolnoSw").checked = false;
			$("samePolnoSw").disable();
		}else{
			$("samePolnoSw").enable();
		}

		//hides unnecessary menus for line SU -BRY 11/03/2010
		//$("bondPolicyData").show();
		$("itemInfo").hide();
		$("itemInfo").up("li",0).hide();
		$("clauses").hide();
		$("clauses").up("li",0).hide();
		$("coInsurance").hide(); //added by Nok 02.16.2011
		$("coInsurance").up("li",0).hide();
		$("basicInfo").hide();
		$("additionalEngineeringInfo").hide();
		$("lineSublineCoverages").hide();
		$("cargoLimitsOfLiability").hide();
		$("carrierInfo").hide();
		$("bankCollection").hide();
		$("limitsOfLiabilities").hide();
		$("discountSurcharge").hide();
		$("groupItemsPerBill").hide();
		$("groupPrelimDist").hide();
		$("groupPrelimDist").up("li",0).hide();
		$("prelimPerilDist").hide();
		$("prelimPerilDist").up("li",0).hide();
		//$("prelimOneRiskDistTsiPrem").hide();	//removed by robert SR 5053 11.11.15
		//$("prelimOneRiskDistTsiPrem").up("li",0).hide();  //removed by robert SR 5053 11.11.15
		//$("prelimDistTsiPrem").hide(); //removed by robert SR 5053 11.11.15
		//$("prelimDistTsiPrem").up("li",0).hide(); //removed by robert SR 5053 11.11.15
		$$("li[class='menuSeparator']").each(function(ms){
			if (ms.getAttribute("id") == "distributionMenuSeparator") ms.style.visibility = "hidden"; ms.style.display = "none";
		});
		$$("li[class='menuSeparator']").each(function(ms){
			ms.hide();
		});
		//end Bryan 
		
		if ($F("gipiWInvoiceExist") == "1"){
			enableMenu("enterBillPremiums");
			$F("globalIssCd") == $F("globalIssCdRI") ? disableMenu("enterInvoiceCommission") : enableMenu("enterInvoiceCommission");
			enableMenu("distribution");
		}else{
			disableMenu("enterInvoiceCommission");
			disableMenu("distribution");
		}
		if ($F("sublineCd") != ""){
			$("bondPolicyData").show();
			enableMenu("bondPolicyData");
		}else{
			disableMenu("bondPolicyData");
		}
		var parStatus = $F("globalParStatus");
		parStatus > 4 ? enableMenu("bill") : disableMenu("bill");
		parStatus == 6 && checkUserModule("GIPIS055")? enableMenu("post") : disableMenu("post");
		
		if($F("issCd") == "RI"){ //added by christian 03/08/2013
			$("creditingBranch").disable();
			$("creditingBranch").value = "RI";
			$("credBranch").value = "RI";
		}
	}

	function updateBondBasicInfoParameters() {
	//	$("gipiWPolbasExist").value = 1;
	//	if ($("deleteBillSw").value == "Y"){
	//		$("gipiWItmperlExist").value = 0;
	//		$("gipiWinvTaxExist").value = 0;
	//	}	
		$("deleteBillSw").value = "N";
		$("deleteSw").value = "N";
		$("deleteWorkingDistSw").value = "N";
		$("deleteWPolnrep").value = "N";
	//	$("validatedIssuePlace").value = "N";
		$("validatedBookingDate").value = "N";
		$("paramSubline").value = $("sublineCd").value;
		$("paramPolicyStatus").value = $("policyStatus").value;
		$("paramRenewNo").value = $("renewNo").value;
		$("paramAssuredNo").value = $("assuredNo").value;
		$("paramAssuredName").value = $("assuredName").value;
		//$("paramIssuePlace").value = $("issuePlace").value;
	//	$("paramProvPremRatePercent").value = $("provPremRatePercent").value;
		$("paramDoi").value = $("doi").value;
	//	$("paramProrateFlag").value = $("prorateFlag").value;
	//	$("paramNoOfDays").value = $("noOfDays").value;
	//	$("paramShortRatePercent").value = $("shortRatePercent").value;
		$("paramBookingYear").value = $("bookingYear").value;
		$("paramBookingMth").value = $("bookingMth").value;
		$("paramDoe").value = $("doe").value;
	//	$("paramCoInsurance").value = $("coIns").value;
		$("paramTakeupTermType").value = $("takeupTermType").value;
	//	$("deleteCoIns").value = "";	
		$("updateIssueDate").value = "N";
		$("validateAssdName").value = "N";
		$("validateIfOldBondExist").value = "N";
		objUW.hidObjGIPIS017.forSaving			= false;
		objUW.hidObjGIPIS017.isExistGipiWPolbas = "1";
	}	
	
	objUWGlobal.inceptDate = $F("doi");
	objUWGlobal.parId = $F("parId");
	
	changeTag = 0;
	initializeChangeTagBehavior(saveFuncMain); 
	initBondBasic();
	setDocumentTitle("Bond Basic Information");
</script>