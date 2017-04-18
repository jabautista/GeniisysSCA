<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
   			<label id="showAccItemInfo" name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>

<div class="sectionDiv" id="itemInformationDiv">
	<jsp:include page="/pages/underwriting/endt/common/subPages/endtItemInformationListingTable.jsp"></jsp:include>
	<div style="margin: 10px;" id="parItemForm">
	
	<input type="hidden" id="tempItemNumbers"		name="tempItemNumbers" />
		<input type="hidden" id="deleteItemNumbers"		name="deleteItemNumbers" />
		<input type="hidden" id="tempDeductibleItemNos"	name="tempDeductibleItemNos" />
		<input type="hidden" id="tempMortgageeItemNos"	name="tempMortgageeItemNos"	/>
		<input type="hidden" id="tempAccessoryItemNos"	name="tempAccessoryItemNos" />
		<input type="hidden" id="tempPerilItemNos"		name="tempPerilItemNos" />
		<input type="hidden" id="tempCarrierItemNos"	name="tempCarrierItemNos" />
		<input type="hidden" id="tempGroupItemsItemNos"	name="tempGroupItemsItemNos" />
		<input type="hidden" id="tempPersonnelItemNos"	name="tempPersonnelItemNos" />
		<input type="hidden" id="tempBeneficiaryItemNos"  name="tempBeneficiaryItemNos" />
	
	<!-- storage for inserting/updating/deleting items -->
		<input type="hidden" id="tempItemNumbers"		name="tempItemNumbers" />
		<input type="hidden" id="deleteItemNumbers"		name="deleteItemNumbers" />
		<input type="hidden" id="tempDeductibleItemNos"	name="tempDeductibleItemNos" />
		<input type="hidden" id="tempMortgageeItemNos"	name="tempMortgageeItemNos"	/>
		<input type="hidden" id="tempAccessoryItemNos"	name="tempAccessoryItemNos" />
		<input type="hidden" id="tempPerilItemNos"		name="tempPerilItemNos" />
		<input type="hidden" id="tempCarrierItemNos"	name="tempCarrierItemNos" />
		<input type="hidden" id="tempGroupItemsItemNos"	name="tempGroupItemsItemNos" />
		<input type="hidden" id="tempPersonnelItemNos"	name="tempPersonnelItemNos" />
		<input type="hidden" id="tempBeneficiaryItemNos"  name="tempBeneficiaryItemNos" />
		
		<input type="hidden" id="tempVariable"			name="tempVariable" 		value="0" />		
		<input type="hidden" id="cgCtrlIncludeSw"		name="cgCtrlIncludeSw"		value="" />
		
		<!-- GIPI_WITEM remaining fields -->
		<input type="hidden" id="itemGrp"			name="itemGrp"			 value="" />
		<input type="hidden" id="tsiAmt"			name="tsiAmt"			 value="" />
		<input type="hidden" id="premAmt"			name="premAmt"			 value="" />
		<input type="hidden" id="annPremAmt"		name="annPremAmt"		 value="" />
		<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		 value="" />
		<input type="hidden" id="recFlag"			name="recFlag"			 value="A" />
		<!--
		<input type="hidden" id="groupCd"			name="groupCd"			 value="" />
		 -->
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
		<input type="hidden" id="varVCopyItem"	name="varVCopyItem"	value="" />
		
		<input type="hidden" id="itemWODed" name="itemWODed" value=""/>
		
		<!-- miscellaneous variables -->
		<input type="hidden" id="currencyListIndex"		name="currencyListIndex"	value="0" />
		<input type="hidden" id="lastRateValue"			name="lastRateVal"	value="0" />
		<input type="hidden" id="lastItemNo" 			name="lastItemNo" 			value="${lastItemNo}" />
		<input type="hidden" id="itemNumbers" 			name="itemNumbers" 			value="${itemNumbers}" />
		<input type="hidden" id="perilExists" 			name="perilExists" 			value="N" />
		<input type="hidden" id="addDeletePageLoaded" 	name="addDeletePageLoaded" 	value="N" />
		<input type="hidden" id="addtlInfoValidated" 	name="addtlInfoValidated" 	value="N" />
		<input	type="hidden" id="delPolDed" name="delPolDed" value="N" />
		<input type="hidden" id="deleteParDiscounts" name="deleteParDiscounts" value="N"/>
		
		<!-- Start of table -->
		<table width="100%" cellspacing="1" border="0">					
			<tr>				
				<td class="rightAligned" style="width: 20%;">Item No. </td>
				<td class="leftAligned" style="width: 20%;"><input type="text" tabindex="1" style="width: 100%; padding: 2px;" id="itemNo" name="itemNo" class="required" errorMsg="test" maxlength="9"/></td>
				<td class="rightAligned" style="width: 10%;">Item Title </td>
				<td class="leftAligned"><input type="text" tabindex="2" style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="250" /></td>
				<td rowspan="6"  style="width: 20%;">
					<table cellpadding="1" border="0" align="center">
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 		class="disabledButton" value="Copy Item Info" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 		class="disabledButton" value="Copy Item/Peril Info" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnNegateRemoveItem" 	name="btnWItem" 		class="disabledButton" value="Negate/Remove Item" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnDeleteAddAllItems" 	name="btnDeleteAddAllItems" 				   class="button" value="Delete/Add All Items"/></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 		class="disabledButton" value="Assign Deductibles" disabled="disabled" /></td></tr>						
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 		class="disabledButton" value="Other Details" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>

					</table>						
				</td>
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
					<select tabindex="5" id="currency" name="currency" style="width: 100%;" class="required">				
						<c:forEach var="currency" items="${currency}">
							<option shortName="${currency.shortName }" 
							value="${currency.code}"
							<c:if test="${1 == currency.code}">
								selected="selected"
							</c:if>>${currency.desc}</option>				
						</c:forEach>	
					</select>
					<select style="display: none;" id="currFloat" name="currFloat">						
						<c:forEach var="cur" items="${currency}">							
							<option value="${cur.valueFloat}">${cur.valueFloat}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Rate</td>
		<td class="leftAligned" style="width: 20%;"><input type="text"
			tabindex="6" style="width: 100%; padding: 2px;" id="rate" name="rate"
			class="moneyRate required" maxlength="12"
			value="<c:if test="${not empty item }">${item[0].currencyRt }</c:if>" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Coverage
					<input type="hidden" id="hideCoverage" name="hideCoverage" value="" />
				</td>
				<td class="leftAligned"  style="width: 20%;">
					<select tabindex="7" id="coverage" name="coverage" style="width: 100%;" class="required">
						<option value=""></option>
						<c:forEach var="coverages" items="${coverages}">
							<option value="${coverages.code}"
							<c:if test="${item.coverageCd == coverages.code}">
								selected="selected"
							</c:if>>${coverages.desc}</option>				
						</c:forEach>
					</select>
				</td>
				
				<td class="rightAligned" style="width: 10%; ">Group </td>
				<td class="leftAligned" style="width: 20%;">
					<select tabindex="8" id="groupCd" name="groupCd" style="width: 103%;">
						<option value=""></option>
						<c:forEach var="groups" items="${groups}">
							<option value="${groups.groupCd}"
							<c:if test="${item.groupCd == groups.groupCd}">
								selected="selected"
							</c:if>>${groups.groupDesc}</option>
						</c:forEach>				
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%; ">Effectivity Dates </td>
				<td colspan="3" class="leftAligned" style="">
					<div style="float:left; border: solid 1px gray; width: 28%; height: 21px; margin-right:3px;">
			    		<input style="width: 80%; border: none;" id="accidentFromDate" name="accidentFromDate" type="text" value="" readonly="readonly"/>
			    		<img id="hrefAccidentFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('accidentFromDate'),this, null);" alt="To Date" />
					</div>
					<div style="float:left; border: solid 1px gray; width: 28%; height: 21px; margin-right:3px;">
			    		<input style="width: 80%; border: none;" id="accidentToDate" name="accidentToDate" type="text" value="" readonly="readonly"/>
			    		<img id="hrefAccidentToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('accidentToDate'),this, null);" alt="To Date" />
					</div>
					<input class="rightAligned" type="text" id="accidentDaysOfTravel" name="accidentDaysOfTravel" value="" style="width: 28%; height: 15px;" readonly="readonly">
					days
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;display: none;">Plan </td>
				<td class="leftAligned"  style="width: 20%;display: none;">
					<select tabindex="7" id="accidentPackBenCd" name="accidentPackBenCd" style="width: 100%;">
						<option value=""></option>
						<c:forEach var="plans" items="${plans}">
							<option value="${plans.packBenCd}"
							<c:if test="${item.packBenCd == plans.packBenCd}">
								selected="selected"
							</c:if>>${plans.packageCd}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%; display: none;">Payment Mode </td>
				<td class="leftAligned" style="width: 20%;display: none;">
					<select tabindex="8" id="accidentPaytTerms" name="accidentPaytTerms" style="width: 103%;">
						<option value=""></option>
						<c:forEach var="payTerms" items="${payTerms}">
							<option value="${payTerms.paytTerms}"
							<c:if test="${item.paytTerms == payTerms.paytTerms}">
								selected="selected"
							</c:if>>${payTerms.paytTermsDesc}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Region </td>
				<td class="leftAligned"  style="width: 20%;">
					<select tabindex="7" id="region" name="region" class="required" style="width: 100%;">
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
		</table>
		<table style="margin:auto; width:55%" border="0">
			<tr>
				<td class="rightAligned">
				
				
					<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" disabled="disabled" />W/ Surcharge &nbsp; &nbsp; &nbsp;
					<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" disabled="disabled" />W/ Discount &nbsp; &nbsp; &nbsp;
					<input type="checkbox" id="includeSw"		name="includeSw"		value="Y" checked="checked" disabled="disabled" />Include Additional Info &nbsp; &nbsp; &nbsp;
					<!--  commented out for now, just add if statements for specific lineCDS
					<c:if test="${lineCd ne 'AV'}"><input type="checkbox" id="chkIncludeSw" name="chkIncludeSw" 	value="N" />Include Additional Info.</c:if>
					<c:if test="${lineCd eq 'AV'}"><input type="hidden" id="chkIncludeSw" name="chkIncludeSw" 	value="" /></c:if>-->
				</td>
			</tr>
		</table>
	</div>
</div>	

<div id="assignedDedDiv">
</div>

<div id="perilDedDiv">
	<input type="hidden" name="perilDedList" id="perilDedList" value="" />
</div>

<input type="hidden" name="itemNegSw" id="itemNegSw" value="N" />
<input type="hidden" name="delDedSw" id="delDedSw" value="N" />
<input type="hidden" name="addedItemNos" id="addedItemNos" />
<input type="hidden" name="deletedItemNos" id="deletedItemNos" />
<input type="hidden" name="delItemDiscSw" id="delItemDiscSw" value="N" />

<script type="text/javascript">
	getRates();
	initAccident();
	loadAllFields();

	$("showAccItemInfo").observe("click", function(){
		if ($("showAccItemInfo").innerHTML == "Hide"){
			$("additionalItemInformation").hide();
		} else if ($("showAccItemInfo").innerHTML == "Show"){
			$("additionalItemInformation").show();
		}
	});
	
	$$("input[type='text']").each(
			function(txt) {
				txt.observe("change", function() {
					$("changedFields").value = parseInt($F("changedFields")) + 1;
					$("addtlInfoValidated").value = "N";
				});
			}
		 );

	$$("select").each(function(sel) {
		sel.observe("change", function() {
			$("changedFields").value = parseInt($F("changedFields")) + 1;
		});
	});

	$$("div#itemTable div[name='row']").each(
			function(row){
				row.observe("mouseover", 
					function(){
						row.addClassName("lightblue");
				});
	
				row.observe("mouseout",
					function(){
						row.removeClassName("lightblue");
				});
	
				row.observe("click",
					function(){
						clickParItemRow(row);
				});
			}
		);

//add, delete item.
	$("btnSaveItem").observe("click", function() {
		if (!whenNewRecordInstance() && $F("btnSaveItem") == "Add") {
			return false;
		} else {
			if ($F("recFlag") == "A" || $F("recFlag").blank()) {
				createRecord();
			} else {
				saveItem();
			}
		}
	});

	$("btnDelete").observe("click",
			function(){
				// check first if the policy is cancelled
				if($F("globalPolFlag") == "4"){
					showMessageBox("Items cannot be deleted if the policy is cancelled.", imgMessage.ERROR);
					return false;
				}else{
					if ($F("varDeductibleExist") == "Y") {
						if ($F("varDeductibleExist") == "Y") {
							showConfirmBox("Delete item", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
									"Yes", "No", delPolDed, "");
						}
					} else {
						deleteRecord();
					}
				}	
		});

	function delPolDed(){
		$("delPolDed").value = "Y";
		deleteRecord();
	}

	$("coverage").observe("blur", function() {
		if ($("coverage").selectedIndex == 0){
			showMessageBox("Coverage is required.", imgMessage.ERROR);
			$("coverage").focus();
		}
	});
	
//B480.ITEM_NO - when_validate_item
	$("itemNo").observe("change", function() {	
		var itemNoDeleted = false;
		var test = $F("itemNo").split(".");
		
		var itemNoDeleted = false;
		var itemNoValid = true;
	
		if(isNaN($F("itemNo"))){
			itemNoValid = false;
			showMessageBox("Field must be of form 099999999.", imgMessage.ERROR);
			$("itemNo").value = "";
			$("itemNo").focus();
		}
	
		if (itemNoValid){
			itemNoValid = !(checkIfDecimal2($F("itemNo")));
			if (!itemNoValid){
				$("itemNo").value = "";
				$("itemNo").focus();
				showMessageBox("Field must be of form 099999999.", "error");
			}
		}
		
		$$("input[name='delItemNos']").each(function(row) {
			if ($F("itemNo") == row.value) {
				itemNoDeleted = true;
			}
		});
	
		if (itemNoDeleted) {
			showMessageBox("You are trying to enter an item with item number. that is previously deleted. " +
								"Please save changes first.", imgMessage.INFO);
			$("itemNo").value = "";
			$("itemNo").focus();
			return false;
		}
		
		if (itemNoValid){
			$("annTsiAmt").value = "";
	  		$("annPremAmt").value = "";
	  		
			if ($F("varNewSw2") == "N") {
				return false;
			}
		//var result = true;
	
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
						//showMessageBox("Checking if item has already been endorsed. Please wait...", imgMessage.INFO);
						//showNotice("Checking if item has already been endorsed. Please wait...");
					},
					onComplete : function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice2();
							var msg = response.responseText;
							
							if (!msg.blank()) {
								var res = msg.split(" ")[0];
		
								if (res == "SUCCESS") {
									hideNotice2();
									showWaitingMessageBox("This is a backward endorsement, any changes made in this item will affect " +
							                 "all previous endorsement that has an effectivity date later than " + msg.substring(8), "info", validateItemNo);
									//result = true;
								} else {
									showMessageBox(msg, imgMessage.ERROR);
									//result = false;
								}
							} else {
								validateItemNo();
							}
						} else {
							result = false;
						}
					}
				});
			}else{
				validateItemNo();
			}
		}
	});

	function validateItemNo(){ //B480.ITEM_NO - when_validate_item STEP #2
		var newItem = true;
		
		$$("div#itemTable div[name='row']").each(function (row) {
			if(row.down("input", 1).value == $F("itemNo")) {
				showMessageBox("You are attempting to create a record with an existing item number " +
			             "or with a deleted item but had not yet been committed, please do the " +
			             "necessary actions.", imgMessage.INFO);
				clickParItemRow(row);
	            newItem = false;
	            return false;
			}
		});
	
		if(newItem){
			new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=getEndtGipiWItemAccidentDetails",{
				method : "GET",
				parameters : {
					globalParId : $F("globalParId"),
					lineCd 		: $F("globalLineCd"),
					sublineCd 	: $F("globalSublineCd"),
					issCd 		: $F("globalIssCd"),
					issueYy 	: $F("globalIssueYy"),
					polSeqNo 	: $F("globalPolSeqNo"),
					renewNo 	: $F("globalRenewNo"),
					expiryDate  : $F("globalExpiryDate").substr(0,10),
					effDate 	: $F("globalEffDate").substr(0,10),
					itemNo 		: $F("itemNo"),
					annTsiAmt 	: $F("annTsiAmt").replace(/,/g,""),
					annPremAmt 	: $F("annPremAmt").replace(/,/g,"")
				},
				asynchronous : true,
				evalScripts : true,
				onCreate: function(){
					//showNotice("Validating item for negation. Please wait.");
					
				},onComplete: function(response){
					hideNotice2();
					
					//0-item title, 1 coverage, 2 groupcd, 3 fromdate, 4 todate, 5 restrictedcondition, 6, changedtag, 7 prorateflag, 8 comsw, 9 shortratepercent
						// 10 recflag// 11 region code//12 anntsiamt// 13 annpremamt
					var text = response.responseText;
					var a = text.split(",");
					
					if ("N" == a[5]){
						$("itemTitle").value =(a[0] == "null"? "": a[0]).toUpperCase();
						$("coverage").value =(a[1] == "null"? "": a[1]);
						$("group").value =(a[2] == "null"? "": a[2]);
						$("fromDate").value = a[3] == "null"? "": a[3];
						$("toDate").value = a[4] == "null"? "": a[4];
						//$("changedTag").value = a[6] == "null"? "": a[6];
						//$("prorateFlag").value = a[7] == "null"? "": a[7];
						//$("compSw").value = a[8] == "null"? "": a[8];
						//$("shortRtPercent").value = a[9] == "null"? "": a[9];
						$("recFlag").value = a[10];
						$("region").value = a[11] == "null"? "": a[11];
						$("annTsiAmt").value = a[12] == "null"? "": a[12];;
						$("annPremAmt").value = a[13] == "null"? "": a[13];;
						$("currency").value = a[3] == "null"? 1: a[14];
						getRates();
					} else {
						setCursor("default");
						showMessageBox("Your endorsement expiry date is equal to or less than your effectivity date. "
								+"Restricted condition.", imgMessage.INFO);
					}
				}
			});
		}
	}
/*pol
 * global parameters neededs
 
 */

