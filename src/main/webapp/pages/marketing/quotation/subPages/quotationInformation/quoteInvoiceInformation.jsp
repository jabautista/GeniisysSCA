<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="invoiceInformationDiv" name="invoiceInformationDiv" style="">
	<div id="spinLoadingDiv"></div>
	<form id="mainInvoiceForm">
		<span id="noticePopup" name="noticePopup" style="display: none;" class="notice">Saving, please wait...</span>
		<div class="sectionDiv" style="margin-bottom: 2px;">
			<table align="center" style="margin-left: 20%; margin-top: 10px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned">Quote Invoice No.</td>
					<td class="leftAligned">
						<input id="txtQuoteInvNo" name="txtQuoteInvNo" readonly="readonly" />
					</td>
					<td class="rightAligned" style="width: 120px;">Intermediary</td>
					<td class="leftAligned">
						<select style="width: 210px;" id="selIntermediary" name="selIntermediary">
							<option value="1234"></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Premium Amount</td>
					<td class="leftAligned">
						<input id="txtInvoicePremiumAmount" name="txtInvoicePremiumAmount" type="text" class="money" readonly="readonly" style="width:138px" value="0"/>
					</td>
					<td class="rightAligned">Tax Amount</td>
					<td class="leftAligned">
						<input id="txtTotalTaxAmount" name="txtTotalTaxAmount" type="text" class="money" readonly="readonly" style="width:202px;"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Amount Due</td>
					<td class="leftAligned">
						<input id="txtAmountDue" name="txtAmountDue" type="text"	class="money" readonly="readonly" style="width:138px"/>
					</td>
					<td class="rightAligned">Currency</td>
					<td class="leftAligned">
						<input id="txtCurrencyDescription" name="txtCurrencyDescription" type="text" readonly="readonly" style="width:202px;"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="addTaxInvoiceDiv" class="sectionDiv">
			<div style="margin: 10px;">
				<div id="taxListingDiv" name="taxListingDiv" style="width: 100%; display: block;">
					<div align="center" style="width: 100%">
						<div class="tableHeader">
							<label id="lblTaxDescription" 	name="lblTaxDescription"style="width: 40%; margin-left: 10%; text-align: left;">Tax Description</label> 
							<label id="lblTaxAmount" 		name="lblTaxAmount" 	style="width: 30%; text-align: right;">Tax Amount</label>
						</div>
					</div>
					<div class="tableContainer" id="invoiceTaxListingDiv" name="invoiceTaxListingDiv" style="width: 100%;">
						
					</div>
				</div>
				<div style="margin-top: 5px">
					<table align="center">
						<tr>
							<td class="rightAligned">Tax Description</td>
							<td class="leftAligned">
								<select style="width: 213px;" id="selInvoiceTax" name="selInvoiceTax">
								</select>
								<select style="display: none;" id="selTaxId" name="selTaxId">
								</select>
								<select style="display: none;" id="selRateInv" name="selRateInv">
								</select>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Tax Amount</td>
							<td class="leftAligned">
								<input id="txtTaxValue" name="txtTaxValue" type="text" class="money" style="width: 205px;" maxlength="17" value="0.00" />
							</td>
						</tr>
						<tr>
							<td></td>
							<td style="text-align: left; padding-left: 5px;">
								<input id="btnAddInvoice" name="btnAddInvoice" class="button" type="button" value="Add" style="width: 70px;" /> 
								<input id="btnDeleteInvoice" name="btnDeleteInvoice" class="disabledButton" type="button" value="Delete" style="width: 70px;" />
							</td>
						</tr> 
					</table>
				</div>
			</div>
		</div>
	</form>
