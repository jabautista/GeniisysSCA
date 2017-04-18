<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="invoiceMainDiv" name="invoiceMainDiv" class="sectionDiv" style="width: 750px; margin-top: 5px; margin-bottom: 2px;">
	<div id="invoiceInfoDiv" name="invoiceInfoDiv" style="margin: 10px 15px 10px 20px;">
		<table>
			<tr>
				<td class="rightAligned" style="margin-right: 0px;">Quote Invoice No.</td>
				<td style="width: 120px;"><input id="invoiceNo" name="invoiceNo" type="text" style="width: 100px; text-align: right; margin-left: 2px;" readonly="readonly"></td>
				<td class="rightAligned" style="width: 65px;">Issue Code</td>
				<td><input id="issCd" name="issCd" type="text" style="width: 40px; margin-right: 25px;" readonly="readonly"></td>
				
				<td class="rightAligned">Intermediary</td>
				<td>
					<span class="lovSpan" style="width: 252px; margin-top: 4px;">
						<input id="intmName" name="intmName" type="text" style="border: none; float: left; width: 217px; height: 13px; margin: 0px;" readonly="readonly">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmName" name="searchIntmName" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Premium Amount</td>
				<td colspan="3"><input id="premAmt" name="premAmt" class="money" type="text" style="width: 227px; margin-left: 2px;" readonly="readonly"></td>
				<td class="rightAligned">Currency</td>
				<td><input id="currency" name="currency" type="text" style="width: 247px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Tax Amount</td>
				<td colspan="3"><input id="taxAmt" name="taxAmt" class="money" type="text" style="width: 227px; margin-left: 2px;" readonly="readonly"></td>
				<td class="rightAligned">Rate</td>
				<td><input id="rate" name="rate" type="text" class="moneyRate" style="width: 247px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Amount Due</td>
				<td colspan="3"><input id="amountDue" name="amountDue" class="money" type="text" style="margin-right: 10px; width: 227px; margin-left: 2px;" readonly="readonly"></td>
			</tr>
		</table>
	</div>
</div>
<div id="invoiceTGMainDiv" name="invoiceTGMainDiv" class="sectionDiv" style="height: 350px; width: 750px; margin-bottom: 5px;">
	<div id="invoiceTGDiv" name="invoiceTGDiv" style="height: 240px; padding-top: 10px; padding-left: 50px;">
		
	</div>
	<div id="invoiceDetailsDiv" name="invoiceDetailsDiv">
		<table align="center">
			<tr>
				<td class="rightAligned">Tax Description </td>
				<td>
					<span class="required lovSpan" style="width: 300px;">
						<input id="txtTaxDesc" name="txtTaxDesc" class="required" type="text" style="border: none; float: left; width: 270px; height: 13px; margin: 0px;" readonly="readonly">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTaxCharges" name="searchTaxCharges" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Tax Amount </td>
				<td><input id="txtTaxAmt" name="txtTaxAmt" class="required money" type="text" style="width: 295px;" maxlength="14" value="0.00"></td>
			</tr>
		</table>
	</div>
	<div id="addDelButtonsDiv" name="addDelButtonsDiv" class="buttonsDiv">
		<input type="button" class="button" id="btnAddInvoice" name="btnAddInvoice" value="Add">
		<input type="button" class="button" id="btnDeleteInvoice" name="btnDeleteInvoice" value="Delete">
	</div>
</div>
<div id="invoiceButtonsDiv" name="invoiceButtonsDiv" class="buttonsDiv" style="margin-top: 5px; margin-bottom: 0px;">
	<input type="button" class="button" id="btnCancelInvoice" name="btnCancelInvoice" value="Cancel">
	<input type="button" class="button" id="btnSaveInvoice" name="btnSaveInvoice" value="Save">
</div>
<div id="invoiceHiddenDiv" name="invoiceHiddenDiv">
	<input id="hidLineCd" name="hidLineCd" type="hidden">
	<input id="hidIssCd" name="hidIssCd" type="hidden">
	<input id="hidQuoteInvNo" name="hidQuoteInvNo" type="hidden">
	<input id="hidTaxCd" name="hidTaxCd" type="hidden">
	<input id="hidTaxId" name="hidTaxId" type="hidden">
	<input id="hidTaxAmt" name="hidTaxAmt" type="hidden">
	<input id="hidRate" name="hidRate" type="hidden">
	<input id="hidFixedTaxAllocation" name="hidFixedTaxAllocation" type="hidden">
	<input id="hidItemGrp" name="hidItemGrp" type="hidden">
	<input id="hidTaxAllocation" name="hidTaxAllocation" type="hidden">
	<input id="hidPrimarySw" name=hidPrimarySw type="hidden">
	<input id="hidPerilSw" name=hidPerilSw type="hidden">
	<input id="hidNoRateTag" name=hidNoRateTag type="hidden">
	<input id="hidIntmNo" name=hidIntmNo type="hidden">
