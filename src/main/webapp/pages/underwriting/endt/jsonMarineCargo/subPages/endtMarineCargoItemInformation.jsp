<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

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
<div id="itemInfoMainDiv">
	<div class="sectionDiv" id="itemInformationDiv">
		<jsp:include page="/pages/underwriting/par/common/itemInformationListingTable.jsp"></jsp:include>
		<div style="margin: 10px;" id="parItemForm">
			<input type="hidden" id="pageName"			name="pageName"			value="itemInformation" />
			<input type="hidden" id="userId"			name="userId" 			value="${USER.userId}" />
			<input type="hidden" id="dateFormatted"		name="dateFormatted"	value="N" />
			
			<!-- GIPI_WITEM remaining fields -->
			<input type="hidden" id="itemGrp"			name="itemGrp"			value="" />
			<input type="hidden" id="tsiAmt"			name="tsiAmt"			value="" />
			<input type="hidden" id="premAmt"			name="premAmt"			value="" />
			<input type="hidden" id="annPremAmt"		name="annPremAmt"		value="" />
			<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		value="" />
			<input type="hidden" id="recFlag"			name="recFlag"			value="A" />
			<input type="hidden" id="packLineCd"		name="packLineCd"		value="" />
			<input type="hidden" id="packSublineCd"		name="packSublineCd"	value="" />
			<input type="hidden" id="otherInfo"			name="otherInfo"		value="" />
			<input type="hidden" id="coverage"			name="coverage"			value="" />
			<input type="hidden" id="fromDate"			name="fromDate"			value="" />
			<input type="hidden" id="toDate"			name="toDate"			value="" />
			<input type="hidden" id="riskNo"			name="riskNo"			value="" />
			<input type="hidden" id="riskItemNo"		name="riskItemNo"		value="" />
			
			<input id="recFlagWCargo" 		name="recFlagWCargo" 		type="hidden" value="" maxlength="1"/>
			<input id="cpiRecNo" 			name="cpiRecNo" 	 		type="hidden" value="" maxlength="12"/>
			<input id="cpiBranchCd" 		name="cpiBranchCd" 	 		type="hidden" value="" maxlength="2"/>
			<input id="deductText" 			name="deductText"    		type="hidden" value="" maxlength="200"/>
			<input id="perilExist" 			name="perilExist" 	 		type="hidden" value="" maxlength="1"/>
			<input id="deleteWVes" 			name="deleteWVes" 	 		type="hidden" value="" maxlength="1"/>
			<input id="origGeogDesc" 		name="origGeogDesc"  		type="hidden" value="" />
			<input id="origGeogCd" 			name="origGeogCd" 	 		type="hidden" value="" />
			<input id="origGeogType" 		name="origGeogType"  		type="hidden" value="" />
			<input id="origGeogClassType" 	name="origGeogClassType"  	type="hidden" value="" />
			<input id="origVesselCd" 		name="origVesselCd"  		type="hidden" value="" />
			<input id="multiVesselCd" 		name="multiVesselCd"  		type="hidden" value="${multiVesselCd }" />
			<input id="paramVesselCd" 		name="paramVesselCd"  		type="hidden" value="" />
			<input type="hidden" id="hidDiscountExists" name="hidDiscountExists"/> <!-- added by Kenneth L.03.26.2014  -->
			<input type="checkbox" id="chkDiscountSw" name="chkDiscountSw" disabled="disabled" style="visibility: hidden;"/> <!-- added by Kenneth L.03.26.2014  -->
		
			<table width="100%">
				<tr>
					<td style="width: 920px;">
						<table cellspacing="0" border="0" style="margin-bottom: 0px; width: 895px;">					
							<tr>				
								<td class="rightAligned" style="width: 100px;">Item No. </td>
								<td class="leftAligned" style="width: 200px;"><input type="text" tabindex="1" style="text-align: right; width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999" /></td>
								<td class="rightAligned" style="width: 100px;">Item Title </td>
								<td class="leftAligned" style="width: 220px;"><input type="text" tabindex="2" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" maxlength="50" /></td>
								<td rowspan="6">
									<div id="utilityButtonsDiv" changeTagAttr="true">
										<table cellpadding="1" border="0" align="center" style="width: 150px;">
											<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
											<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
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
								<td class="rightAligned" style="width: 100px;">Description</td>
								<td class="leftAligned" colspan="4" style="width: 551px;">
								<!-- <input type="text" tabindex="3" style="width: 588px; padding: 2px;" id="itemDesc" name="itemDesc" maxlength="2000" />  -->
									<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
										<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none;" id="itemDesc" name="itemDesc"></textarea>
										<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 100px;"></td>
								<td class="leftAligned" colspan="4" style="width: 551px;">
								<!-- <input type="text" tabindex="4" style="width: 588px; padding: 2px;" id="itemDesc2" name="itemDesc2" maxlength="2000" />  -->
									<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
										<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none;" id="itemDesc2" name="itemDesc2"></textarea>
										<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc2" class="hover" />
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 100px;">Currency </td>
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
								<td class="leftAligned" style="width: 220px;">
									<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 100px;">Group</td>
								<td class="leftAligned" style="width: 220px;">
									<select tabindex="8" id="groupCd" name="groupCd" style="width: 230px;">
										<option value=""></option>
										<c:forEach var="group" items="${groups}">
											<option value="${group.groupCd}">${group.groupDesc}</option>				
										</c:forEach>
									</select>
								</td>
								<td class="rightAligned" style="width: 100px;">Region</td>
								<td class="leftAligned">
									<select tabindex="9" id="region" name="region" class="required" style="width: 230px;">
										<option value=""></option>
										<c:forEach var="region" items="${regions}">
											<option value="${region.regionCd}">${region.regionDesc}</option>				
										</c:forEach>
									</select>
								</td>											
							</tr>										
							<tr>
								<td colspan="4" style="width: 100%;" align="center">
									<table style="margin:auto; width:100%" border="0">
										<tr style="width: 100%;">
											<td>&nbsp;</td>
										</tr>
										<tr style="width: 100%;">
												<td width="100px"></td>
												<td class="rightAligned">
													<div style="text-align : left;">												
														<span style="display: none;">
															<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" tabindex="12" disabled="disabled" style="float: left;" />
															<label style="margin: auto;" > W/ Surcharge &nbsp;</label>
														</span>
														<span style="display: none;">
															<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" tabindex="13" disabled="disabled" style="float: left;" />
															<label style="margin: auto;" > W/ Discount &nbsp;</label>
														</span>												
														<span style="display: inline-block;">
															<input type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" tabindex="14" style="float: left;" />
															<label style="margin: auto;" > Include Additional Info.</label>
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
	<jsp:include page="/pages/underwriting/endt/jsonMarineCargo/subPages/endtMarineCargoItemInfoAdditional.jsp"></jsp:include>
