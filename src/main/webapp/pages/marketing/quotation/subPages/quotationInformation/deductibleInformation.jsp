<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div class="sectionDiv" id="deductibleInformationSectionDiv" name="deductibleInformationSectionDiv" style="">
	<div id="spinLoadingDiv"></div>
	<div id="deductiblesTable" name="deductiblesTable" class="tableContainer" style="margin: 10px;">
		<div class="tableHeader">
			<label id="deductibleLabel1" name="deductibleLabel1" style="width: 65px; text-align: center;">Item</label>
			<label id="deductibleLabel2" name="deductibleLabel2" style="width: 180px; text-align: left;">Peril Name</label>
			<label id="deductibleLabel3" name="deductibleLabel3" style="width: 180px; text-align: left;">Deductible Title</label> 
			<label id="deductibleLabel6" name="deductibleLabel6" style="width: 150px; text-align: left; padding-left: 20px;">Deductible Text</label>
			<label id="deductibleLabel5" name="deductibleLabel5" style="width: 130px; text-align: right;">Rate</label> 
			<label id="deductibleLabel4" name="deductibleLabel4" style="width: 135px; text-align: right; margin-right: 10px;">Amount</label>
		</div>
		<div class="tableContainer" id="deductibleListing" name="deductibleListing" style="display: block;">
			
		</div>
		<div id="deductibleFooter" name="deductibleFooter">
			<div class="tableHeader">
				<label id="deductibleLabel6" name="deductibleLabel6" style="width: 200px; text-align: left; padding-left: 10px; float:left; ">Total Deductible Amount</label>
				<label id="totalDeductibleAmount" name="totalDeductibleAmount" style="width: 650px; text-align: right; float: left;padding-top 10px;" title="totalDeductibleAmount"></label>
			</div>
		</div>
	</div>
	
	<div id="addDeductibleForm" changeTagAttr="true">
		<input type="hidden" name="quoteId" id="quoteId" value="${gipiQuote.quoteId}"> 
		<input type="hidden" name="sublineCd" id="sublineCd" value="${gipiQuote.sublineCd}">
		<div id="messageError" name="messageError"></div>
		
		<input type="hidden" id="pTsiAmt" name="pTsiAmt" value="" /> 
		<table align="center" border="0" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" style="padding-left: 50px;">Item Title</td>
				<td class="leftAligned">
					<input type="text" id="txtItemDisplay" name="txtItemDisplay" readonly="readonly" value="" class="required" style="width: 200px; display: none;" />
					<select style="width: 208px;" id="selDeductibleQuoteItems" name="selDeductibleQuoteItems" class="required">
						<option value=""></option>
					</select>
				</td>
				<td class="rightAligned">Peril Name</td>
				<td class="leftAligned">
					<input type="text" id="txtPerilDisplay" readonly="readonly" value="" class="required" style="width: 200px; display: none;" />
					<select id="selDeductibleQuotePerils" name="selDeductibleQuotePerils" class="required" style="width: 208px;">
						<option pAmt="test" value=""></option>
					</select> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Deductible Title</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtDedDisplay" readonly="readonly" value="" class="required" style="width: 483px; display: none;" />
					<select style="width: 491px;"id="selDeductibleDesc" name="selDeductibleDesc" class="required" >
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Amount</td>
				<td class="leftAligned">
					<input id="txtDeductibleAmt" name="txtDeductibleAmt" type="text" style="width: 200px;" class="money" maxlength="17" readonly="readonly" />
				</td>
				<td class="rightAligned">Rate</td>
				<td class="leftAligned">
					<input id="txtDeductibleRate" name="txtDeductibleRate" type="text" style="width: 200px;"	class="moneyRate" maxlength="13" readonly="readonly" />
				</td>
			</tr>
			
			<tr>
				<td class="rightAligned">Deductible Text</td>
				<td class="leftAligned" colspan="3">
					<input id="txtDeductibleText" name="txtDeductibleText" type="text" style="width: 483px;" maxlength="2000" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3" style="text-align: left; padding-left: 15%;">
					<input id="btnAddDeductible" class="button" type="button" value="Add" style="width: 70px;" />
					<input id="btnDeleteDeductible" class="button" type="button" value="Delete" style="width: 70px;" />
				</td>
			</tr>
		</table>
	</div>	
</div>
<script type="text/javascript">
objGIPIQuoteDeductiblesSummaryList = JSON.parse('${gipiQuoteDeductiblesList}'.replace(/\\/g, '\\\\'));
objGIISDeductibleDescLov = JSON.parse('${deductibleLov}'.replace(/\\/g, '\\\\'));

if (isMakeQuotationInformationFormsHidden == 1) {
	try{
		$("addDeductibleForm").hide();
	}catch(e){
	}
}

