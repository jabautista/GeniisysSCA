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
	<div style="margin: 10px;" id="parItemForm">
		<input type="hidden" id="pageName"			name="pageName"			value="itemInformation" />
		<input type="hidden" id="userId"			name="userId" 			value="${USER.userId}" />
		<input type="hidden" id="dateFormatted"		name="dateFormatted"	value="N" />
		
		<input type="hidden" id="itemGrp"			name="itemGrp"			value="" />
		<input type="hidden" id="tsiAmt"			name="tsiAmt"			value="" />
		<input type="hidden" id="premAmt"			name="premAmt"			value="" />
		<input type="hidden" id="annPremAmt"		name="annPremAmt"		value="" />
		<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		value="" />
		<input type="hidden" id="recFlag"			name="recFlag"			value="A" />
		<input type="hidden" id="packLineCd"		name="packLineCd"		value="" />
		<input type="hidden" id="packSublineCd"		name="packSublineCd"	value="" />
		<input type="hidden" id="otherInfo"			name="otherInfo"		value="" />
		<input type="hidden" id="riskNo"			name="riskNo"			value="" />
		<input type="hidden" id="riskItemNo"		name="riskItemNo"		value="" />
		<input type="hidden" id="itmperlGroupedExists" 	 name="itmperlGroupedExists"   />
		<input type="hidden" id="accidentDeleteBill" name="accidentDeleteBill" value="N" />
		<input type="hidden" id="itemWitmperlExist"  name="itemWitmperlExist"  />
		<input type="hidden" id="itemWgroupedItemsExist" name="itemWgroupedItemsExist" />
		
		<table width="100%">
			<tr>
				<td style="width: 920px;">
					<table cellspacing="0" border="0" style="margin-bottom: 0px; width: 895px;">
						<tr>				
							<td class="rightAligned" style="width: 100px;">Item No. </td>
							<td class="leftAligned" style="width: 200px;"><input type="text" tabindex="1" style="width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999" /></td>
							<td class="rightAligned" style="width: 120px;">Item Title </td>
							<td class="leftAligned"><input type="text" tabindex="2" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" maxlength="50" /></td>
							<td rowspan="6">
								<table cellpadding="1" border="0" align="center" style="width: 150px;">
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnRenumber" 			name="btnWItemRenumber" 	class="button" 			value="Renumber" /></td></tr>						
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Details" 			disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>
									<!--
									<tr>
										<td class="rightAligned" colspan="" style="padding-top: 10px;">
											<input type="checkbox" id="chkIncludeSw" name="chkIncludeSw" value="N" />Include Additional Info.
										</td>
									</tr>
									 -->
								</table>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Description</td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
							<!-- <input type="text" tabindex="3" style="width: 502px; padding: 2px;" id="itemDesc" name="itemDesc" maxlength="2000" /> -->
								<div style="width: 602px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 575px; height: 13px; float: left; border: none;" id="itemDesc" name="itemDesc"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned"></td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
							<!-- <input type="text" tabindex="4" style="width: 502px; padding: 2px;" id="itemDesc2" name="itemDesc2" maxlength="2000" /> -->
								<div style="width: 602px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="4" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 575px; height: 13px; float: left; border: none;" id="itemDesc2" name="itemDesc2"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc2" class="hover" />
								</div>
							</td>
						</tr>						
						<tr>
							<td class="rightAligned">Currency </td>
							<td class="leftAligned">
								<select tabindex="5" id="currency" name="currency" style="width: 230px;" class="required">
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
							<td class="rightAligned">Rate </td>
							<td class="leftAligned">
								<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate required" maxlength="12" value="<c:if test="${not empty item }">${item[0].currencyRt }</c:if>"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Coverage </td>
							<td class="leftAligned">
								<select tabindex="7" id="coverage" name="coverage" style="width: 230px;" class="required">						
									<c:forEach var="coverage" items="${coverages}">
										<option value="${coverage.code}"
										<c:if test="${item.coverageCd == coverage.code}">
											selected="selected"
										</c:if>>${coverage.desc}</option>				
									</c:forEach>
								</select>
							</td>
							<td class="rightAligned">Group </td>
							<td class="leftAligned">
								<select tabindex="8" id="groupCd" name="groupCd" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="group" items="${groups}">
										<option value="${group.groupCd}">${group.groupDesc}</option>				
									</c:forEach>
								</select>
							</td>
						</tr>

						<tr>
							<td class="rightAligned">Effectivity Dates </td>
							<td colspan="4" class="leftAligned">
								<div style="float:left; border: solid 1px gray; width: 150px; height: 21px; margin-right:3px;">
						    		<input style="width: 124px; border: none;" id="fromDate" name="fromDate" type="text" value="" readonly="readonly"/>
						    		<img id="hrefAccidentFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fromDate'),this, null);" alt="From Date" class="hover" />
								</div>
								<div style="float:left; border: solid 1px gray; width: 150px; height: 21px; margin-right:3px;">
						    		<input style="width: 124px; border: none;" id="toDate" name="toDate" type="text" value="" readonly="readonly"/>
						    		<img id="hrefAccidentToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);" alt="To Date" class="hover" />
								</div>
								<div style="float:left; width: 100px; margin: none;">
									<input class="rightAligned" type="text" id="accidentDaysOfTravel" name="accidentDaysOfTravel" value="" style="width: 100px; height: 15px;" readonly="readonly"></div>
								<div style="float:left; margin-left:10px;"><label class="rightAligned" >days</label></div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Plan </td>
							<td class="leftAligned">
								<select tabindex="7" id="accidentPackBenCd" name="accidentPackBenCd" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="plan" items="${plans}">
										<option value="${plan.packBenCd}"
										<c:if test="${item.packBenCd == plan.packBenCd}">
											selected="selected"
										</c:if>>${plan.packageCd}</option>				
									</c:forEach>
								</select>
							</td>
							<td class="rightAligned">Payment Mode </td>
							<td class="leftAligned">
								<select tabindex="8" id="accidentPaytTerms" name="accidentPaytTerms" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="payTerm" items="${payTerms}">
										<option value="${payTerm.paytTerms}"
										<c:if test="${item.paytTerms == payTerm.paytTerms}">
											selected="selected"
										</c:if>>${payTerm.paytTermsDesc}</option>				
									</c:forEach>
								</select>
							</td>
						</tr>

						<tr>
							<td class="rightAligned">Region</td>
							<td class="leftAligned">
								<select tabindex="9" id="region" name="region" class="required" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}">${region.regionDesc}</option>				
									</c:forEach>
								</select>
							</td>							
							<td class="rightAligned">Condition
								<input type="hidden" id="accidentCondition" name="accidentCondition" />
							</td>
							<td class="leftAligned">
								<input type="hidden" id="paramAccidentProrateFlag" name="paramAccidentProrateFlag" value="" />
								<select id="accidentProrateFlag" name="accidentProrateFlag" style="width:230px;" class="required">
										<option value="1">Prorate</option>
										<option value="2">Straight</option>
										<option value="3">Short Rate</option>
								</select>
							</td>
							<td class="leftAligned">	
								<span id="prorateSelectedAccident" name="prorateSelectedAccident" style="display: none; margin-left: 3px;">
									<input type="hidden" style="width: 45px;" id="paramAccidentNoOfDays" name="paramAccidentNoOfDays" value="" />
									<input class="required integerNoNegativeUnformattedNoComma" type="text" style="width: 45px;" id="accidentNoOfDays" name="accidentNoOfDays" value="" maxlength="5" errorMsg="Entered pro-rate number of days is invalid. Valid value is from 0 to 99999." /> 
									<select class="required" id="accidentCompSw" name="accidentCompSw" style="width: 80px;" >
										<option value="Y" >+1 day</option>
										<option value="M" >-1 day</option>
										<option value="N" >Ordinary</option>
									</select>
								</span>
								<span id="shortRateSelectedAccident" name="shortRateSelectedAccident" style="display: none;">
								    <input type="hidden" id="paramAccidentShortRatePercent" name="paramAccidentShortRatePercent" class="moneyRate" style="width: 90px;" maxlength="13" value="" />
									<input type="text" id="accidentShortRatePercent" name="accidentShortRatePercent" class="moneyRate required" style="width: 90px;" maxlength="13" value="" />
								</span>				
							</td>
						</tr>
						<tr>
							<td colspan="4" style="width: 100%;" align="center">
								<table style="margin: auto; width: 100%; border: 0;">
									<tr style="width: 100%;">
										<td>&nbsp;</td>
									</tr>
									<tr style="width: 100%;">
										<td class="rightAligned">
											<div style="text-align : center;">												
												<span style="display: inline-block;">
													<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" tabindex="12" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Surcharge </label>
												</span>
												<span style="display: inline-block; margin-left: 5px;">
													<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" tabindex="13" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Discount </label>
												</span>												
												<span style="display: inline-block; margin-left: 5px;">
													<input type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" tabindex="14" style="float: left;" />
													<label style="margin: auto; margin-left: 2px;" > Include Additional Info.</label>
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
	</div>
