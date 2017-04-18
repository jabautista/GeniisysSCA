<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="creditDebitMemoMainDiv">
	 <div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Credit/Debit Memo</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="reloadForm" name="reloadForm" style="margin-left: 5px">Reload Form</label>
					<label id="showBillTax" name="gro" style="margin-left: 5px">Hide</label>
				</span>				 
			</div>
	</div> 
	
	<div id="creditDebitMemoInfoDiv" name="creditDebitMemoInfoDiv" changeTagAttr="true">
		<div id="creditDebitMemoSubDiv1" name="creditDebitMemoSubDiv1" class="sectionDiv" style="align:center; ">
			<table border="0" style="width:800px; margin:20px auto 20px auto;">
				<tr>
					<td align="right" width="120px">Company</td>
					<td width="280px">
						<div style="float:left; border: solid 1px gray; width: 280px; height: 23px; margin-right:0px; margin-top: 0px;" class="required" changeTagAttr="true">
							<input type="text" id="company" name="company" readonly="readonly" style="width:250px; border:none; float:left;" tabindex="101" class="required" changeTagAttr="true" disabled="disabled" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCompany" name="osCompany" alt="Go" changeTagAttr="true" />
						</div>	
					</td>
					<td align="right" width="120px">Branch</td>
					<td>
						<div style="float:left; border: solid 1px gray; width: 280px; height: 23px; margin-right:0px; margin-top: 0px;" class="required" changeTagAttr="true">
							<input type="text" id="txtBranch" name="txtBranch" readonly="readonly" style="width:250px; border:none; float:left;"  tabindex="102" class="required" changeTagAttr="true" disabled="disabled" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranch" name="osBranch" alt="Go" changeTagAttr="true" />
						</div>	
					</td>
				</tr>
			</table>
		</div>
		
		<div id="creditDebitMemoSubDiv2" name="creditDebitMemoSubDiv2" class="sectionDiv">
			<table border="0" style="width: 800px; margin:30px auto 20px auto;">
				<tr>
					<td>
						<input type="hidden" id="hidGaccTranId" name="hidGaccTranId" />
						<input type="hidden" id="txtFundCd" name="txtFundCd" />
						<input type="hidden" id="txtDspFundDesc" name="txtDspFundDesc" />
						<input type="hidden" id="txtDspBranchCd" name="txtDspBranchCd" />
						<input type="hidden" id="txtBranchCd" name="txtBranchCd" />
						<input type="hidden" id="txtDspBranchName" name="txtDspBranchName" />
						<input type="hidden" id="hidRecipientType" name="hidRecipientType" />
						<input type="hidden" id="hidRecipientNo" name="hidRecipientNo" />
						<input type="hidden" id="hidClosedTag" name="hidClosedTag" />
						<input type="hidden" id="hidTranFlag" name="hidTranFlag" />
						<input type="hidden" id="dfltCurrencyCd" name="dfltCurrencyCd" />
						<input type="hidden" id="dfltCurrencyRt" name="dfltCurrencyRt" />						
					</td>
				</tr>
				<tr>
					<td align="right" width="120px">Type</td>
					<td width="280px" align="left">
						<input type="text" id="txtMemoType" name="txtMemoType" maxLength="3" style="width:60px;" readonly="readonly"  class="required" changeTagAttr="true" />
						<select id="selMeanMemoType" name="selMeanMemoType" style="width:187px; height:24px;" tabindex="103" class="required"  >
							<option value="CM" selected="selected">Credit Memo</option>
							<option value="DM">Debit Memo</option>
							<option value="RCM">Credit Memo for RI Commissions</option>
						</select>
					</td>
					<td align="right" width="120px">Date</td>
					<td width="280px" align="left">
						<div style="float:left; border: solid 1px gray; width: 258px; height: 20px; margin-right:0px; margin-top: 0px;" class="required">
					    	<input type="text" id="txtMemoDate" name="txtMemoDate"  style="float:left;width:233px; border: none; height:12px;" readonly="readonly" tabindex="104" class="required" changeTagAttr="true" />
					    	<img name="hrefMemoDate" id="hrefMemoDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="MemoDate" /> <!-- onClick="scwShow($('txtMemoDate'),this, null);"  -->
						</div>
					</td>
				</tr>	
				<tr>
					<td align="right">Memo No.</td>
					<td align="left">
						<input type="text" id="txtMemoYear" name="txtMemoYear" style="width:60px;text-align:right;" maxlength="4" readonly="readonly" />
						<input type="text" id="txtMemoSeqNo" name="txtMemoSeqNo" style="width:180px;text-align:right;" maxlength="6" readonly="readonly" />
					</td>
					<!-- <td><input type="text" id="txtMemoSeqNo" name="txtMemoSeqNo" /></td> -->
					<td align="right">Status</td>
					<td align="left">
						<input type="text" id="txtMemoStatus" name="txtMemoStatus" style="width:60px; text-align:center;" maxlength="1" readonly="readonly"/>
						<input type="text" id="txtMeanMemoStatus" name="txtMeanMemoStatus" style="width:183px;" readonly="readonly"/>
					</td>
					<!-- <td><input type="text" id="txtMeanMemoStatus" name="txtMeanMemoStatus" /></td> -->
				</tr>
				<tr>
					<td align="right">Recipient</td>
					<td colspan="3" align="left">
						<div style="float:left; border: solid 1px gray; width: 665px; height: 21px; margin-right:0px; margin-top: 0px;" class="required">
							<input type="text" id="txtRecipient" name="txtRecipient" style="float:left;width:639px; border: none; height:12px;" maxlength="240" tabindex="105" class="required"  changeTagAttr="true" />
							<%-- <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 14px; height: 14px; margin: 3px; float: left;" id="osRecipients" name="osRecipients" alt="Go" /> --%>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osRecipients" name="osRecipients" alt="Go" />
						</div>						
					</td>
				</tr>
				<tr>
					<td align="right">Particulars</td>
					<td colspan="3" align="left">
						<div style="float:left; border: solid 1px gray; width: 665px; height: 21px; margin-right:0px; margin-top: 0px;" class="required">
							<textarea id="txtParticulars" name="txtParticulars"  style="float:left;width:639px; border: none; height:14px;" maxlength="2000"  tabindex="106" class="required"  changeTagAttr="true" ></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 15px; height: 15px; margin: 2px; float: left;" alt="EditParticulars" id="textParticulars" class="hover" />
						</div>	
					</td>
				</tr>
				<tr>
					<td align="right">Amount</td>
					<td align="left">
						<!-- <input type="text" id="txtForeignCurrSname" name="txtForeignCurrSname" style="width:60px;"  /> -->
						<!-- <input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" style="width:60px;"  /> -->
						<input type="hidden" id="txtCurrencyCd" name="txtCurrencyCd" />
						<input type="hidden" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" />
						<div style="float:left; border: solid 1px gray; width: 65px; height:21px; margin-right:3px; margin-top: 2px;" class="required">
							<input type="text" id="txtDspFshortName" name="txtDspFshortName" maxlength="5" style="width:35px; border:none; float:left; height:12px" readonly="readonly" tabindex="107" class="required" changeTagAttr="true" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCurrency" name="osCurrency" alt="Go" />
						</div>	
						<input type="text" id="txtForeignAmount" name="txtForeignAmount" maxlength="16" lastValidValue="" style="width:180px;text-align:right;float:left;height:15px;" tabindex="108" class="money2 required" changeTagAttr="true"  /> <!-- maxlength="18"  -->
					</td>
					<!-- <td><input type="text" id="txtForeignAmount" name="txtForeignAmount" /></td> -->
					<td align="right">Local Amount</td>
					<td align="left">
						<input type="text" id="txtLocalCurrSname" name="txtLocalCurrSname" maxlength="5" readonly="readonly" style="width:60px;" />
						<input type="text" id="txtLocalAmount" name="txtLocalAmount" style="width:183px;text-align:right;" readonly="readonly"/>
					</td>
					<!-- <td><input type="text" id="txtLocalAmount" name="txtLocalAmount" /></td> -->
				</tr>
				<tr>
					<td align="right">Conversion Rate</td>
					<td align="left">
						<!-- commented out and changed by reymon 05062013 <input type="text" id="txtCurrencyRt" name="txtCurrencyRt" style="width:250px;text-align:right;"  readonly="readonly"/> -->
						<input type="text" id="txtCurrencyRt" name="txtCurrencyRt" style="width:250px;text-align:right;float:left;height:15px;" tabindex="109" class="required" changeTagAttr="true"  />
					</td>
					<td id="tdRiCommAmt" align="right">RI Comm Amt</td> <!-- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 -->
					<td>
						<input type="text" id="txtRiCommAmt" maxlength="16" lastValidValue="" style="text-align: right; width: 255px; float: left; " tabindex="110" class="money2" changeTagAttr="true" />
					</td>
				</tr>
				<tr id="trRiCommVat"> <!-- bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 -->
					<td align="right" colspan="3">RI Comm Vat</td>
					<td>
						<input type="text" id="txtRiCommVat" maxlength="16" lastValidValue="" style="text-align: right; width: 255px; float: left; " tabindex="111" class="money2" changeTagAttr="true" />
					</td>
				</tr>
				<tr>
					<td align="right">User ID</td>
					<td align="left"><input type="text" id="txtUserId" name="txtUserId" style="width:250px;" readonly="readonly" /></td>
					<td align="right">Last Update</td>
					<td align="left"><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width:255px;" readonly="readonly" /></td>
				</tr>
			</table>
			
			<div id="CreditDebitMemoButtonsDiv" name="CreditDebitMemoButtonsDiv" class="buttonsDiv" style="margin-bottom: 20px;">
				<input type="button" class="button noChangeTagAttr" id="btnDetails" name="btnDetails" value="Details" />
				<input type="button" class="button noChangeTagAttr" id="btnAccountingEntries" name="btnAccountingEntries" value="Accounting Entries" />
				<input type="button" class="button noChangeTagAttr" id="btnPrintCMDM" name="btnPrintCMDM" />  <!-- value="Print CM/DM" -->
			</div>
		</div>
		
		<div id="CreditDebitMemoCancelSaveButtonsDiv" name="CreditDebitMemoCancelSaveButtonsDiv" class="buttonsDiv" style="margin-bottom: 2;">
			<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" />
			<input type="button" class="button" id="btnSave" name="btnSave" value="Save" />
		</div>		
		
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIACS071");
	setDocumentTitle("Credit/Debit Memo");
	changeTag = 0;
	objACGlobal.objGIACS071 = {}; //added by steven 11.22.2013
	
	try {
		var cancelFlag = '${cancelFlag}';
		var memoInfo = JSON.parse('${memoInfo}');
	} catch (e){}
	
	initializeFields();
	
	// sets the values of text fields
	function initializeFields(){
		objGIAC071.prevParams.validCurrSname = "Y";
		$("hidGaccTranId").value = memoInfo.gaccTranId;
		$("txtFundCd").value = memoInfo.fundCd;
		$("txtDspFundDesc").value = memoInfo.fundDesc;
		$("txtBranchCd").value = memoInfo.branchCd;
		$("txtDspBranchName").value = memoInfo.branchName;
		$("dfltCurrencyCd").value = memoInfo.localCurrCd;
		$("dfltCurrencyRt").value = memoInfo.localCurrencyRt;
		$("hidTranFlag").value = memoInfo.tranFlag;
		
		$("company").value = memoInfo.fundCd == null ? "" : memoInfo.fundCd + " - " + memoInfo.fundDesc;
		$("txtBranch").value =  memoInfo.branchCd == null ? "" : memoInfo.branchCd + " - " + memoInfo.branchName;
		$("txtMemoType").value = memoInfo.memoType;
		$("selMeanMemoType").value = memoInfo.memoType; //added by steven 11.21.2013
		$("txtMemoDate").value = dateFormat(memoInfo.dspMemoDate, 'mm-dd-yyyy'); //dateFormat(new Date(), 'mm-dd-yyyy');
		$("txtMemoYear").value = memoInfo.memoYear; //dateFormat(new Date(), 'yyyy');
		$("txtMemoSeqNo").value = memoInfo.memoSeqNo == null ? "" : formatNumberDigits(memoInfo.memoSeqNo, 6);
		$("txtMemoStatus").value = memoInfo.memoStatus; //"U";
		$("txtMeanMemoStatus").value = memoInfo.meanMemoStatus; //"Unprinted";
		$("txtRecipient").value = unescapeHTML2(memoInfo.recipient);
		$("txtParticulars").value = unescapeHTML2(memoInfo.particulars);
		$("txtDspFshortName").value = memoInfo.foreignCurrSname == null ? memoInfo.localCurrSname : memoInfo.foreignCurrSname;
		$("txtCurrencyRt").value = memoInfo.currencyRt == null ? formatToNineDecimal(memoInfo.localCurrRt) : formatToNineDecimal(memoInfo.currencyRt);
		$("txtCurrencyCd").value = memoInfo.currencyCd == null ? memoInfo.localCurrCd : memoInfo.currencyCd;
		$("txtForeignAmount").value = formatCurrency(memoInfo.foreignAmount);
		$("txtLocalCurrSname").value = memoInfo.localCurrSname;
		$("txtLocalAmount").value = formatCurrency(memoInfo.localAmount);
		$("txtLastUpdate").value = memoInfo.lastUpdateStr;
		$("txtUserId").value = memoInfo.userId;
		$("txtRiCommVat").value = formatCurrency(memoInfo.riCommVat);
		$("txtRiCommAmt").value = formatCurrency(memoInfo.riCommAmt);
		//$("btnPrintCMDM").value = cancelFlag == "Y" ? "Cancel" : "Print CM/DM";
		if(objACGlobal.callingForm == "memoListing"){
			disableUpdateToFields();
		}
		toggleRCMFields(); // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
	}
	
	if(cancelFlag == "Y") {
		$("btnPrintCMDM").value = "Cancel CM/DM";
		disableButton($("btnSave"));
		makeBlockQueryOnly(true);	//update_allowed = false;
	} else {
		$("btnPrintCMDM").value = "Print CM/DM";
		$F("txtMemoStatus") == "C" ? disableButton($("btnPrintCMDM")) : enableButton($("btnPrintCMDM"));
		makeBlockQueryOnly(false);
		
		if($F("txtMemoType") == "CM" || $F("txtMemoType") == "DM" || $F("txtMemoType") == "RCM"){
			$F("txtMemoSeqNo") == "" ? disableButton($("btnPrintCMDM")) : enableButton($("btnPrintCMDM"));
			
			if($F("hidTranFlag") == "C" || $F("hidTranFlag") == "P" || $F("hidTranFlag") == "D" || $F("txtMemoStatus") == "C" || $F("txtMemoStatus") == "P"){
				makeBlockQueryOnly(true);	//update_allowed = false;
			} else {
				makeBlockQueryOnly(false);	//update_allowed = true;				
			}
		} else {
			makeBlockQueryOnly(true);	//update_allowed = false;
		}
	}
	
	//buttons behavior
	if($F("txtMemoType") == "CM" || $F("txtMemoType") == "DM" || $F("txtMemoType") == "RCM"){
		enableButton($("btnDetails"));
		enableButton($("btnAccountingEntries"));
	} else {
		disableButton($("btnDetails"));
		disableButton($("btnAccountingEntries"));
	}
	if($F("txtMemoSeqNo") == "" && $F("hidGaccTranId") == ""){
		$("btnSave").value = "Save";
	} else {
		$("btnSave").value = "Update";
	}
	
	
	
	function makeBlockQueryOnly(isQueryOnly){
		isQueryOnly ? disableSearch($("osCompany")) : enableSearch($("osCompany"));
		isQueryOnly ? disableSearch($("osBranch")) : enableSearch($("osBranch"));
		isQueryOnly ? disableDate($("hrefMemoDate")) : enableDate($("hrefMemoDate")); 
		isQueryOnly ? disableSearch($("osRecipients")) : enableSearch($("osRecipients")); 
		isQueryOnly ? disableSearch($("osCurrency")) : enableSearch($("osCurrency"));
		
		//isQueryOnly ? disableInputField($("txtMemoType")) : enableInputField($("txtMemoType"));
		//isQueryOnly ? disableInputField($("selMeanMemoType")) : enableInputField($("selMeanMemoType")); -- marco - 04.28.2013 - replaced with line below
		isQueryOnly ? $("selMeanMemoType").disabled = true : $("selMeanMemoType").disabled = false;
		isQueryOnly ? disableInputField($("txtRecipient")) : enableInputField($("txtRecipient"));
		isQueryOnly ? disableInputField($("txtParticulars")) : enableInputField($("txtParticulars"));
		isQueryOnly ? disableInputField($("txtDspFshortName")) : enableInputField($("txtDspFshortName"));
		isQueryOnly ? disableInputField($("txtForeignAmount")) : enableInputField($("txtForeignAmount"));
		isQueryOnly ? disableInputField($("txtCurrencyRt")) : enableInputField($("txtCurrencyRt"));//added by reymon 05062013
		
		objACGlobal.queryOnly = isQueryOnly ? "Y" : "N";
		
		if(isQueryOnly == false && $F("hidGaccTranId") != ""){
			disableUpdateToFields();
		}			
	}
	
	function convertToLocalAmount(){
		var bool = true;
		var localAmount = 0;
		if($F("txtForeignAmount") != "" && $F("txtCurrencyRt") != ""){
			var foreignAmount = parseFloat(unformatCurrency("txtForeignAmount"));//added by reymon 05062013
			var currencyRt = parseFloat($F("txtCurrencyRt"));//added by reymon 05062013
			//var localAmount = parseFloat($F("txtForeignAmount")) * parseFloat($F("txtCurrencyRt")); commented out and changed by reymon 05062013
			localAmount = foreignAmount * currencyRt;
			$("txtLocalAmount").value = formatCurrency(localAmount);	
			$("txtForeignAmount").value = formatCurrency($F("txtForeignAmount"));
			
			//$("txtLocalAmount").value = formatCurrency(roundNumber((unformatCurrency("txtCurrencyRt") * unformatCurrency("txtForeignAmount")),2));			
		} else {
			//$("txtCurrencyRt").value = formatToNineDecimal(1);//added by reymon 05062013
			$("txtForeignAmount").focus();
			bool = false;
		}
		//added by steven 11.22.2013
		if(localAmount > 9999999999.99 || localAmount < -9999999999.99){
			showWaitingMessageBox("Invalid Local Amount. Value should be from -9,999,999,999.99 to 9,999,999,999.99.", "I", function(){
				$("txtForeignAmount").clear();
				$("txtLocalAmount").clear();
				$("txtForeignAmount").focus();
			});
			bool = false;
		}
		return bool;
	}
	
	objACGlobal.objGIACS071.convertToLocalAmount = convertToLocalAmount; //added by steven 11.22.2013
	
	// function to save memo into the database
	function saveMemo(){
		try {
			new Ajax.Request(contextPath + "/GIACMemoController?action=saveMemo", {
				method : "POST",
				parameters : {
					gaccTranId		: $F("hidGaccTranId"),
					fundCd			: $F("txtFundCd"),
					branchCd		: $F("txtBranchCd"),
					memoType		: $F("txtMemoType"),
					memoDate		: $F("txtMemoDate"),
					memoYear		: $F("txtMemoYear"),
					memoSeqNo		: $F("txtMemoSeqNo"),
					memoStatus		: $F("txtMemoStatus"),
					recipient		: $F("txtRecipient"),
					particulars		: $F("txtParticulars"),
					currencyCd		: $F("txtCurrencyCd"),
					currencyRt		: $F("txtCurrencyRt"),
					foreignAmount	: unformatCurrencyValue($F("txtForeignAmount")),
					localAmount		: unformatCurrencyValue($F("txtLocalAmount")),
					riCommAmt		: unformatCurrencyValue($F("txtRiCommAmt")), // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
					riCommVat		: unformatCurrencyValue($F("txtRiCommVat")), // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
					lastUpdate		: $F("txtLastUpdate"),
					cancelFlag		: cancelFlag,
					moduleId		: "GIACS071"
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Saving memo, please wait..."),
				onComplete: function (response) {
					hideNotice("");
					try{
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							/* showMessageBox(response.responseText, imgMessage.INFO);
							updateMemoInformation(cancelFlag, $F("txtBranchCd"), $F("txtFundCd")); */
							var memo = new Object();
							memo = JSON.parse(response.responseText);
							if($F("hidGaccTranId") == ""){ // for newly added memo
								disableUpdateToFields();						
							}	
							updateFields(memo);	
							changeTag = 0;
							showMessageBox(objCommonMessage.SUCCESS, "S");
						}else{
							showMessageBox(response.responseText, "E");
						}
					}catch(e){
						showMessageBox(response.responseText, "E");
					}
				}
			});
		} catch (e) {
			showErrorMessage("saveMemo", e);
		}
	}	
	
	function updateFields(memo){
		if($F("hidGaccTranId") != "" || $F("txtMemoSeqNo") != ""){
			$("txtLastUpdate").value = memo.lastUpdateStr;
		}
		
		$("txtMemoSeqNo").value = memo.memoSeqNo;
		$("txtUserId").value = memo.userId;
		$("hidGaccTranId").value = memo.gaccTranId;
		objACGlobal.gaccTranId = memo.gaccTranId;
	}
	
	function disableUpdateToFields(){
		enableButton($("btnPrintCMDM"));
		$("btnSave").value = "Update";
		
		disableSearch($("osCompany"));
		disableSearch($("osBranch"));
		$("company").disabled = true;
		$("txtBranch").disabled = true;
		$("txtMemoDate").disabled = true;
		$("txtMemoType").disabled = true;
		$("selMeanMemoType").disabled = true;
		//$("txtDspFshortName").disabled = true;
		disableDate($("hrefMemoDate"));
	}
	
	function getClosedTag(){
		try {
			new Ajax.Request(contextPath + "/GIACMemoController?action=getClosedTag", {
				method	: "POST",
				parameters : {
					fundCd	 : $F("txtFundCd"),  
					branchCd : $F("txtBranchCd"),
					memoDate : $F("txtMemoDate")
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Retrieving closed tag, please wait..."),
				onComplete: function (response) {
					hideNotice();
					validateMemoDate(response.responseText);
				}
			});
		} catch(e){
			showMessageBox("getClosedTag: " + e.message, "E");
		}		
	}
	
	//cancel_opt procedure
	function cancelOption(){
		if($F("txtMemoType") == "CM" || $F("txtMemoType") == "DM" || $F("txtMemoType") == "RCM"){
			if(memoInfo.tranFlag == "D" || $F("txtMemoStatus") == "C"){
				showMessageBox("CM/DM is already cancelled.", imgMessage.INFO);
			} else if ($F("txtMemoType") == "CM" && memoInfo.checkAppliedCMTag == 1){
				showMessageBox("Applied CM cannot be cancelled.", imgMessage.INFO);
			} else {
				//proceed to cancellation
				if(memoInfo.checkUserPerIssCdAcctgTag == 0){
					showMessageBox("You are not allowed to cancel for this branch.", imgMessage.INFO);
				} else {
					showConfirmBox("Cancel CM/DM", "Proceed with CM/DM Cancellation?", "Yes", "No", proceedCancelMemo, "", "");
				}
			}
		} else {
			showMessageBox("Only CM/DM can be cancelled.", imgMessage.ERROR);
		}
	}
	
	function proceedCancelMemo(){
		try {
			new Ajax.Request(contextPath + "/GIACMemoController?action=cancelMemo", {
				method: "POST",
				parameters: {
					gaccTranId 	: $F("hidGaccTranId"),
					fundCd		: $F("txtFundCd"),
					branchCd	: $F("txtBranchCd"),
					memoType	: $F("txtMemoType"),
					memoYear	: $F("txtMemoYear"),
					memoSeqNo	: $F("txtMemoSeqNo"),
					memoDate	: $F("txtMemoDate"),
					tranFlag	: $F("hidTranFlag")
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Cancelling CM/DM, please wait..."),
				onComplete: function (response) {
					hideNotice();	
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						showMessageBox(response.responseText, imgMessage.INFO);
						updateMemoInformation(cancelFlag, $F("txtBranchCd"), $F("txtFundCd"));
					}
				}
			});
		} catch(e){
			showMessageBox("proceedCancelMemo: " + e.message, "E");
		}		
	}
	
	function proceedSaveMemo(){
		/* changed by reymon 05062013
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			if(checkAllRequiredFieldsInDiv("creditDebitMemoInfoDiv")){
				saveMemo();	
			}
		}*/
		if(checkAllRequiredFieldsInDiv("creditDebitMemoInfoDiv")){
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES, "I");
			} else {
				if(checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS071")){ //marco - SR-5730 - 03.14.2017
					saveMemo();
				}
			}
		}
	}
	
	function validateMemoDate(closedTag){
		var message = "";
		var memoDate = Date.parse($F("txtMemoDate"));
		var isTranMonthClosed = false;
		
		if($F("txtMemoDate") != ""){
			// transaction month temporarily closed
			if( closedTag == "T" && memoInfo.allowTranForClosedMonthTag == "N"){
				message = "You are no longer allowed to create a transaction for " + 
							dateFormat(memoDate, "mmmm") + " " + dateFormat(memoDate, "yyyy") + 
							". This transaction month is temporarily closed.";
				isTranMonthClosed = true;
			} 
			// transaction month already closed
			else if(closedTag == "Y" && memoInfo.allowTranForClosedMonthTag == "N"){
				message = "You are no longer allowed to create a transaction for " + 
							dateFormat(memoDate, "mmmm") + " " + dateFormat(memoDate, "yyyy") + 
							". This transaction month is already closed.";
				isTranMonthClosed = true;
			} 		
		}	
		
		if(isTranMonthClosed){
			customShowMessageBox(message, imgMessage.INFO, "txtMemoDate");
			$("txtMemoDate").value = new Date().format("mm-dd-yyyy");
		}else{
			$("txtRecipient").focus();				
		}		 
	}
	
	function printMemo(){
		try{
			var content = contextPath + "/GeneralLedgerPrintController?action=printReport"   //added by steven 5/31/2013
						  			  + "&noOfCopies=" + $F("txtNoOfCopies") 
						  			  + "&printerName=" + $F("selPrinter") 
						  			  + "&destination=" + $F("selDestination")
									  + "&fundCd=" + nvl($F("txtFundCd"), "")
									  + "&branchCd=" + nvl($F("txtBranchCd"), "")
									  + "&moduleId=GIACS071"	
									  + "&tranId=" +  "|" + nvl($F("hidGaccTranId"), "") + "|" //edited by MarkS 9.26.2016 SR23107
									  + "&memoStatus=" + $F("txtMemoStatus")
									  + "&reportId=GIACR071";	
			printGenericReport(content, "PRINT CREDIT/DEBIT MEMO");
		}catch(e){
			showErrorMessage("printMemo",e);
		}
	}
	
	function updateMemoStatus(){
		try {
			new Ajax.Request(contextPath + "/GIACMemoController?action=updateMemoStatus", {
				method		: "POST",
				parameters	: {
					memoStatus	: $F("txtMemoStatus"),
					gaccTranId	: $F("hidGaccTranId")					
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Updating memo status, please wait..."),
				onComplete: function (response) {
					hideNotice();	
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						//showMessageBox(response.responseText, imgMessage.INFO);
						updateMemoInformation(cancelFlag, $F("txtBranchCd"), $F("txtFundCd"));
					}
				}
			});
		} catch(e){
			showMessageBox("updateMemoStatus: " + e.message, "E");
		}
	}
	
	// Executes chk_form_stat Procedure body on GIACS071
	function checkFormStat(parameterFormCall){		
		if(objACGlobal.queryOnly == "N" && changeTag == 1){
			if($F("hidGaccTranId") != ""){ 		//changed memo
				showMessageBox("There are unsaved changes. Please save your work first.", imgMessage.ERROR);
			} else if($F("hidGaccTranId") == ""){ //inserted memo
				showMessageBox("Please complete and save the CM/DM transaction first.", imgMessage.ERROR);
			}
		} else if(changeTag == 0 && $F("hidGaccTranId") == ""){ //new
			showMessageBox("Please create a CM/DM transaction first.", imgMessage.ERROR);
		} else if(objACGlobal.queryOnly == "Y" || (objACGlobal.queryOnly == "N" && $F("hidGaccTranId") != "" && changeTag == 0)) {
			if(parameterFormCall == "GIACS001" || parameterFormCall == "GIACS002" || parameterFormCall == "GIACS016"){
				//  call the function to call the modules.
				//	call_form(parameter.formcall, hide, no_replace, query_only);
			} else if(memoInfo.tranFlag == "O" && ($F("txtMemoType") == "CM" || $F("txtMemoType") == "DM" || $F("txtMemoType") == "RCM")){
				if(objACGlobal.callingForm == "DETAILS" /*&& memoInfo.checkAppliedCMTag == 1*/){
					if(memoInfo.checkAppliedCMTag == 1){
						showMessageBox("This is an applied CM. You cannot change the details.", imgMessage.INFO);
					}
					//call_form(parameter.formcall, hide, no_replace, query_only);
					//objACGlobal.queryOnly = "Y"; // comment out by, query mode should be when printed or cancelled andrew 6.14.2013
					showORInfo();					
				} else if(objACGlobal.callingForm == "ACCT_ENTRIES" /*&& memoInfo.checkAppliedCMTag == 1*/){
					if(memoInfo.checkAppliedCMTag == 1){
						showMessageBox("This is an applied CM. You cannot change the accounting entries.", imgMessage.INFO);
					}
					//call_form(parameter.formcall, hide, no_replace, query_only);
					//objACGlobal.queryOnly = "Y"; // comment out by, query mode should be when printed or cancelled andrew 6.14.2013
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
				}
			} else {
				//call_form(parameter.formcall, hide, no_replace, query_only);
				//objACGlobal.queryOnly = "Y";
				
				if(objACGlobal.callingForm == "DETAILS"){
					//objACGlobal.queryOnly = "Y"; // comment out by, query mode should be when printed or cancelled andrew 6.14.2013
					showORInfo();
				} else if(objACGlobal.callingForm == "ACCT_ENTRIES"){
					//objACGlobal.queryOnly = "Y"; // comment out by, query mode should be when printed or cancelled andrew 6.14.2013
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
				}
			}
		}
	}
	
	$("hrefMemoDate").observe("click", function() {
		if($F("hidGaccTranId") == ""){
			scwShow($('txtMemoDate'),this, null);
		} 
	});
	
	$("osCompany").observe("click", function ()	{
		if ($("osCompany").disabled != true){
			showCompanyLOV('GIACS071');
		}
	});
	
	$("osBranch").observe("click", function ()	{
		if ($("osBranch").disabled != true){
			if($F("company") != "") {
				//showBranchLOV('GIACS071', $F("txtFundCd"));
				//var findText2 = $F("txtBranch").trim() == "" ? "%" : $F("txtBranch");
				showGIACS003BranchLOV('GIACS071', $F("txtFundCd"), '%');
			} else {
				showMessageBox("Please select Company first.", imgMessage.INFO);
			}
		}				
	});	
	
	$("osRecipients").observe("click", function ()	{
		if ($("osRecipients").disabled != true){
			showRecipientLOV();
		}
	});	
	
	$("osCurrency").observe("click", function ()	{
		showCurrencyLOV('GIACS071');	
	});	
	
	$("textParticulars").observe("click", function () {
		if(cancelFlag == "Y"){
			showEditor("txtParticulars", 2000, 'true');
		} else {
			showEditor("txtParticulars", 2000, 'false');
		}
	});	
	
	// bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 START
	function enableRiCommFields(bool){
		if(bool){
			$("txtRiCommAmt").addClassName("required");
			$("txtRiCommVat").addClassName("required");
			enableInputField("txtRiCommAmt");
			enableInputField("txtRiCommVat");
		}else{
			$("txtRiCommAmt").removeClassName("required");
			$("txtRiCommVat").removeClassName("required");
			disableInputField("txtRiCommAmt");
			disableInputField("txtRiCommVat");
		}
	}
	
	function toggleRCMFields(){
		if($("txtMemoType").value == "RCM"){
			$("tdRiCommAmt").show();
			$("txtRiCommAmt").show();
			$("trRiCommVat").show();
			$("txtRiCommAmt").addClassName("required");
			$("txtRiCommVat").addClassName("required");
			if(memoInfo.dvNo == null){
				if(memoInfo.tranFlag == "C" || memoInfo.tranFlag == "D" || memoInfo.tranFlag == "P"){
					enableRiCommFields(false);
				}else if(memoInfo.tranFlag == "O"){
					enableRiCommFields(true);
				}
			}else{
				enableRiCommFields(false);
			}
		}else{
			$("tdRiCommAmt").hide();
			$("txtRiCommAmt").hide();
			$("trRiCommVat").hide();
			$("txtRiCommAmt").removeClassName("required");
			$("txtRiCommVat").removeClassName("required");
			$("txtRiCommAmt").clear();
			$("txtRiCommVat").clear();
		}
	}
	
	$("selMeanMemoType").observe("change", function(){
		$("txtMemoType").value = $F("selMeanMemoType");
		toggleRCMFields(); 
	});
	
	$("txtRiCommAmt").observe("change", function() {		
		if($F("txtRiCommAmt").trim() == "") {
			$("txtRiCommAmt").value = "";
			$("txtRiCommAmt").setAttribute("lastValidValue", "");
		} else {
			if(parseFloat($F("txtRiCommAmt")) < 0 || parseFloat($F("txtRiCommAmt")) > 9999999999.99){
				showWaitingMessageBox("Invalid Amount. Value should be from 0 to 9,999,999,999.99.", "I", function(){
					$("txtRiCommAmt").value = formatCurrency($("txtRiCommAmt").readAttribute("lastValidValue"));
					$("txtRiCommAmt").focus();
				});
			} else {				
				$("txtRiCommAmt").setAttribute("lastValidValue", $F("txtRiCommAmt"));
				$("txtRiCommAmt").value = formatCurrency($F("txtRiCommAmt"));
			}		
		}
	});
	
	$("txtRiCommAmt").observe("focus", function(e) {
		if(!$("txtRiCommAmt").hasAttribute("readonly"))
			$("txtRiCommAmt").value = unformatCurrency("txtRiCommAmt");
	});
	
	$("txtRiCommAmt").observe("keyup", function(e) {	
		if(!$("txtRiCommAmt").hasAttribute("readonly")){
			if(isNaN($F("txtRiCommAmt"))) {
				$("txtRiCommAmt").value = nvl($("txtRiCommAmt").readAttribute("lastValidValue"), "");
			}
		}
	});
	
	$("txtRiCommVat").observe("change", function() {		
		if($F("txtRiCommVat").trim() == "") {
			$("txtRiCommVat").value = "";
			$("txtRiCommVat").setAttribute("lastValidValue", "");
		} else {
			if(parseFloat($F("txtRiCommVat")) < 0 || parseFloat($F("txtRiCommVat")) > 9999999999.99){
				showWaitingMessageBox("Invalid Amount. Value should be from 0 to 9,999,999,999.99.", "I", function(){
					$("txtRiCommVat").value = formatCurrency($("txtRiCommVat").readAttribute("lastValidValue"));
					$("txtRiCommVat").focus();
				});
			} else {				
				$("txtRiCommVat").setAttribute("lastValidValue", $F("txtRiCommVat"));
				$("txtRiCommVat").value = formatCurrency($F("txtRiCommVat"));
			}		
		}
	});
	
	$("txtRiCommVat").observe("focus", function(e) {	
		if(!$("txtRiCommVat").hasAttribute("readonly"))
			$("txtRiCommVat").value = unformatCurrency("txtRiCommVat");
	});
	
	$("txtRiCommVat").observe("keyup", function(e) {
		if(!$("txtRiCommVat").hasAttribute("readonly")){
			if(isNaN($F("txtRiCommVat"))) {
				$("txtRiCommVat").value = nvl($("txtRiCommVat").readAttribute("lastValidValue"), "");
			}
		}
	});
	// bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002 END
	
