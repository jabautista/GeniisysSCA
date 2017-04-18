<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
<div id="innerDiv" name="innerDiv"><label>Item Information</label>
<span class="refreshers" style="margin-top: 0;"> <label
	name="gro" style="margin-left: 5px;">Hide</label> </span></div>
</div>
<div class="sectionDiv" id="itemInformationDiv"><jsp:include
	page="/pages/underwriting/par/common/itemInformationListingTable.jsp"></jsp:include>
<div style="margin: 10px;" id="parItemForm"><!-- storage for inserting/updating/deleting items -->
<input type="hidden" id="tempItemNumbers" name="tempItemNumbers" /> <input
	type="hidden" id="deleteItemNumbers" name="deleteItemNumbers" /> <input
	type="hidden" id="tempDeductibleItemNos" name="tempDeductibleItemNos" />
<input type="hidden" id="tempMortgageeItemNos"
	name="tempMortgageeItemNos" /> <input type="hidden"
	id="tempAccessoryItemNos" name="tempAccessoryItemNos" /> <input
	type="hidden" id="tempPerilItemNos" name="tempPerilItemNos" /> <input
	type="hidden" id="tempCarrierItemNos" name="tempCarrierItemNos" /> <input
	type="hidden" id="tempGroupItemsItemNos" name="tempGroupItemsItemNos" />
<input type="hidden" id="tempPersonnelItemNos"
	name="tempPersonnelItemNos" /> <input type="hidden"
	id="tempBeneficiaryItemNos" name="tempBeneficiaryItemNos" /> <input
	type="hidden" id="tempVariable" name="tempVariable" value="0" /> <input
	type="hidden" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" value="" />

<!-- GIPI_WITEM remaining fields --> <input type="hidden" id="itemGrp"
	name="itemGrp" value="" /> <input type="hidden" id="tsiAmt"
	name="tsiAmt" value="" /> <input type="hidden" id="premAmt"
	name="premAmt" value="" /> <input type="hidden" id="annPremAmt"
	name="annPremAmt" value="" /> <input type="hidden" id="annTsiAmt"
	name="annTsiAmt" value="" /> <input type="hidden" id="recFlag"
	name="recFlag" value="A" /> <input type="hidden" id="noOfItemperils" value=""/><!--
		<input type="hidden" id="groupCd"			name="groupCd"			 value="" />
		 --> <input type="hidden" id="fromDate" name="fromDate"
	value="${fromDate}" /> <input type="hidden" id="toDate" name="toDate"
	value="${toDate}" /> <input type="hidden" id="packLineCd"
	name="packLineCd" value="" /> <input type="hidden" id="packSublineCd"
	name="packSublineCd" value="" /> <input type="hidden" id="discountSw"
	name="discountSw" value="" /> <input type="hidden" id="otherInfo"
	name="otherInfo" value="" /> <!-- <input type="hidden" id="surchargeSw"		name="surchargeSw"		 value="" /> -->
<input type="hidden" id="changedTag" name="changedTag" value="" /> <input
	type="hidden" id="prorateFlag" name="prorateFlag" value="" /> <input
	type="hidden" id="compSw" name="compSw" value="" /> <input
	type="hidden" id="shortRtPercent" name="shortRtPercent" value="" /> <input
	type="hidden" id="packBenCd" name="packBenCd" value="" /> <input
	type="hidden" id="paytTerms" name="paytTerms" value="" /> <!-- variables in oracle forms -->
<!-- <input type="hidden" id="varEndtTaxSw"			name="varEndtTaxSw" 		value="" /> -->

<!-- parameters in oracle forms --> <input type="hidden"
	id="parametersOtherSw" name="parametersOtherSw" value="N" /> <input
	type="hidden" id="parametersDDLCommit" name="parametersDDLCommit"
	value="N" /> <input type="hidden" id="varVCopyItem"
	name="varVCopyItem" value="" /> <!-- miscellaneous variables --> <input
	type="hidden" id="currencyListIndex" name="currencyListIndex" value="0" />
