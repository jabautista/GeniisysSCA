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
<div class="sectionDiv" id="itemInformationDiv">
	<jsp:include page="/pages/underwriting/endt/common/subPages/endtItemInformationListingTable.jsp"></jsp:include>
	<div style="margin: 10px;" id="parItemForm">
		<c:choose>
			<c:when test="${lineCd eq 'MC'}">
				<!-- MOTORCAR ADDITIONAL INFO -->
				<input type="hidden" id="motorNumbers"			name="motorNumbers"			value="${motorNumbers}" />
				<input type="hidden" id="serialNumbers"			name="serialNumbers"		value="${serialNumbers}" />
				<input type="hidden" id="plateNumbers"			name="plateNumbers"			value="${plateNumbers}" />
				<!-- END FOR MOTORCAR ADDITIONAL -->
				
				<!-- MC Module Variables Gipis060 -->
				<input type="hidden" name="vDisplayMotor" id="vDisplayMotor" value="${vDisplayMotor}"/>
				<input type="hidden" name="vGenerateCOCSerial" id="vGenerateCOCSerial" value="${vGenerateCOCSerial}"/>
				<input type="hidden"    name="varSublineMotorcycle"		id="varSublineMotorcycle" 	value="${vMotorCycle }" />
				<input type="hidden"    name="varSublineCommercial"		id="varSublineCommercial" 	value="${vCommercialVehicle }" />
				<input type="hidden"    name="varSublinePrivate"		id="varSublinePrivate" 	value="${vPrivateCar }" />
				<input type="hidden"    name="varSublineLto"			id="varSublineLto" 	value="${vLto }" />
				<input type="hidden"    name="varCocLto"				id="varCocLto" 	value="${vCocLto }" />
				<input type="hidden"    name="varCocNlto"				id="varCocNlto" 	value="${vCocNlto }" />
				<!-- End for MC Module Variables Gipis060 -->
			</c:when>
			<c:when test="${lineCd eq 'FI'}">
				<!-- FIRE ADDITIONAL INFO -->
				<input type="hidden" id="maxRiskItemNo"			name="maxRiskItemNo"		value="${maxRiskItemNo}" />
				<input type="hidden" id="mailAddr1"				name="mailAddr1"			value="${mailAddr1}" />	
				<input type="hidden" id="mailAddr2"				name="mailAddr2"			value="${mailAddr2}" />
				<input type="hidden" id="mailAddr3"				name="mailAddr3"			value="${mailAddr3}" />
				<input type="hidden" id="riskNumbers"			name="riskNumbers"			value="${riskNumbers}" />
				<input type="hidden" id="riskItemNumbers"		name="riskItemNumbers"		value="${riskItemNumbers}" />
				<!-- END FOR FIRE ADDITIONAL -->
			</c:when>
		</c:choose>		
		
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
		<c:if test="${lineCd ne 'FI'}">
			<input type="hidden" id="regionCd"			name="regionCd"			 value="" />
			<input type="hidden" id="riskNo"			name="riskNo"			 value="" />
			<input type="hidden" id="riskItemNo"		name="riskItemNo"		 value="" />
		</c:if>
		<c:if test="${lineCd eq 'MN'}">
			<input type="hidden" id="coverageCd"		name="coverageCd"		 value="" />
		</c:if>
		<!-- variables in oracle forms -->
		<!-- <input type="hidden" id="varEndtTaxSw"			name="varEndtTaxSw" 		value="" /> --> 
		
		<!-- parameters in oracle forms -->
		<input type="hidden" id="parametersOtherSw"		name="parametersOtherSw"	value="N" />
		<input type="hidden" id="parametersDDLCommit"	name="parametersDDLCommit"	value="N" />
		<input type="hidden" id="varVCopyItem"	name="varVCopyItem"	value="" />
		
		<!-- miscellaneous variables -->
		<input type="hidden" id="currencyListIndex"		name="currencyListIndex"	value="0" />
		<input type="hidden" id="lastRateValue"			name="lastRateVal"	value="0" />
		<input type="hidden" id="lastItemNo" 			name="lastItemNo" 			value="${lastItemNo}" />
		<input type="hidden" id="itemNumbers" 			name="itemNumbers" 			value="${itemNumbers}" />
		<input type="hidden" id="perilExists" 			name="perilExists" 			value="N" />
		<input type="hidden" id="addDeletePageLoaded" 	name="addDeletePageLoaded" 	value="N" />
		<input type="hidden" id="addtlInfoValidated" 	name="addtlInfoValidated" 	value="N" />
		
		<table width="100%" cellspacing="1" border="0">					
			<tr>				
				<td class="rightAligned" style="width: 20%;">Item No. </td>
				<td class="leftAligned" style="width: 20%;"><input type="text" tabindex="1" style="width: 100%; padding: 2px;" id="itemNo" name="itemNo" class="required" maxlength="9"/></td>
				<td class="rightAligned" style="width: 10%;">Item Title </td>
				<td class="leftAligned"><input type="text" tabindex="2" style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="250" /></td>
				<td rowspan="6"  style="width: 20%;">
					<table cellpadding="1" border="0" align="center">
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 		class="disabledButton" value="Copy Item Info" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 		class="disabledButton" value="Copy Item/Peril Info" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnNegateItem" 		name="btnWItem" 		class="disabledButton" value="Negate/Remove Item" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnDeleteAddAllItems" 	name="btnDeleteAddAllItems" 				   class="button" value="Delete/Add All Items"/></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 		class="disabledButton" value="Assign Deductibles" disabled="disabled" /></td></tr>						
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 		class="disabledButton" value="Other Details" disabled="disabled" /></td></tr>
						<c:if test="${lineCd eq 'MC'}">
							<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 		class="disabledButton" value="Attach Media" disabled="disabled" /></td></tr>
						</c:if>
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
				<td class="rightAligned" style="width: 10%;">Rate </td>
				<td class="leftAligned" style="width: 20%;">
					<input type="text" tabindex="6" style="width: 100%; padding: 2px;" id="rate" name="rate" class="moneyRate required" maxlength="12" value="<c:if test="${not empty item }">${item[0].currencyRt }</c:if>"/>
				</td>
			</tr>
			<tr>
				<c:if test="${lineCd ne 'MN'}">
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
				</c:if>
				<c:if test="${lineCd eq 'MN'}">
					<td class="rightAligned" style="width: 20%;">Region </td>
					<td class="leftAligned"  style="width: 20%;">
						<select tabindex="7" id="region" name="region" style="width: 100%;">
							<option value=""></option>
							<c:forEach var="regions" items="${regions}">
								<option value="${regions.regionCd}"
								<c:if test="${item.regionCd == regions.regionCd}">
									selected="selected"
								</c:if>>${regions.regionDesc}</option>				
							</c:forEach>
						</select>
					</td>
				</c:if>						
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
				<td class="rightAligned" style="width: 20%; display: none;">Effectivity Dates </td>
				<td colspan="3" class="leftAligned" style="display: none;">
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
		</table>
		<table style="margin:auto; width:55%" border="0">
			<tr>
				<td class="rightAligned">
				
				<!--  commented out for now, just add if statements for specific lineCDS
					<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" disabled="disabled" />W/ Surcharge &nbsp; &nbsp; &nbsp;
					<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" disabled="disabled" />W/ Discount &nbsp; &nbsp; &nbsp;-->
					
					<c:if test="${lineCd ne 'AV'}"><input type="checkbox" id="chkIncludeSw" name="chkIncludeSw" 	value="N" />Include Additional Info.</c:if>
					<!--<c:if test="${lineCd eq 'AV'}"><input type="hidden" id="chkIncludeSw" name="chkIncludeSw" 	value="" /></c:if>-->
				</td>
			</tr>
			<tr>
				<td colspan="4" style="text-align:center;">
					<input type="button" style="width: 100px;" id="btnSaveItem" class="button" value="Add" />
					<input type="button" style="width: 100px;" id="btnDelete" class="disabledButton" value="Delete" disabled="disabled" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	//initializeTable("tableContainer", "row", "");	

	if ($F("globalLineCd") == "MC") {
		$("btnAttachMedia").observe("click", function() {
			// openAttachMediaModal("par");
			openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
		});
	}

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

	$$("input[name='motorItemAddtl']").each(function(row) {
		row.observe("focus", function() {
			//WHEN-NEW-RECORD-INSTANCE for :B580 (GIPI_WVEHICLE)
			if (parseInt($F("changedFields")) > 0 && $F("cocType").blank() && $F("addtlInfoValidated") == "N" && !$F("itemNo").blank()) {
				Ajax.Updater("addDeleteItemDiv", contextPath+"/GIPIParMCItemInformationController?action=validateEndtMotorItemAddtlInfo", {
						evalScripts : true,
						asynchronous : false,
						method : "GET",
						parameters : {
							globalParId : $F("globalParId"),
							itemNo : $F("itemNo"),
							towing : $F("towLimit"),
							cocType : $F("cocType"),
							plateNo : $F("plateNo")
						},
						onCreate : function() {
							showNotice("Validating motor item additional info. Please wait...");
						},
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								hideNotice("");
								var resXML = response.responseXML;
								$("towLimit").value = resXML.getElementsByTagName("towing")[0].childNodes[0].nodeValue;
								$("cocType").value = resXML.getElementsByTagName("cocType")[0].childNodes[0].nodeValue;
								$("plateNo").value = resXML.getElementsByTagName("plateNo")[0].childNodes[0].nodeValue;
							}
						}
				});
	
				$("addtlInfoValidated").value = "Y";
			}
		});
	});

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
				if ($F("varDeductibleExist") == "Y") {
					if ($F("varDeductibleExist") == "Y") {
						showConfirmBox("Delete item", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
								"Yes", "No", deleteRecord, "");
					}
				} else {
					deleteRecord();
				}
		});

	//B480.ITEM_NO - when_validate_item
	$("itemNo").observe("change", function() {
		var itemNoDeleted = false;
		
		if (!isNumber("itemNo", "Invalid input. Value should be a number.", "messageBox")) {
			$("itemNo").focus();
			//return false; --temporarily removed
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
		
		if ($F("varNewSw2") == "N") {
			return false;
		}

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
						hideNotice("Done!");
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
			
			if ($F("globalLineCd") == "MC") {
				new Ajax.Updater("addDeleteItemDiv", contextPath+"/GIPIParMCItemInformationController?action=validateEndtParMCItemNo", {
					evalScripts : true,
					asynchronous : false,
					method : "GET",
					parameters : {
						globalParId : $F("globalParId"),
						itemNo : $F("itemNo"),
						dfltCoverage : $F("paramDfltCoverage"),
						expiryDate : $F("varExpiryDate")
					},
					onCreate : function() {
						showNotice("Validating item no. Please wait...");
					},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							var msg = response.responseText;
							hideNotice("Done!");
	
							if (msg != "SUCCESS") {
								$("itemNo").value = "";
								showMessageBox(msg, imgMessage.ERROR);
							} else {
								if (newItem) {
									$$("div[name='towingParams']").each(function(row) {
										if (row.down("input", 0).value == "TOWING LIMIT - CVP" && $F("sublineCd") == $F("varSublineCommercial")) {
											$("towLimit").value = formatCurrency(parseFloat(row.down("input", 1).value.replace(/,/g,"")));
										} else if (row.down("input", 0).value == "TOWING LIMIT - LTO" && $F("sublineCd") == $F("varSublineLto")) {
											$("towLimit").value = formatCurrency(parseFloat(row.down("input", 1).value.replace(/,/g,"")));
										} else if (row.down("input", 0).value == "TOWING LIMIT - MCL" && $F("sublineCd") == $F("varSublineMotorcycle")) {
											$("towLimit").value = formatCurrency(parseFloat(row.down("input", 1).value.replace(/,/g,"")));
										} else if (row.down("input", 0).value == "TOWING LIMIT - PC" && $F("sublineCd") == $F("varSublinePrivate")) {
											$("towLimit").value = formatCurrency(parseFloat(row.down("input", 1).value.replace(/,/g,"")));
										} else if (row.down("input", 0).value == "TOWING LIMIT - CVP"
											|| row.down("input", 0).value == "TOWING LIMIT - LTO"
											|| row.down("input", 0).value == "TOWING LIMIT - MCL"
											|| row.down("input", 0).value == "TOWING LIMIT - PC" &&
											!$F("packLineCd").blank() && !$F("packSublineCd").blank()) {
												$("towLimit").value = formatCurrency(parseFloat(row.down("input", 1).value.replace(/,/g,"")));
										}
									});
								} else {
									result = false;
								}
								
								$("deductibleAmount").value = $F("deductibleAmount").blank() ? "0.00" : $F("deductibleAmount");
								$("repairLimit").value = formatCurrency(parseFloat($F("deductibleAmount")) + ($F("towLimit").blank() ? "0.00" : parseFloat($F("towLimit"))));
								$("recFlag").value = "A"; 
							}
						} else {
							hideNotice("");
						}
					}
				});
			} else if ($F("globalLineCd") == "FI") {
				if (newItem) {
					$("recFlag").value = "A";
					$("riskNo").value = 1;
					$("riskItemNo").value = $F("itemNo");

					if ($F("address1").blank() && $F("address2").blank() && $F("address3").blank()) {
						$("locRisk1").value = $F("polbasicAddress1");
						$("locRisk2").value = $F("polbasicAddress2");
						$("locRisk3").value = $F("polbasicAddress3");
					} else {
						$("locRisk1").value = $F("address1");
						$("locRisk2").value = $F("address2");
						$("locRisk3").value = $F("address3");
					}

					if ($F("locRisk1").blank() && $F("locRisk2").blank() &&$F("locRisk3").blank()) {
						$("locRisk1").value = $F("assdAddress1");
						$("locRisk2").value = $F("assdAddress2");
						$("locRisk3").value = $F("assdAddress3");
					}
				} else {
					result = false;
				}
			}
		}
	});
	// end of item # change.
	//B480.ITEM_DESC2 - key_next_item
	$("itemDesc2").observe("blur", function() {
		if($F("perilExists") == "Y") {
			$("coverage").focus();
		}

		if ($F("globalLineCd") == "FI") {
			if ($F("annTsiAmt") != 0 || $F("recFlag") != "A") {
				$("coverage").focus();
			}
		}
	});

	//B480.CURRENCY_CD, B480.CURRENCY_DESC, B480.DSP_CURRENCY_DESC - pre_text_item, post_text_item
	$("currency").observe("change", function() {
		var lastIndex = $F("currencyListIndex");

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
/*
	$("chkIncludeSw").observe("click", function() {
		if ($("chkIncludeSw").checked) {
			$("cgCtrlIncludeSw").value = "Y";
		} else  {
			$("cgCtrlIncludeSw").value = "N";
		}
	});*/

	//COPY_PERIL_BTN - when_button_pressed
	$("btnCopyItemPerilInfo").observe("click", function() {
		if ($F("itemNo").blank()) {
			showMessageBox("Please enter item number first.", imgMessage.ERROR);
			return false;
		} else if (parseInt($F("changedFields")) > 0 || $$("input[name='delItemNos']").size() > 0) {
			showMessageBox("Please save changes first before pressing the COPY ITEM/PERIL button.", imgMessage.INFO);
			return false;
		} else {
			copyItemProcedure("PERIL");
		}
	});

	//COPY_ITEM_BTN - when_button_pressed
	$("btnCopyItemInfo").observe("click", function() {
		if ($F("itemNo").blank()) {
			showMessageBox("Please enter item number first.", imgMessage.ERROR);
			return false;
		} else if (parseInt($F("changedFields")) > 0 || $$("input[name='delItemNos']").size() > 0) {
			showMessageBox("Please save changes first before pressing the COPY ITEM button.", imgMessage.INFO);
			return false;
		} else {
			copyItemProcedure("ITEM");
		}
	});

	//NEG_ITEM_BTN - when_button_pressed
	$("btnNegateItem").observe("click", function() {
		if ($F("itemNo").blank()) {
			showMessageBox("Please enter item number first.", imgMessage.ERROR);
			return false;
		}
		
		var result = true;
		
		if ($F("recFlag") == "A") {
			showMessageBox("Item Negation is not available for additional item.", imgMessage.INFO);
			return false;
		}

		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=validateItemForNegation",{
			method : "GET",
			parameters : {
				itemNo : $F("itemNo"),
				parId : $F("globalParId")
			},					
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				showNotice("Validating item for negation. Please wait.");
			},
			onComplete : function(response){
				hideNotice("Done!");
				var msg = response.responseText;
				if (msg != "SUCCESS") {
					showMessageBox(msg, imgMessage.ERROR);
					result = false;
				}
			}
		});

		if (!result) {
			return false;
		} else {
			if ($F("varDiscExist") == "Y") {
				showConfirmBox("Negate Item", "Negating an item will cause the deletion of all discounts. Do you want to continue ?", "Yes", "No",
				 function() {
					 $("varDiscExist").value = "N";
					 negateItem();
				 },
				 "");
			} else {
				negateItem();
			}
		}
	});

	$("btnDeleteAddAllItems").observe("click", function() {
		if ("${isPack}" == "Y") {  //Deo [03.03.2017]: SR-23874
            showConfirmBox("Confirmation", "You are not allowed to Delete/Add items here. "
            	+ "Delete/Add items in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;
        }
		if (parseInt($F("changedFields")) == 0) {
			showConfirmBox3("Delete/Add All Items", "What processing would you like to perform?", "Add", "Delete",
					function() {
						deleteAddAllItems(1);
					},
					function() {
						deleteAddAllItems(2);
					}
			);
		} else {
			showMessageBox("Please save changes first before pressing the DELETE/ADD ALL ITEMS button.", imgMessage.INFO);
		}
	});

	$("btnAssignDeductibles").observe("click", function() {
		if ($F("itemNo").blank()) {
			showMessageBox("Please enter item number first.", imgMessage.ERROR);
			return false;
		}else if (parseInt($F("changedFields")) == 0) {
			new Ajax.Request(contextPath + "/GIPIItemMethodController?action=confirmAssignDeductibles",{
				method : "GET",
				parameters : {
					parId : $F("globalParId"),
					itemNo : $F("itemNo")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : showNotice("Checking Deductibles, please wait..."),
				onComplete : 
					function(response){
						hideNotice("Done!");
						var expectedResponse = 	'Assign Deductibles, will automatically copy the current item deductibles ' +
												'to other items without deductibles yet... This will automatically be saved/store in the tables. ' +
												'Do you want to continue?';
						
						if(response.responseText == expectedResponse){
							/* temporary used javascript built-in confirm method */
							showConfirmBox("Assign Deductibles", 
									"Assign Deductibles, will automatically copy the current item deductibles to other items without deductibles yet... " + 
					                 "This will automatically be saved/store in the tables.\nDo you want to continue?",
					                 "Yes", "No", assignDeductibles,"");
						} else{							
							showMessageBox(response.responseText, imgMessage.INFO);						
						}
					}
			});
		} else {
			showMessageBox("Please save changes first before pressing the DELETE/ADD ALL ITEMS button.", imgMessage.INFO);
		}
	});

	$("btnOtherDetails").observe("click", function() {
		if ($F("itemNo").blank()) {
			showMessageBox("Please enter item number first.", imgMessage.ERROR);
			return false;
		} else {
			//show the Other Details window here
		}
	});

	//for fire item additional LOV's
	
	if ($F("globalLineCd") == "FI") {
		$("province").observe("change", function () {
			filterCityByProvince();
			filterDistrictByProvinceByCity();
			filterBlock();
			filterRisk();
		});

		$("city").observe("change", function() {
			filterDistrictByProvinceByCity();
			filterBlock();
			filterRisk();
		});

		$("district").observe("change", function() {
			filterBlock();
			filterRisk();
		});

		$("block").observe("change", function() {
			filterRisk();
		});
	}

	//other functions
	
	function removeItemFromList(itemNo) {
		$$("div#itemTable div[name='row']").each(function(row) {
			if (row.down("input", 1).value == itemNo) {
				row.remove();
			}
		});
	}

	function supplyItemInfo(blnApply, row, itemNo){

		var itemFromDate = $F("fromDate");
		var itemToDate = $F("toDate");
		var regionCd = ($F("globalLineCd") == "FI") ? "regionCd" : "region";
		var coverage = $F("globalLineCd") == "MN" ? "coverageCd" : "coverage";
		var itemFields = ["itemNo", "itemTitle", "itemGrp", "itemDesc", 
		                  "itemDesc2", "tsiAmt", "premAmt", "annPremAmt",	
		                  "annTsiAmt", "recFlag",	"currency", "rate", 
		                  "groupCd", "fromDate", "toDate", "packLineCd", 
		                  "packSublineCd", "discountSw", coverage, "otherInfo", 
		                  "surchargeSw", regionCd, "changedTag", "prorateFlag", 
		                  "compSw", "shortRtPercent",	"packBenCd", "paytTerms", 
		                  "riskNo", "riskItemNo"];
		
        if(blnApply){            
//        	for(var index=0, length=30; index<length; index++){
//             	$(itemFields[index]).value =  row.down("input", index+1).value;
        	for(var index=0, length=itemFields.length; index<length; index++){
        		if($(itemFields[index]) == null){

        		}
            	$(itemFields[index]).value =  row.down("input", index+1).value;
            }
        	$("rate").value = formatToNineDecimal(row.down("input", 12).value);
        	$("tsiAmt").value = formatCurrency(row.down("input", 6).value);
        	$("premAmt").value = formatCurrency(row.down("input", 7).value);
        	$("annPremAmt").value = formatCurrency(row.down("input", 8).value);
        	$("annTsiAmt").value = formatCurrency(row.down("input", 9).value);
        	$("shortRtPercent").value = formatCurrency(row.down("input", 26).value);
        } else{            
        	for(var index=0, length=29; index<length; index++){
    			$(itemFields[index]).value = "";    			
            }
            
            $("itemNo").value = itemNo;            
        	$("recFlag").value = "A";
        	$("rate").value = formatToNineDecimal("1.00");
        	$("fromDate").value = itemFromDate;
        	$("toDate").value = itemToDate;
        }

        if($F("globalLineCd") == "MC" /*&& itemNumbers.indexOf(itemNo) > 0 (motorNo != null && motorNo != "")*/){			
			suppyVehicleInfo(blnApply, row);
		} else if($F("globalLineCd") == "FI"){
			supplyFireInfo(blnApply, row);
			if(!blnApply){				
				$("riskNo").value	= "1";			
				$("fireFromDate").value = $F("fromDate");
				$("fireToDate").value = $F("toDate");
				$("locRisk1").value	= $F("mailAddr1");
				$("locRisk2").value	= $F("mailAddr2");
				$("locRisk3").value	= $F("mailAddr3");
			}
		} else if ($F("globalLineCd") == "MN") {
			supplyMarineCargoInfo(blnApply, row);
			$("fromDate").value = itemFromDate;
        	$("toDate").value = itemToDate;
		}
	}

	/* this is for MOTOR CAR */
	function suppyVehicleInfo(blnApply, row){
		var vehicleFields1 = ["assignee", "acquiredFrom", "motorNo", "origin",
		                      "destination", "typeOfBody", "plateNo", "modelYear",
		                      "carCompany", "mvFileNo", "noOfPass", "makeCd",
		                      "basicColor"];

	    if(blnApply){
			for(var index=0, length=13; index<length; index++){
				$(vehicleFields1[index]).value = row.down("input", index + 31).value;
			}

			if(row.down("input", 42).value.trim() != ""){
				filterMakes(row.down("input", 42).value); /*makeCd*/
			}
			if (!($("accessory").empty())){
				computeTotalAmountInTable("accessoryTable","acc",4,"item",$F("itemNo"),"accTotalAmtDiv");	
				filterLOV("selAccessory","acc",2,"","item",$F("itemNo"));	
			}
	    } else{
	    	for(var index=0, length=13; index<length; index++){
				$(vehicleFields1[index]).value = "";
			}     
	    }

	    var vehicleFields2 = ["colorCd", "engineSeries", "motorType", "unladenWt",
	                          "towLimit", "serialNo", "sublineType", "deductibleAmount",
	                          "cocType", "cocSerialNo", "cocYY", "ctv", 
	                          "repairLimit"];

	    if(blnApply){
	    	for(var index=0, length=13; index<length; index++){
				$(vehicleFields2[index]).value = row.down("input", index + 45).value;;
			}
	    	$("ctv").checked = row.down("input", 56).value == 'Y' ? true : false;

	    	if(row.down("input", 45).value.trim() != ""){
	    		filterColors(row.down("input", 45).value); /*colorCd*/
	    	}
	    } else{
	    	for(var index=0, length=13; index<length; index++){
				$(vehicleFields2[index]).value = "";
			}
	    	$("towLimit").value = "0.00";
			$("deductibleAmount").value = "0.00";
			$("cocType").value = "NLTO";
			$("ctv").checked = false;
			$("repairLimit").value = "0.00";
	    }
	}

	function filterColors(paramVal){		
		new Ajax.Updater($("colorCd").up("td", 0), contextPath + "/GIPIQuotationMotorCarController?action=filterColors", {
			method : "GET",
			parameters : {
				basicColorCd : $("basicColor").options[$("basicColor").selectedIndex].text
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : 
				function(){					
					$("colorCd").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");					
				},
			onComplete:
				function(){
					$("colorCd").value = paramVal;
					$("isLoaded").value = 1;									
				}
		});
	}
	/* end for MOTOR CAR */

	function setDefaultValues(){
		//$("itemNo").value 			= $F("itemNo");
		var lineCd = $F("globalLineCd");

		if (lineCd == "CA"){
			var ora2010Sw = $F("ora2010Sw");
		}	
		
		$$("input[type=text]").each(
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

		$$("textarea").each(function(ta){
			ta.value = "";
		});
		
		$$("select").each(
			function(elem){
				elem.value = "";
			}
		);
		
		$("currency").value 		= 1;
		(lineCd != "MN" ? $("coverage").value = "" : "");

		if(lineCd == "MC"){
			$("typeOfBody").value		= "";
			$("carCompany").value		= "";
			$("makeCd").value			= "";
			$("basicColor").value		= "";
			$("colorCd").value			= "";
			$("motorType").value		= "";
			$("sublineType").value		= "";
			$("cocType").value			= "NLTO";
			$("ctv").checked			= false;
		/*}else if(lineCd == "FI"){
			$("riskNo").value	= "1";				
			$("fireFromDate").value = $F("fromDate");
			$("fireToDate").value = $F("toDate");
			$("locRisk1").value	= $F("mailAddr1");
			$("locRisk2").value	= $F("mailAddr2");
			$("locRisk3").value	= $F("mailAddr3"); */
		} else if(lineCd == "MN"){
			$("invCurrRt").value 		= ""; //formatToNineDecimal(0);
			$("invoiceValue").value 	= ""; //formatCurrency(0);
			$("markupRate").value 		= ""; //formatToNineDecimal(0);
			$("recFlagWCargo").value 	= "A";
			$("cpiRecNo").value		 	= "";
			$("cpiBranchCd").value		= "";
			$("deductText").value		= "";
			$("deleteWVes").value		= "";
			$("printTag").value 		= "1";
			showListing($("vesselCd"));
			hideListing($("cargoType"));
			$("listOfCarriersPopup").hide();
			$("paramVesselCd").value    = "";
			$("deductibleRemarks").value = ""; //andrew 08.09.2010
		/*} else if (lineCd == "AV"){
			clearAviationModule();
			aviationFilterLOV();
		} else if (lineCd == "CA"){
			clearCasualtyModule();
			$("ora2010Sw").value = ora2010Sw;
		} else if (lineCd == "AH"){
			clearAccidentModule();*/
		}
			
		$$("div#itemTable div[name='row']").each(function (div) {
			div.removeClassName("selectedRow");
		});	
		$("parNo").value = $F("globalParNo");
		$("assuredName").value = $F("globalAssdName");
		$("policyNo").value = $F("vPolicyNo");
		$("recFlag").value = "A";
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
			var tsiAmt 			= "0.00"; //($("tsiAmt").value != "" ? $("tsiAmt").value : "0.00"); //"0.00";
			var premAmt 		= "0.00"; //($("premAmt").value != "" ? $("premAmt").value : "0.00"); //"0.00";
			var annPremAmt 		= "0.00"; //($("annPremAmt").value != "" ? $("annPremAmt").value : "0.00"); //"0.00";
			var annTsiAmt 		= "0.00"; //($("annTsiAmt").value !="" ? $("annTsiAmt").value : "0.00"); //"0.00";
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
			var otherInfo 		= "";
			var surchargeSw 	= "";
			var regionCd 		= (lineCd == "FI") ? $F("regionCd") : $F("region");
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
			
			if(lineCd == 'MC'){
				var assignee 			= $F("assignee");
				var acquiredFrom		= $F("acquiredFrom");
				var motorNo				= $F("motorNo");
				var origin				= $F("origin");
				var destination			= $F("destination");
				var typeOfBody			= $F("typeOfBody");
				var plateNo				= $F("plateNo");
				var modelYear			= $F("modelYear");
				var carCompany			= $F("carCompany");
				var mvFileNo			= $F("mvFileNo");
				var noOfPass			= $F("noOfPass");
				var makeCd				= $F("makeCd");			
				var basicColor			= $F("basicColor");
				var color				= $("colorCd").options[$("colorCd").selectedIndex].text;
				var colorCd				= $F("colorCd");
				var engineSeries		= $F("engineSeries");
				var motorType			= $F("motorType");
				var unladenWt			= $F("unladenWt");
				var towLimit			= $F("towLimit");
				var serialNo			= $F("serialNo");
				var sublineType			= $F("sublineType");
				var deductibleAmount	= $F("deductibleAmount");
				var cocType				= $F("cocType");
				var cocSerialNo			= $F("cocSerialNo");
				var cocYY				= $F("cocYY");
				var ctv					= $("ctv").checked ? 'Y' : 'N';
				var repairLimit			= $F("repairLimit");
				var sublineCd			= $F("sublineCd") /* $F("globalSublineCd") */;			
				var cocSerialSw			= 'N';
				var motorCoverage		= null;
				var estValue			= "0.00";
				var tariffZone			= "";
				var cocIssueDate		= null;
				var cocSeqNo			= 0;
				var cocAtcn				= 'N';
				var make				= getListTextValue("makeCd");
				var motorCoverage		= "";
				
				itemArray = itemArray +
					'<input type="hidden" name="assignees" 			value="'+assignee+'" />' +
					'<input type="hidden" name="acquiredFroms" 		value="'+acquiredFrom+'" />' +
					'<input type="hidden" name="motorNos"			value="'+motorNo+'" />' +
					'<input type="hidden" name="origins"			value="'+origin+'" />' +
					'<input type="hidden" name="destinations"		value="'+destination+'" />' +
					'<input type="hidden" name="typeOfBodys"		value="'+typeOfBody+'" />' +
					'<input type="hidden" name="plateNos" 			value="'+plateNo+'" />' +
					'<input type="hidden" name="modelYears" 		value="'+modelYear+'" />' +
					'<input type="hidden" name="carCompanys" 		value="'+carCompany+'" />' +
					'<input type="hidden" name="mvFileNos" 			value="'+mvFileNo+'" />' +
					'<input type="hidden" name="noOfPasss" 			value="'+noOfPass+'" />' +
					'<input type="hidden" name="makeCds" 			value="'+makeCd+'" />' +
					'<input type="hidden" name="basicColors" 		value="'+basicColor+'" />' +
					'<input type="hidden" name="colors" 			value="'+color+'" />' +
					'<input type="hidden" name="colorCds" 			value="'+colorCd+'" />' +
					'<input type="hidden" name="engineSeriess" 		value="'+engineSeries+'" />' +
					'<input type="hidden" name="motorTypes" 		value="'+motorType+'" />' +
					'<input type="hidden" name="unladenWts" 		value="'+unladenWt+'" />' +
					'<input type="hidden" name="towings" 			value="'+towLimit+'" />' +
					'<input type="hidden" name="serialNos" 			value="'+serialNo+'" />' +
					'<input type="hidden" name="sublineTypeCds" 	value="'+sublineType+'" />' +
					'<input type="hidden" name="deductibleAmounts" 	value="'+deductibleAmount+'" />' +
					'<input type="hidden" name="cocTypes" 			value="'+cocType+'" />' +
					'<input type="hidden" name="cocSerialNos" 		value="'+cocSerialNo+'" />' +
					'<input type="hidden" name="cocYYs" 			value="'+cocYY+'" />' +
					'<input type="hidden" name="ctvs" 				value="'+ctv+'" />' +
					'<input type="hidden" name="repairLimits" 		value="'+repairLimit+'" />' +
					'<input type="hidden" name="sublineCds" 		value="'+sublineCd+'" />' +				
					'<input type="hidden" name="cocSerialSws" 		value="'+cocSerialSw+'" />' +
					'<input type="hidden" name="motorCoverages" 	value="'+motorCoverage+'" />' +
					'<input type="hidden" name="estValues" 			value="'+estValue+'" />' +
					'<input type="hidden" name="tariffZones" 		value="'+tariffZone+'" />' +
					'<input type="hidden" name="cocIssueDates" 		value="'+cocIssueDate+'" />' +
					'<input type="hidden" name="cocSeqNos" 			value="'+cocSeqNo+'" />' +
					'<input type="hidden" name="cocAtcns" 			value="'+cocAtcn+'" />' +
					'<input type="hidden" name="makes" 				value="'+make+'" />' +
					'<input type="hidden" name="motorCoverages" 	value="'+motorCoverage+'" />';
			} else if(lineCd == "FI"){			
				var riskNo 				= $F("riskNo");
				var riskItemNo			= $F("riskItemNo");
				var eqZone				= $F("eqZone");
				var fromDate			= $F("fireFromDate");
				var assignee			= $F("assignee");
				var typhoonZone			= $F("typhoonZone");
				var toDate				= $F("fireToDate");
				var frItemType			= $F("frItemType");
				var floodZone			= $F("floodZone");
				var locRisk1			= $F("locRisk1");
				var regionCd			= $F("regionCd");
				var tariffZone			= $F("tariffZone");
				var locRisk2			= $F("locRisk2");
				var provinceCd			= $F("province");
				var tarfCd				= $F("tarfCd");
				var locRisk3			= $F("locRisk3");
				var city				= $F("city");
				var constructionCd		= $F("construction");
				var front				= $F("front");
				var district			= $F("district");
				var constructionRemarks	= $F("constructionRemarks");
				var right				= $F("right");
				var blockNo				= $F("block"); //$("block").options[$("block").selectedIndex].text;
				var occupancyCd			= $F("occupancy");
				var left				= $F("left");
				var riskCd				= $F("risk");
				var occupancyRemarks	= $F("occupancyRemarks");
				var rear				= $F("rear");
				var blockId				= $F("block");
				var provinceDesc		= $("province").options[$("province").selectedIndex].text;
	
				itemArray = itemArray + 				
					'<input type="hidden" name="eqZones" 				value="'+eqZone+'" />' +
					'<input type="hidden" name="fromDates" 				value="'+fromDate+'" />' +
					'<input type="hidden" name="assignees" 				value="'+assignee+'" />' +
					'<input type="hidden" name="typhoonZones" 			value="'+typhoonZone+'" />' +
					'<input type="hidden" name="toDates" 				value="'+toDate+'" />' +
					'<input type="hidden" name="frItemTypes" 			value="'+frItemType+'" />' +
					'<input type="hidden" name="floodZones" 			value="'+floodZone+'" />' +
					'<input type="hidden" name="locRisk1s" 				value="'+locRisk1+'" />' +
					'<input type="hidden" name="regionCds" 				value="'+regionCd+'" />' +
					'<input type="hidden" name="tariffZones" 			value="'+tariffZone+'" />' +
					'<input type="hidden" name="locRisk2s" 				value="'+locRisk2+'" />' +
					'<input type="hidden" name="provinceCds" 			value="'+provinceCd+'" />' +
					'<input type="hidden" name="tarfCds" 				value="'+tarfCd+'" />' +
					'<input type="hidden" name="locRisk3s" 				value="'+locRisk3+'" />' +
					'<input type="hidden" name="citys" 					value="'+city+'" />' +
					'<input type="hidden" name="constructionCds" 		value="'+constructionCd+'" />' +
					'<input type="hidden" name="fronts" 				value="'+front+'" />' +
					'<input type="hidden" name="districtNos" 			value="'+district+'" />' +
					'<input type="hidden" name="constructionRemarkss"	value="'+constructionRemarks+'" />' +
					'<input type="hidden" name="rights"					value="'+right+'" />' +
					'<input type="hidden" name="blockNos" 				value="'+blockNo+'" />' +
					'<input type="hidden" name="occupancyCds" 			value="'+occupancyCd+'" />' +
					'<input type="hidden" name="lefts" 					value="'+left+'" />' +
					'<input type="hidden" name="riskCds" 				value="'+riskCd+'" />' +
					'<input type="hidden" name="occupancyRemarkss" 		value="'+occupancyRemarks+'" />' +
					'<input type="hidden" name="rears" 					value="'+rear+'" />' +
					'<input type="hidden" name="blockIds" 				value="'+blockId+'" />' +
					'<input type="hidden" name="provinceDescs"			value="'+provinceDesc+'" />';			
			}
	
			return itemArray;
		} catch (e) {
			showErrorMessage("generateAdditionalItems", e);
			//showMessageBox("generateAdditionalItems : " + e.message);
		}
	}

	function clickParItemRow(row) {
		row.toggleClassName("selectedRow");
		$("perilExists").value = "N";
		
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
			/*if (checkIfPerilExists(true)) {
				$("perilExists").value = "Y";
			} else {
				$("perilExists").value = "N";
			}*/
			//check if currency is updateable
			if ($F("vAllowUpdateCurrRate") != "Y" && $F("globalLineCd") == "FI") {
				$("currency").disable();
				$("rate").disable();
			}
			whenNewRecordInstance();
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
		$("currencyListIndex").value = $("currency").selectedIndex;
		//$("changedFields").value = 0;
		toggleEndtItemPeril($F("itemNo")); // added by andrew 07.08.2010		
	}

	function enableWItemButtons() {
		$$("input[name='btnWItem']").each(function(btn) {
			enableButton(btn.id);
		});
		$("btnSaveItem").value = "Update";
		enableButton($("btnDelete"));
	}

	function disableWItemButtons() {
		$$("input[name='btnWItem']").each(function(btn) {
			disableButton(btn.id);
		});
		$("btnSaveItem").value = "Add";
		disableButton($("btnDelete"));
	}

	//update the specified LOV. Fetches new list values from database
	//parameters: 
	//list: The select element/LOV to be updated
	//sizeElem: The number of fetched values from database
	//optValue: The name of value to be saved in value attribute of the option element
	//optText: The text to be saved in the option element
	//path: The path, controller, and parameters to be passed in the Ajax.request
	//postform: The form
	//func: Additional function to call, this is optional.
	function updateLOV(list, sizeElem, optValue, optText, path, postform, func) {
		var content = '<option value=""></option>';
		var i = 0;
		var text = "";
		var value = "";

		new Ajax.Request(path, {
			method : "GET",
			postBody: Form.serialize(postform),
			asynchronous : true,
			evalScripts : true,
			onCreate : 
				function(){
					$(list).update('<option value=""></option>');
					$("isLoaded").value = $F("isLoaded") + 1;
				},
			onComplete:
				function(response){
					hideNotice("Lists are successfully updated.");
					
					var resXML = response.responseXML;
					var size = resXML.getElementsByTagName(sizeElem)[0].childNodes[0].nodeValue;
										
					for (i = 0; i < size; i++) {
						value = resXML.getElementsByTagName(optValue + i)[0].childNodes[0].nodeValue;
						text = resXML.getElementsByTagName(optText + i)[0].childNodes[0].nodeValue;
						content = content + '<option value="'+value+'">'+text+'</option>';
					}
					
					$(list).update(content);
					if (func != null) {
						func(response);
					}
				}
		});
	}

	function updateAddDeleteItemTable(value, id) {
		var itemTable = $("addDeleteItemTableContainer");
		var content;

		content = '<label name="textItem" style="width: 20%; text-align: center;"><input type="checkbox" name="addDeleteCheckbox" value="N"/></label>' +
        '<label name="textItem" style="width: 20%; text-align: left;">'+value+'</label>';
		
		var newDiv = new Element("div");
		newDiv.setAttribute("id", id);
		newDiv.setAttribute("name", "addDeleteItemRow");
		newDiv.setStyle("height: 20px; border-bottom: 1px solid #E0E0E0; padding-top: 10px;");
		newDiv.addClassName("tableRow");
		newDiv.update(content);
		itemTable.insert({bottom : newDiv});

		newDiv.down("input", 0).observe("click", function() {
			var cb = newDiv.down("input", 0);
			if (cb.checked) {
				$("paramItemCnt").value = parseInt($F("paramItemCnt")) + 1;
			} else {
				$("paramItemCnt").value = parseInt($F("paramItemCnt")) - 1;
			}
		});
	}

	//module triggers
	
	// key-crerec
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
		try {
			var parId			= $F("globalParId");
			var itemNo 			= $F("itemNo");
			var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
			var regionCd 		= ($F("globalLineCd") == "FI" || $F("globalLineCd") == "MN") ? "regionCd" : getListTextValue("region");
			var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
			var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
			var currency		= $F("currency");
			var currencyText 	= $("currency").options[$("currency").selectedIndex].text;
			var rate 			= $F("rate");
			var coverage 		= ($F("globalLineCd") != "MN" ? $F("coverage") : "");
			var coverageText 	= ($F("globalLineCd") != "MN" ? $("coverage").options[$("coverage").selectedIndex].text : "");
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

			if($F("globalLineCd") == "MC"){
				var typeOfBody		= getListTextValue("typeOfBody");
				var carCompany		= getListTextValue("carCompany");
				var makeCd			= getListTextValue("makeCd");
				var engineSeries	= getListTextValue("engineSeries");
				var modelYear		= $F("modelYear");
				
				if($F("motorNo").blank()){
					showMessageBox("Motor Number is required!", imgMessage.ERROR);						
					return false;
				} else if($F("motorType").blank()){
					showMessageBox("Motor type is required!", imgMessage.ERROR);
					return false;
				} else if($F("sublineType").blank()){
					showMessageBox("Subline Type is required!", imgMessage.ERROR);
					return false;
				} else if(coverage.blank()){
					showMessageBox("Invalid coverage code!", imgMessage.ERROR);
					return false;
				}
				
				// pre-commit on forms
				if ($F("varPost").blank()) {
					if ($F("varPost2") == "N") {
						return false;
					}
					
					if($F("makeCd") != "" && $F("carCompany") == ""){						
						showMessageBox("Car Company is required if make is entered.", imgMessage.INFO); /* I */
						return false;
					} else if($F("engineSeries") != "" && $F("makeCd") == ""){						
						showMessageBox("Make is required if engine series is entered.", imgMessage.INFO); /* I */
						return false;					
					}
				}
	
				// key-commit on forms
				if (itemTitle.blank() && itemNo.blank()) {
					if (!$F("typeOfBody").blank() || !$F("carCompany").blank() || !$F("makeCd").blank() || !$F("engineSeries").blank()) {
						$("itemTitle").value = rtrim(ltrim(modelYear + " " + carCompany + " " + makeCd +
								" " + engineSeries + " " + typeOfBody));
					} else {
						showMessageBox("Please enter the item title first.", imgMessage.ERROR);
						$("itemTitle").focus();
					}
				}
	
				if (itemNo.blank()) {
					if (!itemTitle.blank()) {
						if ($F("assignee").blank()) {
							if ($F("nbtSublineCd") == $F("varSublineLto")) {
								$("cocType").value = $F("varCocLto");
							} else {
								$("cocType").value = $F("varCocNlto");
							}
						}
					}
				}
	
				if ($F("globalLineCd") == "AV" || $F("globalLineCd") == "CA" || $F("globalLineCd") == "MN") {
					if (regionCd.blank() && !itemNo.blank()) {
						showMessageBox("Region code must be entered.", imgMessage.ERROR);
						return false;
					}
				}
	
				//:B480 pre-insert
				$("invoiceSw").value = "Y";
			} else if ($F("globalLineCd") == "FI") {
				var requiredFields = [	"eqZone", "typhoonZone", "frItemType", "floodZone",
				  						"tariffZone", "province", "tarfCd", "city",
				  						"district", "block", "front", "right",
				  						"left", "rear", "riskNo", "construction",
				  						"occupancy"];
				var fieldNames = [	"EQ Zone", "Typhoon Zone", "Type", "Flood Zone",
									"Tariff Zone", "Province", "Tarriff Code", "City",
									"District", "Block", "Front", "Right",
									"Left", "Rear", "Risk No.", "Construction",
									"Occupancy"];
				var breakLoop = false;
				for(var index=0, length = requiredFields.length; index < length; index++){
					if($F(requiredFields[index]).blank()){
						showMessageBox(fieldNames[index] + " is required!", imgMessage.ERROR);
						breakLoop = true;
						break;							
					}
				}
	
				if(breakLoop){
					return false;
				} else {
					//GIPI_WFIREITM (:B370) when-validate-record
					if (!$F("fireFromDate").blank() && $F("fireToDate").blank()) {
						showMessageBox("If start date is entered, end date is required", imgMessage.WARNING);
						return false;
					} else if ($F("fireFromDate").blank() && !$F("fireToDate").blank()) {
						showMessageBox("If end date is entered, start date is required", imgMessage.WARNING);
						return false;
					}
				}
			} else if ($F("globalLineCd") == "MN") {
				if ($F("region").blank()){
					showMessageBox("Region is required.");
					return false;
				}
			}
			
			if (!result) {
				 return false;
			} else {
				content = 	'<label style="width: 5%; text-align: right; margin-right: 10px;">'+itemNo+'</label>' +						
							'<label style="width: 20%; text-align: left;" title="'+itemTitle+'">'+(itemTitle == "" ? "-" : itemTitle.truncate(20, "..."))+'</label>'+
							'<label style="width: 20%; text-align: left;" title="'+itemDesc+'">'+(itemDesc == "" ? "-" : itemDesc.truncate(20, "..."))+'</label>' +
							'<label style="width: 20%; text-align: left;" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "-" : itemDesc2.truncate(20, "..."))+'</label>' +
							'<label style="width: 10%; text-align: left;" title="'+currencyText+'">'+currencyText.truncate(15, "...")+'</label>' +
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
	
					newDiv.observe("click",
						function(){
							clickParItemRow(newDiv);
					});
				}
			}
		} catch (e) {
			showErrorMessage("saveItem", e);
			//showMessageBox("saveItem : " + e.message);
		}
	}

	//when-new-record-instance
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

	function updateUnladenWt(response) {
		var content = '<option value=""></option>';
		var resXML = response.responseXML;
		var size = resXML.getElementsByTagName("motorTypeListSize")[0].childNodes[0].nodeValue;
		
		for (i = 0; i < size; i++) {
			value = resXML.getElementsByTagName("motorUnladenWt" + i)[0].childNodes[0].nodeValue;
			text = resXML.getElementsByTagName("motorUnladenWt" + i)[0].childNodes[0].nodeValue;
			content = content + '<option value="'+value+'">'+text+'</option>';
		}

		$("unladenWeight").update(content);
	}

	//validations
	function validateCurrency() {
		var lastIndex = $F("currencyListIndex");
		
		new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=checkIfParItemHasPeril",{
			method : "GET",
			parameters : {
				itemNo : $F("itemNo"),
				globalParId : $F("globalParId")
			},					
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				showNotice("Validating currency. Please wait.");
			},
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Success.");
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

	function deleteAddAllItems(choice) {
		if (choice == 3) {
			return false;
		} else {
			if ($F("addDeletePageLoaded") == "N") {
				new Ajax.Updater("addDeleteItemDiv", contextPath+"/GIPIParMCItemInformationController?action=showAddDeleteItemDiv", {
					evalScripts : true,
					asynchronous : false,
					method : "GET",
					parameters : {
						globalParId : $F("globalParId")
					},
					onCreate : function() {
						showNotice("Loading Add/Delete Items Page. Please wait...");
					},
					onComplete : function(response) {
						var result = $F("varDeductibleExist");
						if (result != "Y" && result != "N") {
							showMessageBox(result);
						} else {
							hideNotice("Done!");
							$("addDeletePageLoaded").value = "Y";
						}
					}
				});

				$("btnAddDeleteContinue").observe("click", function() {
					if ($F("varDeductibleExist") == "Y") {
						showConfirmBox("Delete item", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
								"Yes", "No",
								function() {
									new Ajax.Request(contextPath + "/GIPIWDeductibleController?action=deleteGipiWdeductibles2",{
										method : "GET",
										parameters : {
											parId : $F("globalParId"),
											globalLineCd : $F("globalLineCd"),
											globalSublineCd : $F("globalSublineCd")
										},					
										asynchronous : true,
										evalScripts : true,
										onCreate: function() {
											showNotice("Deleting existing deductibles. Please wait...");
										},
										onComplete : function(response){
											hideNotice("Done!");
											var msg = response.responseText;
											if (msg != "SUCCESS") {
												showMessageBox(msg, imgMessage.ERROR);
												return false;
											} else {
												validateBeforeDeleteItem();
											}
										}
									});
								},
								"");
					} else {
						validateBeforeDeleteItem();
					}
				});

				$("btnAddDeleteCancel").observe("click", function() {
					new Effect.toggle("addDeleteItemDiv", "blind", {duration: .2});
				});
			}

			if (choice == 1) {
				//Add item
				if ($$("div[name='addDeleteItemRow']").size() > 0) {
					$$("div[name='addDeleteItemRow']").each(function(row) {
						row.remove();
					});
				}

				$("paramAddDeleteSw").value = "A";
				$("paramItemCnt").value = 0;

				new Ajax.Request(contextPath + "/GIPIWItemController?action=getDistinctItemNos",{
					method : "GET",
					parameters : {
						parId : $F("globalParId")
					},					
					asynchronous : false,
					evalScripts : true,
					onCreate: function() {
						showNotice("Obtaining item numbers. Please wait...");
					},
					onComplete : function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice("Done!");
							var resXML = response.responseXML;
							var size = resXML.getElementsByTagName("itemNosSize")[0].childNodes[0].nodeValue;
							var addtlTxt = "";

							if (size < 1) {
								if ($F("globalLineCd") == "MC") {
									addtlTxt = "affecting ";
								}
								showMessageBox("All "+addtlTxt+"item(s) for this policy is already inserted.", imgMessage.INFO);
								return false;
							}
							for (var i = 0; i < size; i++) {
								value = resXML.getElementsByTagName("itemNo"+i)[0].childNodes[0].nodeValue;
								updateAddDeleteItemTable(value, "row"+i);
							}
							new Effect.toggle("addDeleteItemDiv", "blind", {duration: .2});
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			} else if (choice == 2) {
				//Delete item
				if ($$("div#itemTable div[name='row']").size() == 0) {
					showMessageBox("There are no items inserted for this PAR.", imgMessage.INFO);
					return false;
				}
				
				$("paramAddDeleteSw").value = "D";
				$("paramItemCnt").value = 0;

				if ($$("div[name='addDeleteItemRow']").size() > 0) {
					$$("div[name='addDeleteItemRow']").each(function(row) {
						row.remove();
					});
				}
				
				$$("div#itemTable div[name='row']").each(function (row) {
					updateAddDeleteItemTable(row.down("input", 1).value, row.id);
				});

				new Effect.toggle("addDeleteItemDiv", "blind", {duration: .2});
			}
		}
	}

	//COPY_ITEM
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

	//Copy Item Procedure
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
			onCreate : showNotice("Copying item information, please wait..."),
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("Done!");
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
			onCreate : showNotice("Retrieving max item no, please wait..."),
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

	//negate item function
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
					showNotice("Checking if item is backward endorsement. Please wait...");
				},
				onComplete : function(response){
					hideNotice("Done!");
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
						showNotice("Extracting latest expiry date. Please wait...");
					},
					onComplete : function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice("Done!");
							var expiry = response.responseText;
							$("varExpiryDate").value = expiry;
						}
					}
				});

				//update_gipi_wpolbas2
				new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=updateGipiWpolbasEndt",{
					method : "GET",
					parameters : {
						globalParId : $F("globalParId"),
						negateItem : $F("varNegateItem"),
						prorateFlag : $F("varProrateFlag"),
						compSw : $F("varCompSw"),
						endtExpiryDate : $F("varEndtExpiryDate"),
						effDate : $F("varEffDate"),
						expiryDate : ($F("varExpiryDate")),
						shortRtPercent : $F("varShortRtPercent")
					},
					asynchronous : false,
					evalScripts : true,
					onCreate: function() {
						showNotice("Updating. Please wait...");
					},
					onComplete : function(response){
						hideNotice("Done!");
						if (response.responseText == "SUCCESS") {
							result = true;
							//delete gipi_witmperl
							new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=deleteItemPeril",{
								method : "GET",
								parameters : {
									globalParId : $F("globalParId"),
									itemNo : $F("itemNo")
								},					
								asynchronous : false,
								evalScripts : true,
								onCreate: function() {
									showNotice("Deleting item peril. Please wait...");
								},
								onComplete : function(response){
									hideNotice("Done!");
									if (response.responseText == "SUCCESS") {
										result = true;
									} else {
										showMessageBox(response.responseText, imgMessage.ERROR);
										result = false;
									}
								}
							});
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
							result = false;
						}
					}
				});

				if (!result) {
					return false;
				} else {
					//neg_del_item on database
					//if success
					//variables.v_negate_item = 'Y'
					new Ajax.Request(contextPath + "/GIPIItemMethodController?action=negateItem",{
						method : "GET",
						parameters : {
							itemNo : $F("itemNo"),
							parId : $F("globalParId")
						},					
						asynchronous : false,
						evalScripts : true,
						onCreate: function() {
							showNotice("Updating new item perils. Please wait...");
						},
						onComplete : function(response){
							if (checkErrorOnResponse(response)) {
								hideNotice("Done!");
								var resXML = response.responseXML;
								var msg  = resXML.getElementsByTagName("message")[0].childNodes[0].nodeValue;
								
								if (msg == "SUCCESS") {
									$("premAmt").value = resXML.getElementsByTagName("premAmt")[0].childNodes[0].nodeValue;
									$("tsiAmt").value = resXML.getElementsByTagName("tsiAmt")[0].childNodes[0].nodeValue;
									$("annPremAmt").value = resXML.getElementsByTagName("annPremAmt")[0].childNodes[0].nodeValue;
									$("annTsiAmt").value = resXML.getElementsByTagName("annTsiAmt")[0].childNodes[0].nodeValue;
									$("varNegateItem").value = "Y";

									showMessageBox("Deletion has been sucessfully completed... Check Item Peril Module for information.", imgMessage.INFO);
									$("changedFields").value = parseInt($F("changedFields")) + 1;
									$("invoiceSw").value = "Y";
								} else {
									showMessageBox(msg, imgMessage.ERROR);
									return false;
								}
							}
						}
					});
				}
			}
		}
	}

	//check if peril exists
	//param is used for recFlag checking. if param is true, check if recFlag is "A". otherwise, don't check.
	function checkIfPerilExists(param) {
		if ($F("itemNo").blank()) {
			return false;
		}
		
		var result = true;
		
		new Ajax.Request(contextPath + "/GIPIWItemPerilController?action=checkIfWItemPerilExists2",{
			method : "GET",
			parameters : {
				itemNo : $F("itemNo"),
				globalParId : $F("globalParId")
			},					
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				showNotice("Checking if item peril exists. Please wait.");
			},
			onComplete : function(response){
				if (checkErrorOnResponse(response)) {
					hideNotice("Success.");
					if ((response.responseText == "Y" || $F("recFlag") == "A") && param) {
						result = true;
					} else if (response.responseText == "Y") {
						result = true;
					} else {
						result = false;
					}
				}
			}
		});

		return result;
	}

	//assign deductibles
	function assignDeductibles(){
		new Ajax.Request(contextPath + "/GIPIItemMethodController?action=assignDeductibles",{
			method : "POST",
			parameters : {
				parId : $F("globalParId"),
				itemNo : $F("itemNo")
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : showNotice("Assigning deductible, please wait..."),
			onComplete : 
				function(response){
					hideNotice("Done!");
					showMessageBox("Assigning Deductibles Completed.", imgMessage.INFO);				
				} 
		});
	}

	//delete items validations (DEL_ITEM)
	function validateBeforeDeleteItem() {
		if ($F("paramItemCnt") < 1) {
			showMessageBox("There are no records tagged for processing.", imgMessage.ERROR);
			return false;
		}

		if ($F("varDiscExist") == "Y") {
			var msg = "";

			if ($F("paramAddDeleteSw") == "A") {
				msg = "Adding new item will result to the deletion of all discounts. Do you want to continue ?";
			} else {
				msg = "Deleting existing item will result to the deletion of all discounts. Do you want to continue ?";
			}

			showConfirmBox("Delete Item", msg, "Yes", "No", delItem,"");
		} else {
			delItem();
		}
	}

	//delete items (DEL_ITEM)
	function delItem() {
		var result = deleteDiscount();
		var itemNo = "";

		if (!result) {
			return false;
		} else {
			$("invoiceSw").value = "Y";
			if ($F("paramAddDeleteSw") == "D") {
				$$("div[name='addDeleteItemRow']").each(function(row) {
					if (row.down("input", 0).checked) {
						itemNo = itemNo + parseInt(row.down("label", 1).innerHTML) + " ";
					}					
				});
				deleteItem(itemNo);
			} else if ($F("paramAddDeleteSw") == "A") {
				$$("div[name='addDeleteItemRow']").each(function(row) {
					if (row.down("input", 0).checked) {
						itemNo = itemNo + parseInt(row.down("label", 1).innerHTML) + " ";
					}
				});
				addItem(itemNo);
			}
		}
	}

	//DELETE_ITEM
	function deleteItem(itemNo) {
		new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=deleteEndtItem",{
			method : "GET",
			parameters : {
				globalParId : $F("globalParId"),
				itemNos : itemNo,
				itemNo : $F("itemNo")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				showNotice("Deleting items. Please wait...");
			},
			onComplete : function(response){
				hideNotice("Done!");
				if (response.responseText != "SUCCESS") {
					showMessageBox(response.responseText, imgMessage.ERROR);
				} else {
					$$("div[name='addDeleteItemRow']").each(function(row) {
						if (row.down("input", 0).checked) {
							removeItemFromList(parseInt(row.down("label", 1).innerHTML));
						}
					});
				}
				new Effect.toggle("addDeleteItemDiv", "blind", {duration: .2});
			}
		});
	}

	//delete item record
	function deleteRecord() {
		checkGIPIWItem();			
		if($F("tempVariable") == "1"){
			$("tempVariable").value = "0";
			return false;
		}			
		$$("div#itemTable div[name='row']").each(
			function(row){
				if(row.hasClassName("selectedRow")){
					Effect.Fade(row,{
						duration : .2,
						afterFinish :
							function(){									
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
	
	//ADD_ITEM
	function addItem(itemNo) {
		new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=addEndtItem",{
			method : "GET",
			parameters : {
				globalParId : $F("globalParId"),
				itemNos : itemNo
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: function() {
				showNotice("Adding items. Please wait...");
			},
			onComplete : function(response){
				hideNotice("Done!");
				if (response.responseText != "SUCCESS") {
					showMessageBox(response.responseText, imgMessage.ERROR);
				} else {
					$$("div[name='addDeleteItemRow']").each(function(row) {
						if (row.down("input", 0).checked) {
							//addItemFromList(parseInt(row.down("label", 1).innerHTML));
						}
						showEndtItemInfo();
					});
				}
				new Effect.toggle("addDeleteItemDiv", "blind", {duration: .2});
			}
		});
	}

	/* this is for FIRE */
	function supplyFireInfo(blnApply, row){
		var fireFields = ["eqZone", "fireFromDate", "assignee", "typhoonZone",
		                  "fireToDate", "frItemType", "floodZone", "locRisk1",
		                  "regionCd", "tariffZone", "locRisk2", "province",
		                  "tarfCd", "locRisk3", "city", "construction",
		                  "front", "district", "constructionRemarks", "right",
		                  "block", "occupancy", "left", "risk",
		                  "occupancyRemarks", "rear"];

	    if(blnApply){
			for(var index=0, length=26; index<length; index++){
				$(fireFields[index]).value = row.down("input", index+31).value;
			}

			if(row.down("input", 42).value.trim() /*province*/ != ""){
				//filterCityByProvince(row.down("input", 45).value /*city*/, row.down("input", 58).value  /*provinceDesc*/ /*$("province").options[$("province").selectedIndex].text*/);
				filterCityByProvince(row.down("input", 45).value);
			}

			if(row.down("input", 48).value.trim() /*district*/ != ""){				
				//filterDistrictByProvinceByCity(row.down("input", 48).value /*district*/, row.down("input", 58).value /*provinceDesc*/, row.down("input", 45).value /*city*/);
				filterDistrictByProvinceByCity(row.down("input", 48).value);
			}

			if(row.down("input", 57).value.trim() != ""){
				//filterBlock(row.down("input", 57).value /*blockId/block*/, row.down("input", 58).value /*provinceDesc*/, row.down("input", 45).value /*city*/, row.down("input", 48).value /*district*/);
				filterBlock(row.down("input", 57).value);
			}

			if(row.down("input", 51).value.trim() /*block*/ != ""){
				//filterRisk(row.down("input", 54).value /*risk*/, row.down("input", 51).value /*blockId*/);
				filterRisk(row.down("input", 54).value);
			}
	    } else{
			for(var index=0, length=26; index<length; index++){
				$(fireFields[index]).value = "";
			}
	    }
	}

	function supplyMarineCargoInfo(blnApply, row){
		var marineCargoFields = ["packMethod","blAwb","transhipOrigin","transhipDestination",
		                 		 "voyageNo","lcNo","etd","eta",
		                 		 "origin","destn","invCurrRt","invoiceValue",
		                 		 "markupRate","recFlagWCargo","cpiRecNo","cpiBranchCd",
		                 		 "deductText"]; 
		if(blnApply){
			$("cargoType").selectedIndex = 0;
			$("cargoClassCd").selectedIndex = 0;
			$("invCurrCd").selectedIndex = 0;
			for(var index=0, length=17; index<length; index++){
				$(marineCargoFields[index]).value = row.down("input", index+31).value;
			} 
			if ($("invCurrRt").value != "") {
				$("invCurrRt").value = formatToNineDecimal($("invCurrRt").value);
			}
			if ($("invoiceValue").value != "") {
				$("invoiceValue").value = formatCurrency($("invoiceValue").value);
			}
			if ($("markupRate").value != "") {
				$("markupRate").value = formatToNineDecimal($("markupRate").value);
			}	

			if(row.down("input", 48).value.trim() != ""){
				$("geogCd").value = row.down("input", 48).value;
				geogClassType = $("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType");
				for(var i = 1; i < $("vesselCd").options.length; i++){ 
					if (geogClassType == $("vesselCd").options[i].getAttribute("vesselFlag")){
						$("vesselCd").options[i].show();
					} else {
						$("vesselCd").options[i].hide();
					}		
				}
				$("vesselCd").value = row.down("input", 49).value;
			} else {				
				$("geogCd").value = row.down("input", 48).value;
				for(var i = 1; i < $("vesselCd").options.length; i++){
					$("vesselCd").options[i].show();
				}	 
				$("vesselCd").value = row.down("input", 49).value;
			}		
			if(row.down("input", 50).value.trim() != ""){
				$("cargoClassCd").value = row.down("input", 50).value;
				$("cargoType").selectedIndex = 0;
				for(var i = 1; i < $("cargoType").length; i++){ 
					$("cargoType")[i].hide();
				}
				for(var i = 1; i < $("cargoType").options.length; i++){  
					if ($("cargoType").options[i].getAttribute("cargoClassCd") == $("cargoClassCd").value){
						$("cargoType").options[i].show();
					}
				}
				$("cargoType").value = row.down("input", 51).value;
			}	
			if(row.down("input", 52).value.trim() != ""){
				$("printTag").value = row.down("input", 52).value;
			}
			if(row.down("input", 53).value.trim() != ""){
				$("invCurrCd").value = row.down("input", 53).value;
			}	 
			$("perilExist").value = row.down("input", 54).value; 
			if ($("vesselCd").value == $("multiVesselCd").value) {
				$("listOfCarriersPopup").show();
				computeTotalAmountInTable("carrierTable","carr",7,"item",$F("itemNo"),"listOfCarrierTotalAmtDiv");
			} else{
				$("listOfCarriersPopup").hide();
			}		
			$("paramVesselCd").value = $("vesselCd").value;
			$("deductibleRemarks").value = $F("deductText"); //andrew 08.09.2010
		} else {
			for(var index=0, length=14; index<length; index++){
				$(marineCargoFields[index]).value = "";
			}
			$$("select").each(
					function(elem){
						elem.value = "";
					}
			);
			$("invCurrRt").value 		= "";
			$("invoiceValue").value 	= "";
			$("markupRate").value 		= "";
			$("recFlagWCargo").value 	= "A";
			$("cpiRecNo").value		 	= "";
			$("cpiBranchCd").value		= "";
			$("deductText").value		= "";
			$("deleteWVes").value		= "";
			$("printTag").value 		= "1";
			showListing($("vesselCd"));
			hideListing($("cargoType"));
			$("listOfCarriersPopup").hide();
			$("paramVesselCd").value = "";			
        }
	}
	
	//filters city LOV based on selected province
	//Parameters:
	//val - the selected value of the LOV after being updated. If value is null, val is set to blank.
	function filterCityByProvince(val) {
		var content = "<option value=''></option>";
		var i = 0;
		var provinceDesc = $("province").options[$("province").selectedIndex].text;

		if (!provinceDesc.blank()) {
			$$("div[name='cityList']").each(function (row) {
				if (row.down("input", 0).value == provinceDesc) {
					$$("div[name='cityList2"+i+"']").each(function (r) {
						if (!r.down("input", 1).value.blank()) {
							content = content + "<option value='"+r.down("input", 1).value+"'>"+r.down("input", 1).value+"</option>";
						}
					});
					return false;
				}
				i++;
			});
		}
		
		if (Object.isUndefined(val)) {
			val = "";
		}

		$("city").update(content);
		//$("city").selectedIndex = index > $("city").options.length ? 0 : index;
		$("city").value = val;
	}

	//filters district LOV based on selected province and city
	//Parameters:
	//val - the selected value of the LOV after being updated. If value is null, val is set to blank.
	function filterDistrictByProvinceByCity(val) {
		var content = "<option value=''></option>";
		var i = 0;
		var provinceDesc = $("province").options[$("province").selectedIndex].text;
		var cityDesc 	 = $("city").options[$("city").selectedIndex].text;

		if (!provinceDesc.blank() && !cityDesc.blank()) {
			$$("div[name='districtList']").each(function (row) {
				if (row.down("input", 0).value == provinceDesc && row.down("input", 1).value == cityDesc) {					
					$$("div[name='districtList"+i+"']").each(function (r) {
						if (!r.down("input", 2).value.blank()) {
							content = content + "<option value='"+r.down("input", 2).value+"'>"+r.down("input", 2).value+"</option>";
						}
					});
					return false;
				}
				
				i++;
			});
		}
		
		if (Object.isUndefined(val)) {
			val = "";
		}

		$("district").update(content);
		//$("district").selectedIndex = index > $("city").options.length ? 0 : index;
		$("district").value = val;
	}

	//filters block LOV based on selected province, city, and district
	//Parameters:
	//val - the selected value of the LOV after being updated. If value is null, val is set to blank.
	function filterBlock(val) {
		var content = "<option value=''></option>";
		var i = 0;
		var provinceDesc = $("province").options[$("province").selectedIndex].text;
		var cityDesc 	 = $("city").options[$("city").selectedIndex].text;
		var districtNo = $("district").options[$("district").selectedIndex].text;

		if (!provinceDesc.blank() && !cityDesc.blank() && !districtNo.blank()) {
			$$("div[name='blockList']").each(function (row) {
				if (row.down("input", 0).value == provinceDesc && row.down("input", 1).value == cityDesc && row.down("input", 2).value == districtNo) {
					$$("div[name='blockList"+i+"']").each(function (r) {
						if (!r.down("input", 3).value.blank() && !r.down("input", 4).value.blank()) {
							content = content + "<option value='"+r.down("input", 4).value+"'>"+r.down("input", 3).value+"</option>";
						}
					});
					return false;
				}
				
				i++;
			});
		}
		
		if (Object.isUndefined(val)) {
			val = "";
		}

		$("block").update(content);
		//$("block").selectedIndex = index > $("city").options.length ? 0 : index;
		$("block").value = val;
	}

	//filters risk LOV based on selected district
	//Parameters:
	//val - the selected value of the LOV after being updated. If value is null, val is set to blank.
	function filterRisk(val) {
		var content = "<option value=''></option>";
		var blockId = $("block").options[$("block").selectedIndex].value;

		if (!blockId.blank()) {
			$$("div[name='risk"+blockId+"']").each(function (row) {
				if (!row.down("input", 0).value.blank() && !row.down("input", 1).value.blank()) {
					content = content + "<option value='"+row.down("input", 0).value+"'>"+row.down("input", 1).value+"</option>";
				}
				return false;
			});
		}
		
		if (Object.isUndefined(val)) {
			val = "";
		}

		$("risk").update(content);
		//$("block").selectedIndex = index > $("city").options.length ? 0 : index;
		$("risk").value = val;
	}
	/* end for FIRE */
	
	

	
	getRates();
</script>