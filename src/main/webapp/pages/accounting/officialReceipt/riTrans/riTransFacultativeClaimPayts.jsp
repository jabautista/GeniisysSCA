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
<div class="sectionDiv" id="overridingCommDiv" name="overridingCommDiv">
	<!-- page variables -->
	<input type="hidden" id="txtClaimId" 			name="txtClaimId"  			value=""/>
	<input type="hidden" id="txtClmLossId" 			name="txtClmLossId"  		value=""/>
	<input type="hidden" id="txtAdviceId" 			name="txtAdviceId"  		value=""/>
	<input type="hidden" id="txtPayeeClassCd" 		name="txtPayeeClassCd"  	value=""/>
	<input type="hidden" id="txtPayeeCd" 			name="txtPayeeCd"  			value=""/>
	<input type="hidden" id="txtPayeeType" 			name="txtPayeeType"  		value=""/>
	<input type="hidden" id="txtVCheck" 			name="txtVCheck"  			value="0"/>
	<input type="hidden" id="txtOrPrintTag"			name="txtOrPrintTag"		value="N"/>
	<input type="hidden" id="txtDspPerilSname"		name="txtDspPerilSname"		value=""/>
	
	<jsp:include page="subPages/faculClaimPaytsListingTable.jsp"></jsp:include>
	
	<table align="center" style="margin: 10px">
		<tr>
			<td class="rightAligned" style="width: 180px">Transaction Type</td>
			<td class="leftAligned"	 style="width: 250px;">
				<select id="txtTransactionType" name="txtTransactionType" class="required" style="width: 250px" tabindex=1>
					<option value=""></option>
					<c:forEach var="tranType" items="${transactionTypeList }" varStatus="ctr">
						<option value="${tranType.rvLowValue }">${tranType.rvMeaning }</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width: 120px">Claim No.</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDspClaimNo" name="txtDspClaimNo" maxlength="30" readonly="readonly" style="width: 234px" tabindex=12></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Advice No.</td>
			<td class="leftAligned"	 style="width: 250px;">
				<select id="txtDspLineCd" name="txtDspLineCd" class="required" style="width: 52px" tabindex=2>
					<option value=""></option>
				</select>
				<select id="txtDspIssCd" name="txtDspIssCd" class="required" style="width: 60px" tabindex=3>
					<option value=""></option>
				</select>
				<span>
				<select id="txtDspAdviceYear" name="txtDspAdviceYear" class="required" style="width: 62px" tabindex=4>
					<option value=""></option>
				</select>
				</span>
				<span>
				<select id="txtDspAdviceSeqNo" name="txtDspAdviceSeqNo" class="required" style="width: 62px" tabindex=5>
					<option value="" claimId=""></option>
				</select>
				</span>
			</td>
			<td class="rightAligned" style="width: 120px">Policy No.</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDspPolicyNo" name="txtDspPolicyNo" maxlength="30" readonly="readonly" style="width: 234px" tabindex=13></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Payee Class</td>
			<td class="leftAligned"	 style="width: 250px;">
				<select id="txtDspPayeeDesc" name="txtDspPayeeDesc" class="required" style="width: 250px" tabindex=6>
					<option value=""></option>
				</select>
			</td>
			<td class="rightAligned" style="width: 120px">Payee</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDspPayeeName" name="txtDspPayeeName" maxlength="800" readonly="readonly" style="width: 234px" tabindex=14></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Peril</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtDspPerilName" name="txtDspPerilName" readonly="readonly" maxlength="20" style="width: 240px" tabindex=7></input>
			</td>
			<td class="rightAligned" style="width: 120px">Assured Name</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtDspAssuredName" name="txtDspAssuredName" maxlength="100" readonly="readonly" style="width: 234px" tabindex=15></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Disbursement Amount</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtDisbursementAmt" name="txtDisbursementAmt" class="required" maxlength="20" readonly="readonly" style="width: 240px; text-align: right" tabindex=8>
			</td>
			<td class="rightAligned" style="width: 120px">Remarks</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtRemarks" class="txtReadOnly" name="txtRemarks" maxlength="500" style="width: 234px" tabindex=16></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Input Tax</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtInputVATAmt" name="txtInputVATAmt" maxlength="20" readonly="readonly" style="width: 240px; text-align: right" tabindex=9>
			</td>
			<td class="rightAligned" style="width: 120px"></td>
			<td style="width: 260px;text-align: center">
				<input type="button" class="button" style="width: 150px;font-size: 12px;text-align: center" id="btnCurrButton" name="btnCurrButton" value="Currency Information" tabindex=17></input>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Withholding Tax</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtWholdingTaxAmt" name="txtWholdingTaxAmt" maxlength="20" readonly="readonly" style="width: 240px; text-align: right" tabindex=10>
			</td>
			<td class="rightAligned" style="width: 120px"></td>
			<td style="width: 260px;text-align: center"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px">Net Disbursement</td>
			<td class="leftAligned"	 style="width: 250px;">
				<input type="text" id="txtNetDisbAmt" name="txtNetDisbAmt" maxlength="20" readonly="readonly" style="width: 240px; text-align: right" tabindex=11>
			</td>
			<td class="rightAligned" style="width: 120px"></td>
			<td style="width: 260px;text-align: center"></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 180px"></td>
			<td style="width: 260px;">
				<input type="button" class="button cancelORBtn" 		style="width: 80px;font-size: 12px;text-align: center" id="btnSaveRecord" name="btnSaveRecord" value="Add" tabindex=18></input>
				<input type="button" class="disabledButton cancelORBtn" style="width: 80px;font-size: 12px;text-align: center" id="btnDeleteRecord" name="btnDeleteRecord" value="Delete" disabled="disabled" tabindex=19></input>
			</td>
		</tr>
	</table>
	<div id="currencyDiv" style="display: none;">
		<jsp:include page="../subPages/currencyInfoPage.jsp"></jsp:include>
	</div>
</div>
<div id="faculClaimButtonsDiv" class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 80px;" id="btnSaveInwClaimPayts" name="btnSaveInwClaimPayts"	class="button cancelORBtn" value="Save"   tabindex=20/>
	<input type="button" style="width: 80px;" id="btnCancel" 			name="btnCancel"			class="button" value="Cancel" tabindex=21/>