<input type="hidden" id="lastRateValue" name="lastRateVal" value="0" />
<input type="hidden" id="lastItemNo" name="lastItemNo"
	value="${lastItemNo}" /> <input type="hidden" id="itemNumbers"
	name="itemNumbers" value="${itemNumbers}" /> <input type="hidden"
	id="perilExists" name="perilExists" value="N" /> <input type="hidden"
	id="addDeletePageLoaded" name="addDeletePageLoaded" value="N" /> <input
	type="hidden" id="addtlInfoValidated" name="addtlInfoValidated"
	value="N" /><input	type="hidden" id="delPolDed" name="delPolDed"
	value="N" /><input type="hidden" id="deleteParDiscounts" name="deleteParDiscounts" value="N"/>
	<input type="hidden" id="itemWODed" name="itemWODed" value=""/>
	<input type="hidden" id="deleteItemNos" name="deleteItemNos" value=""/>
	

<table width="100%" cellspacing="1" border="0">
	<tr>
		<td class="rightAligned" style="width: 20%;">Item No.</td>
		<td class="leftAligned" style="width: 20%;"><input type="text"
			tabindex="1" style="width: 100%; padding: 2px;" id="itemNo"
			name="itemNo"
			class="required positiveIntegerOnlyNoCommaClearIfInvalid"
			errorMsg="Field must be of form 099999999." maxlength="9" /></td>
		<td class="rightAligned" style="width: 10%;">Item Title</td>
		<td class="leftAligned"><input type="text" tabindex="2"
			style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle"
			class="required allCaps" maxlength="250" /></td>
		<td rowspan="7" style="width: 20%;">
		<table cellpadding="1" border="0" align="center">
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnCopyItemInfo" name="btnWItem" class="disabledButton"
					value="Copy Item Info" disabled="disabled" /></td>
			</tr>
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnCopyItemPerilInfo" name="btnWItem" class="disabledButton"
					value="Copy Item/Peril Info" disabled="disabled" /></td>
			</tr>
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnNegateItem" name="btnWItem" class="disabledButton"
					value="Negate/Remove Item" disabled="disabled" /></td>
			</tr>
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnDeleteAddAllItems" name="btnDeleteAddAllItems"
					class="button" value="Delete/Add All Items" /></td>
			</tr>
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnAssignDeductibles" name="btnWItem" class="disabledButton"
					value="Assign Deductibles" disabled="disabled" /></td>
			</tr>
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnOtherDetails" name="btnWItem" class="disabledButton"
					value="Other Details" disabled="disabled" /></td>
			</tr>
			<tr align="center">
				<td><input type="button" style="width: 100%;"
					id="btnAttachMedia" name="btnWItem" class="disabledButton"
					value="Attach Media" disabled="disabled" /></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Description 1</td>
		<td class="leftAligned" colspan="3"><input type="text"
			tabindex="3" style="width: 100%; padding: 2px;" id="itemDesc"
			name="itemDesc" maxlength="2000" /></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Description 2</td>
		<td class="leftAligned" colspan="3"><input type="text"
			tabindex="4" style="width: 100%; padding: 2px;" id="itemDesc2"
			name="itemDesc2" maxlength="2000" /></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Currency</td>
		<td class="leftAligned" style="width: 20%;"><select tabindex="5"
			id="currency" name="currency" style="width: 100%;" class="required">
			<c:forEach var="currency" items="${currency}">
				<option shortName="${currency.shortName }" value="${currency.code}"
					<c:if test="${1 == currency.code}">
								selected="selected"
							</c:if>>${currency.desc}</option>
			</c:forEach>
		</select> <select style="display: none;" id="currFloat" name="currFloat">
			<c:forEach var="cur" items="${currency}">
				<option value="${cur.valueFloat}">${cur.valueFloat}</option>
			</c:forEach>
		</select></td>
		<td class="rightAligned" style="width: 10%;">Rate</td>
		<td class="leftAligned" style="width: 20%;"><input type="text"
			tabindex="6" style="width: 100%; padding: 2px;" id="rate" name="rate"
			class="moneyRate required" maxlength="12"
			value="<c:if test="${not empty item }">${item[0].currencyRt }</c:if>" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 20%;">Coverage <input
			type="hidden" id="hideCoverage" name="hideCoverage" value="" /></td>
		<td class="leftAligned" style="width: 20%;"><select tabindex="7"
			id="coverage" name="coverage" style="width: 100%;" class="">
			<option value=""></option>
			<c:forEach var="coverages" items="${coverages}">
				<option value="${coverages.code}"
					<c:if test="${item.coverageCd == coverages.code}">
								selected="selected"
							</c:if>>${coverages.desc}</option>
			</c:forEach>
		</select></td>
		
		<td class="rightAligned" style="width: 10%;">Region</td>
		<td class="leftAligned" style="width: 20%;"><select tabindex="7"
			id="region" name="region" style="width: 100%;" class="required">
			<option value=""></option>
			<c:forEach var="regions" items="${regions}">
				<option value="${regions.regionCd}"
					<c:if test="${item.regionCd == regions.regionCd}">
						selected="selected"
					</c:if>>${regions.regionDesc}</option>
			</c:forEach>
		</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 10%; ">Group </td>
		<td class="leftAligned" style="width: 20%;">
			<select tabindex="8" id="groupCd" name="groupCd" style="width: 100%;">
				<option value=""></option>
				<c:forEach var="groups" items="${groups}">
					<option value="${groups.groupCd}"
					<c:if test="${item.groupCd == groups.groupCd}">
						selected="selected"
					</c:if>>${groups.groupDesc}</option>
				</c:forEach>				
			</select>
		</td>
		<td></td>
	</tr>
	<tr>
		<td colspan="1"></td>
		<td class="" colspan="3" style="text-align: left; font-size: 11px;">
		<input type="checkbox" id="surchargeSw" name="surchargeSw" value="Y"
			disabled="disabled" />W/ Surcharge &nbsp; &nbsp; &nbsp; <input
			type="checkbox" id="discountSw" name="discountSw" value="Y"
			disabled="disabled" />W/ Discount &nbsp; &nbsp; &nbsp; <input
			type="hidden" id="riskNo" value="" /> <input type="hidden"
			id="riskItemNo" value="" /> <c:if test="${lineCd ne 'AV'}">
			<input type="checkbox" id="chkIncludeSw" name="chkIncludeSw"
				value="N" disabled="disabled"/>Include Additional Info.</c:if> <c:if test="${lineCd eq 'AV'}">
			<input type="hidden" id="chkIncludeSw" name="chkIncludeSw" value="" />
		</c:if></td>
		<!-- tr>
			<td colspan="1"></td>
			<td colspan="3" style="text-align: center;"><input type="button"
				style="width: 100px;" id="btnSaveItem" class="button"
				value="Add" /> <input type="button" style="width: 100px;"
				id="btnDelete" class="disabledButton" value="Delete"
				disabled="disabled" /></td>
		</tr-->
