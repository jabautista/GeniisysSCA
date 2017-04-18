<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Item Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="itemAndAdditionalInfoDiv">
	<div class="sectionDiv" id="itemInformationDiv">
		<jsp:include page="/pages/underwriting/endt/marineCargo/subPages/endtMarineCargoItemInformationListingTable.jsp"></jsp:include>
		<div style="margin: 10px;" id="parItemForm" changeTagAttr="true">	
			<!-- storage for inserting/updating/deleting items -->
			<input type="hidden" id="tempItemNumbers"		name="tempItemNumbers" />
			<input type="hidden" id="deleteItemNumbers"		name="deleteItemNumbers" />
			<input type="hidden" id="tempDeductibleItemNos"	name="tempDeductibleItemNos" />
			<input type="hidden" id="tempPerilItemNos"		name="tempPerilItemNos" />
			<input type="hidden" id="tempCarrierItemNos"	name="tempCarrierItemNos" />
			<input type="hidden" id="tempGroupItemsItemNos"	name="tempGroupItemsItemNos" />
			
			<input type="hidden" id="tempVariable"			name="tempVariable"			value="0" />		
			<input type="hidden" id="cgCtrlIncludeSw"		name="cgCtrlIncludeSw"		value="" />
			
			<!-- GIPI_WITEM remaining fields -->
			<input type="hidden" id="itemGrp"			name="itemGrp"			 value="" />
			<input type="hidden" id="tsiAmt"			name="tsiAmt"			 value="" />
			<input type="hidden" id="premAmt"			name="premAmt"			 value="" />
			<input type="hidden" id="annPremAmt"		name="annPremAmt"		 value="" />
			<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		 value="" />
			<input type="hidden" id="recFlag"			name="recFlag"			 value="A" />
	
			<input type="hidden" id="fromDate"			name="fromDate"			 value="${fromDate}" />
			<input type="hidden" id="toDate"			name="toDate"			 value="${toDate}" />
			<input type="hidden" id="packLineCd"		name="packLineCd"		 value="" />
			<input type="hidden" id="packSublineCd"		name="packSublineCd"	 value="" />
			<input type="hidden" id="discountSw"		name="discountSw"		 value="" />		
			<input type="hidden" id="otherInfo"			name="otherInfo"		 value="" />		
			<input type="hidden" id="surchargeSw"		name="surchargeSw"		 value="" />		
			<input type="hidden" id="changedTag"		name="changedTag"		 value="" />
			<input type="hidden" id="prorateFlag"		name="prorateFlag"		 value="" />
			<input type="hidden" id="compSw"			name="compSw"			 value="" />
			<input type="hidden" id="shortRtPercent"	name="shortRtPercent"	 value="" />
			<input type="hidden" id="packBenCd"			name="packBenCd"		 value="" />
			<input type="hidden" id="paytTerms"			name="paytTerms"		 value="" />
	
			<!-- variables in oracle forms -->
			<!-- <input type="hidden" id="varEndtTaxSw"			name="varEndtTaxSw" 		value="" /> --> 
			
			<!-- parameters in oracle forms -->
			<input type="hidden" id="parametersOtherSw"		name="parametersOtherSw"	value="N" />
			<input type="hidden" id="parametersDDLCommit"	name="parametersDDLCommit"	value="N" />
			<input type="hidden" id="varVCopyItem"			name="varVCopyItem"	value="" />
			
			<!-- miscellaneous variables -->
			<input type="hidden" id="currencyListIndex"		name="currencyListIndex"	value="0" />
			<input type="hidden" id="lastRateValue"			name="lastRateVal"	value="0" />
			<input type="hidden" id="lastItemNo" 			name="lastItemNo" 			value="${lastItemNo}" />
			<input type="hidden" id="itemNumbers" 			name="itemNumbers" 			value="${itemNumbers}" />
			<input type="hidden" id="perilExists" 			name="perilExists" 			value="N" />
			<input type="hidden" id="addDeletePageLoaded" 	name="addDeletePageLoaded" 	value="N" />
			<input type="hidden" id="addtlInfoValidated" 	name="addtlInfoValidated" 	value="N" />
			
			<table width="100%">
				<tr>
					<td>
						<table cellspacing="1" border="0" style="margin-bottom: 40px;">					
							<tr>				
								<td class="rightAligned" style="width: 20%;">Item No. </td>
								<td class="leftAligned" style="width: 20%;"><input type="text" tabindex="1" style="width: 100%; padding: 2px;" id="itemNo" name="itemNo" class="required" maxlength="9"/></td>
								<td class="rightAligned" style="width: 10%;">Item Title </td>
								<td class="leftAligned"><input type="text" tabindex="2" style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="250" /></td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 20%;">Description 1</td>
								<td class="leftAligned" colspan="3"><input type="text" tabindex="3" style="width: 100%; padding: 2px;" id="itemDesc" name="itemDesc" maxlength="2000" /></td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 20%;">Description 2</td>
								<td class="leftAligned" colspan="3"><input type="text" tabindex="4" style="width: 100%; padding: 2px;" id="itemDesc2" name="itemDesc2" maxlength="2000" /></td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 20%;">Currency </td>
								<td class="leftAligned" style="width: 20%;">
									<select tabindex="5" id="currency" name="currency" style="width: 103%;" class="required">				
										<c:forEach var="currency" items="${currency}">
											<option shortName="${currency.shortName }"	value="${currency.code}">${currency.desc}</option>				
										</c:forEach>	
									</select>
									<select style="display: none;" id="currFloat" name="currFloat">						
										<c:forEach var="cur" items="${currency}">							
											<option value="${cur.valueFloat}">${cur.valueFloat}</option>
										</c:forEach>
									</select>
								</td>
								<td class="rightAligned" style="width: 10%;">Rate </td>
								<td class="leftAligned" style="width: 20%;">
									<input type="text" tabindex="6" style="width: 100%; padding: 2px;" id="rate" name="rate" class="moneyRate required" maxlength="12" value="<c:if test="${not empty item }">${item[0].currencyRt }</c:if>"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 10%; ">Group </td>
								<td class="leftAligned" style="width: 20%;">
									<select tabindex="8" id="groupCd" name="groupCd" style="width: 103%;">
										<option value=""></option>
										<c:forEach var="group" items="${groups}">
											<option value="${group.groupCd}">${group.groupDesc}</option>				
										</c:forEach>
									</select>
								</td>						
								<td class="rightAligned" style="width: 20%;">Region</td>
								<td class="leftAligned"  style="width: 20%;">
									<select tabindex="7" id="region" name="region" style="width: 103%;">
										<option value=""></option>
										<c:forEach var="region" items="${regions}">
											<option value="${region.regionCd}">${region.regionDesc}</option>				
										</c:forEach>
									</select>
								</td>						
							</tr>
							<tr>
								<td></td>
								<td class="leftAligned" colspan="" style="padding-top: 10px; font-size: 11px;">				
									<input type="checkbox" id="chkIncludeSw" name="chkIncludeSw" value="N"/> Include Additional Info.
								</td>
							</tr>				
						</table>					
					</td>
					<td>
						<table cellpadding="1" border="0" align="center">
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 		class="disabledButton" value="Copy Item Info" disabled="disabled" /></td></tr>
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 		class="disabledButton" value="Copy Item/Peril Info" disabled="disabled" /></td></tr>
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnNegateItem" 		name="btnWItem" 		class="disabledButton" value="Negate/Remove Item" disabled="disabled" /></td></tr>
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnDeleteAddAllItems" 	name="btnDeleteAddAllItems" 				   class="button" value="Delete/Add All Items"/></td></tr>
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 		class="disabledButton" value="Assign Deductibles" disabled="disabled" /></td></tr>						
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 		class="disabledButton" value="Other Details" disabled="disabled" /></td></tr>
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 		class="disabledButton" value="Attach Media" disabled="disabled" /></td></tr><!--
							<tr>
								<td class="rightAligned" colspan="" style="padding-top: 10px;">								
									<input type="checkbox" id="chkIncludeSw" name="chkIncludeSw" value="N" /> Include Additional Info.
								</td>
							</tr>
						--></table>
					</td>
				</tr>
			</table>			
		</div>				
	</div>	
	<jsp:include page="/pages/underwriting/endt/marineCargo/subPages/endtMarineCargoItemInfoAdditional.jsp"></jsp:include>
