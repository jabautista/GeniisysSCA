<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>O.R. Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="officialReceiptInformationDiv" changeTagAttr="true">

	<!-- Hidden Fields -->
	<input type="hidden" id="origlocalCurrAmt" name="origlocalCurrAmt" value="0" />
	<input type="hidden" id="gfunFundCd" name="gfunFundCd" value="${branchDetails.gfunFundCd}" />
	<input type="hidden" id="branchCd" name="branchCd" value="${branchDetails.branchCd}" />
	<input type="hidden" id="address1" name="address1" value="${address1}" />
	<input type="hidden" id="address2" name="address2" value="${address2}" />
	<input type="hidden" id="address3" name="address3" value="${address3}" />
	<!--  <input type="hidden" id="orFlag" name="orFlag" value="${orFlag}" />-->
	<input type="hidden" id="existingDCBNo" name="existingDCBNo" value="${dcbDetail}" />
	<input type="hidden" id="newDCBNo" name="newDCBNo" value="${newDCBNo}" />
	<input type="hidden" id="cashierCode" name="cashierCode" value="${cashierCd}" />
	<input type="hidden" id="dcbYear" name="dcbYear" value="" />
	<!-- <input type="hidden" id="uploadTag" name="uploadTag" value="" />  -->
	<input type="hidden" id="grossTag" name="grossTag" value="${grossTag}" />
	<input type="hidden" id="collectionAmt" name="collectionAmt" value="0" />
	<input type="hidden" id="totGrossAmt" name="totGrossAmt" value="0" />
	<input type="hidden" id="tranMonth" name="tranMonth" value="0" />
	<input type="hidden" id="netCollectionAmt" name="netCollectionAmt" value="0" />
	<input type="hidden" id="gaccTranId" name="gaccTranId" value="${gaccTranId}" />
	<input type="hidden" id="itemNo" name="itemNo" value="0" />
	<input type="hidden" id="payorNo" name="payorNo" value="0" />
	<input type="hidden" id="cancelledORDate" name="cancelledORDate" value="0" />
	<input type="hidden" id="cancelledORTag" name="cancelledORTag" value="0" />
	<input type="hidden" id="withPdc" name="withPdc" value="" />
	<input type="hidden" id="implSwParam" 	name="implSwParam" 	value="${implSwParameter}" />
	<input type="hidden" id="recompute" 	name="recompute" 	value="N" />
	<input type="hidden" id="origFCGrossAmt" 	name="origFCGrossAmt" 	value="0" />
	<input type="hidden" id="orAnteDate"	name="orAnteDate"  value="${orAnteDate}" />
	<input type="hidden" id="uploadImplemSw" name="uploadImplemSw" value="${uploadImplemSw}" />
	<input type="hidden" id="staleMgrChk" name="staleMgrChk" value="${staleMgrChk}" />
	<input type="hidden" id=staleCheck name="staleCheck" value="${staleCheck}" />
	<input type="hidden" id="staleDays" name="staleDays" value="${staleDays}" />
	<input type="hidden" id="apdcSw" name="apdcSw" value="${apdcSw}" />
	<input type="hidden" id="acceptPDC" name="acceptPDC" value="${acceptPDC}" />
	<!--ACCTRANS Details  added by christian 08.29.2012-->
	<input type="hidden" id="tranSeqNo" name="tranSeqNo" value="${gacc.tranSeqNo}" />
	<input type="hidden" id="tranId" name="tranId" value="${gacc.tranId}" />
	<input type="hidden" id="checkCommPayts" name="checkCommPayts" value="${checkCommPayts}" />
	<!-- dcbUserInfo   added by Kris 01.30.2013 -->
	<input type="hidden" id="dcbUserEffectivityDate" name="dcbUserEffectivityDate" value="<fmt:formatDate value="${dcbUserInfo.effectivityDt}" pattern="MM-dd-yyyy" />" />
	<input type="hidden" id="dcbUserExpiryDate" name="dcbUserExpiryDate" value="<fmt:formatDate value="${dcbUserInfo.expiryDt}" pattern="MM-dd-yyyy" />" />
	<!-- john itemId for PDC -->
	<input type="hidden" id="pdcItemId" name="pdcItemId" value="" />
 	<!-- End Hidden Fields -->

	<div id="officialReceiptInformationHeader" style="margin: 10px;">
		<table width="80%" align="center" cellspacing="1" border="0">
 			<tr>
				<td class="rightAligned" style="width: 103px;">Company</td>
				<td class="leftAligned"><input id="company" style="width: 320px;" type="text" value="${branchDetails.gfunFundCd} - ${branchDetails.fundDesc}" readonly="readonly" class="list" /></td>
				<td class="rightAligned" style="width: 103px;">Branch</td>
				<td class="leftAligned"><input id="branch" type="text" style="width: 210px;" value="${branchDetails.branchCd} - ${branchDetails.branchName}" readonly="readonly" class="list" /></td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="border-left: white; border-right: white; border-bottom: white;" id="officialReceiptInformationDiv" style="margin-top: -2px;">
		<div id="officialReceiptInformationBody" style="margin-top: 10px; border-left: white; border-right: white;" >		
			<table width="95%" align="center" cellspacing="1" border="0">
				<tr>
					<td class="rightAligned" style="width: 6%;">DCB No.</td>
					<td  style="width: 25%;">
						<input id="dcbNo" style="width: 60px;" type="text" value="<c:if test="${dcbDetail gt 0}">${dcbDetail}</c:if>" readonly="readonly" class="rightAligned list" />
					 	<input id="cashierCd" type="text" style="width: 120px;" value="" readonly="readonly" class="rightAligned list" /> <!-- ${cashierCd} -->
					</td>
					<td class="rightAligned" style="width:7.5%;">OR No.</td>
					<td style="width: 25%;">
						<input id="orPrefSuf" style="width: 20%;" type="text" value="${orPrefSuf}" readonly="readonly" class="leftAligned list" maxlength="5"/>  <!-- added value  --> 
						<input id="orNo" type="text" style="width: 66%;" value="${orNo}" readonly="readonly" class="rightAligned list" maxlength="10" />  <!-- added value  -->
					</td>
					<td class="rightAligned" style="width: 12%;">Replacement OR</td>
					<td style="width: 25%;">
						<%-- <input id="refPrefSuf" style="width: 90px;" type="text" value="" readonly="readonly" class="rightAligned list" value="${giacOrRelNewPrefSuf}"/>
						<input id="repORNo" type="text" style="width: 90px;" value="" readonly="readonly" class="rightAligned list" value="${giacOrRelNewOrNo}"/> --%> <!-- Commented out and replaced by codes below - Jerome Bautista 11.26.2015 SR 20817 -->
						<input id="refPrefSuf" style="width: 90px;" type="text" readonly="readonly" class="rightAligned list" value="${giacOrRelNewPrefSuf}"/>
						<input id="repORNo" type="text" style="width: 90px;" readonly="readonly" class="rightAligned list" value="${giacOrRelNewOrNo}"/>
					</td>
				</tr>
				<tr>
					<td class="rightAlignedWidth" style="width: 58px;" >Remittance</td>
					<td>
						<span style="float: left; margin-left: 6px; height: 22px; border: 1px solid gray;">
					    	<input style="width: 172px; border: none; height: 14px;" id="remittance" name="remittance" type="text" value="<fmt:formatDate value="${remitDate}" pattern="MM-dd-yyyy" />"/>
					    	<img id="hrefRemitDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Remittance Date" valign="left"/>
					    </span>
					</td>
					<td class="rightAligned" style="width: 57px;">OR Date</td>
					<td>
					 	<input id="orDate" type="text" style="width: 90px;" class="required" value="<fmt:formatDate value="${orDtlDate}" pattern="MM-dd-yyyy" />" />  <!-- added value  -->
						<input id="orTime" type="text" style="width: 91px;" readonly="readonly" class="list" value="<fmt:formatDate value="${orDtlDate}" pattern="hh:mm:ss a" />" />  <!-- added value  --> 
					</td>
					<td class="rightAligned" style="width: 55px;">Cancelled OR</td>
					<td style="width: 25%;">
						<!-- <input id="canPrefSuf" style="width: 90px;" type="text" value="" class="rightAligned list" maxLength="5" />
						<input id="canORNo" type="text" style="width: 90px;" value="" class="rightAligned list" maxLength="10" /> -->
						<span class="lovSpan" style="width: 96px; height: 21px; margin: 2px 2px 0 3px; float: left;">
							<input type="text" id="canPrefSuf" name="canPrefSuf" style="width: 71px; float: left; border: none; height: 13px;" class="disableDelKey leftAligned" maxlength="5" tabindex="107" value="${giacOrRelOldPrefSuf}"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id=searchCancelledOr name="searchCancelledOr" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan" style="border: none; width: 90px; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="canORNo" name="canORNo" style="width: 90px; float: left; height: 15px;" class="rightAligned disableDelKey allCaps" maxlength="10" readonly="readonly" value="${giacOrRelOldOrNo}"/>
						</span>
					</td>
				</tr>
				<tr>
					<td />
					<td />
					<td class="rightAligned" style="width: 57px;">OR Status</td>
					<td style="width: 25%;">
						<input id="orFlag" style="width: 20%;" type="text" value="${orFlag}" readonly="readonly" class="list" />   <!-- added value  --> 
						<input id="meanORNo" type="text" style="width: 66%;" value="${orFlagRV}" readonly="readonly" class="list" />  <!-- added value  --> 
					</td>
					<td class="rightAligned" style="width: 55px;">PR No.</td>
					<td><input id="provReceiptNo" style="width: 93.5%;" type="text" value="${provReceiptNo}" maxlength="30" class="upper" /> </td>  <!-- added value  --> 
				</tr>
			</table>
			<br />
			<table width="96.5%" align="center" cellspacing="1" border="0">
				<tr>
					<td class="rightAligned" style="width: 9.2%">Payor</td>
					<td style="width: 40%">
						<div id="payorNameDiv" style="margin-left: 8px; border: 1px solid gray; width: 380px; height: 21px; float: left;" class="required">
							<input style="width: 350px; border: none; height: 12px; float: left;" id="payorName" name="payorName" type="text" value="${payor}" class="required list dcbEvent" maxLength="550" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmPayor" name="oscmPayor" alt="Go" />
						</div>
					</td>
					<td class="rightAligned" style="width: 15%">Address</td><!-- adpascual - 03.20.2012 - added valign-->
					<td style="width: 27%; padding-right: 13px" >
						<input id="payorAddress1" type="text" value="${address1}" style="width: 94%; margin-left: 8px;" class="list dcbEvent" maxLength="50" /><!-- adpascual - 03.20.2012 - renamed from payorAddress to payorAddress1 -->
					</td>
				</tr>
			</table>
			<table width="96.5%" align="center" cellspacing="1" border="0">
				<tr>
					<td class="rightAligned" style="width: 9.6%">Intermediary</td>
					<td style="width: 40%">
						<div style="margin-left: 8px; width: 380px; height: 21px; float: left;">
							<select id="intermediary" style="width: 382px;" class="list">
								<option value="">Select..</option>
								<c:forEach var="intmDetail" items="${intmDetails}">
									<option value="${intmDetail.intmNo}" style="width: 300px;"
										<c:if test="${intmNo eq intmDetail.intmNo}">
										selected="selected"
									</c:if>>
										${fn:escapeXml(intmDetail.intmName)}</option>
								</c:forEach>
								<!-- intmNo${intmDetail.intmNo} -->
							</select>
						</div>
					</td>
					<td class="rightAligned" style="width: 8%">&nbsp;</td><!-- adpascual - 03.20.2012 - added valign-->
					<td style="width: 30%; padding-right: 7px;">
						<input id="payorAddress2" type="text" value="${address2}" style="width: 95%" class="list dcbEvent" maxLength="50" /> <!-- adpascual - 03.20.2012 - added a new field -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 9.2%">TIN No.</td><!-- adpascual - 03.20.2012 - added valign-->
					<td style="width: 40%; padding-right: 7px;">
						<div style="margin-left: 8px; width: 380px; height: 21px; float: left; padding-bottom:4px; ">
							<input id="payorTinNo" type="text" value="${tin}" style="width: 375px" class="list dcbEvent" maxLength="30" />
						</div>
					</td>
					</div>
					<td class="rightAligned" style="width: 9.6%">&nbsp;</td><!-- adpascual - 03.20.2012 - added valign-->
					<td style="width: 41%; padding-right: 7px">
						<input id="payorAddress3" type="text" value="${address3}" style="width: 95%" class="list dcbEvent" maxLength="50" /> <br /> <!-- adpascual - 03.20.2012 - added a new field -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 5%">Particulars</td>
					<td colspan=3 style="width: 20%">
						<div id="payorParticularsDiv" style="border: 1px solid gray; height: 20px; width: 97.9%; margin-left: 7px;" class="required">
							<textarea id="payorParticulars" style="width: 96%; border: none; height: 13px; float: left;" class="required list dcbEvent" maxlength="500" >${particulars}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPayorParticulars" />
						</div>
					</td>
				</tr>
				<tr style="height: 25px;">
					<td class="rightAligned">Gross Tag</td>
					<td class="leftAligned" style="width: 48%">
						<input type="radio" id="gross" name="grossNet" value="Gross" style="margin-left: 7px;"/> Gross 
						<input type="radio" id="net" name="grossNet" value="Net" /> Net
						<span style="margin-left: 50px;">
							<input type="checkbox" id="riCommTag" name="riCommTag" style="margin-left: 10px; margin-right: 5px;" <c:if test="${riCommTag eq 'Y'}">checked="checked"</c:if> value="${riCommTag}"/> RI Commissions
						</span>
					</td>
					<td class="rightAligned" style="width: 15%"><label id="lblUploadTag" style="float: right;">Upload Tag</label></td>
					<td class="leftAligned" style="width: 5%">
						<input type="checkbox" id="uploadTag" name="uploadTag" style="margin-left: 10px; margin-right: 5px;" disabled="disabled" <c:if test="${uploadTag eq 'Y'}">checked="checked"</c:if> value="${uploadTag}" />
					</td>
				</tr>
			</table>
			<br />
			<div class="buttonDiv" id="officialReceiptButtonDiv">
			<table align="left" border="0" style="margin-left: 215px; margin-bottom: 15px;">
				<tr>
					<td><input type="button" class="button" id="orDetails" name="orDetails" value="OR Details" style="width: 90px;" /></td>
					<td><input type="button" class="button" id="accountingEntries" name="accountingEntries" value="Accounting Entries" style="width: 120px;" /></td>
					<td><input type="button" class="button" id="orPreview" name="orPreview" value="OR Preview" style="width: 90px;" /></td>
					<td><input type="button" class="button" id="spoilOR" name="spoilOR" value="Spoil OR" style="width: 90px;" /></td>
					<td><input type="button" class="button" id="commSlip" name="commSlip" value="Comm Slip" style="width: 90px;" /></td>
				</tr>
			</table>
		</div>
		</div>
	</div>