$("selDeductibleDesc").observe("change", function(){
	var deductibleType = nvl($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("deductibleType"),"");
	var deductibleAmount = nvl($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("deductibleAmt"),0);
	var txtDeductibleRate = nvl($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("deductibleRate"),0);
	var txtDeductibleText = nvl($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("deductibleText"),"");
	
	if(deductibleType == 'F'){
		$("txtDeductibleAmt").value = formatCurrency(deductibleAmount==""?"0":deductibleAmount);
		$("txtDeductibleRate").value = "--";
	} 
	if(deductibleType == 'L'){
		$("txtDeductibleAmt").value = "--";
		$("txtDeductibleRate").value = formatToNineDecimal(txtDeductibleRate==""?"0":txtDeductibleRate);
	} 
	if(deductibleType == 'I'){
		$("txtDeductibleAmt").value = "--";
		$("txtDeductibleRate").value = formatToNineDecimal(txtDeductibleRate==""?"0":txtDeductibleRate);
	} 
	if(deductibleType == 'T'){
		computeDeductibleAmountForDedTypeT();
		$("txtDeductibleRate").value = formatToNineDecimal(txtDeductibleRate==""?"0":txtDeductibleRate);
	} 
	$("txtDeductibleText").value = txtDeductibleText;
});

$("selDeductibleQuoteItems").observe("change", function (){
	//removeAllOptions($("selDeductibleQuotePerils"));
	//refreshPerilValuesByItem();
	$("selDeductibleDesc").selectedIndex = 0;
	$("txtDeductibleAmt").value = formatCurrency("0");
	$("txtDeductibleRate").value = formatToNineDecimal("0");
	$("txtDeductibleText").value = "";
});