// supply add info function
	function clickParItemRow(row) {		
			hideNotice("");
	
			row.toggleClassName("selectedRow");
			$("perilExists").value = "N";
	
			//test function for displaying of perils
			/*
			$$("div[name='rowEndtPeril']").each(function (peril){
				if (peril.getAttribute("item") == row.id.replace("row", "")){
					peril.show();
				} else {
					peril.hide();
				}
				setEndtItemAmounts(peril.getAttribute("item"));
				checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
				checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
			});
			*/
			
			if(row.hasClassName("selectedRow")){	
				$$("div#itemTable div[name='row']").each(
					function(r){
						if(row.getAttribute("id") != r.getAttribute("id")){
							r.removeClassName("selectedRow");
							return false;
						}									
					});
				supplyItemInfo(true, row, row.down("input", 1).value);
				enableWItemButtons();
				setRecordListPerItem(true);
				clearPopupFields();
	
				//getItemPerilDetails();		
				if ($F("vAllowUpdateCurrRate").blank()) {
					$("currency").readOnly = true;
				} else {
					$("currency").readOnly = false;
				}
				//update misc values
				$("lastRateValue").value = $F("rate");
	
				$("itemNo").readOnly = true;
				//emman
				//pansamantalang tanggalin
				/*
				if (checkIfPerilExists(true)) {
					$("perilExists").value = "Y";
				} else {
					$("perilExists").value = "N";
				}
				*/
				//check if currency is updateable
				if ($F("vAllowUpdateCurrRate") != "Y" && $F("globalLineCd") == "AH") {
					$("currency").disable();
					$("rate").disable();
				}
				//whenNewRecordInstance();
			} else {
				setDefaultValues();
				setRecordListPerItem(false);
				disableWItemButtons();
				
				if ($("currency").readOnly) {
					$("currency").readOnly = false;
				}
				$("itemNo").readOnly = false;
				$("itemNo").focus();
	
				if ($("currency").disabled) {
					$("currency").enable();
				}
	
				if ($("rate").disabled) {
					$("rate").enable();
				}
			}
			//$("currencyListIndex").value = $("currency").selectedIndex; -- 1
			//$("changedFields").value = 0;
			//$("currency").value 		= 1; -- 2
			//getRates();  -- 3
			//$("coverage").value 		= "";
			//toggleEndtItemPeril($F("itemNo")); // added by andrew 07.08.2010	
			
		}

	function loadAllFields(){
	
		try {
			hideNotice("");
			if($("deductibleDetail2") != null){
				showDeductibleModal(2);			
			}
			if($("perilInformationDiv") != null){
				new Ajax.Updater("perilInformationDiv", contextPath+"/GIPIWItemPerilController", {
					method: "GET",
					parameters: {action:			"showEndtPerilInfo",
								 globalParType:		$F("globalParType"),
								 globalParId: 		$F("globalParId"),
								 globalLineCd: 		$F("globalLineCd"),
								 globalSublineCd: 	$F("globalSublineCd"),
								 globalIssCd:		$F("globalIssCd"),
								 globalIssueYy:		$F("globalIssueYy"),
								 globalPolSeqNo:	$F("globalPolSeqNo"),
								 globalRenewNo:		$F("globalRenewNo"),
								 globalEffDate: 	$F("globalEffDate")
								 //itemNo:			$F("itemNo")
								 },
					asynchronous: true,
					evalScripts: true,
					onCreate: function() {
						setCursor("wait");
						showSubPageLoading("showPerilInfoSubPage", true);
					},
					onComplete: function () {
						showSubPageLoading("showPerilInfoSubPage", false);
						setCursor("default");
						toggleEndtItemPeril($F("itemNo"));
						Effect.Appear($("parInfoDiv").down("div", 0), {duration: .001});
					}
				});	
			}
		} catch(e){
			showErrorMessage("loadAllFields", e);
			//showMessageBox(e.message);
		}
		
	}

	function supplyItemInfo(blnApply, row, itemNo){
	//14 15	
		var itemFromDate = $F("fromDate");
		var itemToDate = $F("toDate");
		var region = ($F("globalLineCd") == "AH") ? "regionCd" : "region";
		var itemFields = ["itemNo", "itemTitle", "itemGrp", "itemDesc",
		              	  "itemDesc2", "tsiAmt", "premAmt", "annPremAmt",	
		                  "annTsiAmt", "recFlag",	"currency", "rate", 
		                  "groupCd","fromDate", "toDate", "packLineCd",
		                  "packSublineCd", "discountSw", "coverage", "otherInfo", 
		                  "surchargeSw","region", "changedTag", "prorateFlag"];
		/*var itemFields = ["itemNo", "itemTitle", "itemGrp", "itemDesc", 
		                  "itemDesc2", "tsiAmt", "premAmt", "annPremAmt",	
		                  "annTsiAmt", "recFlag",	"currency", "rate", 
		                  "groupCd", "fromDate", "toDate", "packLineCd", 
		                  "packSublineCd", "discountSw", "coverage", "otherInfo", 
		                  "surchargeSw", regionCd, "changedTag", "prorateFlag", 
		                  "compSw", "shortRtPercent",	"packBenCd", "paytTerms", 
		                  "riskNo", "riskItemNo"];*/
	    
	    if(blnApply){            
	//    	for(var index=0, length=30; index<length; index++){
	//         	$(itemFields[index]).value =  row.down("input", index+1).value;           	 			
	    	for(var index=0, length=itemFields.length; index<length; index++){
	        	$(itemFields[index]).value =  row.down("input", index+1).value;
	        }
	
	        //$("currency").value = row.down("input", 11).value;
	    	$("rate").value = formatToNineDecimal(row.down("input", 12).value);
	    	$("tsiAmt").value = formatCurrency(row.down("input", 6).value);
	    	$("premAmt").value = formatCurrency(row.down("input", 7).value);
	    	$("annPremAmt").value = formatCurrency(row.down("input", 8).value);
	    	$("annTsiAmt").value = formatCurrency(row.down("input", 9).value);
	    	$("shortRtPercent").value = formatCurrency(row.down("input", 26).value);
	    	$("itemTitle").value = changeSingleAndDoubleQuotes(row.down("input", 2).value);
	    	$("itemDesc").value = changeSingleAndDoubleQuotes(row.down("input", 4).value);
	    	$("itemDesc2").value = changeSingleAndDoubleQuotes(row.down("input", 5).value);
	    	$("otherInfo").value = changeSingleAndDoubleQuotes(row.down("input", 20).value);
	
	    } else{           
	    	for(var index=0, length=itemFields.length; index<length; index++){
				$(itemFields[index]).value = "";
	        }
	        $("itemNo").value = itemNo;            
	    	$("recFlag").value = "A";
	    	$("rate").value = formatToNineDecimal("1.00");
	    	$("fromDate").value = itemFromDate;
	    	$("toDate").value = itemToDate;
	    }
	    supplyAccidentInfo(blnApply, row);
	}

	function setDefaultValues(){
		//$("itemNo").value 			= $F("itemNo");
		//var lineCd = $F("globalLineCd");
	
		/*
		if (lineCd == "CA"){
			var ora2010Sw = $F("ora2010Sw");
		}
		*/	
	
		$$("div#itemInformationDiv input[type=text]").each(
			function(elem){
				if(elem.hasClassName("money") || elem.hasClassName("money1")){
					elem.value = "0.00";
				} else if(elem.hasClassName("moneyRate")){
					elem.value  = formatToNineDecimal("1.00");
				} else if (elem.hasClassName("percentRate")) {
					elem.value  = formatToNineDecimal("0");
				} else {
					elem.value = "";				
				}
			}
		);
	
		$$("div#itemInformationDiv select").each(
			function(elem){
				elem.value = "";
			}
		);
	
		
		$("currency").value 		= 1;
		$("coverage").value 		= "";
	
		clearAccidentModule();
		$$("div#itemTable div[name='row']").each(function (div) {
			div.removeClassName("selectedRow");
		});	
		$("parNo").value = $F("globalParNo");
		$("assuredName").value = $F("globalAssdName");
		$("policyNo").value = $F("vPolicyNo");
		$("recFlag").value = "A";
	}

	// for additional info
	function supplyAccidentInfo(blnApply, row){
		var accidentFields = ["noOfPerson","destination","monthlySalary",
		                 		 "salaryGrade"];
		if(blnApply){ 	
			$("accidentFromDate").value  = row.down("input", 14).value;
			$("accidentToDate").value    = row.down("input", 15).value;
			$("accidentPackBenCd").value = row.down("input", 27).value;
			$("accidentPaytTerms").value = row.down("input", 28).value;
			$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
			
			/*$("accidentProrateFlag").value = (row.down("input", 24).value == "" ? "2" :row.down("input", 24).value);
			if (row.down("input", 24).value == "" || row.down("input", 24).value == "2"){
				$("shortRateSelectedAccident").hide();
				$("prorateSelectedAccident").hide();
				$("accidentNoOfDays").value = "";
				$("accidentShortRatePercent").value = "";
				$("accidentCompSw").selectedIndex = 2;
			}	
			$("accidentCompSw").value = row.down("input", 25).value;
			$("accidentShortRatePercent").value = row.down("input", 26).value == "" || row.down("input", 26).value == "NaN"? "" :formatToNineDecimal(row.down("input", 26).value);
			*/
			for(var index=0, length=4; index<length; index++){
				$(accidentFields[index]).value = row.down("input", index+31).value;
			}
			if(row.down("input", 35).value.trim() != ""){
				$("positionCd").value = row.down("input", 35).value;
			} else{
				$("positionCd").selectedIndex = 0;
			}	
			$("deleteGroupedItemsInItem").value = row.down("input", 36).value;
			//commeted because these fields are transferred to overlay
			//$("pDateOfBirth").value = row.down("input", 37).value;
			//$("pAge").value = row.down("input", 38).value;
			//$("pCivilStatus").value = row.down("input", 39).value;
			//$("pSex").value = row.down("input", 40).value;
			//$("pHeight").value = row.down("input", 41).value;
			//$("pWeight").value = row.down("input", 42).value;
			//$("groupPrintSw").value = row.down("input", 43).value;
			//$("acClassCd").value = row.down("input", 44).value;
			//$("levelCd").value = row.down("input", 45).value;
			//$("parentLevelCd").value = row.down("input", 46).value;
			//$("itemWitmperlExist").value = row.down("input", 47).value;
			//$("itemWitmperlGroupedExist").value = row.down("input", 48).value;
			//$("populatePerils").value = row.down("input", 49).value;
			//$("itemWgroupedItemsExist").value = row.down("input", 50).value;
			//$("accidentDeleteBill").value = row.down("input", 51).value;
			$("noOfPerson").value = ($("noOfPerson").value == "" ? "" :formatNumber($("noOfPerson").value));
			
			if (parseInt($F("noOfPerson").replace(/,/g, "")) >1){	
				enableButton("btnGroupedItems");
				disableButton("btnPersonalAddtlInfo");	
				//$("personalAdditionalInfoDetail").hide();
				//$("personalAdditionalInformationInfo").hide();
				//$("showPersonalAdditionalInfo").update("Show");
				//$("personalAdditionalInfoDetail").hide();
				$("monthlySalary").disable();
				$("salaryGrade").disable();
				$("monthlySalary").clear();
				$("salaryGrade").clear();
			} else{
				enableButton("btnPersonalAddtlInfo");
				disableButton("btnGroupedItems");
				//$("personalAdditionalInfoDetail").show();
				//$("personalAdditionalInformationInfo").hide();
				//$("showPersonalAdditionalInfo").update("Show");
				//$("personalAdditionalInfoDetail").show();
				$("monthlySalary").enable();
				$("salaryGrade").enable();
			}
			$("monthlySalary").value = ($("monthlySalary").value == "" ? "" :formatCurrency($("monthlySalary").value));
			generateSequenceItemInfo("ben","beneficiaryNo","item",$F("itemNo"),"nextItemNoBen");
			
			$("accidentFromDate").enable();
			$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('accidentFromDate'),this, null);");
			$("accidentToDate").enable();
			$("hrefAccidentToDate").setAttribute("onClick","scwShow($('accidentToDate'),this, null);");
			$("accidentPackBenCd").enable();
	
		//	showRelatedSpan();
	
			/*if ($F("accidentProrateFlag") == "2"){
				var fDateArray = $F("accidentFromDate").split("-");
				var fmonth = fDateArray[0];
				var fdate = fDateArray[1];
				var fyear = fDateArray[2];
				var tDateArray = $F("accidentToDate").split("-");
				var tmonth = tDateArray[0];
				var tdate = tDateArray[1];
				var tyear = tDateArray[2];
				
				if ((fmonth+"-"+fdate+"-"+(parseInt(fyear)+1)) == (tmonth+"-"+tdate+"-"+tyear)){
					$("accidentProrateFlag").disable();
				}
			}*/
	
			if ($F("hidItemWitmperlGroupedExist") == "Y"){			
				//$("accidentProrateFlag").disable();
				//$("accidentShortRatePercent").disable();
				//$("accidentCompSw").disable();
				//$("accidentNoOfDays").disable();
				$("accidentFromDate").disable();
				$("hrefAccidentFromDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
				$("accidentToDate").disable();
				$("hrefAccidentToDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
				$("currency").disable();
				$("rate").disable();
			} else if ($F("hidItemWitmperlExist") == "Y" && $F("hidItemWitmperlGroupedExist") != "Y")	{
				$("accidentPackBenCd").disable();  
				//$("accidentShortRatePercent").disable();
				$("currency").enable();
				if ($("currency").value == "1"){
					$("rate").disable();
				}else{
					$("rate").enable();
				}	
			} else{
				$("accidentFromDate").enable();
				$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('accidentFromDate'),this, null);");
				$("accidentToDate").enable();
				$("hrefAccidentToDate").setAttribute("onClick","scwShow($('accidentToDate'),this, null);");
				$("accidentPackBenCd").enable();
				$("currency").enable();
				if ($("currency").value == "1"){
					$("rate").disable();
				}else{
					$("rate").enable();
				}
			}
		} else{
			clearAccidentModule();
		}
	}

	function clearAccidentModule(){
		$("accidentFromDate").value = "";
		$("accidentToDate").value = "";
		$("accidentPackBenCd").selectedIndex = 0;
		$("accidentPaytTerms").selectedIndex = 0;
		/*$("accidentProrateFlag").value = "2";
		$("accidentProrateFlag").removeClassName("required");
		$("accidentProrateFlag").disable();
		$("shortRateSelectedAccident").hide();
		$("prorateSelectedAccident").hide();*/
		//$("accidentNoOfDays").value = "";
		//$("accidentShortRatePercent").value = "";
		//$("accidentCompSw").selectedIndex = 2;
		$("noOfPerson").value = "";
		$("destination").value = "";
		$("monthlySalary").value = "";
		$("salaryGrade").value = "";
		$("positionCd").selectedIndex = 0;
		generateSequenceItemInfo("ben","beneficiaryNo","item",$F("itemNo"),"nextItemNoBen");
		checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
		//$("personalAdditionalInfoDetail").hide();
		//$("personalAdditionalInformationInfo").hide();
		//$("showPersonalAdditionalInfo").update("Show");
		disableButton("btnGroupedItems");
		enableButton("btnPersonalAddtlInfo");	
	
		$("hidDateOfBirth").value = "";
		$("hidAge").value = "";
		$("hidCivilStatus").value = "";
		$("hidSex").value = "";
		$("hidHeight").value = "";
		$("hidWeight").value = "";
		$("hidGroupPrintSw").value = "";
		$("hidAcClassCd").value = "";
		$("hidLevelCd").value = "";
		$("hidParentLevelCd").value = "";
		$("hidItemWitmperlExist").value = "";
		$("hidItemWitmperlGroupedExist").value = "";
		$("accidentFromDate").enable();
		$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('accidentFromDate'),this, null);");
		$("accidentToDate").enable();
		$("hrefAccidentToDate").setAttribute("onClick","scwShow($('accidentToDate'),this, null);");
		$("accidentPackBenCd").enable();
		$("hidPopulatePerils").value = "";
		$("hidItemWgroupedItemsExist").value = "";
		$("currency").enable();
	
		initAccident();
	}