/* 	$("txtForeignAmount").observe("blur", function(){
		if(convertToLocalAmount()){
			$("txtLocalAmount").focus();
		} else {
			$("txtForeignAmount").focus();
			$("txtLocalAmount").value = "";
		}			
	});  */
	
	$("txtForeignAmount").observe("change", function() {		
		if($F("txtForeignAmount").trim() == "") {
			$("txtForeignAmount").value = "";
			$("txtForeignAmount").setAttribute("lastValidValue", "");
			$("txtLocalAmount").value = "";
		} else {
			if(parseFloat($F("txtForeignAmount")) < -9999999999.99 || parseFloat($F("txtForeignAmount")) > 9999999999.99){
				showWaitingMessageBox("Invalid Amount. Value should be from -9,999,999,999.99 to 9,999,999,999.99.", "I", function(){
					$("txtForeignAmount").value = formatCurrency($("txtForeignAmount").readAttribute("lastValidValue"));
					if(convertToLocalAmount()){
						$("txtLocalAmount").focus();
					} else {
						$("txtForeignAmount").focus();
						$("txtLocalAmount").value = "";
					} 
				});
			} else {				
				$("txtForeignAmount").setAttribute("lastValidValue", $F("txtForeignAmount"));
				$("txtForeignAmount").value = formatCurrency($F("txtForeignAmount"));
				if(convertToLocalAmount()){
					$("txtLocalAmount").focus();
				} else {
					$("txtForeignAmount").focus();
					$("txtLocalAmount").value = "";
				}
			}		
		}
	});
	
	$("txtForeignAmount").observe("focus", function(e) { // bonok :: 3.29.2016 :: UCPB SR 21228 AC-SPECS-2016-002
		if(!$("txtForeignAmount").hasAttribute("readonly")){
			$("txtForeignAmount").value = unformatCurrency("txtForeignAmount");
		}
	});	
	
	$("txtForeignAmount").observe("keyup", function(e) {	
		if(!$("txtForeignAmount").hasAttribute("readonly")){
			if(!(e.keyCode == 109 || e.keyCode == 173) && isNaN($F("txtForeignAmount"))) {
				$("txtForeignAmount").value = nvl($("txtForeignAmount").readAttribute("lastValidValue"), "");
			}
		}
	});		
	
	$("txtDspFshortName").observe("blur", function(){
		if($F("txtDspFshortName") == ""){
			$("osCurrency").click();
		} else {
			//validate currency short name
			try{
				new Ajax.Request(contextPath + "/GIACMemoController?action=validateCurrSname", {
					method		: "POST",
					parameters	: {
						shortname: $F("txtDspFshortName")					
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Validating currency short name, please wait..."),
					onComplete: function (response) {
						hideNotice();	
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
							if(response.responseText == "Y"){
								if(convertToLocalAmount()){
									$("txtLocalAmount").focus();
								} else {
									$("txtForeignAmount").focus();
									$("txtLocalAmount").value = "";
								}
							} else {
								// open the LOV for currency shortname
								objGIAC071.prevParams.validCurrSname = "N";
								$("osCurrency").click();
							}
						}
					}
				});
			
			} catch(e){
				showErorrMessage("txtDspFshortName",e);
			}
		}
	});
	
	$("txtCurrencyRt").observe("blur", function(){
		try{
			//added condition by reymon 05062013
			if (parseFloat($F("txtCurrencyRt")) > 999.999999999 || parseFloat($F("txtCurrencyRt")) < 1 || isNaN($F("txtCurrencyRt"))){
				//$("txtCurrencyRt").value = formatToNineDecimal(1);
				customShowMessageBox("Field must be greater than 0 or less 999.999999999.", imgMessage.ERROR, "txtCurrencyRt");
			}
			if(convertToLocalAmount()){
				//$("txtForeignAmount").value = formatCurrency(nvl($F("txtForeignAmount"),0));	
				$("txtCurrencyRt").value = formatToNineDecimal($F("txtCurrencyRt"));
				$("txtLocalAmount").focus();
			} else {
				$("txtForeignAmount").focus();
				$("txtLocalAmount").value = "";
			}
		} catch(e){
			showErrorMessage("txtCurrencyRt", e);
		}			
	});
		
	$("txtMemoDate").observe("blur", function(){
		if($F("txtFundCd") == ""){
			customShowMessageBox("Please choose a company first.", imgMessage.INFO, "company");
		} else if ($F("txtBranchCd") == ""){
			customShowMessageBox("Please choose a branch first.", imgMessage.INFO, "txtBranch");
		}else {
			var now = new Date().format("mm-dd-yyyy");
			if($F("txtMemoDate") != now){
				getClosedTag();	
			}			
		}
		
	});
	
	
	
	/** Observes the CANCEL button */
	/*$("btnCancel").observe("click", function(){
		//goToModule("/GIISUserController?action=goToAccounting", "Accounting Main" , null);
		showCreditDebitMemoPage(cancelFlag);
	});*/
	
	/** Observes the SAVE button */
	$("btnSave").observe("click", function(){
		proceedSaveMemo();
	});
	
	/** Observes the Print CM/DM or Cancel CM/DM button */
	$("btnPrintCMDM").observe("click", function(){
		//when-button-pressed trigger dummy_button
		if(memoInfo.allowPrintForOpenCMDMTag != "Y" || memoInfo.allowPrintForOpenCMDMTag == null){ 
			if(memoInfo.tranFlag != "C"){ // checks if transaction is closed.
				showMessageBox("Please close transaction first.", imgMessage.INFO);
				return;		//added by Gzelle 07242014
			}
		}
		
		if(cancelFlag != "Y"){
			// PRINT OPTION
			if(memoInfo.allowPrintForOpenCMDMTag != "Y" || memoInfo.allowPrintForOpenCMDMTag == "" || memoInfo.allowPrintForOpenCMDMTag == null){
				if(memoInfo.tranFlag != "C"){	//modified by Gzelle 07242014
					showMessageBox("Please close transaction first.", imgMessage.INFO);
					return;
				}
			} 
			
			if($F("txtMemoStatus") == "C"){
				showMessageBox("This facility is not allowed for cancelled memo.", imgMessage.INFO);
			} else {
				showGenericPrintDialog("Print Credit/Debit Memo", 
										function (){ /* print func here */
											printMemo(); 			// function to call and print the report.
											updateMemoStatus();		//if the report  has been successfully printed, call this function to update the status of the memo from "U" (unprinted) to "P" (printed)
										}, 
										"" /* onLoad func here */, 
										true);
			}
		} else { 
			// CANCEL OPTION
			//when-button-pressed dummy_button
			if(memoInfo.allowCancelTranForClosedMonthTag == "N" && memoInfo.closedTag == "Y"){
				showMessageBox("You are no longer allowed to cancel this transaction. The transaction month is already closed.", imgMessage.INFO);
			} else if(memoInfo.allowCancelTranForClosedMonthTag == "N" && memoInfo.closedTag == "T") {
				showMessageBox("You are no longer allowed to cancel this transaction. The transaction month is temporarily closed.", imgMessage.INFO);
			} else {
				//cancel_opt
				cancelOption();
			}
		}
	});
	
	function updateGlobalVars(){
		objACGlobal.calledForm = "";
		objACGlobal.gaccTranId = $F("hidGaccTranId");
		objACGlobal.giopGaccTranId = $F("hidGaccTranId");
		objACGlobal.fundCd = $F("txtFundCd");
		objACGlobal.branchCd = $F("txtBranchCd");
		objACGlobal.tranFlagState = $F("hidTranFlag");
		objAC.tranFlagState = $F("hidTranFlag");
		// parameter.formcall := 'GIACS004';
		parameterFormCall = "GIACS004";
		
		objACGlobal.withPdc = "N"; //$("withPdc").value == "" ? 'N' : 'Y';
		objACGlobal.documentName = "";
		objACGlobal.implSwParam = "Y"; //$F("implSwParam");
		
		objGIAC071.cancelFlag = cancelFlag; //added 04.08.2013
		//objGIAC071.callingForm = "GIACS071";
		objACGlobal.previousModule = "GIACS071";
		objGIAC071.memoNumber = $F("txtMemoType") + "-" + $F("txtMemoYear") +"-"+$F("txtMemoSeqNo");
		objGIAC071.memoTranNumber = $F("txtMemoYear") + "-" + new Date.parse($F("txtMemoDate"), "mm-dd-yyyy").format("mm");
		objGIAC071.memoStatus = $F("txtMeanMemoStatus");
		objGIAC071.memoDate = $F("txtMemoDate");
		objGIAC071.memoLocalAmt = $F("txtLocalAmount");
		objGIAC071.memoLocalCurrency = $F("txtLocalCurrSname");
		objGIAC071.memoForeignAmt = $F("txtForeignAmount");
		objGIAC071.memoForeignCurrency = $F("txtDspFshortName");
		objGIAC071.memoRecipient = escapeHTML2($F("txtRecipient"));		
	}
	
	$("btnAccountingEntries").observe("click", function(){
		if(($F("hidGaccTranId") == "" || objACGlobal.gaccTranId == null) && ($F("company") != "" || $F("txtBranch") != "" || $F("txtRecipient") != "")){
			changeTag = 1;
		}
		if(changeTag == 0 && ($F("hidGaccTranId") == "" || objACGlobal.gaccTranId == null)){
				showMessageBox("Please create a CM/DM transaction first.", imgMessage.ERROR);			
		} else {
			var  parameterFormCall = "";
			
			/* Set global variables */	
			if($F("txtMemoType") == "CM" || $F("txtMemoType") == "DM" || $F("txtMemoType") == "RCM"){
				objACGlobal.tranSource = $F("txtMemoType");
			}
			
			objACGlobal.callingForm = "ACCT_ENTRIES";			
			updateGlobalVars();			
			checkFormStat(parameterFormCall);
		}		
	});
	
	$("btnDetails").observe("click", function(){
		if(($F("hidGaccTranId") == "" || objACGlobal.gaccTranId == null) && ($F("company") != "" || $F("txtBranch") != "" || $F("txtRecipient") != "")){
			changeTag = 1;
		}
		if(changeTag == 0 && ($F("hidGaccTranId") == "" || objACGlobal.gaccTranId == null)){
			showMessageBox("Please create a CM/DM transaction first.", imgMessage.ERROR);
		} else {
			var  parameterFormCall = "";
			
			/* Set global variables */	
			if($F("txtMemoType") == "CM" || $F("txtMemoType") == "DM" || $F("txtMemoType") == "RCM"){
				objACGlobal.tranSource = $F("txtMemoType");
			}
			
			objACGlobal.callingForm = "DETAILS";
			updateGlobalVars();
			checkFormStat(parameterFormCall);	
		}		
	});
	
	/** The RELOAD FORM link in the inner div */
	observeReloadForm("reloadForm", function(){
		if($F("hidGaccTranId") == "" || objACGlobal.gaccTranId == ""){
			showMemoPage(); //showAddCreditDebitMemoPage('N');
		} else {
			updateMemoInformation(cancelFlag, $F("txtBranchCd"), $F("txtFundCd"));
		}		
	});
	
	observeCancelForm("btnCancel", 
						function() {
							proceedSaveMemo(); 
							if(objAC.fromMenu == "menuAddCreditDebitMemo"){
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							} else if(objAC.fromMenu == "tblAddCreditDebitMemo"){
								objAC.fromMenu = "menuCreditDebitMemo";
								showMemoPage();
							} else {
								showMemoPage();
							}
						}, 
						function() {
							if(objAC.fromMenu == "menuAddCreditDebitMemo"){
								goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
							} else if(objAC.fromMenu == "tblAddCreditDebitMemo"){
								objAC.fromMenu = "menuCreditDebitMemo";
								showMemoPage();
							} else {
								showMemoPage();
							}
						}
	);
	
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	initializeChangeTagBehavior(proceedSaveMemo);
	initializeChangeAttribute();

	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		$("btnCancel").click();
	});	
</script>