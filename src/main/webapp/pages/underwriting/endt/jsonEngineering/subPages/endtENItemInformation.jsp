<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-Control", "No-Cache");
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
<div class="sectionDiv" id="itemInformationDiv">
	<jsp:include page="/pages/underwriting/par/common/itemInformationListingTable.jsp"></jsp:include>
	<div style="margin: 10px;" id="parItemForm" changeTagAttr="true">
		<input type="hidden" id="pageName"			name="pageName"			value="itemInformation" />
		<input type="hidden" id="userId"			name="userId" 			value="${USER.userId}" />
		<input type="hidden" id="dateFormatted"		name="dateFormatted"	value="N" />
		
		<input type="hidden" 	id="itemGrp"			name="itemGrp"			value="" />
		<input type="hidden" 	id="tsiAmt"				name="tsiAmt"			value="" />
		<input type="hidden" 	id="premAmt"			name="premAmt"			value="" />
		<input type="hidden" 	id="annPremAmt"			name="annPremAmt"		value="" />
		<input type="hidden" 	id="annTsiAmt"			name="annTsiAmt"		value="" />
		<input type="hidden" 	id="recFlag"			name="recFlag"			value="A" />
		<input type="hidden" 	id="packLineCd"			name="packLineCd"		value="" />
		<input type="hidden" 	id="packSublineCd"		name="packSublineCd"	value="" />
		<input type="hidden" 	id="otherInfo"			name="otherInfo"		value="" />
		<input type="hidden" 	id="fromDate"			name="fromDate"			value="" />
		<input type="hidden" 	id="toDate"				name="toDate"			value="" />
		<input type="hidden" 	id="riskNo"				name="riskNo"			value="" />
		<input type="hidden" 	id="riskItemNo"			name="riskItemNo"		value="" />
		<input type="checkbox" 	id="cgCtrlIncludeSw" 	name="cgCtrlIncludeSw" 	value="N" style="display : none;"/>
		<input type="hidden" id="hidDiscountExists" name="hidDiscountExists"/> <!-- added by Kenneth L.03.26.2014  -->
		<input type="checkbox" id="chkDiscountSw" name="chkDiscountSw" disabled="disabled" style="visibility: hidden;"/> <!-- added by Kenneth L.03.26.2014  -->
		
		<div id="hiddenElementsDiv" style="visibility: hidden;">
			<select id="coverage" name="coverage">						
				<option value=""></option>
			</select>
		</div>
		
		<table id="tableItems" width="100%">
			<tr>
				<td style="920px;">
					<table cellspacing="0" border="0" style="margin-bottom: 20px;">
						<tr>
							<td class="rightAligned" style="width: 130px;">Item No. </td>
							<td class="leftAligned" style="width: 200px;"><input type="text" tabindex="1" style="text-align: right; width: 194px; padding: 2px;" id="itemNo" name="itemNo" class="required" maxlength="9"/></td>
							<td class="rightAligned" style="width: 110px;">Item Title </td>
							<td class="leftAligned" style="width: 220px;"><input type="text" tabindex="2" style="width: 194px; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="50"/></td>
							<td rowspan="6" style="width: 20%;">
								<div id="utilityButtonsDiv" changeTagAttr="true">
									<table cellpadding="1" border="0" align="center" style="width: 150px;">
										<tr align="center"><td><input type="button" style="width: 100%;" id="btnNegateRemoveItem" 		name="btnWItem" 			class="disabledButton" 	value="Negate/Remove Item" 		disabled="disabled"/></td></tr>
										<tr align="center"><td><input type="button" style="width: 100%;" id="btnDeleteAddAllItems" 	name="btnDeleteAddAllItems" 					class="button" 			value="Delete/Add All Items" /></td></tr>						
										<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
										<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Info" 				disabled="disabled" /></td></tr>
										<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>									
									</table>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 130px;">Description</td>
							<td class="leftAligned" colspan="4" style="width: 551px;">								
								<div style="width: 547px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 520px; height: 13px; float: left; border: none;" id="itemDesc" name="itemDesc"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 130px;"></td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
								<div style="width: 547px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="4" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 520px; height: 13px; float: left; border: none;" id="itemDesc2" name="itemDesc2"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc2" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 130px;">Currency </td>
							<td class="leftAligned" style="width: 200px;">
								<select tabindex="5" id="currency" name="currency" style="width: 200px;" class="required">
									<option value=""></option>			
									<c:forEach var="currency" items="${currency}">
										<option shortName="${currency.shortName }"	value="${currency.code}">${currency.desc}</option>				
									</c:forEach>	
								</select>
								<select style="display: none;" id="currFloat" name="currFloat">
									<option value=""></option>						
									<c:forEach var="cur" items="${currency}">							
										<option value="${cur.valueFloat}">${cur.valueFloat}</option>
									</c:forEach>
								</select>
							</td>
							<td class="rightAligned" style="width: 110px;">Rate </td>
							<td class="leftAligned" style="width: 220px;">
								<input type="text" tabindex="6" style="width: 194px; padding: 2px;" id="rate" name="rate" class="moneyRate required" maxlength="12" value="<c:if test="${not empty item }">${item[0].currencyRt }</c:if>"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 130px;">Region</td>
							<td class="leftAligned"  style="width: 200px;">
								<select tabindex="9" id="region" name="region" class="required" style="width: 200px;">
									<option value=""></option>
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}">${region.regionDesc}</option>				
									</c:forEach>
								</select>
							</td>
							<td class="rightAligned" style="width: 110px; ">Group </td>
							<td class="leftAligned" style="width: 220px;">
								<select tabindex="8" id="groupCd" name="groupCd" style="width: 200px;">
									<option value=""></option>
									<c:forEach var="group" items="${groups}">
										<option value="${group.groupCd}">${group.groupDesc}</option>				
									</c:forEach>
								</select>
							</td>						
						</tr>						
						<tr>
							<td colspan="4" style="width: 100%;" align="center">
								<table style="margin: auto; width: 100%; border: 0;">
									<tr style="width: 100%;">
										<td>&nbsp;</td>
									</tr>
									<tr style="width: 100%;">
										<td style="rightAligned">
											<div style="text-align: center;">
												<span style="display: none;">
													<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Surcharge &nbsp;</label>
												</span>
												<span style="display: none;">
													<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Discount &nbsp;</label>
												</span>
											</div>
										</td>
									</tr>
								</table>
							</td>							
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var itemNo 			= 0;
	var itemTitle 		= "";
	var itemDesc 		= "";
	var itemDesc2 		= "";
	var currency		= "";
	var currencyText 	= "";
	var rate 			= "";
	var coverage 		= null;
	var coverageText 	= null;
	var region			= "";
	var regionText		= "";
	var lastNumericInput = null;
	$("currency").observe("change", function(){		
		if(!($F("currency").empty())){				
			if(objFormVariables.varOldCurrencyCd != $F("currency")){
				objFormVariables.varGroupSw = "Y";				
			}				
			getRates();
			if ($("currency").value == 1){
				$("rate").setAttribute("readonly", "readonly");
				$("rate").disable();
			}else{
				$("rate").removeAttribute("readonly");
				$("rate").enable();
			}
		}else{
			$("rate").value = "";
		}						
	});	

	function addItem() {
		try{
			itemNo 			= $F("itemNo");
			itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
			itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
			itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
			currency		= $F("currency");
			currencyText 	= $("currency").options[$("currency").selectedIndex].text;
			rate 			= $F("rate");
			region			= $F("region");
			regionText		= $("region").options[$("region").selectedIndex].text;
			if(isParItemInfoValid()) {
				if($F("btnAddItem") == "Add") {
					parItemDeleteDiscount(false);
				}
				
				//objFormMiscVariables.miscNbtInvoiceSw = "Y";
				objFormVariables.varInsertDeleteSw = "Y";
				addParItem();
				
				/*updateObjCopyToInsert(objDeductibles, itemNo);
				updateObjCopyToInsert(objGIPIWItemPeril, itemNo);*/ //belle 03252011
				if(objFormMiscVariables.miscCopy == "Y"){
					updateObjCopyToInsert(objDeductibles, itemNo);	
					updateObjCopyToInsert(objMortgagees, itemNo);
					updateObjCopyToInsert(objGIPIWItemPeril, itemNo);
					objFormMiscVariables.miscCopy = "N";
				}

				/*if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
					objFormMiscVariables.miscDeletePerilDiscById = "Y";
				}*/ //belle 03312011
			} 
		}catch(e){
			showErrorMessage("enItemInformation.jsp - btnAddItem", e);
			//showMessageBox("btnAddItem : " + e.message);
		}
	}

	function deleteItem(itemNo){
		parItemDeleteDiscount(false);
		deleteParItem();

		if(checkDeductibleType(objDeductibles, 1, "T") && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		}
	}

	function delRec(itemNo){
		if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
			showConfirmBox("Discount", "Deleting an item will result to the deletion of all discounts. Do you want to continue ?",
					"Continue", "Cancel", function(){
				objFormMiscVariables.miscDeletePerilDiscById = "Y";
				deleteItem(itemNo);
			}, stopProcess);
		}else{
			deleteItem(itemNo);
		}
	}

	$("btnAddItem").observe("click", function(){
		if("${isPack}" == "Y" && $F("btnAddItem") == "Add"){ // added by andrew - 03.17.2011 - added to validate if package
			showConfirmBox("Confirmation", "You are not allowed to create items here. Create a new item in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;			
		}
		if(objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y" && $F("btnAddItem") == "Add"){
			showMessageBox("You are not allowed to have more than one item for a package plan.", imgMessage.INFO);
			setParItemForm(null);
			($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
			changeTag = 0;
			return false;
		}else{
			if($F("btnAddItem") == "Add" && objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N" && objFormMiscVariables.miscCopy == "N"){
				showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
						"Continue", "Cancel", function(){
					deleteDiscounts();
					addItem();
				}, stopProcess);
				return false;
			}else{
				addItem();
			}
		}
	});

	$("btnDeleteItem").observe("click", function(){
		if("${isPack}" == "Y"){ // added by andrew - 03.24.2011 - added to validate if package
			showConfirmBox("Confirmation", "You are not allowed to delete items here. Delete this item in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;			
		}
		var itemNo = $F("itemNo");

		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");		

		if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			showConfirmBox("Deductibles", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
					"Yes", "No", function(){				
				delRec(itemNo);
			}, stopProcess);
		}else{
			delRec(itemNo);
		}
	});	

	$("itemTitle").observe("keyup", function() {
		$("itemTitle").value = $F("itemTitle").toUpperCase(); 
		limitText(this, 50);
	});

	$("editDesc").observe("click", function () {
		showEditor("itemDesc", 2000);
	});

	$("itemDesc").observe("keyup", function () {
		limitText(this, 2000);
	});

	$("editDesc2").observe("click", function () {
		showEditor("itemDesc2", 2000);
	});

	$("itemDesc2").observe("keyup", function () {
		limitText(this, 2000);
	});

/*	$("btnLocation").observe("click", function() {
		showItemLocations(1, "Locations");				
	});

	$("btnDefaultLoc").observe("click", function() {
		showItemLocations(2, "Default Locations");
	});*/
	
	//$("btnCopyItemInfo").observe("click", confirmCopyItem);
	//$("btnCopyItemPerilInfo").observe("click", confirmCopyItemPeril);
	$("btnNegateRemoveItem").observe("click", confirmNegateItem);
	$("btnDeleteAddAllItems").observe("click", function() {
		if ("${isPack}" == "Y") {  //Deo [03.03.2017]: SR-23874
            showConfirmBox("Confirmation", "You are not allowed to Delete/Add items here. "
            	+ "Delete/Add items in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;
        }
		selectAddDeleteOption("parItemTableContainer", "row", objPolbasics);
	});
	$("btnAssignDeductibles").observe("click", assignDeductibles);
	$("btnAttachMedia").observe("click", function(){
		// openAttachMediaModal("par");
		openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
	});
	$("btnOtherDetails").observe("click", function(){	showOtherInfo("otherInfo", 2000);	});
	
	$("itemNo").observe("change", function(){
		toggleEndtItemDetails($F("itemNo"));
	});	
	$("itemNo").observe("keyup", function(){
		if (isNaN($F("itemNo"))){
			$("itemNo").value = lastNumericInput;
		}else{
			lastNumericInput = $("itemNo").value;
		}
	});
</script>