function initAccident(){
	//$("region").addClassName("required");
	/*
	$("accidentPackBenCd").observe("change", function() {
		if ($F("accidentPackBenCd") != "" && $F("itemWgroupedItemsExist") == "Y"){
			showConfirmBox("Message", "There are existing grouped items and system will populate/overwrite perils on ALL grouped items. Would you like to automatically populate peils?",  
					"Yes", "No", onOkFunc, onCancelFunc);
		}	
	});	
	function onOkFunc(){
		$("populatePerils").value = "Y";
	}
	function onCancelFunc(){
		var temp = "";
		$$("div#itemTable div[name='row']").each(function(a){
			if (a.hasClassName("selectedRow")){
				temp = a.down("input",27).value;		
			}	
		});	
		if (temp != ""){
			$("accidentPackBenCd").value = temp;
		}
		$("populatePerils").value = "";
	}	*/

	var prorateFlagText = "";
	var compSw = "";
	var shortRatePercent = "";
	var accidentNoOfDays = "";
	var accidentNoOfDays2 = "";
	var accidentDaysOfTravel = "";
	var accidentToDate = "";
	var accidentFromDate = "";
	/*
	$("accidentCompSw").observe("focus", function() {
		compSw = $F("accidentCompSw");
	});	
	$("accidentCompSw").observe("change", function() {
		if (($("accidentCompSw").value == "M") && ($F("accidentFromDate") == $F("accidentToDate"))){
			$("accidentCompSw").value = compSw;
			showMessageBox("Tagging of -1 day will result to invalid no. of days. Changing is not allowed.", imgMessage.ERROR);
		}	
		if ($F("itemWitmperlExist") == "Y"){
			if (compSw != $F("accidentCompSw")){
				if ($F("accidentDeleteBill") != "Y"){
					showConfirmBox("Message", "You have changed the computation for the item no. of days. Will now do necessary changes.",  
							"Yes", "No", onOkFuncCompSw, onCancelFuncCompSw);
				}
			}	
		}
		function onOkFuncCompSw(){
			$("accidentDeleteBill").value = "Y";
			showRelatedSpan();
		}
		function onCancelFuncCompSw(){
			$("accidentCompSw").value = compSw;
			showRelatedSpan();
		}	
	});
	$("accidentNoOfDays").observe("focus", function() {
		accidentNoOfDays = $F("accidentNoOfDays");
		accidentDaysOfTravel = $F("accidentDaysOfTravel");
		accidentToDate = $F("accidentToDate");
	});
	$("accidentCompSw").observe("focus", function() {
		accidentNoOfDays2 = $F("accidentNoOfDays");
	});
	$("accidentNoOfDays").observe("blur", function() {
		$$("div#itemTable div[name='row']").each(function(row){
			if(row.hasClassName("selectedRow")){			
				accidentToDate    = row.down("input", 15).value;
			}	
		});
		if ($F("itemWitmperlExist") == "Y"){
			if ($F("accidentDeleteBill") != "Y"){
				if (accidentNoOfDays != $F("accidentNoOfDays") || accidentToDate != $F("accidentToDate")){
					showConfirmBox("Message", "You have updated policy's no. of days from "+ accidentNoOfDays +" to "+ $F("accidentNoOfDays") +". Will now do necessary changes.",  
							"Yes", "No", onOkFuncNoOfDays, onCancelFuncNoOfDays);
				}else{
					getNewExpiry();
				}	
			}else{
				getNewExpiry();
			}	
		}else{
			getNewExpiry();
		}	
		function onOkFuncNoOfDays(){
			$("accidentDeleteBill").value = "Y";
			var compSw = $F("accidentCompSw");
			var num = accidentNoOfDays2 == "" ? $F("accidentNoOfDays") :accidentNoOfDays2;
			if (compSw == "Y"){
				num = parseInt(num)-1;
			}else if (compSw == "M"){
				num = parseInt(num)+1;
			}else{
				num = parseInt(num);		
			}
			$("accidentDaysOfTravel").value = num;
			showRelatedSpan();
			getNewExpiry();
		}
		function onCancelFuncNoOfDays(){
			$("accidentNoOfDays").value = accidentNoOfDays;
			$("accidentDaysOfTravel").value = accidentDaysOfTravel;
			$("accidentToDate").value = accidentToDate;
			showRelatedSpan();
		}
		accidentNoOfDays2 = "";
	});

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
			showRelatedSpan();
		}
		function onCancelFuncDeleteBill(){
			$$("div#itemTable div[name='row']").each(function(row){
				if (row.hasClassName("selectedRow")){
					$("accidentProrateFlag").value = (row.down("input",24).value == "" ? "2" :row.down("input",24).value);
					$("accidentCompSw").value = row.down("input", 25).value;
					$("accidentShortRatePercent").value = row.down("input", 26).value == "" || row.down("input", 26).value == "NaN" ? "" :formatToNineDecimal(row.down("input", 26).value);
				}	
				showRelatedSpan();
			});
		}
		showRelatedSpan();
	});
	
	$("accidentProrateFlag").value = "2";
	showRelatedSpan();
	
	$("accidentCompSw").observe("blur", function() {
		if ($F("accidentCompSw") == "Y"){
			$("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) + 1;
		}else if ($F("accidentCompSw") == "M"){
			$("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) - 1;
		}else{
			$("accidentNoOfDays").value  = $F("accidentDaysOfTravel");
		}	
	});

	$("accidentShortRatePercent").observe("blur", function() {
		var accidentShortRatePercent = "";
		$$("div#itemTable div[name='row']").each(function(row){
			if(row.hasClassName("selectedRow")){			
				accidentShortRatePercent  = row.down("input", 26).value == "" ? "" :formatToNineDecimal(row.down("input", 26).value);
			}	
		});
		if ($F("itemWitmperlExist") == "Y"){
			if ($F("accidentDeleteBill") != "Y"){
				if (($F("accidentShortRatePercent")==""?"":formatToNineDecimal($F("accidentShortRatePercent"))) != accidentShortRatePercent){
						showConfirmBox("Message", "You have updated short rate percent from "+accidentShortRatePercent +"% to "+ ($F("accidentShortRatePercent")==""?"":formatToNineDecimal($F("accidentShortRatePercent"))) +"%. Will now do the necessary changes.",  
								"Yes", "No", onOkFunc, onCancelFunc);
				}else{
					validate();
				}	
			}else{
				validate();
			}
		}else{
			validate();
		}	
		function onOkFunc(){
			$("accidentDeleteBill").value = "Y";
			validate();
		}
		function onCancelFunc(){
			$("accidentShortRatePercent").value = accidentShortRatePercent == "" ? "" :formatToNineDecimal(accidentShortRatePercent);
		}
		function validate(){
			if (parseFloat($F("accidentShortRatePercent")) > 100 || parseFloat($F("accidentShortRatePercent")) <= 0 || isNaN(parseFloat($F("accidentShortRatePercent")))){
				showMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR);
				$("accidentShortRatePercent").value = "";
				return false;
			}
		}	
	});	*/

	$("accidentFromDate").observe("blur", function() {
		$$("div#itemTable div[name='row']").each(function(row){
			if(row.hasClassName("selectedRow")){			
				accidentFromDate  = row.down("input", 14).value;
				accidentToDate    = row.down("input", 15).value;
			}	
		});

		if ($F("hidItemWitmperlExist") == "Y"){
			if ($F("hidAccidentDeleteBill") != "Y"){
				if ($F("accidentFromDate") != accidentFromDate){
						showConfirmBox("Message", "You have updated policy's no. of days from "+ computeNoOfDays(accidentFromDate,accidentToDate,"") +" to "+ computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"") +". Will now do necessary changes.",  
								"Yes", "No", onOkFuncNoOfDays, onCancelFuncNoOfDays);
				}else{
					validate();
				}	
			}else{
				validate();
			}
		}else{
			validate();
		}	
		
		function onOkFuncNoOfDays(){
			$("hidAccidentDeleteBill").value = "Y";
			var compSw = $F("accidentCompSw");
			var num = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
			if (compSw == "Y"){
				num = parseInt(num)-1;
			}else if (compSw == "M"){
				num = parseInt(num)+1;
			}else{
				num = parseInt(num);		
			}
			$("accidentDaysOfTravel").value = num;
			//showRelatedSpan();
			getNewExpiry();
			validate();
		}
		function onCancelFuncNoOfDays(){
			$("accidentNoOfDays").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
			$("accidentDaysOfTravel").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
			$("accidentFromDate").value = accidentFromDate;
			//showRelatedSpan();
		}

		function validate(){
			id="globalInceptDate";
			var test = $F("globalInceptDate");
			var gInceptionDate = makeDate($F("globalInceptDate").substr(0,10));	//global inception -- expiry
			var gExpiryDate = makeDate($F("globalExpiryDate").substr(0,10));
			var fromDate = makeDate($F("accidentFromDate"));
			var toDate = makeDate($F("accidentToDate"));
			//var iDate = makeDate($F("wpolbasInceptDate"));
			//var eDate = makeDate($F("wpolbasExpiryDate"));
			if (fromDate > toDate){
				showMessageBox("Start of Effectivity date should not be later than the End of Effectivity date.", imgMessage.ERROR);
				$("accidentFromDate").value = "";
				$("accidentFromDate").focus();
				$("accidentDaysOfTravel").value = "";
			} else if (fromDate > gExpiryDate){
				showMessageBox("Start of Effectivity date should not be later than the Policy Expiry date "+$F("globalExpiryDate").substr(0,10)+".", imgMessage.ERROR);
				$("accidentFromDate").value = "";
				$("accidentFromDate").focus();
				$("accidentDaysOfTravel").value = "";
			} else if (fromDate < gInceptionDate){
				showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date."+$F("globalInceptDate").substr(0,10)+".", imgMessage.ERROR);
				$("accidentFromDate").value = "";
				$("accidentFromDate").focus();	
				$("accidentDaysOfTravel").value = "";
			} else{
				if ($F("accidentFromDate") != ""){
					$("accidentToDate").value = $F("globalExpiryDate").substr(0,10);
					$("accidentToDate").focus();
				}
				$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
			}
			/*showRelatedSpan();

			if ($F("accidentProrateFlag") == "2"){
				var fDateArray = $F("accidentFromDate").split("-");
				var fmonth = fDateArray[0];
				var fdate = fDateArray[1];
				var fyear = fDateArray[2];
				var tDateArray = $F("accidentToDate").split("-");
				var tmonth = tDateArray[0];
				var tdate = tDateArray[1];
				var tyear = tDateArray[2];
				
				if ((fmonth+"-"+fdate+"-"+(parseInt(fyear)+1)) == (tmonth+"-"+tdate+"-"+tyear)){
					$("accidentProrateFlag").disable();
				}
			}*/
		}	
	});
	 
	$("accidentToDate").observe("blur", function() {
		$$("div#itemTable div[name='row']").each(function(row){
			if(row.hasClassName("selectedRow")){			
				accidentFromDate  = row.down("input", 14).value;
				accidentToDate    = row.down("input", 15).value;
			}	
		});
			
		if ($F("hidItemWitmperlExist") == "Y"){
			if ($F("hiaAccidentDeleteBill") != "Y"){
				if ($F("accidentToDate") != accidentToDate){
						showConfirmBox("Message", "You have updated policy's no. of days from "+ computeNoOfDays(accidentFromDate,accidentToDate,"") +" to "+ computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"") +". Will now do necessary changes.",  
								"Yes", "No", onOkFuncNoOfDays, onCancelFuncNoOfDays);
				}else{
					validate();
				}	
			}else{
				validate();
			}
		}else{
			validate();
		}	
		function onOkFuncNoOfDays(){
			$("hidAccidentDeleteBill").value = "Y";
			var compSw = $F("accidentCompSw");
			var num = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
			if (compSw == "Y"){
				num = parseInt(num)-1;
			}else if (compSw == "M"){
				num = parseInt(num)+1;
			}else{
				num = parseInt(num);		
			}
			$("accidentDaysOfTravel").value = num;
			//showRelatedSpan();
			getNewExpiry();
			validate();
		}
		function onCancelFuncNoOfDays(){
			$("accidentNoOfDays").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
			$("accidentDaysOfTravel").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
			$("accidentToDate").value = accidentToDate;
			//showRelatedSpan();
		}

		function validate(){
			var gInceptionDate = makeDate($F("globalInceptDate").substr(0,10));	//global inception -- expiry
			var gExpiryDate = makeDate($F("globalExpiryDate").substr(0,10));
			var fromDate = makeDate($F("accidentFromDate"));
			var toDate = makeDate($F("accidentToDate"));
			if (toDate < fromDate){
				showMessageBox("End of Effectivity date should not be earlier than the Start of Effectivity date.", imgMessage.ERROR);
				$("accidentToDate").value = "";
				$("accidentToDate").focus();	
				$("accidentDaysOfTravel").value = "";			
			} else if (toDate > gExpiryDate){
				showMessageBox("End of Effectivity date should not be later than the Policy Expiry date."+$F("globalExpiryDate").substr(0,10)+".", imgMessage.ERROR);
				$("accidentToDate").value = "";
				$("accidentToDate").focus();
				$("accidentDaysOfTravel").value = "";
			} else if (toDate < gInceptionDate){
				showMessageBox("End of Effectivity date should not be earlier than the Policy inception date."+$F("globalInceptDate").substr(0,10)+".", imgMessage.ERROR);
				$("accidentToDate").value = "";
				$("accidentToDate").focus();
				$("accidentDaysOfTravel").value = "";
			} else{
				$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
			}
			
			/*showRelatedSpan();
			
			if ($F("accidentProrateFlag") == "2"){
				var fDateArray = $F("accidentFromDate").split("-");
				var fmonth = fDateArray[0];
				var fdate = fDateArray[1];
				var fyear = fDateArray[2];
				var tDateArray = $F("accidentToDate").split("-");
				var tmonth = tDateArray[0];
				var tdate = tDateArray[1];
				var tyear = tDateArray[2];
				
				if ((fmonth+"-"+fdate+"-"+(parseInt(fyear)+1)) == (tmonth+"-"+tdate+"-"+tyear)){
					$("accidentProrateFlag").disable();
				}
			}*/
		}
	});	
}

function createRecord() {
	var result = true;

	if ($F("paramPolFlagSw") == "N") {
		if ($F("varDiscExist") == "Y") {
			showConfirmBox("Add New Item", "Adding new item will result to the deletion of all discounts. Do you want to continue ?", "Yes", "No",
			 function() {
				$("varDiscExist").value = "N";
				saveItem();
			 },
			 "");
		} else {
			saveItem();
		}
	} else {
		saveItem();
	}

	//update later for form status changed

	return result;
}

// save item
function saveItem() {		
	var parId			= $F("globalParId");
	var itemNo 			= $F("itemNo");
	var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
	var regionCd 		= $F("region");
	var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
	var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
	var currency		= $F("currency");
	var currencyText 	= $("currency").options[$("currency").selectedIndex].text;
	var rate 			= $F("rate");
	var coverage 		= $F("coverage");
	var coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
	var content			= "";		

	var result = true;

	if($F("itemNo").blank()){
		showMessageBox("Item Number is required!", imgMessage.ERROR);						
		return false;
	} else if(currency.blank() || "0.000000000" == rate){
		showMessageBox("Currency rate is required!", imgMessage.ERROR);
		return false;
	} else if(rate.match("-")) {
		showMessageBox("Invalid currency rate!", imgMessage.ERROR);
		return false;
	}  else if(itemTitle.blank()) {
		showMessageBox("Please enter the item title first.", imgMessage.ERROR);
		return false;
	}
	
	if($F("globalLineCd") == "AH"){
		if ($("region").value == "" ){
			showMessageBox("Region is required!", imgMessage.ERROR);						
			return false;
		}else if ($F("noOfPerson").blank() && $F("positionCd").blank() && $F("destination").blank() && ($F("monthlySalary").blank() || $F("monthlySalary")== "0.00") && $F("salaryGrade").blank()){
			showMessageBox("Please complete the additional accident information before adding an item.", imgMessage.ERROR);						
			return false;
		}	
	}
		
	new Ajax.Request(contextPath +"/GIPIWAccidentItemController?action=preInsertEndtAccident", {
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
			currencyCd 	: $("currency").value,
			effDate 	: $F("globalEffDate").substring(0, 10)
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : function (){
			//showNotice("Validating item...");
		},
		
		onComplete : function(response){
			//0 condition, 1 ann tsi amt, 2 prem amt, 3 currency cd, restricted condition2 4
			var a = response.responseText.split(",");
			
			if (a[0] == "1"){
				$("currency").value = a[3] == "null"? 1: a[14];
				getRates();
				showWaitingMessageBox("The currency used by item number "+$F("itemNo")+" does not cohere "
						+"with the currency used by the policy being endorsed. Will now do the necessary "
	                    +"changes.", "error", saveItem2);
			} else if(a[0] == "2"){
				$("annTsiAmt").value = a[1] == "null"? "": a[1];
				$("annPremAmt").value = a[2] == "null"? "": a[2];

				if(a[4] == "Y"){
					$("currency").value = a[3] == "null"? 1: a[14];
					getRates();
					showWaitingMessageBox("The currency used by item number "+$F("itemNo")+" does not cohere "
							+"with the currency used by the policy being endorsed. Will now do the necessary "
		                    +"changes.", "error", saveItem2);
				}
			} 
		}
	});
	saveItem2();
	/*
	if (!result) {
		 return false;
	} else {
		content = 	'<label style="width: 5%; text-align: right; margin-right: 10px;">'+itemNo+'</label>' +						
					'<label style="width: 20%; text-align: left;" title="'+itemTitle+'">'+(itemTitle == "" ? "-" : itemTitle.truncate(20, "..."))+'</label>'+
					'<label style="width: 20%; text-align: left;" title="'+itemDesc+'">'+(itemDesc == "" ? "-" : itemDesc.truncate(20, "..."))+'</label>' +
					'<label style="width: 20%; text-align: left;" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "-" : itemDesc2.truncate(20, "..."))+'</label>' +
					'<label style="width: 10%; text-align: left;" title="'+currencyText+'">'+currencyText.truncate(12, "...")+'</label>' +
					'<label style="width: 10%; text-align: right; margin-right: 10px;">'+formatToNineDecimal(rate)+'</label>' +
					'<label style="text-align: left;" title="'+coverageText+'">'+coverageText.truncate(15, "...")+'</label>';

		if($F("btnSaveItem") == "Update"){	
			$("row"+itemNo).update(						
				generateAdditionalItems() + content);
			
			setDefaultValues();
		} else {
			if ($F("paramPolFlagSw") != "N") {
				showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
				return false;
			}
			checkTableIfEmpty("row", "itemTable");
			var itemTable = $("parItemTableContainer");
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "row"+itemNo);
			newDiv.setAttribute("name", "row");
			newDiv.addClassName("tableRow");
			newDiv.update(						
				generateAdditionalItems() + content);
			itemTable.insert({bottom : newDiv});
			
			setDefaultValues();
			
			newDiv.observe("mouseover",
				function(){
					newDiv.addClassName("lightblue");
			});

			newDiv.observe("mouseout",
				function(){
					newDiv.removeClassName("lightblue");
			});

			newDiv.observe("click",
				function(){
					clickParItemRow(newDiv);
			});
		}
		checkTableItemInfo("itemTable","parItemTableContainer","row");									
		checkTableIfEmpty("row", "itemTable");
	}*/

}

function saveItem2(){
	var parId			= $F("globalParId");
	var itemNo 			= $F("itemNo");
	var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
	var region 			= $F("region");
	var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
	var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
	var currency		= $F("currency");
	var currencyText 	= $("currency").options[$("currency").selectedIndex].text;
	var rate 			= $F("rate");
	var coverage 		= $F("coverage");
	var coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
	var content			= "";
	content = 	'<label style="width: 5%; text-align: right; margin-right: 10px;">'+itemNo+'</label>' +						
			'<label style="width: 20%; text-align: left;" title="'+itemTitle+'">'+(itemTitle == "" ? "---" : itemTitle.truncate(20, "..."))+'</label>'+
			'<label style="width: 20%; text-align: left;" title="'+itemDesc+'">'+(itemDesc == "" ? "---" : itemDesc.truncate(20, "..."))+'</label>' +
			'<label style="width: 20%; text-align: left;" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "---" : itemDesc2.truncate(20, "..."))+'</label>' +
			'<label style="width: 10%; text-align: left;" title="'+currencyText+'">'+currencyText.truncate(12, "...")+'</label>' +
			'<label style="width: 10%; text-align: right; margin-right: 10px;">'+formatToNineDecimal(rate)+'</label>' +
			'<label style="text-align: left;" title="'+coverageText+'">'+coverageText.truncate(15, "...")+'</label>';
	
	if($F("btnSaveItem") == "Update"){	
		$("row"+itemNo).update(						
			generateAdditionalItems() + content);
		
		setDefaultValues();
	} else {
		if ($F("paramPolFlagSw") != "N") {
			showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
			return false;
		}
		
		var itemTable = $("parItemTableContainer");
		var newDiv = new Element("div");
		newDiv.setAttribute("id", "row"+itemNo);
		newDiv.setAttribute("name", "row");
		newDiv.addClassName("tableRow");
		newDiv.update(						
			generateAdditionalItems() + content);
		itemTable.insert({bottom : newDiv});
		
		setDefaultValues();
		
		newDiv.observe("mouseover",
			function(){
				newDiv.addClassName("lightblue");
		});
		
		newDiv.observe("mouseout",
			function(){
				newDiv.removeClassName("lightblue");
		});
		
		newDiv.observe("click", function(){
			clickParItemRow(newDiv);
		});
	}
	checkTableItemInfo("itemTable","parItemTableContainer","row");
	checkTableIfEmpty("row", "parItemTableContainer");

}

