<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div class="sectionDiv" id="invoiceInformationDiv" name="invoiceInformationDiv" style="display: none;">
	<input type="hidden" id="hidQuoteInvNo" name="hidQuoteInvNo" value="">
	<div style="margin-bottom: 2px;">
		<table align="center" style="margin-left: 20%; margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned">Quote Invoice No.</td>
				<td class="leftAligned">
					<input id="txtQuoteInvNo" name="txtQuoteInvNo" readonly="readonly" />
				</td>
				<td class="rightAligned" style="width: 120px;">Intermediary</td>
				<td class="leftAligned">
					<select style="width: 210px;" id="selIntermediary" name="selIntermediary">
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Premium Amount</td>
				<td class="leftAligned">
					<input id="txtInvoicePremiumAmount" name="txtInvoicePremiumAmount" type="text" class="money" readonly="readonly" style="width:138px"/>
				</td>
				<td class="rightAligned">Tax Amount</td>
				<td class="leftAligned">
					<input id="txtTotalTaxAmount" name="txtTotalTaxAmount" type="text" class="money" readonly="readonly" style="width:202px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Amount Due</td>
				<td class="leftAligned">
					<input id="txtAmountDue" name="txtAmountDue" type="text" class="money" readonly="readonly" style="width:138px"/>
				</td>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned">
					<input id="txtCurrencyDescription" name="txtCurrencyDescription" type="text" readonly="readonly" style="width:202px;"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="addTaxInvoiceDiv">
		<div style="margin: 10px;">
			<div id="quoteInvTaxTable" name="quoteInvTaxTable" style="width: 100%; display: block;">
				<div align="center" style="width: 100%">
					<div class="tableHeader">
						<label id="lblTaxDescription" 	name="lblTaxDescription"style="width: 40%; margin-left: 10%; text-align: left;">Tax Description</label> 
						<label id="lblTaxAmount" 		name="lblTaxAmount" 	style="width: 30%; text-align: right;">Tax Amount</label>
					</div>
				</div>
				<div class="tableContainer" id="quoteInvTaxTableContainer" name="quoteInvTaxTableContainer" style="width: 100%;"></div>
			</div>
			<div style="margin-top: 20px">
				<table align="center" style="margin-bottom: 10px;">
					<tr>
						<td class="rightAligned">Tax Description</td>
						<td class="leftAligned">
							<div class="required" style="float: left; border: solid 1px gray; width: 278px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 247px; border: none; background-color: transparent;" name="txtTaxCharges" id="txtTaxCharges" readonly="readonly"/>
								<img id="hrefTaxCharges" alt="goTaxCharges" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Tax Amount</td>
						<td class="leftAligned">
							<input id="txtTaxValue" name="txtTaxValue" type="text" class="required money" style="width: 272px;" maxlength="17" value="0.00" />
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input id="btnAddInvTax" name="btnAddInvTax" class="button" type="button" value="Add" style="width: 80px;" /> 
				<input id="btnDeleteInvTax" name="btnDeleteInvTax" class="disabledButton" type="button" value="Delete" style="width: 80px;" />
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	quotePerilChangeTag = 0;
	objPackQuoteInvoiceList = JSON.parse('${objPackQuoteInvoiceList}'.replace(/\\/g, '\\\\'));
	intermediaryLov = JSON.parse('${intermediaryLov}'.replace(/\\/g, '\\\\'));
	setPackQuoteIntermediaryLov();
	showPackQuoteInvoiceInfo();
	initializeAllMoneyFields();
	initializeChangeTagBehavior(savePackageQuotation);
	
	$("hrefTaxCharges").observe("click", function(){
		var notIn = "";
		var withPrevious = false;

		$$("div#quoteInvTaxTable div[name='invoiceTaxRow']").each(function(row){
			if(withPrevious) notIn += ",";
			notIn += "'"+row.getAttribute("taxCd")+"'";
			withPrevious = true;
		});
		
		notIn = (notIn != "" ? "("+notIn+")" : null);
		
		showQuoteTaxChargesLOV(objCurrPackQuote.lineCd, objCurrPackQuote.issCd, objCurrPackQuote.quoteId, notIn);
	});

	$("btnAddInvTax").observe("click", function(){
		if(validateBeforeAddOrUpdateInvTax()){
			var selectedItemRow = getSelectedRow("row");
			var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow);
			var invoiceTaxes = currQuoteInvoice.invoiceTaxes;
			
			if($("btnAddInvTax").value == "Add"){
				var newInvTax = setQuoteInvTaxObject();
				newInvTax.recordStatus = 0;
				invoiceTaxes.push(newInvTax);
				var newDiv = createQuoteInvTaxRow(newInvTax);
				$("quoteInvTaxTableContainer").insert({bottom : newDiv});
				setQuoteInvTaxRowObserver(newDiv);
				
			}else if($("btnAddInvTax").value == "Update"){
				var updatedInvTax = setQuoteInvTaxObject();
				updatedInvTax.recordStatus = 1;
				var selectedInvTaxRow = getSelectedRow("invoiceTaxRow");
				
				for(var i=0; i<invoiceTaxes.length; i++){
					if(invoiceTaxes[i].taxCd == selectedInvTaxRow.getAttribute("taxCd")){
						invoiceTaxes.splice(i, 1);
						break;
					}
				}

				invoiceTaxes.push(updatedInvTax);
				var updatedRow = prepareQuoteInvTaxTable(updatedInvTax);
				selectedInvTaxRow.update(updatedRow);
				selectedInvTaxRow.removeClassName("selectedRow");
			}

			currQuoteInvoice.recordStatus = 1;
			currQuoteInvoice.taxAmt = computeTotalTaxAmountForPackageQuotation();
			checkIfToResizeTable("quoteInvTaxTableContainer", "invoiceTaxRow");
			checkTableIfEmpty("invoiceTaxRow", "quoteInvTaxTable");
			setQuoteInvoiceInfoForm(currQuoteInvoice);
			setQuoteInvTaxForm(null);
		}
	});

	$("btnDeleteInvTax").observe("click", function(){
		if($("txtTaxCharges").getAttribute("primarySw") == "Y"){
			showMessageBox("You cannot delete this record.", imgMessage.ERROR);
			return false;
		}else{
			var selectedItemRow = getSelectedRow("row");
			var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow);
			var invoiceTaxes = currQuoteInvoice.invoiceTaxes;
			var selectedInvTaxRow = getSelectedRow("invoiceTaxRow");
	
			for(var i=0; i<invoiceTaxes.length; i++){
				if(invoiceTaxes[i].taxCd == selectedInvTaxRow.getAttribute("taxCd")){
					invoiceTaxes[i].recordStatus = -1;
					currQuoteInvoice.recordStatus = 1;
					break;
				}
			}
			selectedInvTaxRow.remove();
			currQuoteInvoice.taxAmt = computeTotalTaxAmountForPackageQuotation();
			checkIfToResizeTable("quoteInvTaxTableContainer", "invoiceTaxRow");
			checkTableIfEmpty("invoiceTaxRow", "quoteInvTaxTable");
			setQuoteInvoiceInfoForm(currQuoteInvoice);
			setQuoteInvTaxForm(null);
		}
	});

	$("selIntermediary").observe("change", function(){
		var selectedItemRow = getSelectedRow("row");
		var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow);
		currQuoteInvoice.intmNo = $F("selIntermediary");
		currQuoteInvoice.recordStatus = 1;
		changeTag = 1;
	});

	function validateBeforeAddOrUpdateInvTax(){
		var taxDesc = $F("txtTaxCharges");
		var taxAmt = unformatCurrencyValue($("txtTaxValue").value);
		var premAmt = unformatCurrencyValue($("txtInvoicePremiumAmount").value);
		   
		if(taxDesc == ""){
			showMessageBox("Tax Description is required.", imgMessage.ERROR);
			return false;
		}else if(taxAmt == "" || parseFloat(taxAmt) == 0){
			showMessageBox("Tax Amount is required.", imgMessage.ERROR);
			return false;
		}else if(parseFloat(taxAmt) > parseFloat(premAmt)){
			showMessageBox("Tax amount must not be greater than the total premium amount.", imgMessage.ERROR);
			return false;
		}else{
			return true;
		}
	}
	
</script>