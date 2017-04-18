<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="parInformationMainDiv" name="parInformationMainDiv" style="margin-top: 1px; display: none;">
	<form id="parInformationForm" name="parInformationForm">
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/subPages/itemInformationListingTable.jsp"></jsp:include>
		<jsp:include page="/pages/underwriting/subPages/parPerilInformation.jsp"></jsp:include>
		<div id="deductibleDiv"></div>
	</form>
	<div class="buttonsDiv">
		<input id="btnCreatePerils" class="disabledButton" type="button" value="Create Perils" name="btnCreatePerils"/>
		<input id="btnDeleteDiscounts" class="disabledButton" type="button" value="Delete Discounts" name="btnDeleteDiscounts"/>
		<input id="btnCopyPeril" class="disabledButton" type="button" value="Copy Peril" name="btnCopyPeril"/>
		<!--<input id="btnDeductibles" class="button" type="button" value="Deductibles" name="btnDeductibles"/>
		-->
		<input id="btnSave" class="button" type="button" value="Save" name="btnSave"/>
	</div>
	<div id="defaultPerilDiv" name="defaultPerilDiv">
	</div>
	<div id="hiddenDiv" name="hiddenDiv">
		<input type="hidden" id="deldiscSw" name="deldiscSw"/>
		<input type="hidden" id="addItemNo" name="addItemNo"/>
		<input type="hidden" id="addPerilCd" name="addPerilCd"/>
		<input type="hidden" id="perilExist2" name="perilExist2"/>
		<input type="hidden" id="discExists" name="discExists" value="${parDetails.discExists}"/>
		<input type="hidden" id="perilItem" name="perilItem"/>
		<input type="hidden" id="issCdRi" name="issCdRi" value="${issCdRi}"/>
	</div>
</div>

<script type="text/javaScript">
	var parId = $F("globalParId");

	hidePerilInfoDiv();
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	checkItemCount();
	loadPerilListingTable();
	$("btnCreatePerils").disable();
	$("btnDeleteDiscounts").disable();
	$("parNo").value = $("globalParNo").value;
	$("assuredName").value = $("globalAssdName").value;
	
	if ($F("discExists") == 'Y') {
		/*$("btnDeleteDiscounts").enable();
		$("btnDeleteDiscounts").removeClassName("disabledButton");
		$("btnDeleteDiscounts").addClassName("button");*/
		enableButton("btnDeleteDiscounts");
	}

	new Ajax.Request(contextPath+"/GIISPerilController?action=checkIfPerilExists&lineCd="+$F("globalLineCd")+"&nbtSublineCd="+$F("nbtSublineCd"), {
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		postBody: Form.serialize("parInformationForm"),
		onComplete: function (response)	{
			if (checkErrorOnResponse(response)) {
				if (response.responseText == 'Y'){
					/*$("btnCreatePerils").removeClassName("disabledButton");
					$("btnCreatePerils").addClassName("button");
					$("btnCreatePerils").enable();*/
					enableButton("btnCreatePerils");
				}
				$("parInformationMainDiv").show();
			}
		}
	});

	$("btnCreatePerils").observe("click", function() {
		if (($F("itemNo")) != ""){
		showConfirmBox("Create Perils", "Existing perils for this policy will be deleted and"+
				" will be replaced by default perils for this policy. "+
				"Do you want to continue?", "Yes", "No", getDefaultPerils,"");
		} else {
			showMessageBox("Please select an item from the list.");
		}
	});

	
	$("btnDeleteDiscounts").observe("click", function() {
		if ($F("itemNo") == "") {
			showMessageBox("Please select an item.", "error");
		} else {
			showConfirmBox("Delete Discounts", "Are you sure you want to delete all discounts for this policy ?",
				 "Yes", "No", deleteDiscounts, "");
		}
	});
	
	$("btnCopyPeril").observe("click", function() {
		if ($F("itemNo") == "") {
			showMessageBox("Please select an item.", "error");
		} else {
			//showMe(contextPath+"/GIPIWItemController?action=showCopyPerilItems&itemNo="+$F("itemNo")+"&"+Form.serialize("parInformationForm"), 280);
			new Ajax.Request(contextPath+"/GIPIWItemPerilController?action=checkItemPerilDeductibles&globalParId="+$F("globalParId"),{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				postBody: Form.serialize("parInformationForm"),
				onCreate: function () {
					showNotice("Validating item...");
				},
				onComplete: function (response)	{
					if (checkErrorOnResponse(response)) {
						if ("Y" == response.responseText){
							hideNotice("");
							showConfirmBox("Copy Peril", "The PAR has an existing policy level deductible based on % of TSI.  Adding a peril will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductibles,"");
						} else {
							checkIfItemHasExistingPeril();
						}
					}
				}
			});
		}
	});
	
/*	$("btnDeductibles").observe("click", function() {
		showDeductibleModal(3);
	});
	*/
	$("btnSave").observe("click", function(){
		saveWItemPerilPageChanges(1);
	});
	
	function checkItemCount(){
		if ($F("globalPackParId") != null ){
			if ($F("wItemParCount") > 1){
				$("btnCopyPeril").removeClassName("disabledButton");
				$("btnCopyPeril").addClassName("button");
				$("btnCopyPeril").enable();
			}
		}
	}
</script>