</div>
<script>
	makeInputFieldUpperCase();
	var origFCGrossAmt = 0;
	var objClosedTranArray = eval('${closedTranJSON}');
	//var now = new Date();
	var now = serverDate;
	
	$("orNo").value = '${orNo}' == '' ? '' : parseFloat('${orNo}').toPaddedString(10); //added by robert 11.07.2013
	
	initializeGlobalValues();
	/**
	 * Set values for global parameters - GIACS001
	 * @author : Dennis
	 * @version 1.0
	 * @modified : andrew - 10.08.2010 - replaced with global object parameter
	 */
	function initializeGlobalValues() {
		if (objACGlobal.gaccTranId == null || objACGlobal.gaccTranId == "") {
			//shan 02.15.2013 replaced ${grpIssCd} to avoid changing the Branch field to 'HO - Head Office' after saving new OR for other branch
			objACGlobal.branchCd		= '${branchDetails.branchCd}'; //'${grpIssCd}';
			objACGlobal.fundCd			= '${fundCd}';
			if (objACGlobal.orTag == null) {
				objACGlobal.orTag			= '${orTag}' == "null" ? "" : '${orTag}';
			}
			objACGlobal.orFlag			= '${orFlag}';
			objACGlobal.opTag			= '${opTag}';
			objACGlobal.withPdc			= '${withPdc}';
			objACGlobal.implSwParam		= '${implSwParameter}';
			objACGlobal.transaction		= 'Collection';
			objACGlobal.opRecTag		= 'N';
			objACGlobal.tranSource		= 'OR';
			objACGlobal.tranClass = '${collnSourceName}';
			/*
			if(objACGlobal.workflowEventDesc == "CANCEL OR" ){
				objACGlobal.orTag = 'C';
				objACGlobal.orCancel = 'Y';
				//objACGlobal.tranClass = '${collnSourceName}';
			} else {
				if (objACGlobal.workflowEventDesc != null){
					objACGlobal.orTag = 'S';
					objACGlobal.orCancel = 'N';
				}
			}

			if (objACGlobal.workflowEventDesc != "UNPAID PREMIUMS WITH CLAIMS" && objACGlobal.workflowEventDesc != null) {
				if (objACGlobal.orTag == '*') {
					objACGlobal.orTag = 'M';
				}
			}
			*/
		}
		objACGlobal.tranClass = '${collnSourceName}';
		objACGlobal.objClosedTranArray = eval('${closedTranJSON}');
	}
	
	if($F("uploadImplemSw") == "Y") {
		$("lblUploadTag").show();
		$("uploadTag").show();
	} else {
		$("lblUploadTag").hide();
		$("uploadTag").hide();
	}
	$("spoilOR").value = objAC.butLabel == null ? $F("spoilOR"): objAC.butLabel; //added the decode by steven 04.09.2013;nawawalan kasi ng name ung button.
	objAC.tranFlagState = '${tranFlag}';
	objAC.tranFlagState = objAC.tranFlagState == "" ? 'O' : objAC.tranFlagState;
	objACGlobal.tranFlagState = objAC.tranFlagState;
	
	var fcGrossAmt = 0;
	var fcCommAmt = 0;
	var fcTaxAmt = 0;
	
	$("fcGrossAmt").observe("focus", function() {
		fcGrossAmt = $F("fcGrossAmt");		
	});
	
	$("fcCommAmt").observe("focus", function() {
		fcCommAmt = $F("fcCommAmt");
	});
	
	$("fcTaxAmt").observe("focus", function() {
		fcTaxAmt = $F("fcTaxAmt");
	}); 
	
	if ($("orDate").value == "") {
		$("orDate").value = now.format("mm-dd-yyyy");
		$("orTime").value = now.format("h:MM:ss TT", false);
	}
	$("dcbYear").value = now.format("yyyy");
	$("tranMonth").value = now.format("mm");
	
	if (objACGlobal.gaccTranId == null && objACGlobal.orTag != '*'){
		$("canPrefSuf").readOnly = false;
		enableSearch("searchCancelledOr");//john 10.17.2014
		//$("canORNo").readOnly = false;
		$("orDate").disabled = false;
	}
	// added by Kris 02.04.2013: make the OR Date editable when creating new Manual OR [SR 11871]
	else if(objACGlobal.gaccTranId == null && objACGlobal.orTag == '*') { 
		$("orDate").disabled = false;
	}// end
	
	else{
		$("orDate").disabled = true;
		disableSearch("searchCancelledOr");//john 10.17.2014
		$("canPrefSuf").readOnly = true;
		//$("canORNo").readOnly = true;
		$("orDate").disabled = true;
	}

	$("orPrefSuf").observe("change", function () {  //from blur set to change - christian 09.17.2012
		validateOr();
	});

	$("orNo").observe("change", function () {  //from blur set to change - christian 09.17.2012
		validateOr();
	});

	function validateOr(){
		if (!isNaN($F("orNo"))){
			if (!$F("orNo").blank() && !$F("orPrefSuf").blank()){
				new Ajax.Request(contextPath + "/GIACOrderOfPaymentController?action=validateOr", {
					method: 'GET',
					parameters: {
						orPref: $F("orPrefSuf"),
						orNo: $F("orNo"),
						fundCd: objACGlobal.fundCd,
						branchCd: objACGlobal.branchCd			
					}, 
					asynchronous: true,
					onComplete : function (response){
						var result = response.responseText;
						if (result) {
							$("orNo").value = null; 
							customShowMessageBox(result, imgMessage.ERROR, "orNo");
						}else {
							$("orNo").value = parseFloat($F("orNo")).toPaddedString(10);
						}
					}
				});
			}
		}else {
			$("orNo").value = null;
			customShowMessageBox("Field must be of form 0000000009", imgMessage.ERROR, "orNo");
		}		
	}
	
	// added by Kris 01.29.2013: to show appropriate message for invalid day and/or month of remittance date
	function validateRemittanceORDate(str, elemName){
		var text = str; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		return status;
	}

	$("remittance").observe("change", function(){
		/*validateRemittanceDate(); // added by Kris 01.29.2013
		var inputDate = Date.parse($F("remittance"));
		if (inputDate != null){
			$("remittance").value = inputDate.format("mm-dd-yyyy");			
		}else{
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "remittance");
		}*/ // commented out by Kris 02.04.2013 test if the alternate function below will work so that when user inputs invalid remittance date, it will not continue.
		var inputDate = Date.parse($F("remittance"));
		if($F("remittance") == ""){
			$("remittance").setAttribute("lastValidValue", $F("remittance")); //Deo [02.16.2017]: SR-5932
			return true;
		}else {
			if(validateRemittanceORDate($F("remittance"), "remittance")){
				if (inputDate != null){
					$("remittance").value = inputDate.format("mm-dd-yyyy");			
					$("remittance").setAttribute("lastValidValue", $F("remittance")); //Deo [02.16.2017]: SR-5932
				}
			}else{
				customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "remittance");
				return false;
			}
		}
	});
	
	// added by Kris 02.04.2012
	$("remittance").observe("blur", function(){
		var inputDate = Date.parse($F("remittance"));
		
		if($F("remittance") == ""){
			$("remittance").setAttribute("lastValidValue", ""); //Deo [02.16.2017]: SR-5932
			return true;
		}else {
			if(validateRemittanceORDate($F("remittance"), "remittance")){
				if (inputDate != null){
					$("remittance").value = inputDate.format("mm-dd-yyyy");			
					$("remittance").setAttribute("lastValidValue", $F("remittance")); //Deo [02.16.2017]: SR-5932
				}
			}else{
				customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "remittance");
				return false;
			}	
		}
		
	});
	
	$("orDate").observe("blur", function() {
		var inputDate = Date.parse($F("orDate"));
		
		if($F("orDate") == "" || $F("orDate") == null){
			customShowMessageBox("O.R Date is required.", imgMessage.INFO, "orDate");			
		} else {
			if(validateRemittanceORDate($F("orDate"), "orDate")){
				if (inputDate != null){
					var dateDiff = null;
					if($F("orAnteDate") != null || $F("orAnteDate") != "") {
						dateDiff = computeNoOfDays($F("orDate"), dateFormat(new Date(), "mm-dd-yyyy"));
					}
					
					// added by Kris 01.30.2013: to replace the commented block below.
					var effDate = Date.parse($F("dcbUserEffectivityDate"));
					var expDate = Date.parse($F("dcbUserExpiryDate"));
					
					if(dateDiff != null && dateDiff > parseInt($F("orAnteDate")) && inputDate > effDate){
						 showMessageBox("You are no longer allowed to create an OR for "+$F("orDate")+".", "e");
						 $("orDate").value = dateFormat(new Date(), "mm-dd-yyyy");
							$("dcbNo").value = "";
							$("cashierCd").value = "";
							$("existingDCBNo").value = 0;
							$("newDCBNo").value = 0;
					}else{ 
						if(inputDate < effDate /* && $F("orDate") > $F("dcbUserExpiryDate") */ ){
							customShowMessageBox("Your Authority to issue an O.R. Starts on "+dateFormat(effDate, "mm-dd-yyyy")+".", imgMessage.INFO, "orDate");	
						} else if(effDate < inputDate && (inputDate < expDate || expDate == null)){
							if (checkClosedMonthYearTrans(inputDate.getMonth(), inputDate.getFullYear())){
								validatePopulateDCBWithoutMessage();
								if ($F("existingDCBNo") == 0){
									showConfirmBox("Create DCB_NO", "There is no open DCB No. for " + $F("orDate") + ". Create one?", "Yes", "No", validatePopulateDCB, cancelDCBCreation);//showDCBReminderDetails
								} 
							}
						} else if(effDate < inputDate && (inputDate > expDate || expDate == null)){
							customShowMessageBox("You are not authorized to issue an O.R beyond "+$F("dcbUserExpiryDate")+".", imgMessage.INFO, "orDate");
						}
					}
					
					/* commented out by Kris 01.30.2013
					if(dateDiff != null && dateDiff > parseInt($F("orAnteDate"))) {
						showMessageBox("You are no longer allowed to create an OR for "+$F("orDate")+".", "e");
						$("orDate").value = dateFormat(new Date(), "mm-dd-yyyy");
						$("dcbNo").value = "";
						$("cashierCd").value = "";
						$("existingDCBNo").value = 0;
						$("newDCBNo").value = 0;
					} else {
						$("orDate").value = inputDate.format("mm-dd-yyyy");
						if (checkClosedMonthYearTrans(inputDate.getMonth(), inputDate.getFullYear())){
							if (inputDate < authorityDate) {
								customShowMessageBox("Your Authority to issue an O.R. Starts on January 1,2000.", imgMessage.INFO, "orDate");
							}
							validatePopulateDCBWithoutMessage();
							if ($F("existingDCBNo") == 0){
								showConfirmBox("Create DCB_NO", "There is no open DCB No. for " + $F("orDate") + ". Create one?", "Yes", "No", validatePopulateDCB, cancelDCBCreation);//showDCBReminderDetails
							}
						}	
					}*/
					//}
				}else{
					customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "orDate");
				}
			}
		}
	});
	
	$("orDate").observe("change", function(){
		$("dcbNo").value = "";
		$("cashierCd").value = "";
		$("existingDCBNo").value = 0;
		$("newDCBNo").value = 0;
	});
	
	
