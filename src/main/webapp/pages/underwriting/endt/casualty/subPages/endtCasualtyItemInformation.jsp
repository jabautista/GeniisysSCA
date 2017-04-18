<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
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
<div class="sectionDiv" id="itemInformationDiv">
	<jsp:include page="/pages/underwriting/endt/casualty/subPages/endtCasualtyItemInformationListingTable.jsp"></jsp:include>
	<div style="margin : 10px;" id="parItemForm">
		
		<input type="hidden" id="pageName"			name="pageName"			value="itemInformation" />
		<!-- GIPI_WITEM remaining fields -->
		<input type="hidden" id="itemGrp"			name="itemGrp"			 value="" />
		<input type="hidden" id="tsiAmt"			name="tsiAmt"			 value="" />
		<input type="hidden" id="premAmt"			name="premAmt"			 value="" />
		<input type="hidden" id="annPremAmt"		name="annPremAmt"		 value="" />
		<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		 value="" />
		<input type="hidden" id="recFlag"			name="recFlag"			 value="A" />
		<input type="hidden" id="packLineCd"		name="packLineCd"		 value="" />
		<input type="hidden" id="packSublineCd"		name="packSublineCd"	 value="" />
		<input type="hidden" id="otherInfo"			name="otherInfo"		 value="" />
	
		<!-- miscellaneous variables -->
		<input type="hidden" id="perilExists" 			name="perilExists" 			value="N" />
		
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
								<select tabindex="7" id="region" name="region" class="required" style="width: 103%;">
									<option value=""></option>
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}">${region.regionDesc}</option>				
									</c:forEach>
								</select>
							</td>						
						</tr>				
					</table>					
				</td>
				<td>
					<table cellpadding="1" border="0" align="center">
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnNegateItem" 		name="btnWItem" 			class="disabledButton" 	value="Negate/Remove Item" 		disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnDeleteAddAllItems" 	name="btnDeleteAddAllItems" class="button" 			value="Delete/Add All Items"/></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Details" 			disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>
						<tr>
							<td class="rightAligned" colspan="" style="padding-top: 10px;">
								<input type="checkbox" id="chkIncludeSw" name="chkIncludeSw" value="N" />Include Additional Info.
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>		
	</div>
</div>