$("selDeductibleQuotePerils").observe("change",function(){
	if($("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].value != ""){
		filterDeductibleDescLOV();
		$("selDeductibleDesc").enable();
	}
	//showOnlySelectedDeductibles();
	$("selDeductibleDesc").selectedIndex = 0;
	$("txtDeductibleAmt").value = formatCurrency("0");
	$("txtDeductibleRate").value = formatToNineDecimal("0");
	$("txtDeductibleText").value = "";
});
/// ----

	$("txtDeductibleAmt").observe("keyup", function () {
		showMessageBox( "Field is protected against update.", imgMessage.INFO);		
	});

	$("txtDeductibleRate").observe("keyup", function () {
		showMessageBox( "Field is protected against update.", imgMessage.INFO);	
	});

	$("txtDeductibleText").observe("keyup", function(){
		showMessageBox( "Field is protected against update.", imgMessage.INFO);	
	});
	
	function addDeductible(){
		var selectedItem = $F("selDeductibleQuoteItems");
		var selectedPeril = $F("selDeductibleQuotePerils");
		var selectedDeductible = $F("selDeductibleDesc");
		var deductibleTitle = $("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("deductibleTitle");
		var deductibleAmt = "";
		if (selectedItem == "" || selectedPeril == "" || selectedDeductible == "") {
			showMessageBox('Please complete fields.', imgMessage.ERROR);
			exists = true;
			return false;
		}
			
		if (parseFloat($F("txtDeductibleAmt")) == 0 && parseFloat($F("txtDeductibleRate")) == 0) {
			showMessageBox('Please input amount or rate.', imgMessage.ERROR);
			return false;
		} else {
			hideNotice();
		}

		if(checkIfDedExists(selectedItem,selectedPeril,selectedDeductible )){
			showMessageBox("Deductible already exists.", imgMessage.INFO);
		}else{
			var deductibleObj = makeGIPIQuoteDeductibleObject();
			// check if it exists
			{	deductibleObj.recordStatus = 0;
				var deductibleRow = makeGIPIQuoteDeductibleRow(deductibleObj);
				objGIPIQuoteDeductiblesSummaryList.push(deductibleObj);
				$("deductibleListing").insert({ bottom: deductibleRow});
				resetTableStyle("deductiblesTable", "deductibleListing", "deductibleRow");
			}
		}
		clearDeductibleForm();
	}

	function deleteDeductible(){
		var deductibleRow = getSelectedRow("deductibleRow");
		if(deductibleRow != null){
			var perilCd = deductibleRow.getAttribute("perilCd");
			var itemNo = deductibleRow.getAttribute("itemNo");
			var deductibleCd = deductibleRow.getAttribute("deductibleCd");
			var dedObj = pluckQuoteDeductibleFromList(itemNo, perilCd, deductibleCd);
			if(dedObj != null){
				dedObj.recordStatus = -1;
				Effect.Fade(deductibleRow,{
					duration: .3
				});
				function com(){
					deductibleRow.remove();
					clearDeductibleForm();
					enableButton("btnAddDeductible");
					resetTableStyle("deductiblesTable", "deductibleListing", "deductibleRow");
					computeTotalDeductibleAmount();
				}
				setTimeout(com, 150);
			}else{
			}
		}
	}
	
	$("btnDeleteDeductible").observe("click", function ()	{
		deleteDeductible();
		$("selDeductibleDesc").disable(); // nica
		clearChangeAttribute("deductibleInformationSectionDiv");
		clearChangeAttribute("itemInformationDiv");
		//clearChangeAttribute("perilInformationDiv");
		//checkLineCdForAddInfoDiv();
	});
	
	$("btnAddDeductible").observe("click", function ()	{		
		addDeductible();
		$("selDeductibleDesc").disable(); //nica
		computeTotalDeductibleAmount();
		clearChangeAttribute("deductibleInformationSectionDiv");
		clearChangeAttribute("itemInformationDiv");
		//clearChangeAttribute("perilInformationDiv");
		//checkLineCdForAddInfoDiv();
	});
	
	/*	Compute deductible amount based on the rate, TSI amount, minimum amount, 
		maximum amount and range of the deductible.-- nica*/
	/*function computeDeductibleAmountForDedTypeT(){
		var perilName = $("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].text;
		var itemNo = $("selDeductibleQuoteItems").options[$("selDeductibleQuoteItems").selectedIndex].value;
		var pAmt;
		var minAmt = ($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("minimumAmount"));
		var maxAmt = ($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("maximumAmount"));
		var rangeSw = ($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("rangeSw"));

		$$("div[name='perilRow']").each(
			function (row){
				var rPerilName =row.down("input", 8).value;
				var rItemNo = row.down("input", 0).value;
				if(perilName == rPerilName && itemNo == rItemNo){
					pAmt =(row.down("input", 3).value).replace(",", "");
					pAmt = pAmt.replace(",","");
				}
			}
		);
		pAmt = pAmt.replace(",","");
		var percentTSI = (($F("txtDeductibleRate")/100)*pAmt.replace(",", ""));

		if($("txtDeductibleRate").value != "" && $("txtDeductibleRate").value != 0){
			if(minAmt != "" && maxAmt != ""){
				if(rangeSw == "H" || rangeSw == "L"){
					if(percentTSI > minAmt && percentTSI < maxAmt){
						$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
					}else if(percentTSI > minAmt && percentTSI > maxAmt){
						$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
					}else if(percentTSI < minAmt){
						$("txtDeductibleAmt").value =  formatCurrency(minAmt);
					}
				}else{
					$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
				}
			}else if(minAmt != ""){
				if(percentTSI > minAmt){
					$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
				}else{
					$("txtDeductibleAmt").value =  formatCurrency(minAmt);
				}
			}else if(maxAmt != ""){
				if(percentTSI < maxAmt){
					$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
				}else{
					$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
				}
			}else{
				$("txtDeductibleAmt").value =  formatCurrency(percentTSI);
			}
		}else{
			if(minAmt != ""){
				$("txtDeductibleAmt").value =  formatCurrency(minAmt);
			}else if(maxAmt != ""){
				$("txtDeductibleAmt").value =  formatCurrency(maxAmt);
			}	
		}
	}*/ // commented by: nica 05.09.2011

	// added by: nica 05.09.2011
	function checkIfDedExists(itemNo, perilCd, deductibleCd){
		var exist = false;
		$$("div[name= 'deductibleRow']").each(function(row){
			if(row.getAttribute("itemNo") == itemNo && row.getAttribute("perilCd") == perilCd 
				&& row.getAttribute("deductibleCd")==deductibleCd){
				exist = true;
				return exist;
			}
		});
		return exist;
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
			
			objParameters.setItemRows		= prepareJsonAsParameter(setItemRows);
			objParameters.delItemRows		= prepareJsonAsParameter(delItemRows);
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
					quoteId:		objGIPIQuote.quoteId,
					parameters:		JSON.stringify(objParameters),
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
	$("selDeductibleDesc").disable(); //****
	showSelectedItemDeductibleListing();
	//computeTotalDeductibleAmount();
	//resetTableStyle("deductiblesTable", "deductibleListing", "deductibleRow");//ok
	clearDeductibleForm();//ok
	initializeAll();//ok
	initializeAllMoneyFields();//ok
	addStyleToInputs();//ok
	setQuoteDeductibleDescLov();	
	setQuoteDeductibleItemLov();
	setQuoteDeductiblePerilLov();
	initializeChangeAttribute();
	//initializeChangeTagBehavior(loadDeductibleSubpage); // Patrick - 02.14.2012
	//initializeChangeTagBehavior(saveAllQuotationInformation); //Patrick - 02.14.2012
</script>