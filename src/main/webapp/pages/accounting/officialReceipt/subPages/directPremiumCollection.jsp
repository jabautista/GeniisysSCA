<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="width: 100%;" id="premiumCollectionDeleteList"
	class="tableContainer" style="margin-top: 10px; display: block;">

</div>
<div class="sectionDiv" style="float: left; border-top: none;"
	id="directPremiumCollectionDiv" name="directPremiumCollectionDiv">
<jsp:include page="../subPages/directPremiumCollectionListingTable.jsp"></jsp:include>
<input type="hidden" id="dummyInstNo" />
<div id="directPremiumCollectionHeader"
	name="directPremiumCollectionHeader" style="margin: 10px;">
<table align="center" style="margin: 10px;" border="0">
	<tr>
		<td class="rightAligned" style="width: 20%;"></td>
		<td class="leftAligned" style="width: 30%;"></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Transaction Type</td>
		<td class="leftAligned" style="width: 30%;">
			<select id="tranType" name="tranType" style="width: 200px; margin-right: 70px" class="required changed gdpcRecord" tabindex="1001">
				<option value="">Select..</option>
				<c:forEach var="transactionType" items="${transactionTypeList}"
					varStatus="ctr">
					<option value="${transactionType.rvLowValue }">${transactionType.rvLowValue
					} - ${transactionType.rvMeaning }</option>
				</c:forEach>
			</select>
		</td>
		<td class="leftAligned" id="lblAssdName" width="40%"
			style="font-size: 11px;"><label>Assured Name</label></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Bill Number</td>
		<td class="leftAligned" style="width: 30%;">
		<div style="float: left; width: 93px; height: 21px;">
		<div style="float: left; width: 89px; height: 21px; border: 1px solid gray;">
			<select id="tranSource" name="tranSource" style="width: 89px; margin-right: 70px; height: 20px; border: none;"
				class="required changed gdpcRecord" tabindex="1002">
			<option value="">Select..</option>
			<c:forEach var="issSource" items="${issueSourceList}" varStatus="ctr">
				<option value="${issSource.issCd}">${issSource.issCd}</option>
				<!-- ${issSource.issName}
			-->
			</c:forEach>
		</select></div>
		</div>
			<div id="billCmNoDiv" style="border: 1px solid gray; width: 105px; height: 21px; float: left; background-color: #FFFACD;">
				<input style="width: 80px; border: none;" id="billCmNo"	name="billCmNo" type="text" value="" class="required changed gdpcRecord integerNoNegativeUnformatted" reqIndex=2 tabindex="1003" /> 
				<img style="float: right;" errorMsg="Input value is invalid!." src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmBillCmNo" name="oscmBillCmNo" alt="Go" class="required">
			</div>
		</td>
		<td class="leftAligned changed" width="50%"><input type="text"
			style="width: 300px; margin-right: 70px;" id="assdName"
			name="assdName" value="" readonly="readonly" class="gdpcRecord" readonly="readonly" /></td>
	</tr>
	<!--
	<tr>
		<td class="rightAligned" style="width: 20%">Bill/CM No.</td>
		<td class="leftAligned" style="width: 30%">
		<div
			style="border: 1px solid gray; width: 198px; height: 21px; float: left;">
		<input style="width: 173px; border: none;" id="billCmNo"
			name="billCmNo" type="text" value="" class="required changed gdpcRecord" /> <img
			style="float: right;"
			src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
			id="oscmBillCmNo" name="oscmBillCmNo" alt="Go" /></div>
		</td>
		<td class="leftAligned" id="lblPolicy" width="50%"
			style="font-size: 11px;">Policy/Endorsement No.</td>
	</tr>
	-->
	<tr>
		<td class="rightAligned" style="width: 20%;">Installment No.</td>
		<td class="leftAligned" style="width: 30%">
			<div id="instNoDiv" style="border: 1px solid gray; width: 198px; height: 21px; float: left; background-color: #FFFACD;">
				<input style="width: 173px; border: none;" id="instNo" name="instNo" errorMsg="Input value is invalid!."
					type="text" value="" class="required changed gdpcRecord integerNoNegativeUnformatted" tabindex="1004" />
				<img style="float: right;"
					src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
					id="oscmInstNo" name="oscmInstNo" alt="Go" class="required" />
			</div>
		<td class="leftAligned" id="lblPolicy" width="50%"
			style="font-size: 11px;">Policy/Endorsement Number</td>
		<!--<td class="leftAligned" width="50%"><input type="text"
			style="width: 300px; margin-right: 70px;" id="polEndtNo"
			name="polEndtNo" value="" readonly="readonly" class="gdpcRecord"/></td>-->
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Collection Amount</td>
		<td class="leftAligned" style="width: 30%;">
			<input type="text" style="width: 192px; margin-right: 70px;" id="premCollectionAmt" name="premCollectionAmt" value="0.00" 
				class="required money acctAmt gdpcRecord applyDecimalRegExp" maxlength="14" tabindex="1005" 
				min="-9999999999.99" max="9999999999.99"  regExpPatt="nDeci1002" style="width: 200px" />
		</td>
		<!--<td class="leftAligned" id="lblParticulars" width="50%"
			style="font-size: 11px;">Particulars</td>
		-->
		<td class="leftAligned" width="50%">
			<input type="text" style="width: 300px; margin-right: 70px;" id="polEndtNo" name="polEndtNo" value="" readonly="readonly" class="gdpcRecord" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Premium Amount</td>
		<td class="leftAligned" style="width: 30%;">
			<input type="text" style="width: 192px; margin-right: 70px;" id="directPremAmt" name="directPremAmt" value="0.00" 
				class="money acctAmt gdpcRecord required" readOnly="readOnly" />
			
				<input type="hidden" id="premZeroRated" name="premZeroRated" value="" />
				<input type="hidden" id="premVatExempt" name="premVatExempt" value="" />
				<input type="hidden" id="premVatable" 	name="premVatable" 	 value="" />
				
			</td>
		<!--<td class="leftAligned" width="50%"><input type="text"
			style="width: 300px; margin-right: 70px;" id="particulars"
			name="particulars" value="" class="gdpcRecord"/></td>
			-->
		<td class="leftAligned" id="lblParticulars" width="50%"
			style="font-size: 11px;">Particulars</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Tax Amount</td>
		<td class="leftAligned" style="width: 30%;">
			<input type="text" style="width: 192px; margin-right: 70px;" id="taxAmt" name="taxAmt" value="0.00" 
				class="money acctAmt gdpcRecord required" readOnly="readOnly" />
		</td>
		<!--<td colspan="3" width="50%" style="text-align: right;"><input
			type="button" style="margin-right: 319px; width: 110px;"
			id="btnForeignCurrency" class="button" value="Foreign Currency" /></td>
			-->
		<td class="leftAligned" width="50%">
			<div  style="float: left; width: 305px; border: 1px solid gray; height: 20px;">
				<input type="text" style="width: 270px; float: left; border: none; height: 15px; padding-top: 0px;" id="particulars" name="particulars" value="" class="gdpcRecord" maxlength="500" />
				<img id="editParticulars" name="searchGlAcct" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/edit.png">
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" rowspan="2" width="25%" style="text-align: center;">
			<input type="button" style="width: 13px; height: 13px; margin-left: 82px; float: left;" id="btnUpdate" class="button" value="" /> 
			<label style="margin-left: 4px; float: left;" id="lblUpdate">Update</label> 
			<input type="button" style="width: 60px; margin-left: 82px;" id="btnAdd" class="button" value="Add" /> 
			<input type="button" class="disabledButton" id="btnDelete" name="btnDelete" value="Delete" style="width: 60px;" /> 
			<input type="button" style="width: 13px; height: 13px; margin-left: 82px; float: left;" id="btnSpecUpdate" class="button" value="" /> 
			<label style="margin-left: 4px;" id="lblSpecUpdate">Specific Update</label>
		</td>
	</tr>
	<tr>
		<td height="20px"><input type="button"
			style="margin-right: 319px; width: 110px;" id="btnForeignCurrency"
			class="button" value="Foreign Currency" /></td>
	</tr>
	<tr>
		<td height="25px">
			<div id="choosePayorDiv" style="margin-top: 2px;">
				<input type="radio" id="radioAssd" name="payorType" style="margin-left: 82px; float: left" value="A"/>
				<label style="width: 10px;" id="lblRadioAssd">A</label>
				<input type="radio" id="radioIntm" name="payorType" style="float: left" value="I"/>
				<label style="width: 10px;" id="lblRadioIntm">I</label>
				<input type="checkbox" id="chkIncTag" name="chkIncTag" style="float: left; margin-left: 82px; margin-top: 5px; margin-bottom: 5px; display: none;" disabled="disabled" value="" />
				<label style="margin-left: 3px; margin-top: 5px; margin-bottom: 5px; display: none;" id="lblIncTag">Inc. Tag</label>
			<!-- 
				<label style="width: 200px;"><input type="radio" id="radioAssd" name="orType" value="A"/> A</label>
				<label style="width: 200px;"></label> -->
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" width="70%">
			<input type="button" style="width: 95px; margin-left: 82px;" id="btnAssured" class="disabledButton" value="Assured" /> 
			<input type="button" style="width: 95px;" id="btnPlateNo" class="disabledButton" value="Plate No." /> 
			<input type="button" style="width: 95px;" id="btnPolicy" class="button" value="Policy" />
		</td>
	</tr>
	<tr>
		<td colspan="2" width="70%">
			<input type="button" style="width: 95px; margin-left: 82px;" id="btnDatedCheck" class="button" value="Dated Checks" /> 
			<input type="button" style="width: 95px;" id="btnInvoice" class="disabledButton" value="Invoice" /> 
			<input type="button" style="width: 95px;" id="btnPremColln" class="button" value="Prem Colln List" />
		</td>
	</tr>
</table>
</div>
</div>
<div id="outerDiv">
<div id="innerDiv"><label>Taxes Information</label> <span
	style="margin-top: 0pt;" class="refreshers"> <label
	style="margin-left: 5px;" name="gro">Hide</label> </span></div>
</div>
<div id="taxCollectionListingDiv">
	<jsp:include page="../subPages/taxCollectionListing.jsp"></jsp:include>
</div>
<div class="buttonsDiv" style="float: left; width: 100%;">
	<input type="button" style="width: 80px;" id="btnCancel" name="btnCancel" class="button" value="Cancel" /> 
	<input type="button" style="width: 80px;" id="btnSaveDirectPrem" name="btnSaveDirectPrem" class="button" value="Save" />
</div>

