<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="float: left;" id="directClaimPaymentsDiv" name="directClaimPaymentsDiv">
	<div class="sectionDiv" style=" border-top: none;">
		<div id="directClaimPaytsTGDiv" class="sectionDiv" style="border: none; margin-bottom: 10px;">
			<div id="dcpTableGridDiv" style="padding: 10px;">
				<div id="dcpTableGrid" style="height: 230px; width: 900px;"></div>
			</div>
			<div style="float: right; margin-right: 12px; margin-top: 10px;">
				<input type="hidden" id="sumDisbAmt" name="sumDisbAmt" value="" />
				<input type="hidden" id="sumInputVat" name="sumInputVat" value="" />
				<input type="hidden" id="sumWHolding" name="sumWHolding" value="" />
				<input type="text" id="sumDspNetAmt" name="sumDspNetAmt" value="" class="money" style="width: 135px; " />
			</div>
		</div>
	
		<table style="margin-top: 10px; margin-bottom:10px; margin-left: 7%;">
			<tbody>
				<tr>
					<td class="rightAligned" style="width: 128px;">Transaction Type</td>
					<td class="leftAligned" style="width: 215px;" >
						<select style="width: 215px;" id="selTransactionType" name="selTransactionType" title="Transaction Type" class="required">
							<option></option>
							<c:forEach var="transLov" items="${transactionTypeLOV}" >
								<option value="${transLov.rvLowValue}">${transLov.rvLowValue} - ${transLov.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width: 150px;">Claim No.</td>
					<td style="width: 240px;" class="leftAligned">
						<input type="text" id="txtClaimNumber" name="txtClaimNumber" title="Claim Number" readonly="readonly" style="width: 230px;" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Advice No</td>
					<td class="leftAligned">
						<!-- <div> -->
							<input type="text" id="txtLineCd" name="adviceNo" class="required allCaps" style="width: 35px;" maxlength="2" value="" />
							<input type="text" id="txtIssCd" name="adviceNo" class="required allCaps" style="width: 35px;" maxlength="2" value="" />
							<input type="text" id="txtAdviceYear" name="adviceNo" class="required integerNoNegativeUnformattedNoComma" style="width: 35px;" maxlength="5" value="" />
							<input type="text" id="txtAdvSeqNo" name="adviceNo" class="required integerNoNegativeUnformattedNoComma" style="width: 40px;" maxlength="6" value="" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 15px; height: 15px;" id="searchAdvice2" />	<!-- remove alt='Go' to prevent adding style shan 10.30.2013 -->
						<!-- </div> -->
					</td>
					<td class="rightAligned" style="">Policy No.</td>
					<td class="leftAligned">
						<input type="text" 	id="txtPolicyNumber" name="txtPolicyNumber" title="Policy Number" readonly="readonly" style="width: 230px;" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Payee Class</td>
					<td style="width: 210px;" class="leftAligned">
						<input type="hidden" id="tempPolicyNo" 	name="tempPolicyNo"	value="${policyNumber}"/>
						<input type="hidden" id="tempClaimNo" 	name="tempClaimNo" 	value="${claimNumber}"/>
						<input type="hidden" id="temp"	name="temp"	value="${Name}"/>
						
						<input type="hidden" id="payeeType" name="payeeType" value="" />
						<input type="hidden" id="payeeClassCd" name="payeeClassCd" value="" />
						<input type="hidden" id="claimLossId" name="claimLossId" value="" />
						<input type="hidden" id="selectedPayee" name="selectedPayee" value="" />
						<input type="hidden" id="payeeCode" name="payeeCode" value="" />
						<div id="payeeClassDiv" style="border: 1px solid gray; width: 214px; height: 22px; float: left; background-color: #FFFACD;">
							<input type="text" id="selPayeeClass2" name="selPayeeClass2" readonly="readonly" class="required" style="border: none; width: 188px; height: 12px;" /><!-- decrease width by reymon 04242013; added height by shan 10.30.2012 -->
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="width: 15px; height: 15px;" alt="Go" id="searchPayee" hidden="hidden"/>
						</div>
					</td>
					<td class="rightAligned">Payee</td>
					<td class="leftAligned">
						<input type="text" id="txtPayee" name="txtPayee" title="Payee" readonly="readonly" style="width: 230px;" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Peril</td>
					<td class="leftAligned">
						<input type="text" id="txtPeril" name="txtPeril" class="required" readonly="readonly" title="Peril" value="" style="width: 207px;">
					</td>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned">
						<input type="text" id="txtAssuredName" name="txtAssuredName" title="Assured Name" readonly="readonly" style="width: 230px;" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Disbursement Amount</td>
					<td class="leftAligned">
						<input type="text" id="txtDisbursementAmount" 	name="txtDisbursementAmount" title="Disbursement Amount" class="money required" readonly="readonly" style="width: 207px;" value="0"/>
					</td>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 236px;">
							<textarea onKeyDown="limitText(this,4000); ojbGlobalTextArea.origValue = this.value;" onKeyUp="limitText(this,4000); ojbGlobalTextArea.origValue = this.value;" title="Remarks" 
										style="width: 210px; border: none; height: 13px;" id="txtRemarks" name="txtRemarks"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Input Tax</td>
					<td class="leftAligned">
						<input type="text" id="txtInputTax" name="txtInputTax" title="Input Tax" readonly="readonly" style="width: 207px;" class="money" value="0"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Withholding Tax</td>
					<td class="leftAligned">
						<input type="text" style="width: 207px;" id="txtWithholdingTax" title="Withholding Tax" readonly="readonly" name="txtWithholdingTax" class="money" value="0"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Net Disbursement</td>
					<td class="leftAligned">
						<input type="text" style="width: 207px;" id="txtNetDisbursement" name="txtNetDisbursement" title="Net Disbursement" class="money required" readonly="readonly" value="0"/>
					</td>
				</tr>
			</tbody>
		</table>
		<div id="directClaimButtonsDiv" style=" margin-left: 210px; margin-bottom: 20px;" align="left">
			<input type="button" id="btnClaimAdvice" class="disabledButton" value="Claim Advice" />
			<input type="button" id="btnBatchClaim" class="disabledButton" value="Batch Claim Settlement" />
			<input type="button" id="btnForeignCurrDcp" class="button" value="Foreign Currency"/>
			<input type="button" id="btnAddDCP" class="button" value="Add"/>
			<input type="button" id="btnDelDCP" class="button" value="Delete"/>
		</div>
		
			<div id="directClaimCurrencyDiv" style="display: none;">
				<table border="0" align="center" style="margin:10px auto;">
					<tr>
						<td class="rightAligned" style="width: 123px;">Currency Code</td>
						<td class="leftAligned"  >
							<!-- <input type="text" style="width: 50px; text-align: left" id="dcpCurrencyCode" name="dcpCurrencyCode" value="" class="required integerNoNegativeUnformattedNoComma deleteInvalidInput" 
							errorMsg="Entered currency code is invalid. Valid value is from 1 to 99." maxlength="2"/> -->
							<select style="width: 215px;" id="selCurrency" name="selCurrency" class="required">
								<option></option>
								<c:forEach var="currLOV" items="${currencyCodesLOV}" >
									<option value="${currLOV.code}" rate="${currLOV.valueFloat}">${currLOV.desc}</option>
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width: 180px;">Convert Rate</td>
						<td class="leftAligned"  >
							<input type="text" style="width: 100px; text-align: right" class="moneyRate required" readonly="readonly" id="dcpConvertRate" name="dcpConvertRate" selectedConvertRate="" value="" maxlength="13"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Currency Description</td>
						<td class="leftAligned"  >
							<input type="text" style="width: 170px; text-align: left" id="dcpCurrencyDesc" name="dcpCurrencyDesc" value="" readonly="readonly"/></td>
						<td class="rightAligned" >Foreign Currency Amount</td>
						<td class="leftAligned"  >
							<input type="text" style="width: 170px; text-align: right" class="money required" id="dcpForeignCurrencyAmt" name="dcpForeignCurrencyAmt" value="" maxlength="18" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td width="100%" style="text-align: center;" colspan="4">
							<input type="button" style="width: 80px;" id="btnHideDcpCurrencyDiv" class="button" value="Return"/>
						</td>
					</tr>
				</table>
			</div>
		</div>	
	<div id="directClaimMainButton" name="directClaimMainButton" style="" class="buttonsDiv">		
		<input type="button" id="btnDirectClaimCancel" class="button" value="Cancel"/>
		<input type="button" id="btnDirectClaimSave" class="button" value="Save" style="font-family: Arial;"/>
	</div>	
</div>

<input type="hidden" id="claimIdAC017" name="claimIdAC017" value=""/>
<input type="hidden" id="adviceIdAC017" name="adviceIdAC017" value=""/>
<input type="hidden" id="lineCdAC017" name="lineCdAC017" value=""/>
<input type="hidden" id="issCdAC017" name="issCdAC017" value=""/>
<input type="hidden" id="yearAC017" name="yearAC017" value=""/>
<input type="hidden" id="sequenceAC017" name="sequenceAC017" value=""/>
<input type="hidden" id="varIssCd" name="varIssCd" value=""/>
<input type="hidden" id="batchCsrId" name="batchCsrId" value=""/>

<div id="dcpAmountsDiv" name="dcpAmountsDiv">
	<input type="hidden" id="hidInputVatAmount" name="hidInputVatAmount" value="0" />
	<input type="hidden" id="hidWithholdingTaxAmount" name="hidWithholdingTaxAmount" value="0"/>
	<input type="hidden" id="hidNetDisbursementAmount" name="hidNetDisbursementAmount" value="0"/>
	
	<input type="hidden" id="totalNetDisbursementAmount" name="totalNetDisbursementAmount" value="0"/>
	<input type="hidden" id="totalInputVatAmount" name="totalInputVatAmount" value="0"/>
	<input type="hidden" id="totalWithholdingTaxAmount" name="totalWithholdingTaxAmount" value="0"/>
</div>

<script type="text/javascript">
	setModuleId("GIACS017");
	setDocumentTitle("Direct Trans - Direct Claim Payts");
	
	var gdcpObj = {};
	var selectedGDCPObj = null;
	var selectedGDCPIndex = null;
	var enableLOVs = true;
	disableButton("btnDelDCP");
	
	var giacs017Vars = JSON.parse('${vars}');
	//added condition checking if objAC.tranFlagState is empty by robert 11.28.2013
	if ((!isEmpty(objAC.tranFlagState) && objAC.tranFlagState != 'O') || objACGlobal.orStatus == "CANCELLED"
			|| objAC.butLabel == "Cancel OR"  || (objACGlobal.orFlag == "P" && nvl(objAC.tranFlagState, "") != "O") || objAC.tranFlagState == "C"){	// added objACGlobal.orFlag by shan 12.16.2013	
		//showMessageBox("Form running in query-only mode. Cannot change database fields.");
		disableButton("btnDirectClaimSave");
		disableButton("btnAddDCP");
		disableButton("btnDelDCP");
		$("selTransactionType").disable();
		disableSearch("searchAdvice2");
		//disableSearch("searchPayee");
		$$("div#directClaimPaymentsDiv input[type='text']").each(function(row) {
			row.readonly = true;
		});
	}
	
	function computeNetSum(action) {
		try {
			var currentTotal = unformatCurrency("sumDspNetAmt");
			var newAmt = unformatCurrency("txtNetDisbursement");
			var newTotal = 0;
			if(action == "delete") {
				newTotal = currentTotal - newAmt;
			} else if (action == "add") {
				newTotal = currentTotal + newAmt;
			} else if (action == "update") {
				var oldNetAmt = parseFloat(nvl(unformatNumber(gdcpGrid.geniisysRows[selectedGDCPIndex].netDisbursementAmount), "0"));
				newTotal = currentTotal - oldNetAmt + newAmt;
			}
			
			$("sumDspNetAmt").value = formatCurrency(newTotal);
		} catch(e) {
			showErrorMessage("computeNetSum", e);
		}
	}
	
	function enableDisableGDCPInputs() {
		if($F("btnAddDCP")=="Add") {
			disableButton("btnDelDCP");
			/* enableButton("btnClaimAdvice");
			enableButton("btnBatchClaim"); */
			disableButton("btnClaimAdvice");//added by reymon 04252013
			disableButton("btnBatchClaim");//added by reymon 04252013
			
			$$("div#directClaimPaymentsDiv input[name='adviceNo']").each(function(input) {
				input.removeAttribute("readonly");
			});
			
			$$("div#directClaimPaymentsDiv select").each(function(select) {
				select.enable();
			});
			
			$$("div#directClaimPaymentsDiv img").each(function(img) {
				img.setStyle("visibility: visible");
			});
		} else {
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR")  && objAC.tranFlagState != "C" && objAC.paytReqFlag != "C"){ // andrew - 08.15.2012 SR 0010292 //koks 11.15.13 SR QA-1210
				enableButton("btnDelDCP");
			}
			disableButton("btnClaimAdvice");
			disableButton("btnBatchClaim");
			
			$$("div#directClaimPaymentsDiv input[type='text']").each(function(input) {
				input.setAttribute("readonly", "readonly");
			});
			
			$$("div#directClaimPaymentsDiv select").each(function(select) {
				select.disable();
			});
			
			$$("div#directClaimPaymentsDiv img").each(function(img) {
				if(img.id != 'editRemarks') // pol - 05.14.2013
					img.setStyle("visibility: hidden");
			});
			
		}
		$("txtRemarks").removeAttribute("readonly");
	}
	
	function prepareDCPObj() {
		try {
			var obj = {};
			
			obj.gaccTranId 				= objACGlobal.gaccTranId;
			obj.transactionType 		= $F("selTransactionType");
			obj.claimId 				= $F("claimIdAC017");
			obj.claimLossId				= $F("claimLossId");
			obj.adviceId				= $F("adviceIdAC017");
			obj.payeeCd					= $F("payeeCode");
			obj.payeeClassCd			= $F("payeeClassCd");
			obj.payeeType				= $F("payeeType");
			obj.disbursementAmount		= unformatCurrency("txtDisbursementAmount");
			obj.currencyCode			= $F("selCurrency");	
			obj.convertRate				= $F("dcpConvertRate");
			obj.foreignCurrencyAmount	= unformatCurrency("dcpForeignCurrencyAmt");
			obj.orPrintTag				= "N";
			obj.remarks					= $F("txtRemarks");
			obj.inputVatAmount			= unformatCurrency("txtInputTax");
			obj.withholdingTaxAmount	= unformatCurrency("txtWithholdingTax");
			obj.netDisbursementAmount	= unformatCurrency("txtNetDisbursement");
			obj.originalCurrencyCode	= "";
			obj.originalCurrencyRate	= "";
			//obj.perilCd					= $F("hidPerilCd");
			
			obj.dspAdviceNo				= $F("txtLineCd")+"-"+$F("txtIssCd")+"-"+
										  $F("txtAdviceYear")+"-"+parseInt($F("txtAdvSeqNo")).toPaddedString(7);
			obj.currencyDesc			= $F("dcpCurrencyDesc");
			obj.dspIssCd				= $F("txtIssCd");
			obj.dspLineCd				= $F("txtLineCd");
			obj.dspAdviceYear			= $F("txtAdviceYear");
			obj.dspAdviceSeqNo			= $F("txtAdvSeqNo");
			obj.dspPayeeDesc			= $F("selPayeeClass2");
			obj.dspPerilName			= $F("txtPeril");
			obj.dspPayeeName			= $F("txtPayee");
			/* obj.dspLineCd2
			obj.dspSublineCd
			obj.dspIssCd3
			obj.dspPolSeqNo
			obj.dspRenewNo
			obj.dspIssCd2
			obj.dspClmYy
			obj.dspClmSeqNo */
			obj.claimNumber				= $F("txtClaimNumber");
			obj.policyNumber			= $F("txtPolicyNumber");
			obj.dspAssuredName			= $F("txtAssuredName");
			
			return obj;
		} catch(e) {
			showErrorMessage("prepareDCPObj", e);
		}
	}
	
