<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Bill Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="billInfoMainDiv" name="billInfoMainDiv" style="border:none;">
	<div style="border:1px solid #E0E0E0;">
		<div id="billInfo" name="billInfo" style="margin: 10px;">
			<table align="center" border="0">
				<tr>
					<td>Bill Number</td>
					<td class="leftAligned">
						<div id="issCdDiv" class="required" style="margin-left: 1px; border: 1px solid gray; width: 70px; height: 19px;">
							<input type="text" class="allCaps required" style="width: 46px; height: 12px; border:none; margin:0px; padding:3px 2px;" id="txtIssCd" name="txtIssCd" value="" lastValidValue="" maxlength="2"/>
							<img id="imgSearchIssCd" name="imgSearchIssCd" alt="Go" src="/Geniisys/images/misc/searchIcon.png" style="float: right;">
						</div>
					</td>
					<td class="rightAligned">
						<div id="issCdDiv" class="required" style="margin-left: 1px; border: 1px solid gray; width: 174px; height: 19px;">
							<input type="hidden" id="hidPolicyId" name="hidPolicyId"/>
							<input type="hidden" id="hidPremAmt" name="hidPremAmt"/>
							<input type="text" class="integerNoNegativeUnformatted required" style="width: 150px; text-align: right; height: 12px; border:none; margin:0px; padding:3px 2px;" id="txtPremSeqNo" name="txtPremSeqNo" value="" lastValidValue="" maxlength="12"/>
							<img id="imgSearchBillNo" name="imgSearchBillNo" alt="Go" src="/Geniisys/images/misc/searchIcon.png" style="float: right;">
						</div>
					
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div style="border:1px solid #E0E0E0; margin-top:1px;">
		<div id="billInfo" name="billInfo" style="margin: 10px;">
			<input type="hidden" id="hidAssdNo" name="hidAssdNo"/>
			<input type="hidden" id="hidLineCd" name="hidLineCd"/>
			<input type="hidden" id="hidSublineCd" name="hidSublineCd"/>
			<input type="hidden" id="hidCommAmt" name="hidCommAmt"/>
			<table align="center" border="0">
				<tr>
					<td class="rightAligned" style="width:110px;">Policy / Endt No.</td>
					<td class="leftAligned" style="width:400px;"><input type="text" style="width:340px;" id="txtDspPolicyNo" name="txtDspPolicyNo" readonly="readonly" value=""/></td>
					<td class="rightAligned" style="width:70px;">Tran. No.</td>
					<td class="rightAligned" style="width:110px;"><input type="text" style="width: 100px; text-align: right;" id="txtTranNo" name="txtTranNo" readonly="readonly" value=""/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned" colspan="3">
						<div><input type="text" style="width: 600px;" id="txtDspAssdName" name="txtDspAssdName" readonly="readonly" value=""/></div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Status</td>
					<td class="leftAligned" style="width:30px;" colspan="3">
						<table style="border-collapse:collapse;">
							<tr>
								<td>
									<input type="text" style="width: 180px;" id="txtDspTranFlag" name="txtDspTranFlag" readonly="readonly" value=""/>
								</td>
								<td class="rightAligned" style="width:240px;">Date</td>
								<td class="leftAligned" style="width:200px;">
									<input type="text" style="width: 195px;" id="txtTranDate" name="txtTranDate" readonly="readonly" value=""/>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
		<div id="buttonsDiv" style="margin-bottom:15px;" align="center">
			<input type="button" id="btnPostBill" name="btnPostBill"  style="width: 140px;" class="button hover"   value="Post Changes" />
			<input type="button" id="btnCancelBill" name="btnCancelBill"  style="width: 140px;" class="button hover"   value="Cancel" />
			<input type="button" id="btnPrintReport" name="btnPrintReport"  style="width: 140px;" class="button hover"   value="Print Report" />
		</div>
	</div>