</div>

<script type="text/javascript">
	var prorateFlagText = "";

	$("currency").observe("change", function(){		
		if(!($F("currency").empty())){				
			if(objFormVariables.varOldCurrencyCd != $F("currency")){
				objFormVariables.varGroupSw = "Y";				
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
	});

	function addItem(){
		itemNo 			= $F("itemNo");
		itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
		itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
		itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
		currency		= $F("currency");
		currencyText 	= $("currency").options[$("currency").selectedIndex].text;
		rate 			= $F("rate");
		coverage 		= $F("coverage");
		coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
		region			= $F("region");
		regionText		= $("region").options[$("region").selectedIndex].text;		

		if(isParItemInfoValid()){
			if(!(itemTitle.blank()) && $F("noOfPerson").blank()){
				customShowMessageBox("Please complete the additional accident information before proceeding to another item.",
						imgMessage.INFO, "noOfPerson");
				return false;
			}
			
			if($F("btnAddItem") == "Add" && "N" == objFormMiscVariables.miscDeletePerilDiscById) {
				parItemDeleteDiscount(false);
			}

			addParItem();
			objFormMiscVariables.miscNbtInvoiceSw = "Y";

			if(objFormMiscVariables.miscCopy == "Y"){
				updateObjCopyToInsert(objDeductibles, itemNo);
				updateObjCopyToInsert(objGIPIWGroupedItems, itemNo);
				updateObjCopyToInsert(objGIPIWCasualtyPersonnel, itemNo);
				updateObjCopyToInsert(objGIPIWItemPeril, itemNo);		
				objFormMiscVariables.miscCopy = "N";
			}

			/*if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
				objFormMiscVariables.miscDeletePerilDiscById = "Y";
			}*/ //belle 03312011
		}else{			
			return false;
		}
	}

	$("btnAddItem").observe("click", function(){
		if("${isPack}" == "Y" && $F("btnAddItem") == "Add"){ // added by andrew - 03.17.2011 - added to validate if package
			showConfirmBox("Confirmation", "You are not allowed to create items here. Create a new item in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;			
		}
		if(objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y" && $F("btnAddItem") == "Add"){
			showMessageBox("You are not allowed to insert record.", imgMessage.INFO);
			setParItemForm(null);
			($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
			changeTag = 0;
			return false;
		}else{
			if($F("btnAddItem") == "Add" && objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N" && objFormMiscVariables.miscCopy == "N"){
				showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
						"Continue", "Cancel",function(){
					deleteDiscounts();
					addItem();
				}, stopProcess);
				return false;
			}else{
				addItem();
				($$("div#otherInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
			}
		}				
	});
/*	$("btnAddItem").observe("click", function() {
		try {
			if($F("globalParStatus") < 3){
				showMessageBox("You are not granted access to this form. The changes that you have made " +
						"will not be committed to the database.", imgMessage.ERROR);				
				stop = true;
				return false;
			}
			if($F("globalParStatus") < 3){
				showMessageBox("You are not granted access to this form. The changes that you have made " +
						"will not be committed to the database.", imgMessage.ERROR);				
				stop = true;
				return false;
			} else {
				if(isParItemInfoValid()){
					objFormVariables.varInsertDeleteSw = "Y";
					parItemDeleteDiscount();
					objFormMiscVariables.miscNbtInvoiceSw = "Y";
					
					addParItem();

					updateObjCopyToInsert(objDeductibles, itemNo);			
					updateObjCopyToInsert(objGIPIWItemPeril, itemNo);
				} else {
					return false;
				}
			}
		} catch(e) {
			showErrorMessage("accidentItemInfo.jsp - btnAddItem", e);
		}
	});*/

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

	showACProrateSpan();
	
	$("accidentProrateFlag").observe("click", function(){
		prorateFlagText = getListTextValue("accidentProrateFlag");
	});

	$("accidentProrateFlag").observe("change", function(){
		if ($F("itemWitmperlExist") == "Y"){
			if ($F("accidentDeleteBill") != "Y"){
				showConfirmBox("Message", "You have changed your item term from " +prorateFlagText +" to "+ getListTextValue("accidentProrateFlag")+ ". Will now do the necessary changes.",  
						"Yes", "No", onOkFuncDeleteBill, onCancelFuncDeleteBill);
			}
		}
		function onOkFuncDeleteBill(){
			$("accidentDeleteBill").value = "Y";
			showACProrateSpan();
		}
		var itemNum;
/*		var ahInfoObj = objGIPIWItem.gipiWAccidentItem; 
		$$("div#itemTable div[name='row']").each(function(row){
			if (row.hasClassName("selectedRow")){
				itemNum = row.down("label", 0).innerHTML;
				//$("accidentProrateFlag").value = objGIPIWItem.prorateFlag;
				//$("accidentCompSw").value = objGIPIWItem.compSw;
				//$("accidentShortRatePercent").value = objGIPIWItem.shortRtPercent;
				for(var i=0; i<ahInfoObj.length; i++) {
					$("accidentProrateFlag").value = ahInfoObj[i].prorateFlag;
					$("accidentCompSw").value = ahInfoObj[i].compSw;
					$("accidentShortRatePercent").value = ahInfoObj[i].shortRtPercent;	
				}
			}	
		});*/
		
		function onCancelFuncDeleteBill(){
			
			$$("div#itemTable div[name='rowItem']").each(function(row){
				if (row.hasClassName("selectedRow")){
					var itemNum = row.down("label", 0).innerHTML;
					//$("accidentProrateFlag").value = objGIPIWItem.prorateFlag;
					//$("accidentCompSw").value = objGIPIWItem.compSw;
					//$("accidentShortRatePercent").value = objGIPIWItem.shortRtPercent;
				}	
				showACProrateSpan();
			});
		}
		showACProrateSpan();
	});

	$("fromDate").observe("blur", function(){
		//if(makeDate($F("fromDate")) < (Date.parse($F("globalInceptDate")))) {
		if(Date.parse($F("fromDate")) < Date.parse((($F("globalInceptDate")).split(" "))[0])) {
			showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date.", imgMessage.ERROR);	
		} else {
			if(!($F("toDate").empty())) {
				setDaysTravel();
			}
		}
	});

	$("toDate").observe("blur", function(){		
		//if(makeDate($F("toDate")) > Date.parse((($F("globalExpiryDate")).split(" "))[0])) {
		if(Date.parse($F("toDate")) > Date.parse((($F("globalExpiryDate")).split(" "))[0])) {
			showMessageBox("End of Effectivity date should not be later than the Policy Expiry date.", imgMessage.ERROR);
		} else {
			if(!($F("fromDate").empty())) {
				setDaysTravel();
			}
		}
	});

	$("accidentCompSw").observe("change", function() {
		setNoOfDays();
	});

	function setDaysTravel() {
		$("accidentDaysOfTravel").value = computeNoOfDays($F("fromDate"),$F("toDate"));
		$("accidentProrateFlag").enable();
		if($F("accidentProrateFlag") == "1") {
			setNoOfDays();
		}
	}

	function setNoOfDays() {
		if ($F("accidentCompSw") == "Y"){
			$("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) + 1;
		}else if ($F("accidentCompSw") == "M"){
			$("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) - 1;
		}else{
			$("accidentNoOfDays").value  = $F("accidentDaysOfTravel");
		}
	}

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

	$("btnCopyItemInfo").observe("click", confirmParCopyItem);
	$("btnCopyItemPerilInfo").observe("click", confirmParCopyItemPeril);
	$("btnRenumber").observe("click", confirmParRenumber);
	$("btnAssignDeductibles").observe("click", assignDeductibles);
	$("btnAttachMedia").observe("click", function(){
		// openAttachMediaModal("par");
		openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
	});
	
	$("btnOtherDetails").observe("click", function(){	showOtherInfo("otherInfo", 2000);	});		
	
</script>