/* 	function checkClosedMonthYearTrans(month, year){
		var isClosed = true;
		var spMonth = ["January", "February", "March", "April", "May", "June", 
		               "July", "August", "September", "October", "November", "December"];
		for(var i=0; i<objClosedTranArray.length; i++) {	
			if (month == (objClosedTranArray[i].tranMm-1) && year == objClosedTranArray[i].tranYr){
				customShowMessageBox("You are no longer allowed to create a transaction for " + spMonth[month] + " " + year +" This Transaction Month is already closed.", imgMessage.INFO, "orDate");
				$("orDate").value = now.format("mm-dd-yyyy");
				isClosed = false;
			}
		}

		return isClosed;
	} */

	function validateInput(paramField){
		var isValid = true;
		if (unformatCurrency(paramField) > 9999999999.99 || isNaN(unformatCurrency(paramField))){ // if (locCurrAmtLength > 13 || isNaN($F(paramField)) || $F(paramField) == "" ){  || unformatCurrency(paramField) < 0
			isValid = false;
		}
		
		return isValid;
	}
	
	function computeOnChangeLocalCurr() {
		if (unformatCurrency("deductionComm") != 0 || unformatCurrency("vatAmount") != 0){
			$("origlocalCurrAmt").value = unformatCurrency("localCurrAmt") + (unformatCurrency("deductionComm") + unformatCurrency("vatAmount"));
			$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
			$("fcGrossAmt").value = formatCurrency( Math.round((unformatCurrency("origlocalCurrAmt") / parseFloat($F("currRt")))*100)/100 );
			$("origFCGrossAmt").value  = unformatCurrency("fcGrossAmt");
			$("fcNetAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100); //added 10/20/2011
			/* 
			$("fcCommAmt").value = formatCurrency( Math.round((unformatCurrency("deductionComm") / parseFloat($F("currRt")))*100)/100 );
			$("fcTaxAmt").value = formatCurrency( Math.round((unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100 ); */
		}else{
			$("origlocalCurrAmt").value = unformatCurrency("localCurrAmt");
			$("grossAmt").value = formatCurrency($F("localCurrAmt"));
			$("fcGrossAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100);//formatCurrency($F("localCurrAmt"));
			$("origFCGrossAmt").value = unformatCurrency("fcGrossAmt");
			$("fcNetAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100);
		}
	}

	$("localCurrAmt").observe("change", function(){
		if (!validateInput("localCurrAmt")){
			customShowMessageBox("Invalid Local Currency Amount. Value should be from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "localCurrAmt");
			return;
		} 
		if(unformatCurrency("localCurrAmt") < 0.00){
			customShowMessageBox("Invalid amount.", imgMessage.INFO, "localCurrAmt");
			return;
		}
		if(unformatCurrency("localCurrAmt") > 500000) {
			showConfirmBox("Confirm", "Amount entered exceeds 500,000. Continue?", "Yes", "No", computeOnChangeLocalCurr,
					function() {
						$("localCurrAmt").value = $F("origlocalCurrAmt");
						return;
					});
		} else {
			computeOnChangeLocalCurr();
		}
		//fireEvent($("deductionComm"), "blur");
	});
	
	
	$("grossAmt").observe("change", function(){
		if (!validateInput("grossAmt")){
			customShowMessageBox("Invalid Gross Amount. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "grossAmt");
		}else {
			if (unformatCurrency("grossAmt") >= unformatCurrency("localCurrAmt") && (unformatCurrency("grossAmt") > unformatCurrency("deductionComm")) ){
				$("recompute").value = 'Y';
				$("origlocalCurrAmt").value = $F("grossAmt");
				$("fcGrossAmt").value = formatCurrency(  Math.round(( unformatCurrency("origlocalCurrAmt") / parseFloat($F("currRt")))*100)/100);
				$("origFCGrossAmt").value  = unformatCurrency("fcGrossAmt");
			}else if (unformatCurrency("grossAmt") < unformatCurrency("localCurrAmt") && unformatCurrency("grossAmt") > 0){
				$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
				showMessageBox("Gross amount should be larger than net amount.", imgMessage.ERROR);
				$("recompute").value = 'N';
			}else if (unformatCurrency("grossAmt") <= 0){	
				$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
				showMessageBox("Gross amount should be greater than zero.");
				$("recompute").value = 'N';
			}
			else if ((unformatCurrency("grossAmt") >= unformatCurrency("localCurrAmt")) && (unformatCurrency("grossAmt") < unformatCurrency("deductionComm")) ){
				$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
				showMessageBox("Gross Amount should be larger than net amount and Commission Amount");
				$("recompute").value = 'N';
			}
		}
	});

	$("deductionComm").observe("blur", function(){
		if (!validateInput("deductionComm")){
			customShowMessageBox("Invalid  Commission  Amount. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "deductionComm");
		}else {
			if ( unformatCurrency("deductionComm")>=0 && (unformatCurrency("deductionComm") <= unformatCurrency("grossAmt")) ){
				if(unformatCurrency("vatAmount") > unformatCurrency("deductionComm")) { //RCDatu begin
					showMessageBox("Tax amount should be lesser than commission amount.", imgMessage.ERROR);
					$("vatAmount").value = formatCurrency(0);
					$("fcCommAmt").value = 	formatCurrency( Math.round(( unformatCurrency("deductionComm") / parseFloat($F("currRt")))*100)/100 );
					$("fcTaxAmt").value = formatCurrency( Math.round(( unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100 );//RCDatu Add Computation
					$("recompute").value = 'Y';
					//RCDatu begin 01.10.2014
				}else if (formatCurrency(((unformatCurrency("grossAmt")) - unformatCurrency("deductionComm")) - unformatCurrency("vatAmount")) <= 0){
					showMessageBox("Net amount should not be lesser than or equal to zero.", imgMessage.ERROR);
					$("deductionComm").value = formatCurrency(0);
					$("vatAmount").value = formatCurrency(0);
					$("fcCommAmt").value = 	formatCurrency( Math.round(( unformatCurrency("deductionComm") / parseFloat($F("currRt")))*100)/100 );
					$("fcTaxAmt").value = formatCurrency( Math.round(( unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100 );//RCDatu Add Computation
					$("recompute").value = 'Y';
				}else{ //RCDatu End 01.10.2014
					$("fcCommAmt").value = 	formatCurrency( Math.round(( unformatCurrency("deductionComm") / parseFloat($F("currRt")))*100)/100 );
					$("recompute").value = 'Y';
				}				
			}else{				
					showMessageBox("Commission amount should be greater than 0 and not greater than gross amount.", imgMessage.ERROR);
					$("deductionComm").value = formatCurrency(0);
					$("recompute").value = 'Y'; //RCDatu	
				
				
			}
		}	
		
		//$("localCurrAmt").focus();//rcdatu
		//$("deductionComm").focus();
		
	});

	$("vatAmount").observe("blur", function(){
		if (!validateInput("vatAmount")){
			customShowMessageBox("Invalid VAT Amount. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "vatAmount");
		}else {
			if ( unformatCurrency("vatAmount") > 0 && (unformatCurrency("vatAmount") <= unformatCurrency("grossAmt")) && (unformatCurrency("vatAmount") <= unformatCurrency("deductionComm")) && unformatCurrency("vatAmount") <= unformatCurrency("localCurrAmt") ){
				$("fcTaxAmt").value = formatCurrency( Math.round(( unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100 );	
				$("recompute").value = 'Y';
			}else if(unformatCurrency("vatAmount") < unformatCurrency("deductionComm") && unformatCurrency("vatAmount") == unformatCurrency("localCurrAmt") ){
				showMessageBox("Net Amount  for this record is zero.");
				$("recompute").value = 'N';
			//}else if(unformatCurrency("vatAmount") < unformatCurrency("deductionComm") && unformatCurrency("vatAmount") > unformatCurrency("localCurrAmt") ){
			//	showMessageBox("Net Amount  should not be negative.");
			//	$("recompute").value = 'N'; //rcdatu 01.10.2014 comment out
			}
			else{
				showMessageBox("VAT amount should be greater than 0 but not greater than gross amount and commission amount.", imgMessage.INFO, "vatAmount"); //RCDatu Change to INFO
				$("vatAmount").value = formatCurrency(0);
				$("fcTaxAmt").value = formatCurrency( Math.round(( unformatCurrency("vatAmount") / parseFloat($F("currRt")))*100)/100 );//RCDatu Add Computation
				$("recompute").value = 'Y'; //RCDatu change to Y
			}
		}
	});

	$("fcGrossAmt").observe("blur", function(){
		if (unformatCurrency("origFCGrossAmt") != unformatCurrency("fcGrossAmt")){
			if (!validateInput("fcGrossAmt")){
				customShowMessageBox("Invalid FC Gross Amount. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "fcGrossAmt");
			}else {
				if(fcGrossAmt != $F("fcGrossAmt")) {
					if (unformatCurrency("fcGrossAmt") >= 0 && unformatCurrency("fcGrossAmt") >= unformatCurrency("fcNetAmt") && unformatCurrency("fcGrossAmt") >= unformatCurrency("fcCommAmt")){
						$("origlocalCurrAmt").value = formatCurrency(  Math.round(( unformatCurrency("fcGrossAmt") * parseFloat($F("currRt")))*100)/100 );
						$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
						$("origFCGrossAmt").value  = unformatCurrency("fcGrossAmt");
						$("recompute").value = 'Y';
					}else if(unformatCurrency("fcGrossAmt") < unformatCurrency("fcNetAmt")){
						customShowMessageBox("FC Gross Amount  should be larger than net amount.", imgMessage.INFO, "fcGrossAmt");	
						$("fcGrossAmt").value = $F("origFCGrossAmt"); 
						$("recompute").value = 'N';
					}else if(unformatCurrency("fcGrossAmt") > unformatCurrency("fcNetAmt") && unformatCurrency("fcGrossAmt") < unformatCurrency("fcCommAmt")){
						customShowMessageBox("FC Gross Amount should be larger than net amount and FC Commission Amount.", imgMessage.INFO, "fcGrossAmt");	
						$("fcGrossAmt").value = $F("origFCGrossAmt");
						$("recompute").value = 'N';
					}else{
						$("fcGrossAmt").value = formatCurrency( Math.round(( unformatCurrency("origlocalCurrAmt") / parseFloat($F("currRt")))*100)/100 );
						$("origFCGrossAmt").value  = unformatCurrency("fcGrossAmt");
						showMessageBox("FC Gross amount should be greater than zero.", imgMessage.ERROR);
					}
				}
			}
		}
	});
		
	$("fcCommAmt").observe("blur", function(){
		if (!validateInput("fcCommAmt")){
			customShowMessageBox("Invalid  FC Commission  Amount. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "fcCommAmt");
		}else {
			if(fcCommAmt != $F("fcCommAmt")) {
				if ( unformatCurrency("fcCommAmt")>=0 && (unformatCurrency("fcCommAmt")<= unformatCurrency("fcGrossAmt")) ){
					if (unformatCurrency("fcCommAmt")<unformatCurrency("fcTaxAmt")) { //RCDatu begin
	                	showMessageBox("FC tax amount should be lesser FC commission amount.", imgMessage.ERROR);
	                	$("fcTaxAmt").value = formatCurrency(0);
						$("deductionComm").value = 	formatCurrency( Math.round(( unformatCurrency("fcCommAmt") * parseFloat($F("currRt")))*100)/100 );
						$("vatAmount").value = 	formatCurrency( Math.round(( unformatCurrency("fcTaxAmt") * parseFloat($F("currRt")))*100)/100 ); 
						$("recompute").value = 'Y'; 
	                } else if(formatCurrency((Math.round(( unformatCurrency("grossAmt") / parseFloat($F("currRt")))*100)/100) - unformatCurrency("fcCommAmt") - unformatCurrency("fcTaxAmt")) <= 0) {
	                	//RCDatu begin 01.10.2014
	                	showMessageBox("FC Net amount should not be lesser than or equal to zero.", imgMessage.ERROR);
	                	$("fcTaxAmt").value = formatCurrency(0);
	                	$("fcCommAmt").value = formatCurrency(0);
	                	$("deductionComm").value = 	formatCurrency( Math.round(( unformatCurrency("fcCommAmt") * parseFloat($F("currRt")))*100)/100 );
	                	$("vatAmount").value = 	formatCurrency( Math.round(( unformatCurrency("fcTaxAmt") * parseFloat($F("currRt")))*100)/100 );
	                	$("recompute").value = 'Y'; 
	                	//RCDatu end 01.10.2014
	                } else {
	                    $("deductionComm").value = 	formatCurrency( Math.round(( unformatCurrency("fcCommAmt") * parseFloat($F("currRt")))*100)/100 );
	                    $("recompute").value = 'Y';
	                }
				}else{
					showMessageBox("FC Commission amount should be greater than 0 and not greater than FC gross amount.", imgMessage.ERROR);
					$("fcCommAmt").value = formatCurrency(0);
					 $("deductionComm").value = 	formatCurrency( Math.round(( unformatCurrency("fcCommAmt") * parseFloat($F("currRt")))*100)/100 ); //RCDatu
					$("recompute").value = 'N';
				}
			}
		}
	});

	$("fcTaxAmt").observe("blur", function(){
		if (!validateInput("fcTaxAmt")){
			customShowMessageBox("Invalid  FC tax  Amount. Valid value is from 0.00 to 9,999,999,999.99.", imgMessage.INFO, "fcTaxAmt");
		}else {
			if(fcTaxAmt != $F("fcTaxAmt")) {
				if ( unformatCurrency("fcTaxAmt")>=0 && (unformatCurrency("fcTaxAmt")<= unformatCurrency("fcGrossAmt")) && (unformatCurrency("fcTaxAmt")<= unformatCurrency("fcCommAmt")) && unformatCurrency("fcTaxAmt") != unformatCurrency("fcNetAmt") && (unformatCurrency("fcNetAmt") - unformatCurrency("fcTaxAmt")) >= 0 ){
					$("vatAmount").value = 	formatCurrency( Math.round(( unformatCurrency("fcTaxAmt") * parseFloat($F("currRt")))*100)/100 );
					$("recompute").value = 'Y';
				}else if(unformatCurrency("fcTaxAmt") < unformatCurrency("fcCommAmt") && unformatCurrency("fcTaxAmt") == unformatCurrency("fcNetAmt")){
					$("vatAmount").value = 	formatCurrency( Math.round(( unformatCurrency("fcTaxAmt") * parseFloat($F("currRt")))*100)/100 );
					$("recompute").value = 'Y';
					showMessageBox("FC Net Amount for this is Zero.");
				//}else if(unformatCurrency("fcTaxAmt") < unformatCurrency("fcCommAmt") && unformatCurrency("fcTaxAmt") > unformatCurrency("fcNetAmt")){
				//	showMessageBox("FC net amount should not be negative");	
				//	$("fcTaxAmt").value = formatCurrency(0);
				//	$("recompute").value = 'N';  //RCDatu 01.10.2014 comment out
				}else{
					showMessageBox("FC tax amount should be greater than 0 but not greater than FC gross amount and FC commission amount.", imgMessage.ERROR);
					$("fcTaxAmt").value = formatCurrency(0);
					$("vatAmount").value = 	formatCurrency( Math.round(( unformatCurrency("fcTaxAmt") * parseFloat($F("currRt")))*100)/100 ); //RCDatu 
					$("recompute").value = 'Y'; //RCDatu
				}
			}
		}	
	});

	//comment out john 10.27.2014
	/* $("canORNo").observe("keydown", function(e){
		if (e.keyCode == 13) {
			new Ajax.Updater("", "GIACOrderOfPaymentController?action=validateCancelledORInput", {
				method: "GET",
				parameters: {
					canPrefSuf: $F("canPrefSuf"),
					canORNo: $F("canORNo"),
					ajax: "1"
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: function(){
					showNotice("Verifying Cancelled OR information, please wait...");
				},
				onComplete: function (response)	{
					if (checkErrorOnResponse(response)) {
						hideNotice();
						try {
						var resXML = response.responseXML;
						if (resXML.getElementsByTagName("payor")[0].childNodes[0].nodeValue != ""){
							$("payorName").value = resXML.getElementsByTagName("payor")[0].childNodes[0].nodeValue;
							$("payorAddress1").value = resXML.getElementsByTagName("address1")[0].childNodes[0].nodeValue;
							$("payorAddress2").value = resXML.getElementsByTagName("address2")[0].childNodes[0].nodeValue;
							$("payorAddress3").value = resXML.getElementsByTagName("address3")[0].childNodes[0].nodeValue;$("payorParticulars").value = resXML.getElementsByTagName("particulars")[0].childNodes[0].nodeValue;
							$("payorTinNo").value = resXML.getElementsByTagName("tin")[0].childNodes[0].nodeValue;
							$("address1").value = resXML.getElementsByTagName("address1")[0].childNodes[0].nodeValue;
							$("address2").value = resXML.getElementsByTagName("address2")[0].childNodes[0].nodeValue;
							$("address3").value = resXML.getElementsByTagName("address3")[0].childNodes[0].nodeValue;
							$("cancelledORDate").value = resXML.getElementsByTagName("orDate")[0].childNodes[0].nodeValue;
							$("cancelledORTag").value = resXML.getElementsByTagName("orTag")[0].childNodes[0].nodeValue;
							objACGlobal.gaccTranId = resXML.getElementsByTagName("gaccTranId")[0].childNodes[0].nodeValue;
						}else{
							$("payorName").value = "";
							$("payorAddress1").value = "";
							$("payorAddress2").value = "";
							$("payorAddress3").value = "";
							$("payorParticulars").value = "";
							$("payorTinNo").value = "";
							$("payorParticulars").value = "";
							$("address1").value = "";
							$("address2").value = "";
							$("address3").value = "";
							$("cancelledORDate").value = "";
							$("cancelledORTag").value = "";
							objACGlobal.gaccTranId = null;
							showMessageBox("Invalid value for Cancelled OR No.", imgMessage.ERROR);
						}
						} catch (e) {
							showErrorMessage("officialReceiptInformation.jsp - canORNo", e);
						}
					}
				}
			});
		}
	}); */

	$("oscmPayor").observe("click", function ()	{
		if ($("oscmPayor").disabled != true){
			openSearchPayorModal();
		}
	});	

	 
	$("orDetails").observe("click", function () {
		// added by Kris 01.29.2013 
		if(changeTag == 1){
			showMessageBox("Please save the record first.");
			return false;
		} 
		// end 
		 if (objACGlobal.gaccTranId != null){
			//added by steven 2/25/2013; para ipasa ung parameter na kailangan sa pagprint ng OR,pwede ka rin kasing makapunta ng OR Preview gamit ang button na to.
			objORPrinting.dcbNo = $F("dcbNo");
			objORPrinting.cashierCd = $F("cashierCode");
			objORPrinting.collectionAmt = $F("netCollectionAmt");
			objORPrinting.grossAmt = $F("totGrossAmt");
			objORPrinting.grossTag = $("gross").checked == true ? 'Y' : 'N';
			
			var tranSource = 'OR';
			var callingForm = 'DETAILS';
			updateGlobalValues(tranSource, callingForm);
			if(objACGlobal.riCommTag == "Y" || $("riCommTag").checked){
				showORInfoWithAcctEntries();
				$$("div[name='subMenuDiv']").each(function(row){
					row.hide();
				});
				$$("div.tabComponents1 a").each(function(a){
					if(a.id == "acctEntries") {
						$("acctEntries").up("li").addClassName("selectedTab1");					
					}else{
						a.up("li").removeClassName("selectedTab1");	
					}
				});
			}else{
				showORInfo();
			}
		}else{
			showMessageBox("Please save this record first.");
		} 
	});
	
		
	//observeAccessibleModule(accessType.BUTTON, "GIACS025", "orPreview",  //changed accessType to BUTTON christian 09.27.2012
	$("orPreview").observe("click",  
		function(){
			//added by Kris 01.30.2013
			if(changeTag == 1){
				showMessageBox("Please save the record first.");
				return false;
			} // end
			
			//added by d.alcantara 07/04/2011
			objORPrinting.dcbNo = $F("dcbNo");
			objORPrinting.cashierCd = $F("cashierCode");
			objORPrinting.collectionAmt = $F("netCollectionAmt");
			objORPrinting.grossAmt = $F("totGrossAmt");
			objORPrinting.grossTag = $("gross").checked == true ? 'Y' : 'N';
			
			if (objACGlobal.gaccTranId != null){
				var tranSource = 'OR';
				var callingForm = 'DETAILS';
				updateGlobalValues(tranSource, callingForm);
				showORInfoWithORPreview();
				$$("div[name='subMenuDiv']").each(function(row){
					row.hide();
				});
				objACGlobal.tranClass = '0';
				$("opPrev").show();
				$$("div.tabComponents1 a").each(function(a){
					if(a.id == "opPreview") {
						$("opPreview").up("li").addClassName("selectedTab1");					
					}else{
						a.up("li").removeClassName("selectedTab1");	
					}	
				});
			}else{
				showMessageBox("Please save this record first.");
			}
		}
	); 
	
	
	//observeAccessibleModule(accessType.BUTTON, "GIACS030", "accountingEntries",   //changed accessType to BUTTON christian 09.27.2012
	$("accountingEntries").observe("click",  
			function() {				
				//added by Kris 01.29.2013
				if(changeTag == 1){
					showMessageBox("Please save the record first.");
					return false;
				} //end
		
				//added by steven 2/25/2013; para ipasa ung parameter na kailangan sa pagprint ng OR,pwede ka rin kasing makapunta ng OR Preview gamit ang button na to.
				objORPrinting.dcbNo = $F("dcbNo");
				objORPrinting.cashierCd = $F("cashierCode");
				objORPrinting.collectionAmt = $F("netCollectionAmt");
				objORPrinting.grossAmt = $F("totGrossAmt");
				objORPrinting.grossTag = $("gross").checked == true ? 'Y' : 'N';
				if (objACGlobal.gaccTranId != null){
					var tranSource = 'OP';
					var callingForm = 'ACCT_ENTRIES';
					updateGlobalValues(tranSource, callingForm);
					showORInfoWithAcctEntries();
					$$("div[name='subMenuDiv']").each(function(row){
						row.hide();
					});
					$$("div.tabComponents1 a").each(function(a){
						if(a.id == "acctEntries") {
							$("acctEntries").up("li").addClassName("selectedTab1");					
						}else{
							a.up("li").removeClassName("selectedTab1");	
						}	
					});
				}else{
					showMessageBox("Please save this record first.");
				}
		});  
		
	/* 
		$("accountingEntries").observe("click", function (){
			if (objACGlobal.gaccTranId != null){
				var tranSource = 'OP';
				var callingForm = 'ACCT_ENTRIES';
				updateGlobalValues(tranSource, callingForm);
				showORInfoWithAcctEntries();
			}else{
				showMessageBox("Please save this record first.");
			}
		}); */

	function checkCommPayts(){
		if($F("checkCommPayts") == "Y") { // added by andrew - 09.08.2012
			new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
				parameters: {action : "checkCommPayts",
							 gaccTranId : objACGlobal.gaccTranId},
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						validateSpoilCancelOr();						
					}
				}
			});
		} else {
			validateSpoilCancelOr();
		} 
	}
		
	function validateSpoilCancelOr(){
		if ($F("spoilOR") == "Spoil OR"){
			if ($F("orFlag") == 'P'){
				if (objACGlobal.orTag == "" || objACGlobal.orTag == null){
					showConfirmBox("Spoil O.R." , "Are you sure you want to spoil O.R. No. "  + $F("orPrefSuf") + "-" + formatNumberDigits($F("orNo"), 10) + "?", "Yes", "No", spoilOr, "");
				}else {
					showMessageBox("Spoiling of a manual O.R. is not allowed.", imgMessage.INFO);
				}
			}else if ($F("orFlag") == 'N'){
				showMessageBox('This O.R. has not yet been printed.', 'I', imgMessage.INFO);
			}else if ($F("orFlag") == 'C'){
				showMessageBox('This O.R. has already been cancelled.', 'I', imgMessage.INFO);
			}else if ($F("orFlag") == 'R'){
				showMessageBox('This O.R. has already been cancelled and replaced.', imgMessage.INFO);
			}else if ($F("orFlag") == 'D'){
				showMessageBox('This O.R. has already been deleted.', 'I', imgMessage.INFO);
			}else {
				showMessageBox('Spoiling not allowed.', 'I', imgMessage.INFO);
			}
		}else if ($F("spoilOR") == "Cancel OR") {
			if ($F("orFlag") == 'N'){
				showConfirmBox("Cancel O.R." , "Do you want to cancel this unprinted O.R.?", "Yes", "No", spoilOr, "");
			}else if ($F("orFlag") == 'P'){
				showConfirmBox("Cancel O.R." , "Do you want to cancel O.R. No. "  + $F("orPrefSuf") + "-" + formatNumberDigits($F("orNo"), 10) + "?", "Yes", "No", spoilOr, "");
			}else if ($F("orFlag") == 'C') {
				showMessageBox('This O.R. has already been cancelled.', imgMessage.INFO);
			}else if ($F("orFlag") == 'R') {
				showMessageBox('This O.R. has already been cancelled and replaced.',imgMessage.INFO);
			}else if ($F("orFlag") == 'D') {
				showMessageBox('This O.R. has already been deleted.', 'I', imgMessage.INFO);
			}else {
				showMessageBox('Cancellation not allowed.', 'I', imgMessage.INFO);
			}
		}
	}

	$("spoilOR").observe("click", checkCommPayts);

	function spoilOr(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController?action=spoilOr", {
			method: "GET",
			parameters: {
				gaccTranId: objACGlobal.gaccTranId,
				butLabel: $F("spoilOR"),	
				orFlag:   objACGlobal.orFlag,
				orTag: objACGlobal.orTag,
				orPrefSuf: $F("orPrefSuf"),
				orNo:	$F("orNo"),
				gibrFundCd: objACGlobal.fundCd,
				gibrBranchCd: objACGlobal.branchCd,
				orDate:	$F("orDate"),
				dcbNo: $F("dcbNo"),
				callingForm: "BANNER_SCREEN", // ADDED TEXT FOR THE CONDITION IN giac_acctrans_pkg.create_records_in_acctrans -- irwin 11.15.11
				moduleName: "GIACS001",
				orCancellation: objAC.butLabel == "Cancel OR" ? 'Y' : 'N',
				payor: $F("payorName"),
				collectionAmt: $F("netCollectionAmt"),
				cashierCd: $F("cashierCode"),
				grossAmt: $F("totGrossAmt"),
				grossTag: $("gross").checked == true ? 'Y' : 'N',
				itemNo: 1			
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var result = response.responseText.toQueryParams();
				if (result.message != "null") {
					showMessageBox(result.message, imgMessage.ERROR);
				}else{
					showMessageBox("Saving successful.", imgMessage.SUCCESS);
					$("orPrefSuf").value = result.orPrefSuf == "null" ? "" : result.orPrefSuf;
					$("orNo").value = result.orNo == "null" ? "" : result.orNo;
					if ($F("spoilOR") == "Spoil OR"){
						$("orFlag").value = "N";
						objACGlobal.orFlag = "N";
						$("meanORNo").value = "New";
					}else {
						$("orFlag").value = "C";
						objACGlobal.orFlag = "C";
						$("meanORNo").value = "Cancelled";
					}
					setORParams();
					editORInformation(); // andrew - 09.01.2012
					changeTag = 0;
				}
			}
		});
	}

	function updateGlobalValues(tranSource, callingForm) {
		objACGlobal.branchCd = $F("branchCd");
		objACGlobal.fundCd = $F("gfunFundCd");
		objACGlobal.tranSource = tranSource;
		objACGlobal.callingForm = callingForm;
		objACGlobal.withPdc = $("withPdc").value == "" ? 'N' : 'Y';
		objACGlobal.documentName = "";
		objACGlobal.implSwParam = $F("implSwParam");
		objACGlobal.calledForm	= "";
		objACGlobal.riCommTag = $("riCommTag").checked ? "Y" : "N"; // added by: Nica 06.14.2013 AC-SPECS-2012-155
	}

	$("payorName").observe("keyup", function(){
		$("payorName").value = $("payorName").value.toUpperCase();
	});
	
	
	$("orPrefSuf").observe("keyup", function(){
		$("orPrefSuf").value = $("orPrefSuf").value.toUpperCase();
	});
	
	if(objACGlobal.orTag == "S") {
		if(objACGlobal.orFlag == null || 
		   (objACGlobal.orFlag=="P"||objACGlobal.orFlag=="C"||objACGlobal.orFlag=="R"||objACGlobal.orFlag=="D")
		   || $F("apdcSw") == "1") {
			$("provReceiptNo").readonly = true;
			$("payor").readonly = true;
			$("particulars").readonly = true;
			$("intermediary").disable();
			//disable address
			// disable grosstag
			$("payorTinNo").readonly = true;
		} else if(objACGlobal.orFlag == "N") {
			/* $("provReceiptNo").readonly = false;
			$("payor").readonly = false;
			$("particulars").readonly = false;
			$("intermediary").enable();
			//disable address
			// disable grosstag
			$("payorTinNo").readonly = false; */
		} 
	} else if(objACGlobal.orTag == "M") {
		if(objACGlobal.orFlag == "C" || objACGlobal.orFlag == "R" || objACGlobal.orFlag == "D" || objACGlobal.orFlag == null) {
			$("provReceiptNo").readonly = true;
			$("payor").readonly = true;
			$("particulars").readonly = true;
			$("intermediary").disable();
			//disable address
			// disable grosstag
			$("payorTinNo").readonly = true;
		} else if (objACGlobal.orFlag == "P") {
			if(objAC.tranFlagState == "O") {
				
			} else {
				$("provReceiptNo").readonly = true;
				$("payor").readonly = true;
				$("particulars").readonly = true;
				$("intermediary").disable();
				//disable address
				// disable grosstag
				$("payorTinNo").readonly = true;
			}
		}
	}
	// added condition for objACGlobal.orTag == "" christian 08.30.2012
	if ((objACGlobal.orTag == null || objACGlobal.orTag == "") &&  (objACGlobal.orFlag != 'P' && objACGlobal.orFlag != 'C' && objACGlobal.orFlag != 'S' && objACGlobal.orFlag != 'M' && objACGlobal.orFlag != 'R') ){ // objACGlobal.orFlag.indexOf("PCNSM") == -1 //objACGlobal.orFlag != 'R' Added by Jerome Bautista 11.20.2015 SR 20817 
		$("meanORNo").value = "New";
		$("orFlag").value = "N";
	/*}else if (objACGlobal.orTag == '*' &&  objACGlobal.orFlag != 'N'){
		$("meanORNo").value = "Printed";
		$("orFlag").value = "P";*/ //Deo [02.10.2017]: comment out, displays printed even when already cancelled (SR-5932)
	}else if (objACGlobal.orFlag == 'P'){
		$("meanORNo").value = "Printed";
		$("orFlag").value = "P";
	}else if (objACGlobal.orFlag == 'R'){ //Added by Jerome Bautista 11.20.2015 SR 20817
		$("meanORNo").value = "Replaced";
		$("orFlag").value = "R";
	}else if (objACGlobal.orFlag == 'C'){
		$("meanORNo").value = "Cancelled";
		$("orFlag").value = "C";
	}else if (objACGlobal.orTag == 'S' && objACGlobal.opTag == 'S'){
		$("meanORNo").value = "New";
		$("orFlag").value = "N";
	}else if (objACGlobal.orTag == 'S' && objACGlobal.opTag == 'M'){
		$("meanORNo").value = "New";
		$("orFlag").value = "N";	
	}else if (objACGlobal.orTag == 'M' && objACGlobal.opTag == 'M'){
		$("meanORNo").value = "Printed";
		$("orFlag").value = "P";
	}else if ((objACGlobal.orTag == "*") &&  (objACGlobal.orFlag != 'P' && objACGlobal.orFlag != 'C' && objACGlobal.orFlag != 'S' && objACGlobal.orFlag != 'M') ){ // added by Kris 02.06.2013 [SR 11871]
		$("meanORNo").value = "Printed"; //"New";
		$("orFlag").value = "P"; //"N";
	} //end
	if ($F("dcbNo") != ""){
		$("cashierCd").value = $F("cashierCode");
	}

	$("editPayorParticulars").observe("click", function () {
		//showEditor("payorParticulars", 500);
		showOverlayEditor("payorParticulars", 500, $("payorParticulars").hasAttribute("readonly")); // andrew - 08.14.2012
		changeTag = 1; //added by robert 10.09.2013
	});
	
	// added by Kris 01.29.2013
	$("payorParticulars").observe("keyup", function(){
		if($F("payorParticulars").length > 500){ //removed = by robert 10.09.2013
			showMessageBox("You have exceeded the maximum number of allowed characters (500) for this field.", "I");			
		}
	}); //end
	
	/* $("commSlip").observe("click", function (){
		if (checkClosedMonthYearTrans(Date.parse($F("orDate")).getMonth(), Date.parse($F("orDate")).getFullYear())){
			if ($F("existingDCBNo") == 0){
				showConfirmBox("Create DCB_NO", "There is no open DCB No. for " + $F("orDate") + ". Create one?", "Yes", "No", 
						function(){
							objACGlobal.commSlip = 1;
							validatePopulateDCB();
						}, 
						function(){
							objACGlobal.commSlip = 0;
							cancelDCBCreation();//showDCBReminderDetails
						}
				);
			}else{
				showCommSlip();
			}
		}
	}); */
	
	//marco - replaced codes above with codes below - 10.08.2013
	function goToCommSlipPage(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		if(checkClosedMonthYearTrans(Date.parse($F("orDate")).getMonth(), Date.parse($F("orDate")).getFullYear())){
			if($F("existingDCBNo") == 0){
				showConfirmBox("Create DCB_NO", "There is no open DCB No. for " + $F("orDate") + ". Create one?", "Yes", "No", 
						function(){
							objACGlobal.commSlip = 1;
							validatePopulateDCB();
						}, 
						function(){
							objACGlobal.commSlip = 0;
							cancelDCBCreation();//showDCBReminderDetails
						}
				);
			}else{
				showCommSlip();
			}
		}
	}
	
	if(nvl('${showCommSlip}', 'N') == "Y"){
		$("commSlip").show();
		observeAccessibleModule("button", "GIACS154", "commSlip", goToCommSlipPage);
	} else {
		$("commSlip").hide();
	}
	
	$("searchCancelledOr").observe("click", showCancelledOrLOV);
	
	//john 10.14.2014
	function showCancelledOrLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs001CancelledOr",
						page : 1
				},
				title: "List of Cancelled OR",
				width: 550,
				height: 400,
				columnModel: [
		 			{
						id : 'orPrefSuf',
						title: 'OR Pref',
						width : '50px',
						align: 'left'
					},
					{
						id : 'orNo',
						title: 'OR No',
						width : '50px',
						align: 'right',
						titleAlign: 'right'
					},
					{
						id : 'payor',
						title: 'Payor',
					    width: '200px',
					    align: 'left'
					},
					{
						id : 'particulars',
						title: 'Particulars',
					    width: '200px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2($("canPrefSuf").value), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("canPrefSuf").value = unescapeHTML2(row.orPrefSuf);
						$("canORNo").value = lpad(row.orNo, 10, 0);
						$("payorName").value = unescapeHTML2(row.payor);
						$("payorParticulars").value = unescapeHTML2(row.particulars);
						$("payorTinNo").value = unescapeHTML2(row.tin);
						$("payorAddress1").value = unescapeHTML2(row.address1);
						$("payorAddress2").value = unescapeHTML2(row.address2);
						$("payorAddress3").value = unescapeHTML2(row.address3);
						objGiacOrRel = row;
						changeTag = 1;
						showConfirmBox("Confirmation", "Do you want to copy the collection breakdown of cancelled OR?", "Yes", "No",
								function(){
									getCollnBreakDown(row.gaccTranId);
								},
								null, "");
					}
				},
				onCancel: function(){
					$("canPrefSuf").focus();
		  		},
		  		onUndefinedRow: function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "canPrefSuf");
		  		}
			});
		}catch(e){
			showErrorMessage("showCancelledOrLOV",e);
		}
	}
	
	//john 10.15.2014
	function getCollnBreakDown(gaccTranId){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			method: "POST",
			parameters: {
				action: "getCnclCollnBreakDown",
				gaccTranId: gaccTranId
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					for (var i = 0; i < obj.length; i++) {
						addCnclCollnBreakDown(obj[i]);
					}
				}
			}
		});
	}
	
	function addCnclCollnBreakDown(obj){
		$("paymentMode").value = obj.payMode;
		fireEvent($("paymentMode"), "change");
		$("checkClass").value = obj.checkClass;
		$("checkCreditCardNo").value = obj.checkNo;
		$("checkDateCalendar").value = obj.checkDate;
		$("localCurrAmt").value = obj.amount;
		$("currency").value = obj.currencyCd;
		$("currRt").value = obj.currencyRt;
		$("grossAmt").value = obj.grossAmt;
		$("deductionComm").value = obj.commissionAmt;
		$("vatAmount").value = obj.vatAmt;
		$("fcGrossAmt").value = obj.fcGrossAmt;
		$("fcCommAmt").value = obj.fcCommAmt;
		$("fcTaxAmt").value = obj.fcTaxAmt;
		$("bank").value = obj.bankCd;
		
		fireEvent($("btnAdd"), "click");
	}
	
	//added by nok
	//$("acExit").stopObserving("click");
	/* $("acExit").observe("click", function(){
		updateMainContentsDiv("/GIACOrderOfPaymentController?action=showORListing",
			"Retrieving OR data, please wait...");
		objAC.butLabel = "Spoil OR";
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
	}); */
	
	$("hrefRemitDate").observe("click", function(){
		scwNextAction = remitDateUpd.runsAfterSCW(this, null); //Deo [02.16.2017]: SR-5932
		scwShow($('remittance'),this, null);
	});
	
	function remitDateUpd() { //Deo [02.16.2017]: SR-5932
		if ($F("remittance") != $("remittance").readAttribute("lastValidValue")) {
			$("remittance").setAttribute("lastValidValue", $F("remittance"));
			changeTag = 1;
		}
	}
	
	//marco - 09.08.2014
	if(nvl('${dcbUserInfo.validTag}', 'N') == "N"){
		showWaitingMessageBox("You are not authorized to create records for this Company/Branch.", "E", function(){
			fireEvent($("acExit"), "click");
		});
	}else if(compareDatesIgnoreTime(Date.parse($F("dcbUserEffectivityDate"), 'mm-dd-yyyy'), new Date()) == -1){
		showWaitingMessageBox("Your authority to process an O.R. for this company/branch starts on " + $F("dcbUserEffectivityDate") + ".", "E", function(){
			fireEvent($("acExit"), "click");
		});
	}else if($F("dcbUserExpiryDate") != "" && compareDatesIgnoreTime(Date.parse($F("dcbUserExpiryDate"), 'mm-dd-yyyy'), new Date()) == 1){
		showWaitingMessageBox("Your authority to process an O.R. for this company/branch has expired last " + $F("dcbUserExpiryDate") + ".", "E", function(){
			fireEvent($("acExit"), "click");
		});
	}
	
	initializeAccordion();
	initializeAllComputationFields();
	initializeDcbEventObjects();
	$("remittance").setAttribute("lastValidValue", $F("remittance")); //Deo [02.16.2017]: SR-5932
</script>