//delete item record
function deleteRecord() {
	setCursor("wait");
	if ("Y" == $F("varDiscExist")){
		showConfirmBox("Discount", "Deleting an item will result to the deletion of all discounts. Do you want to continue ?",
				"Continue", "Cancel", deleteRecord2, "");
	} else {
		deleteRecord2();
	}
	//checkGIPIWItem();			
	setCursor("default");
}

function deleteRecord2() {
	//checkGIPIWItem();			
	if($F("tempVariable") == "1"){
		$("tempVariable").value = "0";
		return false;
	}			
	if ($F("noOfPerson") > 1){
		removeObjGroupedItems();
	}
	$$("div#itemTable div[name='row']").each(
		function(row){
			if(row.hasClassName("selectedRow")){
				Effect.Fade(row,{
					duration : .2,
					afterFinish :
						function(){
							//checkIfToResizeTable("row", "itemTable");
							checkTableItemInfo("itemTable","parItemTableContainer","row");									
							checkTableIfEmpty("row", "itemTable");
							var parId	= $F("globalParId");
							var itemNo	= $F("itemNo");
							var itemTable = $("parItemTableContainer");
							var newDiv = new Element("div");
							
							$("deleteItemNumbers").value = $F("deleteItemNumbers") + itemNo + " ";
							
							newDiv.setAttribute("id", "row"+itemNo);
							newDiv.setAttribute("name", "rowDelete");
							newDiv.addClassName("tableRow");
							newDiv.setStyle("display : none");
							newDiv.update(
								'<input type="hidden" name="delParIds" 	value="'+parId+'" />' +
								'<input type="hidden" name="delItemNos" value="'+itemNo+'" />');
							itemTable.insert({bottom : newDiv});
																						
							row.remove();
							updateTempNumbers();
							supplyItemInfo(false, row, itemNo);
							setDefaultValues();
							disableWItemButtons();
							
							if ($("currency").readOnly) {
								$("currency").readOnly = false;
							}
							
							$("itemNo").readOnly = false;
							$("itemNo").focus();
							
							setRecordListPerItem(false);
							removeAllRowListing(); //removed because of 'tableRow not existing' problem
							setDefaultValues();
							checkTableItemInfo("itemTable","parItemTableContainer","row");							
							$("wItemParCount").value = parseInt($F("wItemParCount")) - 1;
							//checkItemCount();
							$("changedFields").value = parseInt($F("changedFields")) + 1;
						}
				});
			}
		});
}

function removeObjGroupedItems(){
	for (var i = 0; i < objGipiwGroupedItemsList.length; i++){
		if (objGipiwGroupedItemsList[i].itemNo == $F("itemNo")){
			objGipiwGroupedItemsList[i].recordStatus = -1;
		}
	}

	for (var i = 0; i < objGipiwCoverageItems.length; i++){
		if (objGipiwCoverageItems[i].itemNo == $F("itemNo")){
			objGipiwCoverageItems[i].recordStatus = -1;
		}
	}

	for (var i = 0; i < objGipiwGroupedBenItems.length; i++){
		if (objGipiwGroupedBenItems[i].itemNo == $F("itemNo")){
			objGipiwGroupedBenItems[i].recordStatus = -1;
		}
	}

	for (var i = 0; i < objGipiwGroupedBenPerils.length; i++){
		if (objGipiwGroupedBenPerils[i].itemNo == $F("itemNo")){
			objGipiwGroupedBenPerils[i].recordStatus = -1;
		}
	}
}

function whenNewRecordInstance() {
	var result = true;

	if ($F("globalLineCd") == "MC") {
		if ($F("recFlag") != "A") {
			$("motorType").removeClassName("required");
			$("sublineType").removeClassName("required");
		} else {
			$("motorType").addClassName("required");
			$("sublineType").addClassName("required");
		}

		if ($F("packPolFlag") == "Y" && $F("btnSaveItem") == "Add") {
			if (confirm("You are not allowed to create items here. " +
					" Create a new item in module Package Policy Item Data Entry - Policy ?")) {
				//go to module GIPIS096 here
				return false;
			} else {
				return false;
			}
		} else if ($F("packPolFlag") == "Y" && $F("btnSaveItem") == "Update") {
			showNotice("Updating lists, please wait...");
			$("unladenWt").value = "";
			updateLOV("motorType", "motorTypeListSize", "motorTypeCd", "motorTypeDesc", 
					contextPath + "/GIPIParMCItemInformationController?action=updateMotorTypeList&packSublineCd="+$F("packSublineCd"), 
					"itemInformationForm", updateUnladenWt);

			updateLOV("sublineType", "sublineTypeListSize", "sublineTypeCd", "sublineTypeDesc", 
					contextPath + "/GIPIParMCItemInformationController?action=updateSublineTypeList&packSublineCd="+$F("packSublineCd"), 
					"itemInformationForm", null);
		}
	}

	return result;
}

function generateAdditionalItems(){
	try {
		var lineCd			= $F("globalLineCd");
		var sublineCd		= $F("sublineCd") /* $F("globalSublineCd") */;
		var parId 			= $F("globalParId");
		var itemNo 			= $F("itemNo");
		var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
		var itemGrp 		= $F("itemGrp");
		var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
		var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
		var tsiAmt 			= ""; //($("tsiAmt").value != "" ? $("tsiAmt").value : "0.00"); //"0.00";
		var premAmt 		= ""; //($("premAmt").value != "" ? $("premAmt").value : "0.00"); //"0.00";
		var annPremAmt 		= ""; //($("annPremAmt").value != "" ? $("annPremAmt").value : "0.00"); //"0.00";
		var annTsiAmt 		= ""; //($("annTsiAmt").value !="" ? $("annTsiAmt").value : "0.00"); //"0.00";
		var recFlag 		= ($F("recFlag") == "" ? 'A' : $F("recFlag"));
		var currencyCd 		= $F("currency");
		var currencyRt 		= $F("rate");
		var groupCd 		= $F("groupCd");
		var fromDate 		= (lineCd == "AH") ? $F("accidentFromDate") : $F("fromDate");
		var toDate 			= (lineCd == "AH") ? $F("accidentToDate") : $F("toDate");
		var packLineCd 		= ($F("packLineCd") == null) ? null :  $F("packLineCd");
		var packSublineCd 	= ($F("packSublineCd") == null) ? null : $F("packSublineCd");
		var discountSw 		= "";
		var coverageCd 		= (lineCd != "MN" ? $F("coverage") : "");
		var otherInfo 		= changeSingleAndDoubleQuotes2($F("otherInfo"));
		var surchargeSw 	= "";
		var regionCd 		= $F("region");
		var changedTag 		= "";
		var prorateFlag 	= "";
		var compSw 			= "";
		var shortRtPercent 	= "0.00";//$("shortRtPercent").value; //"0.00";
		var packBenCd 		= (lineCd == "AH") ? $F("accidentPackBenCd") : "";
		var paytTerms 		= (lineCd == "AH") ? $F("accidentPaytTerms") : ""; 
		var riskNo 			= (lineCd == "FI") ? $F("riskNo") : "";
		var riskItemNo 		= (lineCd == "FI") ? $F("riskItemNo") : "";
		var itemArray = '';
		
		itemArray = 
			//'<input type="hidden" name="itemLineCds" 			value="'+ lineCd +'" />' +
			//'<input type="hidden" name="itemSublineCds" 		value="'+ sublineCd +'" />' +
			'<input type="hidden" name="itemParIds" 			value="'+ parId +'" />' +
			'<input type="hidden" name="itemItemNos" 			value="'+ itemNo +'" />' +
			'<input type="hidden" name="itemItemTitles" 		value="'+ itemTitle +'" />' +
			'<input type="hidden" name="itemItemGrps" 			value="'+ itemGrp +'" />' +
			'<input type="hidden" name="itemItemDescs" 			value="'+ itemDesc +'" />' +
			'<input type="hidden" name="itemItemDesc2s" 		value="'+ itemDesc2 +'" />' +
			'<input type="hidden" name="itemTsiAmts" 			value="'+ tsiAmt +'" />' +
			'<input type="hidden" name="itemPremAmts" 			value="'+ premAmt +'" />' +
			'<input type="hidden" name="itemAnnPremAmts" 		value="'+ annPremAmt +'" />' +
			'<input type="hidden" name="itemAnnTsiAmts" 		value="'+ annTsiAmt +'" />' +
			'<input type="hidden" name="itemRecFlags" 			value="'+ recFlag +'" />' +
			'<input type="hidden" name="itemCurrencyCds" 		value="'+ currencyCd +'" />' +
			'<input type="hidden" name="itemCurrencyRts" 		value="'+ formatToNineDecimal(currencyRt) +'" />' +
			'<input type="hidden" name="itemGroupCds" 			value="'+ groupCd +'" />' +
			'<input type="hidden" name="itemFromDates" 			value="'+ fromDate +'" />' +
			'<input type="hidden" name="itemToDates" 			value="'+ toDate +'" />' +
			'<input type="hidden" name="itemPackLineCds" 		value="'+ packLineCd +'" />' +
			'<input type="hidden" name="itemPackSublineCds" 	value="'+ packSublineCd +'" />' +
			'<input type="hidden" name="itemDiscountSws" 		value="'+ discountSw +'" />' +
			'<input type="hidden" name="itemCoverageCds" 		value="'+ coverageCd +'" />' +
			'<input type="hidden" name="itemOtherInfos" 		value="'+ otherInfo +'" />' +
			'<input type="hidden" name="itemSurchargeSws" 		value="'+ surchargeSw +'" />' +
			'<input type="hidden" name="itemRegionCds" 			value="'+ regionCd +'" />' +
			'<input type="hidden" name="itemChangedTags" 		value="'+ changedTag +'" />' +
			'<input type="hidden" name="itemProrateFlags"		value="'+ prorateFlag +'" />' +
			'<input type="hidden" name="itemCompSws" 			value="'+ compSw +'" />' +
			'<input type="hidden" name="itemShortRtPercents" 	value="'+ shortRtPercent +'" />' +
			'<input type="hidden" name="itemPackBenCds" 		value="'+ packBenCd +'" />' +
			'<input type="hidden" name="itemPaytTermss" 		value="'+ paytTerms +'" />' +
			'<input type="hidden" name="itemRiskNos" 			value="'+ riskNo +'" />' +
			'<input type="hidden" name="itemRiskItemNos" 		value="'+ riskItemNo +'" />';

		if(lineCd == "AH"){
			var noOfPerson 				= $F("noOfPerson");
			var destination 			= changeSingleAndDoubleQuotes2($F("destination"));
			var monthlySalary 			= $F("monthlySalary") == "" ? "": $F("monthlySalary");
			var salaryGrade 			= changeSingleAndDoubleQuotes2($F("salaryGrade"));
			var positionCd 				= $F("positionCd");
			var delGrpItem				= $F("deleteGroupedItemsInItem");

			/*
			var dateOfBirth  			= $F("hidDateOfBirth");
			var age 					= $F("hidAge");
			var civilStatus 			= $F("hidCivilStatus");
			var sex 					= $F("hidSex");
			var height 					= $F("hidHeight");
			var weight 					= $F("hidWeight");
			*/

			var dateOfBirth				= $("pDateOfBirth") == null ? $F("hidDateOfBirth") : $F("pDateOfBirth");
			var age						= $("pAge") == null ? $F("hidAge") : $F("pAge");
			var civilStatus				= $("pCivilStatus") == null ? $F("hidCivilStatus") : $F("pCivilStatus");
			var sex						= $("pSex") == null ? $F("hidSex") : $F("pSex");
			var height					= $("pHeight") == null ? $F("hidHeight") : $F("pHeight");
			var weight					= $("pWeight") == null ? $F("hidWeight") : $F("pWeight");
			
			var groupPrintSw			= $F("hidGroupPrintSw");
			var acClassCd				= $F("hidAcClassCd");
			var levelCd					= $F("hidLevelCd");
			var parentLevelCd			= $F("hidParentLevelCd");
			var itemWitmperlExist 		= $F("hidItemWitmperlExist");	
			var itemWitmperlGroupedExist = $F("hidItemWitmperlGroupedExist");
			var populatePerils			= $F("hidPopulatePerils");
			var itemWgroupedItemsExist  = $F("hidItemWgroupedItemsExist");
			var accidentDeleteBill		= $F("hidAccidentDeleteBill");

			itemArray = itemArray + 
				'<input type="hidden" name="noOfPersons" 			value="'+noOfPerson+'" />' +
				'<input type="hidden" name="destinations" 			value="'+destination+'" />' +
				'<input type="hidden" name="monthlySalarys" 		value="'+monthlySalary+'" />' +
				'<input type="hidden" name="salaryGrades" 			value="'+salaryGrade+'" />' +
				'<input type="hidden" name="positionCds" 			value="'+positionCd+'" />'+
				'<input type="hidden" name="delGrpItemsInItems" 	value="'+delGrpItem+'" />'+
				'<input type="hidden" name="dateOfBirths" 			value="'+dateOfBirth+'" />'+
				'<input type="hidden" name="ages" 					value="'+age+'" />'+
				'<input type="hidden" name="civilStatuss" 			value="'+civilStatus+'" />'+
				'<input type="hidden" name="sexs" 					value="'+sex+'" />'+
				'<input type="hidden" name="heights" 				value="'+height+'" />'+
				'<input type="hidden" name="weights" 				value="'+weight+'" />'+
				'<input type="hidden" name="groupPrintSws" 			value="'+groupPrintSw+'" />'+
				'<input type="hidden" name="acClassCds" 			value="'+acClassCd+'" />'+
				'<input type="hidden" name="levelCds" 				value="'+levelCd+'" />'+
				'<input type="hidden" name="parentLevelCds" 		value="'+parentLevelCd+'" />'+
				'<input type="hidden" name="itemWitmperlExists" 	value="'+itemWitmperlExist+'" />'+
				'<input type="hidden" name="itemWitmperlGroupedExists" 	value="'+itemWitmperlGroupedExist+'" />'+
				'<input type="hidden" name="populatePerilss" 			value="'+populatePerils+'" />'+
				'<input type="hidden" name="itemWgroupedItemsExists"    value="'+itemWgroupedItemsExist+'" />'+
				'<input type="hidden" name="accidentDeleteBills"    	value="'+accidentDeleteBill+'" />';
			
		} 
		return itemArray;
	} catch (e) {
		showErrorMessage("generateAdditionalItems", e);
		//showMessageBox("testing generateAdditionalItems... : " + e.message);
	}
}

function enableWItemButtons() {
	$$("input[name='btnWItem']").each(function(btn) {
		enableButton(btn.id);
	});
	$("btnSaveItem").value = "Update";
	enableButton($("btnDelete"));

	$("includeSw").disabled = false;
}

function disableWItemButtons() {
	$$("input[name='btnWItem']").each(function(btn) {
		disableButton(btn.id);
	});
	$("btnSaveItem").value = "Add";
	disableButton($("btnDelete"));

	$("includeSw").disabled = true;
}

/*
function showRelatedSpan(){
	if ($F("accidentFromDate") == "" || $F("accidentToDate") == ""){
		$("accidentProrateFlag").disable();
		$("accidentShortRatePercent").value = "";
		$("accidentNoOfDays").value = "";
		$("accidentShortRatePercent").disable();
		$("accidentNoOfDays").disable();
		$("accidentCompSw").disable();
		$("accidentProrateFlag").removeClassName("required");
		$("accidentShortRatePercent").removeClassName("required");
		$("accidentNoOfDays").removeClassName("required");
		$("accidentCompSw").removeClassName("required");
	}else{
		$("accidentProrateFlag").enable();
		$("accidentShortRatePercent").enable();
		$("accidentNoOfDays").enable();
		$("accidentCompSw").enable();
		$("accidentProrateFlag").addClassName("required");
		$("accidentShortRatePercent").addClassName("required");
		$("accidentNoOfDays").addClassName("required");
		$("accidentCompSw").addClassName("required");
		if ($F("accidentProrateFlag") == "1")	{
			$("shortRateSelectedAccident").hide();
			$("prorateSelectedAccident").show();
			if ($F("accidentCompSw") == "Y"){
				$("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) + 1;
			}else if ($F("accidentCompSw") == "M"){
				$("accidentNoOfDays").value  = parseInt($F("accidentDaysOfTravel")) - 1;
			}else{
				$("accidentNoOfDays").value  = $F("accidentDaysOfTravel");
			}	
		} else if ($F("accidentProrateFlag") == "3") {			
			$("prorateSelectedAccident").hide();
			$("shortRateSelectedAccident").show();
			$("accidentNoOfDays").value = "";
		} else {			
			$("shortRateSelectedAccident").hide();
			$("prorateSelectedAccident").hide();
			$("accidentNoOfDays").value = "";
			$("accidentShortRatePercent").value = "";
			$("accidentCompSw").selectedIndex = 2;
		}
	}		
}*/

$("currency").observe("change", function() {
	var lastIndex = $F("currencyListIndex");
	
	if (!$F("itemNo").blank()) {
		//if (/*!validateCurrency()*/0 < parseInt($F("noOfItemperils")) || $("noOfItemperils") == null) {
			/*
			showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
			$("currency").selectedIndex = lastIndex;
			return false;
			*/
			if ($("itemWitmperlExists") != null){
				showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
				$("currency").selectedIndex = lastIndex;
				return false;
			}
		//}
	} else {
		showMessageBox("Item number is required before changing the currency.", imgMessage.INFO);
		$("currency").selectedIndex = lastIndex;
		return false;
	}

	//pre-text-item
	/*if (itemPerilExists()){
		showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
		$("currency").selectedIndex = lastIndex;
		return false;
	} else*/ if ((0 != parseFloat($F("annTsiAmt") == "" ? "0" : $F("annTsiAmt"))) && (null == $F("annTsiAmt"))){ 
		showMessageBox("Currency cannot be updated, item is being endorsed.", imgMessage.INFO);
		$("currency").selectedIndex = lastIndex;
		return false;
	} else {
		$("varGroupSw").value = "Y";
		getRates();
	}
});

