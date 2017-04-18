<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="mortgageeInformationSectionDiv" name="mortgageeInformationSectionDiv" style="">
	<div id="spinLoadingDiv"></div>
	<div id="contentsDiv" changeTagAttr="true">
		<form id="mortgageeForm" name="mortgageeForm">
			<div class="sectionDiv" id="mortgInfoDiv" changeTagAttr="true">
				<div class="tableContainer" id="mortgageeInformationDiv" name="mortgageeInformationDiv" align="center" style="margin: 10px;">
					<span id="noticePopup" name="noticePopup" style="display: none;" class="notice">Saving, please wait...</span>
					<div class="tableHeader">
						<label style="width: 50%; padding-left: 20px;">Mortgagee Name</label>
						<label style="width: 20%; text-align: right;">Amount</label>
						<label style="width: 20%; text-align: center;">Item No.</label>
					</div>
					<div id="mortgageeListingDiv" name="mortgageeListingDiv" class="tableContainer">
					</div>
				</div>
			
				<table align="center" id="addMortgageeForm" style="margin-top:10px; margin-bottom:10px;" >
					<tr>
						<td class="rightAligned">Mortgagee Name </td>
						<td style="padding-left: 10px;">
							<select id="selMortgagee" name="selMortgagee" style="width: 280px;" class="required">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Amount </td>
						<td style="padding-left: 10px;" align="left">
						<input id="txtMortgageeAmount" name="txtMortgageeAmount" type="text" class="money2" maxlength="17" style="width: 272px;"/></td>
					</tr>
					<tr>
						<td class="rightAligned">Item No. </td>
						<td style="padding-left: 10px;" align="left">
							<input id="txtMortgageeItemNo" name="txtMortgageeItemNo" type="text" readonly="readonly" style="width:272px;"/>						
						</td>
					</tr>
					<tr>
						<td></td>
						<td style="padding-left: 10px; text-align: left;">
							<input id="btnAddMortgagee" name="btnAddMortgagee" class="button" type="button" value="Add" style="width: 70px;" />
							<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" class="disabledButton" type="button" value="Delete" style="width: 70px;" />
						</td>								
					</tr>
				</table>
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
try{
	
	if(isMakeQuotationInformationFormsHidden == 1) {
		$("btnAddMortgagee").hide();
		$("btnDeleteMortgagee").hide();
		$("selMortgagee").disabled = true;
		$("txtMortgageeAmount").readOnly = true;
	}
	
	objMortgageeLov = JSON.parse('${mortgageeLovJSON}'.replace(/\\/g, '\\\\'));
	objGIPIQuoteMortgageeList = JSON.parse('${gipiQuoteMortgageeList}'.replace(/\\/g, '\\\\'));
	
	$("btnAddMortgagee").observe("click", function(){
		var mortgCd = $F("selMortgagee");
		var amount = $F("txtMortgageeAmount").replace(/,/g, "");

		if (mortgCd == ""){
			showMessageBox("Mortgagee Name is required.", imgMessage.ERROR);			
			return false;
		}
		
		/*if(amount == "0.00"  || isNaN(amount) || amount == ""){
			showMessageBox("Invalid Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);			
			return false;
		}*/

		if($F("btnAddMortgagee")=="Add"){
			var newMortgageeObj = makeGIPIQuoteMortgageeObject();
			newMortgageeObj.recordStatus = 0;
			if(objGIPIQuoteMortgageeList==null){
				objGIPIQuoteMortgageeList = new Array();
			}
			clearChangeAttribute("mortgageeInformationSectionDiv");
			objGIPIQuoteMortgageeList.push(newMortgageeObj);
			var newMortgageeRow = makeGIPIQuoteMortgageeRow(newMortgageeObj);
			$("mortgageeListingDiv").insert({bottom: newMortgageeRow});
			resetTableStyle("mortgageeInformationDiv", "mortgageeListingDiv", "mortgageeRow");
			
		}else if($F("btnAddMortgagee")=="Update"){
			var mortgageeObject  = null;
			var mortgageeRow = null;
			for(var i=0; i<objGIPIQuoteMortgageeList.length; i++){
				mortgageeObject = objGIPIQuoteMortgageeList[i];
				mortgageeObject.amount = parseFloat($F("txtMortgageeAmount").replace(/,/g, ""));
				mortgageeObject.recordStatus = 1;
				mortgageeRow = getSelectedRow("mortgageeRow");
				newRow = makeGIPIQuoteMortgageeRow(mortgageeObject);
				mortgageeRow.update(newRow.innerHTML);
				i = objGIPIQuoteMortgageeList.length; // stop loop
			}
			clearChangeAttribute("mortgageeInformationSectionDiv");
		}
		setMortgageeNameLov();
		clearMortgageeForm();
	});
	
	$("btnDeleteMortgagee").observe("click", function(){
		var selectedItemNo = getSelectedRowId("itemRow");
		var mortgageeCd = 0;
		var mortRow = getSelectedRow("mortgageeRow");
		if(mortRow!=null){
			var itemNo = mortRow.getAttribute("itemNo");
			var mortgCd = mortRow.getAttribute("mortgCd");
			var mortgageeToBeDeleted = getMortgageeFromList(itemNo,mortgCd);
			if(mortgageeToBeDeleted != null){
				mortgageeToBeDeleted.recordStatus = -1;
				Effect.Fade(mortRow.id, {
					duration : .001
				});

				mortRow.remove();
				resetTableStyle('mortgageeInformationDiv', 'mortgageeListingDiv', 'mortgageeRow');
				clearMortgageeForm();
				$("selMortgagee").enable();
				setMortgageeNameLov();

			}
		clearChangeAttribute("mortgageeInformationSectionDiv");
		}
	});
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
	}*/

	//initializeChangeTagBehavior(loadMortgageeInformationAccordion); // Patrick - 02.14.2012
	//initializeChangeTagBehavior(saveAllQuotationInformation); //Patrick - 02.14.2012
	$("txtMortgageeItemNo").value = $F("txtItemNo");
	showQuoteItemMortgagees();
	setMortgageeNameLov();
	initializeAllMoneyFields();
	initializeChangeAttribute();
	initializeAll();
	
	
	
}catch(e){
	showErrorMessage("Error caught in Mortgagee Info", e);
}
</script>