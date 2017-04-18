<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="overridingCommDiv" name="overridingCommDiv" changeTagAttr="true">
	<!-- page variables -->
	<input type="hidden" id="txtPrevCommAmt" 		name="txtPrevCommAmt" 			value="" />
	<input type="hidden" id="txtPrevForCurrAmt" 	name="txtPrevForCurrAmt" 		value="" />
	<input type="hidden" id="txtOldDrvAmt2" 		name="txtOldDrvAmt2" 			value="" />
	<input type="hidden" id="txtOldDrvAmt3" 		name="txtOldDrvAmt3" 			value="" />
	<input type="hidden" id="txtOldDrvWtax" 		name="txtOldDrvWtax" 			value="" />
	<input type="hidden" id="txtOldDrvInvat" 		name="txtOldDrvInvat" 			value="" />
	<input type="hidden" id="txtVDrvCommAmt2" 		name="txtVDrvCommAmt2" 			value="" />
	<input type="hidden" id="txtVDrvCommAmt3" 		name="txtVDrvCommAmt3" 			value="" />
	<input type="hidden" id="txtVDrvWtaxAmt" 		name="txtVDrvWtaxAmt" 			value="" />
	<input type="hidden" id="txtVDrvInvatAmt" 		name="txtVDrvInvatAmt" 			value="" />
	
	<jsp:include page="overridingCommListingTable.jsp"></jsp:include>
	
	<table align="center" style="margin: 10px">
		<tr>
			<td class="rightAligned" style="width: 180px">Transaction Type</td>
			<td class="leftAligned"	 style="width: 250px;">
				<select id="txtTransactionType" name="txtTransactionType" class="required" style="width: 250px" tabindex=1>
					<option value="">Select...</option>
					<c:forEach var="tranType" items="${transactionTypeList }" varStatus="ctr">
						<option value="${tranType.rvLowValue }">${tranType.rvLowValue } - ${tranType.rvMeaning }</option>
					</c:forEach>
				</select>
				<input type="text" class="required" id="txtDspTransactionType" name="txtDspTransactionType" style="text-align: left; width: 240px; display: none" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 140px">Assured Name</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtAssdName" name="txtAssdName" maxlength="500" style="width: 234px" readonly="readonly" tabindex=10></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Bill No.</td>
			<td class="leftAligned"	 style="width: 250px;">
				<%-- <select id="txtBillNo" name="txtBillNo" style="width: 250px" class="required" tabindex=2>
					<option value="">Select...</option>
					<c:forEach var="bill" items="${billNoList }" varStatus="ctr">
						<option value="${bill.billNo }"
								issCd="${bill.issCd }"
								premSeqNo="${bill.premSeqNo }">${bill.billNo }</option>
					</c:forEach>
				</select> --%>
				<span id="spanBranchCd" class="lovSpan required" style="width: 96px; margin-right: 2px;">
					<input type="text" id="txtBranchCd" name="txtBranchCd" lastValidValue="" style="width: 70px; float: left; border: none; height: 14px; margin: 0;" class="upper required" tabindex="2" ignoreDelKey="" maxlength="2"/> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
				</span>
				<span id="spanPremSeqNo" class="lovSpan required" style="width: 147px; margin-right: 2px;">
					<input type="text" id="txtPremSeqNo" name="txtPremSeqNo" lastValidValue="" style="width: 121px; height: 14px; margin: 0; border: none; text-align: right; float: left;" class="required integerNoNegativeUnformatted" ignoreDelKey="" maxlength="14" tabindex=3>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPremSeqNo" name="searchPremSeqNo" alt="Go" />
				</span>
<!-- 				<input type="text" id="txtBranchName" name="txtBranchName" value="ALL BRANCHES" style="width: 340px; float: left; height: 14px; margin: 0;" class="upper" maxlength="50" readonly="readonly" tabindex="107"/> -->
<!-- 				<input type="text" class="required" id="txtDspBillNo" name="txtDspBillNo" style="text-align: right; width: 240px; display: none" value="" readonly="readonly"/> -->
			</td>
			<td class="rightAligned" style="width: 140px">Policy No.</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtPolicyNo" name="txtPolicyNo" maxlength="40" style="width: 234px" readonly="readonly" tabindex=10></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Intermediary Name</td>
			<td class="leftAligned"	 style="width: 250px;">
				<!-- <span><select id="txtIntermediaryName" name="txtIntermediaryName" style="width: 250px" class="required" tabindex=4>
					<option value="">Select...</option>
				</select></span>  -->
				<input type="hidden" id="txtIntmNo" name="txtIntmNo"/>
				<input type="text" class="required" id="txtIntermediaryName" name="txtIntermediaryName" style="width: 240px; value="" readonly="readonly"/>
				<input type="text" class="required" id="txtDspIntermediaryName" name="txtDspIntermediaryName" style="width: 240px; display: none" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 140px">Particulars</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtParticulars" name="txtParticulars" maxlength="2000" style="width: 234px" tabindex=11></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Child Intermediary Name</td>
			<td class="leftAligned"	 style="width: 250px;">
				<!-- <span><select id="txtChildIntmName" name="txtChildIntmName" style="width: 250px" class="required" tabindex=5>
					<option value="">Select...</option>
				</select></span> -->
				<input type="hidden" id="txtChildIntmNo" name="txtIntmNo"/>
				<input type="text" class="required" id="txtChildIntmName" name="txtChildIntmName" style="width: 240px; value="" readonly="readonly"/>
				<input type="text" class="required" id="txtDspChildIntmName" name="txtDspChildIntmName" style="width: 240px; display: none" value="" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 140px"></td>
			<td style="width: 260px;text-align: center">
				<input type="button" class="button" style="width: 150px;font-size: 12px;text-align: center" id="btnCurrency" name="btnCurrency" value="Currency Information" tabindex=12></input>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Overriding Commission</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtCommAmt" name="txtCommAmt" maxlength="17" class="required" style="width: 240px; text-align: right" tabindex=6>
			</td>
			<td class="rightAligned" style="width: 140px"></td>
			<td style="width: 260px;text-align: center"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Input VAT</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtInputVAT" name="txtInputVAT" maxlength="17" style="width: 240px; text-align: right" tabindex=7>
			</td>
			<td class="rightAligned" style="width: 140px"></td>
			<td style="width: 260px;text-align: center"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Withholding Tax</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtWtaxAmt" name="txtWtaxAmt" maxlength="17" style="width: 240px; text-align: right" class="required" readonly="readonly" tabindex=8>
			</td>
			<td class="rightAligned" style="width: 140px"></td>
			<td style="width: 260px;text-align: center"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Net Commission</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtDrvCommAmt" name="txtDrvCommAmt" maxlength="17" style="width: 240px; text-align: right" readonly="readonly" tabindex=9>
			</td>
			<td class="rightAligned" style="width: 140px"></td>
			<td style="width: 260px;text-align: center"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px"></td>
			<td style="width: 260px;">
				<input type="button" class="button" 		style="width: 80px;font-size: 12px;text-align: center" id="btnSaveRecord" name="btnSaveRecord" value="Add" tabindex=13></input>
				<input type="button" class="disabledButton" style="width: 80px;font-size: 12px;text-align: center" id="btnDeleteRecord" name="btnDeleteRecord" value="Delete" disabled="disabled" tabindex=14></input>
			</td>
		</tr>
	</table>
	<div id="currencyDiv" style="display: none;">
		<jsp:include page="currencyInfoPage.jsp"></jsp:include>
	</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">
	<input type="button" style="width: 80px;" id="btnCancel" 			  name="btnCancel"				class="button" value="Cancel" tabindex=20/>
	<input type="button" style="width: 80px;" id="btnSaveOvrideCommPayts" name="btnSaveOvrideCommPayts"	class="button" value="Save"   tabindex=19/>
</div>
<script type="text/javascript">
	/** local variables **/
	
	var lastNo = 0; 						// last row no
	var currentRowNo = -1; 					// row no of current record selected. f-1 when no rows are selected
	var okForSaving = false;				// the final variable to be checked if record is OK for adding

	// VARIABLES
	
	var varWithPrem = 0;
	var varPremAmt = "";
	var varPremiumPayts = "";
	var varSwitch = 2;
	var varPercentage = "";
	var varCommAmt = "";
	var varCommAmtDef = "";
	var varForCurAmtDef = "";
	var varDrvCommAmtDef = "";
	var varDrvCommAmt2Def = "";
	var varWtaxAmt = "";
	var varForeignCurrAmt = "";
	var varCurrencyRt = "";
	var varCurrencyCd = "";
	var varCurrencyDesc = "";

	// CONTROL block variables
	
	var controlDrvCommAmt2 = "";
	var controlDrvInvatAmt = "";
	var controlDrvWtaxAmt = "";
	var controlDrvCommAmt3 = "";

	// MISC
	
	var childIntmDistinct = "N";				// flag for child intm listing. If "Y", RECORD_GROUP240 is used (with distinct)
	var lastCommAmt = "";
	var lastInputVAT = "";
	var lastWtaxAmt = "";
	
	/** end of local variables **/

	/** objects and lists **/
	
	ovrideCommPaytsList = eval('${ovrideCommPaytsList }');
	//remove by steven 11.19.2014