<script type="text/javascript">	
	objEndtCAItems = eval('${casualtyItems}');
	objEndtCAPersonnels = eval('${casualtyPersonnels}');	
	objEndtGroupedItems = eval('${groupedItems}');
	objPolbasics = eval('${gipiPolbasics}');
	objParPolbas = JSON.parse('${gipiWPolbas}');
	objItemNoList = eval('[]');	
	objDeductibles = new Array();
	objGIPIWItemPeril = new Array();
	objPerilWCs = new Array();
	
	showItemList(objEndtCAItems);
	//showTableList(objEndtGroupedItems, "groupedItemListing", "rowGroupedItem", "groupedItemsTable");
	
	createItemNoList(objEndtCAItems);			

	$$("div#itemTable div[name='row']").each(
		function(row){
			row.observe("mouseover", function(){
				row.addClassName("lightblue");
			});

			row.observe("mouseout", function(){
				row.removeClassName("lightblue");
			});

			row.observe("click", function(){
				clickRow(row, objEndtCAItems);
			});
		});

	$("btnAttachMedia").observe("click", function(){
		// openAttachMediaModal("par");
		openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
	});

	$("currency").observe("change", function(){
		if(!($F("currency").empty())){
			if(objFormVariables[0].varOldCurrencyCd != $F("currency")){
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
	});

	$("btnAddItem").observe("click", function(){
		if(nvl(objFormVariables[0].varDiscExist, "N") == "Y"){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
					"Continue", "Cancel", updateVariableDiscExist, stopProcess);
		}else if(nvl(objFormParameters[0].parPolFlagSw, "N") != "N"){
			showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
		}else{
			var itemNo = $F("itemNo");
			
			addJSONItem();
			//setCADefaultValues();
			updateObjCopyToInsert(objDeductibles, itemNo);
			updateObjCopyToInsert(objEndtGroupedItems, itemNo);
			updateObjCopyToInsert(objEndtCAPersonnels, itemNo);			
		}
	});

	$("btnDeleteItem").observe("click", function(){
		var itemNo = $F("itemNo");
		// load item deductible listing
		if($("deductiblesTable2") == null){
			showDeductibleModal(2);
		}

		var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 2, "T");

		//if($$("div#deductiblesTable2 div[name='ded2']").size() > 0){
		if(itemTsiDeductibleExist){
			showConfirmBox("Item Deductible", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. " +
					"Continue?", "Yes", "No", function(){ deletePolicyDeductible(itemNo); }, stopProcess);
		}else{
			deleteJSONObject();
			deleteChildRecords(itemNo);
		}
	});

	function deletePolicyDeductible(itemNo){
		objFormMiscVariables[0].miscDeletePolicyDeductibles = "Y";
		objFormMiscVariables[0].miscNbtInvoiceSw = "Y";
		deleteJSONObject();
		deleteChildRecords(itemNo);
	}

	function deleteChildRecords(itemNo){
		$$("div#groupedItemsTable div[name='rowGroupedItem']").each(function(row){
			row.removeClassName("selectedRow");			
			if(row.getAttribute("itemNo") == itemNo){
				Effect.Fade(row, {
					duration : .001,
					afterFinish : function(){						
						row.remove();
						var delObj = new Object();

						delObj.parId = $F("globalParId");
						delObj.itemNo = itemNo;
						delObj.groupedItemNo = row.getAttribute("groupedItemNo");
						delObj.origRecord = isOriginalRecord('${groupedItems}', delObj, "itemNo groupedItemNo");
						addDelObjByAttr(objEndtGroupedItems, delObj, "groupedItemNo");

						delete delObj;												
						checkIfToResizeTable2("groupedItemListing", "rowGroupedItem");
						checkTableIfEmpty2("rowGroupedItem", "groupedItemsTable");						
					}
				});
			}
		});

		setValues("rowGroupedItem", null);

		$$("div#casualtyPersonnelTable div[name='rowCasualtyPersonnel']").each(function(row){
			row.removeClassName("selectedRow");
			if(row.getAttribute("itemNo") == itemNo){
				Effect.Fade(row, {
					duration : .001,
					afterFinish : function(){
						row.remove();
						var delObj = new Object();

						delObj.parId = $F("globalParId");
						delObj.itemNo = itemNo;
						delObj.personnelNo = row.getAttribute("personnelNo");
						delObj.origRecord = isOriginalRecord('${casualtyPersonnels}', delObj, "itemNo personnelNo");
						addDelObjByAttr(objEndtCAPersonnels, delObj, "personnelNo");

						delete delObj;
						checkIfToResizeTable2("casualtyPersonnelListing", "rowCasualtyPersonnel");
						checkTableIfEmpty2("rowCasualtyPersonnel", "casualtyPersonnelTable");
					}
				});
			}
		});

		setValues("rowCasualtyPersonnel", null);
	}

	$("itemNo").observe("change", function(){
		var result = true;
		
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
								
								result = true;
							} else {
								showMessageBox(msg, imgMessage.ERROR);
								result = false;
							}
						} else {
							result = true;
						}
					} else {
						result = false;
					}
				}
			});
		}

		if (!result) {
			return false;
		} else {
			var newItem = true;
						
			for(var outerIndex=0, outerLength=objPolbasics.length; outerIndex < outerLength; outerIndex++){
				for(var innerIndex=0, innerLength=objPolbasics[outerIndex].gipiItems.length; innerIndex < innerLength; innerIndex++){
					
					//if(JSON.stringify(objPolbasics[outerIndex].gipiItems[innerIndex].gipiCasualtyItem.itemNo) == $F("itemNo")){
					if(objPolbasics[outerIndex].gipiItems[innerIndex].itemNo == $F("itemNo")){						
						$("itemNo").value 		= objPolbasics[outerIndex].gipiItems[innerIndex].itemNo;
						$("itemTitle").value 	= objPolbasics[outerIndex].gipiItems[innerIndex].itemTitle;
						$("itemDesc").value 	= objPolbasics[outerIndex].gipiItems[innerIndex].itemDesc;
						$("itemDesc2").value 	= objPolbasics[outerIndex].gipiItems[innerIndex].itemDesc2;
						$("currency").value 	= objPolbasics[outerIndex].gipiItems[innerIndex].currencyCd;
						$("rate").value 		= formatToNineDecimal(objPolbasics[outerIndex].gipiItems[innerIndex].currencyRt);
						$("region").value 		= objPolbasics[outerIndex].gipiItems[innerIndex].regionCd;

						supplyEndtCasualtyAdditionalInfo(objPolbasics[outerIndex].gipiItems[innerIndex].gipiCasualtyItem);
					}else{
						//$("itemNo").value 	= objPolbasics[outerIndex].gipiItems[innerIndex].itemNo;
						$("itemTitle").value 	= "";
						$("itemDesc").value 	= "";
						$("itemDesc2").value 	= "";
						$("currency").value 	= objPolbasics[outerIndex].gipiItems[innerIndex].currencyCd;
						$("rate").value 		= formatToNineDecimal(objPolbasics[outerIndex].gipiItems[innerIndex].currencyRt);
						$("region").value 		= objPolbasics[outerIndex].gipiItems[innerIndex].regionCd;

						supplyEndtCasualtyAdditionalInfo(null);
					}
				}			
			}			
		}
	});

	function updateVariableDiscExist(){
		objFormVariables[0].varDiscExist = "N";

		if(nvl(objFormParameters[0].parPolFlagSw, "N") != "N"){
			showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
		}
	}

	function setCADefaultValues(){		
		if(objCurrEndtItem != undefined){
			$("row" + objCurrEndtItem.itemNo).removeClassName("selectedRow");
		}
	}	

	function confirmAssignDeductibles(){
		var objItemItemNo	= new Object();
		var objDedItemNo	= new Object();
		var itemNo			= "";
		var exists1			= false;
		var exists2			= true;
		
		$$("div#deductiblesTable2 div[name='ded2']").each(function(row){
			itemNo = row.getAttribute("item");
			
			if(itemNo == $F("itemNo")){
				exists1 = true;
			}
			
			if(objDedItemNo[itemNo] == null){
				objDedItemNo[itemNo] = itemNo;
			}
		});
		
		$$("div#itemTable div[name='row']").each(function(row){
			itemNo = row.down("label", 0).innerHTML;
			objItemItemNo[itemNo] = itemNo;
		});
		
		if((Object.keys(objItemItemNo)).size() == (Object.keys(objDedItemNo)).size()){
			exists2 = false;
		}
		
		for(attr in objItemItemNo){
			if(objDedItemNo[attr] == null){
				if(attr == $F("itemNo")){
					exists2 = true;
				}
			}
		}
		
		if(exists1 && exists2){

		}else if(!exists1){
			itemNo = new Number($F("itemNo"));
		}else if(!exists2){

		}

		delete objItemItemNo, objDedItemNo;
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
</script>