//B480.CURRENCY_RT - pre_text_item, post_text_item
$("rate").observe("change", function() {

	lastRate = $F("lastRateValue");

	//if (/*itemPerilExists()*/0 < parseInt($F("noOfItemperils")) || $("noOfItemperils") == null){
	/*
		if ($F("vAllowUpdateCurrRate") == "Y") {
			showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
			$("rate").value = lastRate;
			$("itemNo").focus();
			return false;
		}
		*/
	//}
	
	if ($("itemWitmperlExists") != null){
		showMessageBox("Currency cannot be updated, item has peril/s already.", imgMessage.INFO);
		$("rate").value = lastRate;
		$("itemNo").focus();
		return false;
	}
	
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

function clearPopupFields(){
	
	if(!($("deductibleDiv2").empty())){
		$("inputDeductible2").value = "";
		$("inputDeductibleAmount2").value = "0.00";
		$("deductibleRate2").value = "0.000000000";
		$("deductibleText2").value = "";
		$("aggregateSw2").checked = false;

		disableButton("btnDeleteDeductible2");
		$("btnAddDeductible2").value = "Add";
	} 
	if ($F("globalLineCd") == "AH"){
		if (!($("beneficiaryInformationInfo").empty())){
			$$("div[name='ben']").each(function (div) {
				div.removeClassName("selectedRow");
			});
			checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
		}
	}	
		
// commented out for now to prevent null warning... uncomment mo to angelo pag asa perils ka na. - irwin	
	if($("itemPerilFormDiv") != null){
		$("perilCd").value = "";
		//$("perilRate").value = "0";
		//$("perilTsiAmt").value = "0.00";
		//$("premiumAmt").value = "0.00";
		//$("compRem").value = "";

		disableButton("btnDeletePeril");
		$("btnAddPeril").value = "Add Peril";
		
		//disableButton("btnDeletePeril");
		//$("btnAddItemPeril").value = "Add";


		if(!($("deductibleDiv3").empty())){
			$("inputDeductible3").value = "";
			$("inputDeductibleAmount3").value = "0.00";
			$("deductibleRate3").value = "0.000000000";
			$("deductibleText3").value = "";
			$("aggregateSw3").checked = false;

			disableButton("btnDeleteDeductible3");
			$("btnAddDeductible3").value = "Add";
		}
	} 	
}

/*********************************************/
/*	         ITEM SIDE BUTTONS               */
/*********************************************/

//COPY_ITEM_BTN - when_button_pressed
$("btnCopyItemInfo").observe("click", function() {
	if ($F("recFlag") != "A"){
		showMessageBox("Copy Item facility is only available for additional item.", imgMessage.INFO);
		return false;
	}
	
	if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
		loadDeductibleTables();
	}

	if($$("div#deductiblesTable2 div[name='ded2']").size() > 0){
		showConfirmBox("Deductibles", "The PAR has existing item level deductible/s based on % of TSI. " + 
				"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
				"Continue?", "Yes", "No", confirmCopyItem, stopProcess);
	} else {
		confirmCopyItem();
	}

	/*
	if ($F("itemNo").blank()) {
		showMessageBox("Please enter item number first.", imgMessage.ERROR);
		return false;
	} else if (parseInt($F("changedFields")) > 0 || $$("input[name='delItemNos']").size() > 0) {
		showMessageBox("Please save changes first before pressing the COPY ITEM button.", imgMessage.INFO);
		return false;
	} else {
		copyItemProcedure("ITEM");
	}
	*/
});

function confirmCopyItem(){
	if ($F("varDiscExist") == "Y"){
		showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
				"Yes", "No",
				function (){
					$("varDiscExist").value = "N";
					continueCopyItem();
				}, 
				stopProcess);
	} else {
		continueCopyItem();
	}
}

function continueCopyItem(){
	var nextItem = getNextItemNo("itemTable", "row", "label", 0);
	var includeMsg = "";

	if ($("includeSw").checked == true){
		includeMsg = "(including additional information)";
	} else {
		includeMsg = "(excluding additional information)";
	}
	
	showConfirmBox("Copy Item", "This will create new item (" + nextItem.toPaddedString(3) + ") with the same item information " + includeMsg + " as the current item display. Do you want to continue?",
			"Yes", "No",
			copySelectedItem,
			stopProcess);
}

function copySelectedItem(){
	$("copyProcess").value = "Y";	
	$("varVCopyItem").value = $F("itemNo");
	$("varPost2").value = "N";
	$("recFlag").value = "A";
	
	var parId 			= $F("globalParId");
	var itemNo			= $F("itemNo");
	var newItemNo		= getNextItemNo("itemTable", "row", "label", 0);
	var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
	var regionCd 		= ($F("globalLineCd") == "FI") ? "regionCd" : getListTextValue("region");
	var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
	var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
	var currency		= $F("currency");
	var currencyText 	= $("currency").options[$("currency").selectedIndex].text;
	var rate 			= $F("rate");
	var coverage 		= $F("coverage");
	var coverageText 	= $("coverage").options[$("coverage").selectedIndex].text == "" ? "---" : $("coverage").options[$("coverage").selectedIndex].text;
	var content			= "";

	$("itemNo").value = newItemNo;

	if ($("includeSw").checked == true){
		if ($F("noOfPerson") == 1){
			copyPersonalAddInfo(itemNo);
		} else {
			copyGroupedItemsInfo(itemNo);
		}
	}
	
	content = 	'<label style="width: 5%; text-align: right; margin-right: 10px;">'+newItemNo+'</label>' +						
				'<label style="width: 20%; text-align: left;" name="textItem" title="'+itemTitle+'">'+(itemTitle == "" ? "---" : itemTitle.truncate(20, "..."))+'</label>'+
				'<label style="width: 20%; text-align: left;" name="textItem" title="'+itemDesc+'">'+(itemDesc == "" ? "---" : itemDesc.truncate(20, "..."))+'</label>' +
				'<label style="width: 20%; text-align: left;" name="textItem" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "---" : itemDesc2.truncate(20, "..."))+'</label>' +
				'<label style="width: 10%; text-align: left;" name="textItem" title="'+currencyText+'">'+currencyText.truncate(15, "...")+'</label>' +
				'<label style="width: 10%; text-align: right; margin-right: 10px;">'+formatToNineDecimal(rate)+'</label>' +
				'<label style="text-align: left;" title="'+coverageText+'">'+coverageText.truncate(15, "...")+'</label>';
	
	var itemTable = $("parItemTableContainer");
	var newDiv = new Element("div");
	newDiv.setAttribute("id", "row"+newItemNo);
	newDiv.setAttribute("name", "row");
	newDiv.addClassName("tableRow");
	newDiv.update(generateAdditionalItems() + content);
	itemTable.insert({bottom : newDiv});

	setDefaultValues();
	newDiv.observe("mouseover",
		function(){
			newDiv.addClassName("lightblue");
	});
	newDiv.observe("mouseout",
		function(){
			newDiv.removeClassName("lightblue");
	});
	newDiv.observe("click", function(){
		clickParItemRow(newDiv);
	});

	if ($F("copyPeril") == "Y"){
		copyPerilInformation(newItemNo);
	} 
	
	trimTextItems();
	checkTableItemInfo("itemTable","parItemTableContainer","row");
	checkTableIfEmpty("row", "parItemTableContainer");

	$("invoiceSw").value = "Y";
	$("varCopyItemTag").value = "Y";
	$("varPost2").value = "Y";
	$("copyProcess").value = "Y";

	showMessageBox("Item No. "+(parseFloat(itemNo)).toPaddedString(3)+" sucessfully copied to Item No. "
            + (parseFloat(newItemNo)).toPaddedString(3)+". Will now go to Item No. "+(parseFloat(newItemNo)).toPaddedString(3)+".", imgMessage.SUCCESS);

	//newDiv.addClassName("selectedRow");
	clickParItemRow(newDiv);
}

function copyPersonalAddInfo(itemNo){
	for (var x = 0; x < objAccidentItems.length; x++){
		if (objAccidentItems[x].itemNo == itemNo){
			$("hidDateOfBirth").value = objAccidentItems[x].dateOfBirth;
			$("hidAge").value = objAccidentItems[x].age;
			$("hidCivilStatus").value = objAccidentItems[x].civilStatus;
			$("hidSex").value = objAccidentItems[x].sex;
			$("hidHeight").value = objAccidentItems[x].height;
			$("hidWeight").value = objAccidentItems[x].weight;

			$("hidGroupPrintSw").value = objAccidentItems[x].groupPrintSw;
			$("hidAcClassCd").value = objAccidentItems[x].acClassCd;
			$("hidLevelCd").value = objAccidentItems[x].levelCd;
			$("hidParentLevelCd").value = objAccidentItems[x].parentLevelCd;
		}
	}
}

function copyGroupedItemsInfo(itemNo){
	var objArray = [objGipiwGroupedItemsList, objGipiwCoverageItems,
	            	objGipiwGroupedBenItems, objGipiwGroupedBenPerils];
	
	for (var x = 0; x < objArray.length; x++){
		copyAndInsertNewObject(objArray[x], itemNo);
	}

}

function copyAndInsertNewObject(obj, itemNo){
	for (var i = 0; i < obj.length; i++){
		if (obj[i].itemNo == itemNo){
			var newGrpItems = JSON.parse(JSON.stringify(obj[i]));
			newGrpItems.itemNo = $F("itemNo");
			addNewJSONObject(obj, newGrpItems);		
		}
	}
}

function trimTextItems(){
	$$("label[name='textItem']").each(function (label)    {
        if ((label.innerHTML).length > 12)    {
            label.update((label.innerHTML).truncate(12, "..."));
        }
    });
}

function copyItemProcedure(param) {
	var action = param == "ITEM" ? "confirmCopyItem" : "confirmCopyEndtParItem";
	
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action="+action,{
		method : "GET",
		parameters : {
			parId : $F("globalParId"),
			lineCd : $F("globalLineCd"),
			sublineCd : $F("sublineCd") /* $F("globalSublineCd") */
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function(){},
			//showNotice("Copying item information, please wait..."),
		onComplete : 
			function(response){
				if (checkErrorOnResponse(response)) {
					//hideNotice("Done!");
					var msgPolDedExist = "The PAR has existing " + param == "ITEM" ? "item" : "policy" + " level deductible/s based on % of TSI.  Copying an item and peril info will delete the existing deductible/s. Continue?";
					if(response.responseText != "Empty") {
						/* temporary used javascript built-in confirm method*/
						showConfirmBox("Delete Policy Deductible", response.responseText, "Yes", "No", 
						 function() {
							 deletePolicyDeductible();//emman-function
							 copyItemProcedure2(param);
						 },
						 "");
						/*if (confirm(msgPolDedExist)) {
							//del_pol_dead
							deletePolicyDeductible();
						} else {
							return false;
						}*/
					} else {
						copyItemProcedure2(param);
					}
				}
			}
	});
}

function copyItemProcedure2(param) {
	if ($F("recFlag") != "A") {
		showMessageBox("Copy Item"+ (param == "PERIL" ? "/Peril" : "") +" facility is only available for additional item.", imgMessage.INFO);
		return false;
	} else if ($F("varDiscExist") == "Y") {
		showConfirmBox("Add New Item", "Adding new item will result to the deletion of all discounts. Do you want to continue?", "Yes", "No", 
		function() {
			$("varDiscExist").value = "N";
			getMaxEndtParItemNo(param);
		},
		"");
	} else {
		getMaxEndtParItemNo(param);
	}
}

// get max item_no in gipi_witem
function getMaxEndtParItemNo(param) {
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action=getMaxEndtParItemNo",{
		method : "GET",
		parameters : {
			parId : $F("globalParId")
		},
		asynchronous : false,
		evalScripts : true,
		//onCreate : showNotice("Retrieving max item no, please wait..."),
		onComplete : 
			function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Done!");
					
					$("lastItemNo").value = parseInt(response.responseText);
					var itemNumbers = $F("itemNumbers");
					var maxItemNo = $F("lastItemNo");

					if(itemNumbers.indexOf($F("itemNo")) < 0){
						showMessageBox("Only saved and valid items can be copied.", imgMessage.INFO);
						return false;
					}
					
					if($F("cgCtrlIncludeSw") == 'Y'){
						messageText = "This will create new item (" + maxItemNo + ") with the same item information (including additional information) as the current item display. Do you want to continue?";
					} else{
						messageText = "This will create new item (" + maxItemNo + ") with the same item information (excluding additional information) as the current item display. Do you want to continue?";
					}
					
					$("varVCopyItem").value = $F("itemNo");
					$("varNewSw2").value = "N";						
					
					/* temporary used javascript built-in confirm method */
					showConfirmBox("Delete Policy Deductible", messageText, "Yes", "No", 
					 function () {
						copyItem(maxItemNo);//emman function
						if (param == "PERIL") {
							new Ajax.Request(contextPath + "/GIPIItemMethodController?action=copyItemPeril",{
								method : "GET",
								parameters : {
									parId : $F("globalParId"),
									itemNo : $F("itemNo"),
									newItemNo : maxItemNo
								},
								asynchronous : true,
								evalScripts : true,			
								onComplete : 
									function(response){																		
										//showMotorItemInfo();
									} 
							});
						}
						showEndtItemInfo();
					 }, 
					 "");
				}
			}
	});
}	

function deletePolicyDeductible() {
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action=deletePolicyDeductibles",{
		method : "GET",
		parameters : {
			globalParId : $F("globalParId"),
			globalLineCd : $F("globalLineCd"),
			globalSublineCd : $F("sublineCd") /* $F("globalSublineCd") */
		},
		asynchronous : false,
		evalScripts : true,
		onComplete : function(response) {
			
		}
	});
}

function copyItem(itemNoValue){
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action=copyItemInfo",{
		method : "GET",
		parameters : {
			parId : $F("globalParId"),
			globalLineCd: $F("globalLineCd"),
			sublineCd: $F("sublineCd"),
			itemNo : $F("itemNo"),
			newItemNo : itemNoValue
		},
		asynchronous : false,
		evalScripts : true,			
		onComplete : 
			function(response){
				if($F("cgCtrlIncludeSw") == 'Y'){
					new Ajax.Request(contextPath + "/GIPIItemMethodController?action=copyAdditionalInfoEndt", {
						method : "GET",
						parameters : {
							parId : $F("globalParId"),
							lineCd: $F("globalLineCd"),
							sublineCd: $F("sublineCd"),
							itemNo : $F("itemNo"),
							newItemNo : itemNoValue
						},
						asynchronous : false /*true*/,
						evalScripts : true,
						onCreate : 
							function(){
								showNotice("Copying additional info, please wait...");									
							},
						onComplete :
							function(response){
								hideNotice("");
								if($F("variablesCopyItemTag") == "Y"){
									new Ajax.Request(contextPath + "/GIPIItemMethodController?action=deleteItemDeductible", {
										method : "GET",
										parameters : {
											parId : $F("globalParId"),
											lineCd: $F("globalLineCd"),
											sublineCd: $F("sublineCd"),
											itemNo : $F("itemNo"),
											newItemNo : itemNoValue
										},
										asynchronous : false /*true*/,
										evalScripts : true,
										onCreate : 
											function(){
												showNotice("Copying additional info, please wait...");									
											},
										onComplete :
											function(response){
												hideNotice("");
											}
									});
								}																			
							}
					});	
				}
			} 
	});	
	
}

//added by angelo

//COPY_PERIL_BTN -- when_button_pressed
$("btnCopyItemPerilInfo").observe("click", function() {
	$("copyPeril").value = "Y";
	showEndtPerilInfoPage();
	confirmCopyItem();
});

