<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<script type="text/javascript" src="${path}/js/third_party/prototype.js"></script>
<script type="text/javascript" src="${path}/js/third_party/scriptaculous.js"></script>
<script type="text/javascript" src="${path}/js/third_party/ajaxtags.js"></script>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" style="border-top: none;" id="commPaytsDiv" name="commPaytsDiv" changeTagAttr="true">
	<!-- page variables -->
	<input type="hidden" 	id="currentRowNo" 			name="currentRowNo"				value="-1" />
	
	<!-- module variables -->
	<input type="hidden"	id="globalAcctgExequery"	name="globalAcctgExequery"		value="N" />
	<input type="hidden"	id="giacs020TranSource"		name="giacs020TranSource"		value="" />
	<input type="hidden"	id="giacs020OrFlag"			name="giacs020OrFlag"			value="" />
	<input type="hidden"	id="giacs020GaccTranId"		name="giacs020GaccTranId"		value="" />
	<input type="hidden"	id="giacs020BranchCd"		name="giacs020BranchCd"			value="" />
	<input type="hidden"	id="giacs020FundCd"			name="giacs020FundCd"			value="" />
	
	<!-- CONTROL block items -->
	<input type="hidden"	id="controlSumCommAmt"		name="controlSumCommAmt"		value="${sumCommAmt }" />
	<input type="hidden"	id="controlSumInpVAT"		name="controlSumInpVAT"			value="${sumInpVat }" />
	<input type="hidden"	id="controlSumWtaxAmt"		name="controlSumWtaxAmt"		value="${sumWtaxAmt }" />
	<input type="hidden"	id="controlSumNetCommAmt"	name="controlSumNetCommAmt"		value="${controlSumNetCommAmt }" />
	<input type="hidden"	id="controlVWtaxAmt"		name="controlVWtaxAmt"			value="" />
	<input type="hidden"	id="controlVCommAmt"		name="controlVCommAmt"			value="" />
	<input type="hidden"	id="controlVInputVAT"		name="controlVInputVAT"			value="" />
	<!-- end of CONTROL block items -->
	
	<!-- GCOP block items -->
	<input type="hidden"	id="txtIntmNo"				name="txtIntmNo"				value=""/>
	<input type="hidden"	id="txtCommTag"				name="txtCommTag"				value="N"/>
	<input type="hidden"	id="txtDspPolicyId"			name="txtDspPolicyId"			value=""/>
	<input type="hidden"	id="txtDspAssdNo"			name="txtDspAssdNo"				value=""/>
	<input type="hidden"	id="txtDefCommAmt"			name="txtDefCommAmt"			value=""/>
	<input type="hidden"	id="txtDefInputVAT"			name="txtDefInputVAT"			value=""/>
	<input type="hidden"	id="txtDefWtaxAmt"			name="txtDefWtaxAmt"			value=""/>
	<input type="hidden"	id="txtParentIntmNo"		name="txtParentIntmNo"			value=""/>
	<input type="hidden"	id="txtRecordNo"			name="txtRecordNo"				value=""/>
	<input type="hidden"	id="txtBillGaccTranId"		name="txtBillGaccTranId"		value=""/>	<!-- shan 10.02.2014 -->
	<input type="hidden"	id="txtRecordSeqNo"			name="txtRecordSeqNo"			value=""/>	<!--added by robert SR 19752 07.28.15 -->
	<!-- end of GCOP block items -->
	
	<!-- VARIABLES -->
		<!-- 
		<input type="hidden"		id="varInputVATParam"		name="varInputVATParam"			value="${varInputVATParam }" />
		 -->
		<input type="hidden"		id="varCommPayableParam"	name="varCommPayableParam"		value="${varCommPayableParam }" />
		<input type="hidden"		id="varAssdNo"				name="varAssdNo"				value="${varAssdNo }" />
		<input type="hidden"		id="varIntmNo"				name="varIntmNo"				value="${varIntmNo }" />
		<input type="hidden"		id="varItemNo"				name="varItemNo"				value="${varItemNo }" />
		<input type="hidden"		id="varItemNo2"				name="varItemNo2"				value="${varItemNo2 }" />
		<input type="hidden"		id="varItemNo3"				name="varItemNo"				value="${varItemNo3 }" />
		<input type="hidden"		id="varLineCd"				name="varLineCd"				value="${varLineCd }" />
		<input type="hidden"		id="varModuleId"			name="varModuleId"				value="${varModuleId }" />
		<input type="hidden"		id="varModuleName"			name="varModuleName"			value="GIACS020" />
		<input type="hidden"		id="varGenType"				name="varGenType"				value="${varGenType }" />
		<input type="hidden"		id="varSlTypeCd1"			name="varSlTypeCd1"				value="${varSlTypeCd1 }" />
		<input type="hidden"		id="varSlTypeCd2"			name="varSlTypeCd2"				value="${varSlTypeCd2 }" />
		<input type="hidden"		id="varSlTypeCd3"			name="varSlTypeCd3"				value="${varSlTypeCd3 }" />
		<input type="hidden"		id="varTranType"			name="varTranType"				value="" />
		<input type="hidden"		id="varInputVATParam"		name="varInputVATParam"			value="" />
		<input type="hidden"		id="varLOVTranType"			name="varLovTranType"			value="" />
		<input type="hidden"		id="varLOVIssCd"			name="varLovIssCd"				value="" />
		<input type="hidden"		id="varRCommAmt"			name="varRCommAmt"				value="" />
		<input type="hidden"		id="varICommAmt"			name="varICommAmt"				value="" />
		<input type="hidden"		id="varPCommAmt"			name="varPCommAmt"				value="" />
		<input type="hidden"		id="varRWtax"				name="varRWtax"					value="" />
		<input type="hidden"		id="varIWtax"				name="varIWtax"					value="" />
		<input type="hidden"		id="varPWtax"				name="varPWtax"					value="" />
		<input type="hidden"		id="varDefFgnCurr"			name="varDefFgnCurr"			value="" />
		<input type="hidden"		id="varPctPrem"				name="varPctPrem"				value="" />
		<input type="hidden"		id="varCg$Dummy"			name="varCg$Dummy"				value="" />
		<input type="hidden"		id="varPTranType"			name="varPTranType"				value="" />
		<input type="hidden"		id="varPTranId"				name="varPTranId"				value="" />
		<input type="hidden"		id="varClrRec"				name="varClrRec"				value="" />
		<input type="hidden"		id="varLastWtax"			name="varLastWtax"				value="0" />
		<input type="hidden"		id="varMaxInputVAT"			name="varMaxInputVAT"			value="0" />
		<input type="hidden"		id="varVATRt"				name="varVATRt"					value="" />
		<input type="hidden"		id="varVPolFlag"			name="varVPolFlag"				value="" />
		<input type="hidden"		id="varHasPremium"			name="varHasPremium"			value="Y" />
		<input type="hidden"		id="varCPremiumAmt"			name="varCPremiumAmt"			value="" />
		<input type="hidden"		id="varInvPremAmt"			name="varInvPremAmt"			value="" />
		<input type="hidden"		id="varOtherCharges"		name="varOtherCharges"			value="" />
		<input type="hidden"		id="varNotarialFee"			name="varNotarialFee"			value="" />
		<input type="hidden"		id="varPdPremAmt"			name="varPdPremAmt"				value="" />
		<input type="hidden"		id="varInvoiceButt"			name="varInvoiceButt"			value="N" />
		<input type="hidden"		id="varPrevCommAmt"			name="varPrevCommAmt"			value="" />
		<input type="hidden"		id="varPrevWtaxAmt"			name="varPrevWtaxAmt"			value="" />
		<input type="hidden"		id="varPrevInputVAT"		name="varPrevInputVAT"			value="" />
		<input type="hidden"		id="varFdrvCommAmt"			name="varFdrvCommAmt"			value="" />
		<input type="hidden"		id="varCFireNow"			name="varCFireNow"				value="N" />
		<input type="hidden"		id="varVItemNum"			name="varVItemNum"				value="" />
		<input type="hidden"		id="varVBillNo"				name="varVBillNo"				value="" />
		<input type="hidden"		id="varVIssueCd"			name="varVIssueCd"				value="" />
		<input type="hidden"		id="varCommTakeUp"			name="varCommTakeUp"			value="" />
		<input type="hidden"		id="varVFromSums"			name="varVFromSums"				value="N" />
		<input type="hidden"		id="accessAU"				name="accessAU"					value="${accessAU}"  />
		<input type="hidden"		id="accessMC"				name="accessMC"					value="${accessMC}"  />
		<input type="hidden"		id="noPremPayt"				name="noPremPayt"				value="${noPremPayt}"  />
	<!-- end of VARIABLES -->
	
	<!-- end of module variables -->
	
	<!-- misc variables -->
		<input type="hidden"		id="commPaytsListLastNo"	name="commPaytsListLastNo"		value="${commPaytsListSize - 1}<c:if test="${empty commPaytsListSize }">0</c:if>"/>
		<input type="hidden"		id="tranSourceCommTag"		name="tranSourceCommTag"		value="${tranSourceCommTag }"/>
		<input type="hidden"		id="isIntmNoValidated"		name="isIntmNoValidated"		value="N"/> <!-- used for tagging if intm no is already validated -->
		<input type="hidden"		id="lastPremSeqNo"			name="lastPremSeqNo"			value="" />
		<input type="hidden"		id="lastCommAmt"			name="lastCommAmt"				value=""/>
		<input type="hidden"		id="lastForeignCurrAmt"		name="lastForeignCurrAmt"		value=""/>
		<input type="hidden"		id="lastInputVATAmt"		name="lastInputVATAmt"			value=""/>
		<input type="hidden"		id="lastDisbComm"			name="lastDisbComm"				value=""/>
		<input type="hidden"		id="gcopInvModalTag"		name="gcopInvModalTag"			value="N"/>
		<input type="hidden"		id="recordSelectedTag"		name="recordSelectedTag"		value="N"/>
	<!-- end of misc variables -->
	
	<!-- The div to be used for storing deleted records -->
	<div id="deleteCommPaytsList" name="deleteCommPaytsList"></div>
	
	<!-- The div to be used for storing checked records to be added from GCOP INV table -->
	<div id="gcopInvRecordsList" name="gcopInvRecordsList" style="display: none"></div>

	<jsp:include page="commPaytsListingTable.jsp"></jsp:include>
	
	<table align="center" style="margin: 10px;">
		<tr>
			<td class="rightAligned" style="width: 180px">Transaction Type</td>
			<td class="leftAligned"	 style="width: 250px;">
				<select id="txtTranType" name="txtTranType" style="width: 250px" class="required" tabindex=1>
					<option value="">Select...</option>
					<c:forEach var="tranType" items="${tranTypeLOV }" varStatus="ctr">
						<option value="${tranType.rvLowValue }">${tranType.rvLowValue} - ${tranType.rvMeaning }</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width: 140px">Assured Name</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDspAssdName" maxlength="500" name="txtDspAssdName" style="width: 234px" readonly="readonly" tabindex=9></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Bill No.</td>
			<td class="leftAligned"	 style="width: 250px;">
				<!-- <select id="txtIssCd" name="txtIssCd" style="width: 122px; height: 23px" class="required" tabindex=2> 	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
					<option value="" userAccess="">Select...</option>
					<c:forEach var="issSource" items="${issCdLOV }">
						<option value="${issSource.issCd }" userAccess="${issSource.acctIssCd }" >${issSource.issName }</option>
					</c:forEach>
				</select> 	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015-->
				<div id="spanBranchCd" class="lovSpan required" style="width: 110px; margin-right: 2px; height: 21px;">
					<input type="text" id="txtIssCd" name="txtIssCd" lastValidValue="" style="width: 84px; float: left; border: none; height: 14px; margin: 0;" class="upper required" tabindex="2" ignoreDelKey="" maxlength="2"/> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;"/>
				</div>
				<div id="premSeqNoDiv" style="border: 1px solid gray; width: 132px; height: 21px; float: right; margin-right: 7px; background-color: cornsilk">
					<input type="text" id="txtPremSeqNo" name="txtPremSeqNo" style="width: 106px; border: none; text-align: right; float: left; height: 13px;" class="required" maxlength="14" tabindex=3>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmBillNo" name="oscmBillNo" alt="Go" />
				</div>
			</td>
			<td class="rightAligned" style="width: 140px">Policy/Endorsement No.</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDspLineCd" name="txtDspLineCd" maxlength="30" style="width: 234px" readonly="readonly" tabindex=10></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Intermediary</td>
			<td class="leftAligned"	 style="width: 250px;"><input type="text" id="txtDspIntmName" name="txtDspIntmName" class="required" maxlength="240" style="width: 240px" tabindex=4 readonly="readonly"/></td>
			<td class="rightAligned" style="width: 140px">Particulars</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtParticulars" name="txtParticulars" maxlength="2000" style="width: 234px" tabindex=11></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Commission Amount</td>
			<td class="leftAligned"	 style="width: 250px;"><input type="text" id="txtCommAmt" name="txtCommAmt" class="required" maxlength="16" style="width: 240px;text-align: right" tabindex=5></input></td>
			<td class="rightAligned" style="width: 140px">Actual Disbursed Comm.</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDisbComm" name="txtDisbComm" maxlength="16" style="width: 234px;text-align: right" tabindex=12></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Input VAT Amount</td>
			<td class="leftAligned"	 style="width: 250px;"><input type="text" id="txtInputVATAmt" name="txtInputVATAmt" class="money" maxlength="16" style="width: 240px;text-align: right" tabindex=6></input></td>
			<td class="rightAligned" style="width: 140px"></td>
			<td style="width: 260px;text-align: center">
				<input type="button" class="disabledButton" style="width: 100px;" id="btnInvoice" name="btnInvoice" value="Invoice" disabled="disabled" tabindex=13></input>
				<input type="button" class="button" 		style="width: 100px;" id="btnCurrencyDetails" name="btnCurrencyDetails" value="Currency Info" tabindex=14></input>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Withholding Tax</td>
			<td class="leftAligned"	 style="width: 250px;"><input type="text" id="txtWtaxAmt" name="txtWtaxAmt" class="required" maxlength="16" style="width: 240px;text-align: right" readonly="readonly" tabindex=7></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Net Commission Amount</td>
			<td class="leftAligned"	 style="width: 250px;"><input type="text" id="txtDrvCommAmt" name="txtDrvCommAmt" class="money" maxlength="16" style="width: 240px;text-align: right" readonly="readonly" tabindex=8></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px"></td>
			<td class="leftAligned"	 style="width: 250px;font-size: 11px;">
				<input type="checkbox" id="chkPrintTag" name="chkPrintTag" value="Y" checked="checked" tabindex=15></input> Print Tag
				<input type="checkbox" id="chkDefCommTag" name="chkDefCommTag"  style="margin-left: 50px;" value="Y" checked="checked" disabled="disabled" tabindex=16></input> <c:if test="${isUserValid eq 'Y'}">Def Comm</c:if>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px"></td>
			<td style="width: 260px;">
				<input type="button" class="button" 		style="width: 80px;" id="btnSaveRecord" name="btnSaveRecord" value="Add" tabindex=17></input>
				<input type="button" class="disabledButton" style="width: 80px;" id="btnDeleteRecord" name="btnDeleteRecord" value="Delete" disabled="disabled" tabindex=18></input>
			</td>
		</tr>
	</table>
	<div id="currencyDiv" style="display: none;">
		<jsp:include page="currencyInfoPage.jsp"></jsp:include>
	</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 80px;" id="btnCancel" 		name="btnCancel"		class="button" value="Cancel" tabindex=20/>
	<input type="button" style="width: 80px;" id="btnSaveCommPayts" name="btnSaveCommPayts"	class="button" value="Save" tabindex=19/>
</div>

<!-- AjaxTags -->
<ajax:autocomplete 
	source="txtDspIntmName" 
	target="txtIntmNo" 
	baseUrl="AjaxAutoCompleteController"
	parameters="action=getGIPICommInvoiceDropdownIntmList,tranType={txtTranType},issCd={txtIssCd},premSeqNo={txtPremSeqNo},intmName={txtDspIntmName},recordSelected={recordSelectedTag}" 
	className="autocomplete"/>
<!-- end of AjaxTags -->