</div>
<script>
	objACGlobal.objGIACS408 = {};
	objACGlobal.objGIACS408.fundCd = '${fundCd}';
	objACGlobal.objGIACS408.branchCd = '${branchCd}';
	objACGlobal.objGIACS408.ORA2010SW = '${ORA2010SW}' == '' ? 'N': '${ORA2010SW}';
	objACGlobal.objGIACS408.commPaid = 'N';
	objACGlobal.objGIACS408.icChangeTag = 0;
	objACGlobal.objGIACS408.piChangeTag = 0;
	changeTag = 0;
	changeTagFunc = "";
	objACGlobal.objGIACS408.nbtShowAll = 'N';
	objACGlobal.objGIACS408.posted = 'N';
	objACGlobal.objGIACS408.cancelTag = 'N';
	
	//added by steven 10.17.2014
	$("txtPremSeqNo").readOnly = true;
	disableSearch("imgSearchBillNo");
	
	if(nvl(objACGlobal.objGIACS408.fundCd,'') == ''){
		showWaitingMessageBox('Global parameter P_FUND_CD is null. Cannot continue with module.','I', function() {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		});
	}
	if(nvl(objACGlobal.objGIACS408.branchCd,'') == ''){
		showWaitingMessageBox('Global parameter P_BRANCH_CD is null. Cannot continue with module.','I', function () {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		});
		
	}
	
	$("btnPostBill").observe("click", function() {
		/* if(selectedRecord == null){ //koks
			showMessageBox("Please select record first.", "I");
			return false;
		} */
		if(changeTag == 1){
			showMessageBox("Please save changes before posting.", "I");
		}else{
			postInvoiceCommission();
		}
	});
	
	$("btnCancelBill").observe("click", function() {
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", "I");
		}else{
			//objACGlobal.objGIACS408.updateCancelledInvoice();
			cancelInvoiceCommission();
		}
	});
	
	$("btnPrintReport").observe("click", function() {
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", "I");
		}else{
			onOkPrint();
		}
	});
	
	$("btnToolbarPrint").observe("click", function() {
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", "I");
		}else{
			onOkPrint();
		}
	});
	
	$("imgSearchIssCd").observe("click", showGIACS408IssCdLOV);
	
	$("txtIssCd").observe("change", function(){
		if($F("txtIssCd").trim() == "") {
			$("txtIssCd").value = "";
			$("txtPremSeqNo").clear();
			$("hidPolicyId").clear();
			$("hidPremAmt").clear();
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtPremSeqNo").readOnly = true;
			disableSearch("imgSearchBillNo");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtIssCd").trim() != "" && $F("txtIssCd") != $("txtIssCd").readAttribute("lastValidValue")) {
				showGIACS408IssCdLOV();
			}
		}
	});
	
	
	$("imgSearchBillNo").observe("click", showGIACSBillNoLOV);
	
	$("txtPremSeqNo").observe("change", function(){
		if($F("txtPremSeqNo").trim() == "") {
			$("txtPremSeqNo").clear();
			$("hidPolicyId").clear();
			$("hidPremAmt").clear();
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtPremSeqNo").trim() != "" && $F("txtPremSeqNo") != $("txtPremSeqNo").readAttribute("lastValidValue")) {
				showGIACSBillNoLOV();
			}
		}
	});
	
	//added by steven 10.17.2014
	function showGIACS408IssCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS408IssCdLOV",
				filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
				page : 1
			},
			title: "List of Issuing Sources",
			width: 400,
			height: 400,
			columnModel : [
			               {
			            	   id : "issCd",
			            	   title: "Issue Code",
			            	   width: "350px",
			            	   align: "left"
			               }
			              ],
            autoSelectOneRecord: true,
			filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
			onSelect: function(row) {
				$("txtIssCd").value = unescapeHTML2(row.issCd);
				$("txtPremSeqNo").clear();
				$("hidPolicyId").clear();
				$("hidPremAmt").clear();
				$("txtIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
				$("txtPremSeqNo").setAttribute("lastValidValue", "");
				enableToolbarButton("btnToolbarEnterQuery");
				$("txtPremSeqNo").readOnly = false;
				enableSearch("imgSearchBillNo");
				$("txtPremSeqNo").focus();
			},
			onCancel: function (){
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function showGIACSBillNoLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS408BillNoLOV",
				issCd: $F("txtIssCd"),
				filterText : ($("txtPremSeqNo").readAttribute("lastValidValue").trim() != $F("txtPremSeqNo").trim() ? $F("txtPremSeqNo").trim() : ""),
				page : 1
			},
			title: "List of Invoice Numbers",
			width: 400,
			height: 400,
			columnModel : [
			               {
			            	   id : "issCd",
			            	   title: "Issue Code",
			            	   width: "150px",
			            	   align: "left"
			               },
			               {
			            	   id : "premSeqNo",
			            	   title: "Premium Seq No",
			            	   width: "200px",
			            	   align: "right"
			               }
			              ],
			autoSelectOneRecord: true,
			filterText : ($("txtPremSeqNo").readAttribute("lastValidValue").trim() != $F("txtPremSeqNo").trim() ? $F("txtPremSeqNo").trim() : ""),
			onSelect: function(row) {
				$("txtPremSeqNo").value = row.premSeqNo;
				$("hidPolicyId").value = row.policyId;
				$("hidPremAmt").value = row.premAmt;
				$("txtPremSeqNo").setAttribute("lastValidValue", row.premSeqNo);
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onCancel: function (){
				$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	/* B140 POST-QUERY  */
	function populateBillInformationDtls(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController", {
				parameters:{
					action: "populateBillInformationDtls",
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					policyId: $F("hidPolicyId")
				},
				asynchronous: false,
				evalscripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						$("txtDspPolicyNo").value = json.policyNo;
						$("txtDspAssdName").value = unescapeHTML2(json.assdName);
						$("hidLineCd").value = json.lineCd;
						$("hidSublineCd").value = json.sublineCd;
						$("hidAssdNo").value = json.assdNo;
						$("hidCommAmt").value = json.commAmt;
						$("txtTranNo").value = json.tranNo;
						$("txtTranDate").value = json.tranDate;
						$("txtDspTranFlag").value = json.dspTranFlag;
						
						if($F("hidCommAmt") != 0){
							objACGlobal.objGIACS408.commPaid = 'Y';
							disableButton("btnRecomputeCommRt");
							disableButton("btnRecomputeWithTax");
							$("txtSharePercentage").setAttribute("readonly", "readonly");
							$("txtPerilWholdingTax").setAttribute("readonly", "readonly");
						}else{
							enableButton("btnRecomputeCommRt");
							enableButton("btnRecomputeWithTax");
							$("txtSharePercentage").removeAttribute("readonly");
							//$("txtPerilWholdingTax").removeAttribute("readonly");
						}
						
						disableSearch("imgSearchIssCd");
						disableSearch("imgSearchBillNo");
						$("txtIssCd").readOnly = true;
						$("txtPremSeqNo").readOnly = true;
						
						$("hidBancassuranceSw").value = json.bancaDtlsBtn; 
						if (json.bancaDtlsBtn == "TRUE"){
							enableButton("btnBancAssrnceDtls");
						}else{
							disableButton("btnBancAssrnceDtls");
						}
					}	
				}
			});	
		}catch(e){
			showErrorMessage("populateBillInformationDtls", e);
		}
	}
	objACGlobal.objGIACS408.populateBillInformationDtls = populateBillInformationDtls;
	
	function validateBillNo(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=giacs408ValidateBillNo", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var json = JSON.parse(response.responseText);
					if(nvl(json.row,null) == null){
						showWaitingMessageBox("Query caused no records to be retrieved. Re-enter.", "I", function(){
							$("txtIssCd").value = "";
							$("txtPremSeqNo").value = "";
							$("hidPolicyId").value = "";
							$("hidPremAmt").value = "";
							$("txtIssCd").focus();
							$("txtPremSeqNo").setAttribute("lastValidValue", "");
							$("txtIssCd").setAttribute("lastValidValue", "");
							$("txtPremSeqNo").readOnly = true;
							disableSearch("imgSearchBillNo");
							disableToolbarButton("btnToolbarEnterQuery");
							disableToolbarButton("btnToolbarExecuteQuery");
						});
					}else{
						$("hidPolicyId").value = json.row.policyId;
						$("hidPremAmt").value = json.row.premAmt;
						objACGlobal.objGIACS408.checkBillNoOnSelect();
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBillNo", e);
		}
	}
	objACGlobal.objGIACS408.validateBillNo = validateBillNo;
	
	function execute(){
		executeChangeTag = 1;
		if(objACGlobal.objGIACS408.posted=="Y"){
			objACGlobal.objGIACS408.populateBillInformationDtls();
			objACGlobal.objGIACS408.executeQueryInvCommInfo();
			//objACGlobal.objGIACS408.populateInvoiceCommPeril();
		}else{
			objACGlobal.objGIACS408.populateInvoiceCommPeril();
			objACGlobal.objGIACS408.populateBillInformationDtls();			
			objACGlobal.objGIACS408.executeQueryInvCommInfo();
			disableToolbarButton("btnToolbarExecuteQuery");
			enableButton("btnSave");
		}
	}
	
	function checkBillNoOnSelect(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=giacs408ChkBillNoOnSelect", {
				method: "POST",
				parameters: {
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var json = JSON.parse(response.responseText);
					if(json.polFlag == 4){
						showConfirmBox3("CONFIRMATION", "This is a cancelled policy. Would you still like to continue making changes to the commission?"
								, "Yes", "No", function() {
												return true;
											}, function() {
												showModifyCommInvoicePage();
												return false;
								});
					}else if(json.polFlag == 5){
						showMessageBox("The policy for this bill no. is already spoiled.", "E");
						showModifyCommInvoicePage();
						return false;
					}
					
					if(json.premAmt == 0){
						if(json.exist == 0){
							showMessageBox("Premium amount is zero. Please select another Bill.", "E");
							showModifyCommInvoicePage();
							return false;
						}
					}
					
					if(json.commAmt != 0){
						showMessageBox("Commission payment transaction(s) already exists for this invoice.", "I");
					}
					execute();
				}
			});
		}catch(e){
			showErrorMessage("checkBillNoOnSelect", e);
		}
	}
	objACGlobal.objGIACS408.checkBillNoOnSelect = checkBillNoOnSelect;
	
	function cancelInvoiceCommission(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=cancelInvoiceCommission", {
				method: "POST",
				parameters: {
					commRecId: $F("hidInvCommRecId"),
					fundCd: objACGlobal.objGIACS408.fundCd,
					branchCd: objACGlobal.objGIACS408.branchCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							$("txtTranDate").value = Date.now().format("mm-dd-yyyy HH:MM:ss TT");
							$("txtDspTranFlag").value = "CANCELLED";
							showMessageBox("Bill No. " + $F("txtIssCd") + " - " +  $F("txtPremSeqNo") +" has been CANCELLED.", "I");
							objACGlobal.objGIACS408.updateCancelledInvoice();
							changeTag = 0;
							changeTagFunc = "";
							objACGlobal.objGIACS408.cancelTag = "Y";
							disableButton("btnSave");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("cancelInvoiceCommission", e);
		}
	}
	
	function postInvoiceCommission(){
		try{
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController?action=postInvoiceCommission", {
				method: "POST",
				parameters: {
					fundCd: objACGlobal.objGIACS408.fundCd,
					branchCd: objACGlobal.objGIACS408.branchCd,
					issCd: $F("txtIssCd"),
					premSeqNo: $F("txtPremSeqNo"),
					commRecId: $F("hidInvCommRecId"),
					intmNo: $F("hidInvIntmNo") //added by steven 10.15.2014
					
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Posting changes..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						$("txtTranDate").value = Date.now().format("mm-dd-yyyy HH:MM:ss TT");
						$("txtDspTranFlag").value = "POSTED";
						objACGlobal.objGIACS408.updatePostedInvoice();
						showWaitingMessageBox(response.responseText, "I", confirmPrint);
					}
					/* if(checkErrorOnResponse(response)){
						showWaitingMessageBox(response.responseText, "I", confirmPrint);
						objACGlobal.objGIACS408.posted="Y";
						objACGlobal.objGIACS408.updatePostedInvoice(); //update Invoice TG
						//objACGlobal.objGIACS408.validateBillNo(); //refresh
					} */
				}
			});
		}catch(e){
			showErrorMessage("postInvoiceCommission", e);
		}
	}
	
	function confirmPrint(){
		showConfirmBox("", "Do you want to Print the Bill?", "OK", "Cancel", onOkPrint, "", "");
	}

	function onOkPrint(){
		showGenericPrintDialog("Commission Modification Report", function(){
				var content = contextPath + "/GeneralDisbursementPrintController?action=printGIACR408&reportId=GIACR408"
								+"&commRecId="+$F("hidInvCommRecId")
								+"&premSeqNo="+$F("txtPremSeqNo")
								+"&issCd="+$F("txtIssCd")
								+"&fundCd="+objACGlobal.objGIACS408.fundCd
								+"&branchCd="+objACGlobal.objGIACS408.branchCd;
				printGenericReport(content, "Commission Modification Report");
			});
	}
	
	observeAccessibleModule(accessType.BUTTON, "GIACS408", "btnPrintReport", "");
</script>