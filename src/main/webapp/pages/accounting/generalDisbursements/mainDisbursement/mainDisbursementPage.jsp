<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
		<label>
		<c:if test="${disbursement eq 'CPR'}">Payment Requests Details</c:if>
		<c:if test="${disbursement eq 'FPP'}">Facultative Premium Payment Details</c:if>
		<c:if test="${disbursement eq 'CP'}">Commission Payment Details</c:if>
		<c:if test="${disbursement eq 'OP'}">Other Payment Details</c:if>
		<c:if test="${disbursement eq 'CR'}">Cancel Requests Details</c:if>
   		</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="disbursementRequestsDiv1" changeTagAttr="true">
	<table style="margin-top: 10px; margin-bottom: 10px;" width="80%" align="center" cellspacing="1" border="0">
		<tr>
			<td class="rightAligned" style="width: 103px;">Company</td>
			<td class="leftAligned">
				<input type="hidden" id="txtFundCd" name="txtFundCd" readonly="readonly" />
				<input type="hidden" id="txtDspFundDesc" name="txtDspFundDesc" readonly="readonly" />
				<div style="width: 326px; margin-left: 4px; float: left;" class="withIconDiv required">
					<input style="width: 300px;" id="company" name="company" type="text" value="" readOnly="readonly" class="withIcon required" />
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovCompany" name="lovCompany" alt="Go" />
				</div>
			</td>
			<td class="rightAligned" style="width: 103px;">Branch</td>
			<td class="leftAligned">
				<input type="hidden" id="txtBranchCd" name="txtBranchCd" readonly="readonly" />
				<input type="hidden" id="txtDspBranchName" name="txtDspBranchName" readonly="readonly" />
				<!-- <div style="width: 216px; margin-left: 4px; float: left;" class="withIconDiv required"> -->
					<input style="width: 190px;" id="branch" name="branch" type="text" value="" readOnly="readonly" class="required" />
					<%-- <img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBranch" name="lovBranch" alt="Go" /> --%> <!-- removed by kenneth L. 11.12.2013 -->
				<!-- </div> -->
			</td>
		</tr>
	</table>
</div>
<div class="sectionDiv" id="disbursementRequestsDiv2" changeTagAttr="true">
	<table border="0" align="left" style="margin-left: 87px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned">Request No.</td>
			<td class="leftAligned">
				<input type="hidden" id="varDocumentName" name="varDocumentName" readonly="readonly"/>
				<input type="hidden" id="varLineCdTag" name="varLineCdTag" readonly="readonly"/>
				<input type="hidden" id="varYyTag" name="varYyTag" readonly="readonly"/>
				<input type="hidden" id="varMmTag" name="varMmTag" readonly="readonly"/>
				<div style="width: 61px; float: left;" class="withIconDiv required">
					<input style="width: 35px;" id="txtDocumentCd" name="txtDocumentCd" type="text" value="" readOnly="readonly" class="withIcon required" />
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDocumentCd" name="lovDocumentCd" alt="Go"/>
				</div>
				<input style="width: 25px; float: left;" type="text" id="txtDspBranchCd" name="txtDspBranchCd" readonly="readonly"/>
				<div id="lovLineCdDiv" style="width: 51px; float: left; margin-left: 4px;" class="withIconDiv">
					<input style="width: 25px;" id="txtLineCd" name="txtLineCd" type="text" value="" readOnly="readonly" class="withIcon" />
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovLineCd" name="lovLineCd" alt="Go" />
				</div>
				<input style="width: 50px; text-align: right;" type="text" id="txtDocYear" name="txtDocYear"  class="required" maxlength="4" readonly="readonly"/>
				<input style="width: 35px; text-align: right;" type="text" id="txtDocMm" name="txtDocMm"  class="required" maxlength="2" readonly="readonly"/>
				<input style="width: 55px; text-align: right;" type="text" id="txtDocSeqNo" name="txtDocSeqNo" readonly="readonly" />
			</td>
			<td class="rightAligned" style="width: 100px;">Status</td>
			<td class="leftAligned">
				<input style="width: 45px;" type="text" id="txtPaytReqFlag" name="txtPaytReqFlag" readonly="readonly"/>
				<input style="width: 155px;" type="text" id="txtMeanPaytReqFlag" name="txtMeanPaytReqFlag" readonly="readonly"/>
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Department</td>
			<td class="leftAligned">
				<input type="hidden" id="txtGoucOucId" name="txtGoucOucId" readonly="readonly"/>
				<div style="width: 71px; float: left;" class="withIconDiv required">
					<input style="width: 45px; text-align: right;" id="txtDspDeptCd" name="txtDspDeptCd" type="text" value="" class="withIcon required" ignoreDelKey="1"/>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDspOucName" name="lovDspOucName" alt="Go" class=""/>
				</div>
				<!-- <input style="float: left; width: 45px; text-align: right; margin-right: 4px;" type="text" id="txtDspDeptCd" name="txtDspDeptCd" readonly="readonly required"/> -->
				<input style="width: 248px;" id="txtDspOucName" name="txtDspOucName" type="text" value="" readOnly="readonly" class="required" />
			</td>
			<td class="rightAligned">Created By</td>
			<td class="leftAligned"><input style="width: 212px;" type="text" id="txtCreateBy" name="txtCreateBy" readonly="readonly"/></td>
		</tr>	
		<tr>
			<td class="rightAligned">Date</td>
			<td class="leftAligned">
				<!-- <input style="width: 212px;" type="text" id="txtRequestDate" name="txtRequestDate" readonly="readonly" maxlength="10" class="required"/> -->
				<div style="width: 115px;" class="required withIconDiv">
		    		<input style="width: 90px;" type="text" id="txtRequestDate" name="txtRequestDate" readonly="readonly" maxlength="10" class="required withIcon" triggerChange = "Y"/>
		    		<img class="disabled" id="hreftxtRequestDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Request Date" onClick="scwShow($('txtRequestDate'),this, null);" />
		    	</div>	
			</td>
			<td class="rightAligned">Cancelled By</td>
			<td class="leftAligned"><input style="width: 212px;" type="text" id="txtCancelBy" name="txtCancelBy" readonly="readonly" class=""/></td>
		</tr>	
		<tr>
			<td class="rightAligned"></td>
			<td class="leftAligned">
			</td>
			<td class="rightAligned">Date Cancelled</td>
			<td class="leftAligned"><input style="width: 212px;" type="text" id="txtCancelDate" name="txtCancelDate" readonly="readonly" /></td>
		</tr>	
	</table>
</div>
<div class="sectionDiv" id="disbursementRequestsDiv3" changeTagAttr="true"> <!-- marco - 04.22.2013 - added changeTagAttr -->
	<table border="0" align="center" style="margin-left: 61px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" >Payee</td>
			<td class="leftAligned" colspan="3">
				<div style="width: 81px; float: left;" class="withIconDiv required">
					<input style="width: 56px; text-align: right;" id="txtPayeeClassCd" name="txtPayeeClassCd" type="text" value="" class="withIcon required" ignoreDelKey="1"/>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeClassCd" name="lovPayeeClassCd" alt="Go" />
				</div>
				<div style="width: 161px; float: left;" class="withIconDiv required">
					<input style="width: 135px; text-align: right;" id="txtPayeeCd" name="txtPayeeCd" type="text" value="" class="withIcon required" ignoreDelKey="1"/>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeCd" name="lovPayeeCd" alt="Go" />
				</div>
				<input style="width: 403px;" type="text" id="txtPayee" name="txtPayee" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Particulars</td>
			<td class="leftAligned" colspan="3">
				<div style="float: left; width: 663px;" class="withIconDiv required">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtParticulars" name="txtParticulars" style="width: 633px;" class="withIcon required" readonly="readonly"> </textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtParticulars" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Amount</td>
			<td class="leftAligned" style="width: 310px;">
				<input type="hidden" id="txtCurrencyCd" name="txtCurrencyCd" value="" readonly="readonly" />
				<div style="width: 51px; float: left;" class="withIconDiv required">
					<input style="width: 25px;" id="txtDspFshortName" name="txtDspFshortName" type="text" value="" readOnly="readonly" class="withIcon required" />
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDspFshortName" name="lovDspFshortName" alt="Go" />
				</div>
				<!-- <input style="width: 155px;" type="text" id="txtDvFcurrencyAmt" name="txtDvFcurrencyAmt" readonly="readonly" class="money required" maxlength="18" errorMsg="Field must be of form 99,999,999,999,990.99" min="-99999999999999.99" max="99999999999999.99"/>  -->
				<input style="width: 155px;" type="text" id="txtDvFcurrencyAmt" name="txtDvFcurrencyAmt" readonly="readonly" class="money required" maxlength="18" errorMsg="Invalid Amount. Valid value should be from 0.01 to 99999999999999.99" min="0.01" max="99999999999999.99"/>
			</td>
			<td class="rightAligned" style="width: 123px;">Local Amount</td>
			<td class="leftAligned">
				<input style="width: 45px;" type="text" id="txtDspShortName" name="txtDspShortName" readonly="readonly"/>
				<input style="width: 155px;" type="text" id="txtPaytAmt" name="txtPaytAmt" readonly="readonly" class="money"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Conversion Rate</td>
			<td class="leftAligned"><input style="width: 212px; text-align: right;" type="text" id="txtCurrencyRt" name="txtCurrencyRt" readonly="readonly" class="nthDecimal required" maxlength="13" errorMsg="Field must be of form 99,999,999,999,990.99" min="-999,999,999,999.999999999" max="999,999,999,999.999999999" nthDecimal="9"/></td>
			<td class="rightAligned"></td>
			<td class="leftAligned" id="txtNbtUploadTag" style="display: none;"><input style="float: left;" type="checkbox" id="chkUploadtag" name="chkUploadtag" disabled="disabled"/><label style="margin-left: 4px; float: left;" for="chkUploadtag">Upload Tag</label></td>
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned"><input style="width: 212px;" type="text" id="txtUserId" name="txtUserId" readonly="readonly"  /></td>
			<td class="rightAligned">Last Update</td>
			<td class="leftAligned"><input style="width: 212px;" type="text" id="txtLastUpdate" name="txtLastUpdate" readonly="readonly"  /></td>
		</tr>
		<tr id="txtNbtCommTag" style="display: none;">
			<td class="rightAligned" id="txtNbtCommTagLabel">Replenishment Tag</td>
			<td class="leftAligned" colspan="3">
				<input type="checkbox" id="chkCommtag" name="chkCommtag" disabled="disabled" style="display: none;"/>
				<input type="checkbox" id="chkRfReplenishTag" name="chkRfReplenishTag" style="display: none; float: left; "/>
				<div style="width: 200px; float: left; margin-left: 5px;" class="withIconDiv" id="replenishDiv">
					<input style="width: 170px;" id="txtNbtReplenishNo" name="txtNbtReplenishNo" type="text" value="" readOnly="readonly" class="withIcon" />
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="replenishmentLOV" name="replenishmentLOV" alt="Go" class=""/>
				</div>
				<input id="txtReplenishId" type="hidden" value=""/>
			</td>
		</tr>
		<tr id="txtNbtReplenishment" style="display: none;">
			<td class="rightAligned">Replenishment Amount</td>
			<td class="leftAligned" colspan="3">
				<input style="width: 212px;" type="text" id="txtNbtReplenishAmt" name="txtNbtReplenishAmt" readonly="readonly" class="money"/>
				<input type="button" class="button" id="btnRfDetail" name="btnRfDetail" value="RF Detail" />
			</td>
		</tr>
	</table>		