<script>
	//added by alfie 11.26.2010
	initializeChangeTagBehavior(function() {
		fireEvent($("btnSaveDirectPrem"), "click");
		fireEvent($("acExit"), "click");
	});
	changeTag = 0;

	setModuleId("GIACS007");
	setDocumentTitle("Direct Premium Collections");

	objACGlobal.calledForm = "GIACS007";

	objAC.jsonLoadDirectPremCollnsDtls = JSON.parse('${giacDirectPremCollnsDtls}'); //added by alfie 12.14.2010

	objAC.jsonDirectPremCollnsDtls = JSON.parse('${giacDirectPremCollnsDtls}'); //added by alfie 12.08.2010

	objAC.rowsToAdd = [];
	
	createDivTableRows(objAC.jsonDirectPremCollnsDtls, "premiumCollectionList",
			"rowPremColln", "rowPremColln",
			"gaccTranId issCd premSeqNo instNo tranType",
			prepareDirectPremCollnInfo);

	checkTableIfEmpty("rowPremColln", "directPremiumCollectionTable");

	checkIfToResizeTable2("premiumCollectionList", "rowPremColln");

	$("directPremiumCollectionTable").show();

	addRecordEffects("rowPremColln", rowPremCollnSelectedFn,
			rowPremCollnDeselectedFn, "onPageLoad", null);

	var jsonTaxCollnsOnLoad = JSON.parse('${giacTaxCollectionsListing}');
	var retrievedTaxCollns = null;

	createDivTableRows(jsonTaxCollnsOnLoad, "taxCollectionListContainer",
			"taxRow", "taxRow",
			"b160IssCd b160PremSeqNo transactionType instNo b160TaxCd",
			prepareTaxCollectionsInfo);

	addRecordEffects("taxRow", null, null, "onPageLoad", null);

	hideTaxCollections($("taxCollectionTable"), $("taxCollectionListContainer"));

	objAC.currentRecord = {};
	disableButton("btnForeignCurrency");

	objAC.currentRecord.orPrintTag = '';
	objAC.sumGtaxAmt = 0;
	objAC.taxAllocationFlag = '${taxAllocation}';
	objAC.taxPriorityFlag = '${taxPriority}';
	objAC.enterAdvPayt = '${enterAdvPayt}';
	objAC.preChangedFlag = "Y";
	objAC.checkPremAging = '${chkPremAging}';
	objAC.checkBillDueDate = '${chkBillPremOverdue}';
	objAC.allowCancelledPol = '${allowCancelledPol}';
	objAC.collectionFlag = 'Y';
	objAC.modalStatus = "Show";
	objAC.overdueStatusFlag = 'Y';
	objAC.payorBtn = 'A';
	objAC.formChanged = 'N';
	objAC.insertTax = 'Y';
	
	computeTotals();

	//VARIABLES.VARIABLE_NAME

	objAC.overdueFlag = 'N';
	objAC.overideCalled = 'N';
	objAC.overide = 'N';
	objAC.overideOk = 'N';
	objAC.overdueOverride = 'N';
	objAC.instOverdue = 'N';
   
	objAC.currDtls = eval('${currencyDetails}');
	objAC.defCurrency = '${defaultCurrency.code}';
	objAC.defCurrRate = '${defaultCurrency.valueFloat}';
	objAC.tranFlagState = '${tranFlag}';
	
	var giacs007But = '${giacs007But}';
	var payorType = "";

	if (objAC.jsonDirectPremCollnsDtls.length <= 0) {
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
	}else {
		enableButton("btnUpdate");
		enableButton("btnSpecUpdate");
	}
	
	if(giacs007But != 'Y' && giacs007But != 'y') {
		$("btnUpdate").hide();
		$("lblUpdate").hide();
		$("btnSpecUpdate").hide();
		$("lblSpecUpdate").hide();
		$("radioAssd").hide();
		$("lblRadioAssd").hide();
		$("radioIntm").setStyle("margin-left: 82px;");
	} else {
		$("radioAssd").checked = true;
	}

	enableDisableFieldsGiacs007();
	
	function updateDirectPremRow() {
		 for (var i=0; i<objAC.jsonDirectPremCollnsDtls.length; i++){
			    if (objAC.jsonDirectPremCollnsDtls[i].issCd == row.down("label", 2).innerHTML && objAC.jsonDirectPremCollnsDtls[i].premSeqNo == row.down("label", 3).innerHTML && objAC.jsonDirectPremCollnsDtls[i].instNo == row.down("label", 4).innerHTML && objAC.jsonDirectPremCollnsDtls[i].tranType == row.down("label", 1).innerHTML){
					if (v_counter == 0) {
				    	var newObj = new Object();
				    	newObj.gaccTranId = objAC.jsonDirectPremCollnsDtls[i].gaccTranId;
				    	newObj.tranType = objAC.jsonDirectPremCollnsDtls[i].tranType;
				    	newObj.issCd = objAC.jsonDirectPremCollnsDtls[i].issCd;
				    	newObj.premSeqNo = objAC.jsonDirectPremCollnsDtls[i].premSeqNo;
				    	newObj.instNo  = objAC.jsonDirectPremCollnsDtls[i].instNo;
				    	//newObj.policyId  = objAC.jsonDirectPremCollnsDtls[i].policyId;
				    	newObj.policyId  = objAC.selectedRecord.policyId;
				    	newObj.lineCd = objAC.selectedRecord.lineCd;
				    	newObj.assdNo  = objAC.jsonDirectPremCollnsDtls[i].assdNo;
				    	newObj.collAmt = unformatCurrency("premCollectionAmt");//objAC.jsonDirectPremCollnsDtls[i].collAmt;
				    	newObj.premAmt = unformatCurrency("directPremAmt");
				    	newObj.taxAmt = unformatCurrency("taxAmt");
				    	newObj.orPrintTag = objAC.jsonDirectPremCollnsDtls[i].orPrintTag;
				    	newObj.particulars = $F("particulars");
				    	newObj.incTag = objAC.currentRecord.incTag == "Y" ? "Y" : "N";
				    	newObj.policyNo = $F("polEndtNo");
				    	newObj.assdName = $F("assdName");
				    	newObj.currCd = objAC.jsonDirectPremCollnsDtls[i].currCd;
				    	newObj.currRt = objAC.jsonDirectPremCollnsDtls[i].currRt;
				    	newObj.forCurrAmt = objAC.jsonDirectPremCollnsDtls[i].forCurrAmt;
				    	newObj.origPremAmt = objAC.selectedRecord.origPremAmt;//unformatCurrency("directPremAmt");
				    	newObj.origTaxAmt = objAC.selectedRecord.origTaxAmt;
				    	
				    	newObj.paramPremAmt = objAC.selectedRecord.paramPremAmt;
				    	newObj.prevPremAmt = objAC.selectedRecord.prevPremAmt;
				    	newObj.prevTaxAmt = objAC.selectedRecord.prevTaxAmt;
				    	
				    	newObj.premVatable = objAC.currentRecord.premVatable;
				    	newObj.premVatExempt = objAC.currentRecord.premVatExempt;
				    	newObj.premZeroRated = objAC.currentRecord.premZeroRated;
				    	
				    	newObj.recordStatus = 0;
				    	newObj.isSaved = objAC.currentRecord.isSaved;
				    	objAC.jsonDirectPremCollnsDtls.splice(i, 1, newObj);
				    	//objAC.jsonDirectPremCollnsDtls.push(newObj);
				    	v_counter = v_counter + 1;
					}
				}
		    }
	}
	
	function recomputeAllocation(recompPrem, recompTax, add) {
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
				method : "GET",
				parameters : {
					tranId : objACGlobal.gaccTranId,
					tranType : $F("tranType"),
					tranSource : $F("tranSource"),
					premSeqNo : $F("billCmNo"),
					instNo : $F("instNo"),
					fundCd : objACGlobal.fundCd,
					taxAmt : recompTax /*unformatCurrencyValue(objAC.currentRecord.prevTaxAmt)*/,
					paramPremAmt : unformatCurrencyValue(""+objAC.currentRecord.paramPremAmt),
					premAmt : recompPrem /*unformatCurrencyValue(objAC.currentRecord.origPremAmt)*/,
					collnAmt : unformatCurrency("premCollectionAmt"),
					premVatExempt: unformatCurrencyValue(objAC.currentRecord.premVatExempt),
					revTranId: objAC.currentRecord.revGaccTranId,
					taxType : $F("tranType")
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						
						var result = response.responseText.toQueryParams();
						
						var recomputedPrem = result.premAmt;
						var recomputedTax = result.taxAmt;
						
						 if(recomputedPrem != recompPrem || recomputedTax != recompTax) {
							showMessageBox("There is an overpayment on premium/tax found. Kindly delete and re-enter the record.");
							
							objAC.jsonTaxCollnsNew = JSON.parse(result.giacTaxCollnCur);

							objAC.sumGtaxAmt = result.taxAmt;
							$("directPremAmt").value = formatCurrency(result.premAmt);
							$("taxAmt").value = formatCurrency(result.taxAmt);
							
							if (objAC.currentRecord.otherInfo) {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.otherInfo.currRt;
							} else {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.currRt;
							}
							$("premVatExempt").value = result.premVatExempt;
							objAC.currentRecord.premVatExempt = result.premVatExempt;
							
							retrievedTaxCollns = objAC.jsonTaxCollnsNew;
							updateJSONTaxCollection(retrievedTaxCollns);
						} 
						if(add == "add") {
							addRecord();
						} else {
							updateDirectPremRow();
						}
						
					}
				}
			});
		} catch (e) {
			showErrorMessage("recomputeAllocation", e);
		}
		
	}
	
	$("btnAdd").observe("click", function() {
		var v_counter = 0;
		
		if (checkRequiredDisabledFields2()) {
			getIncTagForAdvPremPayts($("tranSource").value, $("billCmNo").value);
			if (!(checkExistInList(objACGlobal.gaccTranId, $("tranSource").value, $("billCmNo").value, $("instNo").value, $("tranType").value))) {
				//objAC.usedAddButton = "Y";
				//validateGIACS007Record($("tranSource").value, $("billCmNo").value, $("instNo").value, $("tranType").value);
				if (objAC.taxAllocationFlag == "Y") {
					var recompPrem = unformatCurrency("directPremAmt");
					var recompTax = unformatCurrency("taxAmt");
					recomputeAllocation(recompPrem, recompTax, "add");
				} else {
					addRecord();
				}
				//jsonTaxCollnsOnLoad.push(objAC.jsonTaxCollnsNew);
			}else {
				if ($("btnAdd").value == "Add") {
					showMessageBox("Row exist already with same Issuing Source, Bill No., Inst No., Tran ID.", imgMessage.ERROR);
				}else {updateObj = getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls,	"gaccTranId issCd premSeqNo instNo tranType", 
																objACGlobal.gaccTranId
																+ $("tranSource").value
																+ $("billCmNo").value
																+ $("instNo").value
																+ $("tranType").value);
					updateObj.collAmt = unformatCurrencyValue($("premCollectionAmt").value);
					updateObj.premAmt = unformatCurrencyValue($("directPremAmt").value);
					updateObj.taxAmt = unformatCurrencyValue($("taxAmt").value);
					updateObj.forCurrAmt = objAC.currentRecord.forCurrAmt;
					updateObj.particulars = $F("particulars");
					updateObj.incTag = objAC.currentRecord.incTag == "Y" ? "Y" : "N";
					
					$$("div[name='rowPremColln']").each(function(row) {
						if (row.hasClassName("selectedRow")) {
							row.down("label", 5).innerHTML = formatCurrency($("premCollectionAmt").value);
							row.down("label", 6).innerHTML = formatCurrency($("directPremAmt").value);
							row.down("label", 7).innerHTML = formatCurrency($("taxAmt").value);

							getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls,	"issCd premSeqNo instNo tranType",
									row.down("label", 2).innerHTML
							   + row.down("label", 3).innerHTML
							   + row.down("label", 4).innerHTML
							   + row.down("label", 1).innerHTML).recordStatus = -1;
							/*
							var newObj = getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls,	"issCd premSeqNo instNo tranType",
									row.down("label", 2).innerHTML
									   + row.down("label", 3).innerHTML
									   + row.down("label", 4).innerHTML
									   + row.down("label", 1).innerHTML);
							   
							newObj.recordStatus = 0;
							   
							objAC.jsonDirectPremCollnsDtls.push(newObj);
							*/
							if (objAC.taxAllocationFlag == "Y") {
								var recompPrem = unformatCurrency("directPremAmt");
								var recompTax = unformatCurrency("taxAmt");
								recomputeAllocation(recompPrem, recompTax, "update");
							} else {
								updateDirectPremRow();
							}
						}
					});
					updateTaxCollectionDiv(retrievedTaxCollns);
					resetFormValues();
					rowPremCollnDeselectedFn();
					$("btnAdd").value = "Add";
					disableButton("btnDelete");
					$$("div[name='rowPremColln']").each(function(row) {
						row.removeClassName("selectedRow");
					});
				}
			}
			computeTotals();
		} else {
			showMessageBox("Required fields must be entered.",
									imgMessage.ERROR);
		}
	});

	$("btnDelete").observe("click",	function() {
		var indx = 0;
		$$("div[name='rowPremColln']").each(function(row) {
			if (row.hasClassName("selectedRow")) {
				//added based on AC-SPECS-2012-11
				var selectedObj = getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls, "gaccTranId issCd premSeqNo instNo tranType",
						   objACGlobal.gaccTranId 
						   + row.down("label", 2).innerHTML
						   + row.down("label", 3).innerHTML
						   + row.down("label", 4).innerHTML
						   + row.down("label", 1).innerHTML);
			    
				if(nvl(selectedObj.commPaytSw, 0) == 1 || objAC.selectedRecord.commPaytSw == 1) {
					showMessageBox("Delete first the commission payment in "+selectedObj.issCd+
							" - "+selectedObj.premSeqNo+".", imgMessage.ERROR);
					return;
				}
				
				if(nvl(selectedObj.revGaccTranId, null) != null && (selectedObj.tranType == 1 || selectedObj.tranType == 3)) {
					showMessageBox("There is an existing reversal payment for this record. This record cannot be deleted.", 
							imgMessage.ERROR);
					return;
				}
				
				if (getObjectFromArrayOfObjects(objAC.jsonLoadDirectPremCollnsDtls,	"gaccTranId issCd premSeqNo instNo tranType",
											objACGlobal.gaccTranId + row.down("label", 2).innerHTML
																   + row.down("label", 3).innerHTML
																   + row.down("label", 4).innerHTML
																   + row.down("label", 1).innerHTML) == null) {
											objAC.jsonDirectPremCollnsDtls.splice(indx, 1);
				} else {
					getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls,	"issCd premSeqNo instNo tranType",
														row.down("label", 2).innerHTML
												   + row.down("label", 3).innerHTML
												   + row.down("label", 4).innerHTML
												   + row.down("label", 1).innerHTML).recordStatus = -1;
				}
				row.removeClassName("selectedRow");
				Effect.Fade(row, {
					duration : .2,
					afterFinish : function() {
					//added by alfie 11.26.2010
					hideTaxCollections($("taxCollectionTable"),	$("taxCollectionListContainer"));
					removeFromTaxCollectionsTable(objACGlobal.gaccTranId + 
												  row.down("label",	2).innerHTML
												+ row.down("label",	3).innerHTML
												+ row.down("label",	4).innerHTML
												+ row.down("label",	1).innerHTML);
					row.remove();
					checkTableIfEmpty("rowPremColln", "directPremiumCollectionTable");
					checkIfToResizeTable("premiumCollectionList", "rowPremColln");
					disableButton("btnDelete");
					$("btnAdd").value = "Add";
					enableButton("btnAdd");
					resetFormValues();
					computeTotals();
					objAC.formChanged = "Y";
					objAC.currentRecord = null;
					objAC.selectedRecord = null;
					makeRecordEditable("gdpcRecord");
				}
		});
			}
				indx += 1;
			});
			checkIfToResizeTable2("premiumCollectionList", "rowPremColln");
				changeTag = 1;
	});

	function deleteDirectPremCollns() {
		var deleteDirectPremCollnsList = eval("[]");
		var deleteDirectPremCollnss = {};
		var currObj = {};
		for ( var n = 0; n < objAC.jsonDirectPremCollnsDtls.length; n++) {
			currObj = objAC.jsonDirectPremCollnsDtls[n];

			if (currObj.recordStatus) {
				if (currObj.recordStatus == -1) {
					deleteDirectPremCollnss = {};
					deleteDirectPremCollnss.gaccTranId = currObj.gaccTranId;
					deleteDirectPremCollnss.issCd = currObj.issCd;
					deleteDirectPremCollnss.premSeqNo = currObj.premSeqNo;
					deleteDirectPremCollnss.instNo = currObj.instNo;
					deleteDirectPremCollnss.tranType = currObj.tranType;
					deleteDirectPremCollnsList.splice(
							deleteDirectPremCollnsList.length, 0,
							deleteDirectPremCollnss);
				}
			}

		}
		return prepareJsonAsParameter(deleteDirectPremCollnsList);
	}

	$("btnSaveDirectPrem").observe("click", function() {
		new Ajax.Request(
			"GIACDirectPremCollnsController?action=saveDirectPremCollnsDtls2",
			{
				method : "POST",
				parameters : {
					giacDirectPremCollns : giacDirectPremCollns(),
					listToDelete : deleteDirectPremCollns(),
					taxDefaultParams : taxDefaultsParam(),
					giacDirectPremCollnsAll : giacDirectPremCollnsAll(),
					gaccTranId : objACGlobal.gaccTranId,
					moduleName : "GIACS007",
					branchCd : objACGlobal.branchCd,
					fundCd : objACGlobal.fundCd,
					orFlag : objACGlobal.orFlag,
					tranSource : objACGlobal.tranSource,
					recCount : getRecordCount()
				//added by alfie 03-15-2011
				},
				evalScripts : true,
				asynchronous : false,
				onComplete : function(response) {
					//var result = response.responseText.toQueryParams();
					/*if (result.strParams == ""){
						showMessageBox("SUCCESS",imgMessage.SUCCESS);
					}
					showMessageBox("SUCCESS",imgMessage.SUCCESS);*/
					/* showMessageBox(response.responseText=="SUCCESS"?objCommonMessage.SUCCESS:response.responseText,
							imgMessage.SUCCESS); */
					//clearDiv("delPremColln");
					//changeDivTag("rowPremColln", "Y");	
					//$("formChanged").value = "N"; modified by alfie 12.14.2010
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						objAC.formChanged = 'N';

						var objc = {};
						var loadObj = objAC.jsonLoadDirectPremCollnsDtls;
						for ( var i = 0; i < objAC.jsonDirectPremCollnsDtls.length; i++) {
							objc = objAC.jsonDirectPremCollnsDtls[i];
							if (objc.recordStatus == 0) {
								objc.recordStatus = "";
								loadObj.splice(loadObj.length,0,objc); //added by alfie 12.14.2010
							} else if (objc.recordStatus == -1) {
								for ( var j = 0; j < loadObj.length; j++) {

									if (objc.premSeqNo
											+ objc.issCd
											+ objc.instNo == loadObj[j].premSeqNo
											+ loadObj[j].issCd
											+ loadObj[j].instNo) {
										loadObj.splice(j, 1);
									}
								}
							}
						}

						objAC.jsonDirectPremCollnsDtls = eval("[]");
						for ( var k = 0; k < loadObj.length; k++) {
							objAC.jsonDirectPremCollnsDtls
									.splice(
											objAC.jsonDirectPremCollnsDtls.length,
											0, loadObj[k]);
						}
						showMessageBox(objCommonMessage.SUCCESS ,imgMessage.SUCCESS);
					}
					
					changeTag = 0;
					loadDirectPremCollnsForm(1);
				}
			});
		});

	function giacDirectPremCollns() {
		var giacDirectPremCollnsList = eval("[]");
		var giacDirectPremCollnss = null;
		for ( var n = 0; n < objAC.jsonDirectPremCollnsDtls.length; n++) {
			giacDirectPremCollnss = {};
			if (objAC.jsonDirectPremCollnsDtls[n].recordStatus == 0) {
				giacDirectPremCollnss.gaccTranId = objAC.jsonDirectPremCollnsDtls[n].gaccTranId;
				giacDirectPremCollnss.tranType = objAC.jsonDirectPremCollnsDtls[n].tranType;
				giacDirectPremCollnss.issCd = objAC.jsonDirectPremCollnsDtls[n].issCd;
				giacDirectPremCollnss.premSeqNo = objAC.jsonDirectPremCollnsDtls[n].premSeqNo;
				giacDirectPremCollnss.instNo = objAC.jsonDirectPremCollnsDtls[n].instNo;
				giacDirectPremCollnss.collAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].collAmt);
				giacDirectPremCollnss.premAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].premAmt);
				giacDirectPremCollnss.taxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].taxAmt);
				giacDirectPremCollnss.orPrintTag = objAC.jsonDirectPremCollnsDtls[n].orPrintTag;
				giacDirectPremCollnss.particulars = objAC.jsonDirectPremCollnsDtls[n].particulars;
				giacDirectPremCollnss.premVatable = objAC.jsonDirectPremCollnsDtls[n].premVatable;
				giacDirectPremCollnss.premVatExempt = objAC.jsonDirectPremCollnsDtls[n].premVatExempt;
				giacDirectPremCollnss.premZeroRated = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].premZeroRated); //modified by: Halley 09.02.2013
				giacDirectPremCollnss.revGaccTranId = objAC.jsonDirectPremCollnsDtls[n].revGaccTranId;
				giacDirectPremCollnss.incTag 		= objAC.jsonDirectPremCollnsDtls[n].incTag;
				if (objAC.jsonDirectPremCollnsDtls[n].policyId==null) {
					giacDirectPremCollnss.policyId = objAC.jsonDirectPremCollnsDtls[n].otherInfo.policyId;
				} else {
					giacDirectPremCollnss.policyId = objAC.jsonDirectPremCollnsDtls[n].policyId;
				}
				
				if (objAC.jsonDirectPremCollnsDtls[n].otherInfo) {
					giacDirectPremCollnss.currCd = objAC.jsonDirectPremCollnsDtls[n].otherInfo.currCd;
					giacDirectPremCollnss.currRt = objAC.jsonDirectPremCollnsDtls[n].otherInfo.currRt;
					giacDirectPremCollnss.assdNo = objAC.jsonDirectPremCollnsDtls[n].otherInfo.assdNo; // added by: Nica 08.14.2012
				} else {
					giacDirectPremCollnss.currCd = objAC.jsonDirectPremCollnsDtls[n].currCd;
					giacDirectPremCollnss.currRt = objAC.jsonDirectPremCollnsDtls[n].currRt;
					giacDirectPremCollnss.assdNo = objAC.jsonDirectPremCollnsDtls[n].assdNo; // added by: Nica 08.14.2012
				}
				
				giacDirectPremCollnss.forCurrAmt = objAC.jsonDirectPremCollnsDtls[n].forCurrAmt;
				
				giacDirectPremCollnsList.splice(
						giacDirectPremCollnsList.length, 0,
						giacDirectPremCollnss);
			}
		}
		return prepareJsonAsParameter(giacDirectPremCollnsList);
	}

	function giacDirectPremCollnsAll() {
		var giacDirectPremCollnsAllList = eval("[]");
		var giacDirectPremCollnss = null;
		for ( var n = 0; n < objAC.jsonDirectPremCollnsDtls.length; n++) {
			//if (objAC.jsonDirectPremCollnsDtls[n].recordStatus==0) {
				giacDirectPremCollnss = {};
				giacDirectPremCollnss.gaccTranId = objAC.jsonDirectPremCollnsDtls[n].gaccTranId;
				giacDirectPremCollnss.tranType = objAC.jsonDirectPremCollnsDtls[n].tranType;
				giacDirectPremCollnss.issCd = objAC.jsonDirectPremCollnsDtls[n].issCd;
				giacDirectPremCollnss.premSeqNo = objAC.jsonDirectPremCollnsDtls[n].premSeqNo;
				giacDirectPremCollnss.instNo = objAC.jsonDirectPremCollnsDtls[n].instNo;
				giacDirectPremCollnss.collAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].collAmt);
				giacDirectPremCollnss.premAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].premAmt);
				giacDirectPremCollnss.taxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].taxAmt);
				giacDirectPremCollnss.orPrintTag = objAC.jsonDirectPremCollnsDtls[n].orPrintTag;
				giacDirectPremCollnss.particulars = objAC.jsonDirectPremCollnsDtls[n].particulars;
				giacDirectPremCollnss.premVatable = objAC.jsonDirectPremCollnsDtls[n].premVatable;
				giacDirectPremCollnss.premVatExempt = objAC.jsonDirectPremCollnsDtls[n].premVatExempt;
				giacDirectPremCollnss.premZeroRated = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].premZeroRated); //modified by: Halley 09.02.2013
				if (objAC.jsonDirectPremCollnsDtls[n].otherInfo) {
					giacDirectPremCollnss.currCd = objAC.jsonDirectPremCollnsDtls[n].otherInfo.currCd;
					giacDirectPremCollnss.currRt = objAC.jsonDirectPremCollnsDtls[n].otherInfo.currRt;
				} else {
					giacDirectPremCollnss.currCd = objAC.jsonDirectPremCollnsDtls[n].currCd;
					giacDirectPremCollnss.currRt = objAC.jsonDirectPremCollnsDtls[n].currRt;
				}
				giacDirectPremCollnss.forCurrAmt = objAC.jsonDirectPremCollnsDtls[n].forCurrAmt;
				
				giacDirectPremCollnsAllList.splice(
						giacDirectPremCollnsAllList.length, 0,
						giacDirectPremCollnss);
			}
		//}
		return prepareJsonAsParameter(giacDirectPremCollnsAllList);
	}

	function taxDefaultsParam() {
		var taxDefaultParamsList = eval("[]");
		var taxDefaultParams = null;
		for ( var n = 0; n < objAC.jsonDirectPremCollnsDtls.length; n++) {
			if (objAC.jsonDirectPremCollnsDtls[n].recordStatus == 0
					|| objAC.jsonDirectPremCollnsDtls[n].recordStatus == -1) {

				taxDefaultParams = {};
				taxDefaultParams.gaccTranId = objAC.jsonDirectPremCollnsDtls[n].gaccTranId;
				taxDefaultParams.tranType = objAC.jsonDirectPremCollnsDtls[n].tranType;
				taxDefaultParams.issCd = objAC.jsonDirectPremCollnsDtls[n].issCd;
				taxDefaultParams.instNo = objAC.jsonDirectPremCollnsDtls[n].instNo;
				taxDefaultParams.premSeqNo = objAC.jsonDirectPremCollnsDtls[n].premSeqNo;
				taxDefaultParams.fundCd = objACGlobal.fundCd;
				taxDefaultParams.collAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].collAmt);
				//taxDefaultParams.premAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].premAmt);
				//taxDefaultParams.taxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].taxAmt);
				taxDefaultParams.origTaxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].origTaxAmt);
				
				taxDefaultParams.paramPremAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].paramPremAmt);
				taxDefaultParams.prevPremAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].prevPremAmt);
				taxDefaultParams.prevTaxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].prevTaxAmt);
				
				if (objAC.jsonDirectPremCollnsDtls[n].otherInfo) {
					taxDefaultParams.origPremAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].otherInfo.origPremAmt);
					//taxDefaultParams.origTaxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].otherInfo.origTaxAmt);
				} else {
					taxDefaultParams.origPremAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].origPremAmt);
					//taxDefaultParams.origTaxAmt = unformatCurrencyValue(""+objAC.jsonDirectPremCollnsDtls[n].origTaxAmt);
				}
				taxDefaultParams.premVatable = objAC.jsonDirectPremCollnsDtls[n].premVatable;
				taxDefaultParams.premVatExempt = objAC.jsonDirectPremCollnsDtls[n].premVatExempt;
				//taxDefaultParams.premZeroRated = objAC.jsonDirectPremCollnsDtls[n].premZeroRated;
				
				taxDefaultParams.recordStatus = objAC.jsonDirectPremCollnsDtls[n].recordStatus;
				taxDefaultParams.sumTaxTotal = objAC.jsonDirectPremCollnsDtls[n].taxAmt;
				taxDefaultParams.revGaccTranId = objAC.jsonDirectPremCollnsDtls[n].revGaccTranId; // added by: Nica 06.22.2012
				
				taxDefaultParamsList.splice(taxDefaultParamsList.length, 0, taxDefaultParams);
				//break;
			}
		}
		return prepareJsonAsParameter(taxDefaultParamsList);
	}

	/* OBSERVE BUTTON OBJECTS*/

	$("btnUpdate").observe("click", function() {
		if (objAC.jsonDirectPremCollnsDtls.length > 0) {
			if (objAC.formChanged == "N") {

				var params = [];
				var obj = {};

				for ( var p = 0; p < objAC.jsonDirectPremCollnsDtls.length; p++) {
					obj = {};
					obj.issCd = objAC.jsonDirectPremCollnsDtls[p].issCd;
					obj.premSeqNo = objAC.jsonDirectPremCollnsDtls[p].premSeqNo;
					if (objAC.jsonDirectPremCollnsDtls[p].lineCd==null) {
						obj.lineCd = objAC.jsonDirectPremCollnsDtls[p].otherInfo.lineCd;
					} else {
						obj.lineCd = objAC.jsonDirectPremCollnsDtls[p].lineCd;
					}
					obj.tranId = objAC.jsonDirectPremCollnsDtls[p].gaccTranId;
					if (objAC.jsonDirectPremCollnsDtls[p].policyId==null) {
						obj.policyId = objAC.jsonDirectPremCollnsDtls[p].otherInfo.policyId;
					} else {
						obj.policyId = objAC.jsonDirectPremCollnsDtls[p].policyId;
					}
					obj.payorBtn = payorType == "" ? "A" : payorType;

					params.push(obj);
				}
				
				var msg = "";
				 new Ajax.Request(
						"GIACDirectPremCollnsController?action=updateAllPayorIntmDtls2",
						{
							method : "POST",
							parameters : {
								premCollnsDtls : prepareJsonAsParameter(params)
							},
							evalScripts : true,
							asynchronous : false,
							onComplete : function(response) {
								msg = response.responseText;
							}
						}); 
				//});
				if ($$("div[name='rowPremColln']").size() > 0) {
					showMessageBox(msg, imgMessage.INFO);
				}
			} else {
				showMessageBox(
						"Please save your changes first before pressing this button.",
						imgMessage.INFO);
			}
		}
	});

	$("oscmBillCmNo").observe("click", function() {
		if ($("tranType").selectedIndex != 0
				&& $("tranSource").selectedIndex != 0) {
			openSearchInvoiceModal();
		} else {
			showMessageBox(
					"Please select a transaction type and issue source first.",
					imgMessage.ERROR);
		}
	});

	$("oscmInstNo").observe("click", function() {
		//showInstNoModal();
		if ($("tranType").selectedIndex != 0
				&& $("tranSource").selectedIndex != 0
				&& !$F("billCmNo").empty()) {
			openSearchInvoiceModal();
		} else {
			showMessageBox(
					"Please select a transaction type, issue source and Bill No. first.",
					imgMessage.ERROR);
		}
	});


	$("premCollectionAmt").observe("change", function() {
		var collnAmt = unformatCurrencyValue($("premCollectionAmt").value);
		if (collnAmt) {
 			if (collnAmt != objAC.currentRecord.origCollAmt) {
	  			objAC.preChangedFlag = 'Y';
				//if (!$F("instNo").empty()) {
				if (!$F("instNo").empty() && objAC.overideCalled == 'N') {	 //added by d.alcantara, 01/31/2012, based on SR-8450 implemented in c.s.
				//if ($F("taxAllocationFlag") == "Y"){
					if (objAC.taxAllocationFlag == "Y") {
						withTaxAllocation();
					} else {
						noTaxAllocation();
					}
				}
				
			} else {
				$("premCollectionAmt").value = formatCurrency(collnAmt);
				$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt);
				$("taxAmt").value = formatCurrency(objAC.currentRecord.origTaxAmt
						.replace(/,/g, ""));
			}
		} else {
		 		$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
				customShowMessageBox("Please input values from 0-9.", imgMessage.WARNING, "premCollectionAmt");
		}
	});

	$("btnDatedCheck").observe("click", function() {
		Modalbox.show(contextPath+"/GIACDirectPremCollnsController?action=showDatedCheckDetail&ajaxModal=1",
			{
				title : "Dated Check Details",
				width : 500,
				asynchronous : false
			});
	});

	$("btnPremColln").observe("click", function() {
		loadAccountingPopupOverlay(
				"/GIACDirectPremCollnsController?action=printPremiumCollections",
				"Print Premium Collections",
				showPrintGenerator, 400, 150, 100);
	});

	$("btnForeignCurrency").observe("click",function() {
		if ($("tranType").selectedIndex != 0
				&& $("tranSource").selectedIndex != 0
				&& !$F("billCmNo").empty()) {
			loadAccountingPopupOverlay(
					"/GIACDirectPremCollnsController?action=showForeignCurrDtls",
					"Foreign Currency", showForeignCurrDtls,
					400, 150, 100);
		} else {
			showMessageBox(
					"Please select a transaction type, issue source and Bill No. first.",
					imgMessage.ERROR);
		}
	});

	$("btnPolicy").observe("click", function() {
		loadAccountingPopupOverlay(
				"/GIACDirectPremCollnsController?action=showPolicyEntry",
				"Policy Entry", showPolicyEntry, 419, 150, 100);
	});

	$("btnSpecUpdate").observe("click", function() {
		if (objAC.formChanged == 'N') {
			if ($$("div[name='rowPremColln']").size() > 0) {
				loadAccountingPopupOverlay(
						"/GIACDirectPremCollnsController?action=showSpecUpdate",
						"Update only:", showSpecUpdate, 520,
						150, 100);
			}
		} else {
			showMessageBox(
					"Please save your changes first before pressing this button.",
					imgMessage.INFO);
		}
	});

	$("btnInvoice").observe("click", function() {
		if ($("tranType").selectedIndex != 0/*
				&& $("tranSource").selectedIndex != 0*/) {
			openSearchInvoiceModal();
		}/* else {
			showMessageBox(
					"Please select a transaction type and issue source first.",
					imgMessage.ERROR);
		}*/
	});

	$("btnCancel").observe("click", function() {
		objAC.overdueOverride = null;
		objAC.claimsOverride = null;
		objAC.cancelledOverride = null;
		fireEvent($("acExit"), "click");
	});
	
	/* END OBSERVE BUTTON OBJECTS*/

	function resetRetrievedValues() {
		$("polEndtNo").value = "";
		objAC.policyId = "";
		objAC.lineCd = "";
		objAC.sublineCd = "";
		objAC.issCd = "";
		objAC.issueYear = "";
		objAC.polSeqNo = "";
		objAC.endtSeqNo = "";
		objAC.endtType = "";
		objAC.polFlag = "";
		objAC.assdNo = "";
		$("assdName").value = "";
		$("particulars").value = "";
		objAC.currCd = "";
		objAC.currRt = "";
		objAC.currShortName = "";
		objAC.currDesc = "";
	}

	function checkExistInList(paramGaccTranId, paramTranSource, paramBillCmNo,
			paramInstNo, paramTranType) {
		var exist = false;
		if (getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls,
				"gaccTranId issCd premSeqNo instNo tranType", paramGaccTranId
						+ paramTranSource + paramBillCmNo + paramInstNo
						+ paramTranType) != null) {
			exist = true;
		}
		return exist;
	}

	function showInstNoModal() {
		if ($("tranType").selectedIndex != 0
				&& $("tranSource").selectedIndex != 0
				&& !$F("billCmNo").empty()) {
			Modalbox.show(
				contextPath
						+ "/GIACDirectPremCollnsController?action=showInstNoDetails&ajaxModal=1&premSeqNo="
						+ $F("billCmNo") + "&issCd="
						+ $F("tranSource"), {
					title : "Installments",
					width : 600,
					asynchronous : false
				});
		} else {
			showMessageBox(
					"Please select a transaction type, issue source and Bill No. first.",
					imgMessage.ERROR);
		}
	}

	function initializeChangeOfValuesChecker() {
		objAC.requery = "false";
		$$("input[type='text'].changed").each(function(m) {
			m.observe("change", function() {
				objAC.requery = "true";
			});
		});

		$$("select.changed").each(
				function(m) {
					m.observe("change", function() {

						if (m.id == "tranType") {

							$("tranSource").value = "";
							$("billCmNo").value = "";
							$("instNo").value = "";
							$("premCollectionAmt").value = "0.00";
							$("directPremAmt").value = "0.00";
							$("taxAmt").value = "0.00";
							$("assdName").value = "";
							$("polEndtNo").value = "";
							$("particulars").value = "";

						} else {

							$("billCmNo").value = "";
							$("instNo").value = "";
							$("premCollectionAmt").value = "0.00";
							$("directPremAmt").value = "0.00";
							$("taxAmt").value = "0.00";
							$("assdName").value = "";
							$("polEndtNo").value = "";
							$("particulars").value = "";
						}
						if ($("tranType").selectedIndex != 0/*
								&& $("tranSource").selectedIndex != 0*/) {
							enableButton("btnInvoice");
						} else {
							disableButton("btnInvoice");
						}
					});
				});
	}

	function withTaxAllocation() {
		if ($F("tranType") == "1" || $F("tranType") == "4") {
			if (unformatCurrency("premCollectionAmt") < 0) {
				customShowMessageBox("Negative transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
				return;
			}
		} else {
			if (unformatCurrency("premCollectionAmt") > 0) {
				customShowMessageBox("Positive transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
				return;
			}
		}
		
		/* This trigger will restrict the amount being entered from    */
		/* exceeding the allowed collection/refundable amount.         */
		/* Zero amounts will also be disallowed.                       */
		if (Math.abs(unformatCurrency("premCollectionAmt")) > Math
				.abs(parseFloat(objAC.currentRecord.maxCollAmt))) {
			customShowMessageBox("Collection amount should not exceed "
					+ (parseFloat(objAC.currentRecord.maxCollAmt)) + ".", imgMessage.WARNING,
					"premCollectionAmt");
			$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
			return;
		} else if (unformatCurrency("premCollectionAmt") == 0) {
			customShowMessageBox("Collection amount cannot be zero.",
					imgMessage.WARNING, "premCollectionAmt");
			$("premCollectionAmt").value = formatCurrency(objAC.currentRecord.origCollAmt);
			return;
		}
		/* Recompute premium amount and tax amount based on the collection amount entered */
		if (objAC.preChangedFlag == 'Y') {

			if (objAC.taxPriorityFlag == null) { //$F("taxPriorityFlag") modified by alfie 12.10.2010
				showMessageBox(
						"There is no existing PREM_TAX_PRIORITY parameter in GIAC_PARAMETERS table.",
						imgMessage.WARNING);
				return;
			}

			if (objAC.taxPriorityFlag == 'P') {
				/*
				 ** Premium amount has higher priority than tax amount
				 */
				if (unformatCurrency("premCollectionAmt") == parseFloat(objAC.currentRecord.origCollAmt)) {
					$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt); //$F("origPremAmt");
					$("taxAmt").value = formatCurrency(objAC.currentRecord.origTaxAmt
							.replace(/,/g, ""));
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
						.abs(unformatCurrency("directPremAmt"))) {
					$("directPremAmt").value = $F("premCollectionAmt");
					$("taxAmt").value = formatCurrency(0);
				} else {
					$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt);
					$("taxAmt").value = formatCurrency(unformatCurrency("premCollectionAmt")
							- parseFloat(objAC.currentRecord.origPremAmt
									.replace(/,/g, "")));
				}
			} else {
				/*
				 ** Tax amount has higher priority than premium amount
				 */
				if (Math.abs(unformatCurrency("premCollectionAmt")) == Math
						.abs(parseFloat(objAC.currentRecord.origCollAmt))) {
					$("directPremAmt").value = formatCurrency(objAC.currentRecord.origPremAmt);
					$("taxAmt").value = formatCurrency(objAC.currentRecord.origTaxAmt
							.replace(/,/g, ""));
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
						.abs(parseFloat(unformatCurrencyValue(""+objAC.currentRecord.origTaxAmt)))) {
					$("directPremAmt").value = formatCurrency(0);
					$("taxAmt").value = $F("premCollectionAmt");
				} else {
					$("directPremAmt").value = unformatCurrency("premCollectionAmt")
							- parseFloat(unformatCurrencyValue(""+objAC.currentRecord.origTaxAmt));
					$("taxAmt").value = formatCurrency(unformatCurrencyValue(""+objAC.currentRecord.origTaxAmt));
				}
			}
			
			if (objAC.currentRecord.otherInfo) {
				objAC.currentRecord.forCurrAmt = unformatCurrencyValue($("premCollectionAmt").value)
						/ parseFloat(objAC.currentRecord.otherInfo.currRt);
			} else {
				objAC.currentRecord.forCurrAmt = unformatCurrencyValue($("premCollectionAmt").value)
						/ parseFloat(objAC.currentRecord.currRt);
			}

			objAC.currentRecord.paramPremAmt = nvl(objAC.currentRecord.paramPremAmt, null)==null ? 
					(nvl(objAC.currentRecord.maxPremVatable, null)==null ? 
							unformatCurrency("directPremAmt") : objAC.currentRecord.maxPremVatable) : objAC.currentRecord.paramPremAmt; //gagamitin to sa saving :)
			objAC.currentRecord.prevPremAmt = $F("directPremAmt");
			objAC.currentRecord.prevTaxAmt = $F("taxAmt");

			// Call procedure for the tax breakdown 
			if (Math.abs(unformatCurrency("taxAmt")) == 0) {
				$("directPremAmt").value = $F("premCollectionAmt");
				$("taxAmt").value = formatCurrency(0);
				
				if(objAC.currentRecord.premZeroRated == 0) {
					objAC.currentRecord.premVatExempt = unformatCurrency("directPremAmt");
					$("premVatExempt").value = objAC.currentRecord.premVatExempt;
				} else {
					objAC.currentRecord.premZeroRated = unformatCurrency("directPremAmt");
					$("premZeroRated").value = objAC.currentRecord.premZeroRated; 
				}
				
				var checkBill = checkSpecialBillGIACS007($F("tranSource"), $F("billCmNo"));
				if (checkBill == "Y") {
					objAC.currentRecord.premVatable = unformatCurrency("directPremAmt");
					$("premVatable").value = objAC.currentRecord.premVatable;	 
				}
			} else {
				getTaxType1($F("tranType"));
				
				if(objAC.currentRecord.premZeroRated == 0) {
					if((unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt")) == 0) {
						$("premVatable").value = 0;
						objAC.currentRecord.premVatable = 0;
					} else if((unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt")) > 0) {
						$("premVatable").value = unformatCurrency("directPremAmt") - unformatCurrency("premVatExempt");
						objAC.currentRecord.premVatable = $F("premVatable");
					}
				} else {
					objAC.currentRecord.premZeroRated = unformatCurrency("directPremAmt");
					objAC.currentRecord.premVatable = 0;
					objAC.currentRecord.premVatExempt = 0;
				}
				
			}
			objAC.preChangedFlag = 'N';
		}
	}

	function noTaxAllocation() {
		if ($F("tranType") == "1" || $F("tranType") == "4") {
			if (unformatCurrency("premCollectionAmt") < 0) {
				customShowMessageBox("Negative transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
			}
		} else {
			if (unformatCurrency("premCollectionAmt") > 0) {
				customShowMessageBox("Positive transactions are not accepted.",
						imgMessage.WARNING, "taxAmt");
				$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
			}
		}

		/* This trigger will restrict the amount being entered from    */
		/* exceeding the allowed collection/refundable amount.         */
		/* Zero amounts will also be disallowed.                       */
		if (Math.abs(unformatCurrency("premCollectionAmt")) > Math
				.abs(objAC.currentRecord.origCollAmt)) {
			customShowMessageBox("Collection amount should not exceed "
					+ objAC.currentRecord.origCollAmt + ".",
					imgMessage.WARNING, "premCollectionAmt");
			$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
			$("directPremAmt").value = objAC.currentRecord.origPremAmt;
			$("taxAmt").value = objAC.currentRecord.origTaxAmt;
		} else if (unformatCurrency("premCollectionAmt") == "0") {
			customShowMessageBox("Collection amount cannot be zero.",
					imgMessage.WARNING, "premCollectionAmt");
			$("premCollectionAmt").value = objAC.currentRecord.origCollAmt;
		}

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
				if (unformatCurrency("premCollectionAmt") == objAC.currentRecord.origCollAmt) {
					$("directPremAmt").value = objAC.currentRecord.origPremAmt;
					$("taxAmt").value = objAC.currentRecord.origTaxAmt;
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
						.abs(objAC.currentRecord.origPremAmt)) {
					$("directPremAmt").value = $F("premCollectionAmt");
					$("taxAmt").value = formatCurrency(0);
				} else {
					$("directPremAmt").value = objAC.currentRecord.origPremAmt;
					$("taxAmt").value = unformatCurrency("premCollectionAmt")
							- objAC.currentRecord.origPremAmt;
				}
			} else {
				/*
				 ** Tax amount has higher priority than premium amount
				 */
				if (unformatCurrency("premCollectionAmt") == objAC.currentRecord.origCollAmt) {
					$("directPremAmt").value = unformatCurrency(objAC.currentRecord.origPremAmt);
					$("taxAmt").value = $F("origTaxAmt");
				} else if (Math.abs(unformatCurrency("premCollectionAmt")) <= Math
						.abs(objAC.currentRecord.origTaxAmt)) {
					$("directPremAmt").value = formatCurrency(0);
					$("taxAmt").value = $F("premCollectionAmt");
				} else {
					$("directPremAmt").value = unformatCurrency("premCollectionAmt")
							- objAC.currentRecord.origTaxAmt;
					$("taxAmt").value = objAC.currentRecord.origTaxAmt;
				}
			}
 
			objAC.currentRecord.forCurrAmt = unformatCurrency("premCollectionAmt")
					/ parseFloat(objAC.currentRecord.convRate);
		}
	}

	function getTaxType1(taxType) {
		try {
			new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=taxDefaultValueType", {
					method : "GET",
					parameters : {
						tranId : objACGlobal.gaccTranId,
						tranType : $F("tranType"),
						tranSource : $F("tranSource"),
						premSeqNo : $F("billCmNo"),
						instNo : $F("instNo"),
						fundCd : objACGlobal.fundCd,
						/* taxAmt : unformatCurrency("taxAmt"),//objAC.currentRecord.taxAmt,
						paramPremAmt : unformatCurrencyValue(""+objAC.currentRecord.origPremAmt),
						premAmt : unformatCurrencyValue($("directPremAmt").value),//unformatCurrency("premCollectionAmt") - objAC.currentRecord.taxAmt.replace(/,/g, "") ,
						collnAmt : unformatCurrency("premCollectionAmt"),
						premVatExempt: nvl($F("premVatExempt"), "") == "" ? 0 : unformatCurrency("premVatExempt"), */
						taxAmt : unformatCurrencyValue(objAC.currentRecord.prevTaxAmt),//objAC.currentRecord.taxAmt,
						paramPremAmt : unformatCurrencyValue(""+objAC.currentRecord.paramPremAmt),
						premAmt : unformatCurrencyValue(objAC.currentRecord.origPremAmt),//unformatCurrency("premCollectionAmt") - objAC.currentRecord.taxAmt.replace(/,/g, "") ,
						collnAmt : unformatCurrency("premCollectionAmt"),
						premVatExempt: unformatCurrencyValue(objAC.currentRecord.premVatExempt), //parameters edited 09.07.2012
						revTranId: objAC.currentRecord.revGaccTranId,
						taxType : taxType
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							objAC.jsonTaxCollnsNew = JSON.parse(result.giacTaxCollnCur);
							/*
							var result = JSON.parse(response.responseText);
							objAC.jsonTaxCollnsNew = result.giacTaxCollnCur;
							*/
							objAC.sumGtaxAmt = result.taxAmt;
							$("directPremAmt").value = formatCurrency(result.premAmt);
							$("taxAmt").value = formatCurrency(result.taxAmt);
							$("premCollectionAmt").value = formatCurrency(result.collnAmt);
							
							if (objAC.currentRecord.otherInfo) {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.otherInfo.currRt;
							} else {
								objAC.currentRecord.forCurrAmt = result.collnAmt
										* objAC.currentRecord.currRt;
							}
							
							$("premVatExempt").value = result.premVatExempt;
							objAC.currentRecord.premVatExempt = result.premVatExempt;
							
							retrievedTaxCollns = objAC.jsonTaxCollnsNew;
							updateJSONTaxCollection(retrievedTaxCollns);
							//updateTaxCollectionDiv(objAC.jsonTaxCollnsNew);
						}
					}
				});
		} catch (e) {
			showMessageBox(e.message);
		}
	}
	
	function updateJSONTaxCollection(objArr) {
		var exists = false;
		for(var i=0, length = objArr.length; i<length; i++) {
			for(var j=0; j<jsonTaxCollnsOnLoad.length; j++) {
				if(objArr[i].instNo == jsonTaxCollnsOnLoad[j].instNo &&
						objArr[i].b160TaxCd == jsonTaxCollnsOnLoad[j].b160TaxCd &&
						objArr[i].b160IssCd == jsonTaxCollnsOnLoad[j].b160IssCd &&
						objArr[i].transactionType == jsonTaxCollnsOnLoad[j].transactionType &&
						objArr[i].b160PremSeqNo == jsonTaxCollnsOnLoad[j].b160PremSeqNo) {
					exists = true;
					
				}
				if(exists) {
					jsonTaxCollnsOnLoad.splice(j, 1, objArr[i]);
				} else {
					jsonTaxCollnsOnLoad.push(objArr[i]);
				}
				
			}
		}
	}
	
	function updateTaxCollectionDiv(objArr) {
		try {
			var taxArr = jsonTaxCollnsOnLoad.concat(objAC.jsonTaxCollnsNew);;
			taxArr = taxArr.concat(objAC.jsonTaxCollnsNewRecordsList);
			var preparedTaxObj = null;
			var exists = false;
			if(objArr != null) {
				for(var i=0, length = objArr.length; i<length; i++) {
					preparedTaxObj = prepareTaxCollectionsInfo(objArr[i]);	
					for(var j=0; j<taxArr.length; j++) {
						if(objArr[i].instNo == taxArr[j].instNo &&
								objArr[i].b160TaxCd == taxArr[j].b160TaxCd &&
								objArr[i].b160IssCd == taxArr[j].b160IssCd &&
								objArr[i].transactionType == taxArr[j].transactionType &&
								objArr[i].b160PremSeqNo == taxArr[j].b160PremSeqNo) {
							exists = true;
							jsonTaxCollnsOnLoad.splice(j, 1, objArr[i]);
							break;
						}
					}
					
					var rowId = "taxRow"+objArr[i].b160IssCd+objArr[i].b160PremSeqNo+
										objArr[i].transactionType+objArr[i].instNo+objArr[i].b160TaxCd;
					if(exists) {
						$(rowId).update(preparedTaxObj);
					} else {
						var newDiv = new Element("div");
						newDiv.setAttribute("id", rowId);
						newDiv.setAttribute("name", "taxRow");
						newDiv.addClassName("tableRow");
						newDiv.update(preparedTaxObj);
						$("taxCollectionListContainer").insert({bottom: newDiv});
					}
				}
			}
		} catch(e) {
			showErrorMessage("updateTaxCollectionDiv", e);
		}
		
	}

	function clearDiv(divName) {
		$$("div[name='" + divName + "']").each(function(row) {
			row.remove();
		});
	}

	function changeDivTag(divName, tag) {
		$$("div[name='" + divName + "']").each(function(row) {
			row.down("input", 16).value = tag;
		});
	}

	function checkClaim() {
		//var claimExist = false;
		new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=checkClaim", {
			method : "GET",
			parameters : {
				premSeqNo : $F("billCmNo"),
				issCd : $F("tranSource")
			},
			evalScripts : true,
			asynchronous : false,
			onComplete : function(response) {
				if (response.responseText == 'TRUE') {
					showConfirmBox(
							"Premium Collection",
							"This policy has an existing claim. Would you like to continue with the premium collections?",
							"Ok", "Cancel", function() {
								validateUserFunc('CC', 'GIACS007', 'claim');
							}, "");
					} else {
						objAC.overdueStatusFlag = 'Y';
						objAC.requery = "true";
						objAC.overdueStatusFlag = 'Y';
					}
				}
		});
	}

	initializeChangeOfValuesChecker();
	initializeAccordion();

	function showForeignCurrDtls() {
		Effect.Appear("foreignCurrMainDiv", {
			duration : .001
		});
		/* if (objAC.selectedRecord.currCd) {
			$("fCurrCd").value = objAC.selectedRecord.currCd;
			$("fCurrRt").value = formatCurrency(objAC.selectedRecord.currRt);//$F("currRt");
			$("fCurrCdDesc").value = getCurrencyDetail();//$F("transCurrDesc");
			$("fCurrAmt").value = formatCurrency(objAC.selectedRecord.collAmt
					/ parseFloat(objAC.selectedRecord.currRt));
		} else {
			$("fCurrCd").value = objAC.selectedRecord.otherInfo.currCd;
			$("fCurrRt").value = $F("currRt");//formatCurrency(objAC.selectedRecord.otherInfo.currRt);//
			$("fCurrCdDesc").value = $F("transCurrDesc");
			$("fCurrAmt").value = formatCurrency(unformatCurrencyValue(""+objAC.selectedRecord.otherInfo.premCollectionAmt)
					/ parseFloat(objAC.selectedRecord.otherInfo.currRt));
		} */
		var objForeign = nvl(objAC.selectedRecord, null)==null ? objAC.currentRecord : objAC.selectedRecord;
		
		if (objForeign.currCd) {
			$("fCurrCd").value = objForeign.currCd;
			$("fCurrRt").value = formatCurrency(objForeign.currRt);//$F("currRt");
			$("fCurrCdDesc").value = getCurrencyDetail(objForeign.currCd);//$F("transCurrDesc");
		//	$("fCurrAmt").value = formatCurrency(objForeign.collAmt / parseFloat(objForeign.currRt));
			$("fCurrAmt").value = formatCurrency(unformatCurrency("premCollectionAmt") / parseFloat(objForeign.currRt));
		} else {
			$("fCurrCd").value = objForeign.otherInfo.currCd;
			$("fCurrRt").value = $F("currRt");//formatCurrency(objForeign.otherInfo.currRt);//
			$("fCurrCdDesc").value = $F("transCurrDesc");
			/* $("fCurrAmt").value = formatCurrency(unformatCurrencyValue(""+objForeign.otherInfo.premCollectionAmt)
					/ parseFloat(objForeign.otherInfo.currRt)); */
			$("fCurrAmt").value = formatCurrency(unformatCurrency("premCollectionAmt")
					/ parseFloat(objForeign.otherInfo.currRt));		
		}
	}

	function getCurrencyDetail(currCd){
		var currDesc = "";
		for (var i=0; i<objAC.currDtls.length; i++){
			//if (objAC.currDtls[i].code == objAC.selectedRecord.currCd){
			if (objAC.currDtls[i].code == currCd){
				currDesc = objAC.currDtls[i].desc;
			}
		}
		return currDesc;
	}
	
	$("billCmNo").observe("change", function() {
		if ($("tranSource").selectedIndex == 0) {
			showMessageBox(
					"No issue source selected. Please select an issue source to continue.",
					imgMessage.ERROR);
			$("billCmNo").value = "";
		} else if(!isNaN($F("billCmNo")) && $F("billCmNo")!="") {
			$("instNo").value = "";
			$("premCollectionAmt").value = "0.00";
			$("directPremAmt").value = "0.00";
			$("taxAmt").value = "0.00";
			$("assdName").value = "";
			$("polEndtNo").value = "";
			$("particulars").value = "";
			objAC.usedAddButton = "Y";
			
			validatePremSeqNoGIACS007($F("tranType"), $F("tranSource"), $F("billCmNo"), 
					function() {preValidateBill($F("tranSource"), $F("billCmNo"));}, clearInvalidPrem);
		} else {
			$("billCmNo").clear();
		}
	});
	
	$("instNo").observe("change", function() {
		if ($("billCmNo").value == "") {
			showMessageBox(
					"No Bill/CM No. entered. Please enter a Bill/CM No. to continue.",
					imgMessage.ERROR);
			$("instNo").value = "";
		} else {
			objAC.usedAddButton = "Y";
			getEnteredBillDetails($("tranSource").value,
					$("billCmNo").value, $("tranType").value,
					$("instNo").value);
		}
	});

	function getEnteredBillDetails(pIssCd, pPremSeqNo, pTranType, pInstNo) {
		new Ajax.Request(
				contextPath
						+ "/GIACDirectPremCollnsController?action=getEnteredBillDetails",
				{
					method : "GET",
					parameters : {
						premSeqNo : pPremSeqNo,
						issCd : pIssCd,
						tranType : pTranType,
						instNo : pInstNo
					},
					evalScripts : true,
					asynchronous : false,
					onComplete : function(response) {
						var res = JSON.parse(response.responseText);
						var bills = eval(Object.toJSON(res.bills));
						
						if(res.errorMsg != null && res.errorMsg != "") {
							showMessageBox(res.errorMsg);
							clearInvalidPrem();
							return;
						}
						
						if(bills.length > 1) {
							fireEvent($("oscmInstNo"), "click");
							return;
						}  else if (bills.length < 1) {
							showMessageBox("This Installment No. does not exist.");
							return;
						}
						
						var billDetails = getObjectFromArrayOfObjects(
								bills,
								"issCd premSeqNo instNo", pIssCd + pPremSeqNo
										+ pInstNo);
						
						if (!billDetails) {
							customShowMessageBox(
									"Installment doesn't exist or the bill entered was for another transaction type.",
									imgMessage.WARNING, "instNo");
							clearInvalidPrem();
						} else { 
							$("assdName").value = billDetails.assdName;
							$("polEndtNo").value = billDetails.policyNo;
							//if ("1,4".indexOf(pTranType)!= -1) {
							if ("1".indexOf(pTranType)!= -1) {
								$("premCollectionAmt").value = formatCurrency(billDetails.collectionAmt);
								$("directPremAmt").value = formatCurrency(billDetails.premAmt);
								$("taxAmt").value = formatCurrency(billDetails.taxAmt);
							} else {
								$("premCollectionAmt").value = formatCurrency(billDetails.collectionAmt1);
								$("directPremAmt").value = formatCurrency(billDetails.premAmt1);
								$("taxAmt").value = formatCurrency(billDetails.taxAmt1);
							}

							objAC.currentRecord = new Object(billDetails);
							objAC.currentRecord.collAmt = billDetails.collectionAmt;
							objAC.currentRecord.origCollAmt = billDetails.collectionAmt;
							objAC.currentRecord.origPremAmt = billDetails.premAmt;
							objAC.currentRecord.origTaxAmt = billDetails.taxAmt;
							objAC.currentRecord.paramPremAmt = billDetails.premAmt;
							objAC.currentRecord.currCd = billDetails.currCd == null ? objAC.defCurrency : billDetails.currCd;
							objAC.currentRecord.currRt = billDetails.currRt == null ? objAC.defCurrRate : billDetails.currRt;
							objAC.currentRecord.currShortName = "";
							objAC.currentRecord.currDesc = "";
							objAC.currentRecord.policyId = billDetails.policyId;
							objAC.currentRecord.lineCd = billDetails.lineCd;
							objAC.currentRecord.maxCollAmt = billDetails.collectionAmt;
							objAC.currentRecord.revGaccTranId = billDetails.revGaccTranId;
							objAC.currentRecord.premVatable = billDetails.premVatable;
							objAC.currentRecord.premVatExempt = billDetails.premVatExempt;
							objAC.currentRecord.premZeroRated = billDetails.premZeroRated;
							objAC.currentRecord.prevPremAmt = billDetails.premAmt;
							
							objAC.preChangedFlag = 'Y';
							/* setPremTaxTranType(pIssCd, pPremSeqNo, pTranType, 
									pInstNo, billDetails.premAmt, 
									function(res) {
										objAC.premVatable = res.premVatable;
										objAC.premVatExempt = res.premVatExempt;
										objAC.premZeroRated = res.premZeroRated;
										objAC.maxPremVatable = res.maxPremVatable;
									}); */
							
							if(billDetails.currCd == '1') {
								disableButton("btnForeignCurrency");
								//enableButton("btnForeignCurrency");
							} else {
								enableButton("btnForeignCurrency");
								//disableButton("btnForeignCurrency");
							}
						}
						//moved here from observe	
						if($F("btnAdd") == "Add") {
							validateGIACS007Record($("tranSource").value, $("billCmNo").value, $("instNo").value, $("tranType").value);
						}	
					}
				});
	}

	var billDetailToAdd = null;
	function validateGIACS007Record(paramTranSource, paramBillCmNo,
			paramInstNo, paramTranType) {
		new Ajax.Request(
				contextPath
						+ "/GIACDirectPremCollnsController?action=validateRecord",
				{
					method : "GET",
					parameters : {
						issCd : paramTranSource,
						premSeqNo : paramBillCmNo,
						instNo : paramInstNo,
						tranType : paramTranType,
						billPremiumOverdue : objAC.checkBillDueDate,
						tranDate : $F("tranDate")
					},
					evalScripts : true,
					asynchronous : false,
					onCreate : function() {
						
					},
					onComplete : function(response) {
						var result = eval(response.responseText);
						var cancelled = false;
						if (result[0].errorEncountered != undefined) {
							if(result[0].errorMessage == "This is a cancelled policy.") {
								cancelled = true;
							} else {
								showMessageBox(result[0].errorMessage, imgMessage.ERROR);
								clearInvalidPrem();
								return;
							}
						}
						
						var billNoValidationDtls = result[0].billNoValidationDtls;
						//$("polEndtNo").value 	= billNoValidationDtls.policyNo;
						objAC.currentRecord.policyNo 		= billNoValidationDtls.policyNo;
						objAC.currentRecord.policyId 		= billNoValidationDtls.policyId;
						objAC.currentRecord.lineCd 			= billNoValidationDtls.lineCd;
						objAC.currentRecord.subline_cd 		= billNoValidationDtls.sublineCd;
						objAC.currentRecord.issCd 			= billNoValidationDtls.issCd;
						objAC.currentRecord.issueYear 		= billNoValidationDtls.issueYear;
						objAC.currentRecord.polSeqNo 		= billNoValidationDtls.polSeqNo;
						objAC.currentRecord.endtSeqNo 		= billNoValidationDtls.endSeqNo;
						objAC.currentRecord.endtType 		= billNoValidationDtls.endtType;
						objAC.currentRecord.polFlag 		= billNoValidationDtls.polFlag;
						objAC.currentRecord.assdNo 			= billNoValidationDtls.assdNo;
						objAC.currentRecord.assdName 		= billNoValidationDtls.assdName;
						objAC.currentRecord.currCd 			= billNoValidationDtls.currCd;
						objAC.currentRecord.currRt 			= billNoValidationDtls.currRt;
						objAC.currentRecord.currShortName 	= billNoValidationDtls.currShortName;
						objAC.currentRecord.currDesc 		= billNoValidationDtls.currDesc;
						if 	(billNoValidationDtls != undefined){
							if (billNoValidationDtls.currCd == '1') {
								disableButton("btnForeignCurrency");
							} else {
								enableButton("btnForeignCurrency");
							}
						}
						
						var checkInstNoDtls = result[0].checkInstNoDtls;
						if ("1,4".indexOf($F("tranType"), 1) != -1) {
							//$("premCollectionAmt").value 		= formatCurrency(result[0].collectionAmt);
							objAC.currentRecord.collAmt = formatCurrency(result[0].collectionAmt);
							objAC.currentRecord.origCollAmt = formatCurrency(result[0].collectionAmt);
							objAC.currentRecord.origPremAmt = formatCurrency(result[0].premAmt);
							objAC.currentRecord.origTaxAmt = formatCurrency(result[0].taxAmt);
						} else {
							//$("premCollectionAmt").value 		= formatCurrency(result[0].negCollectionAmt);
							objAC.currentRecord.collAmt = formatCurrency(result[0].negCollectionAmt);
							objAC.currentRecord.origCollAmt = formatCurrency(result[0].negCollectionAmt);
							objAC.currentRecord.origPremAmt = formatCurrency(result[0].negPremAmt);
							objAC.currentRecord.origTaxAmt = formatCurrency(result[0].negTaxAmt);
						}
						
						var checkPremPaytForSpecialDtls = result[0].checkPremPaytForSpecialDtls;
						
						if(paramTranType == 2 || paramTranType == 4) {
							objAC.currentRecord.premVatable = -1*objAC.currentRecord.premVatable;
							objAC.currentRecord.premVatExempt = -1*objAC.currentRecord.premVatExempt;
							objAC.currentRecord.premZeroRated = -1*objAC.currentRecord.premZeroRated;
						} else {
							setPremTaxTranType(paramTranSource, paramBillCmNo, paramTranType, 
									paramInstNo, objAC.currentRecord.origPremAmt, 
									function(res) {
										objAC.currentRecord.premVatable = res.premVatable;
										objAC.currentRecord.premVatExempt = res.premVatExempt;
										objAC.currentRecord.premZeroRated = res.premZeroRated;
										objAC.currentRecord.maxPremVatable = res.maxPremVatable;
										
										$("premVatExempt").value = res.premVatExempt;
										$("premZeroRated").value = res.premZeroRated;
										$("premVatable").value = res.premVatable;
									});
						}
						
						if (objAC.taxAllocationFlag == "Y") {
							withTaxAllocation();
						} else {
							noTaxAllocation();
						}
						billDetailToAdd = result;
						if (checkPremPaytForSpecialDtls.msgAlert == "This is a Special Policy.") {
							showWaitingMessageBox(
									checkPremPaytForSpecialDtls.msgAlert,
									imgMessage.INFO,
									function() {
										if (result[0].hasClaim)
											contValidationCheckForClaim(result);
									});
						} else if(objAC.cancelledOverride != 1 && cancelled) {
							processPaytFromCancelled(result);
						} else {
							contValidationCheckForClaim(result);
						}
					}
				});
	}
	
	function getRecordCount() {
		var recCount = 0;

		for ( var r = 0; r < objAC.jsonDirectPremCollnsDtls.length; r++) {

			if (objAC.jsonDirectPremCollnsDtls[r].recordStatus != -1) {
				recCount += 1;
			}
		}
		return recCount;
	}

	$$(".gdpcRecord").each(function(g) {
		if (g.getAttribute("reqIndex") != null || g.getAttribute("reqIndex") != undefined) {
			var clkIndex = g.getAttribute("reqIndex");

			g.observe("click",function() {
				$$(".gdpcRecord").each(function(h) {
					var itmIndex = h.getAttribute("reqIndex");
						if (itmIndex != null || itmIndex != undefined) {
							if ((h.value == 0 || h.value == null || h.value == "")
									& clkIndex > itmIndex) {
								h.focus();
								throw $break;
							}
						}
					});
			});

			g.observe("blur", function() {
				$$(".gdpcRecord").each(function(h) {
					var itmIndex = h.getAttribute("reqIndex");
					if (itmIndex != null || itmIndex != undefined) {
						if ((h.value == 0 || h.value == null || h.value == "")
								& clkIndex > itmIndex) {
							if (g.id != "premCollectionAmt") {
								g.value = null;
							}
							h.focus();
							throw $break;
						}
					}
				});
			});
		}
	});
	
	
	function deleteBeforeAdd(){
		var indx = 0;
		$$("div[name='rowPremColln']").each(function(row) {
			if (row.hasClassName("selectedRow")) {
				if (getObjectFromArrayOfObjects(objAC.jsonLoadDirectPremCollnsDtls,	"gaccTranId issCd premSeqNo instNo tranType",
											objACGlobal.gaccTranId + row.down("label", 2).innerHTML
																   + row.down("label", 3).innerHTML
																   + row.down("label", 4).innerHTML
																   + row.down("label", 1).innerHTML) == null) {
											objAC.jsonDirectPremCollnsDtls.splice(indx, 1);
				
				} else {
					getObjectFromArrayOfObjects(objAC.jsonDirectPremCollnsDtls,	"issCd premSeqNo instNo tranType",
														row.down("label", 2).innerHTML
												   + row.down("label", 3).innerHTML
												   + row.down("label", 4).innerHTML
												   + row.down("label", 1).innerHTML).recordStatus = -1;

				}
				row.removeClassName("selectedRow");
				Effect.Fade(row, {
					duration : .2,
					afterFinish : function() {
					//added by alfie 11.26.2010
					hideTaxCollections($("taxCollectionTable"),	$("taxCollectionListContainer"));
					removeFromTaxCollectionsTable(objACGlobal.gaccTranId + 
												  row.down("label",	2).innerHTML
												+ row.down("label",	3).innerHTML
												+ row.down("label",	4).innerHTML
												+ row.down("label",	1).innerHTML);
					row.remove();
					checkTableIfEmpty("rowPremColln", "directPremiumCollectionTable");
					checkIfToResizeTable("premiumCollectionList", "rowPremColln");
					//disableButton("btnDelete");
					//$("btnAdd").value = "Add";
					//enableButton("btnAdd");
					//resetFormValues();
					computeTotals();
					//objAC.formChanged = "Y";
					//makeRecordEditable("gdpcRecord");
				}
		});
			}
				indx += 1;
			});
			checkIfToResizeTable2("premiumCollectionList", "rowPremColln");
				changeTag = 1;
	}
	
	function disableButtonOnStatus() {
		$("tranType").disabled = true;
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnDatedCheck");
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
		disableButton("btnSaveDirectPrem");
		$("premCollectionAmt").readOnly = true;
		$("instNo").readOnly = true;
		$("billCmNo").readOnly = true;
		$("directPremAmt").readOnly = true;
		$("taxAmt").readOnly = true;
		$("tranSource").disabled = true;
		$("particulars").readOnly = true;
		$("oscmBillCmNo").hide();
		$("oscmInstNo").hide();
	}

	if(objACGlobal.orTag == "S") {
		disableButtonOnStatus();
	}
	
	$("tranType").observe("change", function() {
		if($F("tranType") == 2 || $F("tranType") == 4) {
			$("premCollectionAmt").readOnly = true;
		} else {
			$("premCollectionAmt").readOnly = false;
		}
	});
	
	$$("input[name='payorType']").each(function(r) {
		$(r.id).observe("click", function() {
			if(r.checked == true) {
				if(r.id == "radioAssd") {
					payorType = "A";	
				} else if(r.id == "radioIntm") {
					payorType = "I";
				}
			}
		});	
	});
	
	$("editParticulars").observe("click", function () {
		// showEditor("particulars", 500); 
		showOverlayEditor("particulars", 500, $("particulars").hasAttribute("readonly")); // andrew - 08.14.2012
	});

	$("particulars").observe("keyup", function () {
		limitText(this, 500);
	});
	
	$("btnAssured").observe("click", function() {
		showMessageBox("Page is not yet available.");
	});
	
	if (objAC.tranFlagState != 'O'){
		disableButtonOnStatus();
	}
	
	if (objAC.enterAdvPayt == "Y") {
		//$("chkIncTag").enable();
	}
	
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS007(){
		try {
			$("tranType").removeClassName("required");
			$("tranSource").removeClassName("required");
			$("tranSource").disable();
			$("billCmNo").readOnly = true;
			$("billCmNo").removeClassName("required");
			$("billCmNoDiv").style.backgroundColor = "";
			disableSearch("oscmBillCmNo");
			$("instNo").readOnly = true;
			$("instNo").removeClassName("required");
			$("instNoDiv").style.backgroundColor = "";
			disableSearch("oscmInstNo");
			$("premCollectionAmt").readOnly = true;
			$("directPremAmt").readOnly = true;
			$("taxAmt").readOnly = true;
			$("premCollectionAmt").removeClassName("required");
			$("directPremAmt").removeClassName("required");
			$("taxAmt").removeClassName("required");
			$("radioAssd").disable();
			$("radioIntm").disable();
			$("particulars").readOnly = true;
			disableButton("btnSaveDirectPrem");
		} catch(e){
			showErrorMessage("disableGIACS007", e);
		}
	}
	
	if (objAC.fromMenu == "cancelOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS007();
	}
	
	objAC.policyInvoices = null;
	objAC.overdueOverride = null;
	objAC.claimsOverride = null;
	objAC.cancelledOverride = null;
	initializeAll();
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveOutFaculPremPayts();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.calledForm2 == 'GIACS016' || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016"|| objACGlobal.calledForm2 == 'GIACS016' || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.calledForm2 == 'GIACS016' || objACGlobal.previousModule == "GIACS016"){
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
			}else{
				editORInformation();	
			}
		}
	});
	
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS007(){
		try {
			$("tranType").removeClassName("required");
			$("tranSource").removeClassName("required");
			$("tranSource").disable();
			$("billCmNo").readOnly = true;
			$("billCmNo").removeClassName("required");
			$("billCmNoDiv").style.backgroundColor = "";
			disableSearch("oscmBillCmNo");
			$("instNo").readOnly = true;
			$("instNo").removeClassName("required");
			$("instNoDiv").style.backgroundColor = "";
			disableSearch("oscmInstNo");
			$("premCollectionAmt").readOnly = true;
			$("directPremAmt").readOnly = true;
			$("taxAmt").readOnly = true;
			$("premCollectionAmt").removeClassName("required");
			$("directPremAmt").removeClassName("required");
			$("taxAmt").removeClassName("required");
			$("radioAssd").disable();
			$("radioIntm").disable();
			$("particulars").readOnly = true;
			disableButton("btnSaveDirectPrem");
		} catch(e){
			showErrorMessage("disableGIACS007", e);
		}
	}
	
	if (objAC.fromMenu == "cancelOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS007();
	}
	
	initializeAll();
</script>