</div>
<script type="text/javascript" defer="defer">
	objEndtMNItems = JSON.parse('${items2}'.replace(/\\/g, '\\\\'));
	objPolbasics = JSON.parse('${gipiPolbasics2}'.replace(/\\/g, '\\\\'));
	objItemNoList = JSON.parse('[]');
	setDefaultValues();

	$("btnAttachMedia").observe("click", function(){
		// openAttachMediaModal("par");
		openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
	});
	
	$("btnAddItem").observe("click", function() {
		if(nvl(objFormVariables[0].varDiscExist, "N") == "Y"){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
					"Continue", "Cancel", updateVariableDiscExist, stopProcess);
		}else if(nvl(objFormParameters[0].parPolFlagSw, "N") != "N"){
			showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
		}else{
			var itemNo = $F("itemNo");
			
			addJSONItem();
			setDefaultValues();
			updateObjCopyToInsert(objDeductibles, itemNo);
			updateObjCopyToInsert(objCargoCarriers, itemNo);			
		}
	});

	$("btnDeleteItem").observe("click", function(){
		if($("deductiblesTable1") == null){
			showDeductibleModal(1, checkPolTsiDeductible);
		} else {
			checkPolTsiDeductible();
		}
	});
	
	function checkPolTsiDeductible(){
		var polTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");
		
		if (polTsiDeductibleExist) {
			showConfirmBox("Delete item", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
					"Yes", "No",
					function() {
						objFormMiscVariables.miscDeletePolicyDeductibles = "Y"; 
						deleteJSONObject();
					}, "");
		} else {
			deleteJSONObject();
		}	
	}
	
	$("itemNo").observe("change", checkBackEndtOnItemChange);

	$("currency").observe("change", function() {
		if (!$F("itemNo").blank()) {
			if (!validateCurrency()) {
				return false;
			}
		} else {
			showMessageBox("Item number is required before changing the currency.", imgMessage.INFO);
			$("currency").selectedIndex = lastIndex;
			return false;
		}

		$("varGroupSw").value = "Y";
		getRates();
	});

	//B480.CURRENCY_RT - pre_text_item, post_text_item
	$("rate").observe("change", function() {
		lastRate = $F("lastRateValue");
		if ($("currency").options[$("currency").selectedIndex].readAttribute("shortName") == $F("varPhilPeso")) {
			if ($F("vAllowUpdateCurrRate") == "Y") {
				showMessageBox("Currency rate for Philippine peso is not updateable.", imgMessage.INFO);
				$("rate").value = lastRate;
				$("itemNo").focus();
				return false;
			}
		}
		
		if (!$F("annTsiAmt").blank()) {
			if ($F("vAllowUpdateCurrRate") == "Y") {
				showMessageBox("Currency cannot be updated, item is being endorsed.", imgMessage.INFO);
				$("rate").value = lastRate;
				$("itemNo").focus();
				return false;
			}
		}
		$("lastRateValue").value = $F("rate");
	});

	function setOtherInfo(itemNo, otherInfo){
		objCurrEndtItem.otherInfo = otherInfo;
		addModifiedJSONObject(objEndtMNItems, objCurrEndtItem);
	}
