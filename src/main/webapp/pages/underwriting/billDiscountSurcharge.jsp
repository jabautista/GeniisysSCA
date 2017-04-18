<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" name="hiddenSequence" id="hiddenSequence" value="">
<div id="billDiscountMainDiv" style="margin-top: 1px; display: none;" changeTagAttr="true">
<div id="message" style="display:none;">${message}</div>
	<form id="billDiscountForm" name="billDiscountForm">
		<input type="hidden"   name="parId" 		  id="parId" 	    value="${gipiParList.parId}" />
		<input type="hidden"   name="lineCd" 		  id="lineCd"       value="${gipiParList.lineCd}" />
		<input type="hidden"   name="issCd" 		  id="issCd"        value="${gipiParList.issCd}" />
		<input type="hidden"   name="benefitFlag"     id ="benefitFlag" value="${benefitFlag }" /> 
		<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		<jsp:include page="subPages/billDiscount1.jsp"></jsp:include>
		<jsp:include page="subPages/billDiscount2.jsp"></jsp:include>
		<jsp:include page="subPages/billDiscount3.jsp"></jsp:include>
	</form>
	
	<div class="buttonsDiv" id="discountsButtonDiv">
		<table align="center">
			<tr>
				<td><input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 90px;" /></td>
				<td><input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 90px;" /></td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIPIS143");
	//initializeAccordion(); //Apollo Cruz 09.15.2014
	addStyleToInputs();
	initializeAll();

	function saveBillDiscSurc(){
		new Ajax.Request("GIPIParDiscountController?action=saveBillDiscount", {
			method: "POST",
			postBody: Form.serialize("billDiscountForm"),
			evalScripts: true,
			asynchronous: false,
			onCreate: function() {
				showNotice("Saving information, please wait...");
				$("billDiscountForm").disable();
			},
			onComplete: function (response)	{
				$("billDiscountForm").enable();
				hideNotice(response.responseText);
				if (response.responseText == "SUCCESS") {
					if ($("itemNoPeril").value == 0){
						$("itemPeril").selectedIndex = 0;
						$("itemPeril").disable();
					}
					resetAllForm();
					setParMenusByStatus(5);
					changeTag = 0;
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					showDiscountSurcharge(); //added by steven to reload the page after saving 
					updateParParameters();
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}	
			}
		});
	}	
	
	/*$("reloadForm").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					showDiscountSurcharge, "");
		} else {
			showDiscountSurcharge();
		}
	});
	$("btnCancel").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){saveBillDiscSurc(); if (changeTag == 0){showParListing();}}, showParListing, "");
		} else {
			showParListing();
		}
	});
	$("btnSave").observe("click", function ()	{
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		saveBillDiscSurc();
	});*/
	observeReloadForm("reloadForm", showDiscountSurcharge);
	observeCancelForm("btnCancel", saveBillDiscSurc, showParListing);
	observeSaveForm("btnSave", saveBillDiscSurc);

	function resetAllForm() {
		resetBasicDiscountForm1();
		resetItemDiscountForm();
		resetPerilDiscountForm();
	}	

	if ($("benefitFlag").value == "Y"){
		$("sequenceNoPeril").disable();
		$("grossTagPeril").disable();
		$("discountAmtPeril").disable();
		$("premAmtPeril").disable();
		$("discountRtPeril").disable();
		$("itemNoPeril").disable();
		$("surchargeAmtPeril").disable();
		$("itemPeril").disable();
		$("surchargeRtPeril").disable();
		$("remarkPeril").disable();
		disableButton("btnDelDiscountPeril");
		disableButton("btnAddDiscountPeril");

		$("sequenceNoItem").disable();
		$("grossTagItem").disable();
		$("discountAmtItem").disable();
		$("premAmtItem").disable();
		$("discountRtItem").disable();
		$("itemNo").disable();
		$("surchargeAmtItem").disable();
		$("itemTitle").disable();
		$("surchargeRtItem").disable();
		$("remarkItem").disable();
		disableButton("btnAddDiscountItem");
		disableButton("btnDelDiscountItem");
	}	

	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializePreTextAttribute();
	checkTableIfEmpty("rowBasic", "billPolicyBasicDiscountTable");
	checkIfToResizeTable("billPolicyBasicDiscountTableList", "rowBasic");
	changeTag = 0;
	initializeChangeTagBehavior(saveBillDiscSurc);
	
	/*
	* Apollo Cruz 09.15.2014
	* FGIC-SIT 2342 & 2343 (Temp Solution)
	*/
	$("billPolicyDiscountDiv").hide();
	$("billPolicyDiscountDiv").previous().hide();
	$("billItemDiscountDiv").hide();
	$("billItemDiscountDiv").previous().hide();
</script>