// 	dfltBillNoList = eval('${dfltBillNoList }'); 
// 	billNoList1 = eval('${billNoList1 }');
// 	billNoList2 = eval('${billNoList2 }');
// 	billNoList3 = eval('${billNoList3 }');
// 	billNoList4 = eval('${billNoList4 }');
	
	/** end of objects and lists **/

	/** initialization **/
	setModuleId("GIACS040");
	setDocumentTitle("Overriding Commission");

	//observeReloadForm("reloadForm", showDirectTransOverridingComm);
	//observeCancelForm("btnCancel", saveOverridingCommPayts, showORInfo);
	if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C" && objACGlobal.queryOnly != "Y" ){ // andrew - 08.16.2012 SR 0010292
		initializeChangeTagBehavior(saveOverridingCommPayts);
	}

	changeTag = 0;
	
	$("txtCurrencyCd").readOnly = true;
	$("txtDspCurrencyDesc").readOnly = true;
	$("txtConvertRate").readOnly = true;
	
	var deletedBillList = [];
	
	if (ovrideCommPaytsList.length > 0) {
		for (var i = 0; i < ovrideCommPaytsList.length; i++) {
			var content = generateContent(ovrideCommPaytsList[i], i);
			generateInitialItemValue(ovrideCommPaytsList[i]);
			addTableRow("row"+i, "rowOvrideCommPayts", "overridingCommTableContainer", content, clickOvrideCommPaytsRow);
			lastNo = lastNo + 1;
		}
		checkIfToResizeTable("overridingCommTableContainer", "rowOvrideCommPayts");
	} else {
		checkTableIfEmpty("rowOvrideCommPayts", "overridingCommPaytsTableMainDiv");
	}

	// initialize currency info fields
	$("txtForeignCurrAmt").maxLength = 17;
	
	/** end of initialization **/

	/** events **/
	
	$("txtTransactionType").observe("change", function() {
		//updateBillNoList();

		if ($F("txtTransactionType") == "2" || $F("txtTransactionType") == 4) {
			childIntmDistinct = "Y";
			$("txtCommAmt").readOnly = true;
			$("txtInputVAT").readOnly = true;
		}else{
			$("txtCommAmt").readOnly = false;
			$("txtInputVAT").readOnly = false;
		}
		//added by steven 11.20.2014
		$("txtBranchCd").clear();
		$("txtPremSeqNo").clear();
		$("txtBranchCd").setAttribute("lastValidValue", ""); 
		$("txtPremSeqNo").setAttribute("lastValidValue", ""); 
		//resetField3(["txtIntermediaryName","txtChildIntmName"]);
		//end
		$("txtIntmNo").clear();
		$("txtIntermediaryName").clear();
		$("txtChildIntmNo").clear();
		$("txtChildIntmName").clear();
		resetFields2();
	});

	$("txtCommAmt").observe("change", function() {
		if (isNaN($F("txtCommAmt").replace(/,/g,""))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
				function() {
					$("txtCommAmt").value = lastCommAmt.blank() ? "" : formatCurrency(lastCommAmt);
					$("txtCommAmt").focus();
				}
			);
		} else if (parseFloat($F("txtCommAmt").replace(/,/g,"")) < - 9999999999.99 || parseFloat($F("txtCommAmt").replace(/,/g,"")) > 9999999999.99) {
			showWaitingMessageBox("Field must be of form 9,999,999,999.00.", imgMessage.ERROR,
					function() {
						$("txtCommAmt").value = lastCommAmt.blank() ? "" : formatCurrency(lastCommAmt);
						$("txtCommAmt").focus();
					}
				);
		} else {			
			if (!this.readOnly && parseFloat(this.value) != parseFloat(lastCommAmt)){
				validateCommAmt();
			}else{
				this.value = formatCurrency(this.value);
			}	
		}
	});

	function getDefaultInputVAT(){
		try{
			new Ajax.Request(contextPath + "/GIACOvrideCommPaytsController",{
				parameters: {
					action:		"getInputVAT",
					intmNo:		$F("txtIntmNo"),
					commAmt:	$F("txtCommAmt").replace(/,/g,"")
				},
				onCreate: showNotice("Validating Input VAT, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var result = JSON.parse(response.responseText);
						var inputVAT = $F("txtCommAmt").replace(/,/g,"");
						
						if (parseFloat(inputVAT) != 0 && parseFloat(inputVAT) != parseFloat(result.inputVAT)){
							showMessageBox("Invalid Input VAT Amount entered.");
							$("txtInputVAT").value = formatCurrency(parseFloat(nvl(lastInputVAT,0)));
						}else{
							$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtInputVAT").replace(/,/g,""), $F("txtWtaxAmt").replace(/,/g,""), $F("txtCommAmt").replace(/,/g,"")));
							getRunningTotal();
							lastInputVAT = $F("txtInputVAT").replace(/,/g,"");
							$("txtInputVAT").value = formatCurrency($F("txtInputVAT"));
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("Error in getDefaultInputVAT", e);
		}
	}
	
	$("txtInputVAT").observe("change", function() {
		if (validateInputVAT()) {
			/*$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtInputVAT").replace(/,/g,""), $F("txtWtaxAmt").replace(/,/g,""), $F("txtCommAmt").replace(/,/g,"")));
			getRunningTotal();
			lastInputVAT = $F("txtInputVAT").replace(/,/g,"");
			$("txtInputVAT").value = formatCurrency($F("txtInputVAT"));*/ // moved inside getDefaultInputVAT
			getDefaultInputVAT();
		}
	});

	$("txtWtaxAmt").observe("change", function() {
		getRunningTotal();
	});

	$("txtDrvCommAmt").observe("change", function() {
		$("txtDrvCommAmt").value = formatCurrency(parseFloat(nvl($F("txtCommAmt"), 0)) + parseFloat(nvl($F("txtInputVAT"), 0)) - parseFloat($F("txtWtaxAmt"), 0));
		getRunningTotal();
	});

	$("txtForeignCurrAmt").observe("focus", function() {
		$("txtPrevForCurrAmt").value = $F("txtForeignCurrAmt").replace(/,/g,"");
	});

	$("txtForeignCurrAmt").observe("change", function() {
		if (isNaN($F("txtForeignCurrAmt").replace(/,/g,""))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
				function() {
					$("txtForeignCurrAmt").value = $F("txtPrevForCurrAmt").blank() ? "" : formatCurrency($F("txtPrevForCurrAmt"));
					$("txtForeignCurrAmt").focus();
				}
			);
		} else if (parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) < - 9999999999.99 || parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) > 9999999999.99) {
			showWaitingMessageBox("Field must be of form 9,999,999,999.00.", imgMessage.ERROR,
					function() {
						$("txtForeignCurrAmt").value = $F("txtPrevForCurrAmt").blank() ? "" : formatCurrency($F("txtPrevForCurrAmt"));
						$("txtForeignCurrAmt").focus();
					}
				);
		} else {
			var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
			var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
			
			new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=validateForeignCurrAmt", {
				evalScripts: true,
				asynchronous: true,
				method: "GET",
				parameters: {
					transactionType: $F("txtTransactionType"),
					issCd: paramIssCd,
					premSeqNo: paramPremSeqNo,
					intmNo: $F("txtIntermediaryName"),
					childIntmNo: $F("txtChildIntmName"),
					commAmt: $F("txtCommAmt").replace(/,/g,""),
					wtaxAmt: $F("txtWtaxAmt").replace(/,/g,""),
					drvCommAmt: $F("txtDrvCommAmt").replace(/,/g,""),
					foreignCurrAmt: $F("txtForeignCurrAmt").replace(/,/g,""),
					prevForCurrAmt: $F("txtPrevForCurrAmt").replace(/,/g,""),
					varForCurAmtDef: varForCurAmtDef,
					varCurrencyRt: varCurrencyRt
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();

						if (nvl(result.message, "SUCCESS") != "SUCCESS") {
							if (result.message == "AMOUNT_NOT_NEGATIVE") {
								showWaitingMessageBox("Amount entered should be Negative in value.", imgMessage.ERROR,
									function() {
										$("txtForeignCurrAmt").value = $F("txtPrevForCurrAmt").blank() ? "" : formatCurrency($F("txtPrevForCurrAmt"));
										$("txtForeignCurrAmt").focus();
									});
							} else {
								showWaitingMessageBox(result.message, imgMessage.INFO,
										function() {
											$("txtForeignCurrAmt").focus();
										});
							}
						}
						
						$("txtCommAmt").value = result.commAmt.blank() ? "" : formatCurrency(result.commAmt);
						$("txtWtaxAmt").value = result.wtaxAmt.blank() ? "" : formatCurrency(result.wtaxAmt);
						$("txtDrvCommAmt").value = result.drvCommAmt.blank() ? "" : formatCurrency(result.drvCommAmt);
						$("txtForeignCurrAmt").value = result.foreignCurrAmt.blank() ? "" : formatCurrency(result.foreignCurrAmt);
						$("txtPrevForCurrAmt").value = result.prevForCurrAmt;

						// to fix the error of wrong computation for net commission if record has Input VAT
						if (!$F("txtInputVAT").blank()) {
							$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtInputVAT").replace(/,/g,""), $F("txtWtaxAmt").replace(/,/g,""), $F("txtCommAmt").replace(/,/g,"")));
						}

						getRunningTotal();
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	});

	$("btnCurrency").observe("click", function() {
		if (currentRowNo == -1) { 
			validateCommAmt();
		}
		
		Effect.Appear($("currencyDiv"), {
			duration: 0.2
		});
	});

	$("btnHideCurrPage").observe("click", function() {
		if ($F("txtForeignCurrAmt").blank()) {
			showMessageBox("User supplied value is required for Foreign Currency Amount", imgMessage.ERROR);
		} else {
			Effect.Fade($("currencyDiv"), {
				duration: 0.2
			});
		}
	});

	$("btnSaveRecord").observe("click", function() {
		if (checkRequiredFields()) {
			if (validateFields()) {
				var rowNum;
				var ovrideCommPayts;
				var commAmt;
				var wtaxAmt;
				var inputVAT;
				var drvCommAmt;
				
				if ($F("btnSaveRecord") == "Add") {
					var ok = true;
					$$("div[name='rowOvrideCommPayts']").each(function(row) {
						if (row.down("input", 3).value == $F("txtBranchCd") && row.down("input", 4).value == $F("txtPremSeqNo") && row.down("input", 5).value == $F("txtIntmNo")
								&& row.down("input", 6).value == $F("txtChildIntmNo")) {
							resetFields();
							showMessageBox("Warning: Row with same TRAN ID,BILL NO.,INTM. NO.,CHILD INTM. NO. already exists.", imgMessage.WARNING);
							ok = false;
						}
					});
					
					if (!ok){
						return false;
					}
					
					ovrideCommPayts = new Object();
					rowNum = lastNo;
					commAmt = 0;
					wtaxAmt = 0;
					inputVAT = 0;
					drvCommAmt = 0;
				} else {
					rowNum = currentRowNo;
					ovrideCommPayts = ovrideCommPaytsList[rowNum];
					commAmt = ovrideCommPayts.commAmt;
					wtaxAmt = ovrideCommPayts.wtaxAmt;
					inputVAT = ovrideCommPayts.inputVAT;
					drvCommAmt = ovrideCommPayts.drvCommAmt;
				}
		
				var content = "";
				
				// save record
				ovrideCommPayts.gaccTranId = objACGlobal.gaccTranId;
				ovrideCommPayts.transactionType = $F("txtTransactionType");
				ovrideCommPayts.issCd = escapeHTML2($F("txtBranchCd")); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
				ovrideCommPayts.premSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
				ovrideCommPayts.intmNo = $F("txtIntmNo"); //$F("txtIntermediaryName");
				ovrideCommPayts.childIntmNo = $F("txtChildIntmNo"); //$F("txtChildIntmName");
				ovrideCommPayts.intermediaryName = changeSingleAndDoubleQuotes2($F("txtIntermediaryName")); //changeSingleAndDoubleQuotes2($("txtIntermediaryName").options[$("txtIntermediaryName").selectedIndex].innerHTML);
				ovrideCommPayts.childIntmName = changeSingleAndDoubleQuotes2($F("txtChildIntmName")); //changeSingleAndDoubleQuotes2($("txtChildIntmName").options[$("txtChildIntmName").selectedIndex].innerHTML);
				ovrideCommPayts.commAmt = parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), 0));
				ovrideCommPayts.inputVAT = parseFloat(nvl($F("txtInputVAT").replace(/,/g,""), 0));
				ovrideCommPayts.wtaxAmt = parseFloat($F("txtWtaxAmt").replace(/,/g,""));
				ovrideCommPayts.drvCommAmt = ($F("txtDrvCommAmt").blank()) ? "" : parseFloat($F("txtDrvCommAmt").replace(/,/g,""));
				ovrideCommPayts.currencyCd = $F("txtCurrencyCd");
				ovrideCommPayts.currencyDesc = $F("txtDspCurrencyDesc");
				ovrideCommPayts.convertRt = $F("txtConvertRate");
				ovrideCommPayts.foreignCurrAmt = ($F("txtForeignCurrAmt").blank() ? "" : parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")));
				ovrideCommPayts.particulars = changeSingleAndDoubleQuotes2($F("txtParticulars"));
				ovrideCommPayts.policyNo = changeSingleAndDoubleQuotes2($F("txtPolicyNo"));
				ovrideCommPayts.assdName = changeSingleAndDoubleQuotes2($F("txtAssdName"));
				ovrideCommPayts.billNo = (ovrideCommPayts.issCd.blank() || ovrideCommPayts.premSeqNo == null) ? "" : ovrideCommPayts.issCd + "-" + ovrideCommPayts.premSeqNo;
				ovrideCommPayts.oldDrvAmt2 = $F("txtOldDrvAmt2");
				ovrideCommPayts.oldDrvAmt3 = $F("txtOldDrvAmt3");
				ovrideCommPayts.oldDrvWtax = $F("txtOldDrvWtax");
				ovrideCommPayts.oldDrvInvat = $F("txtOldDrvInvat");
				ovrideCommPayts.vDrvCommAmt2 = $F("txtVDrvCommAmt2");
				ovrideCommPayts.vDrvCommAmt3 = $F("txtVDrvCommAmt3");
				ovrideCommPayts.vDrvWtaxAmt = $F("txtVDrvWtaxAmt");
				ovrideCommPayts.vDrvInvatAmt = $F("txtVDrvInvatAmt");
				ovrideCommPayts.recordStatus = ($F("btnSaveRecord") == "Add") ? 0 : 1;
		
				if ($F("btnSaveRecord") == "Add") {
					// check if record is previously deleted
					var exist = false;
					for (var i = 0; i < ovrideCommPaytsList.length; i++) {
						if (ovrideCommPaytsList[i].issCd 		== ovrideCommPayts.issCd &&
							ovrideCommPaytsList[i].premSeqNo 	== ovrideCommPayts.premSeqNo &&
							ovrideCommPaytsList[i].intmNo 		== ovrideCommPayts.intmNo &&
							ovrideCommPaytsList[i].childIntmNo 	== ovrideCommPayts.childIntmNo) {
							if (ovrideCommPaytsList[i].recordStatus == -1) {
								ovrideCommPayts.recordStatus = 1;
							} else {
								ovrideCommPayts.recordStatus = 0;
							}
							rowNum = i;
							ovrideCommPaytsList[i] = ovrideCommPayts;
							exist = true;
							break;
						}
					}
		
					if (!exist) {
						ovrideCommPaytsList.push(ovrideCommPayts);
						lastNo = lastNo + 1;
					}
		
					content = generateContent(ovrideCommPayts, rowNum);
					
					addTableRow("row"+rowNum, "rowOvrideCommPayts", "overridingCommTableContainer", content, clickOvrideCommPaytsRow);
					//resetFields(); commented out by robert 03.05.2014 moved below
				} else {
					content = generateContent(ovrideCommPayts, rowNum);
					$("row"+rowNum).update(content);
					$("row"+rowNum).update(content).removeClassName("selectedRow");
					enableFields();
				}
		
				checkIfToResizeTable("overridingCommTableContainer", "rowOvrideCommPayts");
				checkTableIfEmpty("rowOvrideCommPayts", "overridingCommPaytsTableMainDiv");
		
				$("lblDrvCommAmt2").innerHTML = formatCurrency(parseFloat($("lblDrvCommAmt2").innerHTML.replace(/,/g,"")) - commAmt + ovrideCommPayts.commAmt);
				$("lblDrvInvatAmt").innerHTML = formatCurrency(parseFloat($("lblDrvInvatAmt").innerHTML.replace(/,/g,"")) - inputVAT + ovrideCommPayts.inputVAT);
				$("lblDrvWtaxAmt").innerHTML  = formatCurrency(parseFloat($("lblDrvWtaxAmt").innerHTML.replace(/,/g,"")) - wtaxAmt + ovrideCommPayts.wtaxAmt);
				$("lblDrvCommAmt3").innerHTML = formatCurrency(parseFloat($("lblDrvCommAmt3").innerHTML.replace(/,/g,"")) - drvCommAmt + ovrideCommPayts.drvCommAmt);
			
				resetFields(); // moved by robert 03.05.2014
				$("btnSaveRecord").value = "Add";
			}
		}
	});

	$("btnCancel").observe("click", function(){		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveOverridingCommPayts();
				if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
					showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
				}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
					showGIACS070Page();
					objACGlobal.previousModule = null;
				}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
					$("giacs031MainDiv").hide();
					$("giacs032MainDiv").show();
					$("mainNav").hide();
				}else{
					changeTag = 0;
					showORInfo();
				}
			}, function(){
				if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
					showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
				}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
					showGIACS070Page();
					objACGlobal.previousModule = null;
				}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
					$("giacs031MainDiv").hide();
					$("giacs032MainDiv").show();
					$("mainNav").hide();
				}else{
					changeTag = 0;
					showORInfo();
				}
			}, "");
		}else{
			changeTag = 0;
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
				showORInfo();
			}
		}	
	});

	$("btnDeleteRecord").observe("click", function() {
		if (currentRowNo < 0) {
			return false;
		}
		
		/*new Ajax.Request(contextPath + "/GIACOvrideCommPaytsController",{
			parameters: {
				action:		"valDeleteRec",
				tranType:	$F("txtTransactionType"),
				issCd:		$F("txtBranchCd"),
				premSeqNo:	$F("txtPremSeqNo")
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: showNotice("Validating record for deletion, please wait..."),
			onComplete: function(response){
				hideNotice();
				
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){*/

					// tag the record as deleted. if previously added, mark as -2
					if (ovrideCommPaytsList[currentRowNo].recordStatus == 0) {
						ovrideCommPaytsList[currentRowNo].recordStatus = -2;
					} else {
						ovrideCommPaytsList[currentRowNo].recordStatus = -1;
					}

					// delete the record from the main container div
					var row = $("row"+currentRowNo);
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function() {
							$("lblDrvCommAmt2").innerHTML = formatCurrency(parseFloat($("lblDrvCommAmt2").innerHTML.replace(/,/g,"")) - ovrideCommPaytsList[currentRowNo].commAmt);
							$("lblDrvInvatAmt").innerHTML = formatCurrency(parseFloat($("lblDrvInvatAmt").innerHTML.replace(/,/g,"")) - ovrideCommPaytsList[currentRowNo].inputVAT);
							$("lblDrvWtaxAmt").innerHTML  = formatCurrency(parseFloat($("lblDrvWtaxAmt").innerHTML.replace(/,/g,"")) - ovrideCommPaytsList[currentRowNo].wtaxAmt);
							$("lblDrvCommAmt3").innerHTML = formatCurrency(parseFloat($("lblDrvCommAmt3").innerHTML.replace(/,/g,"")) - ovrideCommPaytsList[currentRowNo].drvCommAmt);
							row.remove();
							checkIfToResizeTable("overridingCommTableContainer", "rowOvrideCommPayts");
							checkTableIfEmpty("rowOvrideCommPayts", "overridingCommPaytsTableMainDiv");
							resetFields();
							enableFields();
							$("btnSaveRecord").value = "Add";
						}
					});
					
					deletedBillList.push(ovrideCommPaytsList[currentRowNo]);
				/*}
			}
		});	*/	
	});

	$("btnSaveOvrideCommPayts").observe("click", function() {
		saveOverridingCommPayts();
	});

	/** end of events **/

	/** page functions **/
	
	// saves the overriding comm payts records
	function saveOverridingCommPayts() {
		/* removed by robert 03.19.2014 
		if (hasUnsavedChanges()) {
			showMessageBox("Please save changes first.", imgMessage.INFO);
		}
		else  */
		if (!hasChanges()) {
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		} else if(checkPendingRecordChanges()) {
			var addedRows = getAddedJSONObjects(ovrideCommPaytsList);
			var modifiedRows = getModifiedJSONObjects(ovrideCommPaytsList);
			var delRows = getDeletedJSONObjects(ovrideCommPaytsList);
			var setRows = addedRows.concat(modifiedRows);
	
			new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=saveOverridingCommPayts", {
				evalScripts: true,
				asynchronous: false,
				method: "POST", //"GET",
				parameters: {
					gaccTranId : objACGlobal.gaccTranId,
					gaccBranchCd: objACGlobal.branchCd,
					gaccFundCd: objACGlobal.fundCd,
					tranSource: objACGlobal.tranSource,
					orFlag: objACGlobal.orFlag,
					varModuleName: "GIACS040",
					setRows: prepareJsonAsParameter(setRows),
					delRows: prepareJsonAsParameter(delRows)
				},
				onCreate: function() {
					if (objACGlobal.calledForm != "GIACS016") { //added by steven 11.20.2014
						disableMenu("home");
						//disableMenu("cashReceipts");
						disableMenu("generalDisbursements");
						disableMenu("generalLedger");
						disableMenu("endOfMonth");
						disableMenu("reinsurance"); // corrected spelling of menu by robert 03.05.2014
						disableMenu("creditAndCollection");
						disableMenu("acExit");
					}
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						if (nvl(response.responseText, "SUCCESS") == "SUCCESS") {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS,
									function() {
										if (objACGlobal.calledForm != "GIACS016") { //added by steven 11.20.2014
											enableMenu("home");
											//enableMenu("cashReceipts");
											enableMenu("generalDisbursements");
											enableMenu("generalLedger");
											enableMenu("endOfMonth");
											enableMenu("reinsurance"); // corrected spelling of menu by robert 03.05.2014
											enableMenu("creditAndCollection");
											enableMenu("acExit");
										}
									});
							changeTag = 0;
							for (var i = 0; i < ovrideCommPaytsList.length; i++) {
								if (ovrideCommPaytsList[i].recordStatus == 0 || ovrideCommPaytsList[i].recordStatus == 1) {
									ovrideCommPaytsList[i].recordStatus = null;
								} else if (ovrideCommPaytsList[i].recordStatus == -1) {
									ovrideCommPaytsList[i].recordStatus = -2;
								}
							}
							showDirectTransOverridingComm();
						} else {
							showMessageBox(response.responseText, imgMessage.INFO);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}

	// checks if changes have been made
	function hasChanges() {
		var result = false;
		for (var i = 0; i < ovrideCommPaytsList.length; i++) {
			if (ovrideCommPaytsList[i].recordStatus == 0 || ovrideCommPaytsList[i].recordStatus == 1 || ovrideCommPaytsList[i].recordStatus == -1) {
				result = true;
				break;
			}
		}

		return result;
	}

	// checks if there is currently an unsaved change on addition of record
	function hasUnsavedChanges() {
		var result = false;
		
		if ($F("btnSaveRecord") == "Add") {
			var itemFields = ["TransactionType", "BillNo", "IntermediaryName", "ChildIntmName", "CommAmt", "InputVAT",
			      				"WtaxAmt", "DrvCommAmt", "Particulars"];

			for (var i = 0; i < itemFields.length; i++) {
				if (!$F("txt"+itemFields[i]).blank()) {
					result = true;
					break;
				}
			}
		}

		return result;
	}
	
	// Generates content for the div of a new Overriding Comm Payts table row to be added
	function generateContent(ovrideCommPayts, rowNum) {
		var content = "";

		var transactionType = "---";
		var billNo = (ovrideCommPayts.issCd.blank() || ovrideCommPayts.premSeqNo == null) ? "---" : ovrideCommPayts.issCd + "-" + ovrideCommPayts.premSeqNo;
		var intermediaryName = ovrideCommPayts.intermediaryName.blank() ? "---" : ovrideCommPayts.intermediaryName;
		var childIntmName = ovrideCommPayts.childIntmName.blank() ? "---" : ovrideCommPayts.childIntmName;
		var commAmt = ovrideCommPayts.commAmt == null ? "" : formatCurrency(ovrideCommPayts.commAmt);
		var inputVAT = ovrideCommPayts.inputVAT == null ? "" : formatCurrency(ovrideCommPayts.inputVAT);
		var wtaxAmt = ovrideCommPayts.wtaxAmt == null ? "" : formatCurrency(ovrideCommPayts.wtaxAmt);
		var drvCommAmt = ovrideCommPayts.drvCommAmt == null ? "" : formatCurrency(ovrideCommPayts.drvCommAmt);

		var gaccTranId = objACGlobal.gaccTranId;
		var tranType = ovrideCommPayts.transactionType != null ? ovrideCommPayts.transactionType : $F("txtTransactionType");
		var issCd = ovrideCommPayts.issCd != null ? ovrideCommPayts.issCd : $F("txtBranchCd");
		var premSeqNo = ovrideCommPayts.premSeqNo != null ? ovrideCommPayts.premSeqNo : $F("txtPremSeqNo");
		var intmNo = ovrideCommPayts.intmNo != null ? ovrideCommPayts.intmNo : $F("txtIntmNo");
		var childIntmNo = ovrideCommPayts.childIntmNo != null ? ovrideCommPayts.childIntmNo : $F("txtChildIntmNo");

		for (var i = 0; i < $("txtTransactionType").options.length; i++) {
			if (parseInt(nvl($("txtTransactionType").options[i].value, 0)) == ovrideCommPayts.transactionType) {
				transactionType = $("txtTransactionType").options[i].value; //changed by steven 11.21.2014 $("txtTransactionType").options[i].text;
				break;
			}
		}
		//adjust amount columns to 103px kenneth @ fgic
		content = 
			'<label style="width: 140px;font-size: 10px; text-align: center;" id="lblTransactionType" 	name="lblTransactionType">'+transactionType+'</label>' +
			'<label style="width:  55px;font-size: 10px; text-align: center;" id="lblBillNo" 			name="lblBillNo">'+billNo+'</label>' +
			'<label style="width: 135px;font-size: 10px; text-align: center;" id="lblIntermediaryName" 	name="lblIntermediaryName">'+intermediaryName.truncate(17, "...")+'</label>' +
			'<label style="width: 135px;font-size: 10px; text-align: center;" id="lblChildIntmName" 	name="lblChildIntmName">'+childIntmName.truncate(17, "...")+'</label>' +
			'<label style="width: 103px;font-size: 10px; text-align: right;"  id="lblCommAmt" 			name="lblCommAmt">'+commAmt+'</label>' +
			'<label style="width: 103px;font-size: 10px; text-align: right;"  id="lblInputVAT" 			name="lblInputVAT">'+inputVAT+'</label>' +
			'<label style="width: 103px;font-size: 10px; text-align: right;"  id="lblWtaxAmt" 			name="lblWtaxAmt">'+wtaxAmt+'</label>' +
			'<label style="width: 103px;font-size: 10px; text-align: right;"  id="lblDrvCommAmt" 		name="lblDrvCommAmt">'+drvCommAmt+'</label>' +
			'<input type="hidden"	id="count"		name="count"	value="'+rowNum+'" />'+
			'<input type="hidden"	id="gocpGaccTranId'+rowNum+'"		name="gocpGaccTranId"		value="'+gaccTranId+'" />' +
			'<input type="hidden"	id="gocpTranType'+rowNum+'"			name="gocpTranType"			value="'+tranType+'" />' +
			'<input type="hidden"	id="gocpIssCd'+rowNum+'"			name="gocpIssCd"			value="'+issCd+'" />' +
			'<input type="hidden"	id="gocpPremSeqNo'+rowNum+'"		name="gocpPremSeqNo"		value="'+premSeqNo+'" />' +
			'<input type="hidden"	id="gocpIntmNo'+rowNum+'"			name="gocpIntmNo"			value="'+intmNo+'" />' +
			'<input type="hidden"	id="gocpChildIntmNo'+rowNum+'"		name="gocpChildIntmNo"		value="'+childIntmNo+'" />';

		return content;
	}

	// Generate bill no for specified overriding comm payts record
	function generateInitialItemValue(ovrideCommPayts) {
		ovrideCommPayts.billNo = (ovrideCommPayts.issCd.blank() || ovrideCommPayts.premSeqNo == null) ? "" : ovrideCommPayts.issCd + "-" + ovrideCommPayts.premSeqNo;

		ovrideCommPayts.oldDrvAmt2 = "";
		ovrideCommPayts.oldDrvAmt3 = "";
		ovrideCommPayts.oldDrvWtax = "";
		ovrideCommPayts.oldDrvInvat = "";

		ovrideCommPayts.vDrvCommAmt2 = nvl(ovrideCommPayts.commAmt, 0);
		ovrideCommPayts.vDrvCommAmt3 = nvl(ovrideCommPayts.drvCommAmt, 0);
		ovrideCommPayts.vDrvWtaxAmt = nvl(ovrideCommPayts.wtaxAmt, 0);
		ovrideCommPayts.vDrvInvatAmt = "";

		// the status of the record. 1 if changes have been made, 0 if added, -2 if previously added and then deleted, and null if no changes
		ovrideCommPayts.recordStatus = null;
	}

	// check if required fields have values
	function checkRequiredFields() {
		var ok = true;
		var reqArray = [/*"txtTransactionType",*/"txtBranchCd","txtPremSeqNo","txtIntermediaryName"
		                ,"txtChildIntmName","txtCommAmt","txtForeignCurrAmt",];
		
		$F("btnSaveRecord") == "Add" ? reqArray.push("txtTransactionType") : reqArray.push("txtDspTransactionType");

		for ( var i = 0; i < reqArray.length; i++) {
			if ($F(reqArray[i]).blank()) {
				ok = false;
				customShowMessageBox(objCommonMessage.REQUIRED, "I", reqArray[i]);
				break;
			}
			
		}
		return ok;
	}

	// Function to be executed when table row is clicked
	function clickOvrideCommPaytsRow(row) {
		$$("div#overridingCommPaytsTable div[name='rowOvrideCommPayts']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		currentRowNo = row.down("input", 0).value;

		if (row.hasClassName("selectedRow")) {
			populateDetails(currentRowNo);

			disableFields();

			//$("btnSaveRecord").value = "Update";
			disableButton("btnSaveRecord");
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
				objACGlobal.queryOnly == "Y" ? disableButton("btnDeleteRecord") : enableButton("btnDeleteRecord");
				objACGlobal.queryOnly == "Y" ? disableButton("btnSaveRecord") : enableButton("btnSaveRecord");
			}
			$("btnSaveRecord").value = "Update";
		} else {
			resetFields();
			if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
				objACGlobal.queryOnly == "Y" ? disableFields() : enableFields();
				objACGlobal.queryOnly == "Y" ? disableButton("btnSaveRecord") : enableButton("btnSaveRecord");
			}
			$("btnSaveRecord").value = "Add";
		}
	}
	// Populates input fields of Overriding Comm Payts details
	// @param - rowNum: the array index of the Overriding Comm Payts record to be displayed
	function populateDetails(rowNum) {
		var ovrideCommPayts = ovrideCommPaytsList[rowNum];

		// main details
		// change list box items to text fields
		// transaction type
		$("txtTransactionType").value = ovrideCommPayts.transactionType;
		$("txtTransactionType").style.display = "none";
		$("txtDspTransactionType").style.display = "inline";
		$("txtDspTransactionType").value = $("txtTransactionType").options[$("txtTransactionType").selectedIndex].text;

		// bill no
		/*$("txtBillNo").style.display = "none";
		$("txtDspBillNo").style.display = "inline";
		$("txtDspBillNo").value = ovrideCommPayts.issCd + "-" + ovrideCommPayts.premSeqNo;*/
		//added by steven 11.20.2014
		$("txtBranchCd").value = unescapeHTML2(ovrideCommPayts.issCd);
		$("txtPremSeqNo").value = (ovrideCommPayts.premSeqNo);
		disableSearch("searchBranchCd");
		disableSearch("searchPremSeqNo");

		// intermediary name
		$("txtIntermediaryName").style.display = "none";
		$("txtDspIntermediaryName").style.display = "inline";
		$("txtIntermediaryName").value = ovrideCommPayts.intermediaryName;
		$("txtDspIntermediaryName").value = ovrideCommPayts.intermediaryName;
		$("txtIntmNo").value = ovrideCommPayts.intmNo;

		// child intm
		$("txtChildIntmName").style.display = "none";
		$("txtDspChildIntmName").style.display = "inline";
		$("txtChildIntmName").value = ovrideCommPayts.childIntmName;
		$("txtDspChildIntmName").value = ovrideCommPayts.childIntmName;
		$("txtChildIntmNo").value = ovrideCommPayts.childIntmNo;
		
		$("txtCommAmt").value = ovrideCommPayts.commAmt == null ? "" : formatCurrency(ovrideCommPayts.commAmt);
		$("txtInputVAT").value = ovrideCommPayts.inputVAT == null ? "" : formatCurrency(ovrideCommPayts.inputVAT);
		$("txtWtaxAmt").value = ovrideCommPayts.wtaxAmt == null ? "" : formatCurrency(ovrideCommPayts.wtaxAmt);
		$("txtDrvCommAmt").value = ovrideCommPayts.drvCommAmt == null ? "" : formatCurrency(ovrideCommPayts.drvCommAmt);
		$("txtAssdName").value = unescapeHTML2(ovrideCommPayts.assdName); // added by robert 05.12.2014
		$("txtPolicyNo").value = ovrideCommPayts.policyNo;
		$("txtParticulars").value = ovrideCommPayts.particulars;

		// currency info
		$("txtCurrencyCd").value = ovrideCommPayts.currencyCd;
		$("txtConvertRate").value = ovrideCommPayts.convertRt;
		$("txtDspCurrencyDesc").value = ovrideCommPayts.currencyDesc;
		$("txtForeignCurrAmt").value = ovrideCommPayts.foreignCurrAmt == null ? "" : formatCurrency(ovrideCommPayts.foreignCurrAmt);

		// misc
		$("txtPrevCommAmt").value = "";
		$("txtPrevForCurrAmt").value = "";
		$("txtOldDrvAmt2").value = "";
		$("txtOldDrvAmt3").value = "";
		$("txtOldDrvWtax").value = "";
		$("txtOldDrvInvat").value = "";
		$("txtVDrvCommAmt2").value = "";
		$("txtVDrvCommAmt3").value = "";
		$("txtVDrvWtaxAmt").value = "";
		$("txtVDrvInvatAmt").value = "";

		lastCommAmt = $F("txtCommAmt").replace(/,/g,"");
		lastInputVAT = $F("txtInputVAT").replace(/,/g,"");
	}

	// reset fields
	function resetFields(execute) {
		currentRowNo = -1;

		var itemFields = ["TransactionType", "IntmNo", "IntermediaryName", "ChildIntmNo", "ChildIntmName", "CommAmt",
		          			"InputVAT", "WtaxAmt", "DrvCommAmt", "AssdName", "PolicyNo", "Particulars",
		          			"CurrencyCd", "ConvertRate", "DspCurrencyDesc", "ForeignCurrAmt", "PrevCommAmt",
		          			"OldDrvAmt2", "OldDrvAmt3", "OldDrvWtax", "VDrvCommAmt2", "VDrvCommAmt3", "VDrvWtaxAmt",
		          			"OldDrvInvat", "VDrvInvatAmt","BranchCd","PremSeqNo"];

		for (var i = 0; i < itemFields.length; i++) {
			if ((itemFields[i] == "TransactionType" && !execute) 
					|| itemFields[i] != "TransactionType"){
				$("txt"+itemFields[i]).value = "";
			}
		}
		$("txtBranchCd").setAttribute("lastValidValue", ""); //added by steven 11.20.2014
		$("txtPremSeqNo").setAttribute("lastValidValue", ""); //added by steven 11.20.2014
		
		lastCommAmt = "";
		lastInputVAT = "";
		lastWtaxAmt = "";

		//cleanListing("txtBillNo"); //remove by steven 11.19.2014
		/*cleanListing("txtIntermediaryName");	// commented out, drop-down changed to text field : shan 03.10.2015
		cleanListing("txtChildIntmName");*/

		// change back text field items to list box
		// transaction type
		$("txtTransactionType").style.display = "inline";
		$("txtDspTransactionType").style.display = "none";

		// bill no
		//$("txtBillNo").style.display = "inline"; //remove by steven 11.19.2014
		//$("txtDspBillNo").style.display = "none"; //remove by steven 11.19.2014

		// intermediary name
		$("txtIntermediaryName").style.display = "inline";
		$("txtDspIntermediaryName").style.display = "none";

		// child intm
		$("txtChildIntmName").style.display = "inline";
		$("txtDspChildIntmName").style.display = "none";

		//$("btnSaveRecord").value = "Add";
		if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
			enableButton("btnSaveRecord");
		}
		disableButton("btnDeleteRecord");
	}
	
	objGIACS040.resetFields = resetFields;

	// reset fields 2. resets the values of some variables
	function resetFields2() {
		var itemFields = [ "CommAmt", "InputVAT", "WtaxAmt", "DrvCommAmt", 
		           			"AssdName", "PolicyNo", "Particulars", "CurrencyCd", "ConvertRate", "DspCurrencyDesc",
		           			"ForeignCurrAmt", "PrevCommAmt", "OldDrvAmt2", "OldDrvAmt3", "OldDrvWtax",
		           			"VDrvCommAmt2", "VDrvCommAmt3", "VDrvWtaxAmt", "OldDrvInvat", "VDrvInvatAmt"];

		for (var i = 0; i < itemFields.length; i++) {
			$("txt"+itemFields[i]).value = "";
		}
	}
	
	// populates the dynamic LOV for bill no.
	/*function populateBillNoList(objArray) {
		cleanListing("txtBillNo");

		for (var i = 0; i < objArray.length; i++) {
			if (!billNoExists(objArray[i].issCd, objArray[i].premSeqNo)) {
				newOption = new Element("option");
				newOption.text = objArray[i].billNo;
				newOption.value = objArray[i].billNo;
				newOption.setAttribute("issCd", objArray[i].issCd);
				newOption.setAttribute("premSeqNo", objArray[i].premSeqNo);
	
				try {
				    $("txtBillNo").add(newOption, null); // standards compliant; doesn't work in IE
				  }
				catch(ex) {
				    $("txtBillNo").add(newOption); // IE only
				}
			}
		}

		$("txtBillNo").observe("change", function() {
			if (!$F("txtBillNo").blank()) {
				chckPremPayts();
			} 
			populateIntmList();
		});
	}*/

	// populates the dynamic LOV for intm no.
	//changed from td to span by robert 03.19.2014 so that txtDspIntermediaryName field will not be deleted
	function populateIntmList() {
		try {
			if (!$F("txtBranchCd").blank() && !$F("txtPremSeqNo").blank()) {
				var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
				var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
		
				new Ajax.Updater($("txtIntermediaryName").up("span", 0), contextPath+"/GIACOvrideCommPaytsController?action=getIntermediaryListing", {
					evalScripts: true,
					asynchronouse: false,
					method: "GET",
					parameters: {
						issCd: paramIssCd,
						premSeqNo: paramPremSeqNo,
						width: $("txtIntermediaryName").getWidth(),
						tabIndex: $("txtIntermediaryName").getAttribute("tabindex"),
						listId: "txtIntermediaryName",
						listName: "txtIntermediaryName",
						className: "required"
					},
					onCreate: function() {
						if (currentRowNo == -1) {
							$("txtIntermediaryName").up("span", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
						}
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							$("txtIntermediaryName").observe("change", function() {
								populateChildIntmList();
							});

							if (currentRowNo >= 0) {
								$("txtIntermediaryName").value = ovrideCommPaytsList[currentRowNo].intmNo;
								populateChildIntmList();
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			} else {
				cleanListing("txtIntermediaryName");
			}
			cleanListing("txtChildIntmName");
			resetFields2();
		} catch (e) {
			showErrorMessage("populateIntmList",e);
		}
	}

	// populates the dynamic LOV for child intm no.
	//changed from td to span by robert 03.19.2014 so that txtDspChildIntmName field will not be deleted
	function populateChildIntmList() {
		if (!$F("txtBranchCd").blank() && !$F("txtPremSeqNo").blank() && !$F("txtIntermediaryName").blank()) {
			var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
			var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
			var paramIntmNo = $F("txtIntermediaryName");
			
			new Ajax.Updater($("txtChildIntmName").up("span", 0), contextPath+"/GIACOvrideCommPaytsController?action=getChildIntmListing", {
				evalScripts: true,
				asynchronouse: false,
				method: "GET",
				parameters: {
					issCd: paramIssCd,
					premSeqNo: paramPremSeqNo,
					intmNo: paramIntmNo,
					distinct: nvl(childIntmDistinct, "N"),
					width: $("txtChildIntmName").getWidth(),
					tabIndex: $("txtChildIntmName").getAttribute("tabindex"),
					listId: "txtChildIntmName",
					listName: "txtChildIntmName",
					className: "required"
				},
				onCreate: function() {
					if (currentRowNo == -1) {
						$("txtChildIntmName").up("span", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
					}
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						$("txtChildIntmName").observe("change", function() {
							validateChildIntmNo();
						});

						if (currentRowNo >= 0) {
							$("txtChildIntmName").value = ovrideCommPaytsList[currentRowNo].childIntmNo;
						} else {
							resetFields2();
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} else {
			cleanListing("txtChildIntmName");
			resetFields2();
		}
	}

	// initializes an LOV listing
	function cleanListing(listName) {
		$(listName).innerHTML = "";

		var newOption = new Element("option");
		newOption.text = "Select...";
		newOption.value = "";

		/* if (listName == "txtBillNo") { //remove by steven 11.19.2014
			newOption.setAttribute("issCd", "");
			newOption.setAttribute("premSeqNo", "");
		} */

		try {
		    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
		  }
		catch(ex) {
		    $(listName).add(newOption); // IE only
		}
	}

	// updates the dynamic LOV for bill no. when transaction type is changed
	function updateBillNoList() {
		if ($F("txtTransactionType") == "1") {
			populateBillNoList(billNoList1);
		} else if ($F("txtTransactionType") == "2") {
			populateBillNoList(billNoList2);
		} else if ($F("txtTransactionType") == "3") {
			populateBillNoList(billNoList3);
		} else if ($F("txtTransactionType") == "4") {
			populateBillNoList(billNoList4);
		} else {
			//cleanListing("txtBillNo"); remove by steven 11.19.2014
			//added by steven 11.19.2014
			$("txtBranchCd").clear();
			$("txtPremSeqNo").clear();
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
		}
		cleanListing("txtIntermediaryName");
		cleanListing("txtChildIntmName");
		resetFields2();
	}

	// checks if there is already an existing record with specified iss cd and prem seq no (bill no)
	function billNoExists(issCd, premSeqNo) {
		var exists = false;
		
		for (var i = 0; i < ovrideCommPaytsList.length; i++) {
			if (ovrideCommPaytsList[i].issCd == issCd && ovrideCommPaytsList[i].premSeqNo == premSeqNo
					&& (ovrideCommPaytsList[i].recordStatus == null || ovrideCommPaytsList[i].recordStatus >= 0)) {
				exists = true;
				break;
			}
		}

		return exists;
	}

	function validateCommAmt() {
		var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
		var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
		var thisBill = '#' + objACGlobal.gaccTranId + '-' + $F("txtBranchCd") + '-' + $F("txtPremSeqNo") + '-'
						+ $F("txtIntmNo") + '-' + $F("txtChildIntmNo") + '#';
					
		new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=validateCommAmt", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				transactionType: $F("txtTransactionType"),
				issCd: paramIssCd,
				premSeqNo: paramPremSeqNo,
				intmNo: $F("txtIntmNo"), //$F("txtIntermediaryName"),
				childIntmNo: $F("txtChildIntmNo"), //$F("txtChildIntmName"),
				commAmt: $F("txtCommAmt").replace(/,/g,""),
				prevCommAmt: $F("txtPrevCommAmt").replace(/,/g,""),
				wtaxAmt: $F("txtWtaxAmt").replace(/,/g,""),
				foreignCurrAmt: $F("txtForeignCurrAmt").replace(/,/g,""),
				prevForCurrAmt: $F("txtPrevForCurrAmt").replace(/,/g,""),
				varForeignCurrAmt: varForeignCurrAmt,
				varForCurAmtDef: varForCurAmtDef,
				varWtaxAmt: varWtaxAmt,
				varCommAmtDef: varCommAmtDef,
				addUpdateBtn:	$F("btnSaveRecord"),
				currentBill: encodeURIComponent(thisBill)
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					$("txtCommAmt").value = result.commAmt.blank() ? "" : formatCurrency(result.commAmt);

					if (nvl(result.message, "SUCCESS") != "SUCCESS") {
						showWaitingMessageBox(result.message, imgMessage.INFO,
								function() {
									$("txtCommAmt").value = lastCommAmt.blank() ? "" : formatCurrency(lastCommAmt);
									$("txtCommAmt").focus();
								});
					} else {
						lastCommAmt = $F("txtCommAmt").replace(/,/g,"");
					}
					
					$("txtPrevCommAmt").value = result.prevCommAmt.blank() ? "" : result.prevCommAmt;
					$("txtWtaxAmt").value = result.wtaxAmt.blank() ? "" : formatCurrency(result.wtaxAmt);
					$("txtForeignCurrAmt").value = result.foreignCurrAmt.blank() ? "" : formatCurrency(result.foreignCurrAmt);
					$("txtPrevForCurrAmt").value = result.prevForCurrAmt;
					varForeignCurrAmt = result.varForeignCurrAmt;
					varForCurAmtDef = result.varForCurAmtDef;
					$("txtInputVAT").value = result.inputVAT.blank() ? "0.00" : formatCurrency(result.inputVAT);
					lastInputVAT = result.inputVAT;

					$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtInputVAT").replace(/,/g,""), $F("txtWtaxAmt").replace(/,/g,""), $F("txtCommAmt").replace(/,/g,"")));
					getRunningTotal();
					//lastCommAmt = $F("txtCommAmt").replace(/,/g,"");
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					$("txtCommAmt").value = lastCommAmt.blank() ? "0" : formatCurrency(lastCommAmt);
				}
			}
		});
	}

	function validateForeignCurrAmt() {
		var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
		var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
		var ok = true;
		
		new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=validateForeignCurrAmt", {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			parameters: {
				transactionType: $F("txtTransactionType"),
				issCd: paramIssCd,
				premSeqNo: paramPremSeqNo,
				intmNo: $F("txtIntmNo"), //$F("txtIntermediaryName"),
				childIntmNo: $F("txtChildIntmNo"), //$F("txtChildIntmName"),
				commAmt: $F("txtCommAmt").replace(/,/g,""),
				wtaxAmt: $F("txtWtaxAmt").replace(/,/g,""),
				drvCommAmt: $F("txtDrvCommAmt").replace(/,/g,""),
				foreignCurrAmt: $F("txtForeignCurrAmt").replace(/,/g,""),
				prevForCurrAmt: $F("txtPrevForCurrAmt").replace(/,/g,""),
				varForCurAmtDef: varForCurAmtDef,
				varCurrencyRt: varCurrencyRt
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (nvl(result.message, "SUCCESS") != "SUCCESS") {
						ok = false;
					}
				} else {
					ok = false;
				}
			}
		});

		return ok;
	}

	function validateFields() {
		var ok = true;

		if (isNaN($F("txtCommAmt").replace(/,/g,""))) {
			ok = false;
		} else if (parseFloat($F("txtCommAmt").replace(/,/g,"")) < - 9999999999.99 || parseFloat($F("txtCommAmt").replace(/,/g,"")) > 9999999999.99) {
			ok = false;
		} else if (isNaN($F("txtForeignCurrAmt").replace(/,/g,""))) {
			ok = false;
		} else if (parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) < - 9999999999.99 || parseFloat($F("txtForeignCurrAmt").replace(/,/g,"")) > 9999999999.99) {
			ok = false;
		} else if ($F("txtTransactionType").blank()) {
			ok = false;
		//} else if ($F("txtBillNo").blank()) { //remove by steven 11.20.2014
			//ok = false;
		} else if ($F("txtIntermediaryName").blank()) {
			ok = false;
		} else if ($F("txtChildIntmName").blank()) {
			ok = false;
		} else if ($F("txtCommAmt").blank()) {
			ok = false;
		} else if ($F("txtForeignCurrAmt").blank()) {
			ok = false;
		}

		ok = validateForeignCurrAmt();

		return ok;
	}

	function validateInputVAT() {
		var ok = true;
		var inputVAT = parseFloat(nvl($F("txtInputVAT").replace(/,/g,""), "0"));
		var commAmt  = parseFloat(nvl($F("txtCommAmt").replace(/,/g,""), "0"));
		
		if ($F("txtInputVAT").blank()) {
			$("txtInputVAT").value = "0";
		} else if (isNaN($F("txtInputVAT").replace(/,/g,""))) {
			showWaitingMessageBox("Invalid number.", imgMessage.ERROR,
					function() {
						$("txtInputVAT").value = lastInputVAT.blank() ? "" : formatCurrency(lastInputVAT);
						$("txtInputVAT").focus();
					}
				);
			ok = false;
		} else if (inputVAT < - 9999999999.99 || parseFloat($F("txtInputVAT").replace(/,/g,"")) > 9999999999.99) {
			showWaitingMessageBox("Field must be of form 9,999,999,999.00.", imgMessage.ERROR,
					function() {
						$("txtInputVAT").value = lastInputVAT.blank() ? "" : formatCurrency(lastInputVAT);
						$("txtInputVAT").focus();
					}
				);
			ok = false;
		} else if ($F("txtTransactionType") == "1") {
			if (inputVAT > commAmt) {
				showWaitingMessageBox("Input Vat Amount should not be greater than Overriding Commission", imgMessage.ERROR,
						function() {
							$("txtInputVAT").value = lastInputVAT.blank() ? "" : formatCurrency(lastInputVAT);
							$("txtInputVAT").focus();
						}
					);
				ok = false;
			} else if (inputVAT < 0) {
				showWaitingMessageBox("Amount entered is invalid", imgMessage.ERROR,
						function() {
							$("txtInputVAT").value = lastInputVAT.blank() ? "" : formatCurrency(lastInputVAT);
							$("txtInputVAT").focus();
						}
					);
				ok = false;
			}
		} else if ($F("txtTransactionType") == "2") {
			if (inputVAT < commAmt) {
				showWaitingMessageBox("Input Vat Amount should not be more than Overriding Commission", imgMessage.ERROR,
						function() {
							$("txtInputVAT").value = lastInputVAT.blank() ? "" : formatCurrency(lastInputVAT);
							$("txtInputVAT").focus();
						}
					);
				ok = false;
			} else if (inputVAT > 0) {
				showWaitingMessageBox("Amount entered is invalid", imgMessage.ERROR,
						function() {
							$("txtInputVAT").value = lastInputVAT.blank() ? "" : formatCurrency(lastInputVAT);
							$("txtInputVAT").focus();
						}
					);
				ok = false;
			}
		}

		return ok;
	}

	// enable text fields and dropdown lists
	function enableFields() {
		// enable fields
		$("txtTransactionType").enable();
		//$("txtBillNo").enable();
		//added by steven 11.20.2014
		$("txtBranchCd").readOnly = false;
		$("txtPremSeqNo").readOnly = false;
		enableSearch("searchBranchCd");
		enableSearch("searchPremSeqNo");
		//end
		$("txtIntermediaryName").enable();
		$("txtChildIntmName").enable();
		$("txtCommAmt").readOnly = false;
		$("txtInputVAT").readOnly = false;
		$("txtForeignCurrAmt").readOnly = false;
		$("txtParticulars").readOnly = false;
	}

	// disable text fields and dropdown lists
	function disableFields() {
		// disable fields
		$("txtTransactionType").disable();
		//$("txtBillNo").disable();
		//added by steven 11.20.2014
		$("txtBranchCd").readOnly = true;
		$("txtPremSeqNo").readOnly = true;
		disableSearch("searchBranchCd");
		disableSearch("searchPremSeqNo");
		//end
		
		$("txtIntermediaryName").disable();
		$("txtChildIntmName").disable();
		$("txtCommAmt").readOnly = (objACGlobal.tranFlagState == "O" && ($F("txtTransactionType") != "2" && $F("txtTransactionType") != 4)) ? false : true;	// updateable if tran is still open
		$("txtInputVAT").readOnly = (objACGlobal.tranFlagState == "O" && ($F("txtTransactionType") != "2" && $F("txtTransactionType") != 4)) ? false : true; // updateable if tran is still open
		$("txtForeignCurrAmt").readOnly = true;
		$("txtParticulars").readOnly = true;
	}

	/** end of page functions **/
	
	/** module functions **/
	
	// procedure CHCK_PREM_PAYTS
	function chckPremPayts(execute) {
		var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
		var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");

		new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=chckPremPayts", {
			evalScripts: true,
			asynchrnous: false,
			method: "GET",
			parameters: {
				issCd: paramIssCd,
				premSeqNo: paramPremSeqNo,
				varWithPrem: varWithPrem,
				varPremAmt: varPremAmt
			},
			onCreate : function() {
				showNotice("Checking Premium Payments, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (nvl(result.message, "SUCCESS") != "SUCCESS" && result.noPremPayt == "N") {
						showWaitingMessageBox(result.message, imgMessage.INFO,
								function() {
									//chckBalance(false, execute);
									if (execute){
										objGIACS040.addRemoveRecordFromList(false);
									}
									resetFields(execute);
									resetFields2();
								});
						//$("txtBillNo").value = "";
						
							$("txtBranchCd").clear();
							$("txtBranchCd").setAttribute("lastValidValue", ""); //added by steven 11.20.2014
							$("txtPremSeqNo").clear();
							$("txtPremSeqNo").setAttribute("lastValidValue", ""); //added by steven 11.20.2014
							resetFields(execute);
							resetFields2();
						
					} else {
						chckBalance(true, execute);
					}

					varWithPrem = result.varWithPrem;
					varPremAmt = result.varPremAmt;
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	objGIACS040.chckPremPayts = chckPremPayts;

	// procedure CHCK_BALANCE
	// ok means that if there are no previous messages, display messages on this procedure. otherwise, do not display
	function chckBalance(ok, execute) {
		var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
		var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");

		new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=chckBalance", {
			evalScripts: true,
			asynchrnous: false,
			method: "POST",
			parameters: {
				issCd: paramIssCd,
				premSeqNo: paramPremSeqNo,
				moduleName: "GIACS040",
				varSwitch: varSwitch
			},
			onCreate : function() {
				showNotice("Checking Balance, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (nvl(result.message, "SUCCESS") != "SUCCESS") {
						/*if (result.message == "NOT_FULLY_PAID_OVERRIDE" && ok) {
							/*showConfirmBox("", "This Policy is not yet Fully Paid. Do you wish to Override?", "Yes", "No",
											function() {}, function() {
													resetFields();
													resetFields2();
												});*/
							showConfirmBox("CONFIRMATION", "Premium of this policy is still unpaid/partially paid. Would you like to continue with the commission payment?",
									"Yes", "No",
									function(){
										if (result.noPremPayt == "N" && result.accessMC == "FALSE"){
											showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
													"Yes", "No",
													function() {
														showGenericOverride("GIACS040", "MC",
																function(ovr, userId, res){
																	if(res == "FALSE"){
																		//showMessageBox( userId + " is not allowed to edit the DV Payee and Particulars.", imgMessage.ERROR);
																		showMessageBox(userId + " is not allowed to process payments for unpaid premium.", imgMessage.ERROR);
																		$("txtOverrideUserName").clear();
																		$("txtOverridePassword").clear();
																		return false;
																	} else if(res == "TRUE"){
																		ovr.close();
																		if (execute){
																			objGIACS040.addRemoveRecordFromList(true);
																		}
																		delete ovr;
																	}
																},
																function() {
																	if (execute){
																		objGIACS040.addRemoveRecordFromList(false);
																	}
																	resetFields();
																	resetFields2();
																}
														);
													},
													function(){	// no for USER confirmation
														if (execute){
															objGIACS040.addRemoveRecordFromList(false);
														}
														resetFields();
														resetFields2();
													}
											);
										}else{
											if (execute){
												objGIACS040.addRemoveRecordFromList(true);
											}
										}
									},
									function(){	// no for commission payment
										if (execute){
											objGIACS040.addRemoveRecordFromList(false);
										}
										resetFields();
										resetFields2();
									}
							);
						/*} else {
							if (ok) {
								showMessageBox(result.message, imgMessage.INFO);
							}
							//$("txtBillNo").value = "";
							$("txtBranchCd").clear();
							$("txtPremSeqNo").clear();
							$("txtBranchCd").setAttribute("lastValidValue", ""); //added by steven 11.20.2014
							$("txtPremSeqNo").setAttribute("lastValidValue", ""); //added by steven 11.20.2014
						}*/
					}else{
						if (execute){
							objGIACS040.addRemoveRecordFromList(true);
						}
					}

					varSwitch = result.varSwitch;
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	// WHEN-VALIDATE-ITEM trigger of CHILD_INTM_NO
	function validateChildIntmNo() {
		if (!$F("txtChildIntmName").blank()) {
			var paramIssCd = $F("txtBranchCd"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("issCd");
			var paramPremSeqNo = $F("txtPremSeqNo"); //added by steven 11.20.2014 $F("txtBillNo").blank() ? "" : $("txtBillNo").options[$("txtBillNo").selectedIndex].readAttribute("premSeqNo");
			
			var obj = createBillParams();
			new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=validateChildIntmNo", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					transactionType: $F("txtTransactionType"),
					issCd: paramIssCd,
					premSeqNo: paramPremSeqNo,
					intmNo: $F("txtIntermediaryName"),
					childIntmNo: $F("txtChildIntmName"),
					intermediaryName: '',//$("txtIntermediaryName").innerHTML,
					childIntmName: '',//$("txtChildIntmName").innerHTML,
					policyNo: $F("txtPolicyNo"),
					assdName: $F("txtAssdName"),
					commAmt: $F("txtCommAmt").blank ? "" : $F("txtCommAmt").replace(/,/g,""),
					inputVAT: $F("txtInputVAT").blank ? "" : $F("txtInputVAT").replace(/,/g,""),
					wtaxAmt: $F("txtWtaxAmt").blank ? "" : $F("txtWtaxAmt").replace(/,/g,""),
					foreignCurrAmt: $F("txtForeignCurrAmt").blank ? "" : $F("txtForeignCurrAmt").replace(/,/g,""),
					prevCommAmt: $F("txtPrevCommAmt").blank ? "" : $F("txtPrevCommAmt").replace(/,/g,""),
					prevForCurrAmt: $F("txtPrevForCurrAmt").blank ? "" : $F("txtPrevForCurrAmt").replace(/,/g,""),
					convertRt: $F("txtConvertRate"),
					currencyCd: $F("txtCurrencyCd"),
					currencyDesc: $F("txtDspCurrencyDesc"),
					varWithPrem: nvl(varWithPrem,0), //added by steven 11.21.2014
					varCommAmt: varCommAmt,
					varCommAmtDef: varCommAmtDef,
					varForCurAmtDef: varForCurAmtDef,
					varPremAmt: varPremAmt,
					varPercentage: varPercentage,
					varPremiumPayts: varPremiumPayts,
					varWtaxAmt: varWtaxAmt,
					varForeignCurrAmt: varForeignCurrAmt,
					varSwitch: varSwitch,
					varCurrencyRt: varCurrencyRt,
					varCurrencyCd: varCurrencyCd,
					varCurrencyDesc: varCurrencyDesc,
					deletedBills:	obj.deletedBills
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();

						if (nvl(result.message, "SUCCESS") == "SUCCESS") {
							$("txtIntermediaryName").value = result.intermediaryName;
							$("txtChildIntmName").value = result.childIntmName;
							$("txtPolicyNo").value = result.policyNo;
							$("txtAssdName").value = result.assdName;
							$("txtCommAmt").value = result.commAmt.blank() ? "" : formatCurrency(result.commAmt);
							$("txtInputVAT").value = result.inputVAT.blank() ? "" : formatCurrency(result.inputVAT);
							$("txtWtaxAmt").value = result.wtaxAmt.blank() ? "" : formatCurrency(result.wtaxAmt);
							$("txtForeignCurrAmt").value = result.foreignCurrAmt.blank() ? "" : formatCurrency(result.foreignCurrAmt);
							$("txtPrevCommAmt").value = result.prevCommAmt;
							$("txtPrevForCurrAmt").value = result.prevForCurrAmt;
							$("txtConvertRate").value = result.convertRt;
							$("txtCurrencyCd").value = result.currencyCd;
							$("txtDspCurrencyDesc").value = result.currencyDesc;
							varWithPrem = result.varWithPrem;
							varCommAmt = result.varCommAmt;
							varCommAmtDef = result.varCommAmtDef;
							varForCurAmtDef = result.varForCurAmtDef;
							varPremAmt = result.varPremAmt;
							varPercentage = result.varPercentage;
							varPremiumPayts = result.varPremiumPayts;
							varWtaxAmt = result.varWtaxAmt;
							varForeignCurrAmt = result.varForeignCurrAmt;
							varSwitch = result.varSwitch;
							varCurrencyRt = result.varCurrencyRt;
							varCurrencyCd = result.varCurrencyCd;
							varCurrencyDesc = result.varCurrencyDesc;

							lastCommAmt = $F("txtCommAmt").replace(/,/g,"");
							lastInputVAT = $F("txtInputVAT").replace(/,/g,"");

							$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtInputVAT").replace(/,/g,""), $F("txtWtaxAmt").replace(/,/g,""), $F("txtCommAmt").replace(/,/g,"")));

							if ($F("txtCommAmt").blank()) {
								getTotals();
							} else {
								getRunningTotal();
							}
						} else if (result.message == "COMMISSION_FULLY_PAID") {
							showWaitingMessageBox("Commission is Fully Paid.", imgMessage.ERROR,
													function () {
														resetFields();
														resetFields2();
													});
						} else if (result.message == "CANNOT_RELEASE_COMMISSION") {
							showWaitingMessageBox("Cannot Release Commission. Make additional Premium Payments.", imgMessage.ERROR,
													function () {
														resetFields();
														resetFields2();
													});
						} else {
							showMessageBox(result.message, imgMessage.INFO);
							$("txtChildIntmName").value = "";
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} else {
			resetFields2();
		}
	}

	// procedure CGFD$GET_GOCP_DRV_COMM_AMT
	function getDrvCommAmt(pInputVAT, pWtaxAmt, pCommAmt) {
		if (isNaN(pWtaxAmt)) {
			return 0;
		} else {
			var pDrvCommAmt = parseFloat(nvl(pCommAmt, 0)) + parseFloat(nvl(pInputVAT, 0)) - parseFloat(pWtaxAmt);
			varDrvCommAmtDef = pDrvCommAmt;
			return pDrvCommAmt;
		}
	}

	// procedure CGFD$GET_GOCP_DRV_COMM_AMT2
	function getDrvCommAmt2(pCommAmt) {
		var pDrvCommAmt2 = pCommAmt.blank() ? "" : parseFloat(pCommAmt);
		varDrvCommAmt2Def = pDrvCommAmt2;
		return pDrvCommAmt2;
	}

	// procedure CGFD$GET_GOCP_DRV_WTAX_AMT
	function getDrvWtaxAmt(pWtaxAmt) {
		return pWtaxAmt.blank() ? "" : parseFloat(pWtaxAmt);
	}

	// procedure CGFD$GET_GOCP_DRV_COMM_AMT3
	function getDrvCommAmt3(pDrvCommAmt) {
		var pDrvCommAmt3 = pDrvCommAmt.blank() ? "" : parseFloat(pDrvCommAmt);
		varDrvCommAmt3Def = pDrvCommAmt3;
		return pDrvCommAmt3;
	}

	// procedure CGFD$GET_GOCP_DRV_INVAT_AMT
	function getDrvInvatAmt(pInputVAT) {
		var pDrvInvatAmt = pInputVAT.blank() ? "" : parseFloat(pInputVAT);
		varDrvInvatAmtDef = pDrvInvatAmt;
		return pDrvInvatAmt;
	}

	// procedure GET_TOTALS
	function getTotals() {
		$("txtDrvCommAmt").value = formatCurrency(getDrvCommAmt($F("txtInputVAT").replace(/,/g,""), $F("txtWtaxAmt").replace(/,/g,""), $F("txtCommAmt").replace(/,/g,"")));
		controlDrvCommAmt2 = getDrvCommAmt2($F("txtCommAmt").replace(/,/g,""));
		controlDrvWtaxAmt = getDrvWtaxAmt($F("txtWtaxAmt").replace(/,/g,""));
		controlDrvCommAmt3 = getDrvCommAmt3($F("txtDrvCommAmt").replace(/,/g,""));
		controlDrvInvatAmt = getDrvInvatAmt($F("txtInputVAT").replace(/,/g,""));
	}

	// procedure GET_RUNNING_TOTAL
	function getRunningTotal() {
		$("txtOldDrvAmt2").value = nvl($F("txtVDrvCommAmt2"), 0);
		$("txtOldDrvAmt3").value = nvl($F("txtVDrvCommAmt3"), 0);
		$("txtOldDrvWtax").value = nvl($F("txtVDrvWtaxAmt"), 0);
		$("txtOldDrvInvat").value = nvl($F("txtVDrvInvatAmt"), 0);
		$("txtVDrvCommAmt2").value = nvl($F("txtCommAmt").replace(/,/g,""), 0);
		$("txtVDrvCommAmt3").value = nvl($F("txtDrvCommAmt").replace(/,/g,""), 0);
		$("txtVDrvWtaxAmt").value = nvl($F("txtWtaxAmt").replace(/,/g,""), 0);
		$("txtVDrvInvatAmt").value = nvl($F("txtInputVAT").replace(/,/g,""), 0);

		controlDrvCommAmt2 = parseFloat(nvl(controlDrvCommAmt2, 0)) - parseFloat(nvl($F("txtOldDrvAmt2"), 0)) + parseFloat(nvl($F("txtVDrvCommAmt2"), 0));
		controlDrvWtaxAmt = parseFloat(nvl(controlDrvWtaxAmt, 0)) - parseFloat(nvl($F("txtOldDrvWtax"), 0)) + parseFloat(nvl($F("txtVDrvWtaxAmt"), 0));
		controlDrvCommAmt3 = parseFloat(nvl(controlDrvCommAmt3, 0)) - parseFloat(nvl($F("txtOldDrvAmt3"), 0)) + parseFloat(nvl($F("txtVDrvCommAmt3"), 0));
		controlDrvInvatAmt = parseFloat(nvl(controlDrvInvatAmt, 0)) - parseFloat(nvl($F("txtOldDrvInvat"), 0)) + parseFloat(nvl($F("txtVDrvInvatAmt"), 0));

		$("txtOldDrvAmt2").value = nvl($F("txtVDrvCommAmt2"), 0);
		$("txtOldDrvAmt3").value = nvl($F("txtVDrvCommAmt3"), 0);
		$("txtOldDrvWtax").value = nvl($F("txtVDrvWtaxAmt"), 0);
		$("txtOldDrvInvat").value = nvl($F("txtVDrvInvatAmt"), 0);
	}
	
	/** end of module functions **/
	
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS040(){
		try {
			$("txtTransactionType").removeClassName("required");
			$("txtTransactionType").disable();
			//$("txtBillNo").removeClassName("required"); //remove by steven 11.20.2014
			//$("txtBillNo").disable(); //remove by steven 11.20.2014
			$("txtIntermediaryName").removeClassName("required");
			$("txtIntermediaryName").disable();
			$("txtChildIntmName").removeClassName("required");
			$("txtChildIntmName").disable();
			$("txtCommAmt").readOnly = true;
			$("txtCommAmt").removeClassName("required");
			$("txtInputVAT").readOnly = true;
			$("txtWtaxAmt").removeClassName("required");
			$("txtParticulars").readOnly = true;
			$("txtForeignCurrAmt").readOnly = true;
			$("txtDspTransactionType").removeClassName("required");
			//$("txtDspBillNo").removeClassName("required"); //remove by steven 11.20.2014
			$("txtDspIntermediaryName").removeClassName("required");
			$("txtDspChildIntmName").removeClassName("required");			
			disableButton("btnSaveRecord");
			disableButton("btnSaveOvrideCommPayts");
			//added by steven 11.20.2014
			$("txtBranchCd").removeClassName("required");
			$("txtPremSeqNo").removeClassName("required");
			$("spanBranchCd").removeClassName("required");
			$("spanPremSeqNo").removeClassName("required");
			disableSearch("searchBranchCd");
			disableSearch("searchPremSeqNo");
			
		} catch(e){
			showErrorMessage("disableGIACS040", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS040();
	}
	
	$("acExit").stopObserving("click"); 
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveOutFaculPremPayts();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
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
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
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
	//added by steven 11.19.2014
	initializeAll();
	makeInputFieldUpperCase();
	
	function resetField3(listArray) {
		try {
			for ( var i = 0; i < listArray.length; i++) {
				cleanListing(listArray[i]);
			}
			resetFields2();
		} catch (e) {
			showErrorMessage("resetField3",e);
		}
	}
	
	function getGiacs040BranchCdLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs040BranchCdLOV",
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "")
			},
			title: "List of Issue Codes",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "branchCd",
								title: "Issue Code",
								width: '88px'
							},
							{	id : "branchName",
								title: "Issue Name",
								width: '300px'
							}
						],
			draggable: true,
			filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchCd").setAttribute("lastValidValue", row.branchCd);
					$("txtPremSeqNo").value = "";
					$("txtPremSeqNo").setAttribute("lastValidValue", "");
					$("txtPremSeqNo").focus();
					//resetField3(["txtIntermediaryName","txtChildIntmName"]);
				}
			},
	  		onCancel: function(){
	  			$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	objGIACS040.notInParam = new Object();
	
	function createBillParams(){
		var obj = new Object();
		var newBills = '#';
		var deletedBills = '#';
		
		for (var i=0; i < ovrideCommPaytsList.length; i++){
			var row = ovrideCommPaytsList[i];
			var bill = null;
			
			if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4){
				bill = row.issCd + "-" + row.premSeqNo + "-" + row.intmNo + "-" + row.childIntmNo + "-" +row.commAmt + '#';
			}else{
				bill = objACGlobal.gaccTranId + "-" +row.issCd + "-" + row.premSeqNo + "-" + row.intmNo + "-" + row.childIntmNo + '#';
			}
			
			if ($F("txtTransactionType") == row.transactionType && (row.recordStatus != null && (row.recordStatus != -1 && row.recordStatus != -2))){
				newBills = newBills + bill;
			} 
		}
		
		for (var i=0; i < deletedBillList.length; i++){
			var row = deletedBillList[i];
			var bill = null;
			
			if ($F("txtTransactionType") == 2 || $F("txtTransactionType") == 4){
				bill = row.issCd + "-" + row.premSeqNo + "-" + row.intmNo + "-" + row.childIntmNo + "-" +row.commAmt + '#';
			}else{
				bill = objACGlobal.gaccTranId + "-" +row.issCd + "-" + row.premSeqNo + "-" + row.intmNo + "-" + row.childIntmNo + '#';
			}

			if ($F("txtTransactionType") == row.transactionType && (row.recordStatus == -1 || row.recordStatus == -2)){
				deletedBills = deletedBills + bill;
			}
		}
		
		obj.newBills = newBills == "#" ? '' : newBills;
		obj.deletedBills = deletedBills == "#" ? '' : deletedBills;
		return obj;
	}
	
	function populateFields(row, execute){
		if (nvl(row, 1) == 1){
			return;
		}
		if (!execute){
			$("txtTransactionType").value = row.tranType;
		}
		$("txtBranchCd").value = row.branchCd;
		$("txtPremSeqNo").value = row.premSeqNo;
		$("txtPremSeqNo").setAttribute("lastValidValue", row.premSeqNo);
		//$("txtIntermediaryName").focus();
		$("txtIntmNo").value = row.intmNo;
		$("txtIntermediaryName").value = escapeHTML2(row.intmName);
		$("txtChildIntmNo").value = row.chldIntmNo;
		$("txtChildIntmName").value = escapeHTML2(row.chldIntmName);
		$("txtCommAmt").value = row.ovridingCommAmt == null ? "" : formatCurrency(row.ovridingCommAmt);
		$("txtInputVAT").value = row.inputVAT == null ? "" : formatCurrency(row.inputVAT);
		$("txtWtaxAmt").value = row.wtaxAmt == null ? "" : formatCurrency(row.wtaxAmt);
		$("txtDrvCommAmt").value = row.netComm == null ? "" : formatCurrency(row.netComm);
		$("txtPolicyNo").value = escapeHTML2(row.policyNo);
		$("txtAssdName").value = escapeHTML2(row.assdName);
		$("txtForeignCurrAmt").value = row.foreignCurrAmt.blank == null ? "" : formatCurrency(row.foreignCurrAmt);
		$("txtPrevCommAmt").value = row.prevCommAmt;
		$("txtPrevForCurrAmt").value = row.prevForCurrAmt;
		$("txtConvertRate").value = row.convertRt;
		$("txtCurrencyCd").value = row.currencyCd;
		$("txtDspCurrencyDesc").value = escapeHTML2(row.currencyDesc);
		
		lastCommAmt = $F("txtCommAmt").replace(/,/g,"");
		lastInputVAT = $F("txtInputVAT").replace(/,/g,"");
		
		if (execute || execute == null){
			validateBill(execute);
		}else{
			$("btnSaveRecord").click();
		}
		
	}
	
	function validateBill(execute){
		new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=validateBill", {
			evalScripts: true,
			asynchrnous: false,
			method: "POST",
			parameters: {
				tranType: $F("txtTransactionType"),
				issCd: $F("txtBranchCd"),
				premSeqNo: $F("txtPremSeqNo")
			},
			onCreate : function() {
				showNotice("Validating bill, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					var message = response.responseText;
					if (nvl(message, "SUCCESS") == "SUCCESS"){
						chckPremPayts(execute);
					}else{
						showMessageBox(message, "I");
						if (execute){
							objGIACS040.addRemoveRecordFromList(false);
						}
						resetFields(true);
					}					
				}
			}
		});	
	}
	
	objGIACS040.populateFields = populateFields;
	
	function getGiacs040BillNoLOV(){
		if ($F("txtTransactionType").blank() || $F("txtBranchCd").blank()) {
			showMessageBox("Please select a transaction type and issue source first.", "E");
			return false;
		}
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs040BillNoLOV",
				branchCd : $F("txtBranchCd"),
				tranType : $F("txtTransactionType"),
				filterText : ($("txtPremSeqNo").readAttribute("lastValidValue").trim() != $F("txtPremSeqNo").trim() ? $F("txtPremSeqNo").trim() : "")
			},
			title: "List of Bill Numbers",
			width: 405,
			height: 386,
			columnModel:[
			             	{	id : "branchCd",
								title: "Issue Code",
								width: '150px'
							},
							{	id : "premSeqNo",
								title: "Premium Seq. No.",
								width: '220px'
							}
						],
			draggable: true,
			filterText : ($("txtPremSeqNo").readAttribute("lastValidValue").trim() != $F("txtPremSeqNo").trim() ? $F("txtPremSeqNo").trim() : "%"),
			autoSelectOneRecord: true,
			onSelect : function(row){
				if(row != undefined) {
					$("txtPremSeqNo").value = row.premSeqNo;
					$("txtPremSeqNo").setAttribute("lastValidValue", row.premSeqNo);
					$("txtIntermediaryName").focus();
					chckPremPayts();
					populateIntmList();
				}
			},
	  		onCancel: function(){
	  			$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("lastValidValue");
	  		},
	  		onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});		
	}
	
	$("searchBranchCd").observe("click", getGiacs040BranchCdLOV);
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd").trim() == ""){
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtPremSeqNo").value = "";
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
			//resetField3(["txtIntermediaryName","txtChildIntmName"]);
			$("txtIntmNo").clear();
			$("txtChildIntmNo").clear();
			$("txtIntermediaryName").clear();
			$("txtChildIntmName").clear();
			resetFields2();
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getGiacs040BranchCdLOV();
			}
		}
	});
	
	$("searchPremSeqNo").observe("click", showBillNoOverlay); //getGiacs040BillNoLOV);
	
	objGIACS040.premSeqNo = null;
	
	function showBillNoOverlay(showAll){
		objGIACS040.notInParam = createBillParams();
		
		objGIACS040.tranType = $F("txtTransactionType");
		
		if (!showAll){
			objGIACS040.premSeqNo =	$F("txtPremSeqNo");
		}else{
			objGIACS040.premSeqNo = '';
		}
		
		ovrideCommOverlay = Overlay.show(contextPath +"/GIACOvrideCommPaytsController?action=getOvrideCommList&tranType="+$F("txtTransactionType")+
											"&branchCd="+$F("txtBranchCd")+"&premSeqNo="+objGIACS040.premSeqNo+
											"&newBills="+encodeURIComponent(objGIACS040.notInParam.newBills)+
											"&deletedBills="+encodeURIComponent(objGIACS040.notInParam.deletedBills), {
			asynchronous : false,
			urlContent: true,
			draggable: true,
			onCreate : showNotice("Loading, please wait..."),
			//urlParameters: {
			//},
		    title: "Bill Numbers",
		    height: 400,
		    width: 900
		});
	}
	
	function validateTranType(){
		new Ajax.Request(contextPath+"/GIACOvrideCommPaytsController?action=validateTranRefund", {
			evalScripts: true,
			asynchrnous: false,
			method: "GET",
			parameters: {
				tranType: $F("txtTransactionType"),
				issCd: $F("txtBranchCd"),
				premSeqNo: $F("txtPremSeqNo")
			},
			onCreate : function() {
				showNotice("Validating record, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					var message = response.responseText;

					if (nvl(message, "SUCCESS") == "SUCCESS") {
						showBillNoOverlay(false);
					} else {
						showMessageBox(message, imgMessage.INFO);
						$("txtPremSeqNo").setAttribute("lastValidValue", "");
						$("txtIntmNo").clear();
						$("txtChildIntmNo").clear();
						$("txtIntermediaryName").clear();
						$("txtChildIntmName").clear();
						resetFields2();
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});	
	}
	
	$("txtPremSeqNo").observe("change", function(){
		if($F("txtPremSeqNo").trim() == ""){
			$("txtPremSeqNo").value = "";
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
			//resetField3(["txtIntermediaryName","txtChildIntmName"]);
			$("txtIntermediaryName").clear();
			$("txtChildIntmName").clear();
			resetFields2();
		} else {
			if($F("txtPremSeqNo").trim() != "" && $F("txtPremSeqNo") != $("txtPremSeqNo").readAttribute("lastValidValue")) {
				if ($F("txtTransactionType") == "2" || $F("txtTransactionType") == "4"){
					validateTranType();
				}else{
					//getGiacs040BillNoLOV();
					showBillNoOverlay(false);
				}
			}
		}
	});
</script>