</div>
<script type="text/javascript">
	setModuleId("GIACS018");
	/** local variables **/
	
	var lastNo = 0; 						// last row no
	var currentRowNo = -1; 					// row no of current record selected. f-1 when no rows are selected

	/** VARIABLES **/
	
	var varPrevTranType = "";
	var varPrevAdviceSeqNo = "";
	var varGenType = "";
	var varModuleName = "GIACS018";

	/** CONTROL block variables **/
	
	var controlCurrCdParam = "${controlCurrCdParam}";
	var controlVIssCd = "${controlVIssCd}";
	
	/** objects and lists **/
	
	inwClaimPaytsList = eval('${inwClaimPaytsList}');
	lineListing1 = eval('${lineListing1}');
	lineListing2 = eval('${lineListing2}');
	issCdListing1 = eval('${issCdListing1}');
	issCdListing2 = eval('${issCdListing2}');

	currencyList = eval('${currencyList}');
	
	/** end of objects and lists **/
	
	/** initialization **/
	
	$("txtDspCurrencyDesc").readOnly = true;
	$("txtConvertRate").readOnly = true;
	$("txtForeignCurrAmt").readOnly = true;
	$("txtTransactionType").focus();
	
	if (inwClaimPaytsList.length > 0) {
		for (var i = 0; i < inwClaimPaytsList.length; i++) {
			var content = generateContent(inwClaimPaytsList[i], i);
			inwClaimPaytsList[i].recordStatus = null;
			//generateInitialItemValue(inwClaimPaytsList[i]);
			addTableRow("row"+i, "rowInwClaimPayts", "faculClaimPaytsTableContainer", content, clickInwClaimPaytsRow);
			lastNo = lastNo + 1;
			$("lblSumDspNetAmt").innerHTML = formatCurrency(parseFloat($("lblSumDspNetAmt").innerHTML.replace(/,/g,"")) + parseFloat(inwClaimPaytsList[i].netDisbAmt == null ? 0 : inwClaimPaytsList[i].netDisbAmt));
		}
		checkIfToResizeTable("faculClaimPaytsTableContainer", "rowInwClaimPayts");
	} else {
		checkTableIfEmpty("rowInwClaimPayts", "faculClaimPaytsTableMainDiv");
	}

	/** end of initialization **/
	
	/** events **/
	
	$("btnSaveRecord").observe("click", function() {
		if (checkRequiredFields()) {
			var rowNum;
			var inwClaimPayts;
			var netDisbAmt = 0;
			var recordExist = false;
			
			if ($F("btnSaveRecord") == "Add") {
				rowNum = lastNo;
				inwClaimPayts = new Object();
				netDisbAmt = 0;
			} else {
				var rowNum = currentRowNo;
				var inwClaimPayts = inwClaimPaytsList[rowNum];
				netDisbAmt = parseFloat(inwClaimPayts.netDisbAmt == null ? 0 : inwClaimPayts.netDisbAmt);
			}
			
			new Ajax.Request(contextPath+"/GIACInwClaimPaytsController?action=executeGiacs018PreInsertTrigger", {
				evalScripts: true,
				asynchronous: true,
				method: "GET",
				parameters: {
					payeeClassCd: $F("txtPayeeClassCd"),
					payeeCd: $F("txtPayeeCd"),
					transactionType: $F("txtTransactionType"),
					claimId: $F("txtClaimId"),
					adviceId: $F("txtAdviceId"),
					currencyCd: $F("txtCurrencyCd"),
					convertRate: $F("txtConvertRate"),
					foreignCurrAmt: $F("txtForeignCurrAmt")
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();

						$("txtCurrencyCd").value = result.currencyCd;
						validateCurrency();
						$("txtConvertRate").value = result.convertRate;
						$("txtForeignCurrAmt").value = result.foreignCurrAmt;
						
						if (result.message == "SUCCESS") {
							var content = "";
							var exist = false;

							inwClaimPayts.gaccTranId = objACGlobal.gaccTranId;
							inwClaimPayts.claimId = $F("txtClaimId");
							inwClaimPayts.clmLossId = $F("txtClmLossId");
							inwClaimPayts.adviceId = $F("txtAdviceId");
							inwClaimPayts.transactionType = $F("txtTransactionType");
							inwClaimPayts.orPrintTag = $F("txtOrPrintTag");
							inwClaimPayts.payeeType = $F("txtPayeeType");
							inwClaimPayts.dspPayeeDesc = $F("txtDspPayeeDesc");
							inwClaimPayts.payeeClassCd = $F("txtPayeeClassCd");
							inwClaimPayts.payeeCd = $F("txtPayeeCd");
							inwClaimPayts.dspPayeeName = changeSingleAndDoubleQuotes2($F("txtDspPayeeName"));
							inwClaimPayts.disbursementAmt = parseFloat(nvl($F("txtDisbursementAmt").replace(/,/g,""), 0));
							inwClaimPayts.inputVATAmt = $F("txtInputVATAmt").blank() ? null : parseFloat($F("txtInputVATAmt").replace(/,/g,""));
							inwClaimPayts.wholdingTaxAmt = $F("txtWholdingTaxAmt").blank() ? null : parseFloat($F("txtWholdingTaxAmt").replace(/,/g,""));
							inwClaimPayts.netDisbAmt = $F("txtNetDisbAmt").blank() ? null : parseFloat($F("txtNetDisbAmt").replace(/,/g,""));
							inwClaimPayts.remarks = changeSingleAndDoubleQuotes2($F("txtRemarks"));
							inwClaimPayts.currencyCd = $F("txtCurrencyCd");
							inwClaimPayts.currDesc = $F("txtDspCurrencyDesc");
							inwClaimPayts.convertRate = $F("txtConvertRate"); //benjo 02.29.2016 SR-5303
							inwClaimPayts.foreignCurrAmt = $F("txtForeignCurrAmt").blank() ? null : parseFloat($F("txtForeignCurrAmt").replace(/,/g,""));
							inwClaimPayts.dspLineCd = $F("txtDspLineCd");
							inwClaimPayts.dspIssCd = $F("txtDspIssCd");
							inwClaimPayts.dspAdviceYear = $F("txtDspAdviceYear");
							inwClaimPayts.dspAdviceSeqNo = $F("txtDspAdviceSeqNo");
							inwClaimPayts.dspPerilName = changeSingleAndDoubleQuotes2($F("txtDspPerilName"));
							inwClaimPayts.dspPerilSname = changeSingleAndDoubleQuotes2($F("txtDspPerilSname"));
							inwClaimPayts.dspClaimNo = $F("txtDspClaimNo");
							inwClaimPayts.dspPolicyNo = $F("txtDspPolicyNo");
							inwClaimPayts.dspAssuredName = changeSingleAndDoubleQuotes2($F("txtDspAssuredName"));
							inwClaimPayts.vCheck = $F("txtVCheck");
							inwClaimPayts.recordStatus = 0;

							// check if record exists
							for (var i = 0; i < inwClaimPaytsList.length; i++) {
								if (inwClaimPaytsList[i].claimId 		== inwClaimPayts.claimId &&
										inwClaimPaytsList[i].clmLossId	== inwClaimPayts.clmLossId) {
									if (inwClaimPaytsList[i].recordStatus == -1) {
										inwClaimPayts.recordStatus = 1;
									} else if (inwClaimPaytsList[i].recordStatus == null) {
										// tag record as existing, then display error message
										recordExist = true;
									} else if (inwClaimPaytsList[i].recordStatus == -2) {
										inwClaimPayts.recordStatus = 0;
									}
									rowNum = i;
									inwClaimPaytsList[i] = inwClaimPayts;
									exist = true;
									break;
								}
							}

							if (recordExist) {
								showMessageBox("Row with the same Gacc Tran Id, Advice No., Payee Cd and Payee Class Cd already exists.", imgMessage.INFO);
							} else {
								if (!exist) {
									inwClaimPaytsList.push(inwClaimPayts);
									lastNo = lastNo + 1;
								}
	
								content = generateContent(inwClaimPayts, rowNum);
								
								addTableRow("row"+rowNum, "rowInwClaimPayts", "faculClaimPaytsTableContainer", content, clickInwClaimPaytsRow);
								resetFields();
	
								checkIfToResizeTable("faculClaimPaytsTableContainer", "rowInwClaimPayts");
								checkTableIfEmpty("rowInwClaimPayts", "faculClaimPaytsTableMainDiv");
	
								$("lblSumDspNetAmt").innerHTML = formatCurrency(parseFloat($("lblSumDspNetAmt").innerHTML.replace(/,/g,"")) - netDisbAmt + parseFloat(inwClaimPayts.netDisbAmt == null ? 0 : inwClaimPayts.netDisbAmt));
							}
						} else {
							showMessageBox(result.message, imgMessage.INFO);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	});

	$("btnDeleteRecord").observe("click", function() {
		if (currentRowNo < 0) {
			return false;
		}

		//key-delrec
		if ($F("txtOrPrintTag") == "Y") {
			showMessageBox("Delete not allowed.  OR has already been printed.", imgMessage.INFO);
			return false;
		} else {
			// tag the record as deleted. if previously added, mark as -2
			if (inwClaimPaytsList[currentRowNo].recordStatus == 0) {
				inwClaimPaytsList[currentRowNo].recordStatus = -2;
			} else {
				inwClaimPaytsList[currentRowNo].recordStatus = -1;
			}
	
			// delete the record from the main container div
			var row = $("row"+currentRowNo);
			Effect.Fade(row, {
				duration: .2,
				afterFinish: function() {
					$("lblSumDspNetAmt").innerHTML = formatCurrency(parseFloat($("lblSumDspNetAmt").innerHTML.replace(/,/g,"")) - parseFloat(inwClaimPaytsList[currentRowNo].netDisbAmt == null ? 0 : inwClaimPaytsList[currentRowNo].netDisbAmt));
					row.remove();
					checkIfToResizeTable("faculClaimPaytsTableContainer", "rowInwClaimPayts");
					checkTableIfEmpty("rowInwClaimPayts", "faculClaimPaytsTableMainDiv");
					resetFields();
				}
			});
		}
	});

	$("btnSaveInwClaimPayts").observe("click", function() {
		if (hasUnsavedChanges()) {
			showMessageBox("Please save changes first.", imgMessage.INFO);
		} else {
			saveFaculClaimPayts();
		}
	});
	
	$("btnCurrButton").observe("click", function() {
		if (checkFieldsIfNotBlank()) {
			validateCurrency();
			Effect.Appear($("currencyDiv"), {
				duration: 0.2
			});
		} else {
			showMessageBox("Please fill in the previous fields before you proceed.", imgMessage.INFO);
		}
	});

	$("btnHideCurrPage").observe("click", function() {
		Effect.Fade($("currencyDiv"), {
			duration: 0.2
		});
	});
	
	$("txtTransactionType").observe("change", function() {
		validateTransactionType();
		resetFields2();
	});

	$("txtDspLineCd").observe("change", function() {
		validateLineCd();
		resetFields2();
	});

	$("txtDspIssCd").observe("change", function() {
		validateIssCd();
		resetFields2();
	});

	$("txtDspAdviceSeqNo").observe("change", function() {
		validateAdviceSeqNo();
	});

	$("txtCurrencyCd").observe("change", function() {
		validateCurrency();
	});
	
	/** end of events **/
	
	/** page functions **/
	
	// Generates content for the div of a new Overriding Comm Payts table row to be added
	function generateContent(inwClaimPayts, rowNum) {
		var content = "";

		var transactionType = "---";
		var adviceNo = (inwClaimPayts.dspLineCd.blank() || inwClaimPayts.dspIssCd.blank() || inwClaimPayts.dspAdviceYear == null || inwClaimPayts.dspAdviceSeqNo == null) ? "---" : inwClaimPayts.dspLineCd + "-" + inwClaimPayts.dspIssCd + "-" + inwClaimPayts.dspAdviceYear + "-" + inwClaimPayts.dspAdviceSeqNo;
		var payeeClass = inwClaimPayts.dspPayeeDesc.blank() ? "---" : inwClaimPayts.dspPayeeDesc;
		var dspPerilName = inwClaimPayts.dspPerilSname.blank() ? "---" : inwClaimPayts.dspPerilSname;
		var disbursementAmt = inwClaimPayts.disbursementAmt == null ? "" : formatCurrency(inwClaimPayts.disbursementAmt);
		var inputVATAmt = inwClaimPayts.inputVATAmt == null ? "" : formatCurrency(inwClaimPayts.inputVATAmt);
		var wholdingTaxAmt = inwClaimPayts.wholdingTaxAmt == null ? "" : formatCurrency(inwClaimPayts.wholdingTaxAmt);
		var netDisbAmt = inwClaimPayts.netDisbAmt == null ? "" : formatCurrency(inwClaimPayts.netDisbAmt);

		for (var i = 0; i < $("txtTransactionType").options.length; i++) {
			if (parseInt(nvl($("txtTransactionType").options[i].value, 0)) == inwClaimPayts.transactionType) {
				transactionType = $("txtTransactionType").options[i].text;
				break;
			}
		}

		/*
		for (var i = 0; i < $("txtTransactionType").options.length; i++) {
			if (parseInt(nvl($("txtTransactionType").options[i].value, 0)) == inwClaimPayts.transactionType) {
				transactionType = $("txtTransactionType").options[i].text;
				break;
			}
		}*/

		content = 
			'<label style="width: 110px;font-size: 11px; text-align: center;" id="lblTransactionType" 	name="lblTransactionType">'+transactionType.truncate(13, "...")+'</label>' +
			'<label style="width: 145px;font-size: 11px; text-align: center;" id="lblAdviceNo" 			name="lblAdviceNo">'+adviceNo+'</label>' +
			'<label style="width:  80px;font-size: 11px; text-align: center;" id="lblPayeeClass" 		name="lblPayeeClass">'+payeeClass.truncate(10, "...")+'</label>' +
			'<label style="width:  80px;font-size: 11px; text-align: center;" id="lblPerilName" 		name="lblPerilName">'+dspPerilName.truncate(10, "...")+'</label>' +
			'<label style="width: 115px;font-size: 11px; text-align: right;"  id="lblDisbursementAmt" 	name="lblDisbursementAmt">'+disbursementAmt+'</label>' +
			'<label style="width: 115px;font-size: 11px; text-align: right;"  id="lblInputVATAmt" 		name="lblInputVATAmt">'+inputVATAmt+'</label>' +
			'<label style="width: 115px;font-size: 11px; text-align: right;"  id="lblWholdingTaxAmt" 	name="lblWholdingTaxAmt">'+wholdingTaxAmt+'</label>' +
			'<label style="width: 115px;font-size: 11px; text-align: right;"  id="lblNetDisbAmt" 		name="lblNetDisbAmt">'+netDisbAmt+'</label>' +
			'<input type="hidden"	id="count"		name="count"	value="'+rowNum+'" />';

		return content;
	}

	// Function to be executed when table row is clicked
	function clickInwClaimPaytsRow(row) {
		$$("div#faculClaimPaytsTable div[name='rowInwClaimPayts']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		currentRowNo = row.down("input", 0).value;

		if (row.hasClassName("selectedRow")) {
			populateDetails(currentRowNo);

			// disable fields
			$("txtTransactionType").disable();
			$("txtDspLineCd").disable();
			$("txtDspIssCd").disable();
			$("txtDspAdviceYear").disable();
			$("txtDspAdviceSeqNo").disable();
			$("txtDspPayeeDesc").disable();
			$("txtCurrencyCd").readOnly = true;
			$("txtRemarks").readOnly = true;

			//$("btnSaveRecord").value = "Update";
			disableButton("btnSaveRecord");
			enableButton("btnDeleteRecord");
		} else {
			resetFields();
		}
	}

	// reset fields
	function resetFields() {
		currentRowNo = -1;

		var itemFields = ["TransactionType", "DspLineCd", "DspIssCd", "DspAdviceYear", "DspAdviceSeqNo", "DspPayeeDesc",
		          			"DspPerilName", "DspPerilSname", "DisbursementAmt", "InputVATAmt", "WholdingTaxAmt", "NetDisbAmt",
		          			"DspClaimNo", "DspPolicyNo", "DspPayeeName", "DspAssuredName", "Remarks",
		          			"ClaimId", "ClmLossId", "AdviceId", "PayeeClassCd", "PayeeCd", "PayeeType",
		          			"CurrencyCd", "ConvertRate", "DspCurrencyDesc", "ForeignCurrAmt"];

		for (var i = 0; i < itemFields.length; i++) {
			$("txt"+itemFields[i]).value = "";
		}

		$("txtVCheck").value = "0";
		$("txtOrPrintTag").value = "N";

		// enable fields //added cancelOtherOR by robert 10302013
		if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
			disableGIACS009();
		} else {
			$("txtTransactionType").enable();
			$("txtDspLineCd").enable();
			$("txtDspIssCd").enable();
			$("txtDspAdviceYear").enable();
			$("txtDspAdviceSeqNo").enable();
			$("txtDspPayeeDesc").enable();
			$("txtCurrencyCd").readOnly = false;
			$("txtRemarks").readOnly = false;
			
			//$("btnSaveRecord").value = "Add";
			enableButton("btnSaveRecord");
			disableButton("btnDeleteRecord");
		}
		// clean lists
		cleanListing("txtDspLineCd");
		cleanListing("txtDspIssCd");
		cleanListing("txtDspAdviceYear");
		cleanListing("txtDspAdviceSeqNo");
		cleanListing("txtDspPayeeDesc");

		// misc
		varPrevTranType = "";
		varPrevAdviceSeqNo = "";
	}

	// reset fields 2. resets values of some variables
	function resetFields2() {

		var itemFields = ["DspPayeeDesc", "DspPerilName", "DspPerilSname", "DisbursementAmt", "InputVATAmt", "WholdingTaxAmt",
		          			"NetDisbAmt", "DspClaimNo", "DspPolicyNo", "DspPayeeName", "DspAssuredName", "Remarks",
		          			"ClaimId", "ClmLossId", "AdviceId", "PayeeClassCd", "PayeeCd", "PayeeType",
		          			"CurrencyCd", "ConvertRate", "DspCurrencyDesc", "ForeignCurrAmt"];

		for (var i = 0; i < itemFields.length; i++) {
			$("txt"+itemFields[i]).value = "";
		}
	}

	// initializes an LOV listing
	function cleanListing(listName) {
		$(listName).innerHTML = "";

		var newOption = new Element("option");
		newOption.text = "";
		newOption.value = "";

		try {
		    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
		  }
		catch(ex) {
		    $(listName).add(newOption); // IE only
		}
	}

	// populate a listing with a single value, used for display purposes only
	function populateListingWithSingleValue(listName, val) {
		cleanListing(listName);

		var newOption = new Element("option");
		newOption.text = val;
		newOption.value = val;

		try {
		    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
		  }
		catch(ex) {
		    $(listName).add(newOption); // IE only
		}
		$(listName).value = val;
	}

	// populates the dynamic LOV for Line Cd.
	function populateLineListing(objArray) {
		cleanListing("txtDspLineCd");

		for (var i = 0; i < objArray.length; i++) {
			newOption = new Element("option");
			newOption.text = objArray[i].lineCd;
			newOption.value = objArray[i].lineCd;

			try {
				if (objACGlobal.previousModule == 'GIACS016'){	// shan 09.17.2014
					if (unescapeHTML2(objGIACS002.lineCd) == unescapeHTML2(newOption.text)){
						 $("txtDspLineCd").add(newOption, null);
					}
				}else{
			    	$("txtDspLineCd").add(newOption, null); // standards compliant; doesn't work in IE
				}
			  }
			catch(ex) {
				if (objACGlobal.previousModule == 'GIACS016'){	// shan 09.17.201
					if (unescapeHTML2(objGIACS002.lineCd) == unescapeHTML2(newOption.text)){
						$("txtDspLineCd").add(newOption); // IE only
					}
				}else{
					$("txtDspLineCd").add(newOption); // IE only
				}
			}
		}
	}

	// populates the dynamic LOV for Iss Cd.
	function populateIssCdListing(objArray) {
		cleanListing("txtDspIssCd");

		for (var i = 0; i < objArray.length; i++) {
			newOption = new Element("option");
			newOption.text = objArray[i].issCd;
			newOption.value = objArray[i].issCd;

			try {
			    $("txtDspIssCd").add(newOption, null); // standards compliant; doesn't work in IE
			  }
			catch(ex) {
			    $("txtDspIssCd").add(newOption); // IE only
			}
		}
	}

	// Populates input fields of Facul Claim Payts details
	// @param - rowNum: the array index of the Facul Claim Payts record to be displayed
	function populateDetails(rowNum) {
		var inwClaimPayts = inwClaimPaytsList[rowNum];

		// main details
		$("txtTransactionType").value = inwClaimPayts.transactionType;
		populateListingWithSingleValue("txtDspLineCd", inwClaimPayts.dspLineCd);
		populateListingWithSingleValue("txtDspIssCd", inwClaimPayts.dspIssCd);
		populateListingWithSingleValue("txtDspAdviceYear", inwClaimPayts.dspAdviceYear);
		populateListingWithSingleValue("txtDspAdviceSeqNo", inwClaimPayts.dspAdviceSeqNo);
		populateListingWithSingleValue("txtDspPayeeDesc", inwClaimPayts.dspPayeeDesc + " - " + inwClaimPayts.payeeClassCd);
		$("txtDspPerilName").value = unescapeHTML2(inwClaimPayts.dspPerilName);
		$("txtDspPerilSname").value = unescapeHTML2(inwClaimPayts.dspPerilSname);
		$("txtDisbursementAmt").value = inwClaimPayts.disbursementAmt == null ? "" : formatCurrency(inwClaimPayts.disbursementAmt);
		$("txtInputVATAmt").value = inwClaimPayts.inputVATAmt == null ? "" : formatCurrency(inwClaimPayts.inputVATAmt);
		$("txtWholdingTaxAmt").value = inwClaimPayts.wholdingTaxAmt == null ? "" : formatCurrency(inwClaimPayts.wholdingTaxAmt);
		$("txtNetDisbAmt").value = inwClaimPayts.netDisbAmt == null ? "" : formatCurrency(inwClaimPayts.netDisbAmt);
		$("txtDspClaimNo").value = inwClaimPayts.dspClaimNo;
		$("txtDspPolicyNo").value = inwClaimPayts.dspPolicyNo;
		$("txtDspPayeeName").value = unescapeHTML2(inwClaimPayts.dspPayeeName);
		$("txtDspAssuredName").value = unescapeHTML2(inwClaimPayts.dspAssuredName);
		$("txtRemarks").value = unescapeHTML2(inwClaimPayts.remarks);
		$("txtCurrencyCd").value = inwClaimPayts.currencyCd;
		$("txtDspCurrencyDesc").value = inwClaimPayts.currDesc;
		$("txtConvertRate").value = inwClaimPayts.convertRate;
		$("txtForeignCurrAmt").value = inwClaimPayts.foreignCurrAmt == null ? "" : formatCurrency(inwClaimPayts.foreignCurrAmt);
		$("txtClaimId").value = inwClaimPayts.claimId;
		$("txtClmLossId").value = inwClaimPayts.clmLossId;
		$("txtAdviceId").value = inwClaimPayts.adviceId;
		$("txtPayeeClassCd").value = inwClaimPayts.payeeClassCd;
		$("txtPayeeCd").value = inwClaimPayts.payeeCd;
		$("txtPayeeType").value = inwClaimPayts.payeeType;
		$("txtVCheck").value = inwClaimPayts.vCheck;
		$("txtOrPrintTag").value = inwClaimPayts.orPrintTag;

		varPrevTranType = inwClaimPayts.transactionType;
		varPrevAdviceSeqNo = inwClaimPayts.dspAdviceSeqNo;
	}

	// checks if the main fields are not blank
	function checkFieldsIfNotBlank() {
		return !$F("txtPayeeCd").blank() && !$F("txtPayeeClassCd").blank() && !$F("txtPayeeType").blank() 
				&& !$F("txtClmLossId").blank() && !$F("txtAdviceId").blank() && !$F("txtClaimId").blank();
	}

	// check if required fields have values
	function checkRequiredFields() {
		var ok = true;
		var item = "";

		$$("[class='required']").each(function(field) {
			if (field.value.blank()) {
				if (field.id == "txtTransactionType") {
					item = "Transaction Type";
				} else if (field.id == "txtDspLineCd") {
					item = "Advice No";
				} else if (field.id == "txtDspIssCd") {
					item = "Advice No";
				} else if (field.id == "txtDspAdviceYear") {
					item = "Advice No";
				} else if (field.id == "txtDspAdviceSeqNo") {
					item = "Advice No";
				} else if (field.id == "txtDspPayeeDesc") {
					item = "Payee Class";
				} else if (field.id == "txtDisbursementAmt") {
					item = "Dibursement Amount";
				}

				ok = false;
				
				return false;
			}
		});

		if (!ok) {
			showMessageBox("User supplied value is required for " + item + ".", imgMessage.ERROR);
		}

		return ok;
	}

	// checks if changes have been made
	function hasChanges() {
		var result = false;
		for (var i = 0; i < inwClaimPaytsList.length; i++) {
			if (inwClaimPaytsList[i].recordStatus == 0 || inwClaimPaytsList[i].recordStatus == 1 || inwClaimPaytsList[i].recordStatus == -1) {
				result = true;
				break;
			}
		}

		return result;
	}

	// checks if there is currently an unsaved change on addition of record
	function hasUnsavedChanges() {
		var result = false;
		
		var itemFields = ["TransactionType", "DspLineCd", "DspIssCd", "DspAdviceYear", "DspAdviceSeqNo", "DspPayeeDesc",
		          			"DspPerilName", "DspPerilSname", "DisbursementAmt", "InputVATAmt", "WholdingTaxAmt", "NetDisbAmt",
		          			"DspClaimNo", "DspPolicyNo", "DspPayeeName", "DspAssuredName", "Remarks",
		          			"ClaimId", "ClmLossId", "AdviceId", "PayeeClassCd", "PayeeCd", "PayeeType",
		          			"CurrencyCd", "ConvertRate", "DspCurrencyDesc", "ForeignCurrAmt"];

		for (var i = 0; i < itemFields.length; i++) {
			if (!$F("txt"+itemFields[i]).blank() && $("btnSaveRecord").disabled == false) {	// added new condition to check only new record : shan 09.17.2014
				result = true;
				break;
			}
		}

		return result;
	}

	function saveFaculClaimPayts() {
		if (!hasChanges()) {
			showMessageBox("No changes to save.", imgMessage.INFO);
		} else {
			if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS018")){ //marco - SR-5722 - 02.13.2017
				return;
			}
			
			var addedRows = getAddedJSONObjects(inwClaimPaytsList);
			var modifiedRows = getModifiedJSONObjects(inwClaimPaytsList);
			var delRows = getDeletedJSONObjects(inwClaimPaytsList);
			var setRows = addedRows.concat(modifiedRows);
			
			new Ajax.Request(contextPath+"/GIACInwClaimPaytsController?action=saveFaculClaimPayts", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					gaccTranId : objACGlobal.gaccTranId,
					gaccBranchCd: objACGlobal.branchCd,
					gaccFundCd: objACGlobal.fundCd,
					tranSource: objACGlobal.tranSource,
					orFlag: objACGlobal.orFlag,
					varModuleName: varModuleName,
					varGenType: varGenType,
					setRows: prepareJsonAsParameter(setRows),
					delRows: prepareJsonAsParameter(delRows)
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();

						if (nvl(result.message, "SUCCESS") == "SUCCESS") {
							showMessageBox("Records successfully saved.", imgMessage.INFO);

							varModuleName = result.varModuleName;
							varGenType = result.varGenType;

							for (var i = 0; i < inwClaimPaytsList.length; i++) {
								if (inwClaimPaytsList[i].recordStatus == 0 || inwClaimPaytsList[i].recordStatus == 1) {
									inwClaimPaytsList[i].recordStatus = null;
								} else if (inwClaimPaytsList[i].recordStatus == -1) {
									inwClaimPaytsList[i].recordStatus = -2;
								}
							}
						} else {
							showMessageBox(result.message, imgMessage.INFO);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}
	
	/** end of page functions **/
	
	/** other validations **/
	
	// validate transaction type
	function validateTransactionType() {
		if ($F("txtTransactionType") == "" || $F("txtTransactionType") == "1" || $F("txtTransactionType") == "2") {
			$("txtDspLineCd").value = "";
			$("txtDspIssCd").value = "";
			$("txtDspAdviceYear").value = "";
			$("txtDspAdviceSeqNo").value = "";
			$("txtDisbursementAmt").value = "";
			$("txtClaimId").value = "";
			$("txtAdviceId").value = "";
			$("txtClmLossId").value = "";
			$("txtPayeeClassCd").value = "";
			$("txtPayeeCd").value = "";
			$("txtPayeeType").value = "";
			$("txtDspPayeeDesc").value = "";
			$("txtDspCurrencyDesc").value = "";
			$("txtConvertRate").value = "";
			$("txtForeignCurrAmt").value = "";
			$("txtCurrencyCd").value = "";

			varPrevTranType = $("txtTransactionType");

			if ($F("txtTransactionType") == "1") {
				populateLineListing(lineListing1);
			} else if ($F("txtTransactionType") == "2") {
				populateLineListing(lineListing2);
			} else {
				cleanListing("txtDspLineCd");
			}
			cleanListing("txtDspIssCd");
			cleanListing("txtDspAdviceYear");
			cleanListing("txtDspAdviceSeqNo");
			cleanListing("txtDspPayeeDesc");
		} else {
			showWaitingMessageBox("Error: THIS IS NOT A VALID TRANSACTION TYPE!!!", imgMessage.INFO,
									function() {
										$("txtTransactionType").focus();
									});
		}
	}

	// validate line cd
	function validateLineCd() {
		if ($F("txtTransactionType") == "1") {
			populateIssCdListing(issCdListing1);
		} else if (($F("txtTransactionType") == "2")){
			populateIssCdListing(issCdListing2);
		} else {
			cleanListing("txtDspIssCd");
		}
		cleanListing("txtDspAdviceYear");
		cleanListing("txtDspAdviceSeqNo");
		cleanListing("txtDspPayeeDesc");
	}

	// validate iss cd
	function validateIssCd() {
		if (!$F("txtDspIssCd").blank()) {
			new Ajax.Updater($("txtDspAdviceYear").up("span", 0), contextPath+"/GIACInwClaimPaytsController?action=getAdviceYearByIssCdListing", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					tranType: $F("txtTransactionType"),
					lineCd: $F("txtDspLineCd"),
					issCd: controlVIssCd,
					moduleName: varModuleName,
					width: $("txtDspAdviceYear").getWidth(),
					tabIndex: $("txtDspAdviceYear").getAttribute("tabindex"),
					listId: "txtDspAdviceYear",
					listName: "txtDspAdviceYear",
					className: "required"
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						$("txtDspAdviceYear").observe("change", function() {
							validateAdviceYear();
							resetFields2();
						});

						if (currentRowNo >= 0) {
							$("txtDspAdviceYear").value = inwClaimPaytsList[currentRowNo].dspAdviceYear;
							//populateChildIntmList();
						}
					} else {
						$("txtDspAdviceYear").up("span", 0).update("");
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} else {
			cleanListing("txtDspAdviceYear");
		}
		cleanListing("txtDspAdviceSeqNo");
		cleanListing("txtDspPayeeDesc");
	}

	function listNewlyDeletedAdvSeqNo(){
		var newOption = new Element("option");
		var objArray = inwClaimPaytsList;
		
		for (var i = 0; i < objArray.length; i++) {						
			if ((objArray[i].recordStatus == -1 || objArray[i].recordStatus == -2) && objArray[i].dspLineCd == $F("txtDspLineCd")  && objArray[i].dspIssCd == $F("txtDspIssCd") 
					&& objArray[i].dspAdviceYear == $F("txtDspAdviceYear")){
				var exists = false;
				for (var j=0; j < $("txtDspAdviceSeqNo").length; j++){
					if (objArray[i].dspAdviceSeqNo == $("txtDspAdviceSeqNo").options[j].value){
						exists = true;
						break;
					}
				}
				
				if (!exists){
					newOption.text = objArray[i].dspAdviceSeqNo;
					newOption.value = objArray[i].dspAdviceSeqNo;
					newOption.claimId = objArray[i].claimId;
					newOption.adviceId = objArray[i].adviceId;
					
					try {
					    $("txtDspAdviceSeqNo").add(newOption, null); // standards compliant; doesn't work in IE
					  }
					catch(ex) {
					    $("txtDspAdviceSeqNo").add(newOption); // IE only
					}
				
				    $("txtDspAdviceSeqNo").options[$("txtDspAdviceSeqNo").options.length-1].setAttribute("claimId", newOption.claimId);
				    $("txtDspAdviceSeqNo").options[$("txtDspAdviceSeqNo").options.length-1].setAttribute("adviceId", newOption.adviceId);
				}
			}
		}
	}
	
	// validate advice year
	function validateAdviceYear() {
		if (!$F("txtDspAdviceYear").blank()) {
			var notIn = null;		// shan 09.17.2014
			
			for (var i = 0; i < inwClaimPaytsList.length; i++) {
				if ((inwClaimPaytsList[i].recordStatus != -1 && inwClaimPaytsList[i].recordStatus != -2) && inwClaimPaytsList[i].transactionType == $F("txtTransactionType") && inwClaimPaytsList[i].dspLineCd == $F("txtDspLineCd") 
						&& inwClaimPaytsList[i].dspIssCd == $F("txtDspIssCd") && inwClaimPaytsList[i].dspAdviceYear == $F("txtDspAdviceYear")){
					notIn = (notIn == null ? inwClaimPaytsList[i].dspAdviceSeqNo : notIn + "," + inwClaimPaytsList[i].dspAdviceSeqNo);
				}				
			}
			
			new Ajax.Updater($("txtDspAdviceSeqNo").up("span", 0), contextPath+"/GIACInwClaimPaytsController?action=getAdviceSeqNoListing", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					tranType: $F("txtTransactionType"),
					lineCd: $F("txtDspLineCd"),
					issCd: controlVIssCd,
					adviceYear: $F("txtDspAdviceYear"),
					moduleName: varModuleName,
					width: $("txtDspAdviceSeqNo").getWidth(),
					tabIndex: $("txtDspAdviceSeqNo").getAttribute("tabindex"),
					listId: "txtDspAdviceSeqNo",
					listName: "txtDspAdviceSeqNo",
					className: "required",
					notIn:		(notIn == null ? "--" : "(" + notIn + ")")	// shan 09.17.2014
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						$("txtDspAdviceSeqNo").observe("change", function() {
							varPrevAdviceSeqNo = "";
							validateAdviceSeqNo();
						});

						if (currentRowNo >= 0) {
							$("txtDspAdviceSeqNo").value = inwClaimPaytsList[currentRowNo].dspAdviceSeqNo;
							//populateChildIntmList();
						}
						
						if ($F("txtTransactionType") == "1") listNewlyDeletedAdvSeqNo();	// shan 09.18.2014
					} else {
						$("txtDspAdviceSeqNo").up("span", 0).update("");
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} else {
			cleanListing("txtDspAdviceSeqNo");
		}
		cleanListing("txtDspPayeeDesc");
	}

	// validate advice seq no
	function validateAdviceSeqNo() {
		$("txtClaimId").value = $("txtDspAdviceSeqNo").options[$("txtDspAdviceSeqNo").selectedIndex].readAttribute("claimId");
		$("txtAdviceId").value = $("txtDspAdviceSeqNo").options[$("txtDspAdviceSeqNo").selectedIndex].readAttribute("adviceId");
		
		if (!$F("txtDspAdviceSeqNo").blank()) {
			if (currentRowNo < 0) {
				$("txtClmLossId").value = "";
				$("txtPayeeCd").value = "";
				$("txtPayeeClassCd").value = "";
				$("txtPayeeType").value = "";
				$("txtDspPayeeDesc").value = "";
			}

			new Ajax.Request(contextPath+"/GIACInwClaimPaytsController?action=getClaimPolicyAndAssured", {
				evalScripts: true,
				asynchronous: true,
				method: "GET",
				parameters: {
					claimId: $F("txtClaimId")
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						try {
							var result = JSON.parse(response.responseText);
							
							if (result.message == "SUCCESS") {
								$("txtDspClaimNo").value = result.claimNo;
								$("txtDspPolicyNo").value = result.policyNo;
								$("txtDspAssuredName").value = unescapeHTML2(result.assuredName);
	
								varPrevAdviceSeqNo =  $F("txtDspAdviceSeqNo");
	
								new Ajax.Updater($("txtDspPayeeDesc").up("td", 0), contextPath+"/GIACInwClaimPaytsController?action=getClmLossIdListing", {
									evalScripts: true,
									asynchronous: false,
									method: "GET",
									parameters: {
										tranType: $F("txtTransactionType"),
										lineCd: $F("txtDspLineCd"),
										claimId: $F("txtClaimId"),
										adviceId: $F("txtAdviceId"),
										width: $("txtDspPayeeDesc").getWidth(),
										tabIndex: $("txtDspPayeeDesc").getAttribute("tabindex"),
										listId: "txtDspPayeeDesc",
										listName: "txtDspPayeeDesc",
										className: "required"
									},
									onCreate: function() {
										$("txtDspPayeeDesc").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
									},
									onComplete: function(response) {
										if (checkErrorOnResponse(response)) {
											$("txtDspPayeeDesc").observe("change", function() {
												varPrevAdviceSeqNo = "";
												validatePayee();
											});
	
											if (currentRowNo >= 0) {
												$("txtDspPayeeDesc").value = inwClaimPaytsList[currentRowNo].dspPayeeDesc;
												//populateChildIntmList();
											}
										} else {
											$("txtDspPayeeDesc").up("td", 0).update("");
											showMessageBox(response.responseText, imgMessage.ERROR);
										}
									}
								});
							} else {
								showWaitingMessageBox(result.message, imgMessage.INFO,
										function() {
											$("txtDspPayeeDesc").focus();
										});
							}
						} catch(e) {
							showErrorMessage("getClaimPolicyAndAssured-onComplete", e);
						}
					} else {
						showWaitingMessageBox(response.responseText, imgMessage.ERROR,
												function() {
													$("txtDspPayeeDesc").focus();
												});
					}
				}
			});
		} else {
			$("txtDspClaimNo").value = "";
			$("txtDspPolicyNo").value = "";
			$("txtDspAssuredName").value = "";
			cleanListing("txtDspPayeeDesc");
		}
	}

	// validate payee
	function validatePayee() {
		if ($("txtDspPayeeDesc").selectedIndex > 0) { 
			var netAmt = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("netAmt");
			
			$("txtClmLossId").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("clmLossId");
			$("txtPayeeType").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("payeeType");
			$("txtPayeeClassCd").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("payeeClassCd");
			$("txtPayeeCd").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("payeeCd");
			$("txtDspPayeeName").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("dspPayeeName");
			$("txtDspPerilName").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("dspPerilName");
			$("txtDspPerilSname").value = $("txtDspPayeeDesc").options[$("txtDspPayeeDesc").selectedIndex].readAttribute("dspPerilSname");
			$("txtDisbursementAmt").value = netAmt.blank() ? "" : formatCurrency(netAmt);
	
			// post-text-item
			if ($F("txtVCheck") == "0") {
				new Ajax.Request(contextPath+"/GIACInwClaimPaytsController?action=validatePayee", {
					evalScripts: true,
					asynchronous: true,
					method: "GET",
					parameters: {
						gaccTranId: objACGlobal.gaccTranId,
						transactionType: $F("txtTransactionType"),
						claimId: $F("txtClaimId"),
						clmLossId: $F("txtClmLossId"),
						adviceId: $F("txtAdviceId"),
						inputVATAmt: $F("txtInputVATAmt").blank() ? "" : $F("txtInputVATAmt").replace(/,/g,""),
						wholdingTaxAmt: $F("txtWholdingTaxAmt").blank() ? "" : $F("txtWholdingTaxAmt").replace(/,/g,""),
						netDisbAmt: $F("txtNetDisbAmt").blank() ? "" : $F("txtNetDisbAmt").replace(/,/g,"")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
	
							$("txtInputVATAmt").value = formatCurrency(parseFloat(nvl(result.inputVATAmt, 0)));
							$("txtWholdingTaxAmt").value = formatCurrency(parseFloat(nvl(result.wholdingTaxAmt, 0)));
							$("txtNetDisbAmt").value = formatCurrency(parseFloat(nvl(result.netDisbAmt, 0)));
							$("txtVCheck").value = result.vCheck;
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}
		}
	}

	// validate currency
	function validateCurrency() {
		for (var i = 0; i < currencyList.length; i++) {
			if (currencyList[i].code == $F("txtCurrencyCd")) {
				$("txtDspCurrencyDesc").value = currencyList[i].desc;
				$("txtConvertRate").value = currencyList[i].valueFloat;

				if (!isNaN($F("txtConvertRate")) && !$F("txtConvertRate").blank()) {
					$("txtForeignCurrAmt").value = formatCurrency(parseFloat(nvl($F("txtDisbursementAmt").replace(/,/g,""), 0)) / parseFloat($F("txtConvertRate").replace(/,/g,"")));
				}
			}
		}
	}
	/** end of other validations **/
	
	//disable fields if calling form is Cancel OR : 08-16-2012 Christian
	function disableGIACS009(){
		var divArray = ["faculClaimButtonsDiv", "overridingCommDiv"];
		disableCancelORFields(divArray);
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS009();
	} else {
		initializeChangeTagBehavior(saveFaculClaimPayts);
		initializeChangeAttribute();
	}
	
	$("acExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveFaculClaimPayts();
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
	$("btnCancel").stopObserving("click");
	$("btnCancel").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveFaculClaimPayts();
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
</script>