</div>
<script type="text/javascript">
try{
	if(isMakeQuotationInformationFormsHidden == 1) {
		$("btnAddInvoice").hide();
		$("btnDeleteInvoice").hide();
		$("selIntermediary").disabled = true;
		
		}
	// An Array of invoices containing an array of invTaxes
	objGIPIQuoteInvoiceList	= JSON.parse('${invoiceList}'.replace(/\\/g, '\\\\'));
	
	invoiceTaxLov 	= JSON.parse('${invoiceTaxLov}'.replace(/\\/g, '\\\\'));
	intermediaryLov = JSON.parse('${intermediaryLov}'.replace(/\\/g, '\\\\'));
	invoiceSequence = JSON.parse('${invoiceSequence}'.replace(/\\/g, '\\\\'));
	
	initializeRecordStatus(objGIPIQuoteInvoiceList);
	
	// CHANGE THE LOV's DEPENDING ON THE PERIL LIST
	/* var row = new Element("div");
	
	//loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click",function(){
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")){
			$$("div[name='invoiceTaxRow']").each(function(taxes){
				if(invoiceTaxRow.getAttribute("id") != taxes.getAttribute("id")){
					taxes.removeClassName("selectedRow");
					clearChangeAttribute("invoiceInformationDiv");
				}
			});
		}else{
			clearChangeAttribute("invoiceInformationDiv");
		}
	}); */
		
	
	$("btnAddInvoice").observe("click", function(){
		var newTaxAmt	= $F("txtTaxValue");
		var newTaxId	= $F("selTaxId");	// foreach
		var newRateInv	= $F("selRateInv"); // foreach
		var newTaxCd	= $F("selInvoiceTax");
		var newTaxDesc	= $("selInvoiceTax").options[$("selInvoiceTax").selectedIndex].text;

		//var newInvoiceObj = new Object(); not used
		var newInvTax 	= makeInvoiceTaxObject($("selInvoiceTax").selectedIndex);

		var proceed = true;

		if (newInvTax.taxCd == ""){
			proceed = false;
			showMessageBox("Tax Description is required", imgMessage.ERROR);
		} else if (newInvTax.taxAmt == "0.00"){
			proceed = false;
			showMessageBox("Tax Amount is required", imgMessage.ERROR);
		}
		
		if(proceed){
			var selectedInvoice = pluckInvoiceFromList();
			/*if(selectedInvoice==null){
				selectedInvoice = showDefaultInvoiceValues(); // makes a new peril and adds
			}*/
			
			if($F("btnAddInvoice") == "Add"){
				selectedInvoice.invoiceTaxes.push(newInvTax);
				createInvoiceTaxRow(newInvTax);
				hideSelectedTaxDescriptions();
				clearChangeAttribute("itemInformationDiv");
				clearChangeAttribute("mainInvoiceForm");
				// pluck selected
			}else if($F("btnAddInvoice") == "Update"){
				var itax = pluckTaxFromInvoice();
				itax.taxAmt = newInvTax.taxAmt;
				var taxDescr = "";
				$$("div[name='invoiceTaxRow']").each(function(taxes){
					if(taxes.hasClassName("selectedRow")){
						taxDescr = taxes.down("label",0).innerHTML;
						// pluck invoice, pluck selected invoiceTax, change taxAmount of invoiceTax
						taxes.update('<label style="width: 40%; margin-left: 10%;">' + taxDescr + '</label>'
								   + '<label style="width: 30%; text-align: right;" 	class="money">' + formatCurrency(newInvTax.taxAmt) + '</label>');
						selectedInvoice.taxAmt = newInvTax.taxAmt;
						selectedInvoice.recordStatus = 1;
						clearChangeAttribute("itemInformationDiv");
						clearChangeAttribute("mainInvoiceForm");
					}
				});
			}
			clearInvoiceTaxForm();
			hideSelectedTaxDescriptions();
			updateTaxAmountAndAmountDue();
		}
	});
	
	$("btnDeleteInvoice").observe("click", function(){
		// delete row div & invoiceObj - apply-the-invoice-change
		var taxDescr	= "";
		var taxValue	= 0;
		var taxCd		= 0;
		var selectedTax = pluckTaxFromInvoice();
		$$("div[name='invoiceTaxRow']").each(function(row){
			if(row.hasClassName("selectedRow")){
				taxCd		= row.id.substr(13);
				taxDescr	= row.down("label", 0).innerHTML;
				taxValue	= row.down("label", 1).innerHTML;
				selectedTax.recordStatus = -1;
				row.remove();
				hideSelectedTaxDescriptions();
				clearInvoiceTaxForm();
			}
		});
		updateTaxAmountAndAmountDue();
		clearChangeAttribute("itemInformationDiv");
		clearChangeAttribute("mainInvoiceForm");
	});
	
	$("selIntermediary").observe("change", function(){
		var invoice = pluckInvoiceFromList();
		/*if(invoice==null){
			invoice = showDefaultInvoiceValues();
		}*/
		invoice.intmNo = $F("selIntermediary");
	});
	
	setInvoiceLovOptions();
	initializeAll();
}catch(e){
	//showErrorMessage("invoiceInformation.jsp", e);
	showMessageBox(e.message, imgMessage.ERROR);
}

if($("txtTotalPremiumAmount")!=null){
	$("txtInvoicePremiumAmount").value = $F("txtTotalPremiumAmount"); 
}else{
	$("txtInvoicePremiumAmount").value = $F("txtTotalPremiumAmount");
}