<script type="text/javascript">
	checkIfToResizeTable("commPaytsTableContainer", "rowCommPayts");
	checkTableIfEmpty("rowCommPayts", "commPaytsTableMainDiv");
	setModuleId("GIACS020");
	//setDocumentTitle("Commission Payts");commented out by reymon 03252013
	setDocumentTitle("Enter Commission Payments");//changed by reymon 03252013
	var existingRecord = false;	// shan 10.02.2014
	defaultCommissionAmt = "";
	changeTag = 0;	
	window.scrollTo(0,0); 	
	hideNotice("");
	observeCancelForm("btnCancel", saveGiacs020CommPayts, function(){
		if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
			showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
		}else if(objACGlobal.previousModule == "GIACS002"){
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS003"){
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;			
		}else if(objACGlobal.previousModule == "GIACS071"){
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
			$("giacs031MainDiv").hide();
			$("giacs032MainDiv").show();
			$("mainNav").hide();
		}else{
			changeTag = 0;
			showORInfo();
		}
	});
	var getGipiCommFlag = 0;

	// check if OR is printed. if yes, disable all fields (emman 06.17.2011)
	//if ((objACGlobal.orFlag == "P" && objACGlobal.orTag != "*") || objACGlobal.orFlag == "C" || objACGlobal.orFlag == "D") {
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){	
		$("txtTranType").disable();
		$("txtIssCd").disable();
		$("txtPremSeqNo").readOnly = true;

		$("txtDspIntmName").readOnly = true;
		$("txtCommAmt").readOnly = true;
		$("txtInputVATAmt").readOnly = true;
		$("txtWtaxAmt").readOnly = true;
		$("txtDrvCommAmt").readOnly = true;

		$("txtDspAssdName").readOnly = true;
		$("txtDspLineCd").readOnly = true;
		$("txtParticulars").readOnly = true;
		$("txtDisbComm").readOnly = true;

		$("chkPrintTag").disable();
		$("chkDefCommTag").disable();

		disableButton("btnSaveRecord");
		disableButton("btnDeleteRecord");
		disableButton("btnSaveCommPayts");
	} else {
		$("txtCurrencyCd").readOnly = true;
		$("txtDspCurrencyDesc").readOnly = true;
		$("txtConvertRate").readOnly = true;
		$("txtForeignCurrAmt").addClassName("required");
	}

	$("giacs020TranSource").value = objACGlobal.tranSource;
	$("giacs020OrFlag").value = objACGlobal.orFlag;
	$("giacs020BranchCd").value = objACGlobal.branchCd;
	$("giacs020FundCd").value = objACGlobal.fundCd;
	$("giacs020GaccTranId").value = objACGlobal.gaccTranId;

	// check if def_comm_tag should be disabled (emman 06.14.2011)
	if ('${isUserValid}' != "Y") {
		$("chkDefCommTag").style.display = "none";
	}

	$("oscmBillNo").observe("click", function() {
		objGIACS020.onLOV = ($F("txtPremSeqNo") != "")? "N" : "Y";	// shan 10.16.2014
		//premSeqNoPreTextItem();
		//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
		if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
			if ($F("txtTranType").blank() || $F("txtIssCd").blank()) {
				showMessageBox("Please select a transaction type and issue source first.", imgMessage.ERROR);
				return false;
			} else if ($F("currentRowNo") != -1) {
				if ($F("gcopChanged"+$F("currentRowNo")) == "N") {
					showMessageBox("You cannot update this record.", imgMessage.WARNING);
				} else {
					showGcopInvDetails();
				}
			} else {
				//premSeqNoListVal();
				showGcopInvDetails();
			}
		}
	});

	$("btnSaveRecord").observe("click", function() {
		if (checkRequiredFields()) {
			/*if(!(isNaN($F("txtDisbComm").replace(/,/g,"")))){
				//added by steven 09.12.2014
				var result2 = checkRelCommWUnprintedOr($F("txtIssCd"),$F("txtPremSeqNo"));
				if (result2.message == "ALLOWED") {
					showConfirmBox("Confirmation", "The premium payment of bill no. " + result2.issCd + "-" + result2.premSeqNo + " is not yet printed. "+result2.refNo +'.'+
							"Do you want to continue?",
							"Yes", "No",
							function() {
								saveRecord();
							},function(){
								return;
							});
				}else if (result2.message == "NOT_ALLOWED") {
					showMessageBox( "The premium payment of bill no. " + result2.issCd + "-" + result2.premSeqNo + " is not yet printed. "+result2.refNo +'.','I');
					return;
				}
				
				if (result2.message != "ALLOWED") {
					saveRecord(); 
				}
			}*/ // moved inside validateIntmNo() : shan 10.17.2014
			saveRecord();
		}
	});

	$("btnDeleteRecord").observe("click", function() {
		if (existingRecord && ($F("txtTranType") == "1" || $F("txtTranType") == "3")) {	// added condition : shan 10.02.2014
			deleteRecord();
		}else{
			var row = $("row"+$F("currentRowNo"));
			if (row.down("input", 1).value != "Y") {
				var deleteDiv = $("deleteCommPaytsList");
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "commPaytsRowDeleted"+row.down("input", 3).value+"-"+row.down("input", 4).value+"-"+row.down("input",5).value+
						"-"+row.down("input",23).value+"-"+row.down("input",24).value+"-"+row.down("input",30).value); //added by robert SR 19752 07.28.2015
				newDiv.setAttribute("name", "commPaytsRowDeleted");
				newDiv.update(
						'<input type="hidden" id="deletedGcopGaccTranId" 		name="deletedGcopGaccTranId" 	  value="'+row.down("input", 2).value+'" />' +
						'<input type="hidden" id="deletedGcopIntmNo" 			name="deletedGcopIntmNo" 	  	  value="'+row.down("input", 6).value+'" />' +
						'<input type="hidden" id="deletedGcopIssCd" 			name="deletedGcopIssCd"		 	  value="'+row.down("input", 4).value+'" />' +
						'<input type="hidden" id="deletedGcopPremSeqNo" 		name="deletedGcopPremSeqNo" 	  value="'+row.down("input", 5).value+'" />' + //added by robert SR 19752 07.28.2015
						'<input type="hidden" id="deletedCommTag" 				name="deletedCommTag" 	  		  value="'+row.down("input", 23).value+'" />' + //added by robert SR 19752 07.28.2015
						'<input type="hidden" id="deletedRecordNo" 				name="deletedRecordNo" 	  	  	  value="'+row.down("input", 24).value+'" />' + //added by robert SR 19752 07.28.2015
						'<input type="hidden" id="deletedRecordSeqNo" 			name="deletedRecordSeqNo"		  value="'+row.down("input", 30).value+'" />' //added by robert SR 19752 07.28.2015
						);
			
				deleteDiv.appendChild(newDiv);
			}
			// delete the record from the main container div
			Effect.Fade(row, {
				duration: .2,
				afterFinish: function() {
					$("controlSumCommAmt").value = parseFloat(nvl($F("controlSumCommAmt"), "0")) - parseFloat(nvl(row.down("input", 9).value, "0"));
					$("controlSumInpVAT").value = roundNumber(parseFloat(nvl($F("controlSumInpVAT"), "0")) - parseFloat(nvl(row.down("input", 10).value, "0")), 2);
					$("controlSumWtaxAmt").value = parseFloat(nvl($F("controlSumWtaxAmt"), "0")) - parseFloat(nvl(row.down("input", 11).value, "0"));
					$("controlSumNetCommAmt").value = roundNumber(parseFloat(nvl($F("controlSumNetCommAmt"), "0")) - parseFloat(nvl(row.down("input", 12).value, "0")), 2);
				
					row.remove();
					resetFields();
					disableButton("btnDeleteRecord"); 
					$("btnSaveRecord").value = "Add"; 
					computeTotalAmtValues();
					checkIfToResizeTable("commPaytsTableContainer", "rowCommPayts");
					checkTableIfEmpty("rowCommPayts", "commPaytsTableMainDiv");
				}
			});
		}
	});

	$("btnSaveCommPayts").observe("click", function() {
		saveGiacs020CommPayts();
	});
	
	$$("div[name='rowCommPayts']").each(function(row) {
		row.observe("mouseover", function() {
			row.addClassName("lightblue");
		});

		row.observe("mouseout", function() {
			row.removeClassName("lightblue");
		});

		row.observe("click", function() {
			clickCommPaytsRow(row);
		});

		/*
		$$("input[type='text']").each(function (txt) {
			txt.readOnly = true;
		});

		$$("input[type='checkbox']").each(function (chk) {
			chk.disable();
		});

		$$("select").each(function (sel) {
			sel.disable();
		});

		disableButton($("btnSaveRecord"));
		disableButton($("btnInvoice"));
		disableButton($("btnCurrencyDetails"));*/
	});

	// item functions
	
	$("chkDefCommTag").observe("change", function() {
		var ok = true;
		if ($F("txtTranType") == 2 || $F("txtTranType") == 4) {
			if (!$("chkDefCommTag").checked) {
				$("chkDefCommTag").checked = true;
			} else {
				$("chkDefCommTag").checked = false;
			}
		} else {
			$("varCg$Dummy").value = "2";
			if (!$("chkDefCommTag").checked) {
				showConfirmBox("", "Changing status for this item will overwrite the default computation of the Commission Amount.  Do you wish to continue?",
						"Yes", "No",
						function() {
							$("chkDefCommTag").checked = false;
						},
						function() {
							$("chkDefCommTag").checked = true;
						}
				);
			} else {
				$("chkDefCommTag").checked = true;

				if (getDefPremPct()) {
					if (compSummary()) {
						if (($F("txtTranType") == 1 && parseFloat($F("txtCommAmt")) <= 0)
								|| ($F("txtTranType") == 3 && parseFloat($F("txtCommAmt")) > 0)) {
							$("chkDefCommTag").checked = false;
						} else {
							$("chkDefCommTag").checked = true;
							if (!getDefPremPct()) {
								return false;
							}
						}
					} else {
						return false;
					}
				} else {
					return false;
				}
				//compSummary();
			}
		}

		if ($("chkDefCommTag").checked) {
			$("chkDefCommTag").value = "Y";
		} else {
			$("chkDefCommTag").value = "N";
		}
	});

	$("chkPrintTag").observe("change", function() {
		if ($("chkPrintTag").checked) {
			$("chkPrintTag").value = "Y";
		} else {
			$("chkPrintTag").value = "N";
		}
	});
	
	$("txtTranType").observe("focus", function() {
		if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
			gcopTranTypePreTextItem();
		}
	});

	$("txtTranType").observe("change", function() {
		if ($("txtTranType").selectedIndex != 0) {
			if (/*$("txtIssCd").selectedIndex != 0*/ !$F("txtIssCd").blank()) {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
				enableButton("btnInvoice");
			}
		}
		$("isIntmNoValidated").value = "N";
		// added (emman 06.13.2011)
		$("txtIssCd").value = "";
		$("txtPremSeqNo").value = "";
		resetFields2();
	});

	$("txtIssCd").observe("change", function() {
		/*if ($("txtIssCd").selectedIndex == 0) {
			$("txtTranType").enable();
			$("txtPremSeqNo").readOnly = true;
		} else {
			$("txtTranType").disable();
			$("txtPremSeqNo").readOnly = false;
		}*/ // removed (emman 06.13.2011)
		
		// added (emman 06.13.2011)
		$("txtPremSeqNo").value = "";
		resetFields2();
		
		/*if ($("txtIssCd").options[$("txtIssCd").selectedIndex].readAttribute("userAccess") == "0") {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
			disableButton("btnInvoice");
			showMessageBox("You are not allowed to apply payment for this Issuing Source.", imgMessage.INFO);
			return false;
		} else if ($("txtIssCd").options[$("txtIssCd").selectedIndex].readAttribute("userAccess").blank()) {
			disableButton("btnInvoice");
			return false;
		} else*/ if ($("txtTranType").selectedIndex != 0){	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
			enableButton("btnInvoice");
		}
		
		if($F("txtIssCd").trim() != "" && $F("txtIssCd") != $("txtIssCd").readAttribute("lastValidValue")) {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
			getGiacs020IssCdLOV();
		}

		$("isIntmNoValidated").value = "N";
	});
	
	// start : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
	$("searchIssCd").observe("click", getGiacs020IssCdLOV);
	
	function getGiacs020IssCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs020IssCdLOV",
				moduleId: "GIACS020",
				filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : "")
			},
			title: "List of Issue Codes",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "issCd",
								title: "Issue Code",
								width: '88px'
							},
							{	id : "issName",
								title: "Issue Name",
								width: '300px'
							},
							{	id : "userIssCdAcess",
								width: '0px',
								visible: false
							}
						],
			draggable: true,
			filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtIssCd").value = row.issCd;
					$("txtIssCd").setAttribute("lastValidValue", row.issCd);
					$("txtPremSeqNo").value = "";
					$("txtPremSeqNo").setAttribute("lastValidValue", "");
					$("txtPremSeqNo").focus();
				}
			},
	  		onCancel: function(){
	  			$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}	// end : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015

	$("txtPremSeqNo").observe("change", function() {
		if (isNaN($F("txtPremSeqNo"))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
				function() {
					$("txtPremSeqNo").value = $F("lastPremSeqNo");
					$("txtPremSeqNo").focus();
				}
			);
		} else if(parseInt($F("txtPremSeqNo")) > 999999999 || parseInt($F("txtPremSeqNo") < -999999999)) {
			showWaitingMessageBox("Must be in range -9999999999999 to 9999999999999", imgMessage.ERROR,
					function() {
						$("txtPremSeqNo").value = $F("lastPremSeqNo");
						$("txtPremSeqNo").focus();
					}
				);
		} else if (this.value == ""){
			resetFields2();
		} else{
			objGIACS020.onLOV = "N";	// shan 10.16.2014
			$("isIntmNoValidated").value = "N";
			/*if (chkModifiedComm()) {
				$("txtDspIntmName").focus();
			}*/
			// irwin here
			validateGiacs020Intermediary();
			//$("txtCommAmt").focus(); //moved to validateGiacs020Intermediary
			//validateGcopCommAmt();
		}
	});

	$("txtPremSeqNo").observe("focus", function() {
		//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
		if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
			premSeqNoPreTextItem();
		}
	});

	$("txtDspIntmName").observe("focus", function() {
		// removed (emman 06.08.2011)
		/*if ($("txtTranType").selectedIndex == 0 || $("txtIssCd").selectedIndex == 0 || $F("txtPremSeqNo").blank()) {
			$("txtDspIntmName").readOnly = true;
		} else {
			$("txtDspIntmName").readOnly = false;
		}*/

		//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
			//validateGiacs020Intermediary(); removed  // irwin 8.2.2012
		//}
	});

	$("txtCommAmt").observe("focus", function() {
		//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
		if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
			if ($F("txtDspIntmName").blank()) $("txtDspIntmName").focus();
			
			if ($F("recordSelectedTag") != "Y") {
				if ($("txtTranType").selectedIndex == 0 || /*$("txtIssCd").selectedIndex == 0*/ $F("txtIssCd").blank() || $F("txtPremSeqNo").blank()) {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
				} else {
					$("txtCommAmt").readOnly = false;
				}
			}
			
			$("lastCommAmt").value = $F("txtCommAmt");
			
			if ($F("currentRowNo") == -1) {
				if (!$F("txtIssCd").blank() && !$F("txtPremSeqNo").blank() && !$F("txtIntmNo").blank()) {
					getGipiCommInvoice();
				}
			}
	
			if ($("chkDefCommTag").checked) {
				$("varDefFgnCurr").value = getNaNAlternativeValue(parseFloat($F("varDefFgnCurr")) * parseFloat($F("varPctPrem")), "");
				$("varICommAmt").value = getNaNAlternativeValue(parseFloat($F("varICommAmt")) * parseFloat($F("varPctPrem")), "");
				$("varIWtax").value = getNaNAlternativeValue(parseFloat($F("varIWtax")) * parseFloat($F("varPctPrem")), "");
			}
	
			$("varPrevCommAmt").value = parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0"));
			$("varPrevWtaxAmt").value = parseFloat(nvl($F("txtWtaxAmt").replace(/,/g,""), "0"));
			$("varPrevInputVAT").value = parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0"));
	
			$("txtDrvCommAmt").value = formatCurrency(parseFloat(getDrvCommAmt($F("txtWtaxAmt"), $F("txtInputVATAmt"), $F("txtCommAmt"))));
			
			$("txtCommAmt").readOnly = ($F("txtTranType") == 2 || $F("txtTranType") == 4) ? true : false; // shan 09.25.2014
		}
	});

	$("txtCommAmt").observe("change", function() {
		if (isNaN($F("txtCommAmt").replace(/,/g,""))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
				function() {
					$("txtCommAmt").value = formatCurrency($F("lastCommAmt").replace(/,/g,""));
					$("txtCommAmt").focus();
				}
			);
		} else if ($F("txtCommAmt").blank()) {
			showWaitingMessageBox("Field must be entered.", imgMessage.ERROR,
					function() {
						invCommAmt();
						$("txtCommAmt").focus();
					});
			return false;
		} else {
			validateValidCommAmt();
		}
	});
	
	function validateValidCommAmt(){
		if ($F("txtTranType") == 1 || $F("txtTranType") == 4){
			if (parseFloat($F("txtCommAmt").replace(/,/g,"")) > parseFloat(defaultCommissionAmt.replace(/,/g,""))){
				showMessageBox("Invalid Commission Amount.", imgMessage.ERROR);
				$("txtCommAmt").value = formatCurrency(defaultCommissionAmt);
			} else {
				validateGcopCommAmt();
			}
		} else if ($F("txtTranType") == 2 || $F("txtTranType") == 3){
			if (parseFloat($F("txtCommAmt").replace(/,/g,"")) < parseFloat(defaultCommissionAmt.replace(/,/g,""))){
				showMessageBox("Invalid Commission Amount.", imgMessage.ERROR);
				$("txtCommAmt").value = formatCurrency(defaultCommissionAmt);
			} else {
				validateGcopCommAmt();
			}
		}
	}

	$("txtInputVATAmt").observe("focus", function() {
		//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
		if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
			if ($F("recordSelectedTag") != "Y") {
				if ($("txtTranType").selectedIndex == 0 || /*$("txtIssCd").selectedIndex == 0*/ $F("txtIssCd").blank() || $F("txtPremSeqNo").blank()) {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
					$("txtInputVATAmt").readOnly = true;
				} else {
					$("txtInputVATAmt").readOnly = false;
				}
			}
			
			$("lastInputVATAmt").value = $F("txtInputVATAmt");
			$("varPrevInputVAT").value = parseFloat(nvl($F("txtInputVATAmt"), "0"));
			$("controlVInputVAT").value = parseFloat(nvl($F("txtInputVATAmt"), "0"));
			this.readOnly = true;	// shan 10.15.2014
			if ($F("txtTranType") == 2 || $F("txtTranType") == 4 || $F("txtTranType").blank()) {
				this.readOnly = true;
			}else{
				this.readOnly = false;
			}
		}
	});

	$("txtInputVATAmt").observe("change", function() {
		if (isNaN($F("txtInputVATAmt").replace(/,/g,""))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
				function() {
					$("txtInputVATAmt").value = 	formatCurrency($F("lastInputVATAmt").replace(/,/g,""));
					$("txtCommAmt").focus();
				}
			);
		} else {
			/*if ($F("txtTranType") == 1 || $F("txtTranType") == 4) {
				if ($F("txtInputVATAmt").blank()) {
					$("txtInputVATAmt").value = 0;
				} else if (parseFloat($F("txtInputVATAmt")) > parseFloat($F("txtDefInputVAT"))) {
					showMessageBox("Input VAT Amount cannot be greater than the default value of " + $F("txtDefInputVAT") + ".", imgMessage.INFO);
					$("txtInputVATAmt").value = parseFloat(nvl($F("varPrevInputVAT"),0));
				}
			} else if ($F("txtTranType") == 2 || $F("txtTranType") == 3) {
				if ($F("txtInputVATAmt").blank()) {
					$("txtInputVATAmt").value = 0;
				} else if (parseFloat($F("txtInputVATAmt")) < parseFloat($F("txtDefInputVAT"))) {
					showMessageBox("Input VAT Amount cannot be less than the default value of " + $F("txtDefInputVAT") + ".", imgMessage.INFO);
					$("txtInputVATAmt").value = parseFloat(nvl($F("varPrevInputVAT"),0));
				}
			}*/
			
			if ($F("txtTranType") == 1 || $F("txtTranType") == 3){
				var allowedInputVAT = parseFloat(nvl($F("txtCommAmt"), 0)) * parseFloat(nvl($F("varVATRt"), 0)) / 100;
				allowedInputVAT = Number(Math.round(allowedInputVAT + 'e2') + 'e-2'); // 2 in e2/e-2 represents number of decimal
				if (this.value != 0 && this.value != allowedInputVAT){
					showMessageBox("Invalid Input VAT Amount entered.");
					$("txtInputVATAmt").value = formatCurrency(parseFloat(nvl($F("lastInputVATAmt"),0)));	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
					return;
				}
			}
	
			$("varCFireNow").value = "Y";
	
			$("controlSumInpVAT").value = parseFloat(nvl($F("controlSumInpVAT").replace(/,/g,""), "0"))
											+ parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0"))
											- parseFloat(nvl($F("controlVInputVAT").replace(/,/g,""), "0"));
	
			$("controlVInputVAT").value = parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0"));
			$("varPrevInputVAT").value = parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0"));
	
			$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtWtaxAmt"), $F("txtInputVATAmt"), $F("txtCommAmt")));
			$("txtInputVATAmt").value = formatCurrency(parseFloat($F("txtInputVATAmt").replace(/,/g,"")));
		}
	});
	
	$("txtDisbComm").observe("focus", function() {
		//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
		if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
			$("lastDisbComm").value = $F("txtDisbComm");

			function afterCompute() {
				if ($("chkDefCommTag").checked) {
					$("varDefFgnCurr").value = getNaNAlternativeValue(parseFloat($F("varDefFgnCurr")) * parseFloat($F("varPctPrem")), "");
					$("varICommAmt").value = getNaNAlternativeValue(parseFloat($F("varICommAmt")) * parseFloat($F("varPctPrem")), "");
					$("varIWtax").value = getNaNAlternativeValue(parseFloat($F("varIWtax")) * parseFloat($F("varPctPrem")), "");
				}
			
				$("varPrevCommAmt").value = parseFloat(nvl($F("txtCommAmt"), "0"));
				$("varPrevWtaxAmt").value = parseFloat(nvl($F("txtWtaxAmt"), "0"));
				$("varPrevInputVAT").value = parseFloat(nvl($F("txtInputVATAmt"), "0"));
		
				$("txtDrvCommAmt").value = formatCurrency(parseFloat(getDrvCommAmt($F("txtWtaxAmt"), $F("txtInputVATAmt"), $F("txtCommAmt"))));
			}
		
			if ($F("currentRowNo") == -1) {
				getGipiCommInvoice(afterCompute);
			}
		}
	});
	
	$("txtDisbComm").observe("change", function() {
		try{
			if (isNaN($F("txtDisbComm").replace(/,/g,""))) {
				showWaitingMessageBox("Invalid number.",imgMessage.ERROR,
					function() {
						$("txtDisbComm").value = formatCurrency($F("lastDisbComm").replace(/,/g,""));
						$("txtPremSeqNo").focus();
					}
				);
			} else {
				if ($F("varCommPayableParam") == 2 && $F("txtTranType") == 1) {
					$("txtDisbComm").value = formatCurrency($F("txtDisbComm").replace(/,/g,""));
					$("txtInputVATAmt").value = formatCurrency((parseFloat(nvl($F("varVATRt").replace(/,/g,""), "0"))/100) * (parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0"))));
					$("txtForeignCurrAmt").value = (parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0"))) / (parseFloat(nvl($F("txtConvertRate").replace(/,/g,""), "0")));
					$("varCFireNow").value = "Y";
				}
		
				$("controlVCommAmt").value = parseFloat(nvl($F("varPrevCommAmt").replace(/,/g,""), "0"));
				$("controlVWtaxAmt").value = parseFloat(nvl($F("varPrevWtaxAmt").replace(/,/g,""), "0"));
				$("controlVInputVAT").value = parseFloat(nvl($F("varPrevInputVAT").replace(/,/g,""), "0"));
		
				function formatAmounts() {
					$("txtCommAmt").value = formatCurrency(parseFloat($F("txtCommAmt").replace(/,/g,"")));
					$("txtWtaxAmt").value = formatCurrency(parseFloat($F("txtWtaxAmt").replace(/,/g,"")));
					$("txtInputVATAmt").value = formatCurrency(parseFloat($F("txtInputVATAmt").replace(/,/g,"")));
					$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")));
					$("txtDisbComm").value = formatCurrency(parseFloat($F("txtDisbComm").replace(/,/g,"")));
					}

				function afterGetInv() {
					if ($("chkDefCommTag").checked) {
						$("varDefFgnCurr").value = getNaNAlternativeValue(parseFloat($F("varDefFgnCurr")) * parseFloat($F("varPctPrem")), "");
						$("varICommAmt").value = getNaNAlternativeValue(parseFloat($F("varICommAmt")) * parseFloat($F("varPctPrem")), "");
						$("varIWtax").value = getNaNAlternativeValue(parseFloat($F("varIWtax")) * parseFloat($F("varPctPrem")), "");
					}

					$("varCFireNow").value = "Y";

					function func1() {
						validateCommAmt1();
						formatAmounts();
					}

					if (validateCommAmt()) {
						getGipiCommInvoice(func1);

					}else{
						getGipiCommInvoice(formatAmounts);
					}
				}
			}

		}catch(e){
			showErrorMessage("txtDsbComm change", e);
		}
	});

/* 	$("txtDisbComm").observe("focus", function() {
		if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
			$("lastDisbComm").value = $F("txtDisbComm");
			
			if ($F("currentRowNo") == -1) {
				getGipiCommInvoice();
			}
	
			if ($("chkDefCommTag").checked) {
				$("varDefFgnCurr").value = getNaNAlternativeValue(parseFloat($F("varDefFgnCurr")) * parseFloat($F("varPctPrem")), "");
				$("varICommAmt").value = getNaNAlternativeValue(parseFloat($F("varICommAmt")) * parseFloat($F("varPctPrem")), "");
				$("varIWtax").value = getNaNAlternativeValue(parseFloat($F("varIWtax")) * parseFloat($F("varPctPrem")), "");
			}
	
			$("varPrevCommAmt").value = parseFloat(nvl($F("txtCommAmt"), "0"));
			$("varPrevWtaxAmt").value = parseFloat(nvl($F("txtWtaxAmt"), "0"));
			$("varPrevInputVAT").value = parseFloat(nvl($F("txtInputVATAmt"), "0"));
	
			$("txtDrvCommAmt").value = formatCurrency(parseFloat(getDrvCommAmt($F("txtWtaxAmt"), $F("txtInputVATAmt"), $F("txtCommAmt"))));
		}
	});

	$("txtDisbComm").observe("change", function() {
		
		try{
			 if (isNaN($F("txtDisbComm").replace(/,/g,""))) {
				showWaitingMessageBox("Invalid number.",imgMessage.ERROR,
					function() {
						$("txtDisbComm").value = formatCurrency($F("lastDisbComm").replace(/,/g,""));
						$("txtPremSeqNo").focus();
					}
				);
			} else {
				if ($F("varCommPayableParam") == 2 && $F("txtTranType") == 1) {
					$("txtInputVATAmt").value = (parseFloat(nvl($F("varVATRt").replace(/,/g,""), "0"))/100) * (parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0")));
					$("txtForeignCurrAmt").value = (parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0"))) / (parseFloat(nvl($F("txtConvertRate").replace(/,/g,""), "0")));
					$("varCFireNow").value = "Y";
				}
		
				$("controlVCommAmt").value = parseFloat(nvl($F("varPrevCommAmt").replace(/,/g,""), "0"));
				$("controlVWtaxAmt").value = parseFloat(nvl($F("varPrevWtaxAmt").replace(/,/g,""), "0"));
				$("controlVInputVAT").value = parseFloat(nvl($F("varPrevInputVAT").replace(/,/g,""), "0"));
			
				//getGipiCommInvoice();
		
				if ($("chkDefCommTag").checked) {
					$("varDefFgnCurr").value = getNaNAlternativeValue(parseFloat($F("varDefFgnCurr")) * parseFloat($F("varPctPrem")), "");
					$("varICommAmt").value = getNaNAlternativeValue(parseFloat($F("varICommAmt")) * parseFloat($F("varPctPrem")), "");
					$("varIWtax").value = getNaNAlternativeValue(parseFloat($F("varIWtax")) * parseFloat($F("varPctPrem")), "");
				}
				$("varCFireNow").value = "Y";
		
				if (validateCommAmt()) {
					validateCommAmt1();
				}else{
					getGipiCommInvoice();
				}
			
				$("txtCommAmt").value = formatCurrency(parseFloat($F("txtCommAmt").replace(/,/g,"")));
				$("txtWtaxAmt").value = formatCurrency(parseFloat($F("txtWtaxAmt").replace(/,/g,"")));
				$("txtInputVATAmt").value = formatCurrency(parseFloat($F("txtInputVATAmt").replace(/,/g,"")));
				$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")));
				$("txtDisbComm").value = formatCurrency(parseFloat($F("txtDisbComm").replace(/,/g,"")));
			}
		}catch(e){
			showErrorMessage("txtDsbComm change", e);
		}  
	}); */
	
	$("btnInvoice").observe("click", function() {
		showGcopInvDetails();
	});

	$("btnCurrencyDetails").observe("click", function() {
		Effect.Appear($("currencyDiv"), {
			duration: 0.2
		});
	});

	$("btnHideCurrPage").observe("click", function() {
		Effect.Fade($("currencyDiv"), {
			duration: 0.2
		});
	});

	$("txtForeignCurrAmt").observe("change", function() {
		if (parseFloat($F("txtForeignCurrAmt")) == 0) {
			showMessageBox("Foreign Currency Amount should not be equal to zero.", imgMessage.INFO);
			return false;
		}

		if (isNaN($F("txtForeignCurrAmt").replace(/,/g,""))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
				function() {
					$("txtForeignCurrAmt").value = formatCurrency(nvl($F("lastForeignCurrAmt").replace(/,/g,""), formatCurrency(nvl($F("lastCommAmt").replace(/,/g,"")))));
					$("txtForeignCurrAmt").focus();
				}
			);
		} else {
			// chk_def_curr_amt
			if ($F("txtTranType") == 1) {
				if (roundNumber(parseFloat($F("txtForeignCurrAmt")),2) > roundNumber(parseFloat($F("varDefFgnCurr")),2)) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be greater than the outstanding balance!!!", imgMessage.INFO);
					return false;
				} else if (parseFloat($F("txtForeignCurrAmt")) < 0) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be less than the outstanding balance!!!", imgMessage.INFO);
					return false;
				} else if (parseFloat($F("txtForeignCurrAmt")) == 0) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be equal to zero!!!", imgMessage.INFO);
					return false;
				}
			} else if ($F("txtTranType") == 4) {
				if (roundNumber(parseFloat($F("txtForeignCurrAmt")),0) > roundNumber(Math.abs(parseFloat($F("varDefFgnCurr"))),0)) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be greater than the outstanding balance!!!", imgMessage.INFO);
					return false;
				} else if (parseFloat($F("txtForeignCurrAmt")) < 0) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be less than the outstanding balance!!!", imgMessage.INFO);
					return false;
				} else if (parseFloat($F("txtForeignCurrAmt")) == 0) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be equal to zero!!!", imgMessage.INFO);
					return false;
				}
			} else if ($F("txtTranType") == 2 || $F("txtTranType") == 3) {
				if (parseFloat($F("txtForeignCurrAmt")) > 0) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be greater than the outstanding balance!!!", imgMessage.INFO);
					return false;
				} else if (roundNumber(Math.abs(parseFloat($F("txtForeignCurrAmt"))), 2) > roundNumber(Math.abs(parseFloat($F("varDefFgnCurr"))), 2)) {
					$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");
					showMessageBox("Foreign currency amount entered should not be less than the outstanding balance!!!", imgMessage.INFO);
					return false;
				}
			}
			// end of chk_def_curr_amt
	
			$("txtCommAmt").value = getNaNAlternativeValue(parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) * parseFloat($F("txtConvertRate")), "");
	
			getGipiCommInvoice();
	
			if ($("chkDefCommTag").checked) {
				$("varDefFgnCurr").value = getNaNAlternativeValue(parseFloat($F("varDefFgnCurr")) * parseFloat($F("varPctPrem")), "");
				$("varICommAmt").value = getNaNAlternativeValue(parseFloat($F("varICommAmt")) * parseFloat($F("varPctPrem")), "");
				$("varIWtax").value = getNaNAlternativeValue(parseFloat($F("varIWtax")) * parseFloat($F("varPctPrem")), "");
			}
	
			if (validateCommAmt()) {
				$("txtInputVATAmt").value = getNaNAlternativeValue((parseFloat(nvl($F("varVATRt"),0)) / 100) * parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0")), "");
				validateCommAmt1();
				$("controlSumNetCommAmt").value = getNaNAlternativeValue(parseFloat(nvl($F("controlSumCommAmt").replace(/,/g,""), "0"))
												  + parseFloat(nvl($F("controlSumInpVAT").replace(/,/g,""), "0"))
												  - parseFloat(nvl($F("controlSumWtaxAmt").replace(/,/g,""), 0)), "");
			}

			$("lastForeignCurrAmt").value = $F("txtForeignCurrAmt");
		}
	});

	// page functions
	
	function clickCommPaytsRow(row) {
		try{
			$$("div#commPaytsTable div[name='rowCommPayts']").each(function(r) {
				if (row.id != r.id) {
					r.removeClassName("selectedRow");
				}
			});

			 var itemFields = ["TranType", "DspAssdName", "IssCd", "PremSeqNo", "DspLineCd", "DspIntmName", 
			          			"Particulars", "CommAmt", "DisbComm", "InputVATAmt", "WtaxAmt", "DrvCommAmt",
			          			"IntmNo", "CommTag", "DspPolicyId", "DspAssdNo", "CurrencyCd", "ConvertRate",
			          			"DspCurrencyDesc", "ForeignCurrAmt", "ParentIntmNo", "RecordNo", "RecordSeqNo"]; //added recordSeqNo by robert SR 19752 07.28.15

			row.toggleClassName("selectedRow");
			
			if (row.hasClassName("selectedRow")) {
				 for (var i = 0; i < itemFields.length; i++) {
					if (itemFields[i] == "CommAmt" || itemFields[i] == "InputVATAmt" || 
						itemFields[i] == "WtaxAmt" || itemFields[i] == "DrvCommAmt" || itemFields[i] == "ForeignCurrAmt") {
						
						$("txt"+itemFields[i]).value = formatCurrency(parseFloat(nvl($F("gcop"+itemFields[i]+row.down("input", 0).value), "0")));
						} else if(itemFields[i] == "DisbComm" ){
							$("txt"+itemFields[i]).value = $F("gcop"+itemFields[i]+row.down("input", 0).value) ==  "" ? "" : formatCurrency($F("gcop"+itemFields[i]+row.down("input", 0).value));
						}  else {
						$("txt"+itemFields[i]).value = $F("gcop"+itemFields[i]+row.down("input", 0).value);
					}
				}
				 
				defaultCommissionAmt= $F("gcopCommAmt"+row.down("input", 0).value);

				if ($F("gcopPrintTag"+row.down("input", 0).value) == "Y") {
					$("chkPrintTag").checked = true;
				}

				if ($F("gcopDefCommTag"+row.down("input", 0).value) == "Y") {
					$("chkDefCommTag").checked = true;
				}

				$("currentRowNo").value = row.down("input", 0).value;

				// check: if record is not yet saved, do not disable fields
				$("recordSelectedTag").value = "Y";
				
				existingRecord = ($F("gcopChanged"+row.down("input", 0).value) == "N" ? true : false);

				//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
				if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
					if ($F("gcopChanged"+row.down("input", 0).value) == "N") {
						objAC.paytReqFlag == "N" ? enableCommPaytsFields() : disableCommPaytsFields();
					} else {
						if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
							enableCommPaytsFields();
						}
					}
				}

				if (/*(objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") &&*/ objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
					if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C" && objACGlobal.fromDvStatInq != 'Y'){  //added fromDvStatInq by Robert SR 5189 12.22.15 // andrew - 08.15.2012 SR 0010292
						nvl(objAC.paytReqFlag, "N") != "N" ? disableButton("btnDeleteRecord") : enableButton("btnDeleteRecord") ;
					}
					$("btnSaveRecord").value = "Update";
				}
				if(row.down("input", 29) != undefined) {
					$("varVATRt").value = row.down("input", 29).value;
				}
			} else {
				resetFields();
				//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D") {
				if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
					disableButton("btnDeleteRecord");
					$("btnSaveRecord").value = "Add";
				}
				existingRecord = false;
			}  
		}catch(e){
			showErrorMessage("clickCommPaytsRow", e);
		}
	}

	function resetFields() {
		try {
			var itemFields = ["TranType", "DspAssdName", "IssCd", "PremSeqNo", "DspLineCd", "DspIntmName", 
			          			"Particulars", "CommAmt", "DisbComm", "InputVATAmt", "WtaxAmt", "DrvCommAmt",
			          			"IntmNo", "CommTag", "DspPolicyId", "DspAssdNo", "CurrencyCd", "ConvertRate",
			          			"DspCurrencyDesc", "ForeignCurrAmt", "ParentIntmNo", "RecordNo", "RecordSeqNo"]; //added recordseqno by robert SR 19752 07.28.2015
	
			for (var i = 0; i < itemFields.length; i++) {
				$("txt"+itemFields[i]).value = "";
			}
	
			//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D" && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C") {
			if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
				$$("select").each(function(sel) {
					sel.enable();
				});
			}
	
			$("chkPrintTag").checked = true;
			$("chkDefCommTag").checked = true;
	
			//misc
			$("currentRowNo").value = -1;
			$("isIntmNoValidated").value = "N";
			$("lastPremSeqNo").value = "";
			$("lastCommAmt").value = "";
			$("lastForeignCurrAmt").value = "";
			$("lastInputVATAmt").value = "";
			$("lastDisbComm").value = "";
			$("recordSelectedTag").value = "N"; // used for checking in intm dropdown list, also used to check if there is a record selected
	
			//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D" && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C") {
			if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
				enableCommPaytsFields();
			}
	
			Effect.Fade($("currencyDiv"), {
				duration: 0.2
			});
	
			disableButton("btnInvoice");
	
			// enable/disable fields
			// $("txtPremSeqNo").readOnly = true; // removed (06.14.2011)
			//$("txtDspIntmName").readOnly = false; // removed (emman 06.08.2011)
			//if ((objACGlobal.orFlag != "P" || objACGlobal.orTag == "*") && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D" && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C") {
			if (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR" && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" && objACGlobal.orFlag != "C" && objACGlobal.orFlag != "D"){	
				$("txtCommAmt").readOnly = false;
				$("txtInputVATAmt").readOnly = false;
				
				$("chkPrintTag").enable();
				$("chkDefCommTag").disable();
			}
			$("txtTranType").focus();
			
			defaultCommissionAmt = "";
		} catch(e){
			showErrorMessage("resetFields", e);
		}
	}

	// reset text fields, used when fields tran_type, iss_cd, and prem_seq_no were changed (emman 06.13.2011)
	// exclude stated fields from being cleared
	function resetFields2() {
		var itemFields = ["DspAssdName","DspLineCd", "DspIntmName", 
		          			"Particulars", "CommAmt", "DisbComm", "InputVATAmt", "WtaxAmt", "DrvCommAmt",
		          			"IntmNo", "CommTag", "DspPolicyId", "DspAssdNo", "CurrencyCd", "ConvertRate",
		          			"DspCurrencyDesc", "ForeignCurrAmt", "ParentIntmNo", "RecordNo"];

		for (var i = 0; i < itemFields.length; i++) {
			$("txt"+itemFields[i]).value = "";
		}
		defaultCommissionAmt = "";
	}

	function enableCommPaytsFields() {
		$$("input[type='checkbox']").each(function (chk) {
			chk.enable();
		});

		$$("select").each(function (sel) {
			sel.enable();
		});

		// $("txtDspIntmName").readOnly = false; // removed (emman 06.08.2011)
		$("txtInputVATAmt").readOnly = false;
		$("txtCommAmt").readOnly = false;
		$("txtParticulars").readOnly = false;
		$("txtDisbComm").readOnly = false;
		$("txtForeignCurrAmt").readOnly = false;
		$("txtPremSeqNo").readOnly = false; // added (emman 06.08.2011)

		//$("txtCurrencyCd").readOnly = true;
		//$("txtDspCurrencyDesc").readOnly = true;
		//$("txtConvertRate").readOnly = true;

		enableButton("btnSaveRecord");
		enableButton("btnCurrencyDetails");

		/*
		// check the fields fields to be enabled/disabled
		if ($F("txtPremSeqNo").blank()) {
			$("txtIssCd").enable();
		}

		if ($F("txtIssCd").blank()) {
			$("txtTranType").enable();
			$("txtPremSeqNo").readOnly = true;
		} else {
			$("txtTranType").disable();
			$("txtPremSeqNo").readOnly = false;
		}*/ // removed (emman 06.14.2011)
	}

	function disableCommPaytsFields() {
		$$("input[type='checkbox']").each(function (chk) {
			chk.disable();
		});

		$$("select").each(function (sel) {
			sel.disable();
		});

		$("txtTranType").disable();
		$("txtIssCd").disable();
		$("txtPremSeqNo").readOnly = true;
		// $("txtDspIntmName").readOnly = true; // removed (emman 06.08.2011)
		$("txtInputVATAmt").readOnly = true;
		$("txtCommAmt").readOnly = true;
		$("txtParticulars").readOnly = true;
		$("txtDisbComm").readOnly = true;
		$("txtForeignCurrAmt").readOnly = true;

		disableButton("btnSaveRecord");
		disableButton("btnInvoice");
	}

	// check if required fields have values
	function checkRequiredFields() {
		var ok = true;
		var item = "";

		$$("[class='required']").each(function(field) {
			if (field.value.blank()) {
				if (field.id == "txtTranType") {
					item = "Transaction Type";
				} else if (field.id == "txtIssCd") {
					item = "Bill No";
				} else if (field.id == "txtPremSeqNo") {
					item = "Bill No";
				} else if (field.id == "txtCommAmt") {
					item = "Commission Amount";
				} else if (field.id == "txtDisbComm") {
					item = "Actualy Disbursed Comm";
				} else if (field.id == "txtWtaxAmt") {
					item = "Withholding Tax";
				} else if (field.id == "txtDspIntmName" && $F("txtIntmNo").blank()) {
					item = "Intermediary";
				}

				if (field.id != "txtDisbComm") {
					ok = false;
				}
				return false;
			}
		});

		if (!ok) {
			showMessageBox("User supplied value is required for " + item + ".", imgMessage.ERROR);
		}

		return ok;
	}

	// Add new comm payts record or update existing comm payts record
	function saveRecord() {
		var content;
		var ok = true;
		if ($F("btnSaveRecord") == "Add") {
			$$("div[name='rowCommPayts']").each(function(row) {
				if (row.down("input", 4).value == $F("txtIssCd") && row.down("input", 5).value == $F("txtPremSeqNo") && row.down("input", 6).value == $F("txtIntmNo") &&
						($F("txtTranType") == 1 || $F("txtTranType") == 3)) { //added by robert SR 19752 07.28.2015
					if ($F("gcopInvModalTag") == "N") {
						resetFields();
						showMessageBox("Warning: Row with same TRAN ID,INTM. NO.,BILL NO. already exists.", imgMessage.WARNING);
					}
					ok = false;
				}
			});
		}

		if (!ok) {
			return false;
		}

		// PRE-INSERT
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=preInsertGIACS020CommPayts", {
			method: "GET",
			parameters: {
				gaccTranId: objACGlobal.gaccTranId,
				intmNo: $F("txtIntmNo"),
				parentIntmNo: $F("txtParentIntmNo"),
				commTag: $F("txtCommTag"),
				recordNo: $F("txtRecordNo")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (nvl(result.message, "SUCCESS") == "SUCCESS") {
						$("txtParentIntmNo").value = result.parentIntmNo;
						$("txtRecordNo").value = result.recordNo;

						content = getUpdatedContent();

						if ($F("btnSaveRecord") == "Add") {
							$("commPaytsListLastNo").value = parseInt($F("commPaytsListLastNo")) + 1;
							
							var itemTable = $("commPaytsTableContainer");
							var newDiv = new Element("div");
							newDiv.setAttribute("id", "row"+$F("commPaytsListLastNo"));
							newDiv.setAttribute("name", "rowCommPayts");
							newDiv.addClassName("tableRow");
							newDiv.update(content);
							itemTable.insert({bottom : newDiv});
							
							newDiv.observe("mouseover",
								function(){
									newDiv.addClassName("lightblue");
							});
				
							newDiv.observe("mouseout",
								function(){
									newDiv.removeClassName("lightblue");
							});
				
							newDiv.observe("click",
								function(){
									clickCommPaytsRow(newDiv);
							});
				
 							Effect.Appear(newDiv, {
 								duration: .2
 							});

							checkIfToResizeTable("commPaytsTableContainer", "rowCommPayts");
							checkTableIfEmpty("rowCommPayts", "commPaytsTableMainDiv");

							$$("div[name='commPaytsRowDeleted']").each(function(row) {
								if (row.down("input", 1).value == parseInt(newDiv.down("input",6).value) 
										&& row.down("input", 2).value == parseInt(newDiv.down("input", 4).value)
										&& row.down("input", 2).value == parseInt(newDiv.down("input", 5).value)) {
									row.remove();
									return false;
								}
							});

							if ($F("gcopInvModalTag") == "N") {
								resetFields();
							}
						}else{
								$("row"+$F("currentRowNo")).update(content);
								$("row"+$F("currentRowNo")).update(content).removeClassName("selectedRow");;
								resetFields();
								$("btnSaveRecord").value = "Add";
								disableButton("btnDeleteRecord");
						}
						computeTotalAmtValues();
					} else {
						showMessageBox(result.message, imgMessage.INFO);
					}
				} else {
					showMessageBox(response.responseText,imgMessage.ERROR);
				}
			}
		});
	}

	//Delete commPayts record
	function deleteRecord() {
		var row = $("row"+$F("currentRowNo"));

		//execute key-delrec
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=executeGIACS020DeleteRecord", {
			evalScripts: true,
			asynchrnous: false,
			method: "GET",
			parameters: {
				issCd: row.down("input", 4).value,
				premSeqNo: row.down("input", 5).value,
				intmNo: row.down("input", 6).value,
				commAmt: row.down("input", 9).value
			},
			onComplete: function(response) {
				// add the record to delete list, save the gacc_tran_id, item_no, and transaction_type,
				// add only if record is not recently added and there is no existing refund for this bill no. and intm no.
				if (nvl(response.responseText, "SUCCESS") == "SUCCESS") {
					if (checkErrorOnResponse(response)) {
						if (row.down("input", 1).value != "Y") {
							var deleteDiv = $("deleteCommPaytsList");
							var newDiv = new Element("div");
							newDiv.setAttribute("id", "commPaytsRowDeleted"+row.down("input", 3).value+"-"+row.down("input", 4).value+"-"+row.down("input",5).value);
							newDiv.setAttribute("name", "commPaytsRowDeleted");
							newDiv.update(
									'<input type="hidden" id="deletedGcopGaccTranId" 		name="deletedGcopGaccTranId" 	  value="'+row.down("input", 2).value+'" />' +
									'<input type="hidden" id="deletedGcopIntmNo" 			name="deletedGcopIntmNo" 	  	  value="'+row.down("input", 6).value+'" />' +
									'<input type="hidden" id="deletedGcopIssCd" 			name="deletedGcopIssCd"		 	  value="'+row.down("input", 4).value+'" />' +
									'<input type="hidden" id="deletedGcopPremSeqNo" 		name="deletedGcopPremSeqNo" 	  value="'+row.down("input", 5).value+'" />' +   //added by robert SR 19752 07.28.2015
									'<input type="hidden" id="deletedCommTag" 				name="deletedCommTag" 	  		  value="'+row.down("input", 23).value+'" />' +  //added by robert SR 19752 07.28.2015
									'<input type="hidden" id="deletedRecordNo" 				name="deletedRecordNo" 	  	  	  value="'+row.down("input", 24).value+'" />' +  //added by robert SR 19752 07.28.2015
									'<input type="hidden" id="deletedRecordSeqNo" 			name="deletedRecordSeqNo"		  value="'+row.down("input", 30).value+'" />'    //added by robert SR 19752 07.28.2015
									);
						
							deleteDiv.appendChild(newDiv);
						}
				
						// delete the record from the main container div
						Effect.Fade(row, {
							duration: .2,
							afterFinish: function() {
								$("controlSumCommAmt").value = parseFloat(nvl($F("controlSumCommAmt"), "0")) - parseFloat(nvl(row.down("input", 9).value, "0"));
								$("controlSumInpVAT").value = roundNumber(parseFloat(nvl($F("controlSumInpVAT"), "0")) - parseFloat(nvl(row.down("input", 10).value, "0")), 2);
								$("controlSumWtaxAmt").value = parseFloat(nvl($F("controlSumWtaxAmt"), "0")) - parseFloat(nvl(row.down("input", 11).value, "0"));
								$("controlSumNetCommAmt").value = roundNumber(parseFloat(nvl($F("controlSumNetCommAmt"), "0")) - parseFloat(nvl(row.down("input", 12).value, "0")), 2);
							
								row.remove();
								resetFields();
								disableButton("btnDeleteRecord"); //added by reymon 03252013
								$("btnSaveRecord").value = "Add"; //added by reymon 03252013
								computeTotalAmtValues();
								checkIfToResizeTable("commPaytsTableContainer", "rowCommPayts");
								checkTableIfEmpty("rowCommPayts", "commPaytsTableMainDiv");
							}
						});
					} else {
						showMessagebox(response.responseText, imgMessage.INFO);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	//Get contents for updated row
	function getUpdatedContent() {
		var rowNo = parseInt($F("commPaytsListLastNo")) + 1;
		$$("div[name='rowCommPayts'].selectedRow").each(function(row) {
			rowNo = (row.id).replace(/row/g, '');
		});
		var content = "";
		
		if (rowNo >= 0) {
			var count = rowNo;
			var status = "Y";
			var gaccTranId = objACGlobal.gaccTranId;
			var tranType = $F("txtTranType");
			var issCd = $F("txtIssCd");
			var premSeqNo = $F("txtPremSeqNo");
			var intmNo = $F("txtIntmNo");
			var dspLineCd = $F("txtDspLineCd");
			var dspAssdName = escapeHTML2($F("txtDspAssdName"));//changed changeSingleAndDoubleQuotes2 to escapeHTML2 by reymon 03252013
			var commAmt = $F("txtCommAmt");
			var inputVATAmt = $F("txtInputVATAmt");
			var wtaxAmt = $F("txtWtaxAmt");
			var drvCommAmt = $F("txtDrvCommAmt");
			var printTag = $("chkPrintTag").checked ? "Y" : "N";
			var defCommTag = $("chkDefCommTag").checked ? "Y" : "N";
			var particulars =  changeSingleAndDoubleQuotes2($F("txtParticulars"));
			var currencyCd = $F("txtCurrencyCd");
			var dspCurrencyDesc = $F("txtDspCurrencyDesc");
			var convertRate = $F("txtConvertRate");
			var foreignCurrAmt = $F("txtForeignCurrAmt");
			var parentIntmNo = $F("txtParentIntmNo");
			var userId = "";
			var lastUpdate = "";
			var commTag = $F("txtCommTag");
			var recordNo = $F("txtRecordNo");
			var disbComm = $F("txtDisbComm");
			var dspPolicyId = $F("txtDspPolicyId");
			var dspIntmName = escapeHTML2($F("txtDspIntmName"));//added escapeHTML2 by reymon 03252013
			var dspAssdNo = $F("txtDspAssdNo");
			var recordSeqNo = $F("txtRecordSeqNo"); //added by robert SR 19752 07.28.2015
			
			var tranTypeName = ($F("txtTranType").blank()) ? "" : 
				(($F("txtTranType") == 1 || $F("txtTranType") == 3) ? "Commission" : "Refund/Reclass");
			var billNo = (issCd.blank() || premSeqNo.blank()) ? "---" : issCd + "-" + premSeqNo;
			
			
			dspIntmName =  unescapeHTML2(dspIntmName);  //added by jeffdojello 12.06.2013
			
			content = 
				'<label style="width: 120px;font-size: 11px; text-align: center" id="lblTranType"		name="lblTranType">'+((tranTypeName.blank()) ? "---" : tranTypeName)+'</label>' +
				'<label style="width:  64px;font-size: 11px; text-align: center" id="lblBillNo"		name="lblBillNo">'+billNo+'</label>' +
				'<label style="width: 153px;font-size: 11px; text-align: center" id="lblIntermediary"	name="lblIntermediary">'+((dspIntmName.blank()) ? "---" : dspIntmName.truncate(20, "..."))+'</label>' +
				'<label style="width: 132px;font-size: 11px; text-align: right"  id="lblCommAmt"		name="lblCommAmt">'+commAmt+'</label>' +
				'<label style="width: 126px;font-size: 11px; text-align: right"  id="lblInputVatAmt"	name="lblInputVATAmt">'+inputVATAmt+'</label>' +
				'<label style="width: 108px;font-size: 11px; text-align: right"  id="lblWholdingTax"	name="lblWholdingTax">'+wtaxAmt+'</label>' +
				'<label style="width: 175px;font-size: 11px; text-align: right"  id="lblNetCommAmt"	name="lblNetCommAmt">'+drvCommAmt+'</label>' +
				'<input type="hidden"	id="count'+rowNo+'"					name="count"				value="'+rowNo+'" />' +
				'<input type="hidden"	id="gcopChanged'+rowNo+'"			name="gcopChanged"			value="'+status+'" />' +
				'<input type="hidden"	id="gcopGaccTranId'+rowNo+'"		name="gcopGaccTranId"		value="'+gaccTranId+'" />' +
				'<input type="hidden"	id="gcopTranType'+rowNo+'"			name="gcopTranType"			value="'+tranType+'" />' +
				'<input type="hidden"	id="gcopIssCd'+rowNo+'"				name="gcopIssCd"			value="'+issCd+'" />' +
				'<input type="hidden"	id="gcopPremSeqNo'+rowNo+'"			name="gcopPremSeqNo"		value="'+premSeqNo+'" />' +
				'<input type="hidden"	id="gcopIntmNo'+rowNo+'"			name="gcopIntmNo"			value="'+intmNo+'" />' +
				'<input type="hidden"	id="gcopDspLineCd'+rowNo+'"			name="gcopDspLineCd"		value="'+dspLineCd+'" />' +
				'<input type="hidden"	id="gcopDspAssdName'+rowNo+'"		name="gcopDspAssdName"		value="'+dspAssdName+'" />' +
				'<input type="hidden"	id="gcopCommAmt'+rowNo+'"			name="gcopCommAmt"			value="'+commAmt.replace(/,/g,"")+'" />' +
				'<input type="hidden"	id="gcopInputVATAmt'+rowNo+'"		name="gcopInputVATAmt"		value="'+inputVATAmt.replace(/,/g,"")+'" />' +
				'<input type="hidden"	id="gcopWtaxAmt'+rowNo+'"			name="gcopWtaxAmt"			value="'+wtaxAmt.replace(/,/g,"")+'" />' +
				'<input type="hidden"	id="gcopDrvCommAmt'+rowNo+'"		name="gcopDrvCommAmt"		value="'+drvCommAmt.replace(/,/g,"")+'" />' +
				'<input type="hidden"	id="gcopPrintTag'+rowNo+'"			name="gcopPrintTag"			value="'+printTag+'" />' +
				'<input type="hidden"	id="gcopDefCommTag'+rowNo+'"		name="gcopDefCommTag"		value="'+defCommTag+'" />' +
				'<input type="hidden"	id="gcopParticulars'+rowNo+'"		name="gcopParticulars"		value="'+particulars+'" />' +
				'<input type="hidden"	id="gcopCurrencyCd'+rowNo+'"		name="gcopCurrencyCd"		value="'+currencyCd+'" />' +
				'<input type="hidden"	id="gcopDspCurrencyDesc'+rowNo+'"	name="gcopCurrDesc"			value="'+dspCurrencyDesc+'" />' +
				'<input type="hidden"	id="gcopConvertRate'+rowNo+'"		name="gcopConvertRate"		value="'+convertRate+'" />' +
				'<input type="hidden"	id="gcopForeignCurrAmt'+rowNo+'"	name="gcopForeignCurrAmt"	value="'+foreignCurrAmt.replace(/,/g,"")+'" />' +
				'<input type="hidden"	id="gcopParentIntmNo'+rowNo+'"		name="gcopParentIntmNo"		value="'+parentIntmNo+'" />' +
				'<input type="hidden"	id="gcopUserId'+rowNo+'"			name="gcopUserId"			value="'+userId+'" />' +
				'<input type="hidden"	id="gcopLastUpdate'+rowNo+'"		name="gcopLastUpdate"		value="'+lastUpdate+'" />' +
				'<input type="hidden"	id="gcopCommTag'+rowNo+'"			name="gcopCommTag"			value="'+commTag+'" />' +
				'<input type="hidden"	id="gcopRecordNo'+rowNo+'"			name="gcopRecordNo"			value="'+recordNo+'" />' +
				'<input type="hidden"	id="gcopDisbComm'+rowNo+'"			name="gcopDisbComm"			value="'+disbComm.replace(/,/g,"")+'" />' +
				'<input type="hidden"	id="gcopDspPolicyId'+rowNo+'"		name="gcopDspPolicyId"		value="'+dspPolicyId+'" />' +
				'<input type="hidden"	id="gcopDspIntmName'+rowNo+'"		name="gcopDspIntmName"		value="'+dspIntmName+'" />' +
				'<input type="hidden"	id="gcopDspAssdNo'+rowNo+'"			name="gcopDspAssdNo"		value="'+dspAssdNo+'" />' +
				'<input type="hidden"	id="gcopVatRt'+rowNo+'"			name="gcopVatRt"		value="'+$F("varVATRt")+'" />'+
				'<input type="hidden"	id="gcopBillGaccTranId'+rowNo+'"			name="gcopBillGaccTranId"		value="'+$F("txtBillGaccTranId")+'" />' +
				'<input type="hidden"	id="gcopRecordSeqNo'+rowNo+'"			name="gcopRecordSeqNo"			value="'+recordSeqNo+'" />' //added by robert SR 19752 07.28.15
				;
				
        		// gcopChanged is the tag to check if this is a new or an updated record.
    			// 'Y' if changed, 'N' if there is no change
		}

		return content;
	}

	// compute total amount values
	function computeTotalAmtValues() {
		var sumCommAmt = 0;
		var sumInpVAT = 0;
		var sumWtaxAmt = 0;
		var sumNetCommAmt = 0;

		$$("div[name='rowCommPayts']").each(function(row) {
			sumCommAmt    = sumCommAmt 	  + roundNumber(parseFloat(nvl(row.down("input",  9).value, "0")), 2);
			sumInpVAT     = sumInpVAT 	  + roundNumber(parseFloat(nvl(row.down("input", 10).value, "0")), 2);
			sumWtaxAmt 	  = sumWtaxAmt    + roundNumber(parseFloat(nvl(row.down("input", 11).value, "0")), 2);
			sumNetCommAmt = sumNetCommAmt + roundNumber(parseFloat(nvl(row.down("input", 12).value, "0")), 2);

			$("controlSumCommAmt").value = sumCommAmt;
			$("controlSumInpVAT").value = sumInpVAT;
			$("controlSumWtaxAmt").value = sumWtaxAmt;
			$("controlSumNetCommAmt").value = sumNetCommAmt;
		});

		$("lblSumCommAmt").innerHTML = formatCurrency(parseFloat(nvl($F("controlSumCommAmt"), "0")));
		$("lblSumInputVATAmt").innerHTML = formatCurrency(parseFloat(nvl($F("controlSumInpVAT"), "0")));
		$("lblSumWtaxAmt").innerHTML = formatCurrency(parseFloat(nvl($F("controlSumWtaxAmt"), "0")));
		$("lblSumNetCommAmt").innerHTML = formatCurrency(parseFloat(nvl($F("controlSumNetCommAmt"), "0")));
	}

	// module functions and validations
	
	// GCOP.tran_type PRE-TEXT-ITEM
	function gcopTranTypePreTextItem() {
		if ($F("txtTranType") == 2 || $F("txtTranType") == 4) {
			$("varTranType").value = -1;
		} else {
			$("varTranType").value = 1;
		}
	}

	// GCOP.prem_seq_no KEY-LISTVAL
	function premSeqNoListVal() {
		$("varLOVTranType").value = $F("txtTranType");
		$("varLOVIssCd").value = $F("txtIssCd");

		if (!$F("txtTranType").blank() && !$F("txtIssCd").blank()) {
			Modalbox.show(contextPath+"/GIACCommPaytsController?action=showBillNoDetails&tranType="+$F("txtTranType")+"&issCd="+$F("txtIssCd") , 
					  {title: "Bill No", 
					  width: 400,
					  asynchronous: false});
		}
	}

	// PROCEDURE get_gipi_comm_invoice
	function getGipiCommInvoice(func) {
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=getGipiCommInvoice", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				issCd : $F("txtIssCd"),
				premSeqNo : $F("txtPremSeqNo"),
				intmNo : $F("txtIntmNo"),
				convertRate : $F("txtConvertRate"),
				currencyCd : $F("txtCurrencyCd"),
				iCommAmt : $F("varICommAmt").replace(/,/g,""),
				iWtax : $F("varIWtax").replace(/,/g,""),
				currDesc : $F("txtDspCurrencyDesc"),
				defFgnCurr : $F("varDefFgnCurr").replace(/,/g,"")
				},
			onComplete: function(response) {
				//var result = response.responseText.toQueryParams();
				var result = JSON.parse(response.responseText);
				if (nvl(result.message, "SUCCESS") == "SUCCESS") {
					$("txtConvertRate").value = result.convertRate;
					$("txtCurrencyCd").value = result.currencyCd;
					$("varICommAmt").value = result.iCommAmt;
					$("varIWtax").value = result.iWtax;
					$("txtDspCurrencyDesc").value = result.currDesc;
					$("varDefFgnCurr").value = result.defFgnCurr;

					if(func!=null) 
						func();
				} else {
					resetFields();
					showMessageBox(result.message, imgMessage.WARNING);
					return false;
				}
			}
		});
	}

	function validateGiacs020Intermediary() {
		if ($F("currentRowNo") != -1) {
			if ($F("recordSelectedTag") ==  "Y" && $F("gcopChanged"+$F("currentRowNo")) == "N") return false;
		}
		
		if (chkModifiedComm() && validateGIACS020BillNo()) {	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
			validateNoPremPayt();
		}
		
		//SR#20909 :: john dolon 11.6.2015
	    function validateNoPremPayt(){
	        if ($F("noPremPayt") == "Y"){
	            new Ajax.Request(contextPath+"/GIACCommPaytsController?action=checkGcopInvChkTag", {
	                evalScripts: true,
	                asynchronous: true,
	                method: "GET",
	                parameters: {
	                    checked: "Y",
	                    issCd: $F("txtIssCd"),
	                    premSeqNo: $F("txtPremSeqNo"),
	                    commTagDisplayed: ($("chkDefCommTag").style.display == "none") ? "N" : "Y",
	                    tranType: $F("txtTranType"),
	                    varCommPayableParam: $F("varCommPayableParam")
	                },
	                onComplete: function(response) {
	                    if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
	                        var result = response.responseText.toQueryParams();
	                        var result2 = objACGlobal.checkRelCommWUnprintedOr($F("txtIssCd"),$F("txtPremSeqNo"));
	                        if (result2.message == "ALLOWED") {
	                            showConfirmBox("Confirmation", "The premium payment of bill no. " + result2.issCd + "-" + result2.premSeqNo + " is not yet printed. "+result2.refNo +'.'+
	                                    "Do you want to continue?",
	                                    "Yes", "No",
	                                    function() {
	                                        if (result.message == "SUCCESS") {
	                                        	getIntermediary();
	                                        } else if (result.message == "PARAM2_OVERWRITE") {
	                                            showCommPaytConfirmation(result);
	                                        } else if ($F("noPremPayt") != null && $F("noPremPayt") == "Y"){
	                                        	if ($F("accessMC") == "FALSE" && $F("accessAU") == "FALSE"){
	                                        		showMessageBox(result.message, imgMessage.INFO);
	                                            } else {
	                                            	showCommPaytConfirmation(result);
	                                            }
	                                        } /* else if ($F("accessMC") == "FALSE"){
	                                            showMessageBox(result.message, imgMessage.INFO);
	                                        }  */else {
	                                            showMessageBox(result.message, imgMessage.INFO);
	                                        }
	                                    },
	                                    function() {
	                                        null;
	                                    }
	                            );
	                        }else if (result2.message == "NOT_ALLOWED") {
	                            showMessageBox( "The premium payment of bill no. " + result2.issCd + "-" + result2.premSeqNo + " is not yet printed. "+result2.refNo +'.','I');
	                        }
	                        
	                        if (result2.message != "ALLOWED") {
	                            if (result.message == "SUCCESS") {
	                            	getIntermediary();
	                            } else if (result.message == "PARAM2_OVERWRITE") {
	                                if ($F("noPremPayt") != null){
	                                    if ($F("noPremPayt") == "N" && $F("accessMC") == "TRUE"){
	                                        showConfirmBox("", "Policy is not yet fully paid. Do you wish to override it?",
	                                                "Yes", "No",
	                                                function() {
	                                        			getIntermediary();
	                                                },
	                                                function() {
	                                                    null;
	                                                }
	                                        );
	                                    }else if ($F("noPremPayt") == "Y"){
	                                    	showCommPaytConfirmation(result);
	                                    }
	                                }
	                            } else if ($F("noPremPayt") != null && $F("noPremPayt") == "Y"){
	                            	if ($F("accessMC") == "FALSE" && $F("accessAU") == "FALSE"){
                                		showMessageBox(result.message, imgMessage.INFO);
                                    } else {
                                    	showCommPaytConfirmation(result);
                                    }
                                } /* else if ($F("accessMC") == "FALSE"){
                                    showMessageBox(result.message, imgMessage.INFO);
                                }  */ else {
	                                showMessageBox(result.message, imgMessage.INFO);
	                            }
	                        }
	                    
	                    }
	                }
	            });
	        } else if ($F("noPremPayt") == "N"){
	        	getIntermediary();
	        }
	    }
		
		function checkingIfPaidOrUnpaid(){
			new Ajax.Request(contextPath+"/GIACCommPaytsController?action=checkingIfPaidOrUnpaid", {
                evalScripts: true,
                asynchronous: true,
                method: "GET",
                parameters: {
                    issCd: $F("txtIssCd"),
                    premSeqNo: $F("txtPremSeqNo")
                },
                onComplete: function(response) {
                    if(checkErrorOnResponse(response)){ //Modified by Jerome Bautista 03.04.2016 SR 21279
                    	if(response.responseText == "NO PAYMENT"){
                    		if ($F("accessAU") == "FALSE"){
                    			showOverrideAU();
                    		}
                    	} else if(response.responseText == "PARTIAL PAYMENT"){
                    		getIntermediary();
                    	} 
                    }
                }
            });
		}
		
		function showCommPaytConfirmation(res){
	        showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
	                "Yes", "No",
	                function(){
	                    if ($F("accessAU") == "FALSE"){
	                    	checkingIfPaidOrUnpaid();
	                    }else{
	                    	getIntermediary();
	                    }
	                },
	                function(){    // no for commission payment
	                    null;
	                }
	        );
	    }
		
		function showOverrideAU(){
			showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
                    "Yes", "No",
                    function() {
                        showGenericOverride("GIACS020", "AU",
                                function(ovr, userId, result){
                                    if(result == "FALSE"){
                                        showMessageBox(userId + " is not allowed to process payments for unpaid premium.", imgMessage.ERROR);
                                        $("txtOverrideUserName").clear();
                                        $("txtOverridePassword").clear();
                                    } else if(result == "TRUE"){
                                        getIntermediary();
                                        ovr.close();
                                        delete ovr;                                                                            
                                    }
                                }, null);
                    }, null);
		}
		
		//getCommPaytsIntermediary(); uncomment later
		// added to accomodate multiple intermdiary with commissions - irwin
		
		function getIntermediary(){
			new Ajax.Request(contextPath+"/GIACCommPaytsController?action=getIntermediary", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					tranType: $F("txtTranType"),
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					//intmNo: $F("txtIntmNo"),
					//intmName: $F("txtDspIntmName"),
					varVFromSums: $F("varVFromSums"),
					onLOV:		objGIACS020.onLOV		// shan 10.16.2014
				//	keyword: $F("keyword")
				},
				onCreate: showNotice("Retrieving Intermediary, please wait..."),
				onComplete: function(response) {
					hideNotice();
					if(checkErrorOnResponse(response)) {
						//var result = response.responseText.toQueryParams();
						var result = JSON.parse(response.responseText);
						//						
						if(parseInt(result.size)> 1){
							showGcopInvDetails();
							resetFields2();
						}else if(parseInt(result.size) == 1){
							$("txtIntmNo").value = result.intmNo;
							$("txtDspIntmName").value = result.intmName;
							
							$("varCg$Dummy").value = "1";
							$("varPTranType").value = "";
							if ($F("txtWtaxAmt").blank()) {
								$("controlVWtaxAmt").value = 0;
							}
							$("controlVCommAmt").value = nvl($F("txtCommAmt"), 0);
							$("controlVInputVAT").value = nvl($F("txtInputVATAmt"), 0);
							
							//added by jeffdojello 12.06.2013
							$("txtCommAmt").value = formatCurrency(result.commAmt);
							$("txtWtaxAmt").value = formatCurrency(result.wtax);
							$("txtInputVATAmt").value = formatCurrency(result.invatAmt);
							$("txtForeignCurrAmt").value = formatCurrency(result.commAmt);
							defaultCommissionAmt = (result.commAmt);
							//------------------------------

							validateIntmNo(); 
							
							/*$("txtCommAmt").focus(); //moved inside validateIntmNo()
							validateGcopCommAmt();*/
						}else{
							validateIntmNo(); 
							/*$("txtCommAmt").focus(); 
							validateGcopCommAmt();*/
						}
						
					} else {
						showMessageBox(response.responseText,imgMessage.ERROR);
					}
				}
			});
		}
	}
	
	// start : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
	function validateGIACS020BillNo(issCd, premSeqNo){
		var result = true;
		new Ajax.Request(contextPath+"/GIACCommPaytsController", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				action:	"validateGIACS020BillNo",
				tranType: $F("txtTranType"),
				issCd: nvl(issCd, $F("txtIssCd")),
				premSeqNo: nvl(premSeqNo, $F("txtPremSeqNo"))
			},
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {					
					if (response.responseText != "SUCCESS"){
						showMessageBox(response.responseText, imgMessage.INFO);
						result = false;
						return false;
					}
				} else {
					showMessageBox(response.responseText,imgMessage.ERROR);
					result = false;
					return false;
				}
			}
		});
		
		return result;
	}
	
	objACGlobal.validateGIACS020BillNo = validateGIACS020BillNo;
	// end : SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
	
	// to compensate invoice will multiple intermediaries = irwin
	function getCommPaytsIntermediary2() {
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=getIntermediary", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				tranType: $F("txtTranType"),
				issCd: $F("txtIssCd"),
				premSeqNo: $F("txtPremSeqNo")
			},
			onComplete: function(response) {
				if(checkErrorOnResponse(response)) {
					//var result = response.responseText.toQueryParams();
					var result = JSON.parse(response.responseText);
					
					$("txtIntmNo").value = result.intmNo;
					$("txtDspIntmName").value = result.intmName;
				} else {
					showMessageBox(response.responseText,imgMessage.ERROR);
				}
			}
		});
	}
	
	//added by steven 09.12.2014
	function checkRelCommWUnprintedOr(issCd,premSeqNo) {
		try {
			var obj = [];
			new Ajax.Request(contextPath + "/GIACCommPaytsController", {
				parameters : {action : "checkRelCommWUnprintedOr",
							  gaccTranId:	objACGlobal.gaccTranId,
							  issCd:		issCd,
							  premSeqNo:	premSeqNo},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						obj = JSON.parse(response.responseText);
						obj = obj[0];
					}
				}
			});
			return obj;
		} catch (e) {
			showErrorMessage("checkRelCommWUnprintedOr",e);
		}
	}
	objACGlobal.checkRelCommWUnprintedOr = checkRelCommWUnprintedOr;

	// Validate Intm No
	function validateIntmNo(checkUnprintedOR) {
		var ok = true;
	
		if ($F("isIntmNoValidated") == "N" && !$F("txtTranType").blank()
				&& !$F("txtIssCd").blank() && !$F("txtPremSeqNo").blank()) {
			if ($F("giacs020TranSource") == "DV") {
				$("txtCommTag").value = $F("tranSourceCommTag");
			} else {
				$("txtCommTag").value = "N";
			}
			var deletedExists = false;
			  
			$$("div#deleteCommPaytsList div[name='commPaytsRowDeleted']").each(function(r) {				
				if(r.down("input", 1).value == $F("txtIntmNo") && r.down("input", 2).value == $F("txtIssCd") 
						&& r.down("input", 3).value == $F("txtPremSeqNo")){
					deletedExists = true;
				}
			});

			new Ajax.Request(contextPath+"/GIACCommPaytsController?action=validateGIACS020IntmNo", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					intmNo:		$F("txtIntmNo"),
					gaccTranId:	objACGlobal.gaccTranId,
					tranType:	$F("txtTranType"),
					issCd:		$F("txtIssCd"),
					premSeqNo:	$F("txtPremSeqNo"),
					commTag:	deletedExists ? "Y" : $F("txtCommTag"),
					defCommTagDisplayed:	($("chkDefCommTag").style.display == "none") ? "N" : "Y", 
					commAmt:	$F("txtCommAmt").replace(/,/g,""),
					wtaxAmt:	$F("txtWtaxAmt").replace(/,/g,""),
					inputVATAmt:	$F("txtInputVATAmt").replace(/,/g,""),
					defCommTag:	$("chkDefCommTag").checked ? "Y" : "N",
					convertRate:	$F("txtConvertRate"),
					currencyCd:	$F("txtCurrencyCd"),
					currDesc:	$F("txtDspCurrencyDesc"),
					foreignCurrAmt:	$F("txtForeignCurrAmt").replace(/,/g,""),
					defWtaxAmt:	$F("txtDefWtaxAmt").replace(/,/g,""),
					drvCommAmt:	$F("txtDrvCommAmt").replace(/,/g,""),
					defCommAmt: $F("txtDefCommAmt").replace(/,/g,""),
					defInputVAT: $F("txtDefInputVAT").replace(/,/g,""),
					dspPolicyId: $F("txtDspPolicyId"),
					dspIntmName: $F("txtDspIntmName"),
					dspAssdNo: $F("txtDspAssdNo"),
					dspAssdName: $F("txtDspAssdName"),
					dspLineCd: $F("txtDspLineCd"),
					varVATRt:	$F("varVATRt"),
					varClrRec:	$F("varClrRec"),
					varVPolFlag: $F("varVPolFlag"),
					varHasPremium: $F("varHasPremium"),
					varCPremiumAmt: $F("varCPremiumAmt").replace(/,/g,""),
					varInvPremAmt: $F("varInvPremAmt").replace(/,/g,""),
					varOtherCharges: $F("varOtherCharges").replace(/,/g,""),
					varNotarialFee: $F("varNotarialFee").replace(/,/g,""),
					varPdPremAmt: $F("varPdPremAmt").replace(/,/g,""),
					varPctPrem: $F("varPctPrem").replace(/,/g,""),
					varCgDummy: $F("varCg$Dummy"),
					varCommPayableParam: $F("varCommPayableParam").replace(/,/g,""),
					varMaxInputVAT: $F("varMaxInputVAT").replace(/,/g,""),
					varLastWtax: $F("varLastWtax").replace(/,/g,""),
					varInvoiceButt: $F("varInvoiceButt"),
					varPrevCommAmt: $F("varPrevCommAmt").replace(/,/g,""),
					varPrevWtaxAmt: $F("varPrevWtaxAmt").replace(/,/g,""),
					varPrevInputVat: $F("varPrevInputVAT").replace(/,/g,""),
					varPTranType: $F("varPTranType"),
					varPTranId: $F("varPTranId"),
					varRCommAmt: $F("varRCommAmt").replace(/,/g,""),
					varICommAmt: $F("varICommAmt").replace(/,/g,""),
					varPCommAmt: $F("varPCommAmt").replace(/,/g,""),
					varRWtax:	$F("varRWtax").replace(/,/g,""),
					varFdrvCommAmt: $F("varFdrvCommAmt").replace(/,/g,""),
					varDefFgnCurr: $F("varDefFgnCurr").replace(/,/g,""),
					varIWtax: $F("varIWtax").replace(/,/g,""),
					varPWtax: $F("varPWtax").replace(/,/g,""),
					varVarTranType : $F("varTranType"),
					varInputVATParam: $F("varInputVATParam").replace(/,/g,""),
					varCFireNow: $F("varCFireNow"),
					controlVCommAmt: $F("controlVCommAmt").replace(/,/g,""),
					controlSumInpVAT: $F("controlSumInpVAT").replace(/,/g,""),
					controlVInputVAT: $F("controlVInputVAT").replace(/,/g,""),
					controlSumCommAmt: $F("controlSumCommAmt").replace(/,/g,""),
					controlSumWtaxAmt: $F("controlSumWtaxAmt").replace(/,/g,""),
					controlVWtaxAmt: $F("controlVWtaxAmt").replace(/,/g,""),
					controlSumNetCommAmt: $F("controlSumNetCommAmt").replace(/,/g,""),
					billGaccTranId:		$F("txtBillGaccTranId")	// shan 10.02.2014
				},
				onCreate: function() {
					//showNotice("Validating Intm No. Please wait...");
				},
				onComplete: function(response) {
					//hideNotice("");
					var result = JSON.parse(response.responseText);
					if (checkErrorOnResponse(response)) {
						var validCommAmt = "Y";
						
						if (nvl(result.message, "SUCCESS") == "SUCCESS") {
							$("txtCommAmt").value = formatCurrency(nvl(result.commAmt, 0));
							$("txtWtaxAmt").value = formatCurrency(nvl(result.wtaxAmt, 0));
							$("txtInputVATAmt").value = formatCurrency(nvl(result.inputVATAmt, 0));
							if (result.defCommTag == "Y") {
								$("chkDefCommTag").checked = true;
							} else {
								$("chkDefCommTag").checked = false;
							}
							$("txtConvertRate").value = result.convertRate;
							$("txtCurrencyCd").value = result.currencyCd;
							$("txtDspCurrencyDesc").value = result.currDesc;
							$("txtForeignCurrAmt").value = formatCurrency(nvl(result.foreignCurrAmt, 0));
							$("txtDefWtaxAmt").value = result.defWtaxAmt;
							$("txtDrvCommAmt").value = formatCurrency(nvl(result.drvCommAmt, 0));
							$("txtDefCommAmt").value = result.defCommAmt;
							$("txtDefInputVAT").value = result.defInputVAT;
							$("txtDspPolicyId").value = result.dspPolicyId;
							$("txtDspIntmName").value = unescapeHTML2(result.dspIntmName);//added unescapeHTML2 by reymon 03252013
							$("txtDspAssdNo").value = result.dspAssdNo;
							$("txtDspAssdName").value = unescapeHTML2(result.dspAssdName);//added unescapeHTML2 by reymon 03252013
							$("txtDspLineCd").value = result.dspLineCd;
							$("varVATRt").value = result.varVATRt;
							$("varClrRec").value = result.varClrRec;
							$("varVPolFlag").value = result.varVPolFlag;
							$("varHasPremium").value = result.varHasPremium;
							$("varCPremiumAmt").value = result.varCPremiumAmt;
							$("varInvPremAmt").value = result.varInvPremAmt;
							$("varOtherCharges").value = result.varOtherCharges;
							$("varNotarialFee").value = result.varNotarialFee;
							$("varPdPremAmt").value = result.varPdPremAmt;
							$("varPctPrem").value = result.varPctPrem;
							$("varCg$Dummy").value = result.varCgDummy;
							$("varCommPayableParam").value = result.varCommPayableParam;
							$("varMaxInputVAT").value = result.varMaxInputVAT;
							$("varLastWtax").value = result.varLastWtax;
							//$("varInvoiceButt").value = result.varInvoiceButt; // removed (emman 06.15.2011)
							$("varPrevCommAmt").value = result.varPrevCommAmt;
							$("varPrevWtaxAmt").value = result.varPrevWtaxAmt;
							$("varPrevInputVAT").value = result.varPrevInputVat;
							$("varPTranType").value = result.varPTranType;
							$("varPTranId").value = result.varPTranId;
							$("varRCommAmt").value = result.varRCommAmt;
							$("varICommAmt").value = result.varICommAmt;
							$("varPCommAmt").value = result.varPCommAmt;
							$("varRWtax").value = result.varRWtax;
							$("varFdrvCommAmt").value = result.varFdrvCommAmt;
							$("varDefFgnCurr").value = result.varDefFgnCurr;
							$("varIWtax").value = result.varIWtax;
							$("varPWtax").value = result.varPWtax;
							$("varTranType").value = result.varVarTranType;
							$("varInputVATParam").value = result.varInputVATParam;
							$("varCFireNow").value = result.varCFireNow;
							$("controlVCommAmt").value = result.controlVCommAmt;
							$("controlSumInpVAT").value = result.controlSumInpVAT;
							$("controlVInputVAT").value = result.controlVInputVAT;
							$("controlSumCommAmt").value = result.controlSumCommAmt;
							$("controlSumWtaxAmt").value = result.controlSumWtaxAmt;
							$("controlVWtaxAmt").value = result.controlVWtaxAmt;
							$("controlSumNetCommAmt").value = result.controlSumNetCommAmt;

							validCommAmt = result.validCommAmt;

							$("isIntmNoValidated").value = "Y";

							if (result.policyStatus != "OK") {
								showMessageBox("This is a "+result.policyStatus+" policy.", imgMessage.INFO);
								ok = false;
							}
							if (result.gipiInvoiceExist == "N") {
								showMessageBox("No existing record in GIPI_INVOICE table.", imgMessage.INFO);
								ok = false;
							}
							if (result.invalidTranType1or2 == "Y") {
								showMessageBox("You entered an invalid transaction type!!! Only transaction type 1 or 2 is allowed!!!", imgMessage.INFO);
								ok = false;
							}
							if (result.invalidTranType3or4 == "Y") {
								showMessageBox("You entered an invalid transaction type!!! Only transaction type 3 or 4 is allowed!!!", imgMessage.INFO);
								ok = false;
							}
							if (nvl(result.noTranType, "0") != "0") {
								showMessageBox("No transaction type "+result.noTranType+" for this bill and intermediary.", imgMessage.WARNING);
								ok = false;
							}
							if (result.invCommFullyPaid == "Y") {
								showWaitingMessageBox("Invoice Commission fully paid.", imgMessage.INFO,
										function () {
									resetFields();
								});// added reset fields - 05-13-11
								//showMessageBox("Invoice Commission fully paid.", imgMessage.INFO);
								ok = false;
							}
							if (validCommAmt == "N") {
								showWaitingMessageBox("No valid amount of commission for this transaction type.", imgMessage.INFO,
										function () {
											resetFields();
											$("txtTranType").focus();
										});
								ok = false;
							}
							if ($F("accessMC") == "FALSE" && $F("txtDrvCommAmt") == null){ //added by robert SR 19679 07.09.15
								showWaitingMessageBox("Policy is not yet fully paid.", imgMessage.INFO,
										function () {
											resetFields();
											$("txtTranType").focus();
										});
								ok = false;
							}  //end robert SR 19679 07.13.15
							// shan 10.17.2014
							if (checkUnprintedOR == false){
								validateGcopCommAmt(); //proceed(result, validCommAmt);	
							}else{
								var res = checkRelCommWUnprintedOr($F("txtIssCd"),$F("txtPremSeqNo"));
								if (res.message == "ALLOWED") {
									showConfirmBox("Confirmation", "The premium payment of bill no. " + res.issCd + "-" + res.premSeqNo + " is not yet printed. "+res.refNo +'.'+
											"Do you want to continue?",
											"Yes", "No",
											function() {
												proceed(result, validCommAmt);
											},function(){
												resetFields();
												ok = false;
											});
								}else if (res.message == "NOT_ALLOWED") {
									showWaitingMessageBox( "The premium payment of bill no. " + res.issCd + "-" + res.premSeqNo + " is not yet printed. "+res.refNo +'.','I', resetFields);
									ok = false;
								}
								
								if (res.message != "ALLOWED") {
									proceed(result, validCommAmt);
								}
							}
							// end 10.17.2014
						} else {
							showMessageBox(result.message, imgMessage.ERROR);
							ok = false;
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
						ok = false;
					}
				}
			});
		}

		return ok;
	}

	function proceed(result, validCommAmt){	//enclosed in a function : shan 10.17.2014
		if (result.pdPrem == "N") {
			if ($F("noPremPayt") != null && $F("noPremPayt") == "Y"){	// added by shan 09.11.2014
				if ($F("accessAU") == "TRUE"){
					showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
							"Yes", "No",
							function(){
								getGcopInvDetails();	
							},
							function(){	// no for commission payment
								resetFields();
							}
					);
				}else{
					showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
							"Yes", "No",
							function(){
								if ($F("accessAU") == "FALSE"){
									showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
											"Yes", "No",
											function() {
												showGenericOverride("GIACS020", "AU",
														function(ovr, userId, res){
															if(res == "FALSE"){
																//showMessageBox( userId + " is not allowed to edit the DV Payee and Particulars.", imgMessage.ERROR);
																showMessageBox(userId + " is not allowed to process payments for unpaid premium.", imgMessage.ERROR);
																$("txtOverrideUserName").clear();
																$("txtOverridePassword").clear();
																return false;
															} else if(res == "TRUE"){
																getGcopInvDetails();
																ovr.close();
																delete ovr;
															}
														},
														function() {
															resetFields();
														}
												);
											},
											function(){	// no for USER confirmation
												resetFields();
											}
									);
								}
							},
							function(){	// no for commission payment
								resetFields();
							}
					);
				}
			}else{
				showWaitingMessageBox("No premium payment has been made for this policy.", imgMessage.INFO,
					function () {
						resetFields();
						$("txtTranType").focus();
					});
				ok = false;
			}
		}else if (result.policyFullyPaid == "N") {
			if ($F("noPremPayt") != null){	// added by shan 09.11.2014
				if ($F("noPremPayt") == "N" && $F("accessMC") == "TRUE"){
					showConfirmBox("CONFIRMATION", "Policy is not yet fully paid. Do you wish to override it?",
							"Yes", "No",
							function() {
								//
							},
							function() {
								resetFields();
								$("txtTranType").focus();
								ok = false;
							}
					);
				}else if ($F("noPremPayt") == "Y"){
					showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
							"Yes", "No",
							function(){
								if ($F("accessAU") == "FALSE"){
									showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
											"Yes", "No",
											function() {
												showGenericOverride("GIACS020", "AU",
														function(ovr, userId, res){
															if(res == "FALSE"){
																//showMessageBox( userId + " is not allowed to edit the DV Payee and Particulars.", imgMessage.ERROR);
																showMessageBox(userId + " is not allowed to process payments for unpaid premium.", imgMessage.ERROR);
																$("txtOverrideUserName").clear();
																$("txtOverridePassword").clear();
																return false;
															} else if(res == "TRUE"){
																getGcopInvDetails();
																ovr.close();
																delete ovr;
															}
														},
														function() {
															resetFields();
														}
												);
											},
											function(){	// no for USER confirmation
												resetFields();
											}
									);
								}else{
									param2FullPremPayt();
								}
							},
							function(){	// no for commission payment
								resetFields();
							}
					);
				}
			}else if ($F("txtCommTag") == "Y"){
				 showWaitingMessageBox("Policy is not yet fully paid.", imgMessage.INFO,
						function () {
							resetFields();
							$("txtTranType").focus();
						});
				ok = false;
			}
		}else if (result.policyOverride == "Y") {
			/*showConfirmBox("Override", "Policy is not yet fully paid. Do you wish to override it?", "Yes", "No", 
					function() {
						$("chkDefCommTag").checked = false;
						var varPsPdPremAmt = result.psPdPremAmt;
						var varPsTotPremAmt = result.psTotPremAmt;

						new Ajax.Request(contextPath+"/GIACCommPaytsController?action=giacs020Param2MgmtComp", {
							evalScripts: true,
							asynchronouse: false,
							method: "GET",
							parameters: {
								issCd: $F("txtIssCd"),
								premSeqNo: $F("txtPremSeqNo"),
								intmNo: $F("txtIntmNo"),
								commAmt: $F("txtCommAmt").replace(/,/g,""),
								wtaxAmt: $F("txtWtaxAmt").replace(/,/g,""),
								drvCommAmt: $F("txtDrvCommAmt").replace(/,/g,""),
								defCommAmt: $F("txtDefCommAmt").replace(/,/g,""),
								varMaxInputVAT: $F("varMaxInputVAT").replace(/,/g,""),
								varVATRt: $F("varVATRt"),
								varClrRec: $F("varClrRec"),
								validCommAmt: validCommAmt,
								mgmtPdPremAmt: varPsPdPremAmt,
								mgmtTotPremAmt: varPsTotPremAmt
							},
							onComplete: function(response2) {
								var result2 = response2.responseText.toQueryParams();

								$("txtIntmNo").value = nvl(result2.intmNo, "");
								$("txtCommAmt").value = nvl(result2.commAmt, "").blank() ? "" : formatCurrency(nvl(result2.commAmt, 0));
								$("txtWtaxAmt").value = nvl(result2.wtaxAmt, "").blank() ? "" : formatCurrency(nvl(result2.wtaxAmt, 0));
								$("txtDrvCommAmt").value = nvl(result2.drvCommAmt, "").blank() ? "" : formatCurrency(nvl(result2.drvCommAmt, 0));
								$("txtDefCommAmt").value = nvl(result2.defCommAmt, "");
								$("varMaxInputVAT").value = nvl(result2.varMaxInputVAT, "");
								$("varVATRt").value = nvl(result2.varVATRt, "");
								$("varClrRec").value = nvl(result2.varClrRec, "");
								validCommAmt = result2.validCommAmt;

								if (validCommAmt == "N") {
									showWaitingMessageBox("No valid amount of commission for this transaction type.", imgMessage.INFO,
											function () {
												resetFields();
												$("txtTranType").focus();
											});
								} else {
									intmNoPostTextItem();
								}										
							}
						});
					}, function() {
						resetFields();
						ok = false;
					});*/
			if ($F("noPremPayt") != null && $F("noPremPayt") == "Y"){ //added by robert SR 19679 07.13.15
				showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
						"Yes", "No",
						function(){
							if ($F("accessAU") == "TRUE"){
								param2FullPremPayt();				
							}else if ($F("accessAU") == "FALSE"){
								showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
										"Yes", "No",
										function() {
											showGenericOverride("GIACS020", "AU",
													function(ovr, userId, res){
														if(res == "FALSE"){
															//showMessageBox( userId + " is not allowed to edit the DV Payee and Particulars.", imgMessage.ERROR);
															showMessageBox(userId + " is not allowed to process payments for unpaid premium.", imgMessage.ERROR);
															$("txtOverrideUserName").clear();
															$("txtOverridePassword").clear();
															return false;
														} else if(res == "TRUE"){
															param2FullPremPayt();
															ovr.close();
															delete ovr;
														}
													},
													function() {
														resetFields();
													}
											);
										},
										function(){	// no for USER confirmation
											resetFields();
										}
								);
							}
						},
						function(){	// no for commission payment
							resetFields();
						}
				);
			}else{
				$("txtCommAmt").focus(); 
				validateGcopCommAmt();
			} //end robert SR 19679 07.13.15
		}else{
			// everything okay
			$("txtCommAmt").focus(); 
			validateGcopCommAmt();
		}
	}
	
	function param2FullPremPayt(){
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=param2FullPremPayt", {
			evalScripts: true,
			asynchronouse: false,
			method: "GET",
			parameters: {
				issCd: $F("txtIssCd"),
				premSeqNo: $F("txtPremSeqNo"),
				intmNo: $F("txtIntmNo")
			},
			onComplete: function(response2) {
				var result2 = response2.responseText.toQueryParams();

				if (result2.varMessage == "SUCCESS"){
					$("txtIntmNo").value = nvl(result2.intmNo, "");
					$("txtCommAmt").value = nvl(result2.commAmt, "").blank() ? "" : formatCurrency(nvl(result2.commAmt, 0));
					$("txtWtaxAmt").value = nvl(result2.wtaxAmt, "").blank() ? "" : formatCurrency(nvl(result2.wtaxAmt, 0));
					$("txtDrvCommAmt").value = nvl(result2.drvCommAmt, "").blank() ? "" : formatCurrency(nvl(result2.drvCommAmt, 0));
					$("txtDefCommAmt").value = nvl(result2.defCommAmt, "");
					$("varMaxInputVAT").value = nvl(result2.varMaxInputVAT, "");
					$("varClrRec").value = nvl(result2.varClrRec, "");
				}else{
					showWaitingMessageBox(result2.varMessage, imgMessage.INFO,
						function () {
							resetFields();
							$("txtTranType").focus();
					});
				}
			}
		});	
	}
	
	function getGcopInvDetails(){	// to retrieve details when overriding no premium or partial payment : shan 10.24.2014
		try{
			new Ajax.Request(contextPath+"/GIACCommPaytsController",{
				method: "POST",
				parameters: {
					action:		"getGcopInvDetails",
					tranType : $F("txtTranType"),
					issCd : $F("txtIssCd"),
					premSeqNo : $F("txtPremSeqNo"),
					intmNo : $F("txtIntmNo"),
					intmName : $F("txtDspIntmName"),
					varVFromSums : $F("varVFromSums"),
					keyword : null,
					gaccTranId:		objACGlobal.gaccTranId,
					notIn:	objGIACS020.notIn == null ? "--" : "(" + objGIACS020.notIn + ")",
					onLOV:	objGIACS020.onLOV,
					getNoPremPayt:  "Y"
				},
				onCreate: showNotice("Retrieving details, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var result = JSON.parse(response.responseText);

						if (result.message == "SUCCESS"){
							var row = result.row[0];
							$("txtIntmNo").value = row.intmNo;
							$("txtDspIntmName").value = unescapeHTML2(row.intmName);
							$("isIntmNoValidated").value = "N";
							$("txtCommAmt").value = formatCurrency(row.commAmt);
							$("txtInputVATAmt").value = formatCurrency(row.invatAmt);
							
							$("txtWtaxAmt").value = formatCurrency(row.wtax);
							$("txtDrvCommAmt").value = formatCurrency(row.ncommAmt);
							$("txtBillGaccTranId").value = row.billGaccTranId;
							$("txtDspIntmName").focus();
							$("txtCommAmt").focus();
							fireEvent($("txtCommAmt"), 'change');
						}else if (result.message == "showLOV"){
							
						}else{
							
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getGcopInvDetails", e);
		}
	}
	
	objACGlobal.validateIntmNo = validateIntmNo;
	function showGcopInvDetails() {
		premSeqNoPreTextItem();
		if ($F("currentRowNo") == -1) {
			$("varInvoiceButt").value = "Y";
			$("gcopInvModalTag").value = "Y";
		}

		if ($F("txtTranType").blank() || $F("txtIssCd").blank()) {
			showMessageBox("Please select a transaction type and issue source first.", imgMessage.ERROR);
			return false;
		} else if ($F("currentRowNo") != -1) {
			if ($F("gcopChanged"+$F("currentRowNo")) == "N") {
				showMessageBox("You cannot update this record.", imgMessage.WARNING);
			}
		} else {
			if (!$F("txtTranType").blank() && !$F("txtIssCd").blank()) {
				/* Modalbox.show(contextPath+"/GIACCommPaytsController?action=showGcopInvDetails&tranType="+$F("txtTranType")+"&issCd="+$F("txtIssCd")+
						"&premSeqNo="+$F("txtPremSeqNo")+"&intmNo="+$F("txtIntmNo")+"&varVFromSums="+$F("varVFromSums"), 
						  {title: "Invoice", 
						  width: 900,
						  asynchronous: false}); */
				//added by steven 09.12.2014
				objGIACS020.notIn = null;
						  
				$$("div#commPaytsTableContainer div[name='rowCommPayts']").each(function(r) {
					if(r.down("input", 3).value == $F("txtTranType") && r.down("input", 4).value == $F("txtIssCd")){
						var billGaccTranId = (r.down("input", 29).name == "gcopBillGaccTranId" ? r.down("input", 29).value : r.down("input", 30).value);
						var val = "'" + billGaccTranId + "-" + r.down("input", 5).value + "-" + r.down("input", 6).value + "'"; // billGaccTranId + premSeqNo + intmNo combi
						objGIACS020.notIn = (objGIACS020.notIn == null ? val : objGIACS020.notIn + "," + val);
					}
				});
				
				GcopInvDetailsOverlay = Overlay.show(contextPath+"/GIACCommPaytsController?action=showGcopInvDetails&tranType="+$F("txtTranType")+"&issCd="+$F("txtIssCd")+
						"&premSeqNo="+$F("txtPremSeqNo")+"&intmNo="+$F("txtIntmNo")+"&varVFromSums="+$F("varVFromSums"), {
					asynchronous : false,
					urlContent: true,
					draggable: true,
					onCreate : showNotice("Loading, please wait..."),
					//urlParameters: {
					//},
				    title: "Invoice",
				    height: 470,
				    width: 900
				});
			}
		}
	}

	function saveCommPayts() {
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=saveGIACCommPayts", {
			evalScripts: true,
			asynchronous: false,
			method: "POST",
			postBody: Form.serialize("itemInformationForm"),
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					//if (nvl(result.message, "SUCCESS") == "SUCCESS") {
					if (result.message == "SUCCESS") {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);

						changeTag = 0;
						
						$("varCommTakeUp").value = result.varCommTakeUp;
						$("varVItemNum").value = result.varVItemNum;
						$("varVBillNo").value = result.varVBillNo;
						$("varVIssueCd").value = result.varVIssueCd;

						$$("div[name='rowCommPayts']").each(function(row) {
							if (row.down("input", 1).value != "N") {
								row.down("input", 1).value = "N";
							}
						});

						while ($("deleteCommPaytsList").hasChildNodes()) {
							$("deleteCommPaytsList").removeChild($("deleteCommPaytsList").lastChild);
						}

						//$("deleteCommPaytsList").removeChild();
						showDirectTransCommPayts();
					} else {
						//showMessageBox(result.message, imgMessage.ERROR);
						//added error message by reymon 03252013
						//added geniisys exception reymon 05072013

						if (response.responseText.include("ORA-20004: No records in GIIS INTERMEDIARY table")){
							showMessageBox("No maintained withholding tax for intermediary/parent intermediary.","E");
						} else if(response.responseText.include("Geniisys Exception")) {
							var message = response.responseText.split("#");
							var message2 = message[2].split(".");
							showMessageBox(message2[0]+".", message[1]);
						} else{
							showMessageBox(result.message, imgMessage.ERROR);
						}
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	//marco - SR 21585 - 03.18.2016
	function checkCommPaytStatus() {
		new Ajax.Request(contextPath + "/GIACCommPaytsController", {
			parameters: {
				action: "checkCommPaytStatus",
				gaccTranId: $F("giacs020GaccTranId")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					saveCommPayts();
				}
			}
		});
	}
	
	function saveGiacs020CommPayts() {
		var count = 0;
		
		$$("div[name='rowCommPayts']").each(function(row) {
			if (row.down("input", 1).value != "N") {
				count = count + 1;
				return false;
			}
		});

		if ($$("div[name='commPaytsRowDeleted']").size() == 0 && count == 0) {
			showMessageBox("No changes to save.", imgMessage.INFO);
			return false;
		} else {
			checkCommPaytStatus();
		}
	}

	// end of page functions

	// PROCEDURE cgfd$get_gcop_drv_comm_amt
	function getDrvCommAmt(pWtaxAmt, pInputVATAmt, pCommAmt) {
		if (pWtaxAmt.blank() || pInputVATAmt.blank() || pCommAmt.blank()) {
			return 0;
		} else {
			pCommAmt = nvl(pCommAmt.replace(/,/g,""), 0);
			pInputVATAmt = nvl(pInputVATAmt.replace(/,/g,""), 0);
			pWtaxAmt = nvl(pWtaxAmt.replace(/,/g,""), 0);
			return nvl(parseFloat(pCommAmt) + parseFloat(pInputVATAmt) - parseFloat(pWtaxAmt), 0);
		}
	}

	// GCOP.comm_amt WHEN-VALIDATE-ITEM
	function validateGcopCommAmt() {
		if ($F("varCommPayableParam") == 2 && $F("txtTranType") == 1) {
			$("txtInputVATAmt").value = (parseFloat(nvl($F("varVATRt"), "0")) / 100) * (parseFloat(nvl($F("txtCommAmt"), "0").replace(/,/g,"")));
			$("txtForeignCurrAmt").value = parseFloat(nvl($F("txtCommAmt"), "0").replace(/,/g,"")) / parseFloat(nvl($F("txtConvertRate"), "0").replace(/,/g,""));
			$("varCFireNow").value = "Y";
		} else {
			$("controlVCommAmt").value  = parseFloat(nvl($F("varPrevCommAmt"), "0"));
			$("controlVWtaxAmt").value  = parseFloat(nvl($F("varPrevWtaxAmt"), "0"));
			$("controlVInputVAT").value = parseFloat(nvl($F("varPrevInputVAT"), "0"));
			
			getGipiCommInvoice();

			if ($F("chkDefCommTag").checked) {
				$("varDefFgnCurr").value = ($F("varDefFgnCurr").blank() || $F().blank("varPctPrem")) ? "" : $F("varDefFgnCurr") * $F("varPctPrem");
				$("varICommAmt").value = ($F("varICommAmt").blank() || $F().blank("varPctPrem")) ? "" : $F("varICommAmt") * $F("varPctPrem");
				$("varIWtax").value = ($F("varIWtax").blank() || $F().blank("varPctPrem")) ? "" : $F("varIWtax") * $F("varPctPrem");
			}
			$("varCFireNow").value = "Y";
		}
		
		if (validateCommAmt()) {
			validateCommAmt1();
		}

		$("txtCommAmt").value = formatCurrency(parseFloat($F("txtCommAmt").replace(/,/g,"")));
		$("txtWtaxAmt").value = formatCurrency(parseFloat($F("txtWtaxAmt").replace(/,/g,"")));
		$("txtInputVATAmt").value = formatCurrency(parseFloat($F("txtInputVATAmt").replace(/,/g,"")));
		$("txtForeignCurrAmt").value = formatCurrency(parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")));
	}

	// PROCEDURE validate_comm_amt
	function validateCommAmt() {
		if ($F("txtTranType") == 1 || $F("txtTranType") == 4) {
			if (parseFloat($F("txtCommAmt").replace(/,/g,"")) > parseFloat($F("txtDefCommAmt").replace(/,/g,""))) {
				invCommAmt();
				showMessageBox("Amount entered should not be greater than the outstanding balance.", imgMessage.ERROR);
				return false;
			} else if (parseFloat($F("txtCommAmt").replace(/,/g,"")) < 0) {
				invCommAmt();
				showMessageBox("Please enter a positive amount for this transaction.", imgMessage.ERROR);
				return false;
			} else if (parseFloat($F("txtCommAmt").replace(/,/g,"")) == 0) {
				invCommAmt();
				showMessageBox("Commission amount should not be equal to zero.", imgMessage.INFO);
			}
		} else if ($F("txtTranType") == 2 || $F("txtTranType") == 3) {
			if (Math.abs(parseFloat($F("txtCommAmt").replace(/,/g,""))) > Math.abs(parseFloat($F("txtDefCommAmt").replace(/,/g,"")))) {
				invCommAmt();
				showMessageBox("Amount entered should not be greater than the outstanding balance.", imgMessage.ERROR);
				return false;
			} else if (parseFloat($F("txtCommAmt").replace(/,/g,"")) > 0) {
				invCommAmt();
				showMessageBox("Please enter a negative amount for this transaction.", imgMessage.ERROR);
				return false;
			} else if (parseFloat($F("txtCommAmt").replace(/,/g,"")) == 0) {
				invCommAmt();
				showMessageBox("Commission amount should not be equal to zero.", imgMessage.INFO);
			}
		}
		return true;
	}

	// PROCEDURE validate_comm_amt1
	function validateCommAmt1() {
		getGipiCommInvoice();

		$("txtWtaxAmt").value =  getNaNAlternativeValue(roundNumber((parseFloat($F("txtCommAmt").replace(/,/g,""))/parseFloat($F("varICommAmt").replace(/,/g,"")) * parseFloat($F("varIWtax").replace(/,/g,""))), 2), "");
		
		if (parseFloat($F("varLastWtax").replace(/,/g,"")) != 0
				&& parseFloat($F("txtWtaxAmt").replace(/,/g,"")) > parseFloat($F("varLastWtax").replace(/,/g,""))
				&& truncateDecimal(parseFloat($F("txtWtaxAmt").replace(/,/g,"")) / parseFloat($F("varLastWtax").replace(/,/g,""), 2)) == 1) {
			$("txtWtaxAmt").value = $F("varLastWtax");
		}
		$("txtInputVATAmt").value = getNaNAlternativeValue((parseFloat(nvl($F("varVATRt"),0)) / 100) * parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0")), ""); //added by robert SR 19686 07.15.15

		if (parseFloat($F("varMaxInputVAT").replace(/,/g,"")) != 0
				&& parseFloat($F("txtInputVATAmt").replace(/,/g,"")) > parseFloat($F("varMaxInputVAT").replace(/,/g,""))
				&& truncateDecimal(parseFloat($F("txtInputVATAmt").replace(/,/g,"")) / parseFloat($F("varMaxInputVAT").replace(/,/g,""), 2)) == 1) {
			$("txtInputVATAmt").value = $F("varLastWtax");
		}

		$("controlSumCommAmt").value = parseFloat(nvl($F("controlSumCommAmt").replace(/,/g,""), "0"))
										+ parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0"))
										- parseFloat(nvl($F("controlVCommAmt").replace(/,/g,""), "0"));

		$("controlSumInpVAT").value = parseFloat(nvl($F("controlSumInpVAT").replace(/,/g,""), "0"))
										+ parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0"))
										- parseFloat(nvl($F("controlVInputVAT").replace(/,/g,""), "0"));

		$("controlSumWtaxAmt").value = parseFloat(nvl($F("controlSumWtaxAmt").replace(/,/g,""), "0"))
										+ parseFloat(nvl($F("txtWtaxAmt").replace(/,/g,""), "0"))
										- parseFloat(nvl($F("controlVWtaxAmt").replace(/,/g,""), "0"));

		$("controlVCommAmt").value = getNaNAlternativeValue(parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0")), "");
		$("controlVWtaxAmt").value = getNaNAlternativeValue(parseFloat(nvl($F("txtWtaxAmt").replace(/,/g,""), "0")), "");
		$("controlVInputVAT").value = getNaNAlternativeValue(parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0")), "");
		$("varPrevCommAmt").value = getNaNAlternativeValue(parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0")), "");
		$("varPrevWtaxAmt").value = getNaNAlternativeValue(parseFloat(nvl($F("txtWtaxAmt").replace(/,/g,""), "0")), "");
		$("varPrevInputVAT").value = getNaNAlternativeValue(parseFloat(nvl($F("txtInputVATAmt").replace(/,/g,""), "0")), "");
		$("txtForeignCurrAmt").value = getNaNAlternativeValue(parseFloat($F("txtCommAmt").replace(/,/g,"")) / parseFloat($F("txtConvertRate")), "");

		$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtWtaxAmt"), $F("txtInputVATAmt"), $F("txtCommAmt")));
	}

	// PROCEDURE inv_comm_amt
	function invCommAmt() {
		$("txtCommAmt").value = $F("varPrevCommAmt");
		$("txtWtaxAmt").value = $F("varPrevWtaxAmt");
		$("txtInputVATAmt").value = parseFloat(nvl($F("txtCommAmt"), "0").replace(/,/g,"")) * parseFloat(nvl($F("varVATRt"), "0").replace(/,/g,"")) / 100;

		if (!$F("varMaxInputVAT").blank()) {
			if ($F("varMaxInputVAT") != 0 && $F("txtInputVATAmt") > $F("varMaxInputVAT") 
					&& parseFloat(truncateDecimal((parseFloat($F("txtInputVATAmt"))/parseFloat($F("varMaxInputVAT"))), 2)) == 1) {
				$("txtInputVATAmt").value = $F("varMaxInputVAT");
			}
		}

		$("controlVCommAmt").value  = $F("varPrevCommAmt");
		$("controlVWtaxAmt").value  = $F("varPrevWtaxAmt");
		$("controlVInputVAT").value = $F("varPrevInputVAT");
	}

	// PROCEDURE get_def_prem_pct
	function getDefPremPct() {
		var ok = true;
		
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=getCommPaytsDefPremPct", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				issCd: $F("txtIssCd"),
				premSeqNo: $F("txtPremSeqNo"),
				varInvPremAmt: $F("varInvPremAmt").replace(/,/g,""),
				varOtherCharges: $F("varOtherCharges").replace(/,/g,""),
				varNotarialFee: $F("varNotarialFee").replace(/,/g,""),
				varPdPremAmt: $F("varPdPremAmt").replace(/,/g,""),
				varCPremiumAmt: $F("varCPremiumAmt").replace(/,/g,""),
				varHasPremium: $F("varHasPremium"),
				varClrRec: $F("varClrRec"),
				varPctPrem: $F("varPctPrem"),
				varPdPrem: "Y",
				message: "SUCCESS"
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (nvl(result.message, "SUCCESS") == "SUCCESS") {
						$("varInvPremAmt").value = result.varInvPremAmt;
						$("varOtherCharges").value = result.varOtherCharges;
						$("varNotarialFee").value = result.varNotarialFee;
						$("varPdPremAmt").value = result.varPdPremAmt;
						$("varCPremiumAmt").value = result.varCPremiumAmt;
						$("varHasPremium").value = result.varHasPremium;
						$("varClrRec").value = result.varClrRec;
						$("varPctPrem").value = result.varPctPrem;
						$("varPdPrem").value = result.varPdPrem;

						if (result.pdPrem == "N") {
							showWaitingMessageBox("No premium payment has been made for this policy.", imgMessage.INFO, function(){});
						}
					} else {
						showMessageBox(result.message, imgMessage.INFO);
						ok = false;
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					ok = false;
				}
			}
		});

		return ok;
	}

	// PROCEDURE comp_summary
	function compSummary() {
		var ok = true;
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=giacs020CompSummary", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				defCommTag: $("chkDefCommTag").checked ? "Y" : "N",
				premSeqNo: $F("txtPremSeqNo"),
				intmNo: $F("txtIntmNo"),
				issCd: $F("txtIssCd"),
				tranType: $F("txtTranType"),
				convertRate: $F("txtConvertRate"),
				currencyCd: $F("txtCurrencyCd"),
				currDesc: $F("txtDspCurrencyDesc"),
				inputVATAmt: $F("txtInputVATAmt").replace(/,/g,""),
				commAmt: $F("txtCommAmt").replace(/,/g,""),
				wtaxAmt: $F("txtWtaxAmt").replace(/,/g,""),
				foreignCurrAmt: $F("txtForeignCurrAmt").replace(/,/g,""),
				defInputVAT: $F("txtDefInputVAT").replace(/,/g,""),
				drvCommAmt: $F("txtDrvCommAmt").replace(/,/g,""),
				defCommAmt: $F("txtDefCommAmt").replace(/,/g,""),
				defWtaxAmt: $F("txtDefWtaxAmt").replace(/,/g,""),
				varCgDummy: $F("varCg$Dummy"),
				varPrevCommAmt: $F("varPrevCommAmt").replace(/,/g,""),
				varPrevWtaxAmt: $F("varPrevWtaxAmt").replace(/,/g,""),
				varPrevInputVAT: $F("varPrevInputVAT").replace(/,/g,""),
				varPTranType: $F("varPTranType"),
				varPTranId: $F("varPTranId"),
				varRCommAmt: $F("varRCommAmt").replace(/,/g,""),
				varICommAmt: $F("varICommAmt").replace(/,/g,""),
				varPCommAmt: $F("varPCommAMt").replace(/,/g,""),
				varRWtax: $F("varRWtax").replace(/,/g,""),
				varFdrvCommAmt: $F("varFdrvCommAmt").replace(/,/g,""),
				varDefFgnCurr: $F("varDefFgnCurr").replace(/,/g,""),
				varPctPrem: $F("varPctPrem"),
				varIWtax: $F("varIWtax").replace(/,/g,""),
				varPWtax: $F("varPWtax").replace(/,/g,""),
				varVarTranType: $F("varTranType"),
				varVATRt: $F("varVATRt"),
				varInputVATParam: $F("varInputVATParam"),
				varHasPremium: $F("varHasPremium"),
				varClrRec: $F("varClrRec"),
				controlVCommAmt: $F("controlVCommAmt").replace(/,/g,""),
				controlSumInpVAT: $F("controlSumInpVAT").replace(/,/g,""),
				controlVInputVAT: $F("controlVInputVAT").replace(/,/g,""),
				controlSumCommAmt: $F("controlSumCommAmt").replace(/,/g,""),
				controlSumWtaxAmt: $F("controlSumWtaxAmt").replace(/,/g,""),
				controlVWtaxAmt: $F("controlVWtaxAmt").replace(/,/g,""),
				controlSumNetCommAmt: $F("controlSumNetCommAmt").replace(/,/g,""),
				invCommFullyPaid: "N",
				message: "SUCCESS"
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();
					if (nvl(result.message, "SUCCESS") == "SUCCESS") {
						$("txtConvertRate").value = result.convertRate;
						$("txtCurrencyCd").value = result.currencyCd;
						$("txtDpsCurrencyDesc").value = result.currDesc;
						$("txtInputVATAmt").value = formatCurrency(nvl(result.inputVATAmt, 0));
						$("txtCommAmt").value = formatCurrency(nvl(result.commAmt, 0));
						$("txtWtaxAmt").value = formatCurrency(nvl(result.wtaxAmt, 0));
						$("txtForeignCurrAmt").value = formatCurrency(nvl(result.foreignCurrAmt, 0));
						$("txtDefInputVAT").value = result.defInputVAT;
						$("txtDrvCommAmt").value = result.drvCommAmt;
						$("txtDefCommAmt").value = result.defCommAmt;
						$("txtDefWtaxAmt").value = result.defWtaxAmt;
						$("varCg$Dummy").value = result.varCgDummy;
						$("varPrevCommAmt").value = result.varPrevCommAmt;
						$("varPrevWtaxAmt").value = result.varPrevWtaxAmt;
						$("varPrevInputVAT").value = result.varPrevInputVAT;
						$("varPTranType").value = result.varPTranType;
						$("varPTranId").value = result.varPTranId;
						$("varRCommAmt").value = result.varRCommAmt;
						$("varICommAmt").value = result.varICommAmt;
						$("varPCommAmt").value = result.varPCommAmt;
						$("varRWtax").value = result.varRWtax;
						$("varFdrvCommAmt").value = result.varFdrvCommAmt;
						$("varDefFgnCurr").value = result.varDefFgnCurr;
						$("varPctPrem").value = result.varPctPrem;
						$("varIWtax").value = result.varIWtax;
						$("varPWtax").value = result.varPWtax;
						$("varTranType").value = result.varVarTranType;
						$("varVATRt").value = result.varVATRt;
						$("varInputVATParam").value = result.varInputVATParam;
						$("varHasPremium").value = result.varHasPremium;
						$("varClrRec").value = result.varClrRec;
						$("controlVCommAmt").value = result.controlVCommAmt;
						$("controlSumInpVAT").value = result.controlSumInpVAT;
						$("controlVInputVAT").value = result.controlVInputVAT;
						$("controlSumCommAmt").value = result.controlSumCommAmt;
						$("controlSumWtaxAmt").value = result.controlSumWtaxAmt;
						$("controlVWtaxAmt").value = result.controlVWtaxAmt;
						$("controlSumNetCommAmt").value = result.controlSumNetCommAmt;

						if (result.invCommFullyPaid == "Y") {
							showMessageBox("Invoice Commission fully paid.", imgMessage.INFO);
						}
						if (result.invalidTranType1or2 == "Y") {
							showMessageBox("You entered an invalid transaction type!!! Only transaction type 1 or 2 is allowed!!!", imgMessage.INFO);
						}
						if (result.invalidTranType3or4 == "Y") {
							showMessageBox("You entered an invalid transaction type!!! Only transaction type 3 or 4 is allowed!!!", imgMessage.INFO);
						}
						if (result.noTranType != "0") {
							showMessageBox("No transaction type "+result.noTranType+" for this bill and intermediary.", imgMessage.WARNING);
						}
					} else {
						showMessageBox(result.message, imgMessage.INFO);
						ok = false;
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					ok = false;
				}
			}
		});

		return ok;
	}

	// :GCOP.intm_no POST-TEXT-ITEM trigger
	function intmNoPostTextItem() {
		new Ajax.Request(contextPath+"/GIACCommPaytsController?action=giacs020IntmNoPostText", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			parameters: {
				commAmt: $F("txtCommAmt").replace(/,/g,""),
				premSeqNo: $F("txtPremSeqNo"),
				intmNo: $F("txtIntmNo"),
				issCd: $F("txtIssCd"),
				wtaxAmt: $F("txtWtaxAmt").replace(/,/g,""),
				defCommTag: $("chkDefCommTag").checked ? "Y" : "N",
				varLastWtax: $F("varLastWtax").replace(/,/g,"")
			},
			onComplete: function(response3) {
				if (checkErrorOnResponse(response3)) {
					var result3 = response3.responseText.toQueryParams();

					if (result3.defCommTag == "Y") {
						$("chkDefCommTag").checked = true;
					} else {
						$("chkDefCommTag").checked = false;
					}

					$("varLastWtax").value = result3.varLastWtax;

					if ($F("varClrRec") == "Y") {
						resetFields();
						$("varClrRec").value = "N";
					} else {
						$("txtCommAmt").focus();
						validateGcopCommAmt();
					}
				} else {
					showWaitingMessageBox(response3.responseText, imgMessage.ERROR,
							function () {
								resetFields();
								$("txtTranType").focus();
							});
				}
			}
		});
	}

	// GCOP.prem_seq_no PRE-TEXT-ITEM
	function premSeqNoPreTextItem() {
		$("lastPremSeqNo").value = $F("txtPremSeqNo");
		
		if ($F("txtTranType") == 1 || $F("varLOVTranType") == 1) {
			$("varTranType").value = 1;
		} else if ($F("txtTranType") == 2 || $F("varLOVTranType") == 2) {
			$("varTranType").value = -1;
		} else if ($F("txtTranType") == 3 || $F("varLOVTranType") == 3) {
			$("varTranType").value = 1;
		} else if ($F("txtTranType") == 4 || $F("varLOVTranType") == 4) {
			$("varTranType").value = -1;
		} else if ($F("txtTranType") == 5 || $F("varLOVTranType") == 5) {
			$("varTranType").value = 1;
		}
	}
	//
	
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS020(){
		try {
			$("txtTranType").removeClassName("required");
			$("txtIssCd").removeClassName("required");
			$("txtTranType").disable();
			$("txtIssCd").disable();
			$("txtPremSeqNo").removeClassName("required");
			$("premSeqNoDiv").style.backgroundColor = "";
			disableSearch("oscmBillNo");
			$("txtDspIntmName").removeClassName("required");
			$("txtCommAmt").removeClassName("required");
			$("txtWtaxAmt").removeClassName("required");
			$("chkPrintTag").disable();
			$("txtParticulars").readOnly = true;
			$("txtDisbComm").readOnly = true;
// 			$("txtDisbComm").removeClassName("required"); //remove by steven 1/15/2013
			$("txtDisbComm").stopObserving("focus");
			$("txtForeignCurrAmt").removeClassName("required");
			$("txtForeignCurrAmt").readOnly = true;
			disableButton("btnSaveRecord");
			disableButton("btnSaveCommPayts");			
			disableSearch("searchIssCd"); //added by robert
		} catch(e){
			showErrorMessage("disableGIACS020", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || nvl(objACGlobal.queryOnly,"N") == "Y"){
		disableGIACS020();
	} else {
		initializeChangeTagBehavior(saveGiacs020CommPayts);
	}
	
	$("acExit").stopObserving("click"); 
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						//saveOutFaculPremPayts();  //removed, causing javascript error
						saveGiacs020CommPayts();    //replaced by Halley 11.20.13
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS002"){  //added by Halley 11.20.13
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 9.26.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS002"){  //added by Halley 11.20.13
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 9.26.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;
				
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 9.26.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});
	makeInputFieldUpperCase();	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
</script>