/*	
	//other functions
	function removeItemFromList(itemNo) {
		$$("div#itemTable div[name='row']").each(function(row) {
			if (row.down("input", 1).value == itemNo) {
				row.remove();
			}
		});
	}
	
	// key-crerec
	function createRecord() {
		var result = true;

		if ($F("paramPolFlagSw") == "N" && $F("varDiscExist") == "Y") {
				showConfirmBox("Add New Item", "Adding new item will result to the deletion of all discounts. Do you want to continue ?", "Yes", "No",
					 function() {
						$("varDiscExist").value = "N";
						addItem();
					 },
				 "");			
		} else {
			addJSONItem();
		}
		//update later for form status changed
		return result;
	}
*/
	//validations
	function validateCurrency() {
		try {
			var lastIndex = $F("currencyListIndex");
			
			new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=checkIfParItemHasPeril",{
				method : "GET",
				parameters : {
					itemNo : 	  $F("itemNo"),
					globalParId : $F("globalParId")
				},					
				asynchronous : false,
				evalScripts : true,
				onCreate: function() {
					//showNotice("Validating currency. Please wait.");
					setCursor("wait");
				},
				onComplete : function(response){
					setCursor("default");
					
					if (checkErrorOnResponse(response)) {						
						if (response.responseText == "Y") {
							showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
							$("currency").selectedIndex = lastIndex;
							return false;
						} else {
							if (!$F("annTsiAmt").blank() && !$("annTsiAmt") == 0) {
								if ($F("vAllowUpdateCurrRate") == "Y") {
									showMessageBox("Currency cannot be updated, item is being endorsed.", imgMessage.INFO);
									$("currency").selectedIndex = lastIndex;
									return false;
								} else {
									$("currencyListIndex").value = $F("currency").selectedIndex;
								}
							}
						}
					}
				}
			});

			return true;
		} catch (e) {
			showErrorMessage("validateCurrency", e);
			//showMessageBox("validateCurrency : " + e.message);
		}
	}

	showItemList(objEndtMNItems);

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
	});

	$("btnAssignDeductibles").observe("click", function() {
		if($("deductiblesTable2") == null){
			showDeductibleModal(2);
			window.setTimeout("assignDeductibles();", 700);
		} else {
			assignDeductibles();
		}
	});

	$("btnOtherDetails").observe("click", function() {
		if ($F("itemNo").blank()) {
			showMessageBox("Please enter item number first.", imgMessage.ERROR);
			return false;
		} else {
			showTextEditor(objCurrEndtItem.otherInfo, 2000, function() {
				setOtherInfo($F("itemNo"), $F("textarea1"));					
			});			
		}
	});	
	
	$$("div#itemTable div[name='row']").each(function(row){
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});

		row.observe("mouseout",	function(){
				row.removeClassName("lightblue");
		});
						
		row.observe("click", function() {	
			var itemNo = $F("itemNo");
			var vesselCd = $F("vesselCd");
			clickRow(row, objEndtMNItems);
			checkIfMultipleCarrier(itemNo, vesselCd);
		});
	});

	function checkBackEndtOnItemChange(){
		try {
			var itemNoDeleted = false;
			var result;
			
			if (!isNumber("itemNo", "Invalid input. Value should be a number.", "messageBox")) {
				$("itemNo").focus();
			}
			
			// IF :GLOBAL.CG$BACK_ENDT = 'Y' THEN  
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
						showNotice("Checking if item has already been endorsed. Please wait...");
					},
					onComplete : function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice();
							var msg = response.responseText;
							
							if (!msg.blank()) {
								var res = msg.split(" ")[0];
		
								if (res == "SUCCESS") {
									showMessageBox("This is a backward endorsement, any changes made in this item will affect " +
							                 "all previous endorsement that has an effectivity date later than " + msg.substring(8), imgMessage.INFO);									
								} else {
									showMessageBox(msg, imgMessage.ERROR);
								}
							}							
						} 
					}
				});
			}	
		} catch(e){
			showErrorMessage("checkBackEndtOnItemChange", e);
			//showMessageBox("");
		}	
	}
	
	getRates();
</script>