/*
function saveAllQuotationInformation(){ //Patrick - 02.14.2012
	if(checkPendingRecordChanges()){
		var lineCd = getLineCdMarketing();
		// do not include unmodified subpages to parameters when saving to speed up saving
		instantiateNullListings();
	
		var addedItemRows = getAddedJSONObjectList(objGIPIQuoteItemList);
		var modifiedItemRows = getModifiedJSONObjects(objGIPIQuoteItemList);
		var delItemRows = getDeletedJSONObjects(objGIPIQuoteItemList);
		var setItemRows	= addedItemRows.concat(modifiedItemRows);
	
		var addedPerilRows = getAddedJSONObjectList(objGIPIQuoteItemPerilSummaryList);
		var modifiedPerilRows = getModifiedJSONObjects(objGIPIQuoteItemPerilSummaryList);
		var delPerilRows = getDeletedJSONObjects(objGIPIQuoteItemPerilSummaryList);
		var setPerilRows = addedPerilRows.concat(modifiedPerilRows);
	
		// added by: Nica 09.05.2011
		var addedDeductibleRows = getAddedJSONObjectList(objGIPIQuoteDeductiblesSummaryList);
		var modifiedDeductibleRows = getModifiedJSONObjects(objGIPIQuoteDeductiblesSummaryList);
		var delDeductibleRows = getDeletedJSONObjects(objGIPIQuoteDeductiblesSummaryList);
		var setDeductibleRows = addedDeductibleRows.concat(modifiedDeductibleRows);
		
		var addedMortgageeRows = getAddedJSONObjectList(objGIPIQuoteMortgageeList);
		var modifiedMortgageeRows = getModifiedJSONObjects(objGIPIQuoteMortgageeList);
		var delMortgageeRows = getDeletedJSONObjects(objGIPIQuoteMortgageeList);
		var setMortgageeRows = addedMortgageeRows.concat(modifiedMortgageeRows);
	
		var addedInvoiceRows = getAddedJSONObjectList(objGIPIQuoteInvoiceList);
		var modifiedInvoiceRows = getModifiedJSONObjects(objGIPIQuoteInvoiceList);
		var delInvoiceRows = getDeletedJSONObjects(objGIPIQuoteInvoiceList);
		var setInvoiceRows = addedInvoiceRows.concat(modifiedInvoiceRows);
		
		var objParameters = new Object();

		objParameters.setItemRows 		= prepareJsonAsParameter(setItemRows);
		objParameters.delItemRows 		= prepareJsonAsParameter(delItemRows);
		objParameters.setPerilRows		= prepareJsonAsParameter(setPerilRows);
		objParameters.delPerilRows		= prepareJsonAsParameter(delPerilRows);
		objParameters.setDeductibleRows	= prepareJsonAsParameter(setDeductibleRows);
		objParameters.delDeductibleRows	= prepareJsonAsParameter(delDeductibleRows);
		objParameters.setMortgageeRows 	= prepareJsonAsParameter(setMortgageeRows);
		objParameters.delMortgageeRows	= prepareJsonAsParameter(delMortgageeRows);
		objParameters.setInvoiceRows	= prepareJsonAsParameter(setInvoiceRows);
		objParameters.delInvoiceRows	= prepareJsonAsParameter(delInvoiceRows);
		objParameters.gipiQuote			= prepareJsonAsParameter(objGIPIQuote); // added by roy 06/13/2011
		
		new Ajax.Request(contextPath + "/GIPIQuotationInformationController?action=saveQuotationInformationJSON",
		{	method: "POST",
			//postBody: Form.serialize("quotationInformationForm"),
			onCreate: function(){
				disableButton("btnEditQuotation");
				disableButton("btnSaveQuotation");
				disableButton("btnPrintQuotation");
				$("quotationInformationForm").disable();
				showNotice("Saving, please wait...");
			},
			parameters:{
				quoteId: 		objGIPIQuote.quoteId,
				parameters : 	JSON.stringify(objParameters),
				lineCd:			getLineCdMarketing()
			},
			onComplete: function(response){
				$("quotationInformationForm").enable();
				enableButton("btnEditQuotation");
				enableButton("btnSaveQuotation");
				enableButton("btnPrintQuotation");
				if (checkErrorOnResponse(response)){
					hideNotice(response.responseText);
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
						enableButton("btnEditQuotation");
						enableButton("btnSaveQuotation");
						enableButton("btnPrintQuotation");
						quoteInfoSaveIndicator = 1;
						deleteExecutedRecordStats();
						changeTag = 0; // Patrick - 02.14.2012	
						lastAction(); // Patrick - 02.13.2012
						lastAction = "";
					}
				}
				enableQuotationMainButtons();
				showAccordionLabelsOnQuotationMain();
				delRemovedDeductibles();
			}
		});
	}
}
*/
//initializeChangeTagBehavior(); // Patrick - 02.14.2012
//initializeChangeTagBehavior(saveAllQuotationInformation); //Patrick - 02.14.2012
showInvoice2();
initializeChangeAttribute();
</script>