</div>
<div class="buttonDiv" id="disbursementRequestButtonDiv" style="float: left; width: 100%;">
	<table align="center" border="0" style="margin-bottom: 30px; margin-top: 10px;">
		<tr>
			<td><input type="button" class="button" id="btnDvInfo" name="btnDvInfo" value="DV Info" /></td>
			<td><input type="button" class="button" id="btnDrDetails" name="btnDrDetails" value="DR Details" /></td>
			<td><input type="button" class="button" id="btnAcctEntries" name="btnAcctEntries" value="Acct. Entries" /></td>
			<td><input type="button" class="button" id="btnCloseReq" name="btnCloseReq" value="Close Request" /></td>
			<td><input type="button" class="button" id="btnPrintReq" name="btnPrintReq" value="Print Request" /></td>
			<td style="display: none;" id="btnCommFundTD"><input type="button" class="button" id="btnCommFund" name="btnCommFund" value="Comm Fund Slip" /></td>
			<td style="display: none;" id="btnCancelReqTD"><input type="button" class="button" id="btnCancelReq" name="btnCancelReq" value="Cancel Request" /></td>
			<td><input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" /></td>
			<td><input type="button" class="button" id="btnSave" name="btnSave" value="Save" /></td>
		</tr>
	</table>
</div>	

<input id="newRec" type="hidden" value="${newRec }"/>
<input id="allowTranForClosedMonth" type="hidden" value="${allowTranForClosedMonth }"/>
<input id="globalPFundCd" type="hidden" value="${globalPFundCd }" />
<input id="globalPBranchCd" type="hidden" value="${globalPBranchCd }" />
<input id="globalPFundDesc" type="hidden" value="${globalPFundDesc }"/>
<input id="globalPBrancName" type="hidden" value="${globalPBrancName }"/>
<input id="defaultCurrencyRt" type="hidden" value="${defaultCurrencyRt }"/>
<input id="defaultCurrency" type="hidden" value="${defaultCurrency }"/>
<input id="allowPrint" type="hidden" value="${allowPrint }"/>
<!-- GRPQ(GIAC_PAYT_REQUESTS) hidden items -->

<input id="refId" type="hidden" /> 

<!-- GRPQ(GIAC_PAYT_REQUESTS) hidden items -->
<input id="reqDtlNo"  type="hidden"/>
<input id="otherBranch"  type="hidden"/>

<script type="text/javascript" >