</div>
<script type="text/javascript">
	objQuote.invoiceInfo = JSON.parse('${invoiceInfo}'.replace(/\\/g, '\\\\'));
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	populateInvoiceInfo();

	var objInvoice = [];
	var taxCdList = ""; //","; changed by shan 07.04.2014
	var taxCdLength = 0;
	var objVars = JSON.parse('${variables}'.replace(/\\/g, '\\\\'));
	
	objQuote.objInvTaxDtlsTableGrid = JSON.parse('${invTaxTableGrid}');
	objQuote.objInvTaxDtlsRows = objQuote.objInvTaxDtlsTableGrid.rows || [];
	objQuote.selectedInvoiceIndex = -1;
	objQuote.selectedInvoiceInfoRow = "";
	try{
		var invTaxTableModel = {
			url: contextPath+"/GIPIQuoteInvoiceController?action=showInvoiceOverlay&refresh=1&quoteId="+objQuote.invoiceInfo.quoteId+
					"&currencyCd="+objQuote.invoiceInfo.currencyCd,
			options: {
				title: '',
              	height: '200px',
	          	width: '650px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objQuote.selectedInvoiceIndex = y;
	          		objQuote.selectedInvoiceInfoRow = invTaxTableGrid.geniisysRows[y];
	          		$("txtTaxDesc").value = invTaxTableGrid.geniisysRows[y].taxDesc;
	          		$("txtTaxAmt").value = formatCurrency(invTaxTableGrid.geniisysRows[y].taxAmt);
	          		disableSearch("searchTaxCharges");
	          		populateHiddenFields(1);
	          		toggleInvoiceButtons();
	          		invTaxTableGrid.keys.releaseKeys();
                },
                onRemoveRowFocus: function(){
                	objQuote.selectedInvoiceIndex = -1;
                	$("txtTaxDesc").value = "";
	          		$("txtTaxAmt").value = "0.00";
	          		enableSearch("searchTaxCharges");
	          		populateHiddenFields(0);
                	toggleInvoiceButtons();
                	invTaxTableGrid.keys.releaseKeys();
                	objQuote.selectedInvoiceInfoRow = "";
                },
                beforeSort: function(){
                	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
                },
                onSort: function(){
                	objQuote.selectedInvoiceIndex = -1;
                	$("txtTaxDesc").value = "";
	          		$("txtTaxAmt").value = "0.00";
	          		enableSearch("searchTaxCharges");
	          		populateHiddenFields(0);
                	toggleInvoiceButtons();
                	invTaxTableGrid.keys.releaseKeys();
                	objQuote.selectedInvoiceInfoRow = "";
                },
                toolbar: {
                	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
                	onRefresh: function(){
                		objQuote.selectedInvoiceIndex = -1;
                		$("txtTaxDesc").value = "";
    	          		$("txtTaxAmt").value = "0.00";
    	          		enableSearch("searchTaxCharges");
    	          		populateHiddenFields(0);
                		toggleInvoiceButtons();
                		invTaxTableGrid.keys.releaseKeys();
                		objQuote.selectedInvoiceInfoRow = "";
                	},
                	onFilter: function(){
                		objQuote.selectedInvoiceIndex = -1;
                		$("txtTaxDesc").value = "";
    	          		$("txtTaxAmt").value = "0.00";
    	          		enableSearch("searchTaxCharges");
    	          		populateHiddenFields(0);
                		toggleInvoiceButtons();
                		invTaxTableGrid.keys.releaseKeys();
                		objQuote.selectedInvoiceInfoRow = "";
                		
                	}
                }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'taxDesc',
							title: 'Tax Description',
							width: '370px',
							filterOption: true
						},
						{	id: 'taxAmt',
							title: 'Tax Amount',
							titleAlign: 'right',
							width: '232px',
							geniisysClass: 'money',
							align: 'right',
							filterOption: true,
							filterOptionType: 'number'
						},
						{	id: 'quoteInvNo',
							width: '0px',
							visible: false
						},
						{	id: 'lineCd',
							width: '0px',
							visible: false
						},
						{	id: 'issCd',
							width: '0px',
							visible: false
						},
						{	id: 'taxCd',
							width: '0px',
							visible: false
						},
						{	id: 'taxId',
							width: '0px',
							visible: false
						},
						{	id: 'rate',
							width: '0px',
							visible: false
						},
						{	id: 'itemGrp',
							width: '0px',
							visible: false
						},
						{	id: 'fixedTaxAllocation',
							width: '0px',
							visible: false
						},
						{	id: 'taxAllocation',
							width: '0px',
							visible: false
						},
						{	id: 'primarySw',
							width: '0px',
							visible: false
						},
						{	id: 'perilSw',
							width: '0px',
							visible: false
						},
						{	id: 'noRateTag',
							width: '0px',
							visible: false
						}
  					],  				
  				rows: objQuote.objInvTaxDtlsRows
		};
		invTaxTableGrid = new MyTableGrid(invTaxTableModel);
		invTaxTableGrid.pager = objQuote.objInvTaxDtlsTableGrid;
		invTaxTableGrid.render('invoiceTGDiv');
		invTaxTableGrid.afterRender = function(){
			objInvoice = invTaxTableGrid.geniisysRows;
			populateTaxCdList();
			changeTag = 0;
		};
	}catch(e){
		showMessageBox("Error in Invoice Overlay TableGrid: " + e, imgMessage.ERROR);
	}
	toggleInvoiceButtons();
	
	$("searchIntmName").observe("click", function(){
		getIntmLOV();
	});
	
	$("searchTaxCharges").observe("click", function(){
		getTaxChargesLOV();
	});
	
	$("btnAddInvoice").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("invoiceDetailsDiv")){
			if(parseFloat($F("txtTaxAmt").value) == 0){
				showMessageBox("");
			}else{
				var rowObj = setObjInvoice($("btnAddInvoice").value);
				if($("btnAddInvoice").value == "Add"){
					objInvoice.push(rowObj);
					invTaxTableGrid.addBottomRow(rowObj);
				}else{
					objInvoice.splice(objQuote.selectedInvoiceIndex, 1, rowObj);
					invTaxTableGrid.updateVisibleRowOnly(rowObj, objQuote.selectedInvoiceIndex);
				}
				populateTaxCdList();
				computeAmounts();
				invTaxTableGrid.onRemoveRowFocus();
			}
		}else{
			showMessageBox(objCommonMessage.REQUIRED, "I");
		}
	});
	
	$("btnDeleteInvoice").observe("click", function(){
		checkRequiredTax();
	});
	
	$("txtTaxAmt").observe("blur", function(){
		validateTaxAmt();
	});
	
	function validateTaxAmt(){
		if(isNaN(parseFloat($F("txtTaxAmt").replace(/,/g, "")))){
			//clearFocusElementOnError("txtTaxAmt", "Field must be of form 9,999,999,999.00");
			//$("txtTaxAmt").value = "0.00"; // replaced by: Nica 11.06.2012
			showWaitingMessageBox("Invalid Tax Amount. Valid value should be from 0 to 9,999,999,999.99.", "I", function(){
				$("txtTaxAmt").focus();
				$("txtTaxAmt").value = formatCurrency($("hidTaxAmt").value);	
			});
			
		}else if(parseFloat(unformatCurrencyValue($F("txtTaxAmt"))) > parseFloat(unformatCurrencyValue($F("premAmt")))){
			clearFocusElementOnError("txtTaxAmt", "Tax amount must not be greater than the total premium amount.");
			$("txtTaxAmt").value = "0.00";
		}else if($("hidTaxCd").value == objVars.evat && objVars.vatTag == 2){
			if($F("txtTaxAmt") != 0){
				showMessageBox("This assured is zero VAT rated.", "E");
				$("txtTaxAmt").value = "0.00";
			}
		}else if($("hidPerilSw").value == 'Y'){
			if(parseFloat(nvl($F("txtTaxAmt"), 0)) <= 0 && nvl(objVars.editTag, 'N') == 'N'){
				showMessageBox("Tax Amount must not be less than or equal to zero.", "W");
				$("txtTaxAmt").value = "0.00";
			}
		}else if(parseFloat(nvl($F("txtTaxAmt"), 0)) <= 0 && parseFloat(unformatCurrencyValue($F("premAmt"))) > 0 &&
				nvl(objVars.editTag, 'N') == 'N' && $F("hidPerilSw") == 'N'){
			showMessageBox("Tax Amount must not be less than or equal to zero.", "I");
			$("txtTaxAmt").value = "0.00";
		}else if(unformatCurrencyValue($("hidTaxAmt").value) != unformatCurrencyValue($F("txtTaxAmt")) && nvl($("hidNoRateTag").value, "N") != "Y"){ 
			// added by: Nica 11.06.2012 - to disallow update of amounts if no rate tag is not equal to Y
			var origTaxAmt = formatCurrency(nvl($("hidTaxAmt").value,0)); //added nvl by robert 11.11.2013
			showMessageBox("Tax Amount must be equal to "+origTaxAmt+".", "I");
			$("txtTaxAmt").value = origTaxAmt;
		}else if(parseFloat(unformatCurrencyValue($F("txtTaxAmt"))) < 0){ //marco - 08.31.2012
			//showMessageBox("Tax Amount must not be less than or equal to zero.", "I");
			showMessageBox("Negative value for tax amount is not allowed.", "E");
			$("txtTaxAmt").value = "0.00";
		}
	}
	
	function populateInvoiceInfo(){
		$("invoiceNo").value = objQuote.invoiceInfo.quoteInvNo == null ? "" : objQuote.invoiceInfo.quoteInvNo.toPaddedString(12);
		$("intmName").value = unescapeHTML2(objQuote.invoiceInfo.intmName == null ? "" : objQuote.invoiceInfo.intmName);
		$("premAmt").value = objQuote.invoiceInfo.premAmt == null ? "" : formatCurrency(objQuote.invoiceInfo.premAmt);
		$("taxAmt").value = objQuote.invoiceInfo.taxAmt == null ? "" : formatCurrency(objQuote.invoiceInfo.taxAmt);
		$("amountDue").value = objQuote.invoiceInfo.amountDue == null ? "" : formatCurrency(objQuote.invoiceInfo.amountDue);
		$("currency").value = unescapeHTML2(objQuote.invoiceInfo.currencyDesc == null ? "" : objQuote.invoiceInfo.currencyDesc);
		$("rate").value = objQuote.invoiceInfo.currencyRt == null ? "" : formatToNineDecimal(objQuote.invoiceInfo.currencyRt);
		$("issCd").value = objQuote.invoiceInfo.issCd == null ? "" : unescapeHTML2(objQuote.invoiceInfo.issCd);
		$("hidIntmNo").value = objQuote.invoiceInfo.intmNo == null ? "" : objQuote.invoiceInfo.intmNo;
	}
	
	function populateHiddenFields(func){
		$("hidLineCd").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].lineCd : "";
		$("hidIssCd").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].issCd : "";
		$("hidQuoteInvNo").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].quoteInvNo : "";
		$("hidTaxCd").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxCd : "";
		$("hidTaxId").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxId : "";
		$("hidTaxAmt").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxAmt : "";
		$("hidRate").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].rate : "";
		$("hidFixedTaxAllocation").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].fixedTaxAllocation : "";
		$("hidItemGrp").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].itemGrp : "";
		$("hidTaxAllocation").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].taxAllocation : "";
		$("hidPrimarySw").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].primarySw : "";
		$("hidPerilSw").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].perilSw : "";
		$("hidNoRateTag").value = func == 1 ? invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].noRateTag : "";
	}
	
	function populateHiddenFieldsOnAdd(row){
		$("hidLineCd").value = row.lineCd;
		$("hidIssCd").value = row.issCd;
		$("hidQuoteInvNo").value = objQuote.invoiceInfo.quoteInvNo;
		$("hidTaxCd").value = row.taxCd;
		$("hidTaxId").value = row.taxId;
		$("hidRate").value = row.rate;
		$("hidPerilSw").value = row.perilSw;
		$("hidNoRateTag").value = row.noRateTag;
	}
	
	function populateTaxCdList(){
		taxCdList = ""; //",";	changed by shan 07.04.2014
		taxCdLength = 0;
		for(var i = 0; i < objInvoice.length; i++){
			if(objInvoice[i].recordStatus != -1){
				taxCdList = taxCdList + objInvoice[i].taxCd + ",";
				taxCdLength += 1;
			}
		}
		taxCdList = taxCdList == "" ? "" : "(" + taxCdList.substring(0, taxCdList.length - 1) + ")";	// shan 07.04.2014
	}
	
	function toggleInvoiceButtons(){
		if(objQuote.selectedInvoiceIndex == -1){
			disableButton("btnDeleteInvoice");
			$("btnAddInvoice").value = "Add";
		}else{
			enableButton("btnDeleteInvoice");
			$("btnAddInvoice").value = "Update";
		}
	}
	
	function checkRequiredTax(){
		if(invTaxTableGrid.geniisysRows[objQuote.selectedInvoiceIndex].primarySw == "Y"){
			showMessageBox("You cannot delete this tax. This tax is required for this line.", "I");
		}else{
			deleteInvoice();
		}
	}
	
	function deleteInvoice(){
		var delObj = setObjInvoice("Delete");
		objInvoice.splice(objQuote.selectedInvoiceIndex, 1, delObj);
		invTaxTableGrid.deleteVisibleRowOnly(objQuote.selectedInvoiceIndex);
		populateTaxCdList();
		computeAmounts();
		invTaxTableGrid.onRemoveRowFocus();
	}
		
	function getIntmLOV(){
		try{
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action : "getGIIMM002IntmLOV"},
				title: "Intermediary",
				width: 405,
				height: 386,
				columnModel:[
								{	id : "intmNo",
									title: "Intm No.",
									width: '75px'
								},
				             	{	id : "intmName",
									title: "Intermediary Name",
									width: '205px'
								},
								{	id : "refIntmCd",
									title: "Ref. Intm. Code",
									width: '108px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("hidIntmNo").value = row.intmNo;
						$("intmName").value = unescapeHTML2(row.intmName);
						changeTag = 1;
					}
				}
			});
		}catch(e){
			showErrorMessage("getIntmLOV",e);
		}
	}
	
	function getTaxChargesLOV(){
		try{
			LOV.show({
				controller: "MarketingLOVController",
				urlParameters: {action     : "getTaxChargesLOV",
								page 	   : 1,
								lineCd 	   : objGIPIQuote.lineCd,
								issCd 	   : objQuote.invoiceInfo.issCd,
								quoteId    : objQuote.invoiceInfo.quoteId,
								premAmt	   : unformatCurrencyValue($F("premAmt")),
								rate       : $F("rate"),
								notIn	   : taxCdList // changed by shan 07.04.2014 ; createCompletedNotInParam(invTaxTableGrid,"taxCd") //added by steven 12/06/2012
// 								taxCdList  : taxCdList,
// 								taxCdCount : taxCdLength
							   },
				title: "Tax Charges",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "taxDesc",
									title: "Tax Description",
									width: '292px',
									filterOption: true
								},
								{	id : "rate",
									title: "Rate",
									width: '74px',
									geniisysClass: 'rate'
								},
								{	id : "lineCd",
									width: '0px',
									visible: false
								},
								{	id : "issCd",
									width: '0px',
									visible: false
								},
								{	id : "quoteInvNo",
									width: '0px',
									visible: false
								},
								{	id : "taxCd",
									width: '0px',
									visible: false
								},
								{	id : "taxId",
									width: '0px',
									visible: false
								},
								{	id : "taxAmt",
									width: '0px',
									visible: false
								},
								{	id : "fixedTaxAllocation",
									width: '0px',
									visible: false
								},
								{	id : "itemGrp",
									width: '0px',
									visible: false
								},
								{	id : "taxAllocation",
									width: '0px',
									visible: false
								},
								{	id : "taxAmt",
									width: '0px',
									visible: false
								},
								{	id: 'perilSw',
									width: '0px',
									visible: false
								},
								{	id: 'noRateTag',
									width: '0px',
									visible: false
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("txtTaxDesc").value = unescapeHTML2(row.taxDesc);
						if(row.perilSw == "N"){
							checkTaxType(row.taxCd, row.taxId);
						}else{
							//$("txtTaxAmt").value = formatCurrency(row.taxAmt); -- marco - 09.26.2012 - for zero vat rated assured
							$("txtTaxAmt").value = row.taxCd == objVars.evat && objVars.vatTag == 2 ? "0.00" : formatCurrency(row.taxAmt);
							$("hidTaxAmt").value = $("txtTaxAmt").value; // added by: Nica 11.06.2012
						}
						populateHiddenFieldsOnAdd(row);
					}
				}
			});
		}catch(e){
			showErrorMessage("getTaxChargesLOV",e);
		}
	}
	
	function checkTaxType(taxCd, taxId){
		new Ajax.Request(contextPath + "/GIPIQuoteInvoiceController?action=checkTaxType",{
			method : "GET",
			parameters : {
				taxCd : taxCd,
				taxId : taxId,
				lineCd : objGIPIQuote.lineCd,
				issCd : objQuote.invoiceInfo.issCd,
				premAmt : unformatCurrencyValue($F("premAmt")),
				rate : $F("rate")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					var obj = JSON.parse(response.responseText);
					var taxAmt = obj.taxAmt;
					var msg = obj.message;
					if(msg == "SUCCESS"){
						//$("txtTaxAmt").value = formatCurrency(taxAmt); -- marco - 09.26.2012 - for zero vat rated assured
						$("txtTaxAmt").value = taxCd == objVars.evat && objVars.vatTag == 2 ? "0.00" : formatCurrency(taxAmt);
						$("hidTaxAmt").value = $("txtTaxAmt").value; // added by: Nica 11.06.2012 
					}else{
						showMessageBox(msg, "E");
					}
				}
			}
		});
	}
	
	function setObjInvoice(func){
		var rowObjInvoice = new Object();
		rowObjInvoice.lineCd = $F("hidLineCd");
		rowObjInvoice.issCd = $F("hidIssCd");
		rowObjInvoice.quoteInvNo = $F("hidQuoteInvNo");
		rowObjInvoice.taxCd = $F("hidTaxCd");
		rowObjInvoice.taxAmt = $F("txtTaxAmt");
		rowObjInvoice.taxId = $F("hidTaxId");
		rowObjInvoice.rate = $F("hidRate");
		rowObjInvoice.itemGrp = $F("hidItemGrp");
		rowObjInvoice.fixedTaxAllocation = $F("hidFixedTaxAllocation");
		rowObjInvoice.taxAllocation = $F("hidTaxAllocation");
		rowObjInvoice.taxDesc = $F("txtTaxDesc");
		rowObjInvoice.primarySw = $F("hidPrimarySw");
		rowObjInvoice.perilSw = $F("hidPerilSw");
		rowObjInvoice.noRateTag = $F("hidNoRateTag");
		rowObjInvoice.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		changeTag = 1;
		return rowObjInvoice;
	}
	
	function saveInvoice(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objInvoice);
		objParams.delRows = getDeletedJSONObjects(objInvoice);
		
		new Ajax.Request(contextPath+"/GIPIQuoteInvoiceController?action=saveInvoice",{
			method: "POST",
			parameters:{
				quoteId    : objQuote.invoiceInfo.quoteId,
				quoteInvNo : objQuote.invoiceInfo.quoteInvNo,
				intmNo	   : $F("hidIntmNo"),
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Invoice, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							//updateObjInvoice();
							computeAmounts();
							invTaxTableGrid.refresh();
						});
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function updateObjInvoice(){
		for(var i = 0; i < objInvoice.length; i++){
			if(objInvoice[i].recordStatus == -1){
				//objInvoice[i].recordStatus == null;
				delete objInvoice[i];
			}
			objInvoice[i].recordStatus == null;
		}
	}
	
	function computeAmounts(){
		var taxTotal = 0;
		var dueTotal = 0;
		for(var i = 0; i < objInvoice.length; i++){
			if(objInvoice[i].recordStatus != -1){
				taxTotal = parseFloat(taxTotal) + parseFloat(unformatCurrencyValue(objInvoice[i].taxAmt));
			}
		}
		dueTotal = parseFloat(objQuote.invoiceInfo.premAmt) + parseFloat(taxTotal);
		$("taxAmt").value = formatCurrency(taxTotal);
		$("amountDue").value = formatCurrency(dueTotal);
	}
	
	observeSaveForm("btnSaveInvoice", saveInvoice);
	observeCancelForm("btnCancelInvoice", saveInvoice, function(){
		invTaxTableGrid.keys.releaseKeys();
		invoiceOverlay.close();
		changeTag = 0;
	});

</script>