</table>
<table style="margin: auto; width: 55%" border="0">

</table>
</div>
</div>

<script type="text/javascript">
	objEndtMHItems 		= eval('${jsonGIPIWItemVes}');
	objPolbasics 		= eval('${gipiPolbasics}');
	objParPolbas 		= JSON.parse('${gipiWPolbas}');
	objItemNoList 		= eval('[]');	
	objDeductibles 		= new Array();
	objGIPIWItemPeril 		= new Array();
	objPerilWCs 		= new Array();

	showItemList(objEndtMHItems);

	function createItemNoList(){
		for(var index=0, length=objEndtMHItems.length; index < length; index++){
			objItemNoList.push({"itemNo" : objEndtMHItems[index].itemNo});
		}
	}

	createItemNoList();
	moderateVesselOptions();

	$$("div#itemTable div[name='row']").each(
		function(row){
			row.observe("mouseover", function(){
				row.addClassName("lightblue");
			});

			row.observe("mouseout", function(){
				row.removeClassName("lightblue");
			});

			row.observe("click", function(){
				clickRow(row, objEndtMHItems);
			});
		});

	$("btnAttachMedia").observe("click", function(){
		// openAttachMediaModal("par");
		openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
	});

	/*$("currency").observe("change", function(){
		if(!($F("currency").empty())){
			if(objFormVariables.varOldCurrencyCd != $F("currency")){
				objFormVariables[0].varGroupSw = "Y";				
			}
				
			getRates();
			if ($("currency").value == "1"){
				$("rate").disable();
			}else{
				$("rate").enable();
			}
		}else{
			$("rate").value = "";
		}		
	});*/

	$("btnAddItem").observe("click", function(){
		try {
			if(nvl(objFormVariables[0].varDiscExist, "N") == "Y"){
				showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
						"Continue", "Cancel", function(){updateVariableDiscExist(); addItemProcess();}, stopProcess);
			}else if(nvl(objFormParameters[0].parPolFlagSw, "N") != "N"){
				showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
			}else{
				addItemProcess();
			}
		} catch (e) {
			showErrorMessage("endtMarineHullItemInformation.jsp - btnAddItem", e);
			//showMessageBox("btnAddItem : " + e.message);
		}
	});

	function addItemProcess(){
		try {
			var itemNo = $F("itemNo");
			addJSONItem();
			updateObjCopyToInsert(objDeductibles, itemNo);
			moderateVesselOptions();
			$("row"+itemNo).removeClassName("selectedRow");
		} catch (e) {
			showErrorMessage("addItemProcess", e);
			//showMessageBox("addItemProcess : " + e.message);
		}
	}

	$("btnDeleteItem").observe("click", function(){
		try {
			var itemNo = $F("itemNo");
			// load item deductible listing
			if($("deductiblesTable2") == null){
				showDeductibleModal(2);
			}
	
			var policyTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");
	
			//if($$("div#deductiblesTable2 div[name='ded2']").size() > 0){
			if(policyTsiDeductibleExist){
				showConfirmBox("Policy Deductible", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. " +
						"Continue?", "Yes", "No", deletePolicyDeductible, stopProcess);
			}else{
				updateVariableDiscExist();
				deleteItemProcess();
				moderateVesselOptions();
				//deleteChildRecords(itemNo);
			}
		} catch(e){
			showErrorMessage("endtMarineHullItemInformation.jsp - btnDeleteItem", e);
			//showMessageBox("btnDeleteItem : " + e.message);
		}
	});

	function deleteItemProcess(){
		try {
			if(nvl(objFormVariables[0].varDiscExist, "N") == "Y"){
				showConfirmBox("Discount", "Deleting an item will result to the deletion of all discounts.Do you want to continue?",
						"Continue", "Cancel", function(){updateVariableDiscExist(); deleteJSONObject();}, stopProcess);
			} else {
				deleteJSONObject();
			}
		} catch(e){
			showErrorMessage("deleteItemProcess", e);
			//showMessageBox("deleteItemProcess : " + e.message);
		}
	}

	

	function deletePolicyDeductible(){
		objFormMiscVariables[0].miscDeletePolicyDeductibles = "Y";
		objFormMiscVariables[0].miscNbtInvoiceSw = "Y";
		deleteItemProcess();
		//deleteChildRecords(itemNo);
	}
	
	function validateItemNo(){
		var result = true;

		if (isNaN($F("itemNo"))
				|| checkIfDecimal2($F("itemNo"))){
			showWaitingMessageBox("Must be of form 099999999.", imgMessage.ERROR, 
					function(){
				$("itemNo").value = "";
				$("itemNo").focus();
			});
			result = false;
		} else if ( parseInt($F("itemNo")) > 999999999
				|| parseInt($F("itemNo")) <= 0){
			showWaitingMessageBox("Must be in range 000000001 to 999999999.", imgMessage.ERROR, 
					function(){
				$("itemNo").value = "";
				$("itemNo").focus();
			});
		}
		return result;
	}
	//B480.ITEM_NO - when_validate_item
	$("itemNo").observe("change", function() {
		//setCursor("wait");
		var itemNoDeleted = false;
		var itemNoValid = true;

		itemNoValid = validateItemNo();

		if (itemNoValid){
			$("annTsiAmt").value = "";
      		$("annPremAmt").value = "";
      		
			if (objFormVariables[0].varNewSw2 == "N") {
				return false;
			}

			if ($F("itemNo") != ""){
				if ($F("globalBackEndt") == "Y") {
					new Ajax.Request(contextPath + "/GIPIPolbasicController?action=getBackEndtEffectivityDate",{
						method : "GET",
						parameters : {
							itemNo : $F("itemNo"),
							parId : $F("globalParId")
						},					
						asynchronous : false,
						evalScripts : true,
						onCreate: function() {
							//showNotice("Checking if item has already been endorsed. Please wait...");
						},
						onComplete : function(response){
							if (checkErrorOnResponse(response)) {
								
								var msg = response.responseText;
								if (!msg.blank()) {
									var res = msg.split(" ")[0];
									if (res == "SUCCESS") {
										showWaitingMessageBox("This is a backward endorsement, any changes made in this item will affect " +
								                 "all previous endorsement that has an effectivity date later than " + msg.substring(8), imgMessage.INFO, checkIfItemNoIsUnique);
									} else {
										showMessageBox(msg, imgMessage.ERROR);
										//result = false;
									}
								} else {
									checkIfItemNoIsUnique();
									//result = true;
								}
							} else {
								//result = false;
							}
						}
					});
				} else {
					checkIfItemNoIsUnique();
				}
			}
		} 
	});
	// end of item # change.
	
	function checkIfItemNoIsUnique(){ //itemNo ON-CHANGE STEP#2
		try {
			var itemNoExists = false;
			/*$$("div#parItemTableContainer div[name='row']").each(function(i){
				if ($F("itemNo") == i.down("input", 1).value){
					itemNoExists = true;
				}
			});*/
			for (var i=0; i<objEndtMHItems.length; i++){
				if (objEndtMHItems[i].itemNo == $F("itemNo")
						&& (objEndtMHItems[i].recordStatus != -1)){
					itemNoExists = true;
				}
			}
			if (itemNoExists){
				itemNoValid = false;
				$("itemNo").value = "";
				$("itemNo").focus();
				//setCursor("default");
				showWaitingMessageBox("Item must be unique.", imgMessage.ERROR, 
						function(){
					$("itemNo").value = "";
					$("itemNo").focus();
				});
			} else {
				new Ajax.Request(contextPath + "/GIPIWItemVesController?action=getEndtGipiWItemVesDetails",{
					method : "GET",
					parameters : {
						globalParId : $F("globalParId"),
						lineCd 		: $F("globalLineCd"),
						sublineCd 	: $F("globalSublineCd"),
						issCd 		: $F("globalIssCd"),
						issueYy 	: $F("globalIssueYy"),
						polSeqNo 	: $F("globalPolSeqNo"),
						renewNo 	: $F("globalRenewNo"),
						itemNo 		: $F("itemNo"),
						annTsiAmt 	: $F("annTsiAmt"),
						annPremAmt 	: $F("annPremAmt")
					},					
					asynchronous : true,
					evalScripts : true,
					onCreate: function() {
	
					},
					onComplete : function(response){
						var msg = response.responseText;
						//0itemTitle, 1annPremAmt, 2annTsiAmt, 3currencyCd, 4currencyRt, 5fromDate, 6toDate, 
						//7regionCd, 8recFlag, 9restrictedCondition
						var a = msg.split(",");
	
						if ("N" == a[9]){
							$("itemTitle").value =(a[0] == "null"? "": a[0]).toUpperCase();
							$("annPremAmt").value = a[1];
							$("annTsiAmt").value = a[2];
							$("currency").value = a[3] == "null"? 1: a[3];
							//$("currencyRt").value = $("currency").options[$("currency").selectedIndex].getAttribute("currencyRt");
							$("fromDate").value = a[5] == "null"? "": a[5];
							$("toDate").value = a[6] == "null"? "": a[6];
							$("region").value = a[7];
							$("recFlag").value = a[8];
							getRates();
							//setCursor("default");
						} else {
							//setCursor("default");
							showMessageBox("Your endorsement expiry date is equal to or less than your effectivity date. "
									+"Restricted condition.", imgMessage.ERROR);
						}
						setRecFlagDependentFields();
					}
				});
			}
		} catch (e){
			showErrorMessage("checkIfItemNoIsUnique", e);
			//showMessageBox("checkIfItemNoIsUnique : " + e.message);
		}
	}

	function updateVariableDiscExist(){
		objFormVariables[0].varDiscExist = "N";

		if(nvl(objFormParameters[0].parPolFlagSw, "N") != "N"){
			showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
		}
		objFormMiscVariables[0].miscDeletePerilDiscById = "Y";
		objFormMiscVariables[0].miscDeleteItemDiscById = "Y";
		objFormMiscVariables[0].miscDeletePolbasDiscById = "Y";
	}

	$("btnCopyItemInfo").observe("click", confirmCopyItem);
	$("btnCopyItemPerilInfo").observe("click", confirmCopyItemPeril);
	$("btnNegateItem").observe("click", confirmNegateItem);
	$("btnDeleteAddAllItems").observe("click", function() {
		if ("${isPack}" == "Y") {  //Deo [03.03.2017]: SR-23874
            showConfirmBox("Confirmation", "You are not allowed to Delete/Add items here. "
            	+ "Delete/Add items in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;
        }
		selectAddDeleteOption("parItemTableContainer", "row", objPolbasics);
		moderateVesselOptions();
	});
	$("btnAssignDeductibles").observe("click", function() {
		//confirmAssignDeductibles();
		if($("deductiblesTable2") == null){
			showDeductibleModal(2);
			window.setTimeout("assignDeductibles();", 700);
		} else {
			assignDeductibles();
		}
	});
	$("btnOtherDetails").observe("click", function(){
		showOtherInfo("otherInfo", 2000);
	});

	showDeductibleModal(1, "");
</script>