try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	var disbursement = (('${disbursement}') == "" ? objACGlobal.disbursement : '${disbursement}');
	var uploadTagSw = ('${uploadTagSw}');
	var allUserSw = ('${allUserSw}');
	var lovDocumentCd = "";
	var userIsValid = '${userIsValid}';
	
	var globalDocCd = ('${globalDocCd}');
	
	var gprq = JSON.parse('${giacPaytRequests}');	
	var grqd = JSON.parse('${giacPaytRequestsDtl}');
	
	objACGlobal.disbursement = disbursement; //marco - 04.20.2013 - to prevent objACGlobal.disbursement from losing its value
	objACGlobal.gaccTranId = grqd.tranId;
	objAC.paytReqFlag = grqd.paytReqFlag; //koks 11.14.13 SR 615 QA
	objACGlobal.tranFlagState = '${tranFlag}';	// shan 04.08.2015
	objACGlobal.sysdate = "${sysdate}";
	disableDate("hreftxtRequestDate");
	disableSearch("replenishmentLOV");
	
	function populateGprq(obj){
		try{
			$("company").value 				= obj == null ? null :/* unescapeHTML2(obj.fundCd)+" - "+ */unescapeHTML2(obj.dspFundDesc); // removed fund cd Kenneth L. 11.08.2013
			$("txtFundCd").value 			= obj == null ? null :unescapeHTML2(obj.fundCd);
			$("txtDspFundDesc").value 		= obj == null ? null :unescapeHTML2(obj.dspFundDesc);
			$("branch").value 				= obj == null ? null :/* unescapeHTML2(obj.branchCd)+" - "+ */unescapeHTML2(obj.dspBranchName); // removed branch cd Kenneth L. 11.08.2013
			$("txtBranchCd").value 			= obj == null ? null :unescapeHTML2(obj.branchCd);
			$("txtDspBranchName").value 	= obj == null ? null :unescapeHTML2(obj.dspBranchName);
			$("txtDocumentCd").value 		= obj == null ? null :unescapeHTML2(obj.documentCd);
			$("txtDspBranchCd").value 		= obj == null ? null :unescapeHTML2(obj.branchCd);
			$("txtLineCd").value 			= obj == null ? null :unescapeHTML2(obj.lineCd);
			$("txtDocYear").value 			= obj == null ? null :(obj.docYear);
			$("txtDocMm").value 			= obj == null ? null :formatNumberDigits(obj.docMm,2);
			$("txtDocSeqNo").value 			= obj == null ? null :formatNumberDigits(obj.docSeqNo,6);
			$("txtGoucOucId").value 		= obj == null ? null :(obj.docSeqNo);
			$("txtDspDeptCd").value 		= obj == null ? null :unescapeHTML2(obj.dspDeptCd);
			$("txtDspOucName").value 		= obj == null ? null :unescapeHTML2(obj.dspOucName);
			$("txtCreateBy").value 			= obj == null ? null :unescapeHTML2(obj.createBy);
			$("txtRequestDate").value 		= obj == null ? null :(obj.strRequestDate);
			$("chkUploadtag").checked		= obj == null ? false :(nvl(obj.uploadTag,"N").toUpperCase() == "Y" ? true :false);
			$("chkRfReplenishTag").checked	= obj == null ? false :(nvl(obj.rfReplenishTag,"N").toUpperCase() == "Y" ? true :false);
			$("refId").value = obj == null ? null :(obj.refId);
			
			if(obj != null ){
				new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=populateChkTags", {
					method: "POST",
					parameters: {
						fundCd:		obj.fundCd,
						branchCd:		obj.branchCd,
						documentCd:		obj.documentCd
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : function(){
						},
					onComplete : function(response) {
						var mes = response.responseText.toQueryParams();
						$("varDocumentName").value =  mes.varDocumentName;
						$("varLineCdTag").value =  mes.varLineCdTag;
						$("varYyTag").value =  mes.varYyTag;
						$("varMmTag").value =  mes.varMmTag;
					}
				});		
			}
		}catch(e){
			showErrorMessage("populateGprq", e);	
		}	
	}	
	
	function populateGrqd(obj){
		try{
			$("txtPaytReqFlag").value 		= obj == null ? null :unescapeHTML2(obj.paytReqFlag);
			$("txtMeanPaytReqFlag").value 	= obj == null ? null :unescapeHTML2(obj.meanPaytReqFlag);
			$("txtCancelBy").value 			= obj == null ? null :unescapeHTML2(obj.cancelBy);
			$("txtCancelDate").value 		= obj == null ? null :(obj.strCancelDate);
			$("txtPayeeClassCd").value 		= obj == null ? null :unescapeHTML2(obj.payeeClassCd);
			$("txtPayeeCd").value 			= obj == null ? null :formatNumberDigits(obj.payeeCd,12);
			$("txtPayee").value 			= obj == null ? null :unescapeHTML2(obj.payee);
			$("txtParticulars").value 		= obj == null ? null :unescapeHTML2(obj.particulars);
			$("txtDspFshortName").value 	= obj == null ? null :unescapeHTML2(obj.dspFshortName);
			$("txtDvFcurrencyAmt").value 	= obj == null ? null :formatCurrency(obj.dvFcurrencyAmt);
			$("txtCurrencyCd").value 		= obj == null ? null :(obj.currencyCd);
			$("txtDspShortName").value 		= obj == null ? null :unescapeHTML2(obj.dspShortName);
			$("txtPaytAmt").value 			= obj == null ? null :formatCurrency(obj.paytAmt);
			$("txtCurrencyRt").value 		= obj == null ? null :formatToNineDecimal(obj.currencyRt);
			$("chkCommtag").checked			= obj == null ? false :(nvl(obj.commTag,"N").toUpperCase() == "Y" ? true :false);
			$("txtNbtReplenishNo").value 	= obj == null ? null :unescapeHTML2(obj.nbtReplenishNo);
			$("txtNbtReplenishAmt").value 	= obj == null ? null :formatCurrency(obj.nbtReplenishAmt);
			$("txtReplenishId").value 	= obj == null ? null : obj.replenishId;
			$("reqDtlNo").value = obj == null ? null :(obj.reqDtlNo);
			$("txtLastUpdate").value = obj == null ? null : obj.strLastUpdate;
			//$("txtLastUpdate").value = obj == null ? null :(dateFormat(obj.lastUpdate,"mm-dd-yyyy hh:mm:ss TT"));
			$("txtUserId").value 	= obj == null ? null :unescapeHTML2(obj.userId);
			whenNewRecordInstance();
		}catch(e){
			showErrorMessage("populateGprd", e);	
		}	
	}	
	
	/*Gzelle - 04.05.2013
	* disable GIACS016 if called from Payment Request Status Inquiry(GIACS236)
	*/
 	function disableGiacs016() {
 		disableSearch("lovCompany");
		//disableSearch("lovBranch");
		disableSearch("lovDspOucName");
		disableSearch("lovPayeeClassCd"); 
		disableSearch("lovPayeeCd");
		disableSearch("lovDspFshortName");
		disableSearch("replenishmentLOV");
		$("company").disabled 				= true;
		$("branch").disabled 				= true;
		$("txtDocumentCd").disabled 		= true;
		$("txtDspBranchCd").readOnly 		= true;
		$("txtLineCd").readOnly 			= true;
		$("txtDocYear").disabled 			= true;
		$("txtDocMm").disabled 				= true;
		$("txtDocSeqNo").readOnly 			= true;
		$("txtPaytReqFlag").readOnly 		= true;
		$("txtMeanPaytReqFlag").readOnly 	= true;
		$("txtDspDeptCd").readOnly 			= true;
		$("txtDspOucName").disabled 		= true;
		$("txtCreateBy").readOnly 			= true;
		$("txtRequestDate").disabled 		= true;
		$("txtCancelBy").readOnly 			= true;
		$("txtCancelDate").readOnly 		= true;
		$("txtPayeeClassCd").disabled 		= true;
		$("txtPayeeCd").disabled 			= true;
		$("txtPayee").readOnly 				= true;
		$("txtParticulars").disabled 		= true;
		$("txtDspFshortName").disabled 		= true;
		$("txtDvFcurrencyAmt").disabled 	= true;
		$("txtDspShortName").readOnly 		= true;
		$("txtPaytAmt").readOnly 			= true;
		$("txtCurrencyRt").readOnly 		= true;
		$("txtUserId").readOnly 			= true;
		$("txtLastUpdate").readOnly 		= true;
		disableDate("hreftxtRequestDate"); // irwin
		disableButton("btnSave");
		disableButton("btnCloseReq");
	}
	/*Gzelle - 04.05.2013*/
	
	function whenNewFormInstance(){
		try{
			if (disbursement != "CP"){
				$("txtNbtCommTag").hide();
				$("chkCommtag").hide();
			}else{
				$("txtNbtCommTag").show();
				$("chkCommtag").show();
				$("txtNbtCommTagLabel").value = "Replenishment Tag";
				$("disbursementRequestsDiv3").down("table",0).style.marginLeft = "48px";
			}	
			
			//if (allUserSw == "N"){
				if (disbursement == "CR"){
					$("btnCancelReqTD").show();
				}else if (disbursement == "CP"){
					$("btnCommFundTD").show();
					if ($F("txtPaytReqFlag") == "X"){
						disableButton("btnCommFund");
					}
				}	
			//} 
			
			if (nvl(uploadTagSw,"N").toUpperCase() == "Y"){
				$("txtNbtUploadTag").show();
				//$("chkUploadtag").disabled = false;
				$("chkUploadtag").disabled = true; // kenneth L.11.08.2013
			}else{
				$("txtNbtUploadTag").hide();
				$("chkUploadtag").disabled = true;
			}	
			if (disbursement == "OP"){
				$("txtNbtCommTag").show();
				$("chkRfReplenishTag").show();
				//$("txtNbtReplenishNo").show(); 
				$("replenishDiv").show();
				$("txtNbtReplenishment").show();
				$("txtNbtCommTagLabel").value = "Replenishment Tag";
				if ($("chkRfReplenishTag").checked == true){
					enableButton("btnRfDetail");
					enableSearch("replenishmentLOV");
				}else{
					disableButton("btnRfDetail");
				}	
				$("disbursementRequestsDiv3").down("table",0).style.marginLeft = "24px";
			}else if(disbursement == "CR"){
				disableSearch("lovPayeeClassCd");
				disableSearch("lovPayeeCd");
				$("txtParticulars").readOnly = true;
				disableSearch("lovDspFshortName");
				$("txtDvFcurrencyAmt").readOnly = true;
				$("txtCurrencyRt").readOnly = true;
				
				$("btnCancel").hide();	// added Kenneth L. 11.12.2013
				$("btnSave").hide();
			}else{
				$("chkRfReplenishTag").hide();
				$("txtNbtReplenishNo").hide();
				$("replenishDiv").hide();
				$("txtNbtReplenishment").hide();
			}	
			if($F("varLineCdTag") == "N"){
				disableSearch("lovLineCd");
			}else{
				enableSearch("lovLineCd"); //replaced Kenneth L. 11.12.2013 : removed comment : shan 09.09.2014
				//disableSearch("lovLineCd");
			}
			if($F("newRec") == "N"){
				disableSearch("lovCompany");
				//disableSearch("lovBranch");
			}
		}catch(e){
			showErrorMessage("whenNewFormInstance", e);	
		}	
	}	
	
	function whenNewRecordInstance(){//GPRQ
		try{
			disableSearch("lovDocumentCd");
			disableSearch("lovDspOucName");
		//	disableSearch("lovLineCd");
			
			if (nvl(gprq.refId,null) == null){ // added more params and functions -irwin
				//key-crerec trigger
				$("txtMeanPaytReqFlag").value = "New";
				$("txtPaytReqFlag").value = "N";
				$("txtCurrencyCd").value = "1";
				$("txtCreateBy").value = ("${PARAMETERS['USER'].userId}");
				$("txtFundCd").value = $F("globalPFundCd");
				$("txtDspFundDesc").value = $F("globalPFundDesc");
				$("company").value = /* $F("globalPFundCd")+" - "+ */$F("globalPFundDesc"); // removed fund cd Kenneth L. 11.08.2013
				$("txtBranchCd").value = $F("globalPBranchCd");
				$("txtDspBranchName").value = $F("globalPBrancName");
				$("branch").value = /* $F("globalPBranchCd")+" - "+ */$F("globalPBrancName");// removed branch cd Kenneth L. 11.08.2013
				$("txtDspBranchCd").value = $F("globalPBranchCd");
				
				if('${setInitialDoc}' == "N"){
					$("lovDocumentCd").click();
				}else{
					var docObj = JSON.parse('${docObj}');	
					$("varDocumentName").value = unescapeHTML2(docObj.documentName);
					$("varLineCdTag").value = unescapeHTML2(docObj.lineCdTag);
					$("varYyTag").value = unescapeHTML2(docObj.yyTag);
					$("varMmTag").value = unescapeHTML2(docObj.mmTag);
					$("txtDocumentCd").value = unescapeHTML2(docObj.documentCd);
					$("txtDocumentCd").focus();
					
					if ($("varLineCdTag").value == "Y"){
						enableSearch("lovLineCd");
						$("lovLineCdDiv").addClassName("required");
						$("txtLineCd").addClassName("required");
					}else{
						disableSearch("lovLineCd");
						$("lovLineCdDiv").removeClassName("required");
						$("txtLineCd").removeClassName("required");
						$("txtLineCd").value = "";
					}	
					changeTag= 1;
				}
				enableSearch("lovDocumentCd");
				enableSearch("lovDspOucName");
				enableInputField("txtRequestDate");
				enableDate("hreftxtRequestDate");
				$("txtFundCd").value = $F("globalPFundCd");
				$("txtBranchCd").value = $F("globalPBranchCd");
				$("txtDspFshortName").value = unescapeHTML2($F("defaultCurrency"));
				$("txtCurrencyRt").value = formatToNineDecimal($F("defaultCurrencyRt"));
				$("txtDspShortName").value = unescapeHTML2($F("defaultCurrency"));
				
				if($F("varLineCdTag") == "N"){
					disableSearch("lovLineCd");
				}else{
					enableSearch("lovLineCd");
				}
				
				$("chkCommtag").disabled = false;
				
			}

			if ($F("txtPaytReqFlag") == "C" || $F("txtPaytReqFlag") == "X"){
				/*insert/update/delete not allowed*/
				disableSearch("lovCompany");
				//disableSearch("lovBranch");
				disableSearch("lovPayeeClassCd"); 
				disableSearch("lovPayeeCd");
				disableSearch("lovDspFshortName");
				disableSearch("replenishmentLOV");
				$("txtParticulars").readOnly = true;
				$("txtDvFcurrencyAmt").readOnly = true;
				$("txtCurrencyRt").readOnly = true;
				$("chkCommtag").disabled = true;
				$("chkRfReplenishTag").disabled = true;
				$("txtDspDeptCd").readOnly = true;
				$("txtPayeeClassCd").readOnly = true;
				$("txtPayeeCd").readOnly = true;
				if (objAC.paytReqStatTag == "Y") {		//added by Gzelle - 04.05.2013 - disable form if called from GIACS236
		 			disableGiacs016();
				}
			}else{
				if (objAC.paytReqStatTag == "Y") {		//added by Gzelle - 04.05.2013 - disable form if called from GIACS236
					disableGiacs016();
				}else {
					enableSearch("lovCompany");
					//enableSearch("lovBranch");
					enableSearch("lovPayeeClassCd");
					enableSearch("lovPayeeCd");
					enableSearch("lovDspFshortName");
					$("txtParticulars").readOnly = false;
					$("txtDvFcurrencyAmt").readOnly = false;
					$("txtCurrencyRt").readOnly = false;
					$("chkCommtag").disabled = false;	
					if (nvl(gprq.refId,null) != null) $("txtDspDeptCd").readOnly = true;				
				}
			}	
		}catch(e){
			showErrorMessage("whenNewRecordInstance", e);	
		}
	}	
	
	function setGiacPaytRequestsObj(){
		try{
			var obj = {};
		 	obj.documentCd = $F("txtDocumentCd");
			obj.branchCd = $F("txtBranchCd");
			obj.docYear = $F("txtDocYear");
			obj.docMm = $F("txtDocMm");
			obj.dspBranchName = $F("txtDspBranchName");
			obj.lineCd = $F("txtLineCd");
			obj.goucOucId = $F("txtGoucOucId");
			obj.fundCd = $F("txtFundCd");
			obj.refId = $F("refId"); 
			obj.uploadTag = $("chkUploadtag").checked ? "Y" : "N";
			obj.rfReplenishTag = $("chkRfReplenishTag").checked ? "Y" : "N";
			obj.docSeqNo = removeLeadingZero($F("txtDocSeqNo"));
			obj.tranId = objACGlobal.gaccTranId;
			obj.requestDate =  $F("txtRequestDate");	// RSIC SR-11259, copied from SR-16985 : shan 08.28.2015
			
			return obj;
		}catch(e){
			showErrorMessage("setGiacPaytRequestsObj",e);
		}
	}
	function setGiacPaytRequestsDtl(){ // irwin
		try{
			var obj = {};
			obj.reqDtlNo = $F("reqDtlNo");
			obj.payeeClassCd = $F("txtPayeeClassCd");
			obj.paytReqFlag = $F("txtPaytReqFlag");
			obj.payeeCd = $F("txtPayeeCd");
			obj.payee = $F("txtPayee");
			obj.particulars = $F("txtParticulars");
			obj.currencyCd = $F("txtCurrencyCd");
			obj.currencyRt = unformatNumber($F("txtCurrencyRt"));
			obj.dvFcurrencyAmt  = unformatNumber($F("txtDvFcurrencyAmt"));
			obj.paytAmt = unformatNumber($F("txtPaytAmt"));
			obj.commTag = $("chkCommtag").checked ? "Y" : "N";
			obj.replenishId = $F("txtReplenishId");
			obj.tranId = objACGlobal.gaccTranId;
			return obj;
		}catch(e){
			showErrorMessage("setGiacPaytRequestsDtl",e);
		}
	}
	
	function saveDisbursmentRequest(){
		try{
			var giacPaytRequests = setGiacPaytRequestsObj();
			var giactPayRequestsDtl = setGiacPaytRequestsDtl();
			var objParameter = {};
			objParameter.giacPaytRequests = giacPaytRequests;
			objParameter.giactPayRequestsDtl = giactPayRequestsDtl;
			
			new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=saveDisbursmentRequest", {
				method: "POST",
				parameters: {
					newRec:		$F("newRec"),
					parameters: JSON.stringify(objParameter)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
						showNotice("Saving Disbursement Request, please wait...");
					},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)){
						hideNotice("");
						changeTagFunc = "";
						if(!isNaN(response.responseText)){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								if(exitPage != null) {
									exitPage();
								} else {
									objACGlobal.gaccTranId = grqd.tranId;
									showDisbursementMainPage(disbursement, response.responseText,$F("otherBranch"));
								}
							});
						}
						changeTag = 0; 
						//replaced by kenneth 01.06.2014 to display success message first before going to the previous module
						
						/* if(!isNaN(response.responseText)){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								objACGlobal.gaccTranId = grqd.tranId;
								showDisbursementMainPage(disbursement, response.responseText,$F("otherBranch"));
							});
						} */
						/* showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, 
							function(){
								changeTag = 0;
							}		
						); */
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveDisbursmentRequest");
		}
	}
	
	function getClosedTag(fundCd, requestDate,branchCd){
		try{
			var bool = false;
			new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=getClosedTag", {
				method: "POST",
				parameters: {
					fundCd:		fundCd,
					requestDate: requestDate,
					branchCd : branchCd
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
						showNotice("please wait...");
					},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)){
						hideNotice("");
						
						var result = response.responseText;
						
						if((result == 'T' || result == "Y") && nvl($F("allowTranForClosedMonth","Y")) == "N"){
							bool = false;
						}else{
							bool =  true;							
						}
						
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
			return bool;	
		}catch(e){
			showErrorMessage("getClosedTag");
		}
	}
	
	function showDvInfo(refId, gprq){
		try{
			genericObjOverlay = Overlay.show(contextPath+"/GIACPaytRequestsController", { 
				urlContent: true,
				urlParameters: {action : "showDvInfo",
								refId : refId,
								ajax : "1"},
				title: "Disbursement Voucher Information",							
			    height: 450,
			    width: 820,
			    draggable: true,
			    onCompleteFunction : function(){
			    	$("company").value = unescapeHTML2(/* gprq.fundCd +" - "+ */gprq.dspFundDesc); // removed fund cd Kenneth L. 11.08.2013
			    	$("branch").value = unescapeHTML2(gprq.dspBranchName);
			    	$("txtDocumentCd").value = unescapeHTML2(gprq.documentCd);
			    	$("txtDspBranchCd").value = unescapeHTML2(gprq.branchCd);
			    	$("txtLineCd").value = unescapeHTML2(gprq.lineCd);
			    	$("txtDocYear").value = gprq.docYear;
			    	$("txtDocSeqNo").value = formatNumberDigits(gprq.docSeqNo,6);
			    	$("txtDocMm").value = gprq.docMm;
			    	$("txtRequestDate").value = gprq.strRequestDate;
			    	$("txtDspDeptCd").value = unescapeHTML2(gprq.dspDeptCd);
			    	$("txtDspOucName").value = unescapeHTML2(gprq.dspOucName);
			    	$("txtPaytReqFlag").value 		= unescapeHTML2(grqd.paytReqFlag);
					$("txtMeanPaytReqFlag").value 	= unescapeHTML2(grqd.meanPaytReqFlag);
			    }
			});
			
		}catch(e){
			showErrorMessage("getDvInfo",e);
		}
	}
	
	function showRfDetailTG(replenishId){
		try{
			objACGlobal.branchCd 		= gprq.branchCd;
			genericObjOverlay = Overlay.show(contextPath+"/GIACReplenishDvController", { 
				urlContent: true,
				urlParameters: {action : "showRfDetailTG",
								replenishId : replenishId,
								ajax : "1"},
				title: "Replenishment Details",							
			    height: 620,
			    width: 760,
			    draggable: true,
			    onCompleteFunction : function(){
			    	$("replenishId").value = replenishId;
			    }
			});
			
		}catch(e){
			showErrorMessage("showRfDetailTG",e);
		}
	}
	
	
	$("chkRfReplenishTag").observe("change", function(){
		if ($("chkRfReplenishTag").checked == true){
			enableButton("btnRfDetail");
			enableSearch("replenishmentLOV");
		}else{
			disableButton("btnRfDetail");
			disableSearch("replenishmentLOV");
			$("txtNbtReplenishNo").value = "";
			$("txtNbtReplenishAmt").value = "";
		}
	});
	
	$("editTxtParticulars").observe("click", function(){
		if($("txtParticulars").hasAttribute("readonly")){	// condition added shan 08.27.2013
			showOverlayEditor("txtParticulars", 500, $("txtParticulars").hasAttribute("readonly"), function(){
				changeTag = 1; // Added by Gab Ramos 07.08.2015 SR 19675
			}); 
		}else{
			if ($F("txtPaytReqFlag") == "C" || $F("txtPaytReqFlag") == "X" || disbursement == "CR"){
				showOverlayEditor("txtParticulars", 2000, "true", function(){
					changeTag = 1;	// Added by Gab Ramos 07.08.2015 SR 19675
				});
			}else{
				showOverlayEditor("txtParticulars", 2000, "false", function(){
					changeTag = 1;	// Added by Gab Ramos 07.08.2015 SR 19675
				}); 
			}	
		}
	});
	
	$("lovCompany").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			showCompanyLOV("GIACS016");
		}
	});
	
	/* $("lovBranch").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			if ($F("txtFundCd") == ""){
				customShowMessageBox("Please select company first.","I","company");
				return false;
			}
			showBranchLOV("GIACS016", $F("txtFundCd"));
		}	
	}); */
	
	$("lovPayeeClassCd").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			showPayeeLOV("GIACS016");
		}	
	});
	
	$("lovPayeeCd").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			showPayeeLOV2("GIACS016", $F("txtPayeeClassCd"));
		}	
	});
	
	$("lovDspFshortName").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			showCurrencyLOV("GIACS016");
		}	
	});
	
	$("lovDocumentCd").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			if ($F("txtFundCd") == ""){
				customShowMessageBox("Please select company first.","I","company");
				return false;
			}else if ($F("txtBranchCd") == ""){
				customShowMessageBox("Please select branch first.","I","branch");
				return false;
			}else{
				var paramMenu = "";
				if (disbursement == "FPP" || disbursement == "CP"){
					if (disbursement == "FPP") paramMenu = "FACUL_RI_PREM_PAYT_DOC";
					if (disbursement == "CP") paramMenu = "COMM_PAYT_DOC";
			      	lovDocumentCd = "getRgDocumentCdNonClaimLOV";
			   	}else if (disbursement == "CPR"){
					lovDocumentCd = "getRgDocumentCdClaimLOV";
			   	}else if (disbursement == "OP"){
					lovDocumentCd = "getRgDocumentCdOtherLOV";
			   	}else{
			   		lovDocumentCd = "getRgDocumentCdAllLOV";
			   	}	
				showDocumentCdLOV("GIACS016", lovDocumentCd, $F("txtFundCd"), $F("txtBranchCd"), paramMenu);
			}
		}	
	});
	
	$("lovLineCd").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			showGiisLineLOV("GIACS016");
		}	
	});
	
	$("lovDspOucName").observe("click", function(){
		if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			if ($F("txtFundCd") == ""){
				customShowMessageBox("Please select company first.","I","company");
				return false;
			}
			if ($F("txtBranchCd") == ""){
				customShowMessageBox("Please select branch first.","I","branch");
				return false;
			}
			showOucsLOV("GIACS016", $F("txtFundCd"), $F("txtBranchCd"), nvl(gprq.refId,null));
		}	
	});
	
	$("txtDocYear").observe("change", function(){
		if(isNaN(this.value)){
			this.value = "";
			customShowMessageBox("Invalid year.","I","txtDocYear");
		}else{
			var currentYear = parseInt(new Date().getFullYear());
			if($F("txtRequestDate") == ''){
				if(parseInt(this.value) > currentYear){
					showMessageBox("This is a future year.");
				}else if(parseInt(this.value) < currentYear){
					showMessageBox("Please note that this is a PREVIOUS date.");
				}
			}else{
				var requestDate = Date.parse($F("txtRequestDate"));
				if(parseInt(this.value) != requestDate.getFullYear()){
					if(parseInt(this.value) > currentYear){
						showMessageBox("This is a future year.");
					}else if (parseInt(this.value) < currentYear){
						showMessageBox("Please note that this is a PREVIOUS date.");
					}
					$("txtRequestDate").value = "";
				}
			}
			
			if($F("varMmTag") == "Y"){
				$("txtDocMm").focus();
			}
		}
	});
	
	function getLocalAmt(){
		try{
			if ($F("txtCurrencyRt") == "" || $F("txtDvFcurrencyAmt") == "") return;
			$("txtPaytAmt").value = formatCurrency(roundNumber((unformatCurrency("txtCurrencyRt") * unformatCurrency("txtDvFcurrencyAmt")),2));
		}catch(e){
			showErrorMessage("getLocalAmt", e);	
		}	
	}	
	
	$("txtCurrencyRt").observe("blur", function(){
		getLocalAmt();
	});
	
	$("txtDvFcurrencyAmt").observe("blur", function(){
		getLocalAmt();
	});
	
	$("txtDspFshortName").observe("blur", function(){
		getLocalAmt();
	});
	
	$("txtRequestDate").observe("change", function(){
		
		var dateToday = makeDate(objACGlobal.sysdate);
		var docYear  = parseInt($F("txtDocYear"));
		var requestDate = Date.parse(this.value);
		
		if(checkDate3(this.value, "txtRequestDate")){
			if(this.value != "" ){
				//requestDate= dateFormat(requestDate, 'mm-dd-yyyy');
				if(getClosedTag($F("txtFundCd"), this.value,$F("txtBranchCd"))){
					if(requestDate == dateToday){
						if($F("varYyTag") == "Y"){
							$("txtDocYear").value = requestDate.getFullYear();
						}
						
						if($F("varMmTag") == "Y"){
							$("txtDocMm").value = requestDate.getMonth()+1;
						}
					}else{
						if(requestDate > dateToday){
							showMessageBox("Please note that this is a future date.");
						}else if(requestDate < dateToday){
							showMessageBox("Please note that this is a previous date.");
						}
						$("txtDocYear").value = requestDate.getFullYear();
						$("txtDocMm").value = lpad((requestDate.getMonth()+1),"2","0");
					}
				}else{
					showMessageBox("You are no longer allowed to create a transaction for "+getMonthWordEquivalent(requestDate.getMonth()) +" "+requestDate.getFullYear()+". This transaction month is already closed.");
					this.value = "";
				}
			}
		}
	});
	
	
	$("txtDocMm").observe("change", function(){
		if(isNaN(this.value)){
			this.value = "";
			customShowMessageBox("Invalid month.","I","txtDocYear");
		}else{
			var docYear = parseInt($F("txtDocYear"));
			var currentYear = parseInt(new Date().getFullYear());
			var currentMonth = parseInt(new Date().getMonth());
			if($F("txtRequestDate") == ''){
				if(docYear == currentYear){
					if(parseInt(this.value) < currentMonth){
						showMessageBox("This is a previous month.");
					}else if(parseInt(this.value) < currentMonth){
						showMessageBox("This is a future month.");
					}
				}else{
					showMessageBox("This is a future year and month.");
				}
			}else{
				var requestDate = Date.parse($F("txtRequestDate"));
				if(parseInt(this.value) != requestDate.getMonth()){
					if(docYear  == currentYear){
						if(parseInt(this.value) < currentMonth){
							showMessageBox("This is a previous month.");
						}else if(parseInt(this.value) > currentMonth){
							showMessageBox("This is a future month.");	
						}
						$("txtRequestDate").value = "";
						
					}else if(docYear > currentYear){
						showMessageBox("This is a future year and month.");
						$("txtRequestDate").value = "";
					}
				}
			}
			
			if($F("varMmTag") == "Y"){
				$("txtDocMm").focus();
			}
		}
	});
	$("txtDocMm").observe("focus", function(){
		if($F("newRec") == "Y"){
			if($F("varMmTag") == "Y"){
				if($F("txtDocYear")!= ''){
					if(this.value == ""){
						this.value = new Date().getMonth()+1;
					}		
				}else{
					customShowMessageBox("Please enter year first.","I", "txtDocYear");
				}
				
			}
			
		}
	});
	
	
	
	$("txtDocYear").observe("focus", function(){
		if($F("newRec") == "Y"){
			if($F("varYyTag") == "Y"){
				if(this.value == ""){
					this.value = new Date().getFullYear();
				}
			}	
		}
	});
	
	$("btnDvInfo").observe("click" , function (){
		if(nvl(gprq.withDv, "N") == "Y"){
			showDvInfo(gprq.refId,gprq);
		}else{
			showMessageBox("There is no DV for this request.");
		}
	});
	populateGprq(nvl(gprq.refId,null) == null ? null :gprq);
	populateGrqd(nvl(gprq.refId,null) == null ? null :grqd);
	whenNewFormInstance();
	function closeRequest(){
		try{
			var giacPaytRequests = setGiacPaytRequestsObj();
			var giactPayRequestsDtl = setGiacPaytRequestsDtl();
			giacPaytRequests.docSeqNo = removeLeadingZero($F("txtDocSeqNo"));
			giacPaytRequests.lineCd = $F("txtLineCd");
			giactPayRequestsDtl.tranId = grqd.tranId;
			
			var objParameter = {};
			objParameter.giacPaytRequests = giacPaytRequests;
			objParameter.giactPayRequestsDtl = giactPayRequestsDtl;
			
			new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=closeRequest", {
				method: "POST",
				parameters: {
					parameters: JSON.stringify(objParameter)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
						showNotice("Closing Disbursement Request, please wait...");
					},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)){
						hideNotice("");
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								showDisbursementMainPage(disbursement, gprq.refId,$F("otherBranch"));
							});
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("closeRequest",e);
		}
	}
	
	function valAmtBeforeClosing(){
		try{
			new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=valAmtBeforeClosing", {
				method: "POST",
				parameters: {
					tranId:		grqd.tranId,
					paytAmt: nvl(grqd.paytAmt,null)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
						//showNotice("Saving Pack PAR, please wait...");
					},
				onComplete : function(response) {
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var reqNo = gprq.documentCd +"-"+ gprq.branchCd +"-"+ ($F("varLineCdTag") == "Y" ? gprq.lineCd+"-" : "") + ($F("varYyTag") == "Y" ? gprq.docYear+"-" : "" )+($F("varMmTag") == "Y" ? gprq.docMm+"-" : "" )+ gprq.docSeqNo;					
						
						showConfirmBox("CLOSE REQUEST FOR PAYMENTS","Do you want to close Request No. "+reqNo+"?","Yes","No",closeRequest);
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});		
		}catch(e ){
			showErrorMessage("valAmtBeforeClosing",e);
		}
	}
	
	function cancelRequest(withDv){
		try{
			var reqNo = gprq.documentCd +"-"+ gprq.branchCd +"-"+ ($F("varLineCdTag") == "Y" ? gprq.lineCd+"-" : "") + ($F("varYyTag") == "Y" ? gprq.docYear+"-" : "" )+($F("varMmTag") == "Y" ? gprq.docMm+"-" : "" )+ gprq.docSeqNo;
			var message = "Do you want to cancel this Request for Payment ("+reqNo+")?";
			if(grqd.paytReqFlag == "N"){
				showConfirmBox("CANCEL REQUEST FOR PAYMENT",message,"Yes","No",contCancelRequest);
			}else if(grqd.paytReqFlag == "C"){
				if(withDv == "N"){
					showConfirmBox("CANCEL REQUEST FOR PAYMENT",message,"Yes","No",contCancelRequest);
				}else{
					showMessageBox("Cancellation not allowed. A DV was already created for this Request. Cancel the DV to automatically cancel this Request.","I");
					return false;
				}
			}else if(grqd.paytReqFlag == "P"){
				showMessageBox("Cancellation not allowed. This Request is already tagged as paid.","I");
				return false;
			}else if(grqd.paytReqFlag == "X"){
				showMessageBox("Cancellation not allowed. This Request has already been cancelled.","I");
				return false;
			}
			
		}catch(e){
			showErrorMessage("cancelRequest",e);
		}
	}
	
	function contCancelRequest(){
		try{
			new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=cancelPaymentRequest", {
				method: "POST",
				parameters: {
					tranId: grqd.tranId,
					moduleId: 'GIACS016',
					refId : gprq.refId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : function(){
					showNotice("Processing, please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							//showMessageBox("Cancelled Request for Payment successfully.","I");
							//showDisbursementMainPage(disbursement, giacPaytRequests.refId,$F("otherBranch"));
							showWaitingMessageBox("Payment Request has been cancelled.", "I", function(){
								showDisbursementMainPage(disbursement, gprq.refId, $F("otherBranch"));
							}); //marco - 04.22.2013
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});	
		}catch(e){
			showErrorMessage("contCancelRequest",e);
		}
	}
	
	$("btnCancelReq").observe("click", function (){
		new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=checkUserAccessForBranch", {
			method: "POST",
			parameters: {
				issCd:		gprq.branchCd,
				lineCd: null,
				moduleId: 'GIACS016',
				refId : gprq.refId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)){
					var res = response.responseText.split(",");
					if(res[0] == "0"){
						showMessageBox("User is not allowed to cancel request for this branch.","I");
						return false;
					}else{
						cancelRequest(res[1]);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});	
	});
	
	$("btnCloseReq").observe("click", function(){
		if (nvl(userIsValid,"N") == "N" ){
			showMessageBox("You are not authorized to close this request.", "I");
			return false;
		}else{
			if (changeTag == 1){
				showConfirmBox4("Close Request", "Do you wish to commit the changes you have made?", "Yes", "No", "Cancel", saveGIACS016, function(){showMessageBox(objCommonMessage.SAVE_CHANGES, "I");}, null);
				return false;
			}else{
				if(grqd.paytReqFlag == "C"){
					showMessageBox("This disbursement request has already been closed.", "I");
					return false;
				}else if(grqd.paytReqFlag == "P" || grqd.paytReqFlag == "X"){
					showMessageBox("Update not allowed.", "I");
					return false;
				}else if(grqd.paytReqFlag == "N"){
					valAmtBeforeClosing();
				}
			}
		}
		
	});
	
	
	$("btnAcctEntries").observe("click",function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
		} else if(objACGlobal.gaccTranId == null){
			showMessageBox("Please save the record first.", "I");			
		}else{
			objACGlobal.tranSource		= 'DISB_REQ';
			objACGlobal.gaccTranId 	 	= grqd.tranId;
			objACGlobal.branchCd 		= gprq.branchCd;
			objACGlobal.fundCd          = gprq.fundCd;
			objACGlobal.allowCloseTrans          = "N";
			objACGlobal.callingForm =  'ACCT_ENTRIES';
			objACGlobal.calledForm =  'GIACS016';
			objACGlobal.calledForm2 =  'GIACS016'; // just in case if the objACGlobal.calledForm is used
			objACGlobal.previousModule =  'GIACS016';
			objACGlobal.disbursement = disbursement;
			objACGlobal.refId = gprq.refId;
			objACGlobal.otherBranch = $F("otherBranch");			
			objACGlobal.giopGaccTranId 	 	= grqd.tranId;
			objACGlobal.tranNo = gprq.tranNo;
			objACGlobal.requestDate = gprq.strRequestDate;
			objACGlobal.payee = grqd.payee;
			objACGlobal.dvFcurrencyAmt = grqd.dvFcurrencyAmt;
			objACGlobal.dspFshortName = grqd.dspFshortName;
			objACGlobal.dspShortName = grqd.dspShortName;
			objACGlobal.paytAmt = grqd.paytAmt;
			
			if(grqd.paytReqFlag != "N" || objAC.paytReqStatTag == "Y"){	//Gzelle 04.09.2013
				objACGlobal.queryOnly =  'Y';
			}
			
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

			objACGlobal.populateAcctEntriesForDisb = populateAcctEntriesForDisb;
		}
	});


	/**
	* Populate header fields
	* @author andrew robes
	* @date 5.2.2013
	* 
	*/
	function populateAcctEntriesForDisb(){
		try {
			new Ajax.Request(contextPath + "/GIACPaytRequestsController", {
					parameters : {action : "getGIACS016PayReqOtherDetails",
								  tranId : gprq.tranId,
								  documentCd : gprq.documentCd,
								  branchCd : gprq.branchCd,
								  lineCd : gprq.lineCd,
								  docYear : gprq.docYear,
								  docMm : gprq.docMm,
								  docSeqNo : gprq.docSeqNo,
								  paytReqFlag : grqd.paytReqFlag
								  },
				    asynchronous: false,
					evalScripts: true,
					onComplete : function(response){
						try {				
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								var result = JSON.parse(response.responseText);
								objACGlobal.tranNo = result.dspTranNo;
								objACGlobal.reqNo = result.dspReqNo;
								objACGlobal.reqStatus = result.dspPaytReqMean; 
		
								$("fundCd").value 			= objACGlobal.fundCd;
								$("branch").value 			= objACGlobal.branchCd;
								$("transactionNo").value 	= objACGlobal.tranNo;
								$("orNo").value 			= objACGlobal.reqNo;
								$("orStatus").value 		= objACGlobal.reqStatus;
								$("orDate").value 			= objACGlobal.requestDate;
								$("grossAmtCurrency").value = objACGlobal.dspFshortName; 
								$("grossAmt").value 		= formatCurrency(objACGlobal.dvFcurrencyAmt); 
								$("payor").value 			= unescapeHTML2(objACGlobal.payee);
								$("fCurrency").value 		= objACGlobal.dspShortName; 
								$("fCurrencyAmt").value 	= formatCurrency(objACGlobal.paytAmt);
								$("lblOrNo").innerHTML = "Payt Req No.";
								$("lblOrNo").title = "Payt Req No.";
								$("lblOrStatus").innerHTML = "Req. Status";
								$("lblOrStatus").title = "Req. Status";
								$("lblOrDate").innerHTML = "Request Date";
								$("lblOrDate").title = "Request Date";
							}
						} catch(e){
							showErrorMessage("populateAcctEntriesForDisb", e);
						}
					}
				});	
		}catch(e){
			showErrorMessage("populateAcctEntriesForDisb", e);
		}
	}
	
	$("btnDrDetails").observe("click",function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
		} else if(objACGlobal.gaccTranId == null){
			showMessageBox("Please save the record first.", "I");
		}else{
			objACGlobal.tranSource		= 'DV';
			objACGlobal.calledForm =  'GIACS016';
			objACGlobal.calledForm2 =  'GIACS016'; // just in case if the objACGlobal.calledForm is used
			objACGlobal.callingForm =  'DISB_REQ';
			objACGlobal.previousModule =  'GIACS016';
			objACGlobal.gaccTranId 	 	= grqd.tranId;
			objACGlobal.giopGaccTranId 	 	= grqd.tranId;
			objACGlobal.fundCd          = gprq.fundCd;
			objACGlobal.branchCd 		= gprq.branchCd;
			objACGlobal.refId = gprq.refId;
			objACGlobal.otherBranch = $F("otherBranch");
			objACGlobal.disbursement = disbursement;
			objACGlobal.tranNo = gprq.tranNo;
			objACGlobal.requestDate = gprq.strRequestDate;
			objACGlobal.payee = grqd.payee;
			objACGlobal.dvFcurrencyAmt = grqd.dvFcurrencyAmt;
			objACGlobal.dspFshortName = grqd.dspFshortName;
			objACGlobal.dspShortName = grqd.dspShortName;
			objACGlobal.paytAmt = grqd.paytAmt;
			objGIACS002.lineCd = gprq.lineCd;	// shan 09.08.2014
			
			if(grqd.paytReqFlag != "N" || objAC.paytReqStatTag == "Y"){	//Gzelle 04.09.2013
				objACGlobal.queryOnly =  'Y';
			}
			
			if(disbursement == "CPR"){
				//showORInfoWithDirectClaimsPayt();	 replaced by Kenneth 11.13.2013
				function showDirectClmPayments(){
					new Ajax.Updater("transBasicInfoSubpage", contextPath+"/GIACDirectClaimPaymentController?action=showDirectClaimPayts", {
						method : "GET",
						parameters: {
							ajaxModal : 1,
							gaccTranId : objACGlobal.gaccTranId
						},
						postBody : Form.serialize("itemInformationForm"),
						asynchronous : true,
						evalScripts : true,
						onCreate: function() {
							showNotice("Loading Direct Claim Payments Information. Please wait...");
						},
						onComplete: function() {
							hideNotice("");
							$$("div[name='subMenuDiv']").each(function(row){
								row.hide();
							});
							objACGlobal.tranClass = '0';
							setCurrentTab1("directTransac");
							$("directTransMenu").show();
							setCurrentTab2("directTransTab4"); 
						}
					});	
				}
				objACGlobal.onClickDVDetails = showORInfoWithCustomTab(showDirectClmPayments);
			}else if(disbursement == "FPP"){
				function showRi(){
					/* $$("div.tabComponents1 a").each(function(a){
						if(a.id == "riTrans") {
							$("riTrans").up("li").addClassName("selectedTab1");					
						}else{
							a.up("li").removeClassName("selectedTab1");	
						}	
					}); */
					setCurrentTab1("riTrans");
					
					$$("div[name='subMenuDiv']").each(function(row){
						row.hide();
					});
					objACGlobal.tranClass = '0';
					
					$("riTransTab1").innerHTML = 'Inw Facul Prem Collns';
					$("riTransTab2").innerHTML = 'Losses Recov from RI';
					$("riTransTab3").innerHTML = 'Facul Claim Payts';
					$("riTransTab4").innerHTML = 'Out Facul Prem Payts';
					$("riTransMenu").show();
					
					setCurrentTab2("riTransTab4"); 
					
					showRITransOutFaculPremPayts();
				}
				//showORInfoWithCustomTab(showRi, "riTransTab1"); replaced by kenneth 11.13.2013
				objACGlobal.onClickDVDetails = showORInfoWithCustomTab(showRi);
			}else if(disbursement == "CP"){
				function showDirect(){
					new Ajax.Updater("transBasicInfoSubpage", contextPath+"/GIACCommPaytsController?action=showCommPayts", {
						method : "GET",
						parameters: {
							gaccTranId : objACGlobal.gaccTranId
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function() {
							showNotice("Loading Comm Payts page. Please wait...");
						},
						onComplete: function() {
							hideNotice("");
							$$("div[name='subMenuDiv']").each(function(row){
								row.hide();
							});
							objACGlobal.tranClass = '0';
							setCurrentTab1("directTransac");
							$("directTransMenu").show();
							setCurrentTab2("directTransTab5"); 
						}
					});	
				}
				objACGlobal.onClickDVDetails = showORInfoWithCustomTab(showDirect);
			}else if(disbursement ==  "OP"){
				//showORInfoWithCustomTab(showTaxPayments);replaced by kenneth 11.13.2013
				objACGlobal.onClickDVDetails = showORInfoWithCustomTab(showTaxPayments);
			}else if(disbursement ==  "CR"){
				//showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I"); //Kenneth L. - 11.13.2013
				objACGlobal.queryOnly =  'Y';
				objACGlobal.onClickDVDetails = showORInfoWithCustomTab(showTaxPayments);
			}
			objACGlobal.populateAcctEntriesForDisb = populateAcctEntriesForDisb;
			
		}
	});
	
	//marco - 06.06.2013
	function showTaxPayments(){
		new Ajax.Updater("transBasicInfoSubpage", contextPath+"/GIACTaxPaymentsController", {
			method : "GET",
			parameters: {
				action : "showTaxPayments",
				gaccTranId : objACGlobal.gaccTranId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Loading Tax Payments...");
			},
			onComplete: function() {
				hideNotice("");
				setCurrentTab1("otherTrans");
				$("directTransMenu").hide();
				$("otherTransMenu").show();
				$("otherTransTab7").innerHTML = 'PDC Collections';
				setCurrentTab2("otherTransTab4");
			}
		});	
	}
	
	function showORInfoWithCustomTab(func){
		new Ajax.Updater("mainContents", contextPath+"/GIACOrderOfPaymentController?action=showORDetails" ,{
			method: "GET",
			parameters : {
				gaccTranId : objACGlobal.gaccTranId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Loading Transaction Basic Information. Please wait...");
			},
			onComplete: function() {
				hideNotice("");
				func();
			}
		});
	}
	
	function setCurrentTab1(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	
	function setCurrentTab2(id){
		$$("div.tabComponents2 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab2");					
			}else{
				a.up("li").removeClassName("selectedTab2");	
			}	
		});
	}
	
	function showORInfoWithDirectClaimsPayt() {
		new Ajax.Updater("mainContents", contextPath+"/GIACOrderOfPaymentController?action=showORDetails" ,{
			method: "GET",
			parameters : {
				gaccTranId : objACGlobal.gaccTranId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function() {
				showNotice("Loading Transaction Basic Information. Please wait...");
			},
			onComplete: function() {
				hideNotice("");
				$$("div.tabComponents2 a").each(function(a){
					if(a.id == "directTransTab4") {
						$("directTransTab4").up("li").addClassName("selectedTab2");					
					}else{
						a.up("li").removeClassName("selectedTab2");	
					}	
				}); 
				showDirectClaimPayments(); 
			}
		});
	}
	
	function saveGIACS016(){
		try{
			var isComplete = checkAllRequiredFieldsInDiv("disbursementRequestsDiv2");
			var isComplete2 = checkAllRequiredFieldsInDiv("disbursementRequestsDiv3");
			if (isComplete && isComplete2){
				if(checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS016")){ //marco - SR-5717 - 03.10.2017
					saveDisbursmentRequest();
				}
			}	
			
		}catch(e){
			showErrorMessage("saveGIACS016", e);	
		}	
	}	
	function showReplenishNoLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {action : 	  "getReplenishNoLOV",
								page : 		  1
				},
				title: "",
				width: 350,
				height: 386,
				columnModel:[	
								{
									id : 'replenishNo',
									title: 'Replenishment No.',
								    width: '160px',
								    align: 'left',
								    titleAlign: 'left'
								},
								{
									id : 'replenishmentAmt',
									title: 'Replenishment Amount',
								    width: '170px',
								    align: 'right',
								    titleAlign: 'right',
								    geniisysClass: 'money'
								},
								{
									id : 'replenishId',
									width : '0px',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					$("txtNbtReplenishAmt").value = formatCurrency(row.replenishmentAmt);
					$("txtNbtReplenishNo").value = row.replenishNo;
					$("txtReplenishId").value = row.replenishId;
					changeTag = 1;
				},
		  		onCancel: function(){
		  			if (moduleId == "GIACS016"){
		  				$("txtDspFshortName").focus();
		  			}
		  		}
			});
		}catch(e){
			showErrorMessage("showPayeeLOV2",e);
		}
	}
	
	$("replenishmentLOV").observe("click", function(){
		//if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
			showReplenishNoLOV();
		//}
	});
	
	deleteOnBackSpace(null,"txtNbtReplenishNo","replenishmentLOV", function(){
		$("txtReplenishId").value = "";
		$("txtNbtReplenishAmt").value = "";
	});
	
	$("btnRfDetail").observe("click",function(){
		if(changeTag == 1 ){
			showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
			return false;
		}else if($F("txtNbtReplenishNo") == ""){
			showMessageBox("Enter the applicable batch for replenishment first.","I");
			return false;
		}else{
			objACGlobal.disbursement = disbursement;
			objACGlobal.refId = gprq.refId;
			objACGlobal.otherBranch = $F("otherBranch");
			showRfDetailTG($F("txtReplenishId"));
		}
	});
	
	function printCheckRequisition(){
		try{
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIADD01A" // check requisition printing
			+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
			+"&fundCd="+nvl(gprq.fundCd, "")
			+"&branchCd="+nvl(gprq.branchCd, "")
			+"&moduleId=GIACS016"	
			+"&tranId="+nvl(grqd.tranId, "")
			+"&tranSource=DV"
			+"&reportId=GIADD01A"
			+"&documentCd="+nvl(gprq.documentCd, "");	
			
			printGenericReport(content, "CHECK REQUISITION");
		}catch(e){
			showErrorMessage("printCheckRequisition",e);
		}
	}
	
	/* added by shan 08.27.2013 */
	function disableGIACS016(){
		$("company").removeClassName("required");
		$("branch").removeClassName("required");
		$("txtDocumentCd").removeClassName("required");
		$("txtDocYear").removeClassName("required");
		$("txtDocMm").removeClassName("required");
		$("txtDspDeptCd").removeClassName("required");
		$("txtDspOucName").removeClassName("required");
		disableSearch("lovLineCd");
		$("txtRequestDate").removeClassName("required");
		$("txtPayeeClassCd").removeClassName("required");
		disableSearch("lovPayeeClassCd");
		$("txtPayeeCd").removeClassName("required");
		disableSearch("lovPayeeCd");
		$("txtParticulars").removeClassName("required");
		$("txtParticulars").readOnly = true;
		$("txtDspFshortName").removeClassName("required");
		disableSearch("lovDspFshortName");
		$("txtDvFcurrencyAmt").removeClassName("required");
		$("txtCurrencyRt").removeClassName("required");
		$("chkUploadtag").disabled = true;
		
		$$("div").each(function(div){
			if (div.hasClassName("required")){
				div.removeClassName("required");
			}
		});
	}
	
	if (objACGlobal.previousModule == "GIACS070" && objACGlobal.queryOnly == "Y"){
		disableGIACS016();
	}
	
	
	$("btnPrintReq").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else if(nvl($F("newRec"), "") == "Y"){
			showMessageBox("Please create a record first.", "I");
			return false;	
		}else{
			
			if(grqd.paytReqFlag == "P" || grqd.paytReqFlag == "C"){
				showGenericPrintDialog("Check Requisition Printing", printCheckRequisition, null);
			}else{
				if(grqd.paytReqFlag == "N"){
					if(nvl($F("allowPrint"),"N") == "Y" && nvl(grqd.acctEntExist,"N") == "N"){
						showGenericPrintDialog("Check Requisition Printing", printCheckRequisition, null);
					}else{
						new Ajax.Request(contextPath+"/GIACPaytRequestsController?action=valAmtBeforeClosing", { // Copied valAmtsBeforeClosing
							method: "POST",
							parameters: {
								tranId:		grqd.tranId,
								paytAmt: nvl(grqd.paytAmt,null)
							},
							asynchronous: false,
							evalScripts: true,
							onCreate : function(){
									//showNotice("Saving Pack PAR, please wait...");
								},
							onComplete : function(response) {
								if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									showWaitingMessageBox("This disbursement requests has not been closed yet.","I", function(){
										showGenericPrintDialog("Check Requisition Printing", printCheckRequisition, null);
									});
								} else {
									showMessageBox(response.responseText, imgMessage.ERROR);
								}
							}
						});	
					}
				}else{
					showMessageBox("Cannot print cancelled request.", "I");
				}
			} 	
			
		}
	});
	
	//marco - 05.31..2013
	function showCommFundSlip(){
		try {
			objACGlobal.disbursement = disbursement;
			objACGlobal.refId = gprq.refId;
			objACGlobal.otherBranch = $F("otherBranch");
			
			new Ajax.Updater("mainContents", contextPath + "/GIACPaytRequestsController", {
				parameters : {
					action : "getCommFundListing",
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous : false,
				evalScripts : true,
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response) {
					hideNotice("");
					setModuleId("GIACS157");
					setDocumentTitle("Commission Fund Slip");
				}
			});
		} catch (e) {
			showErrorMessage("showCommFundSlip", e);
		}
	}
	observeAccessibleModule(accessType.BUTTON, "GIACS157", "btnCommFund", showCommFundSlip);
	
	observeChangeTagOnDate("hreftxtRequestDate", "txtRequestDate");
	//Main Button
	observeReloadForm("reloadForm", function(){showDisbursementMainPage(disbursement, gprq.refId,$F("otherBranch"));});
	observeSaveForm("btnSave", saveGIACS016);
	//replaced observeCancelForm- kenneth 01.06.2014 to handle logout, exit and cancel issues
	/*observeCancelForm("btnCancel", saveGIACS016, function(){
		if(objACGlobal.previousModule == "GIACS003"){//added by steven 04.09.2013
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS071"){ // added by Kris 04.11.2013
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;					
		}else if (objAC.paytReqStatTag == "Y") {		//modified by Gzelle 04.23.2013
		     objGIACS236.updatePaymentRequestStatus(objGIACS236.fundCd, objGIACS236.branchCd, objGIACS236.statusFlag);
			 //objAC.paytReqStatTag = null;
		}else if(objACGlobal.previousModule == "GIACS002"){
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == null){// GIACS016
			/* $("home").show();
			$("cashReceipts").show();
			$("generalDisbursements").show();
			$("generalLedger").show();
			$("endOfMonth").show(); 
			showDisbursementRequests(disbursement, objACGlobal.otherBranchCd);
			$("acExit").show();
		}
	});*/ 
	
	changeTag = 0;
	initializeChangeTagBehavior(saveGIACS016);
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GIACS016");
	setDocumentTitle("Enter/View Requests For Payments");
	objACGlobal.calledForm =  '';
	objACGlobal.calledForm = '';
	objACGlobal.queryOnly = "";
	
	//$("acExit").stopObserving();
	/* $("acExit").observe("click", function(){
		if(objACGlobal.previousModule == "GIACS003"){//added by steven 04.09.2013
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS071"){ // added by Kris 04.11.2013
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;					
		}else if (objAC.paytReqStatTag == "Y") {	//modified by Gzelle 04.23.2013
		     objGIACS236.updatePaymentRequestStatus(objGIACS236.fundCd, objGIACS236.branchCd, objGIACS236.statusFlag);
			 //objAC.paytReqStatTag = null;
		}else if(objACGlobal.previousModule == "GIACS002"){
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			objACGlobal.previousModule = null;
		}else{
			showDisbursementRequests(objACGlobal.disbursementCd, objACGlobal.otherBranchCd);
			objAC.paytReqStatTag = null;
		}
	});	 */
	
	//added by kenneth 01.06.2014 to display success message first before going to the previous module
	function exitForm(){
		if(objACGlobal.previousModule == "GIACS003"){//added by steven 04.09.2013
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS071"){ // added by Kris 04.11.2013
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;					
		}else if (objAC.paytReqStatTag == "Y") {		//modified by Gzelle 04.23.2013
		     objGIACS236.updatePaymentRequestStatus(objGIACS236.fundCd, objGIACS236.branchCd, objGIACS236.statusFlag);
			 //objAC.paytReqStatTag = null;
		}else if(objACGlobal.previousModule == "GIACS002"){
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			objACGlobal.previousModule = null;
		} else if(objACGlobal.callingForm2 == "GIACS607"){ //shan 06.09.2015 : conversion of GIACS607
			/*
			** nieko Accounting Uploading
			$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			$("processPremAndCommDiv").show();

			setModuleId("GIACS607");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			objACGlobal.callingForm2 = "";
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGIACS607",
					sourceCd: objGIACS607.sourceCd,
					fileNo:   objGIACS607.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else if(objACGlobal.callingForm2 == "GIACS603"){ //john : conversion of GIACS603
			/*
			** nieko Accounting Uploading
			$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			$("processDataPerPolicy").show();

			setModuleId("GIACS603");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			objACGlobal.callingForm2 = "";
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs603",
					sourceCd: objGIACS603.sourceCd,
					fileNo:   objGIACS603.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else if(objACGlobal.callingForm2 == "GIACS604"){ //john : conversion of GIACS604
			/*
			** nieko Accounting Uploading
			$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			$("processDataPerBill").show();

			setModuleId("GIACS604");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			objACGlobal.callingForm2 = "";
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs604",
					sourceCd: objGIACS604.sourceCd,
					fileNo:   objGIACS604.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else if(objACGlobal.callingForm2 == "GIACS608"){ 
			/*
			** nieko Accounting Uploading
			$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			$("processInwardRIPremDiv").show();

			setModuleId("GIACS608");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			objACGlobal.callingForm2 = "";
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGIACS608",
					sourceCd: objGIACS608.sourceCd,
					fileNo: objGIACS608.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			}); 
		} else if(objACGlobal.callingForm == "GIACS610"){ 
			$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			$("processDataPerBankRefNo").show();

			setModuleId("GIACS610");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});
		} else if (objACGlobal.callingForm2 == "GIACS609") { //Deo: GIACS609 conversion
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs609",
					sourceCd: objGIACS609.sourceCd,
					fileNo: objGIACS609.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						objACGlobal.callingForm2 = "";
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else{// GIACS016
			/* $("home").show();
			$("cashReceipts").show();
			$("generalDisbursements").show();
			$("generalLedger").show();
			$("endOfMonth").show(); */
			showDisbursementRequests(disbursement, objACGlobal.otherBranchCd);
			$("acExit").show();
		}
	}
	
	//added by kenneth 01.06.2014 to display success message first before going to the previous module
	var exitPage = null;
	function cancelGiiss016(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					exitPage = exitForm;
					saveGIACS016();
				}, exitForm, ""
			);
		} else {
			exitForm();
		}
	}
	
	$("btnCancel").observe("click", cancelGiiss016);
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	
	//shan 11.15.2013
	if ($("txtPaytReqFlag").value == "C"){
		$$("input[type='text'], textarea").each(function (a) {
			$(a).observe("keydown",function(e){
				if(e.keyCode === 46){
					$(a).blur();
				}
			});
		});
	}	
	
	$("txtDspDeptCd").observe("change", function(){
		if (this.value == ""){
			$("txtDspOucName").clear();
			this.setAttribute("lastValidValue", "");
		}else{
			showOucsLOV("GIACS016", $F("txtFundCd"), $F("txtBranchCd"), nvl(gprq.refId,null), this.value);
		}
	});
	
	$("txtPayeeClassCd").observe("change", function(){
		if (this.value != ""){
			if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
				showPayeeLOV("GIACS016", this.value);
			}
		}
	});
	
	$("txtPayeeCd").observe("change", function(){
		if (this.value == ""){
			$("txtPayee").clear();
			this.setAttribute("lastValidValue", "");
		}else{
			if ($F("txtPaytReqFlag") != "C" || $F("txtPaytReqFlag") != "X"){
				showPayeeLOV2("GIACS016", $F("txtPayeeClassCd"), this.value);
			}	
		}
	});
}catch(e){
	showErrorMessage("Disbursement main page.", e);
}
</script>