function copyPerilInformation(copyToItemNo){
	$("itemNo").value = copyToItemNo;
	$$("div#perilTableContainerDiv div[name='rowEndtPeril']").each(function (peril){
		if (peril.down("input", 0).value == $F("varVCopyItem")){
			peril.hide();
			
			var itemNo 					= copyToItemNo;
			var perilCd					= peril.down("input", 1).value;
			var perilName				= peril.down("input", 2).value;
			var premRate				= peril.down("input", 3).value;
			var tsiAmt					= peril.down("input", 4).value;
			var annTsiAmt				= peril.down("input", 5).value;
			var premiumAmt				= peril.down("input", 6).value;
			var annPremAmt				= peril.down("input", 7).value;
			var remarks					= peril.down("input", 8).value;
			var discSum					= peril.down("input", 9).value;
			var recFlag					= peril.down("input", 10).value;
			var basicPerilCd			= peril.down("input", 11).value;
			var riCommRate				= peril.down("input", 12).value;
			var riCommAmt				= peril.down("input", 13).value;
			var tariffCd				= peril.down("input", 14).value;
			var perilType				= peril.down("input", 15).value;

			var insContent   =  "<input type='hidden' name='insItemNo' 				value='" + itemNo + "' />" +
								"<input type='hidden' name='insPerilCd'				value='" + perilCd + "' />" +
								"<input type='hidden' name='insPerilName'			value='" + perilName + "' />" +
								"<input type='hidden' name='insPremiumRate'			value='" + premRate + "' />" +
								"<input type='hidden' name='insTsiAmount'			value='" + tsiAmt + "' />" +
								"<input type='hidden' name='insAnnTsiAmount'		value='" + annTsiAmt + "' />" +
								"<input type='hidden' name='insPremiumAmount'		value='" + premiumAmt + "' />" +
								"<input type='hidden' name='insAnnPremiumAmount'	value='" + annPremAmt + "' />" +
								"<input type='hidden' name='insRemarks' 			value='" + remarks + "' />" +
								"<input type='hidden' name='insDiscSum'				value='" + discSum + "' />" +
								"<input type='hidden' name='insRecFlag'				value='" + recFlag + "' />" +
								"<input type='hidden' name='insWcSw'				value='N' />" +
								"<input type='hidden' name='insRiCommRate'			value='" + formatToNineDecimal(riCommRate) + "' />" +
								"<input type='hidden' name='insRiCommAmount'		value='" + riCommAmt + "' />" +
								"<input type='hidden' name='insTarfCd'				value='" + tariffCd + "' />";
			
			var perilContent =  "<input type='hidden' name='hidItemNo' 				value='" + itemNo + "' />" +
								"<input type='hidden' name='hidPerilCd' 			value='" + perilCd + "' />" +
								"<input type='hidden' name='hidPerilName' 			value='" + perilName + "' />" +
								"<input type='hidden' name='hidPremiumRate' 		value='" + premRate + "' />" +
								"<input type='hidden' name='hidTsiAmount' 			value='" + tsiAmt + "' />" +
								"<input type='hidden' name='hidAnnTsiAmount' 		value='" + annTsiAmt + "' />" +
								"<input type='hidden' name='hidPremiumAmount' 		value='" + premiumAmt + "' />" +
								"<input type='hidden' name='hidAnnPremiumAmount'	value='" + annPremAmt + "' />" +
								"<input type='hidden' name='hidRemarks'				value='" + remarks + "' />" +
								"<input type='hidden' name='hidDiscSum'				value='" + discSum + "' />" +
								"<input type='hidden' name='hidRecFlag'				value='" + recFlag + "' />" +
								"<input type='hidden' name='hidBasicPerilCd'		value='" + basicPerilCd + "' />" +
								"<input type='hidden' name='hidRiCommRate'			value='" + riCommRate + "' />" +
								"<input type='hidden' name='hidRiCommAmount'		value='" + riCommAmt + "' />" +
								"<input type='hidden' name='hidTariffCd'			value='" + tariffCd + "' />" +
								"<input type='hidden' name='hidPerilType'			value='" + perilType + "' />" +
								"<div id='labelDiv1' style='display: block;' />" +
								"<label style='width: 4%; text-align: center; margin-left: 3px;' name='lblItemNo' title='" + itemNo + "' >" + itemNo + "</label>" +
								"<label style='width: 16%; text-align: left; margin-left: 5px;' name='lblPerilName' title='" + perilName + "' >" + perilName.truncate(18, "...") + "</label>" +
								"<label style='width: 15%; text-align: right; margin-left: 3px;' name='lblPremiumRate' title='" + premRate + "' >" + formatToNineDecimal(premRate) + "</label>" +
								"<label style='width: 15%; text-align: right; margin-left: 3px;' name='lblTsiAmount' title='" + tsiAmt + "' >" + formatCurrency(tsiAmt) + "</label>" +
								"<label style='width: 15%; text-align: right; margin-left: 3px;' name='lblAnnTsiAmount' title='" + annTsiAmt + "' >" + formatCurrency(annTsiAmt) + "</label>" +
								"<label style='width: 15%; text-align: right; margin-left: 3px;' name='lblPremiumAmount' title='" + premiumAmt + "' >" + formatCurrency(premiumAmt) + "</label>" +
								"<label style='width: 17%; text-align: right; margin-left: 3px;' name='lblAnnPremiumAmount' title='" + annPremAmt + "' >" + formatCurrency(annPremAmt) + "</label>" +
								"</div>" +
								"<div id='labelDiv2' style='display: none;' />" +
								"<label style='width: 4%; text-align: center; margin-left: 3px;' name='lblItemNo' title='" + itemNo + "' >" + itemNo + "</label>" +
								"<label style='width: 16%; text-align: left; margin-left: 5px;' name='lblPerilName' title='" + perilName + "' >" + perilName.truncate(18, "...") + "</label>" +
								"<label style='width: 18%; text-align: right; margin-left: 3px; name='lblRIRate' title='" + riCommRate + "' >" + formatToNineDecimal(riCommRate) + "</label>" +
								"<label style='width: 18%; text-align: right; margin-left: 3px; name='lblCommisionAmount' title='" + riCommAmt + "' >" + formatCurrency(riCommAmt) + "</label>" +
								"<label style='width: 18%; text-align: right; margin-left: 3px; name='lblPremiumCeded' title='" + premiumAmt + "' >" + formatCurrency(premiumAmt) + "</label>" +
								"</div>";

			var perilRow = new Element("div");
			perilRow.setAttribute("id", "rowEndtPeril" + itemNo + perilCd);
			perilRow.setAttribute("item", itemNo);
			perilRow.setAttribute("name", "rowEndtPeril");
			//perilRow.setStyle("display: none;");
			perilRow.addClassName("tableRow");

			var insPerilRow = new Element("div");
			insPerilRow.setAttribute("id", "insPeril" + itemNo + perilCd);
			insPerilRow.setAttribute("name", "insPeril");
			insPerilRow.update(insContent);
			$("forInsertDiv").insert({bottom : insPerilRow});
			
			perilRow.update(perilContent);
			$("perilTableContainerDiv").insert({bottom : perilRow});

			perilRow.observe("mouseover", function(){
				perilRow.addClassName("lightblue");
			});

			perilRow.observe("mouseout", function(){
				perilRow.removeClassName("lightblue");
			});
			
			perilRow.observe("click", function(){
				perilRow.toggleClassName("selectedRow");
				if (perilRow.hasClassName("selectedRow")){
					$$("div[name='rowEndtPeril']").each(function (pRow){
						if (perilRow.getAttribute("id") != pRow.getAttribute("id")){
							pRow.removeClassName("selectedRow");
						}
					});

					for (var k = 0; k < $("perilCd").length; k++){
						if (perilCd == $("perilCd").options[k].value){
							$("perilCd").selectedIndex = k;
						}
					}

					$("inputPremiumRate").value = formatToNineDecimal(premRate);
					$("inputTsiAmt").value = formatCurrency(tsiAmt);
					$("inputAnnTsiAmt").value = formatCurrency(annTsiAmt);
					$("inputPremiumAmt").value = formatCurrency(premiumAmt);
					$("inputAnnPremiumAmt").value = formatCurrency(annPremAmt);
					$("inputRiCommRate").value = riCommRate;
					$("inputCompRem").value = remarks;

					$("btnAddPeril").value 			= "Update";
					enableButton("btnDeletePeril");

					toggleEndtPerilDeductibles($F("varVCopyItem"), $F("perilCd"));
					copyPerilDeductible($F("varVCopyItem"), copyToItemNo);
					
				} else {
					$("perilCd").selectedIndex 		= 0;
					$("inputPremiumRate").value 	= formatToNineDecimal("0");
					$("inputTsiAmt").value 			= formatCurrency("0");
					$("inputAnnTsiAmt").value		= formatCurrency("0");
					$("inputPremiumAmt").value 		= formatCurrency("0");
					$("inputAnnPremiumAmt").value 	= formatCurrency("0");
					$("inputRiCommRate").value 		= formatToNineDecimal("0");
					$("inputCompRem").value 		= "";

					$("btnAddPeril").value 			= "Add";
					disableButton("btnDeletePeril");
					
					toggleEndtPerilDeductibles($F("varVCopyItem"), "");
				}
			});

			checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
			checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");

		}
		
	});

	$("copyPeril").value = "N";
	
}

function copyPerilDeductible(itemNoCopiedFrom, copyToItemNo){	
	var newDedId = "";
	
	$$("div#wdeductibleListing3 div[name='ded3']").each(function (ded){
		if (ded.getAttribute("item") == itemNoCopiedFrom){		
			var newItemNo = copyToItemNo;
			var newPerilCd = ded.getAttribute("perilCd");
			var deductCd = ded.getAttribute("dedCd");
			newDedId = "ded3" + newItemNo + newPerilCd + deductCd;
			
			var itemNo 				= ded.down("input", 0).value;
			var perilName			= ded.down("input", 1).value;
			var perilCd 			= ded.down("input", 2).value;
			var deductibleTitle 	= ded.down("input", 3).value;
			var dedDeductibleCd 	= ded.down("input", 4).value;
			var deductibleAmount 	= ded.down("input", 5).value;
			var deductibleRate		= ded.down("input", 6).value;
			var deductibleText		= ded.down("input", 7).value;
			var aggregateSw 		= ded.down("input", 8).value;
			var ceilingSw 			= ded.down("input", 9).value;
			var deductibleType		= ded.down("input", 10).value;
			var dedLineCd 			= ded.down("input", 11).value;
			var dedSublineCd 		= ded.down("input", 12).value;
			var dedType				= ded.down("input", 13).value;	
			
			var hidDedContent = "<input type='hidden' id='dedItemNo3' 			name='dedItemNo3' 			value='" + itemNo + "' />" +
								"<input type='hidden' id='dedPerilName3'		name='dedPerilName3'		value='" + perilName + "' />" +
								"<input type='hidden' id='dedPerilCd3'			name='dedPerilCd3'			value='" + perilCd + "' />" +
								"<input type='hidden' id='dedTitle3'			name='dedTitle3'			value='" + deductibleTitle + "' />" +
								"<input type='hidden' id='dedDeductibleCd3'		name='dedDeductibleCd3'		value='" + dedDeductibleCd + "' />" +
								"<input type='hidden' id='dedAmount3'			name='dedAmount3'			value='" + deductibleAmount + "' />" +
								"<input type='hidden' id='dedRate3'				name='dedRate3'				value='" + deductibleRate + "' />" +
								"<input type='hidden' id='dedText3'				name='dedText3'				value='" + deductibleText + "' />" +
								"<input type='hidden' id='dedAggregateSw3'		name='dedAggregateSw3'		value='" + aggregateSw + "' />" +
								"<input type='hidden' id='dedCeilingSw3'		name='dedCeilingSw3'		value='" + ceilingSw + "' />" +
								"<input type='hidden' id='dedDeductibleType3'	name='dedDeductibleType3'	value='" + deductibleType + "' />" +
								"<input type='hidden' id='dedLineCd3'			name='dedLineCd3'			value='" + dedLineCd + "' />" +
								"<input type='hidden' id='dedSublineCd3'		name='dedSublineCd3'		value='" + dedSublineCd + "' />" +
								"<input type='hidden' id='dedType3'				name='dedType3'				value='" + dedType + "' />";

			var viewContent	  = "<label style='width: 36px; text-align: right; margin-right: 10px;'>" + newItemNo + "</label>" +
								"<label name='peril' id='peril3" + newItemNo + newPerilCd + deductCd + "' style='width: 160px; text-align: left;'>" + perilName + "</label>" +
								"<label name='dedTitle3' id='dedTitle3" + newItemNo + newPerilCd + deductCd + "' style='width: 213px; text-align: left; margin-left: 5px;'>" + deductibleTitle + "</label>" +
								"<label style='width: 119px; text-align: right;'>" + formatToNineDecimal(deductibleRate) + "</label>" +
								"<label style='width: 119px; text-align: right;'>" + formatCurrency(deductibleAmount) + "</label>" +
								"<label name='dedText3' id='dedText3" + newItemNo + newPerilCd + deductCd + "' style='width: 155px; text-align: left; margin-left: 20px;'>" + deductibleText + "</label>";

			var insId = "insDed3" + newItemNo + newPerilCd + deductCd;
			var code = newItemNo + newPerilCd + deductCd;

			var forInsDedDiv  = "<input type='hidden' id='insDedItemNo3" + code + "' 			name='insDedItemNo3' 			value='" + itemNo + "' />" +
								"<input type='hidden' id='insDedPerilName3" + code + "'			name='insDedPerilName3'		value='" + perilName + "' />" +
								"<input type='hidden' id='insDedPerilCd3" + code + "'			name='insDedPerilCd3'			value='" + perilCd + "' />" +
								"<input type='hidden' id='insDedTitle3" + code + "'				name='insDedTitle3'			value='" + deductibleTitle + "' />" +
								"<input type='hidden' id='insDedDeductibleCd3" + code + "'		name='insDedDeductibleCd3'		value='" + dedDeductibleCd + "' />" +
								"<input type='hidden' id='insDedAmount3" + code + "'			name='insDedAmount3'			value='" + deductibleAmount + "' />" +
								"<input type='hidden' id='insDedRate3" + code + "'				name='insDedRate3'				value='" + deductibleRate + "' />" +
								"<input type='hidden' id='insDedText3" + code + "'				name='insDedText3'				value='" + deductibleText + "' />" +
								"<input type='hidden' id='insDedAggregateSw3" + code + "'		name='insDedAggregateSw3'		value='" + aggregateSw + "' />" +
								"<input type='hidden' id='insDedCeilingSw3" + code + "'			name='insDedCeilingSw3'		value='" + ceilingSw + "' />" +
								"<input type='hidden' id='insDedDeductibleType3" + code + "'	name='insDedDeductibleType3'	value='" + deductibleType + "' />" +
								"<input type='hidden' id='insDedLineCd3" + code + "'			name='insDedLineCd3'			value='" + dedLineCd + "' />" +
								"<input type='hidden' id='insDedSublineCd3" + code + "'			name='insDedSublineCd3'		value='" + dedSublineCd + "' />" +
								"<input type='hidden' id='insDedType3" + code + "'				name='insDedType3'				value='" + dedType + "' />";
													
			var copyDedDiv = new Element("div");
			copyDedDiv.setAttribute("id", newDedId);
			copyDedDiv.setAttribute("name", "ded3");
			copyDedDiv.addClassName("tableRow");
			copyDedDiv.setStyle("display: none;");
			copyDedDiv.setAttribute("perilCd", newPerilCd);
			copyDedDiv.setAttribute("dedcd", deductCd);
			copyDedDiv.setAttribute("item", newItemNo);
			copyDedDiv.update(hidDedContent + viewContent);
			
			$("wdeductibleListing3").insert({bottom: copyDedDiv});

			var insDedDiv = new Element("div");
			insDedDiv.setAttribute("id", insId);
			insDedDiv.setAttribute("name", "insDed3");
			insDedDiv.setStyle("display: none;");
			insDedDiv.update(forInsDedDiv);

			$("dedForInsertDiv3").insert({bottom: insDedDiv});

			copyDedDiv.show();

			addClassToAddedRows(copyDedDiv, "ded3", fillDedInfo, clearDedInfo);

			ded.hide();
			
			$("perilDedList").value = $("perilDedList").value + "-" + newDedId;
			checkIfToResizeTable2("wdeductibleListing3", "ded3");		
		} 
	});	
}

function addClassToAddedRows(newRow, tableRowName, clickFunction, removeSelectedFunction){
	newRow.observe("mouseover", function(){
		newRow.addClassName("lightblue");
	});

	newRow.observe("mouseout", function(){
		newRow.removeClassName("lightblue");
	});

	newRow.observe("click", function(){
		newRow.toggleClassName("selectedRow");
		if (newRow.hasClassName("selectedRow")){
			$$("div[name='" + tableRowName + "']").each(function (row){
				if (newRow.getAttribute("id") != row.getAttribute("id")){
					row.removeClassName("selectedRow");
				}

				clickFunction(newRow);
			});
		} else {
			removeSelectedFunction();
		}
	});
}

function fillDedInfo(newRow){
	for (var i = 0; i < $("inputDeductible3").length; i++){
		if (newRow.down("input", 4).value == $("inputDeductible3").options[i].value){
			$("inputDeductible3").selectedIndex = i;
		} 
	}

	$("deductibleRate3").value = formatToNineDecimal(newRow.down("input", 6).value);
	$("inputDeductibleAmount3").value = formatCurrency(newRow.down("input", 5).value);
	$("deductibleText3").value = newRow.down("input", 7).value;
	if (newRow.down("input", 8).value == "Y"){
		$("aggregateSw3").checked = true;
	}

	$("btnAddDeductible3").value = "Update";
	enableButton("btnDeleteDeductible3");
	
}

function clearDedInfo(){
	$("inputDeductible3").selectedIndex = 0;
	$("deductibleRate3").value = formatToNineDecimal(0);
	$("inputDeductibleAmount3").value = formatCurrency(0);
	$("deductibleText3").value = "";
	$("aggregateSw3").checked = false;

	$("btnAddDeductible3").value = "Add";
	disableButton("btnDeleteDeductible3");
}

//NEG_ITEM_BTN -- when_button_pressed
$("btnNegateItem").observe("click", negateItem);

function negateItem() {
	var endtExpiryDate = new Date($F("varEndtExpiryDate"));
	var effDate = new Date($F("varEffDate"));
	if (parseInt($F("changedFields")) == 0) {
		showConfirmBox("Negate Item", "Negate/Remove Item will automatically negate all perils of item number " + $F("itemNo") + ", which means that it is deleted. Do you want to continue?", "Yes", "No",
		 function() {
			if($F("polProrateFlag") == "1" && endtExpiryDate <= effDate) {
				showMessageBox("Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.", imgMessage.ERROR);
				return false;
			}

			if(checkIfPerilExists(false)) {
				showConfirmBox("Negate Item", "Existing perils for this item will be automatically deleted. Do you want to continue?", "Yes", "No",
				negDelItem,//emman function
				 "");
			} else {
				negDelItem();//emman function
			}
		 },
		  "");
	} else {
		showMessageBox("Please save changes first before pressing the NEGATE/REMOVE ITEM button.", imgMessage.INFO);
	}
}

function negDelItem() {
	var result = true;
	
	if ($F("globalBackEndt") == "Y") {
		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=checkBackEndtBeforeDelete",{
			method : "GET",
			parameters : {
				itemNo : $F("itemNo"),
				parId : $F("globalParId")
			},					
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				//showNotice("Checking if item is backward endorsement. Please wait...");
			},
			onComplete : function(response){
				//hideNotice("Done!");
				var msg = response.responseText;
				if (msg != "SUCCESS") {
					showMessageBox(msg, imgMessage.INFO);
					result = false;
				}
			}
		});
	}

	if (!result) {
		return false;
	} else {
		//delete_discount
		result = deleteDiscount();

		if(!result) {
			return false;
		} else {
			//extract_expiry
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=extractExpiry",{
				method : "GET",
				parameters : {
					parId : $F("globalParId")
				},					
				asynchronous : false,
				evalScripts : true,
				onCreate: function() {
					//showNotice("Extracting latest expiry date. Please wait...");
				},
				onComplete : function(response){
					if (checkErrorOnResponse(response)) {
						//hideNotice("Done!");
						var expiry = response.responseText;
						$("varExpiryDate").value = expiry;
						negDelItem2();
					}
				}
			});
		}
	}
}