</div>
<script type="text/javascript">
	var itemNo 			= 0;
	var itemTitle 		= "";
	var itemDesc 		= "";
	var itemDesc2 		= "";
	var currency		= "";
	var currencyText 	= "";
	var rate 			= "";
	var coverage 		= "";
	var coverageText 	= "";
	var region			= "";
	var regionText		= "";
	var stop 			= false;

	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	// initialized values
	// Kailangan i-parse yung object para hindi sya magreference dun sa formMap :D	
	
	objGIPIWItem = JSON.parse(Object.toJSON(formMap.itemCargos));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	objGIPIWVesAir = JSON.parse(Object.toJSON(formMap.gipiWVesAir));
	objGIPIWVesAccumulation = JSON.parse(Object.toJSON(formMap.gipiWVesAccumulation));
	objGIPIWCargoCarrier = JSON.parse(Object.toJSON(formMap.gipiWCargoCarrier));
	objItemAnnTsiPrem = JSON.parse(Object.toJSON(formMap.itemAnnTsiPrem));//monmon
	objPolbasics = JSON.parse('${gipiPolbasics}'); // andrew - 07162015 - 19806
	objParPolbas = JSON.parse('${gipiWPolbas}'); // andrew - 07162015 - 19806
	showItemList(objGIPIWItem);
	
	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);

	$("itemTitle").observe("keyup", function(){
		$("itemTitle").value = $F("itemTitle").toUpperCase();
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
	
	function addItem(){
		itemNo 			= $F("itemNo");
		itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
		itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
		itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
		currency		= $F("currency");
		currencyText 	= $("currency").options[$("currency").selectedIndex].text;
		rate 			= $F("rate");
		//coverage 		= $F("coverage");
		//coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
		region			= $F("region");
		regionText		= $("region").options[$("region").selectedIndex].text;

		if(isParItemInfoValid()){

			if($F("vesselCd").blank() && !(itemTitle.blank())){
				customShowMessageBox("Please complete the information for Item No. " + itemNo + " before saving.", imgMessage.INFO, "vesselCd");				
				return false;
			}

			if((($$("div#cargoCarrierTable div[item='" + itemNo + "']")).length < 1) && $F("vesselCd") == objFormVariables.varVMultiCarrier){
				customShowMessageBox("Item No. " + itemNo + " has no corresponding vessel.", imgMessage.INFO, "carrierVesselCd");
				return false;
			}

			if($F("btnAddItem") == "Add" && "N" == objFormMiscVariables.miscDeletePerilDiscById) {
				parItemDeleteDiscount(false);
			}
			
			addParItem();
			//objFormMiscVariables.miscNbtInvoiceSw = "Y";

			if(objFormMiscVariables.miscCopy == "Y"){				
				updateObjCopyToInsert(objGIPIWCargoCarrier, itemNo);
				updateObjCopyToInsert(objDeductibles, itemNo);
				updateObjCopyToInsert(objGIPIWItemPeril, itemNo);				
				objFormMiscVariables.miscCopy = "N";
			}

			/*if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N" && objFormMiscVariables.miscCopy == "N"){
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
			showMessageBox("You are not allowed to have more than one item for a package plan.", imgMessage.INFO);
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
			}
		}		
	});

	function deleteItem(itemNo){
		parItemDeleteDiscount(false);
		deleteParItem();
		deleteFromCargoCarrier(itemNo);

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

	$("currency").observe("change", function(){		
		if(!($F("currency").empty())){				
			if(objFormVariables.varOldCurrencyCd != $F("currency")){
				objFormVariables.varGroupSw = "Y";				
			}				
			getRates();
			$("rate").readOnly = $("currency").value == 1 ? true : false;
		}else{
			$("rate").value = "";
		}						
	});

	$("currency").observe("focus", function(){
		objFormVariables.varOldCurrencyCd = $F("currency");
	});

	$("btnCopyItemInfo").observe("click", confirmCopyItem);
	$("btnCopyItemPerilInfo").observe("click", confirmCopyItemPeril);	
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
	
 	/* var carrierExist = "Y";
	<c:if test="${empty vesselListing}">
		carrierExist = "N";
	</c:if>
	 */
	$("itemNo").observe("change", function(){ 
		toggleEndtItemDetails($F("itemNo"));
	});	
</script>