/*	function populateGDCPFields(row) {
		try {
			//$("selTransactionType").selectedIndex = row==null ? 0 : row.transactionType;
			$("selTransactionType").value = row==null ? "" : row.transactionType;
			if(row != null && nvl(row.claimNumber, null) == null) {
				$("txtClaimNumber").value = row.dspLineCd2+" - "+row.dspSublineCd+" - "+row.dspIssCd2+" - "
					+row.dspClmYy+" - "+parseInt(row.dspClmSeqNo).toPaddedString(5);
			} else if(row != null) {
				$("txtClaimNumber").value = row.claimNumber;
			} else {
				$("txtClaimNumber").value = "";
			}
			
			$("txtLineCd").value = row==null ? "" : row.dspLineCd;
			$("txtIssCd").value = row==null ? "" : row.dspIssCd;
			$("txtAdviceYear").value = row==null ? "" : row.dspAdviceYear;
			$("txtAdvSeqNo").value = row==null ? "" : row.dspAdviceSeqNo;
			if(row != null && nvl(row.policyNumber, null) == null) {
				$("txtPolicyNumber").value = row.dspLineCd2+" - "
						+row.dspSublineCd+" - "+row.dspIssCd3+" - "+row.dspIssueYy
						+" - "+parseInt(row.dspPolSeqNo).toPaddedString(7)+
						" - "+parseInt(row.dspRenewNo).toPaddedString(2);
			} else if(row != null){
				$("txtPolicyNumber").value = row.policyNumber;
			} else {
				$("txtPolicyNumber").value = "";
			}
			
			$("selPayeeClass2").value = row==null ? "" : row.dspPayeeDesc;
			$("txtPayee").value = row==null ? "" : row.dspPayeeName;
			$("txtPeril").value = row==null ? "" : row.dspPerilName;
			$("txtAssuredName").value = row==null ? "" : row.dspAssuredName;
			$("txtDisbursementAmount").value = row==null ? "" : formatCurrency(row.disbursementAmount);
			$("txtInputTax").value = row==null ? "" : formatCurrency(row.inputVatAmount);
			$("txtWithholdingTax").value = row==null ? "" : formatCurrency(row.withholdingTaxAmount);
			$("txtNetDisbursement").value = row==null ? "" : formatCurrency(row.netDisbursementAmount);
			$("txtRemarks").value = row==null ? "" : row.remarks;
			
			$("adviceIdAC017").value = row==null ? "" : row.adviceId;
			$("claimIdAC017").value = row==null ? "" : row.claimId;
			$("claimLossId").value = row==null ? "" : row.claimLossId;
			$("payeeClassCd").value = row==null ? "" : row.payeeClassCd;
			$("payeeCode").value = row==null ? "" : row.payeeCd;
			$("payeeType").value = row==null ? "" : row.payeeType;
			
			$("selCurrency").value = row==null ? "" : row.currencyCode;
			$("dcpConvertRate").value = row==null ? "" : row.convertRate;
			$("dcpCurrencyDesc").value = row==null ? "" : row.currencyDesc;
			$("dcpForeignCurrencyAmt").value = row==null ? "" : (row.foreignCurrencyAmount==null ? "0.00" : formatCurrency(row.foreignCurrencyAmount));
			if(row==null) {
				$("btnAddDCP").value = "Add";
			} else {
				$("btnAddDCP").value = "Update";
			}
			enableDisableGDCPInputs();
		} catch(e) {
			showErrorMessage("populateGDCPFields", e);
		}
	}*/
	
	function addModifiedDCP(obj) {
		try {
			var exists = false;
			for(var i=0; i<objDCPArr.length; i++) {
				var dcp = objDCPArr[i];
				if(dcp.transactionType == obj.transactionType
					&& dcp.claimId == obj.claimId && dcp.claimLossId == obj.claimLossId) {
					if(dcp.recordStatus == "0" && obj.recordStatus == "-1") {
						objDCPArr.splice(i, 1, obj);
					} else {
						objDCPArr.splice(i, 1, obj);
					}
					exists = true;
				}
			}
			if(!exists) {
				if(dcp.recordStatus != "0" || dcp.recordStatus != "1" && obj.recordStatus == "-1") {
					objDCPArr.push(obj);
				}
			}
		} catch(e) {
			showErrorMessage("addModifiedDCP", e);
		}
	}
	
	function addDCP() {
		try {
			var newDCP = prepareDCPObj();
			
			if($F("btnAddDCP") == "Add") {
				newDCP.recordStatus = "0";
				computeNetSum("add");
				gdcpGrid.addBottomRow(newDCP);
				//objDCPArr.push(newDCP);
			} else {
				newDCP.recordStatus = "1";
				computeNetSum("update");
				gdcpGrid.updateVisibleRowOnly(newDCP, selectedGDCPIndex);
				addModifiedDCP(newDCP);
				//gdcpGrid.updateRowAt(newDCP, selectedGDCPIndex);
			}
			
			populateGDCPFields(null, false);
			enableDisableGDCPInputs();
			selectedGDCPIndex = null;
			gdcpGrid.releaseKeys();
			changeTag = 1;
		} catch(e) {
			showErrorMessage("addDCP", e);
		}
	}
	
	function saveGDCP() {
		if (changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);//Added by reymon 04242013
		}else{
			if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS017")){ //marco - SR-5721 - 02.13.20167
				return;
			}
			
			try {
				/* var objParams = {};
				//objParams.setRows = gdcpGrid.getNewRowsAdded();
				objParams.setRows = getAddedAndModifiedJSONObjects(objDCPArr); */
				/* var addedRows 	 = gdcpGrid.getNewRowsAdded();
				var delRows 	 = gdcpGrid.getDeletedRows(); 
				var setRows		 = addedRows.concat(gdcpGrid.getModifiedRows());*/
				var setRows 	 = getAddedAndModifiedJSONObjects(objDCPArr);
				var delRows 	 = getDeletedJSONObjects(objDCPArr);
				
				/*
				** Added by reymon 04242013
				** Removed assured and payee name that causes json error during saving
				*/
				var tempObjArray = new Array();
				if(setRows != null){
					for (var i = 0; i<setRows.length; i++){
						setRows[i].dspAssuredName = '';
						setRows[i].dspPayeeName = '';
						setRows[i].remarks = setRows[i].remarks == null || setRows[i].remarks == "" ? "" : setRows[i].remarks.replace(/\"/g, "&#34;");   /* pol - 05.14.2013 lara - 10/21/2013 */
						tempObjArray.push(setRows[i]);
					}
					setRows = tempObjArray;
				}
				
				tempObjArray = new Array();
				if(delRows != null){
					for (var i = 0; i<delRows.length; i++){
						delRows[i].dspAssuredName = '';
						delRows[i].dspPayeeName = '';
						delRows[i].remarks = delRows[i].remarks == null || delRows[i].remarks == "" ? "" : delRows[i].remarks.replace(/\"/g, "&#34;");  /* pol - 05.14.2013 */
						tempObjArray.push(delRows[i]);
					}
					delRows = tempObjArray;
				}
				//end reymon
				
				new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
					method: "POST",
					parameters:{
						action: 	"saveDirectClaimPayments",
						setRows: 	prepareJsonAsParameter(setRows),
					 	delRows: 	prepareJsonAsParameter(delRows),
					 	gaccTranId: objACGlobal.gaccTranId,
					 	branchCd: 	objACGlobal.branchCd,
					 	fundCd:  	objACGlobal.fundCd,
					 	tranSource: objACGlobal.tranSource,
					 	orFlag: 	objACGlobal.orFlag
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							if (response.responseText == "SUCCESS"){
								//showMessageBox(response.responseText, imgMessage.SUCCESS); reymon 04242013
								showWaitingMessageBox("Saving successful.", imgMessage.SUCCESS, function(){	//change from showMessageBox : shan 10.30.2013
									changeTag = 0;
									
									if (lastAction == "" || lastAction == undefined || lastAction == null){	// lastAction located in observeGoToModule function
										showDirectClaimPayments();
									}else{
										lastAction();	// shan 10.30.2013
										lastAction = "";
									}
																
								});
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}
					}
				}); 
			} catch(e) {
				showErrorMessage("saveGDCP", e);
			}
		}
	}
	
	$("btnAddDCP").observe("click", function() {
		if($("selTransactionType").selectedIndex == 0 ){
			showMessageBox("Please select a transaction type.", imgMessage.ERROR);
		}else if($F("selPayeeClass2").blank()) {
			showMessageBox("Please select a payee class.", imgMessage.ERROR);
		}else if($F("txtPeril").blank()){
			showMessageBox("Peril code not entered", imgMessage.ERROR);
		}else if($F("txtDisbursementAmount").blank()){
			showMessageBox("Please enter disbursement amount.", imgMessage.ERROR);
		}else if($F("txtNetDisbursement").blank()){
			showMessageBox("Please enter the net disubursement amount.", imgMessage.ERROR);
		}/* else if($F("selCurrency") == "") {
			showMessageBox("Please select a currency", imgMessage.ERROR);
		} */else{
			addDCP();
		}
	});
	
	$("btnDelDCP").observe("click", function() {
		if(objACGlobal.orFlag == "P" && nvl(objAC.tranFlagState, "") != "O"){
			showMessageBox("Delete not allowed. OR has already been printed.", imgMessage.ERROR);
		}else {
			var delDCP = prepareDCPObj();
			
			a = 0;
			
			for ( var i = 0; i < gdcpGrid.geniisysRows.length; i++) {
				if (gdcpGrid.geniisysRows[i].recordStatus == 0 || gdcpGrid.geniisysRows[i].recordStatus == 1) {
					if(delDCP.claimId == gdcpGrid.geniisysRows[i].claimId && delDCP.adviceId == gdcpGrid.geniisysRows[i].adviceId){
						a = a + 1;
					}
				}
			}
			
			if(a > 1){
				showConfirmBox("Confirmation", "This advice has multiple settlement. All settlement records included in this advice will also be deleted. Do you want to continue?", "Yes", "No",
						function(){
							for ( var i = 0; i < gdcpGrid.geniisysRows.length; i++) {
								if(delDCP.claimId == gdcpGrid.geniisysRows[i].claimId && delDCP.adviceId == gdcpGrid.geniisysRows[i].adviceId ){
									computeNetSum("delete");
									addModifiedDCP(gdcpGrid.geniisysRows[i]);
									gdcpGrid.geniisysRows[i].recordStatus = -1;
									gdcpGrid.deleteVisibleRowOnly(i);
									populateGDCPFields(null, false);
									enableDisableGDCPInputs();
									changeTag = 1;
									changeTagFunc = saveGDCP;	//shan 10.30.2013
								}
							}
						},"");
			} else {
				delDCP.recordStatus = "-1";
				computeNetSum("delete");
				addModifiedDCP(delDCP);
				gdcpGrid.deleteVisibleRowOnly(selectedGDCPIndex);
				populateGDCPFields(null, false);
				enableDisableGDCPInputs();
				changeTag = 1;
				changeTagFunc = saveGDCP;	//shan 10.30.2013
			}
		}
	});
	
	$("btnDirectClaimSave").observe("click", saveGDCP);
	
	$("searchAdvice2").observe("click", function() {
		if($F("selTransactionType")=="") {
			showMessageBox("Please enter a transaction type first.");
			return;
		}
		if(enableLOVs) {
			var notIn = gdcpGrid.createNotInParam("adviceId");
			//var notIn2 = getAdviceLossId(gdcpGrid, 0);
			var lineCd = $F("txtLineCd");	// added by shan 09.08.2014
			
			if (objACGlobal.previousModule == 'GIACS016'){
				lineCd = (lineCd == "" || lineCd == objGIACS002.lineCd ? objGIACS002.lineCd : null);
			}
			
			var notIn2 = getAdviceLossId(gdcpGrid, 0);
			
			showAdvSeqNoLOV(
				$F("selTransactionType"), /*$F("txtLineCd")*/ lineCd, $F("txtIssCd"),
				$F("txtAdviceYear"), $F("txtAdvSeqNo"), giacs017Vars.varIssCd, notIn, notIn2
			);
		}
	});
	
	//created by reymon for showAdvSeqNoLOV 04252013
	function getAdviceLossId2(tableGrid, swtch){
		var arr = tableGrid.getDeletedIds();
		var notIn = "";
		var exist = new Array();
		var adviceIdTemp = "";
		var adviceIdTemp2 = "";
		var claimLossId = "";
		for (var i=0; i<tableGrid.rows.length; i++){
			if (arr.indexOf(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]) == -1){
				adviceIdTemp = tableGrid.rows[i].adviceId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')] : tableGrid.rows[i].adviceId;
				if (nvl(adviceIdTemp,null) != null	&& 	exist.indexOf(adviceIdTemp)){
					if (swtch == 0){
						notIn = notIn + "OR (x.advice_id = " + adviceIdTemp +" AND y.clm_loss_id NOT IN (";
					}else if(swtch == 1){
						notIn = notIn + "OR (advice_id = " + adviceIdTemp +" AND clm_loss_id NOT IN (";
					}
					exist.push(adviceIdTemp);
					for (var x=0; x<tableGrid.rows.length; x++){
						if (arr.indexOf(tableGrid.rows[x][tableGrid.getColumnIndex('divCtrId')]) == -1){
							adviceIdTemp2 = tableGrid.rows[x].adviceId == null ? tableGrid.rows[x][tableGrid.getColumnIndex('adviceId')] : tableGrid.rows[x].adviceId;
							if (nvl(adviceIdTemp2,null) != null && adviceIdTemp == adviceIdTemp2){
								claimLossId = tableGrid.rows[x].claimLossId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('claimLossId')] : tableGrid.rows[x].claimLossId;
								notIn = notIn + claimLossId + ", ";
							}
						}
					}
					notIn = notIn.substr(0, notIn.length-2) + ")) ";
				}
			}
		}
		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				adviceIdTemp = tableGrid.rows[i].adviceId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')] : tableGrid.rows[i].adviceId;
				if (nvl(adviceIdTemp,null) != null && exist.indexOf(adviceIdTemp)){
					if (swtch == 0){
						notIn = notIn + "OR (x.advice_id = " + adviceIdTemp +" AND y.clm_loss_id NOT IN (";
					}else if(swtch == 1){
						notIn = notIn + "OR (advice_id = " + adviceIdTemp +" AND clm_loss_id NOT IN (";
					}
					exist.push(adviceIdTemp);
					for (var x=0; x<tableGrid.newRowsAdded.length; x++){
						if (tableGrid.newRowsAdded[x] != null){
							adviceIdTemp2 = tableGrid.rows[x].adviceId == null ? tableGrid.rows[x][tableGrid.getColumnIndex('adviceId')] : tableGrid.rows[x].adviceId;
							if (nvl(adviceIdTemp2,null) != null && adviceIdTemp == adviceIdTemp2){
								claimLossId = tableGrid.rows[x].claimLossId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('claimLossId')] : tableGrid.rows[x].claimLossId;
								notIn = notIn + claimLossId + ", ";
							}
						}
					}
					notIn = notIn.substr(0, notIn.length-2) + ")) ";
				}
			}
		}
		return notIn.length>0 ? notIn.substr(3) :notIn;
	}
	
	function getAdviceLossId(tableGrid, swtch){
		var notIn = ",";
		var rows = tableGrid.geniisysRows;
		for(var i=0; i<rows.length; i++){
			if(nvl(rows[i].recordStatus, 0) != -1){
					
				notIn = notIn + rows[i].adviceId + "-"+ rows[i].claimLossId + ",";
				
			}
		}

		notIn = (notIn != "" ? notIn : "");
		return notIn;
	}
	
	/*$("searchPayee").observe("click", function() {
		if($F("selTransactionType")=="" || $F("txtLineCd") == "" || $F("txtIssCd") == "" || $F("txtAdviceYear") == "") {
			showMessageBox("List of Values not available.");
		} else if(enableLOVs){
			var notIn = getLossId(gdcpGrid, $F("adviceIdAC017"));
			showPayeeLOVGIACS017($F("selTransactionType"), $F("txtLineCd"), $F("adviceIdAC017"), $F("claimIdAC017"), notIn);
		}
	});*/
	
	function getLossId(tableGrid, adviceId){
		var arr = tableGrid.getDeletedIds();
		var notIn = "";
		var adviceIdTemp = "";
		var claimLossId = "";
		for (var i=0; i<tableGrid.rows.length; i++){
			if (arr.indexOf(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]) == -1){
				adviceIdTemp = tableGrid.rows[i].adviceId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')] : tableGrid.rows[i].adviceId;
				if (nvl(adviceIdTemp,null) != null && adviceIdTemp == adviceId){
					claimLossId = tableGrid.rows[i].claimLossId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('claimLossId')] : tableGrid.rows[i].claimLossId;
					notIn = notIn + claimLossId + ", ";
				}
			}
		}
		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				adviceIdTemp = tableGrid.rows[i].adviceId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('adviceId')] : tableGrid.rows[i].adviceId;
				if (nvl(adviceIdTemp,null) != null && adviceIdTemp == adviceId){
					claimLossId = tableGrid.rows[i].claimLossId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('claimLossId')] : tableGrid.rows[i].claimLossId;
					notIn = notIn + claimLossId + ", ";
				}
			}
		}
		return notIn.length>0 ? notIn.substr(0,notIn.length-2) :notIn;
	}
	
	$("selCurrency").observe("change", function() {
		var oldForeignAmt = unformatCurrency("dcpForeignCurrencyAmt");
		$("dcpConvertRate").value = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("rate");
		$("dcpForeignCurrencyAmt").value = formatCurrency(oldForeignAmt*parseFloat($F("dcpConvertRate")));
	});
	
	$("btnDirectClaimCancel").observe("click", function() {
		fireEvent($("acExit"), "click");
	});
	
	$("txtAdvSeqNo").observe("change", function() {
		if(!isNaN(removeLeadingZero($F("txtAdvSeqNo")))) {
			new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
				method: "GET",
				parameters: {
					action: "getEnteredAdviceDetails",
					vIssCd: 		giacs017Vars.varIssCd,
					tranType: 		$F("selTransactionType"),
					lineCd:  		$F("txtLineCd"),
					issCd:			$F("txtIssCd"),
					adviceYear:		$F("txtAdviceYear"),
					adviceSeqNo:	$F("txtAdvSeqNo"),
					notIn:			gdcpGrid.createNotInParam("adviceId")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response) {
					if(checkErrorOnResponse(response)) {
						var row = JSON.parse(response.responseText);
						var exists = false;
						for(var i=0; i<objDCPArr.length; i++) {
							if(objDCPArr[i].adviceId == row.adviceId && 
								objDCPArr[i].recordStatus != "-1") {
								exists = true;
								break;
							}
						}
						if(exists) {
							showMessageBox("Claim has already been added.");
							$("txtAdvSeqNo").value = "";
							$("txtAdviceYear").value = "";
						} else if(row != null && JSON.stringify(row) != '{}') {
							if (objACGlobal.previousModule == 'GIACS016' && $F("txtLineCd") != objGIACS002.lineCd){	// added condition : shan 09.08.2014
								var notIn = gdcpGrid.createNotInParam("adviceId");
								var notIn2 = getAdviceLossId(gdcpGrid, 0);
								var lineCd = $F("txtLineCd");
								
								lineCd = (lineCd == "" || lineCd == objGIACS002.lineCd ? objGIACS002.lineCd : null);
								showAdvSeqNoLOV(
										$F("selTransactionType"), lineCd, $F("txtIssCd"),
										$F("txtAdviceYear"), $F("txtAdvSeqNo"), giacs017Vars.varIssCd, notIn, notIn2
									);
							}else{
								$("selCurrency").value = row==null ? "" : row.currencyCode;
								$("dcpConvertRate").value = row==null ? "" : row.convertRate;
								$("dcpCurrencyDesc").value = row==null ? "" : row.currencyDescription;
								
								$("txtLineCd").value		= row.lineCode;
								$("txtIssCd").value			= row.issueCode;
								$("txtAdviceYear").value	= row.adviceYear;
								$("txtAdvSeqNo").value 	    = row.adviceSequenceNumber;
								$("adviceIdAC017").value 	= row.adviceId;
								$("claimIdAC017").value 	= row.claimId;
								
								$("txtClaimNumber").value 	= row.claimNumber;
								$("txtPolicyNumber").value	= row.policyNumber;
								$("txtAssuredName").value 	= row.assuredName;
								$("txtAdviceYear").setAttribute("lastValidValue", $F("txtAdviceYear"));
								$("txtAdvSeqNo").setAttribute("lastValidValue", $F("txtAdvSeqNo"));
							}
						} else {
							showMessageBox(/*"No existing claim."*/ "Advice Number doesn't exist.");
							$("txtAdvSeqNo").value = $("txtAdvSeqNo").readAttribute("lastValidValue") == "" ? "" : $("txtAdvSeqNo").readAttribute("lastValidValue");
							$("txtAdviceYear").value = $("txtAdviceYear").readAttribute("lastValidValue") == "" ? "" : $("txtAdviceYear").readAttribute("lastValidValue");
							$("txtAdviceYear").setAttribute("lastValidValue", $F("txtAdviceYear"));
							$("txtAdvSeqNo").setAttribute("lastValidValue", $F("txtAdvSeqNo"));
						}
					}
				}
			});
		}
	});
	
	try {
		gdcpObj.gdcpTableGrid 	= JSON.parse('${gdcpTG}');
		gdcpObj.gdcpRows 		= gdcpObj.gdcpTableGrid.rows || [];
		gdcpObj.sumAmounts 		= JSON.parse('${gdcpSum}');
		objDCPArr				= gdcpObj.gdcpRows;
		
		//**
		$("sumDisbAmt").value = gdcpObj.sumAmounts.sumDisbAmt;
		$("sumInputVat").value = gdcpObj.sumAmounts.sumInputVat;
		$("sumWHolding").value = gdcpObj.sumAmounts.sumWHolding;
		//** mga walang silbi :D
		$("sumDspNetAmt").value = formatCurrency(gdcpObj.sumAmounts.sumDspNetAmt); //temporary displayed sum
		
		var gdcpTableModel = {
			url: contextPath+"/GIACDirectClaimPaymentController?action=refreshGDCPTableGrid&gaccTranId="+objACGlobal.gaccTranId,
		    options: {
		    	title: '',
		    	height: '220px',
		    	newRowPosition: 'bottom',
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateGDCPFields(null, false);
						enableDisableGDCPInputs();
						if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
			  				disableGIACS017();
			  			}
						return true;						
					}					
				}, beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						populateGDCPFields(null, false);
						enableDisableGDCPInputs();
						if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
			  				disableGIACS017();
			  			}
						return true;						
					}					
				}, onCellFocus: function(element, value, x, y, id) {
		    		if(y >= 0) {
		    			selectedGDCPIndex = y;
		    			selectedGDCPObj = gdcpGrid.geniisysRows[y];
		    			populateGDCPFields(selectedGDCPObj, false);
		    			enableDisableGDCPInputs();
		    		}
		    		if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		  				disableGIACS017();
		  			}
		    		gdcpGrid.keys.releaseKeys();
		    	}, onRemoveRowFocus: function() {
		  			selectedGDCPIndex = null;
		  			selectedGDCPObj = null;
		  			populateGDCPFields(null, false);
		  			enableDisableGDCPInputs();
		  			if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		  				disableGIACS017();
		  			}
		  		},
		  		//added by shan 10.30.2013
		  		checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						gdcpGrid.onRemoveRowFocus();
					}
				}
		    },
		    columnModel: [
				{
					id: 'recordStatus',
					width: '0',
					visible: false,
					editor: 'checkbox'
				}, {	
					id: 'divCtrId',
					width: '0',
					visible: false
				}, {
					id: 'transactionType',
					title: '',
					width: '20px',
					editable: false,
					align: 'center',
					filterOptionType: 'integerNoNegative'
				}, {
					id: 'dspAdviceNo',
					title: 'Advice Number',
					width: '120px',
					titleAlign: 'left',
					align: 'left',
					editable: false,
					filterOption: true
				}, {
					id: 'dspPayeeDesc',
					title: 'Payee Class',
					width: '100px',
					titleAlign: 'left',
					align: 'left',
					editable: false,
					filterOption: true
				}, {
					id: 'dspPerilName',
					title: 'Peril',
					width: '80px',
					titleAlign: 'left',
					align: 'left',
					editable: false,
					filterOption: true
				}, {
					id: 'disbursementAmount',
					title: 'Disbursement Amount',
					width: '140px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				}, {
					id: 'inputVatAmount',
					title: 'Input Tax',
					width: '115px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				}, {
					id: 'withholdingTaxAmount',
					title: 'Withholding Tax',
					width: '120px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				}, {
					id: 'netDisbursementAmount',
					title: 'Net Disbursement',
					width: '135px',
					titleAlign: 'right',
					align: 'right',
					editable: false,
					geniisysClass : 'money',
					filterOptionType: 'number',
				  	filterOption: true
				}, {
					id: 'gaccTranId',
					width: '0',
					visible: false
				}, {
					id: 'claimId',
					width: '0',
					visible: false
				}, {
					id: 'claimLossId',
					width: '0',
					visible: false
				}, {
					id: 'adviceId',
					width: '0',
					visible: false
				}, {
					id: 'payeeCd',
					width: '0',
					visible: false
				}, {
					id: 'payeeClassCd',
					width: '0',
					visible: false
				}, {
					id: 'payeeType',
					width: '0',
					visible: false
				}, {
					id: 'currencyCode',
					width: '0',
					visible: false
				}, {
					id: 'convertRate',
					width: '0',
					visible: false
				}, {
					id: 'foreignCurrencyAmount',
					width: '0',
					visible: false
				}, {
					id: 'orPrintTag',
					width: '0',
					visible: false
				}, {
					id: 'remarks',
					width: '0',
					visible: false
				}, {
					id: 'currencyDesc',
					width: '0',
					visible: false
				}, {
					id: 'dspIssCd',
					width: '0',
					visible: false
				}, {
					id: 'dspLineCd',
					width: '0',
					visible: false
				}, {
					id: 'dspAdviceYear',
					width: '0',
					visible: false
				}, {
					id: 'dspAdviceSeqNo',
					width: '0',
					visible: false
				}, {
					id: 'dspPayeeName',
					width: '0',
					visible: false
				}, {
					id: 'dspLineCd2',
					width: '0',
					visible: false
				}, {
					id: 'dspSublineCd',
					width: '0',
					visible: false
				}, {
					id: 'dspIssCd3',
					width: '0',
					visible: false
				}, {
					id: 'dspIssueYy',
					width: '0',
					visible: false
				}, {
					id: 'dspPolSeqNo',
					width: '0',
					visible: false
				}, {
					id: 'dspRenewNo',
					width: '0',
					visible: false
				}, {
					id: 'dspIssCd2',
					width: '0',
					visible: false
				}, {
					id: 'dspClmYy',
					width: '0',
					visible: false
				}, {
					id: 'dspClmSeqNo',
					width: '0',
					visible: false
				}, {
					id: 'dspAssuredName',
					width: '0',
					visible: false
				}, {
					id: 'policyNumber',
					width: '0',
					visible: false
				}, {
					id: 'claimNumber',
					width: '0',
					visible: false
				}, {
					id: 'batchCsrId',
					width: '0',
					visible: false
				}
		    ],
		    rows: gdcpObj.gdcpRows
		};
		
		gdcpGrid = new MyTableGrid(gdcpTableModel);
		gdcpGrid.pager = gdcpObj.gdcpTableGrid;
		gdcpGrid.render('dcpTableGrid');
	} catch(e) {
		showErrorMessage("showGDCPTableGrid", e);
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	$("btnHideDcpCurrencyDiv").observe("click",function(){
		Effect.Fade($("directClaimCurrencyDiv"), {
			duration: .2
		});	
	});
	
	$("btnForeignCurrDcp").observe("click",function(){
		Effect.Appear($("directClaimCurrencyDiv"), {
			duration: .2
		});	
	});
	
	$("selTransactionType").observe("change", function() {
		if($F("selTransactionType") != "") {
			enableButton("btnClaimAdvice");
			enableButton("btnBatchClaim");
		} else {
			disableButton("btnClaimAdvice");
			disableButton("btnBatchClaim");
		}
	});
	
	$("btnClaimAdvice").observe("click", function() {
		var contentDiv = new Element("div", {id: "modal_claim_advice"});
		var contentHTML = '<div id="modal_claim_advice"></div>';
		var notIn = gdcpGrid.createNotInParam("adviceId");
		var notIn2 = getAdviceLossId(gdcpGrid, 1);//added by reymon 04262013
		
		adviceOverlay = Overlay.show(contentHTML, {
			id: 'modal_dialog_advice',
			title: "Claim Advice",
			width: 500,
			height: 360,
			draggable: true,
			closable: true
		});
		
		new Ajax.Updater("modal_claim_advice", contextPath+"/GIACDirectClaimPaymentController?action=showClaimAdviceModal&refresh=0&lineCd="+
				$F("txtLineCd")+"&issCd="+$F("txtIssCd")+"&adviceYear="+$F("txtAdviceYear")+"&adviceSeqNo="+$F("txtAdvSeqNo")+
				"&riIssCd="+giacs017Vars.varIssCd+"&tranType="+$F("selTransactionType")+"&notIn="+notIn+"&notIn2="+notIn2, {//added notIn and notIn2 reymon 02242013
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		
	});
	
	$("btnBatchClaim").observe("click", function() {
		var contentDiv = new Element("div", {id: "modal_batch_claim"});
		var contentHTML = '<div id="modal_batch_claim"></div>';
		var notIn = getBatchCsrId(gdcpGrid);//added by reymon 04292013
		
		batchOverlay = Overlay.show(contentHTML, {
			id: 'modal_dialog_batch',
			title: "Batch Claim Settlement",
			width: 500,
			height: 360,
			draggable: true,
			closable: true
		});
		
		new Ajax.Updater("modal_batch_claim", contextPath+"/GIACDirectClaimPaymentController?action=showBatchClaimModal&refresh=0&lineCd="+
				$F("txtLineCd")+"&issCd="+$F("txtIssCd")+"&adviceYear="+$F("txtAdviceYear")+"&adviceSeqNo="+$F("txtAdvSeqNo")+
				"&riIssCd="+giacs017Vars.varIssCd+"&tranType="+$F("selTransactionType")+"&notIn="+notIn, {//added notin reymon 04292013
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	});
	
	//created by reymon for 04262013
	function getBatchCsrId(tableGrid){
		var arr = tableGrid.getDeletedIds();
		var notIn = "";
		var exist = new Array();
		var batchCsrIdTemp = "";
		
		for (var i=0; i<tableGrid.rows.length; i++){
			if (arr.indexOf(tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')]) == -1){
				batchCsrIdTemp = tableGrid.rows[i].batchCsrId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('batchCsrId')] : tableGrid.rows[i].batchCsrId;
				if (nvl(batchCsrIdTemp,null) != null && exist.indexOf(batchCsrIdTemp)){
					notIn = notIn + batchCsrIdTemp + ", ";
					exist.push(batchCsrIdTemp);
				}
			}
		}
		for (var i=0; i<tableGrid.newRowsAdded.length; i++){
			if (tableGrid.newRowsAdded[i] != null){
				batchCsrIdTemp = tableGrid.rows[i].batchCsrId == null ? tableGrid.rows[i][tableGrid.getColumnIndex('batchCsrId')] : tableGrid.rows[i].batchCsrId;
				if (nvl(batchCsrIdTemp,null) != null && exist.indexOf(batchCsrIdTemp)){
					notIn = notIn + batchCsrIdTemp + ", ";
					exist.push(batchCsrIdTemp);
				}
			}
		}
		return notIn.length>0 ? notIn.substr(0, notIn.length-2) :notIn;
	}
	
	$("txtLineCd").observe("change", function() {
		populateGDCPFields(null, true);
	});
	
	$("txtIssCd").observe("change", function() {
		populateGDCPFields(null, true);
	});
		
	$("txtAdviceYear").observe("change", function() {
		populateGDCPFields(null, true);
	});
	
	$("varIssCd").value = giacs017Vars.varIssCd;
		
	initializeAll();
	initializeAllMoneyFields();
	initializeChangeAttribute();
	initializeChangeTagBehavior(saveGDCP);
	
	// andrew - 08.14.2012 SR 0010292
	function disableGIACS017(){
		try {
			$("selTransactionType").disable();
			$("selTransactionType").removeClassName("required");
			$("txtLineCd").removeClassName("required");
			$("txtIssCd").removeClassName("required");
			$("txtAdviceYear").removeClassName("required");
			$("txtAdvSeqNo").removeClassName("required");
			$("txtLineCd").readOnly = true;
			$("txtIssCd").readOnly = true;
			$("txtAdviceYear").readOnly = true;
			$("txtAdvSeqNo").readOnly = true;
			$("selPayeeClass2").removeClassName("required");
			$("txtPeril").removeClassName("required");
			$("txtDisbursementAmount").removeClassName("required");
			$("payeeClassDiv").style.backgroundColor = "";
			$("txtNetDisbursement").removeClassName("required");
			$("selCurrency").disable();
			$("selCurrency").removeClassName("required");
			$("dcpConvertRate").removeClassName("required");
			$("dcpForeignCurrencyAmt").removeClassName("required");
			$("txtRemarks").readOnly = true;
			disableSearch("searchAdvice2"); //added by robert
			disableButton("btnAddDCP");
			disableButton("btnDirectClaimSave");
		} catch(e){
			showErrorMessage("disableGIACS017", e);
		}
	}
	//added cancelOtherOR by robert 10302013;; added objACGlobal.orFlag by shan 12.16.2013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y" 
			|| (objACGlobal.orFlag == "P" && nvl(objAC.tranFlagState, "") != "O")){
		disableGIACS017();
	}
	
	
	if(objACGlobal.calledForm == "GIACS016"){
		//disableGIACS017(); -- temporarily commented out by robert 11.28.2013 - pabalik na lang kung kelangan talaga to :)
		$("acExit").stopObserving("click");
		$("acExit").observe(
				"click",
				function() {
					if (changeTag == 1) {
						showConfirmBox4("CONFIRMATION",
								objCommonMessage.WITH_CHANGES, "Yes", "No",
								"Cancel", function() {
									saveAcctEntries();
									if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
										showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
									}else if(objACGlobal.previousModule == "GIACS071"){
										updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
										objACGlobal.previousModule = null;
									}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
										showGIACS070Page();
										objACGlobal.previousModule = null;
									}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
										$("giacs031MainDiv").hide();
										$("giacs032MainDiv").show();
										$("mainNav").hide();
									}else{
										editORInformation();	
									}
								}, function() {
									if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
										showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
									}else if(objACGlobal.previousModule == "GIACS071"){
										updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
										objACGlobal.previousModule = null;
									}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
										showGIACS070Page();
										objACGlobal.previousModule = null;
									}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
										$("giacs031MainDiv").hide();
										$("giacs032MainDiv").show();
										$("mainNav").hide();
									}else{
										editORInformation();	
									}
									changeTag = 0;
								}, "");
					} else {
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
						}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
							showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}
				});
		
	}else{	//added by shan : copy from transBasicInformation.jsp
		$("acExit").stopObserving("click");
		$("acExit").observe("click", function () {
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
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS016"){ // added by Kris 05.17.2013
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){ //added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				if(changeTag == 1) {
					if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
						changeTag = 0;
						changeTagFunc = "";
						editORInformation(); 
					}else{
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									lastAction = editORInformation;	//shan 10.30.2013
									changeTagFunc(); 
									if (changeTag == 0){
										changeTagFunc = "";
										editORInformation(); 
									}
								}, 
								function(){
									changeTag = 0;
									changeTagFunc = "";
									lastAction = "";	//shan 10.30.2013
									editORInformation(); 
								}, 
								"");
					}	
				}else{
					changeTag = 0;
					changeTagFunc = "";
					lastAction = "";	//shan 10.30.2013
					editORInformation(); 
				}
			}
		});
	}
</script>