function negDelItem2() {
	new Ajax.Request(contextPath + "/GIPIWItemVesController?action=checkUpdateGipiWPolbasValidity&globalParId="
			+$F("globalParId"),{
		method : "POST",
		asynchronous : false,
		evalScripts : true,
		postBody : Form.serialize("itemInformationForm"),
		onCreate: function() {
			//showNotice("Updating. Please wait...");
		},
		onComplete : function(response){
			if (checkErrorOnResponse) {
				$("updateGIPIWPolbas").value = "Y";
				deleteItemPerilsForItemNo($F("itemNo"));
				negDelItem3();
			} else {
				//hideNotice("");
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}

function negDelItem3() {
	new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=getNegateItemPerils",{
		method : "GET",
		parameters : {
			itemNo : $F("itemNo"),
			globalParId : $F("globalParId")
		},					
		asynchronous : false,
		evalScripts : true,
		onCreate: function() {
			//showNotice("Getting negated item peril values...");
		},
		onComplete : function(response){
			var jsonPerils = eval(response.responseText);
			
			for (var i=0; i<jsonPerils.length; i++){
				
				var itemNo = jsonPerils[i].itemNo;
				var perilCd = jsonPerils[i].perilCd;
				var perilName = jsonPerils[i].perilName;
				var premiumRate = jsonPerils[i].premRt == null ? "" : jsonPerils[i].premRt;
				var tsiAmount = jsonPerils[i].tsiAmt == null ? "" : jsonPerils[i].tsiAmt;
				var annTsiAmount = jsonPerils[i].annTsiAmt == null ? "" : jsonPerils[i].annTsiAmt;
				var premiumAmount = jsonPerils[i].premAmt == null ? "" : jsonPerils[i].premAmt;
				var annPremiumAmount = jsonPerils[i].annPremAmt == null ? "" : jsonPerils[i].annPremAmt;
				var remarks = jsonPerils[i].compRem == null ? "" : jsonPerils[i].compRem == null;
				var recFlag = jsonPerils[i].recFlag == null ? "" : jsonPerils[i].recFlag;
				var incWC = "";//jsonPerils[i].attribute;
				var riCommRate = jsonPerils[i].riCommRate == null ? "" : jsonPerils[i].riCommRate;
				var riCommAmount = jsonPerils[i].riCommAmt == null ? "" : jsonPerils[i].riCommAmt;
				var tarfCd = jsonPerils[i].tarfCd == null ? "" : jsonPerils[i].tarfCd == null;
				var basicPerilCd = jsonPerils[i].basicPerilCd == null ? "" : jsonPerils[i].basicPerilCd;
				var perilType = jsonPerils[i].perilType == null ? "" : jsonPerils[i].perilType == null;
	
				var insId = "insPeril" + itemNo + perilCd;
				var insertContent = '<input type="hidden" name="insItemNo" 			 value="'+itemNo+'"/>'+
									'<input type="hidden" name="insPerilCd" 		 value="'+perilCd+'"/>'+
									'<input type="hidden" name="insPerilName" 		 value="'+perilName+'"/>'+
									'<input type="hidden" name="insPremiumRate" 	 value="'+(premiumRate == null ? "" : parseFloat(premiumRate))+'"/>'+
							   		'<input type="hidden" name="insTsiAmount" 		 value="'+tsiAmount+'"/>'+
							   		'<input type="hidden" name="insAnnTsiAmount" 	 value="'+annTsiAmount+'"/>'+
									'<input type="hidden" name="insPremiumAmount" 	 value="'+premiumAmount+'"/>'+
									'<input type="hidden" name="insAnnPremiumAmount" value="'+annPremiumAmount+'"/>'+
									'<input type="hidden" name="insRemarks" 		 value="'+remarks+'"/>'+
									'<input type="hidden" name="insDiscSum" 		 value=""/>'+
									'<input type="hidden" name="insRecFlag" 		 value="'+recFlag+'"/>'+
									'<input type="hidden" name="insWcSw" 		 	 value="'+incWC+'"/>'+
									//'<input type="hidden" name="insBasicPerilCd" 	 value="'+basicPerilCd+'"/>'+
									'<input type="hidden" name="insRiCommRate"	 	 value="'+riCommRate+'" />'+
									'<input type="hidden" name="insRiCommAmount" 	 value="'+riCommAmount+'" />'+
									'<input type="hidden" name="insTarfCd" 	 		 value="'+tarfCd+'" />';
						
				var newId = "rowEndtPeril" + itemNo + perilCd;								
				var viewContent   = '<input type="hidden" name="hidItemNo" 			 value="'+itemNo+'"/>'+
									'<input type="hidden" name="hidPerilCd" 		 value="'+perilCd+'"/>'+
									'<input type="hidden" name="hidPerilName" 		 value="'+perilName+'"/>'+
									'<input type="hidden" name="hidPremiumRate" 	 value="'+premiumRate+'"/>'+
							   		'<input type="hidden" name="hidTsiAmount" 		 value="'+tsiAmount+'"/>'+
							   		'<input type="hidden" name="hidAnnTsiAmount" 	 value="'+annTsiAmount+'"/>'+ 
									'<input type="hidden" name="hidPremiumAmount" 	 value="'+premiumAmount+'"/>'+
									'<input type="hidden" name="hidAnnPremiumAmount" value="'+annPremiumAmount+'"/>'+
									'<input type="hidden" name="hidRemarks" 		 value="'+remarks+'"/>'+
									'<input type="hidden" name="hidDiscSum" 		 value=""/>'+
									'<input type="hidden" name="hidRecFlag" 		 value="'+recFlag+'"/>'+
									'<input type="hidden" name="hidBasicPerilCd" 	 value="'+basicPerilCd+'"/>'+
									'<input type="hidden" name="hidRiCommRate"	 	 value="'+riCommRate+'" />'+
									'<input type="hidden" name="hidRiCommAmount" 	 value="'+riCommAmount+'" />'+
									'<input type="hidden" name="hidTarfCd" 	 		 value="'+tarfCd+'" />'+
									'<input type="hidden" name="hidPerilType" 	     value="'+perilType+'" />'+
									'<div id="labelDiv1">'+
									'<label name="lblItemNo" 			style="width: 4%; text-align: center; margin-left: 3px;">'+itemNo+'</label>'+
									'<label name="lblPerilName" 		style="width: 16%; text-align: left; margin-left: 5px;">'+perilName.truncate(18, "...")+'</label>'+
									'<label name="lblPremiumRate" 		style="width: 15%; text-align: right; margin-left: 3px;">'+formatToNineDecimal(premiumRate)+'</label>'+
							   		'<label name="lblTsiAmount" 		style="width: 15%; text-align: right; margin-left: 3px;">'+(tsiAmount == null ? "" : formatCurrency(tsiAmount))+'</label>'+
							   		'<label name="lblAnnTsiAmount" 		style="width: 15%; text-align: right; margin-left: 3px;">'+(annTsiAmount == null ? "" : formatCurrency(annTsiAmount))+'</label>'+
									'<label name="lblPremiumAmount" 	style="width: 15%; text-align: right; margin-left: 3px;">'+(premiumAmount == null ? "" : formatCurrency(premiumAmount))+'</label>'+
									'<label name="lblAnnPremiumAmount"	style="width: 17%; text-align: right; margin-left: 3px;">'+(annPremiumAmount == null ? "" : formatCurrency(annPremiumAmount))+'</label>'+
									'</div>'/*+
									'<div id="labelDiv2">'+
									'<label name="lblItemNo" 			style="width: 4%; text-align: center; margin-left: 3px;">'+itemNo+'</label>'+
									'<label name="lblPerilName" 		style="width: 16%; text-align: left; margin-left: 5px;">'+perilName.truncate(18, "...")+'</label>'+
							   		'<label name="lblRIRate" 		    style="width: 18%; text-align: right; margin-left: 3px;">'+(riCommRate == null ? "" : formatToNineDecimal(riCommRate))+'</label>'+
									'<label name="lblCommissionAmount" 	style="width: 18%; text-align: right; margin-left: 3px;">'+(riCommAmount == null ? "" : formatCurrency(riCommAmount))+'</label>'+
									'<label name="lblPremiumCeded"		style="width: 18%; text-align: right; margin-left: 3px;">'+(premiumAmount == null ? "" : formatCurrency(premiumAmount))+'</label>'+
									'</div>'*/;

					var newRow = new Element('div');
					newRow.setAttribute("name", "rowEndtPeril");
					newRow.setAttribute("id", newId);
					newRow.setAttribute("item", itemNo);
					newRow.addClassName("tableRow");
					newRow.setStyle("display: none;");
						
					newRow.update(viewContent);					
					$("perilTableContainerDiv").insert({bottom: newRow});

					newRow.observe("mouseover", function ()	{
						newRow.addClassName("lightblue");
					});
					
					newRow.observe("mouseout", function ()	{
						newRow.removeClassName("lightblue");
					});
		
					newRow.observe("click", function ()	{
						newRow.toggleClassName("selectedRow");
						if (newRow.hasClassName("selectedRow"))	{
							$$("div[name='rowEndtPeril']").each(function (li)	{
									if (newRow.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});	
							//setEndtPerilForm(newRow);
							//setEndtPerilFields(newRow);
							
							var perils = $("perilCd");
							for (var k=0; k < perils.length; k++) {
								if (perils.options[k].value == newRow.down("input", 1).value)	{
									perils.selectedIndex = k;
								}
							}
							
							$("inputPremiumRate").value		= formatToNineDecimal(newRow.down("input", 3).value);
							$("inputTsiAmt").value 			= formatCurrency(newRow.down("input", 4).value);
							$("inputAnnTsiAmt").value		= formatCurrency(newRow.down("input", 5).value);
							$("inputPremiumAmt").value 		= formatCurrency(newRow.down("input", 6).value);
							$("inputAnnPremiumAmt").value 	= formatCurrency(newRow.down("input", 7).value);
							$("inputRiCommRate").value 		= newRow.down("input", 12).value;
							$("inputCompRem").value 		= newRow.down("input", 8).value;

							toggleEndtPerilDeductibles($F("itemNo"), $F("perilCd"));
							
						} else {
							//setEndtPerilForm(null);
							//setEndtPerilFields(null);
							
							$("perilCd").selectedIndex = 0;
							
							$("inputPremiumRate").value		= formatToNineDecimal("0");
							$("inputTsiAmt").value 			= formatCurrency("0");
							$("inputAnnTsiAmt").value		= formatCurrency("0");
							$("inputPremiumAmt").value 		= formatCurrency("0");
							$("inputAnnPremiumAmt").value 	= formatCurrency("0");
							$("inputRiCommRate").value 		= formatToNineDecimal("0");
							$("inputCompRem").value 		= "";

							toggleEndtPerilDeductibles($F("itemNo"), "");
						}
					});
		
					checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
					checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
					setEndtItemAmounts($F("itemNo"));
					var insPeril = new Element('div');
					insPeril.setAttribute("name", "insPeril");
					insPeril.setAttribute("id", insId);
					insPeril.setStyle("visibility: hidden;");
					insPeril.update(insertContent);
					$("forInsertDiv").insert({bottom: insPeril});

					Effect.Appear(newRow, {
						duration: .5, 
						afterFinish: function ()	{
							checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
							checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
						}
					});

			}
			//hideNotice("");
			showMessageBox("Deletion has been sucessfully completed... Check Item Peril Module for information.", imgMessage.INFO);
			$("changedFields").value = parseInt($F("changedFields")) + 1;
			$("invoiceSw").value = "Y";
		}
	});

}

function checkIfPerilExists(param){
	var result = false;
	
	new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=checkIfWItemPerilExists2", {
		method			: "GET",
		parameters		: {
			parId	: $F("globalParId"),
			itemNo	: $F("itemNo")
		},
		asynchronous	: false,
		evalScripts		: true,
		onComplete		: function (response){
			var message = response.responseText;
			if (message == "Y"){ //change N to Y after testing
				result = true;	
			}
		}
	});

	return result;
}

function deleteItemPerilsForItemNo(pItemNo){		
	try {

		
		
		$$("div[name='rowEndtPeril']").each(function (rowEndtPeril) {
			if (rowEndtPeril.down("input", 0).value == pItemNo){
				//var itemNo        = rowEndtPeril.down("input", 0).value;
				var pPerilCd       = rowEndtPeril.down("input", 1).value;

				deletePerilDeductibles(pPerilCd);
				
				var forDeleteDiv  = $("forDeleteDiv");
				var deleteContent = '<input type="hidden" id="delItemNo'+pItemNo+pPerilCd+'"   name="delItemNo"    value="'+ pItemNo +'" />'+
									'<input type="hidden" id="delPerilCd'+pItemNo+pPerilCd+'"  name="delPerilCd"   value="'+ pPerilCd +'" />';									
				var deleteDiv     = new Element("div");
				
				deleteDiv.setAttribute("id", "delPeril"+pItemNo+pPerilCd);
				deleteDiv.setStyle("visibility: hidden;");
				deleteDiv.update(deleteContent);
						
				forDeleteDiv.insert({bottom : deleteDiv});

				$$("div[name='insPeril']").each(function(div){
					var id = div.getAttribute("id");
					if(id == "insPeril"+pItemNo+pPerilCd){
						div.remove();
					}
				});

				//setEndtVariables();
				//var obj = setJSONPeril();
				//addDeletedJSONPeril(obj);
				Effect.Fade(rowEndtPeril, {
					duration: .5,
					afterFinish: function () {
						rowEndtPeril.remove();
						checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");
						checkIfToResizeTable2("perilTableContainerDiv", "rowEndtPeril");
						setEndtItemAmounts(pItemNo);
						//setEndtPerilForm(null);
						//setEndtPerilFields(null);
					}
				});				
			}
		});
	} catch (e) {
		showErrorMessage("deleteItemPerilsForItemNo", e);
		//showMessageBox("deleteEndtPeril : " + e.message);
	}
}

function deletePerilDeductibles(pPerilCd){
	$$("div[name='ded3']").each(function (ded) {
		if (ded.down("input", 0).value == $F("itemNo") && ded.down("input", 2).value == pPerilCd){
			ded.remove();
		}
	});
}

function updatePerilsForNegation(){
	var totalAnnTsiAmount = $F("itemTsiAmt");
	var totalAnnPremiumAmount = $F("itemPremiumAmt");
	
	$$("div[name='rowEndtPeril']").each(function (rp){
		rp.remove();
	});

	$$("div[name='ded3']").each(function (rpd){
		rpd.remove();
	});

	$("tableHeaderDiv1").remove();
	$("itemTsiAmt").value = "0.00";
	$("itemPremiumAmt").value = "0.00";
	$("itemAnnTsiAmt").value = "0.00";
	$("itemAnnPremiumAmt").value = "0.00";

	checkTableIfEmpty2("rowEndtPeril", "endtPerilTable");

}

//DEL_ADD_BTN -- when_button_pressed
$("btnDeleteAddAllItems").observe("click", function(){
	if ("${isPack}" == "Y") {  //Deo [03.03.2017]: SR-23874
        showConfirmBox("Confirmation", "You are not allowed to Delete/Add items here. "
        	+ "Delete/Add items in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
		return false;
    }
	if (parseInt($F("changedFields")) == 0){
		showConfirmBox3("Delete/Add All Items", "What processing would you like to perform?", "ADD", "DELETE",
				function(){
					deleteAddAllItems(1);
				},
				function(){
					deleteAddAllItems(2);
				});
	} else {
		showMessageBox("Please save changes first before pressing the DELETE/ADD ALL ITEMS button.", imgMessage.INFO);
	}
});

function updateAddDeleteItemTable(value, id){	
	$("addDeleteItemDiv").show();
	
	var itemTable = $("addDeleteItemTableContainer");
	var content = '<label name="textItem" style="width: 20%; text-align: center;">' +
				  		'<input type="checkBox" name="addDeleteCheckbox" value="N"/>' +
				  '</label>' + 
				  '<label name="textItem" style="width: 20%; text-align: left;">' +
				  		value +
				  '</label>';
	var newDiv = new Element("div");
	newDiv.setAttribute("id", id);
	newDiv.setAttribute("name", "addDeleteItemRow");
	newDiv.setAttribute("style", "height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;");
	newDiv.setAttribute("class", "tableRow");
	newDiv.update(content);
	itemTable.insert({bottom: newDiv});

	newDiv.down("input", 0).observe("click", function () {
		if (newDiv.down("input", 0).checked == true) {
			$("paramItemCnt").value = parseInt($("paramItemCnt").value) + 1;
		} else {
			$("paramItemCnt").value = parseInt($("paramItemCnt").value) - 1;
		}
	});

}

function deleteAddAllItems(choice){
	if (choice == 3) {
		return false;
	} else {
		if ($F("addDeletePageLoaded") == "N"){
			new Ajax.Updater("addDeleteItemDiv", contextPath + "/GIPIEndtParMCItemInfoController?action=showAddDeleteItemDiv", {
				method: "GET",
				parameters: {
					globalParId: $F("globalParId")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var deductibleExist = $F("varDeductibleExist");
					if (deductibleExist == "Y" || deductibleExist == "N"){
						$("addDeletePageLoaded").value = "Y";
					} else {
						showMessageBox(deductibleExist);
					}
				}
			});
		}
		
		if (choice == 1){
			//add item
			$("paramAddDeleteSw").value = "A";
			$("paramItemCnt").value = 0;
			
			new Ajax.Request(contextPath + "/GIPIWItemController?action=getDistinctItemNos", {
				method: "GET",
				parameters: {
					parId: $F("globalParId")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						//used if the return is an xml object
						var resXML = response.responseXML;
						//used to get the inner xml value of tagname itemNosSize
						var itemNosSize = resXML.getElementsByTagName("itemNosSize")[0].childNodes[0].nodeValue;

						if (itemNosSize < 1){
							showMessageBox('All item(s) for this policy is already inserted.');
							return false;
						}

						for (var i = 0; i <=  itemNosSize; i++){
							value = resXML.getElementsByTagName("itemNo"+i)[0].childNodes[0].nodeValue;
							updateAddDeleteItemTable(value, "row"+i);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
			
		} else if (choice == 2){
			//delete item
			if ($$("div#itemTable div[name=row]").size() == 0){
				showMessageBox('There are no items inserted for this PAR.', imgMessage.ERROR);
				return false;
			}
			
			$("paramAddDeleteSw").value = "D";
			$("paramItemCnt").value = 0;

			$$("div#addDeleteItemDiv div[name=addDeleteItemRow]").each(function (row){
				row.remove();
			});
			
			$$("div#itemTable div[name=row]").each(function (row){
				updateAddDeleteItemTable(row.down("input", 1).value, row.id);
			});

		}

		checkAddDeleteItemButtons();
	}
}

function checkAddDeleteItemButtons(){
	$("btnAddDeleteContinue").observe("click", function () {
		if ($F("paramItemCnt") < 1){
			showMessageBox('There are no records tagged for processing', imgMessage.ERROR);
		} else {
			if ($F("varDeductibleExist") == "Y"){ 
				showConfirmBox("Delete Deductible", 'The PAR has an existing deductible based on % of TSI. ' +
													'Deleting the item will delete the existing deductible. Continue?' ,
							   "Yes", "No",
							   function(){
									$("delDedSw").value = "Y";
							   },
							   "");
			}
			validateBeforeDeleteItem();
			/*
			if ($F("varDeductibleExist") == "Y"){ //revert to "Y" after testing
				showConfirmBox("Delete Deductible", 'The PAR has an existing deductible based on % of TSI. ' + 
													'Deleting the item will delete the existing deductible. Continue?',
							   "Yes", "No",
							   function(){
									new Ajax.Request(contextPath + "/GIPIWDeductibleController?action=deleteGipiWdeductibles2", {
										method: "GET",
										parameters: {
											globalParId: $F("globalParId"),
											globalLineCd: $F("globalLineCd"),
											globalSublineCd: $F("globalSublineCd")
										},
										evalScripts: true,
										asynchronous: true,
										onComplete: function(response) {
											var msgResponse = response.responseText;
											if (msgResponse != "SUCCESS"){
												showMessageBox(msgResponse, imgMessage.ERROR);
												return false;
											} else {
												validateBeforeDeleteItem();
											}
										}
									});
							   },
							   "");
			} else {
				//validateBeforeDeleteItem();
			}
			*/
		}	
	});

	$("btnAddDeleteCancel").observe("click", function() {
		$("addDeleteItemDiv").hide();	
	});
}

function validateBeforeDeleteItem(){
	if ($F("varDiscExist") == "Y"){
		var message = "";
		if ($F("paramAddDeleteSw") == "A"){
			message = "Adding new ";
		} else if ($F("paramAddDeleteSw") == "D"){
			message = "Deleting existing ";
		}
		showConfirmBox("Delete Discounts", message + 
										  'item will result to the deletion of all discounts. ' + 
										  'Do you want to continue ? ',
					   "Yes", "No",
					   delItemDisc,
					   "");
	} else {
		delItemDisc();
	}
}

function delItemDisc(){

	$("delItemDiscSw").value = "Y";
	
	/*
	var result = deleteDiscount();
	if (!result){
		return false;
	} else {
	*/
		var itemNo = "";
		var itemNos = "";
		$("varDiscExist").value = "N";
		$("invoiceSw").value = "Y";
		
		if ($F("paramAddDeleteSw") == "A"){
			$$("div#addDeleteItemDiv div[name=addDeleteItemRow]").each(function (row){
				if (row.down("input", 0).checked == true){
					itemNo = row.down("label", 1).innerHTML;

					$$("div#itemTable div[name='row']").each(function (row){
						if (row.down("input", 1).value == itemNo){
							itemNos = itemNos + itemNo + " ";
						}
					});
				}
			});

			//addItems(itemNos);
			$("addedItemNos").value = itemNos;
			showMessageBox("Items added successfully.", imgMessage.SUCCESS);
			//updateAddDeleteTables(1);
			
		} else if ($F("paramAddDeleteSw") == "D"){

			$$("div#addDeleteItemDiv div[name=addDeleteItemRow]").each(function (row){
				if (row.down("input", 0).checked == true){
					itemNo = row.down("label", 1).innerHTML;
					row.remove();

					$$("div#itemTable div[name='row']").each(function(row) {
						if (row.down("input", 1).value == itemNo) {
							row.remove();
							itemNos = itemNos + itemNo + " ";
						}
					});
				}
			});			

			//deleteItems(itemNos);
			$("deletedItemNos").value = itemNos;
			showMessageBox("Items deleted successfully.", imgMessage.SUCCESS);
			//updateAddDeleteTables(2);
		}	
	//}
}

//ASSIGN_DED_BTN -- when_button_pressed
/*
$("btnAssignDeductibles").observe("click", function() {
	if (parseInt($F("changedFields")) == 0){
		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=confirmAssignDeductibles", { 
			method: "GET",
			parameters: {
				parId: $F("globalParId"),
				itemNo: $F("itemNo")
			},
			asynchronous: false,
			evalScripts: true,
			onSuccess: function(response){
				var expectedResponse = 'Assign Deductibles, will automatically copy the current item deductibles ' +
                  					   'to other items without deductibles yet... ' + 
                  					   'This will automatically be saved/store in the tables. ' + 
                  					   'Do you want to continue?';
				
				//if (expectedResponse == response.ResponseText){
					showConfirmBox("Assign Deductibles", response.responseText,
							       "Yes", "No",
								   //getItemDeductible,
								   assignDeductibles,
								   "");
				//} else {
				//	showMessageBox(response.responseText, imgMessage.INFO);
				//}
			}
		});
	} else {
		showMessageBox('Please save changes first before pressing the ASSIGN DEDUCTIBLES button.', imgMessage.INFO);
	}
});

function assignDeductibles(){
	new Ajax.Request(contextPath + "/GIPIItemMethodController?action=assignDeductibles", {
		method: "GET",
		parameters: {
			parId: $F("globalParId"),
			itemNo: $F("itemNo")
		},
		asynchronous: false,
		evalScripts: true,
		onComplete: function(response){
			showMessageBox("Assigning Deductibles Completed", imgMessage.INFO);
		}
	});
}
*/

/*
function getItemDeductible() {
	var deductibleCd = "";
	var itemNo = "";
	var perilCd = "";
	var perilName = "";
	var dedTitle = "";
	var dedAmount = "0.00";
	var dedRate = "0.00";
	var dedText = "";
	var dedAggregateSw = "";
	var dedCeilingSw = "";
	var dedDeductibleType = "";
	var dedLineCd = "";
	var dedSublineCd = "";
	var dedType = "";
	var content = "";

	var id = "";
	
	$$("div[name='ded2']").each(function (ded){
		if (ded.getAttribute("display") == null){	
			id = ded.getAttribute("id");
			
			deductibleCd = ded.getAttribute("dedCd");
			itemNo = ded.getAttribute("item");
			perilCd = ded.getAttribute("perilCd");
			perilName = $F("dedPerilName2");
			dedTitle = $F("dedTitle2");
			dedAmount = $F("dedAmount2");
			dedRate = $F("dedRate2");
			dedText = $F("dedText2");
			dedAggregateSw = $F("dedAggregateSw2");
			dedCeilingSw = $F("dedCeilingSw2");
			dedDeductibleType = $F("dedDeductibleType2");
			dedLineCd = $F("dedLineCd2");
			dedSublineCd = $F("dedSublineCd2");
			dedType = $F("dedType2");
			
			//var table = $("assignedDedDiv");
			var table = $("wdeductibleListing2");

			$$("div[name='row']").each(function (row){
				if (row.id != "row" + ded.getAttribute("item")){
					var deds = new Element("div");
					deds.setAttribute("id", ded.id);
					deds.setAttribute("perilCd", ded.getAttribute("perilCd"));
					deds.setAttribute("dedCd", ded.getAttribute("dedCd"));
					deds.setAttribute("name", ded.getAttribute("name"));
					deds.setAttribute("class", "tableRow");
					deds.setAttribute("style", "");
					deds.setAttribute("item", row.id.replace("row", ""));

					content = '<input type="hidden" name="dedCd" value=' + deductibleCd + ' />' +
					  		  '<input type="hidden" name="item" value=' + itemNo + ' />' +
					  		  '<input type="hidden" name="perilCd" value=' + perilCd + ' />' +
					  		  '<input type="hidden" name="dedPerilName2" value=' + perilName + ' />' +
					  		  '<input type="hidden" name="dedTitle2" value=' + dedTitle + ' />' +
					  		  '<input type="hidden" name="dedAmount2" value=' + dedAmount + ' />' +
					  		  '<input type="hidden" name="dedRate2" value=' + dedRate + ' />' +
					 	      '<input type="hidden" name="dedText2" value=' + dedText + ' />' +
					 		  '<input type="hidden" name="dedAggregateSw2" value=' + dedAggregateSw + ' />' +
					  		  '<input type="hidden" name="dedCeilingSw2" value=' + dedCeilingSw + ' />' +
					  		  '<input type="hidden" name="dedDeductibleType2" value=' + dedDeductibleType + ' />' +
					  		  '<input type="hidden" name="dedLineCd2" value=' + dedLineCd + ' />' +
					  		  '<input type="hidden" name="dedSublineCd2" value=' + dedSublineCd + ' />' +
					  		  '<input type="hidden" name="dedType2" value=' + dedType + ' />';

					deds.update(content);
					table.insert({bottom : deds});
				}
			});

			/*
			var deds = new Element("div");
			deds.setAttribute("id", ded.id);
			deds.setAttribute("perilCd", ded.getAttribute("perilCd"));
			deds.setAttribute("dedCd", ded.getAttribute("dedCd"));
			//deds.setAttribute("item", ded.getAttribute("item"));
			deds.setAttribute("name", ded.getAttribute("name"));
			deds.setAttribute("display", "none");
			deds.setAttribute("class", "tableRow");
			deds.setAttribute("style", "");
			*/
			
		
			/*content = '<input type="hidden" name="adDedCd" value=' + deductibleCd + '/>' +
					  '<input type="hidden" name="adItemNo" value=' + itemNo + '/>' +
					  '<input type="hidden" name="adPerilCd" value=' + perilCd + '/>' +
					  '<input type="hidden" name="adPerilName" value=' + perilName + '/>' +
					  '<input type="hidden" name="adDedTitle" value=' + dedTitle + '/>' +
					  '<input type="hidden" name="adDedAmount" value=' + dedAmount + '/>' +
					  '<input type="hidden" name="adDedRate" value=' + dedRate + '/>' +
					  '<input type="hidden" name="adDedText" value=' + dedText + '/>' +
					  '<input type="hidden" name="adDedAggregateSw" value=' + dedAggregateSw + '/>' +
					  '<input type="hidden" name="adDedCeilingSw" value=' + dedCeilingSw + '/>' +
					  '<input type="hidden" name="adDedDeductibleType" value=' + dedDeductibleType + '/>' +
					  '<input type="hidden" name="adDedLineCd" value=' + dedLineCd + '/>' +
					  '<input type="hidden" name="adDedSublineCd" value=' + dedSublineCd + '/>' +
					  '<input type="hidden" name="adDedType" value=' + dedType + '/>';*/
	
			//deds.update(content);
			//table.insert({bottom : deds});	
		//}

		//showMessageBox("Assigning Deductibles Completed", imgMessage.INFO);
		
	//});

	/*
	$$("div[name='row']").each(function (row){
		
	});
	*/
//}

	$("btnAssignDeductibles").observe("click", function() {
		if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
			loadDeductibleTables();
		}
		
		var existDed1 = "N"; //value is Y if selected item has existing item level deductible
		var existDed2 = "N"; //value is Y if any of the other items has no existing item level deductible
		var itemNoToCopy = $F("itemNo");
		var copyToItemNos = "";
		var previousItemNo = "";
		
		//Checks if the selected item has an existing item level deductible
		$$("div#wdeductibleListing2 div[name='ded2']").each(function(ded){
			if (ded.down("input", 0).value == itemNoToCopy){
				existDed1 = "Y";
			}
		});
		
		//Checks if there are items without any item level deductible; 
		//If so, list of item numbers are saved in copyToItemNos separated by commas(",")
		$$("div#parItemTableContainer div[name='row']").each(function(itm){
			if (itm.down("input", 1).value != itemNoToCopy){
				var itemHasDeductibles = "N";
				$$("div#wdeductibleListing2 div[name='ded2']").each(function(ded){
					if (ded.down("input", 0).value == itm.down("input", 1).value){
						itemHasDeductibles = "Y";
					}
				});
		
				if ("N" == itemHasDeductibles){
					existDed2 = "Y";
					if (itm.down("input", 1).value != previousItemNo){
						if ("" != copyToItemNos){
							copyToItemNos = copyToItemNos + "," + itm.down("input", 1).value;
						} else {
							copyToItemNos = itm.down("input", 1).value;
						}
					}
					previousItemNo = itm.down("input", 1).value;
				}
			}
		});
		
		if ("N" == existDed1){
			showMessageBox("Item "+(parseInt(itemNoToCopy)).toPaddedString(2)+" has no existing deductible(s). You cannot assign a null deductible(s).", imgMessage.INFO);
		} else if ("N" == existDed2){
			showMessageBox("All existing items already have deductible(s).", imgMessage.INFO);
		} else if (("Y" == existDed1)&&("Y" == existDed2)){
			$("itemWODed").value = copyToItemNos;
			var message = "Assign Deductibles, will copy the current item deductibles to other items without deductibles yet. Do you want to continue?";
			showConfirmBox("Assign Deductibles", message, "Yes", "No", assignDeductibles, stopProcess);
		}
	});

	function assignDeductibles(){
		var copyToItemNos = $F("itemWODed");
		var itemNos = copyToItemNos.split(",");
		for (var x=0; x<(itemNos.length); x++){
			copyDeductiblesOfItem($F("itemNo"), itemNos[x], 2);
		}
		showMessageBox("Deductibles has been assigned.", imgMessage.SUCCESS);
	}

	function copyDeductiblesOfItem(copyFromItemNo, copyToItemNo, dedLevel){
		$$("div#deductiblesTable"+dedLevel+" div[item='"+copyFromItemNo+"']").each(function(a){
			var itemNo 			= copyToItemNo;
			var perilCd 		= a.down("input", 2).value;
			var perilName 		= a.down("input", 1).value;		
			var deductibleTitle = a.down("input", 3).value;
			var deductibleCd 	= a.down("input", 4).value;
			var	deductibleType	= a.down("input", 10).value;
			var deductibleAmt 	= a.down("input", 5).value;
			var deductibleRate 	= a.down("input", 6).value;
			var deductibleText 	= a.down("input", 7).value;
			var aggregateSw 	= a.down("input", 8).value;
			var ceilingSw		= a.down("input", 9).value;
			var id = dedLevel + itemNo + perilCd + deductibleCd;
			var insContent = '<input type="hidden" id="insDedItemNo'+id+'" 			name="insDedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
				 '<input type="hidden" id="insDedPerilName'+id+'" 		name="insDedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
				 '<input type="hidden" id="insDedPerilCd'+id+'" 		name="insDedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
				 '<input type="hidden" id="insDedTitle'+id+'" 			name="insDedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
				 '<input type="hidden" id="insDedDeductibleCd'+id+'"	name="insDedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
				 '<input type="hidden" id="insDedAmount'+id+'" 			name="insDedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
				 '<input type="hidden" id="insDedRate'+id+'"			name="insDedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
				 '<input type="hidden" id="insDedText'+id+'"			name="insDedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
				 '<input type="hidden" id="insDedAggregateSw'+id+'"		name="insDedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
		 		 '<input type="hidden" id="insDedCeilingSw'+id+'"		name="insDedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
		 		 '<input type="hidden" id="insDedDeductibleType'+id+'" 	name="insDedDeductibleType'+dedLevel+'"	value=""'+deductibleType+'" />';
			var content = '<input type="hidden" name="dedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
				 '<input type="hidden" name="dedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
				 '<input type="hidden" name="dedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
				 '<input type="hidden" name="dedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
				 '<input type="hidden" name="dedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
				 '<input type="hidden" name="dedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
				 '<input type="hidden" name="dedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
				 '<input type="hidden" name="dedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
				 '<input type="hidden" name="dedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
				 '<input type="hidden" name="dedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
				 '<input type="hidden" name="dedDeductibleType'+dedLevel+'"	value=""'+deductibleType+'" />' +
				 (1 < dedLevel ? '<label style="width: 36px; text-align: right; margin-right: 10px;">'+itemNo+'</label>' : "") +								  
				 (3 == dedLevel ? '<label style="width: 160px; text-align: left; " title="'+perilName+'">'+perilName.truncate(20, "...")+'</label>' : "") +	
				 '<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'">'+deductibleTitle.truncate(25, "...")+'</label>'+		
				 '<label style="width: 119px; text-align: right;">'+(deductibleRate == "" ? "-" : formatToNineDecimal(deductibleRate))+'</label>'+
				 '<label style="width: 119px; text-align: right;">'+(deductibleAmt == "" ? "-" : formatCurrency(deductibleAmt))+'</label>'+							 
				 '<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
				 '<label style="width: 33px; text-align: center;">';

			if (aggregateSw == 'Y') {
				content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;  " />';
			} else {
				content += '<span style="width: 33px; height: 10px; text-align: left; display: block; margin-left: 3px;"></span>';
			}
			if(1 == dedLevel){
				content += '</label><label style="width: 20px; text-align: center;">';
				if (ceilingSw == 'Y') {
					content += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;" />';
				}
			}
			content += '</label>';

			var newTaxDiv = new Element('div');
			newTaxDiv.setAttribute("name", "ded"+dedLevel);
			newTaxDiv.setAttribute("id", "ded"+id);
			newTaxDiv.setAttribute("item", itemNo);
			newTaxDiv.setAttribute("dedCd", deductibleCd);
			newTaxDiv.addClassName("tableRow");
			newTaxDiv.setStyle("display: none;");

			newTaxDiv.update(content);
			$("wdeductibleListing"+dedLevel).insert({bottom: newTaxDiv});
					
			newTaxDiv.observe("mouseover", function ()	{
				newTaxDiv.addClassName("lightblue");
			});
			
			newTaxDiv.observe("mouseout", function ()	{
				newTaxDiv.removeClassName("lightblue");
			});
			
			newTaxDiv.observe("click", function ()	{
				newTaxDiv.toggleClassName("selectedRow");
				if (newTaxDiv.hasClassName("selectedRow"))	{
					$$("div[name='ded"+dedLevel+"']").each(function (li)	{
							if (newTaxDiv.getAttribute("id") != li.getAttribute("id"))	{
							li.removeClassName("selectedRow");
						}
					});	
					setDeductibleForm(newTaxDiv, dedLevel);
				} else {
					setDeductibleForm(null, dedLevel);
				}
			});

			checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);						
			setTotalAmount(dedLevel, itemNo, perilCd);
			var temp = $F("tempDeductibleItemNos").blank() ? "" : $F("tempDeductibleItemNos");
			$("tempDeductibleItemNos").value = temp + $F("inputDeductible"+dedLevel) + " ";

			var forInsertDiv = $("dedForInsertDiv"+dedLevel);
			var newInsDiv = new Element('div');
			newInsDiv.setAttribute("name", "insDed"+dedLevel);
			newInsDiv.setAttribute("id", "insDed"+id);
			newInsDiv.setStyle("display: none;");
			newInsDiv.update(insContent);			
			forInsertDiv.insert({bottom: newInsDiv});						

			setDeductibleForm(null, dedLevel);
		});
	}

//end angelo

//BUT_OTHER_INFO -- when_button_pressed
$("btnOtherDetails").observe("click", function() {
	if ($F("itemNo").blank()) {
		showMessageBox("Please enter item number first.", imgMessage.ERROR);
		return false;
	} else {
		showOtherInfoEditor("otherInfo", 2000);
	}
});

$("btnAttachMedia").observe("click", function(){
	// openAttachMediaModal("par");
	openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
});

function stopProcess(){
	hideNotice("");
	return false;
}	

</script>