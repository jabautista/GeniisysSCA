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

<div class="sectionDiv" id="itemInformationDiv" changeTagAttr="true" masterDetail="true">
	<jsp:include page="itemInformationListingTable2.jsp"></jsp:include>
	<div style="margin: 10px;" id="parItemForm">
		<input type="hidden" id="isLoaded" 					name="isLoaded"					value="1" />
		<input type="hidden" id="lastItemNo" 				name="lastItemNo" 				value="${lastItemNo}" />
		<input type="hidden" id="globalParId"				name="globalParId" 				value="${parId}" />		
		<input type="hidden" id="itemNumbers" 				name="itemNumbers" 				value="${itemNumbers}" />
		<input type="hidden" id="itemNoArray" 				name="itemNoArray" 				value="" />
		<input type="hidden" id="localPolicyNo" 			name="localPolicyNo" 			value="${policyNo}" />
		<input type="hidden" id="nbtInvoiceSw"				name="nbtInvoiceSw"				value="" />
		<input type="hidden" id="deletePolicyDeductible"	name="deletePolicyDeductible"	value="N" />
		<input type="hidden" id="copyPeril"					name="copyPeril"				value="N" />	
		<input type="hidden" id="planSw"					name="planSw"					value="" />
		<input type="hidden" id="planCd"					name="planCd"					value="" />	
		<input type="hidden" id="planChTag"					name="planChTag"				value="" />
		
		<c:choose>
			<c:when test="${lineCd eq 'MC'}">
				<!-- MOTORCAR ADDITIONAL INFO -->				
				<!--   -->
				<!-- END FOR MOTORCAR ADDITIONAL -->
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
		<!--<input type="hidden" id="cgCtrlIncludeSw"		name="cgCtrlIncludeSw"		value="" /> -->
		
		<!-- GIPI_WITEM remaining fields -->
		<input type="hidden" id="packLineCd"		name="packLineCd"		value="" />
		<input type="hidden" id="packSublineCd"		name="packSublineCd"	value="" />
		<input type="hidden" id="fromDate"			name="fromDate"			value="${fromDate}" />
		<input type="hidden" id="toDate"			name="toDate"			value="${toDate}" />
		<input type="hidden" id="recFlag"			name="recFlag"			value="" />
		<input type="hidden" id="regionCd" 			name="regionCd" 		value="${regionCd}" />
		<input type="hidden" id="itemGrp"			name="itemGrp"			value="" />		
		<input type="hidden" id="tsiAmt"			name="tsiAmt"			value="" />
		<input type="hidden" id="premAmt"			name="premAmt"			value="" />
		<input type="hidden" id="annPremAmt"		name="annPremAmt"		value="" />
		<input type="hidden" id="annTsiAmt"			name="annTsiAmt"		value="" />
		<input type="hidden" id="otherInfo"			name="otherInfo"		value="" />		
					
		<input type="hidden" id="changedTag"		name="changedTag"		value="" />
		<input type="hidden" id="prorateFlag"		name="prorateFlag"		value="" />
		<input type="hidden" id="compSw"			name="compSw"			value="" />
		<input type="hidden" id="shortRtPercent"	name="shortRtPercent"	value="" />
		<input type="hidden" id="packBenCd"			name="packBenCd"		value="" />
		<input type="hidden" id="paytTerms"			name="paytTerms"		value="" />
		
		<c:if test="${lineCd ne 'FI'}">			
			<input type="hidden" id="riskNo"			name="riskNo"		value="" />
			<input type="hidden" id="riskItemNo"		name="riskItemNo"	value="" />
		</c:if>		
		
		<!-- GIPI_PARLIST (b240 on forms) -->
		<input type="hidden" id="invoiceSw"				name="invoiceSw"	value="" />
		
		<!-- variables in oracle forms -->
		<input type="hidden" id="varPost"			name="varPost" 			value="" />
		<input type="hidden" id="varPost2"			name="varPost2"			value="Y" />
		<input type="hidden" id="varCopyItemTag"	name="varCopyItemTag" 	value="N" />
		<input type="hidden" id="varOldCurrencyCd"	name="varOldCurrencyCd"	value="" />
		<input type="hidden" id="varGroupSw"		name="varGroupSw"		value="N" />
		<input type="hidden" id="varDiscExist"		name="varDiscExist" 	value="${varDiscExist}" />
		
		<!-- parameters in oracle forms -->
		<input type="hidden" id="parOtherSw"			name="parOtherSw"			value="N" />
		<input type="hidden" id="parDDLCommit"			name="parDDLCommit"			value="N" />
		<input type="hidden" id="parDefaultCoverage"	name="parDefaultCoverage"	value="${parDefaultCoverage}" />
		
		<table width="100%" cellspacing="1" border="0">					
			<tr>				
				<td class="rightAligned" style="width: 20%;">Item No. </td>
				<td class="leftAligned" style="width: 20%;"><input type="text" tabindex="1" style="width: 100%; padding: 2px;" id="itemNo" name="itemNo" class="required integerNoNegativeUnformatted" maxlength="9" /></td>
				<td class="rightAligned" style="width: 10%;">Item Title </td>
				<td class="leftAligned"><input type="text" tabindex="2" style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="250" /></td>
				<td rowspan="6"  style="width: 20%;">
					<table cellpadding="1" border="0" align="center">
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnCopyItemInfo" 		class="disabledButton" value="Copy Item Info" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnCopyItemPerilInfo" class="disabledButton" value="Copy Item/Peril Info" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnRenumber" 			name="btnRenumber" 			class="button" value="Renumber" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnAssignDeductibles" class="disabledButton" value="Assign Deductibles" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnOtherDetails" 		class="disabledButton" value="Other Details" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnAttachMedia" 		class="disabledButton" value="Attach Media" disabled="disabled" /></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%; display: none;" id="btnLocation" 			name="btnLocation" 		 	class="disabledButton" value="Location"		disabled="disabled"	/></td></tr>
						<tr align="center"><td><input type="button" style="width: 100%; display: none;" id="btnDefaultLoc"			name="btnDefaultLoc"	 	class="button" 		   value="Default Location"/></td></tr>
					</table>						
				</td>
			</tr>
			<c:if test="${lineCd eq 'EN' and sublineCd eq 'OP' or sublineCd eq 'PCP'}">
				<tr>
					<td class="rightAligned" style="width: 20%;">From Date</td>
					<td class="leftAligned" style="width: 20%;"><input type="text" style="width: 100%; padding: 2px;" id="fromDate" name="fromDate"/></td>
					<td class="rightAligned" style="width: 10%;">To Date</td>
					<td class="leftAligned" style="width: 20%" ><input type="text" style="width: 100%; padding: 2px;" id="toDate" name="toDate" /></td>				
				</tr>
			</c:if>
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
							<option value="${currency.code}"
							<c:if test="${item.currencyCd == currency.code}">
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
					<input type="text" tabindex="6" style="width: 100%; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="1.00" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999."/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Coverage 
					<input type="hidden" id="hideCoverage" name="hideCoverage" value="" />
				</td>
				<td class="leftAligned"  style="width: 20%;">
					<select tabindex="6" id="coverage" name="coverage" style="width: 100%;" class="required">						
						<c:forEach var="coverage" items="${coverages}">
							<option value="${coverage.code}"
							<c:if test="${item.coverageCd == coverage.code}">
								selected="selected"
							</c:if>>${coverage.desc}</option>				
						</c:forEach>
					</select>
				</td>
				<c:if test="${lineCd eq 'AV' or lineCd eq 'CA' or lineCd eq 'MN' or lineCd eq 'EN'}">
					<td class="rightAligned" style="width: 20%;">Region </td>
					<td class="leftAligned"  style="width: 20%;">
						<select tabindex="7" id="region" name="region" style="width: 100%;">
							<option value=""></option>
							<c:forEach var="region" items="${regions}">
								<option value="${region.regionCd}"
								<c:if test="${regionCd == region.regionCd}">
									selected="selected"
								</c:if>>${region.regionDesc}</option>				
							</c:forEach>
						</select>
					</td>
				</c:if>				
				<td class="rightAligned" style="width: 10%;">Group </td>
				<td class="leftAligned" style="width: 20%;">
					<select tabindex="8" id="groupCd" name="groupCd" style="width: 103%;">
						<option value=""></option>
						<c:forEach var="group" items="${groups}">
							<option value="${group.groupCd}"
							<c:if test="${item.groupCd == group.groupCd}">
								selected="selected"
							</c:if>>${group.groupDesc}</option>				
						</c:forEach>
					</select>
				</td>				
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Effectivity Dates </td>
				<td colspan="3" class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 30%; height: 21px; margin-right:3px;">
			    		<input style="width: 80%; border: none;" id="accidentFromDate" name="accidentFromDate" type="text" value="" readonly="readonly"/>
			    		<img id="hrefAccidentFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('accidentFromDate'),this, null);" alt="To Date" />
					</div>
					<div style="float:left; border: solid 1px gray; width: 30%; height: 21px; margin-right:3px;">
			    		<input style="width: 80%; border: none;" id="accidentToDate" name="accidentToDate" type="text" value="" readonly="readonly"/>
			    		<img id="hrefAccidentToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('accidentToDate'),this, null);" alt="To Date" />
					</div>
					<div style="float:left; width:30%;"><input class="rightAligned" type="text" id="accidentDaysOfTravel" name="accidentDaysOfTravel" value="" style="width: 100%; height: 15px;" readonly="readonly"></div>
					<div style="float:left; margin-left:10px;"><label class="rightAligned" >days</label></div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Plan </td>
				<td class="leftAligned"  style="width: 20%;">
					<select tabindex="7" id="accidentPackBenCd" name="accidentPackBenCd" style="width: 100%;">
						<option value=""></option>
						<c:forEach var="plan" items="${plans}">
							<option value="${plan.packBenCd}"
							<c:if test="${item.packBenCd == plan.packBenCd}">
								selected="selected"
							</c:if>>${plan.packageCd}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Payment Mode </td>
				<td class="leftAligned" style="width: 20%;">
					<select tabindex="8" id="accidentPaytTerms" name="accidentPaytTerms" style="width: 103%;">
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
				<c:if test="${lineCd ne 'AV' and lineCd ne 'CA' and lineCd ne 'MN' and lineCd ne 'EN'}">
					<td class="rightAligned" style="width: 20%;">Region </td>
					<td class="leftAligned"  style="width: 20%;">
						<select tabindex="7" id="region" name="region" style="width: 100%;">
							<option value=""></option>
							<c:forEach var="region" items="${regions}">
								<option value="${region.regionCd}"
								<c:if test="${regionCd == region.regionCd}">
									selected="selected"
								</c:if>>${region.regionDesc}</option>				
							</c:forEach>
						</select>
					</td>
				</c:if>
				<c:if test="${lineCd eq 'MC'}">
					<td class="rightAligned" style="width: 10%;">Motor Coverages</td>
					<td class="leftAligned" style="width: 20%;">
						<select tabindex="9" id="motorCoverage" name="motorCoverage" style="width: 103%;">
							<option value=""></option>
							<c:forEach var="mcCoverage" items="${motorCoverages}">
								<option value="${mcCoverage.rvLowValue}">${mcCoverage.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
				</c:if>
				<td class="rightAligned" >Condition
				 	<input type="hidden" id="accidentCondition" name="accidentCondition" />
				</td>
				<td class="leftAligned">
					<input type="hidden" id="paramAccidentProrateFlag" name="paramAccidentProrateFlag" value="" />
					<select id="accidentProrateFlag" name="accidentProrateFlag" style="width:103%;" class="required">
							<option value="1">Prorate</option>
							<option value="2">Straight</option>
							<option value="3">Short Rate</option>
					</select>
				</td>
				<td class="leftAligned">	
					<span id="prorateSelectedAccident" name="prorateSelectedAccident" style="display: none;">
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
			
		</table>
		<table style="margin:auto; width:70%" border="0">
			<tr>
				<td class="rightAligned">
					<div style="text-align : center;">
						<c:if test="${lineCd eq 'MC'}">
							<span id="generateCocSerialNoDiv" style="display: inline-block;">
								<input type="checkbox" id="generateCOCSerialNo" name="generateCOCSerialNo" disabled="disabled" style="float: left;" />
								<label id="lblGenerateCOCSerialNo" for="generateCOCSerialNo" style="margin: auto;" > Generate COC Serial No. &nbsp; &nbsp; &nbsp;</label>
							</span>					
																				
						</c:if>
						<span style="display: inline-block;">
							<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" disabled="disabled" style="float: left;" />
							<label style="margin: auto;" > W/ Surcharge &nbsp; &nbsp; &nbsp;</label>
						</span>
						<span style="display: inline-block;">
							<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" disabled="disabled" style="float: left;" />
							<label style="margin: auto;" > W/ Discount &nbsp; &nbsp; &nbsp;</label>
						</span>					
						<c:if test="${lineCd ne 'AV' and lineCd ne 'EN'}">
							<span style="display: inline-block;">
								<input type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" style="float: left;" />
								<label style="margin: auto;" > Include Additional Info.</label>
							</span>							
						</c:if>
						<c:if test="${lineCd eq 'AV' or lineCd eq 'EN'}">
							<input type="hidden" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="" />
						</c:if>
					</div>
				</td>
			</tr>
			<c:if test="${lineCd eq 'EN'}">
				<tr>
					<td colspan="4" style="text-align:center;">
						<input type="button" id="btnAdd" class="button" value="Add" />
						<input type="button" id="btnDelete" class="disabledButton" value="Delete" disabled="disabled" />
					</td>
				</tr>					
			</c:if>
		</table>
	</div>
</div>

<script type="text/javascript">
	//initializeTable("tableContainer", "row", "");	
	var selectedItemRow; // = new Array(3);
	var copyOfPeril 	= new Array(2);
	var currentItemNo 	= 1;
	objGIPIWItemWGroupedPeril = eval('${itemsWPerilGroupedListing}');	
	
	objItemNoList = new Array();	

	if($F("globalLineCd") == "EN"){
		objGIPIWItem = JSON.parse('${objENItem}'.replace(/\\/g, '\\\\'));
	}	
	
	$("btnAttachMedia").observe("click", function() {
		// openAttachMediaModal("par");
		openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
	});	
	
	$$("div#itemTable div[name='rowItem']").each(
   		function(row){
   	   		var obj = new Object();

   	   		obj[row.getAttribute("item")] = row.getAttribute("item");   	   		
			objItemNoList.push(obj);

			delete obj;
   	   		
			loadRowMouseOverMouseOutObserver(row);

   			row.observe("click",
   				function(){
   					//generateRiskItemNo();				
   					//if($F("isLoaded") == "1"){
   						selectedItemRow = row;   						

   						//preLoadSelectedItemRowProcedures();	
   						// temporary comment the above statement
   						// to handle issue regarding unsaved changes
   						// comment the if condition when the above statement is to be used
   						
   						if(masterDetail){			
							showConfirmBox("Confirmation", "There are unsaved changes you have made with regards to item info. Disregard changes?", "Yes", "No", preLoadSelectedItemRowProcedures, untoggleSelectedRow);			
						}else{
							preLoadSelectedItemRowProcedures();								
						}
						   						
   					//}					
   			});			
   		});

	function preLoadSelectedItemRowProcedures(){
		var row = selectedItemRow;		
		masterDetail = false; 
		// comment the masterDetail variable 
		// when if condition regarding masterDetial
		// in $$("div#itemTable div[name='rowItem']") click observer
		// is commented
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")){
			$$("div#itemTable div[name='rowItem']").each(
				function(r){									
					if(row.getAttribute("id") != r.getAttribute("id")){
						hideItemPerilInfos();
						loadUnselectedItemRowOnPerilProcedures();
						r.removeClassName("selectedRow");
					}									
				});
			loadSelectedItemRowProcedures();
		}else{
			loadUnselectedItemRowProcedures($F("itemNo"));
		}
	}

	function untoggleSelectedRow(){
		var row = selectedItemRow;

		row.removeClassName("selectedRow");
	}
	
	$("btnAdd").observe("click",
		function(){
			var parId			= $F("globalParId");
			var itemNo 			= $F("itemNo");
			var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
			var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
			var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
			var currency		= $F("currency");
			var currencyText 	= $("currency").options[$("currency").selectedIndex].text;
			var rate 			= $F("rate");
			var coverage 		= $F("coverage");
			var coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
			var content			= "";
			var itemOk			= true;			

			try{
				
			if(itemTitle.blank()){
				showMessageBox("Item Title is required!", imgMessage.ERROR);
				itemOk = false;
				return false;
			} else if(currency.blank()){
				showMessageBox("Currency is required!", imgMessage.ERROR);
				itemOk = false;
				return false;
			} else if(rate.match("-")) {
				showMessageBox("Invalid currency rate!", imgMessage.ERROR);
				itemOk = false;
				return false;
			} else if(rate.blank()) {
				showMessageBox("Currency Rate is required!", imgMessage.ERROR);
				itemOk = false;
				return false;	
			}else if(parseFloat(rate) <= 0 || parseFloat(rate) > 999.999999999){
				showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999", imgMessage.ERROR);
				itemOk = false;
				return false;		
			} else if ($F("hideCoverage") != "Y"){
				if(coverage.blank()){
					showMessageBox("Coverage is required.", imgMessage.ERROR);
					itemOk = false;
					return false;
				}	
			} 
			if (itemOk){
				if($F("globalLineCd") == "MC"){
					
					if($F("motorNo").blank()){
						showMessageBox("Motor Number is required!", imgMessage.ERROR);						
						return false;
					} else if($F("motorType").blank()){
						showMessageBox("Motor type is required!", imgMessage.ERROR);
						return false;
					} else if($F("sublineType").blank()){
						showMessageBox("Subline Type is required!", imgMessage.ERROR);
						return false;
					}
					
					// key-commit on forms
					if($F("cocSerialNo") != ""){						
						checkCOCSerialNoInPolicy();
						if($F("tempVariable") == "1"){
							$("tempVariable").value = "0";							
							return false;
						}
						checkCOCSerialNoInPar();
						if($F("tempVariable") == "1"){
							$("tempVariable").value = "0";							
							return false;
						}
					}
								
					if(itemTitle.blank() && !($F("motorNo").blank())){
						if(!($F("typeOfBody").blank()) || !($F("carCompany").blank()) || !($F("make").blank()) || !($F("engineSeries").blank())){
							$("itemTitle").value = $F("modelYear") + " " + $("carCompany").options[$("carCompany").selectedIndex].text + " " +
								$("make").options[$("make").selectedIndex].text + " " + 
								$("engineSeries").options[$("engineSeries").selectedIndex].text + " " +
								$("typeOfBody").options[$("typeOfBody").selectedIndex].text;
						}else{
							showMessageBox("Please enter the item title first.", imgMesage.ERROR);
							return false;
						}
					}
					
					if(!(itemNo.blank()) && !(itemTitle.blank())){						
						if($F("assignee").blank()){
							$("cocType").value = $F("sublineCd") == $F("varSublineLto") ? $F("varCocLto") : $F("varCocNlto");	
						}						
						$("cocYy").value = $F("cocYy").blank() ? $F("globalParYy") : $F("cocYy");						
					}
					
					if($F("region").blank() && !(itemTitle.blank())){
						showMessageBox("Region code must be entered.", imgMessage.ERROR);
						return false;
					}
						
					// pre-commit on forms
					if($F("varPost").blank()){
						if($F("makeCd") != "" && $F("carCompany") == ""){						
							showMessageBox("Car Company is required if make is entered.", imgMessage.INFO); /* I */
							return false;
						} else if($F("engineSeries") != "" && $F("makeCd") == ""){						
							showMessageBox("Make is required if engine series is entered.", imgMessage.INFO); /* I */
							return false;					
						}
					}				

					if($F("globalParStatus") < 3){
						showMessageBox("You are not granted access to this form. The changes that you have made " +
								"will not be committed to the database.", imgMessage.ERROR);
						return false;
					}
					$("nbtInvoiceSw").value = "Y";
					postFormsCommit();
				} else if($F("globalLineCd") == "FI"){
					var requiredFields = [	"frItemType", "tariffZone", "province", "tarfCd", 
					    					"city", "district", "block", "front", 
					    					"right", "left", "rear"];
					var fieldNames = [	"Type", "Tariff Zone", "Province", "Tarriff Code",
										"City","District", "Block", "Front Boundary", 
										"Right Boundary","Left Boundary", "Rear Boundary"];
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
					}					
				} else if($F("globalLineCd") == "MN"){
					var requiredFields = [ "region", "vesselCd", "cargoClassCd", "cargoType" ];
					var fieldNames = [ "Region", "Carrier", "Cargo Class", "Cargo Type" ];
					var breakLoop = false;
					var etd = makeDate($F("etd"));
					var eta = makeDate($F("eta"));	
					
					for(var index=0, length = requiredFields.length; index < length; index++){
						if($F(requiredFields[index]).blank()){
							showMessageBox(fieldNames[index] + " is required!", imgMessage.ERROR);
							breakLoop = true;
							break;							
						}
					}

					if(breakLoop){
						return false;
					}
					
					if (($F("eta") != "") && ($F("etd") != "")){
						if(eta >= etd){
							null;
						} else {
							showMessageBox("Arrival Date should not be earlier than the Departure Date "+$F("etd")+".", imgMessage.ERROR);
							return false;
						}		
					}
				} else if($F("globalLineCd") == "AV"){
					if ($("region").value == "" ){
						showMessageBox("Region is required!", imgMessage.ERROR);						
						return false;
					}else if($F("vesselCd").blank()){
						showMessageBox("Aircraft Name is required!", imgMessage.ERROR);						
						return false;
					} else if ($F("recFlag") == "A" && $F("recFlagAv") == "A"){
						if ($F("qualification").blank() || $F("geogLimit").blank()){
							showMessageBox("The GEOG. LIMIT and QUALIFICATION field should have some specific information. You cannot save the changes made unless you do the necessary actions.", imgMessage.ERROR);						
							return false;
						}	
					}
					if (parseInt($F("prevUtilHrs").replace(/,/g, "")) > 999999 || parseInt($F("prevUtilHrs").replace(/,/g, "")) < -999999){
						showMessageBox("Please enter valid number for Previous Utilization. Value must range from -999,999 to 999,999", imgMessage.ERROR);						
						return false;	
					} else if (parseInt($F("estUtilHrs").replace(/,/g, "")) > 999999 || parseInt($F("estUtilHrs").replace(/,/g, "")) < -999999){
						showMessageBox("Please enter valid number for Estimated Utilization. Value must range from -999,999 to 999,999", imgMessage.ERROR);						
						return false;
					} else if (parseInt($F("totalFlyTime").replace(/,/g, "")) > 999999 || parseInt($F("totalFlyTime").replace(/,/g, "")) < -999999){
						showMessageBox("Please enter valid number for Fly Time. Value must range from -999,999 to 999,999", imgMessage.ERROR);						
						return false;
					}		
				} else if($F("globalLineCd") == "CA"){
					if ($("region").value == "" ){
						showMessageBox("Region is required!", imgMessage.ERROR);						
						return false;
					}else if ($F("location").blank() && $F("sectionOrHazardCd").blank() && $F("capacityCd").blank() && $F("limitOfLiability").blank()){
						showMessageBox("Please complete the additional casualty information before adding an item.", imgMessage.ERROR);						
						return false;
					}	
				} else if($F("globalLineCd") == "MH"){
					if($F("geogLimit").blank()){
						showMessageBox("Geographic limit must have some specific information. Please do the necessary changes.", imgMessage.ERROR);
						return false;
					}					
				} else if($F("globalLineCd") == "AH"){
					if ($("region").value == "" ){
						showMessageBox("Region is required!", imgMessage.ERROR);						
						return false;
					}else if ($F("noOfPerson").blank() && $F("positionCd").blank() && $F("destination").blank() && ($F("monthlySalary").blank() || $F("monthlySalary")== "0.00") && $F("salaryGrade").blank()){
						showMessageBox("Please complete the additional accident information before adding an item.", imgMessage.ERROR);						
						return false;
					}else if ($F("accidentProrateFlag") == "1" && $F("accidentNoOfDays").blank() && $F("accidentFromDate") != "" && $F("accidentToDate") != ""){
						showMessageBox("Condition no. of days is required!", imgMessage.ERROR);						
						return false;
					}else if ($F("accidentProrateFlag") == "1" && parseFloat($F("accidentNoOfDays")) < 0){
						showMessageBox("Entered pro-rate number of days is invalid. Valid value is from 0 to 99999", imgMessage.ERROR);						
						return false;	
					}else if ($F("accidentProrateFlag") == "3" && $F("accidentShortRatePercent").blank() && $F("accidentFromDate") != "" && $F("accidentToDate") != ""){
						showMessageBox("Condition short rate percent is required!", imgMessage.ERROR);						
						return false;
					}else if ($F("accidentProrateFlag") == "3" && parseFloat($F("accidentShortRatePercent")) <= 0 ){
						showMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR);						
						return false;
					}else if ($F("accidentProrateFlag") == "3" && parseFloat($F("accidentShortRatePercent")) > 100 ){
						showMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR);						
						return false;
					}else if ($F("accidentProrateFlag") == "3" && isNaN(parseFloat($F("accidentShortRatePercent")))){
						showMessageBox("Entered short rate percent is invalid. Valid value is from 0.000000001 to 100.000000000.", imgMessage.ERROR);						
						return false;
					}	
				}				

				var changes = changeTag;
				content = 	'<label name="textItem" style="width: 5%; text-align: right; margin-right: 10px;" labelName="itemNo">'+itemNo+'</label>' +						
							'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemTitle+'">'+(itemTitle == "" ? "---" : itemTitle.truncate(15, "..."))+'</label>'+
							'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemDesc+'">'+(itemDesc == "" ? "---" : itemDesc.truncate(15, "..."))+'</label>' +
							'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "---" : itemDesc2.truncate(15, "..."))+'</label>' +
							'<label name="textItem2" style="width: 10%; text-align: left;" title="'+currencyText+'">'+currencyText.truncate(10, "...")+'</label>' +
							'<label name="textRate" style="width: 10%; text-align: right; margin-right: 10px;">'+formatToNineDecimal(rate)+'</label>' +
							'<label name="textItem" style="text-align: left;" title="'+coverageText+'">'+(coverageText == "" ? "---" :coverageText.truncate(15, "..."))+'</label>';
				
				if($F("btnAdd") == "Update"){						
					$("row"+itemNo).update(						
							generateAdditionalItems(false, null, $F("globalLineCd"), 0) + content);						
					//reset
					updateTempNumbers();								
					setDefaultValues();									
					buttonBehavior("Add");

					changes = 0;
					masterDetail = false;

					hideItemPerilInfos();
					//setRecordListPerItem(false);
					//checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
													
				} else{		
					var itemTable = $("parItemTableContainer");
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "row"+itemNo);
					newDiv.setAttribute("name", "rowItem");
					newDiv.setAttribute("item", itemNo);
					newDiv.addClassName("tableRow");
					//newDiv.setStyle("display : none");
					newDiv.update(						
						generateAdditionalItems(false, null, $F("globalLineCd"), 0) + content);		
					itemTable.insert({bottom : newDiv});
					//supplyItemInfo(false, null, newDiv.down("input", 1).value);					
					updateTempNumbers();
					setDefaultValues();
					//generateItemInfo();
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
							selectedItemRow = newDiv;
							preLoadSelectedItemRowProcedures();
							/*
							if(changeTag == 1){			
								showConfirmBox("Confirmation", "There are unsaved changes you have made. Do you want to cancel it?", "Yes", "No", loadSelectedItemRowProcedures, untoggleSelectedRow);			
							}else{
								preLoadSelectedItemRowProcedures();									
							}
							*/							
					});	
					//$("wItemParCount").value = parseInt($F("wItemParCount")) + 1;
					setCopyPerilButton();
					changes = 0;
					masterDetail = false;														
				}
			}
			generateItemInfo();	
			checkTableItemInfo("itemTable","parItemTableContainer","rowItem");
			loadDispalyTextTruncator();			
			
			//changeTag = changes;
			}catch(e){
				showErrorMessage("itemInformation.jsp - btnAdd", e);
			}					
	});

	$("btnDelete").observe("click",
		function(){
			checkGIPIWItem();			
			if($F("tempVariable") == "1"){
				$("tempVariable").value = "0";
				return false;
			}

			$("nbtInvoiceSw").value = "Y";
				
			$$("div#itemTable div[name='rowItem']").each(
				function(row){
					if(row.hasClassName("selectedRow")){
						Effect.Fade(row,{
							duration : .2,
							afterFinish :
								function(){									
									checkTableIfEmpty("rowItem", "itemTable");
									var parId	= $F("globalParId");
									var itemNo	= $F("itemNo");
									var itemTable = $("parItemTableContainer");
									var newDiv = new Element("div");
									
									$("deleteItemNumbers").value = $F("deleteItemNumbers") + itemNo + " ";
									
									newDiv.setAttribute("id", "rowDelete"+itemNo);
									newDiv.setAttribute("name", "rowDelete");
									newDiv.addClassName("tableRow");
									newDiv.setStyle("display : none");
									newDiv.update(
										'<input type="hidden" name="delParIds" 	value="'+parId+'" />' +
										'<input type="hidden" name="delItemNos" value="'+itemNo+'" />');
									itemTable.insert({bottom : newDiv});															
									row.remove();
									buttonBehavior("Add");									
									updateTempNumbers();									
									supplyItemInfo(false, row, itemNo);									
									setRecordListPerItem(false);									
									removeAllRowListing();									
									setDefaultValues();
									checkTableItemInfo("itemTable","parItemTableContainer","rowItem");
									checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+itemNo, "row2");

									if($("mortgageeTable") != null){
										checkPopupsTable("mortgageeTable","mortgageeListing","rowMortg");
									}
									
									if($("deductiblesTable2") != null){
										checkPopupsTable("deductiblesTable2", "wdeductibleListing2", "ded2");
									}

									if($("deductiblesTable3") != null){
										checkPopupsTable("deductiblesTable3", "wdeductibleListing3", "ded3");
									}									
									
									//$("wItemParCount").value = parseInt($F("wItemParCount")) - 1;
									setCopyPerilButton();
									$("nbtInvoiceSw").value = "Y";
								}
						});
						checkTableItemInfo("itemTable","parItemTableContainer","rowItem");						
					}
				});
	});
	
	function buttonBehavior(status){
		var buttonList = ["btnDelete", "btnCopyItemInfo", "btnCopyItemPerilInfo", //"btnRenumber",
		          		  "btnAssignDeductibles", "btnOtherDetails", "btnAttachMedia"];
		if(status == "Add"){
			$("btnAdd").value = "Add";			

			$$("input[type=button]").each(
				function(elem){
					if(elem.hasClassName("button") && buttonList.indexOf(elem.getAttribute("id")) > -1){
						disableButton(elem.readAttribute("id"));						
					}
				}
			);
			if($F("globalLineCd") == "EN" && $F("globalSublineCd")) {
				disableButton("btnLocation");
			}
			//enableButton("btnSave");
			$("itemNo").enable();		
		} else{
			$("btnAdd").value = "Update";

			$$("input[type=button]").each(
					function(elem){
						if(elem.hasClassName("disabledButton") && buttonList.indexOf(elem.getAttribute("id")) > -1){							
							enableButton(elem.readAttribute("id"));
						}
					}
				);
			if($F("globalLineCd") == "EN" && $F("globalSublineCd")) {
				enableButton("btnLocation");
			}
			//disableButton("btnSave");
			$("itemNo").disable();		
		}
		
		if ($F("globalLineCd") == "AV"){
			disableButton("btnCopyItemInfo");
			disableButton("btnCopyItemPerilInfo");
			disableButton("btnAttachMedia");
		}	
	}	
	
	function supplyItemInfo(blnApply, row, itemNo){
		
		var itemFromDate = $F("fromDate");
		var itemToDate = $F("toDate");
		var regionCd = ($F("globalLineCd") == "FI") ? "fireRegionCd" : "region";
		var itemFields = ["itemNo", 		"itemTitle", 		"itemGrp", 		"itemDesc", 
		                  "itemDesc2", 		"tsiAmt", 			"premAmt", 		"annPremAmt",	
		                  "annTsiAmt", 		"recFlag",			"currency", 	"rate", 
		                  "groupCd", 		"fromDate", 		"toDate", 		"packLineCd", 
		                  "packSublineCd", 	"discountSw", 		"coverage", 	"otherInfo", 
		                  "surchargeSw", 	"region", 			"changedTag", 	"prorateFlag", 
		                  "compSw", 		"shortRtPercent",	"packBenCd", 	"paytTerms", 
		                  "riskNo", 		"riskItemNo"];

        if(blnApply){            
        	for(var index=0, length=30; index<length; index++){            	
            	$(itemFields[index]).value =  row.down("input", index+1).value;            	         	 			
            }			
            
        	$("rate").value = formatToNineDecimal(row.down("input", 12).value);
        	$("discountSw").checked = row.down("input", 18).value == "Y" ? true : false;
        	$("surchargeSw").checked = row.down("input", 21).value == "Y" ? true : false;        	
        	$("cgCtrlIncludeSw").enable();
        	
        	if ($("currency").value == "1"){
        		$("rate").disable();
        	}else{
        		$("rate").enable();
        	}
			
        	if(checkIfItemHashExistingPeril2($F("itemNo"))){            	
				$("currency").disable();
        	}        	
        } else{        	        
        	for(var index=0, length=29; index<length; index++){
    			$(itemFields[index]).value = "";
            }
            $("itemNo").value = itemNo; 
            generateItemInfo(); //orio to generate the correct next item no           
        	
        	$("recFlag").value = "A";
        	$("rate").value = formatToNineDecimal("1.00");
        	$("fromDate").value = itemFromDate;
        	$("toDate").value = itemToDate;

        	$("currency").enable();        	            
        }		
		
		if($F("globalLineCd") == "MC"){
			if((row.childElements()).size() > 38 /* 38 is the minimum number of elements in a row */){
				suppyVehicleInfo(blnApply, row);
				$("generateCOCSerialNo").enable();
				$("generateCOCSerialNo").checked = row.down("input", 60).value =="Y" ? true : false;

				if($("generateCOCSerialNo").checked){
					$("cocSerialNo").disable();	
				}else{
					if($F("varGenerateCoc") == "Y"){
						$("cocSerialNo").enable();
					}
				}
			}else{
				supplyVehicleInfo(false, null);
				$("cocType").value	= ($F("sublineCd") == $F("varSublineLto")) ? $F("varCocLto") : $F("varCocNlto");

				if($F("varGenerateCoc") == "Y"){
					$("generateCOCSerialNo").enable();
				}else{
					$("generateCOCSerialNo").disable();
				}
				$("generateCOCSerialNo").checked = false;
			}						
		} else if($F("globalLineCd") == "FI"){
			if((row.childElements()).size() > 38){
				setCursor("wait");
				supplyFireInfo(blnApply, row);
				if(!blnApply){				
					$("riskNo").value	= "1";			
					$("fireFromDate").value = $F("fromDate");
					$("fireToDate").value = $F("toDate");
					$("locRisk1").value	= $F("mailAddr1");
					$("locRisk2").value	= $F("mailAddr2");
					$("locRisk3").value	= $F("mailAddr3");
				}
				setCursor("default");
			}else{
				supplyFireInfo(false, null);
			}
		}else if ($F("globalLineCd") == "MN") {
			supplyMarineCargoInfo(blnApply, row);
			$("fromDate").value = itemFromDate;
        	$("toDate").value = itemToDate;
		} else if ($F("globalLineCd") == "AV") {
			supplyAviationInfo(blnApply, row);
			$("fromDate").value = itemFromDate;
        	$("toDate").value = itemToDate;
		} else if ($F("globalLineCd") == "CA") {
			supplyCasualtyInfo(blnApply, row);
			$("fromDate").value = itemFromDate;
        	$("toDate").value = itemToDate;
		} else if ($F("globalLineCd") == "AH") {
			supplyAccidentInfo(blnApply, row);
		} else if($F("globalLineCd") == "MH"){
			supplyMarineHullInfo(blnApply, row);
		}			
	}
	
	function suppyVehicleInfo(blnApply, row){
		var vehicleFields1 = ["assignee", 		"acquiredFrom", "motorNo", 	"origin",
		                      "destination", 	"typeOfBody", 	"plateNo", 	"modelYear",
		                      "carCompany", 	"mvFileNo", 	"noOfPass", "makeCd",
		                      "basicColor"];

        if(blnApply){
			//for(var index=0, length=13; index<length; index++){
			//	$(vehicleFields1[index]).value = row.down("input", index + 31).value;
			//}
			
			$("assignee").value 		= row.down("input", 31).value;
			$("acquiredFrom").value 	= row.down("input", 32).value;
			$("motorNo").value 			= row.down("input", 33).value;
			$("origin").value 			= row.down("input", 34).value;
			$("destination").value 		= row.down("input", 35).value;
			$("typeOfBody").value 		= row.down("input", 36).value;
			$("plateNo").value 			= row.down("input", 37).value;
			$("modelYear").value 		= row.down("input", 38).value;
			$("carCompany").value 		= row.down("input", 39).value;
			$("mvFileNo").value 		= row.down("input", 40).value;
			$("noOfPass").value 		= row.down("input", 41).value;
			$("makeCd").value 			= row.down("input", 42).value;
			$("basicColor").value 		= row.down("input", 43).value;
			$("colorCd").value			= row.down("input", 45).value;
			$("engineSeries").value		= row.down("input", 46).value;
			$("motorType").value		= row.down("input", 47).value;
			$("unladenWt").value		= row.down("input", 48).value;
			$("towLimit").value			= formatCurrency(row.down("input", 49).value);
			$("serialNo").value			= row.down("input", 50).value;
			$("sublineType").value		= row.down("input", 51).value;
			$("deductibleAmount").value	= formatCurrency(computeTotalFieldAmountInTable("wdeductibleListing2", "ded2", 5, $F("itemNo"), 0)); //row.down("input", 52).value;
			$("cocType").value			= row.down("input", 53).value;
			$("cocSerialNo").value		= row.down("input", 54).value;
			$("cocYy").value			= row.down("input", 55).value;
			$("ctv").checked			= row.down("input", 56).value == 'Y' ? true : false;
			$("repairLimit").value		= formatCurrency(row.down("input", 57).value);
			$("motorCoverage").value	= row.down("input", 58).value == 0 ? "" : row.down("input", 58).value;
			
			if(row.down("input", 42).value.trim() != ""){				
				reloadLOV("makeCd");
				//updateLOV("makeCd", "carCompanyCd", "carCompany");
				for(var index=0, length = $("makeCd").options.length; index < length; index++){
					var attributeValue = $("makeCd").options[index].getAttribute("carCompanyCd"); 
					if(attributeValue != $F("carCompany")) {
						$("makeCd").options[index].hide();
					}else{
						if(row.down("input", 42).value == $("makeCd").options[index].getAttribute("value")){
							$("makeCd").options[index].selected = true;
						}
					}
				}
			}
			
			if(row.down("input", 46).value.trim() != ""){								
				for(var index=0, length = $("engineSeries").options.length; index < length; index++){
					var attributeValue1 = $("engineSeries").options[index].getAttribute("makeCd");
					var attributeValue2 = $("engineSeries").options[index].getAttribute("carCompanyCd"); 
					if((parseInt(attributeValue1) == parseInt($F("makeCd"))) && 
							(parseInt(attributeValue2) == parseInt($F("carCompany")))){												
							$("engineSeries").options[index].show();
							if(row.down("input", 46).value == $("engineSeries").options[index].getAttribute("value")){
								$("engineSeries").options[index].selected = true;
							}														
					}else{
						$("engineSeries").options[index].hide();
					}					
				}				
			}
			
			if (!($("accessory").empty())){
				computeTotalAmountInTable("accessoryTable","acc",4,"item",$F("itemNo"),"accTotalAmtDiv");	
				filterLOV("selAccessory","acc",2,"","item",$F("itemNo"));	
			}
        } else{
        	$("assignee").value 		= "";
			$("acquiredFrom").value 	= "";
			$("motorNo").value 			= "";
			$("origin").value 			= "";
			$("destination").value 		= "";
			$("typeOfBody").value 		= "";
			$("plateNo").value 			= "";
			$("modelYear").value 		= "";
			$("carCompany").value 		= "";
			$("mvFileNo").value 		= "";
			$("noOfPass").value 		= "";
			$("makeCd").value 			= "";
			$("basicColor").value 		= "";
			$("colorCd").value			= "";
			$("engineSeries").value		= "";
			$("motorType").value		= "";
			$("unladenWt").value		= "";
			$("towLimit").value			= "";
			$("serialNo").value			= "";
			$("sublineType").value		= "";
			$("deductibleAmount").value	= "";
			$("cocType").value			= "";
			$("cocSerialNo").value		= "";
			$("cocYy").value			= "";
			$("ctv").checked			= false;
			$("repairLimit").value		= "";
			$("motorCoverage").value	= "";

			if($F("colorCd") != ""){        		
        		reloadLOV("colorCd");
				updateLOV("colorCd", "basicColorCd", "basicColor");
        	}
        }		
	}
	
	function supplyFireInfo(blnApply, row){
		var fireFields = ["eqZone", "fireFromDate", "assignee", "typhoonZone",
		                  "fireToDate", "frItemType", "floodZone", "locRisk1",
		                  "fireRegionCd", "tariffZone", "locRisk2", "province",
		                  "tarfCd", "locRisk3", "city", "construction",
		                  "front", "district", "constructionRemarks", "right",
		                  "block", "occupancy", "left", "risk",
		                  "occupancyRemarks", "rear"];

		$("city").disable();
		$("district").disable();
		$("block").disable();
		$("risk").disable();
		
        if(blnApply){

			for(var index=0, length=26; index<length; index++){
				$(fireFields[index]).value = row.down("input", index+31).value;
			}
			$("city").value = getCityCode(row.down("input", 45).value);
			
        } else{
			for(var index=0, length=26; index<length; index++){
				$(fireFields[index]).value = "";
			}
			$("locRisk1").value	= $F("mailAddr1");
			$("locRisk2").value	= $F("mailAddr2");
			$("locRisk3").value	= $F("mailAddr3");
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
						$("vesselCd").options[i].disabled = false;
					} else {
						$("vesselCd").options[i].hide();
						$("vesselCd").options[i].disabled = true;
					}		
				}
				$("vesselCd").value = row.down("input", 49).value;
			} else {
				$("geogCd").value = row.down("input", 48).value;
				for(var i = 1; i < $("vesselCd").options.length; i++){
					$("vesselCd").options[i].show();
					$("vesselCd").options[i].disabled = false;
				}	 
				$("vesselCd").value = row.down("input", 49).value;
			}		
			if(row.down("input", 50).value.trim() != ""){
				$("cargoClassCd").value = row.down("input", 50).value;
				$("cargoType").selectedIndex = 0;
				for(var i = 1; i < $("cargoType").length; i++){ 
					$("cargoType")[i].hide();
					$("cargoType").options[i].disabled = true;
				}
				for(var i = 1; i < $("cargoType").options.length; i++){  
					if ($("cargoType").options[i].getAttribute("cargoClassCd") == $("cargoClassCd").value){
						$("cargoType").options[i].show();
						$("cargoType").options[i].disabled = false;
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
	
	function supplyAviationInfo(blnApply, row){
		var aviationFields = ["purpose","deductText","prevUtilHrs",
		                 		 "estUtilHrs","totalFlyTime","qualification",
		                 		 "geogLimit"];
		if(blnApply){ 
			for(var index=0, length=7; index<length; index++){
				$(aviationFields[index]).value = row.down("input", index+31).value;
			}
			aviationFilterLOV();
			if(row.down("input", 38).value.trim() != ""){
				for(var i = 1; i < $("vesselCd").options.length; i++){ 
					if (row.down("input", 38).value == $("vesselCd").options[i].value){
						$("vesselCd").options[i].show();
						$("vesselCd").options[i].disabled = false;
					}
				}
				$("vesselCd").value = row.down("input", 38).value;
				$("airType").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("airDesc");
	    		$("rpcNo").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("rpcNo");
			}
			if(row.down("input", 39).value.trim() != ""){
				$("recFlagAv").value = row.down("input", 39).value;
			}	
			if ($F("globalParType") == "E"){
				if ($F("recFlag") == "A" && $F("recFlagAv") == "A"){
					$("qualification").addClassName("required");
					$("geogLimit").addClassName("required");	
				} else if ($F("recFlag") == "C" && $F("recFlagAv") == "C"){
					$("qualification").removeClassName("required");
					$("geogLimit").removeClassName("required");
				}			
			}
		} else{
			clearAviationModule();
		}	
	}	
	
	function supplyCasualtyInfo(blnApply, row){
		clearCasualtyModule();
		var casualtyFields = ["location","limitOfLiability","sectionLineCd",
		                 		 "sectionSublineCd","interestOnPremises","sectionOrHazardInfo",
		                 		 "conveyanceInfo","propertyNo"];
		if(blnApply){ 
			for(var index=0, length=8; index<length; index++){
				$(casualtyFields[index]).value = row.down("input", index+31).value;
			}
			if(row.down("input", 39).value.trim() != ""){
				$("locationCd").value = row.down("input", 39).value;
			} else{
				$("locationCd").selectedIndex = 0;
			}	
			if(row.down("input", 40).value.trim() != ""){
				$("sectionOrHazardCd").value = row.down("input", 40).value;
				if ($("sectionLineCd").value == ""){
					$("sectionLineCd").value = $("sectionOrHazardCd").options[$("sectionOrHazardCd").selectedIndex].getAttribute("sectionLineCd");
				}
				if ($("sectionSublineCd").value == ""){
		    		$("sectionSublineCd").value = $("sectionOrHazardCd").options[$("sectionOrHazardCd").selectedIndex].getAttribute("sectionSublineCd");
				}
			} else{
				$("sectionOrHazardCd").selectedIndex = 0;
			}
			if(row.down("input", 41).value.trim() != ""){
				$("capacityCd").value = row.down("input", 41).value;
			} else{
				$("capacityCd").selectedIndex = 0;
			}
			if(row.down("input", 42).value.trim() != ""){
				$("propertyNoType").value = row.down("input", 42).value;
			} else{
				$("propertyNoType").selectedIndex = 0;
			}
			checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
			computeTotalAmountInTable("groupedItemsTable","grpItem",4,"item",$F("itemNo"),"groupedItemsTotalAmtDiv");
			computeTotalAmountInTable("personnelTable","per",4,"item",$F("itemNo"),"personnelInfoTotalAmtDiv");
		} else{
			clearCasualtyModule();
		}		 
	}	
	
	function supplyAccidentInfo(blnApply, row){
		var accidentFields = ["noOfPerson","destination","monthlySalary",
		                 		 "salaryGrade"];
		if(blnApply){ 
			$("accidentFromDate").value  	= row.down("input", 14).value;
			$("accidentToDate").value    	= row.down("input", 15).value;
			$("accidentPackBenCd").value 	= row.down("input", 27).value;
			$("accidentPaytTerms").value 	= row.down("input", 28).value;
			$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");

			$("accidentProrateFlag").value = (row.down("input", 24).value == "" ? "2" :row.down("input", 24).value);
			if (row.down("input", 24).value == "" || row.down("input", 24).value == "2"){
				$("shortRateSelectedAccident").hide();
				$("prorateSelectedAccident").hide();
				$("accidentNoOfDays").value = "";
				$("accidentShortRatePercent").value = "";
				$("accidentCompSw").selectedIndex = 2;
			}	
			$("accidentCompSw").value = row.down("input", 25).value;
			$("accidentShortRatePercent").value = row.down("input", 26).value == "" || row.down("input", 26).value == "NaN"? "" :formatToNineDecimal(row.down("input", 26).value);
			
			for(var index=0, length=4; index<length; index++){
				$(accidentFields[index]).value = row.down("input", index+31).value;
			}
			if(row.down("input", 35).value.trim() != ""){
				$("positionCd").value = row.down("input", 35).value;
			} else{
				$("positionCd").selectedIndex = 0;
			}	
			$("deleteGroupedItemsInItem").value = row.down("input", 36).value;
			$("pDateOfBirth").value 			= row.down("input", 37).value;
			$("pAge").value						= row.down("input", 38).value;
			$("pCivilStatus").value 			= row.down("input", 39).value;
			$("pSex").value 					= row.down("input", 40).value;
			$("pHeight").value 					= row.down("input", 41).value;
			$("pWeight").value 					= row.down("input", 42).value;
			$("groupPrintSw").value 			= row.down("input", 43).value;
			$("acClassCd").value 				= row.down("input", 44).value;
			$("levelCd").value 					= row.down("input", 45).value;
			$("parentLevelCd").value 			= row.down("input", 46).value;
			$("itemWitmperlExist").value 		= row.down("input", 47).value;
			$("itemWitmperlGroupedExist").value = row.down("input", 48).value;
			$("populatePerils").value 			= row.down("input", 49).value;
			$("itemWgroupedItemsExist").value 	= row.down("input", 50).value;
			$("accidentDeleteBill").value 		= row.down("input", 51).value;
			$("noOfPerson").value 				= ($("noOfPerson").value == "" ? "" :formatNumber($("noOfPerson").value));
			
			if (parseInt($F("noOfPerson").replace(/,/g, "")) >1){
				enableButton("btnGroupedItems");
				disableButton("btnPersonalAddtlInfo");	
				$("personalAdditionalInfoDetail").hide();
				$("personalAdditionalInformationInfo").hide();
				$("showPersonalAdditionalInfo").update("Show");
				$("personalAdditionalInfoDetail").hide();
				$("monthlySalary").disable();
				$("salaryGrade").disable();
				$("monthlySalary").clear();
				$("salaryGrade").clear();
			} else{
				enableButton("btnPersonalAddtlInfo");
				disableButton("btnGroupedItems");
				$("personalAdditionalInfoDetail").show();
				$("personalAdditionalInformationInfo").hide();
				$("showPersonalAdditionalInfo").update("Show");
				$("personalAdditionalInfoDetail").show();
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

			showRelatedSpan();

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
			}
			
			if ($F("itemWitmperlGroupedExist") == "Y"){
				$("accidentProrateFlag").disable();
				$("accidentShortRatePercent").disable();
				$("accidentCompSw").disable();
				$("accidentNoOfDays").disable();
				$("accidentFromDate").disable();
				$("hrefAccidentFromDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
				$("accidentToDate").disable();
				$("hrefAccidentToDate").setAttribute("onClick","showMessageBox('You cannot alter, insert or delete record in current field because changes will have an effect on the computation of TSI amount and Premium amount of the existing records in grouped item level', imgMessage.ERROR);");
				$("currency").disable();
				$("rate").disable();
			} else if ($F("itemWitmperlExist") == "Y" && $F("itemWitmperlGroupedExist") != "Y")	{
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
	
	function supplyMarineHullInfo(blnApply, row){
		clearMarineHullModule();
		var marineHullFields=["vesselCd", "vesselName", "vesselOldName", "vesTypeDesc",
		              		 "propelSw",  "vessClassDesc", "hullDesc", "regOwner",	
		              		 "regPlace", "grossTon", "vesselLength", "yearBuilt", 
		              		 "netTon", 	"vesselBreadth", "noCrew", "deadWeight",
		              		  "vesselDepth", "crewNat", "dryPlace", "dryDate",
		              		   "geogLimit", "deductText"];

		if(blnApply){
			for(var index=0, length=22; index<length; index++){
				$(marineHullFields[index]).value = row.down("input", index+31).value;
			}
			if($F("vesselCd")!= ""){
				var noCrew 			= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("noCrew");
				var netTon 			= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("netTon");
				var grossTon 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("grossTon");
				var yearBuilt 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("yearBuilt");
				var vesselBreadth 	= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselBreadth");
				var deadWeight 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("deadWeight");
				var vesselDepth 	= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselDepth");
				var vesselLength 	= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselLength");
				var vesselOldName 	= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselOldName");
				var regOwner 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("regOwner");
				var regPlace 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("regPlace");
				var crewNat 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("crewNat");
				
				$("vesselName").value 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselName");
				$("vesselOldName").value 	= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesselOldName");
				$("vesTypeDesc").value 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vesTypeDesc");
				$("propelSw").value 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("propelSw");
				$("vessClassDesc").value 	= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("vessClassDesc");
				$("hullDesc").value 		= $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("hullDesc");
				$("regPlace").value 		= (regPlace==""?"-":regPlace);
				$("regOwner").value 		= (regOwner==""?"-":regOwner);
				$("crewNat").value 			= (crewNat==""?"-":crewNat);
				$("grossTon").value 		= (grossTon==""?"-":grossTon);
				$("vesselLength").value 	= (vesselLength==""?"-":vesselLength);
				$("yearBuilt").value 		= (yearBuilt==""?"-":yearBuilt); 
				$("netTon").value 			= (netTon==""?"-":netTon);
				$("vesselBreadth").value 	= (vesselBreadth==""?"-":vesselBreadth);
				$("noCrew").value 			= (noCrew == ""? "-":noCrew);
				$("deadWeight").value 		= (deadWeight==""?"-":deadWeight);
				$("vesselDepth").value 		= (vesselDepth==""?"-":vesselDepth);				
			}		
		}
	}
	
	function setDefaultValues(){
		//$("itemNo").value 			= $F("itemNo");
		var lineCd = $F("globalLineCd");

		if (lineCd == "CA"){
			var ora2010Sw = $F("ora2010Sw");
		}	
		
		$$("input[type=text]").each(
			function(elem){
				if(elem.hasClassName("money")){
					//elem.value = "0.00";
					elem.value = "";
				} else if(elem.hasClassName("moneyRate2")){
					elem.value  = formatToNineDecimal("1.00");
				} else{
					elem.value = "";
				}				
			}
		);

		$$("select").each(
			function(elem){
				elem.value = "";
			}
		);
		
		generateItemInfo();		
		
		$("currency").value 		= "1";
		$("coverage").value 		= $F("parDefaultCoverage");	
		$("region").value			= $F("regionCd");	
		$("rate").disable(); // if currency is PHP then disabled the rate
		$("currency").enable();
		$("varOldCurrencyCd").value	= $F("currency");
		
		if(lineCd == "MC"){
			$("typeOfBody").value		= "";
			$("carCompany").value		= "";
			$("makeCd").value			= "";
			$("basicColor").value		= "";
			$("colorCd").value			= "";
			$("motorType").value		= "";
			$("sublineType").value		= "";
			$("towLimit").value			= $F("towing");			
			$("ctv").checked			= false;
			$("region").addClassName("required");
			$("cocType").value			= ($F("sublineCd") == $F("varSublineLto")) ? $F("varCocLto") : $F("varCocNlto");

			if($F("varGenerateCoc") == "Y"){
				$("generateCOCSerialNo").enable();
			}else{
				$("generateCOCSerialNo").disable();
			}
			$("generateCOCSerialNo").checked = false;			

			reloadLOV("makeCd");
			reloadLOV("engineSeries");
			
			if (!($("accessory").empty())){
				checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));   	
				$("accTotalAmtDiv").hide();
				filterLOV("selAccessory","acc",2,"","item",$F("itemNo"));
			}
		} else if(lineCd == "FI"){
			$("riskNo").value	= "1";				
			//$("fireFromDate").value = $F("fromDate");
			//$("fireToDate").value = $F("toDate");
			$("locRisk1").value	= $F("mailAddr1");
			$("locRisk2").value	= $F("mailAddr2");
			$("locRisk3").value	= $F("mailAddr3");
			//to hide the region cd LOV in item screen if line cd = FIRE
			$("region").up("tr",0).hide();
			$("city").disable();
			$("district").disable();
			$("block").disable();
			$("risk").disable();
		} else if(lineCd == "MN"){
			$("region").addClassName("required");
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
			$("paramVesselCd").value    = "";
			hideCoverage();
			$("cargoType").selectedIndex = 0;
			$("cargoClassCd").selectedIndex = 0;
			$("invCurrCd").selectedIndex = 0;
		} else if (lineCd == "AV"){
			clearAviationModule();
			aviationFilterLOV();
		} else if (lineCd == "CA"){
			clearCasualtyModule();
			$("ora2010Sw").value = ora2010Sw;
			computeTotalAmountInTable("groupedItemsTable","grpItem",4,"item",$F("itemNo"),"groupedItemsTotalAmtDiv");
			computeTotalAmountInTable("personnelTable","per",4,"item",$F("itemNo"),"personnelInfoTotalAmtDiv");
		} else if (lineCd == "AH"){
			clearAccidentModule();
		} else if (lineCd == "EN"){
			hideCoverage();
		}		 	
		$$("div#itemTable div[name='rowItem']").each(function (div) {
			div.removeClassName("selectedRow");
		});	
		$("parNo").value = $F("globalParNo");
		$("assuredName").value = $F("globalAssdName");		
		enableButton("btnRenumber");		
		$("discountSw").checked = false;
    	$("surchargeSw").checked = false;    	
    	$("cgCtrlIncludeSw").disable();

    	if(lineCd != "AV" || lineCd != "EN"){
			$("cgCtrlIncludeSw").checked = false;
    	}
    	changeTag = 0;
	}	
	
	/* this is for FIRE */
	/*function filterCityByProvince(paramVal, province){		
		reloadLOV("city");
		updateLOV("city","provinceCd","province");
		$("district").value = "";
		reloadLOV("district");
		updateLOV("district", "provinceCd", "province");
		$("block").value ="";
		reloadLOV("block");
		updateLOV("block","provinceCd","province");
		getCityCode(paramVal);	
	}
	
	function filterDistrictByProvinceByCity(paramVal, province, city){		
		$("district").value = paramVal;
	}
	
	function filterBlock (paramVal, province, city, district){		
		$("block").value = paramVal;
	}
	
	function filterRisk(paramVal, block){	
		reloadLOV("risk");
		updateLOV("risk","blockId","block");
		$("risk").value = paramVal;
	} commented by: nica 10.04.2010 unused functions*/ 
	
	function getCityCode(paramVal){
		for (var i=0; i<$("city").length; i++){
			if (paramVal == $("city").options[i].getAttribute("cityDesc")){
				$("city").selectedIndex = i;
			}
		}
	}
	/* end for FIRE */

	
	$("itemNo").observe("blur",
		function(){
			var exist = false;
			
			$$("div#itemTable div[name='rowItem']").each(
				function(row){
					if(row.down("input", 1).value == $F("itemNo")){
						exist = true;
					}			
				});
			
			if($F("itemNo") < 1 || $F("itemNo") > 999999999){
				showMessageBox("Entered item no. is invalid. Valid value is from 1 to  999999999 and it must be unique.", imgMessage.ERROR);
				$("itemNo").value = "";
			}else if(exist){
				showMessageBox("Item no. must be unique.", imgMessage.ERROR);
				$("itemNo").value = "";
			}
	});
	
	$("currency").observe("change",
		function(){			
			if($F("varOldCurrencyCd") != $F("currency")){
				$("varGroupSw").value = "Y";
			}
			
			getRates();
			if ($("currency").value == "1"){
				$("rate").disable();
			}else{
				$("rate").enable();
			}																		
		});
	
	$("rate").observe("blur",
		function(){
			if(parseFloat($F("rate")) > 999.999999999 || parseFloat($F("rate")) <= 0){
				showMessageBox("Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999.", imgMessage.ERROR);
				//validateRate("rate");
				//validateCurrency("rate", "Invalid Currency Rate. Value should be from 0.000000001 to 100.000000000.", "popup", 0.000000001, 100.000000000);
				//$("rate").clear();
				return false;
			}
		});	
	
	function confirmCopyItem(){
		// load deductibles table to get records
		if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
			loadDeductibleTables();
		}
		
		// check deductible		
		if($$("div#deductiblesTable2 div[name='ded2']").size() > 0){
			$("copyPeril").value = "N";
			showConfirmBox("Deductibles", "The PAR has existing item level deductible/s based on % of TSI. " + 
					"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
					"Continue?", "Yes", "No", confirmCopyItem2, stopProcess);
		}else{
			confirmCopyItem2();
		}		
	}

	function confirmCopyItemPeril(){
		// load deductibles table to get records
		if($("deductiblesTable2") == null && $("deductiblesTable3") == null){
			loadDeductibleTables();
		}
				
		// check deductible
		$("copyPeril").value = "Y";		
		if($$("div#deductiblesTable1 div[name='ded1']").size() > 0){
			showConfirmBox("Deductibles", "The PAR has existing policy level deductible/s based on % of TSI. " + 
					"Copying the item info will not copy the existing deductible/s because there is no TSI yet for the item. " +
					"Continue?", "Yes", "No", confirmCopyItem2, stopProcess);
		}else{
			confirmCopyItem2();
		}
	}

	function confirmCopyItem2(){
		$("deletePolicyDeductible").value = "Y";

		if($F("varDiscExist") == "Y"){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
					"Yes", "No", confirmCopyItem3, updateVariablesDiscExist);
		}else{
			confirmCopyItem3();
		}
	}

	function confirmCopyItem3(){
		var messageText = "";
		var includePeril = "";
		var newItemNo = getNextItemNo("itemTable", "rowItem");
		if($F("copyPeril") == "Y"){
			includePeril = " and perils ";
		}else{
			includePeril = "";
		}
		
		if($("cgCtrlIncludeSw").checked){
			messageText = "This will create new item (" + newItemNo.toPaddedString(3) + ") with the same item information " + includePeril +
							"(including additional information) as the current item display. Do you want to continue?" ;
			$("cgCtrlIncludeSw").checked = true;
		}else{
			messageText = "This will create new item (" + newItemNo.toPaddedString(3) + ") with the same item information " + includePeril +
							"(excluding additional information) as the current item display. Do you want to continue?" ;
			$("cgCtrlIncludeSw").checked = false;
		}
		
		showConfirmBox("Copy Item", messageText, "Yes", "No", copyItem, stopProcess);		
	}

	/*	Created by	: mark jm 09.13.2010	
	*	Description	: Copy item and it's details based on selected record 
	*/
	function copyItem(){
		var rowHash		= new Hash();
		var includeAddl	= $("cgCtrlIncludeSw").checked ? "Y" : "N";
		var copyItemNo	= $F("itemNo");		
		
		rowHash = generateItemRowHashMap($("row" + copyItemNo));
		$("row" + copyItemNo).removeClassName("selectedRow");
		loadUnselectedItemRowProcedures(copyItemNo);
		
		$("itemNo").value 			= rowHash.get("itemNo");		
        $("itemTitle").value 		= rowHash.get("itemTitle");
        $("itemGrp").value 			= rowHash.get("itemGrp");
        $("itemDesc").value 		= rowHash.get("itemDesc");
        $("itemDesc2").value 		= rowHash.get("itemDesc2");;
        $("tsiAmt").value		 	= rowHash.get("tsiAmt");
        $("premAmt").value 			= rowHash.get("premAmt");
        $("annPremAmt").value 		= rowHash.get("annPremAmt");
        $("annTsiAmt").value 		= rowHash.get("annTsiAmt");
        $("recFlag").value 			= rowHash.get("recFlag");
        $("currency").value 		= rowHash.get("currencyCd");
        $("rate").value 			= formatToNineDecimal(rowHash.get("currencyRt"));
        $("groupCd").value 			= rowHash.get("groupCd");
        $("fromDate").value 		= rowHash.get("fromDate");
        $("toDate").value 			= rowHash.get("toDate");
        $("packLineCd").value 		= rowHash.get("packLineCd");
        $("packSublineCd").value 	= rowHash.get("packSublineCd");
        $("discountSw").value 		= rowHash.get("discountSw");
        $("coverage").value 		= rowHash.get("coverageCd");
        $("otherInfo").value 		= rowHash.get("otherInfo");
        $("surchargeSw").value 		= rowHash.get("surchargeSw");
        $("region").value			= rowHash.get("regionCd");            
        $("changedTag").value 		= rowHash.get("changedTag");
        $("prorateFlag").value 		= rowHash.get("prorateFlag");
        $("compSw").value 			= rowHash.get("compSw");
        $("shortRtPercent").value 	= rowHash.get("shortRtPercent");
        $("packBenCd").value 		= rowHash.get("packBenCd");
        $("paytTerms").value 		= rowHash.get("paytTerms");
        $("riskNo").value 			= rowHash.get("riskNo");
        $("riskItemNo").value 		= ""; //rowHash.get("riskItemNo")
		
        if(includeAddl == "Y"){
			if($F("globalLineCd") == "MC"){				
				$("assignee").value 		= rowHash.get("assignee");
				$("acquiredFrom").value 	= rowHash.get("acquiredFrom");
				$("motorNo").value 			= "";
				$("origin").value 			= rowHash.get("origin");
				$("destination").value 		= rowHash.get("destination");
				$("typeOfBody").value 		= rowHash.get("typeOfBodyCd");
				$("plateNo").value 			= rowHash.get("plateNo");
				$("modelYear").value 		= rowHash.get("modelYear");
				$("carCompany").value 		= rowHash.get("carCompanyCd");
				$("mvFileNo").value 		= rowHash.get("mVFileNo");
				$("noOfPass").value 		= rowHash.get("noOfPass");
				$("makeCd").value 			= rowHash.get("makeCd");
				$("basicColor").value 		= rowHash.get("basicColorCd");
				$("colorCd").value			= rowHash.get("colorCd");
				$("engineSeries").value		= rowHash.get("engineSeries");
				$("motorType").value		= rowHash.get("motorType");
				$("unladenWt").value		= rowHash.get("unladenWt");
				$("towLimit").value			= formatCurrency(rowHash.get("towing"));
				$("serialNo").value			= "";
				$("sublineType").value		= rowHash.get("sublineTypeCd");
				$("deductibleAmount").value	= formatCurrency(rowHash.get("deductibleAmount"));
				$("cocType").value			= rowHash.get("cOCType");
				$("cocSerialNo").value		= "";
				$("cocYy").value			= rowHash.get("cOCYy");
				$("ctv").checked			= rowHash.get("cTV") == "Y" ? true : false;
				$("repairLimit").value		= formatCurrency(rowHash.get("repairLimit"));
				$("motorCoverage").value	= rowHash.get("motorCoverage");				

			}else if($F("globalLineCd") == "FI"){

				$("eqZone").value		 		= rowHash.get("eQZone");
				$("fireFromDate").value 		= rowHash.get("fromDate");
				$("assignee").value 			= rowHash.get("assignee");
				$("typhoonZone").value 			= rowHash.get("typhoonZone");
				$("fireToDate").value			= rowHash.get("toDate");
				$("frItemType").value 			= rowHash.get("fRItemType");
				$("floodZone").value 			= rowHash.get("floodZone");
				$("locRisk1").value				= rowHash.get("locRisk1");
				$("fireRegionCd").value 		= rowHash.get("regionCd");
				$("regionCd").value				= rowHash.get("regionCd");
				$("tariffZone").value 			= rowHash.get("tariffZone");
				$("locRisk2").value 			= rowHash.get("locRisk2");
				$("province").value 			= rowHash.get("provinceCd");
				$("tarfCd").value 				= rowHash.get("tarfCd");
				$("locRisk3").value 			= rowHash.get("locRisk3");
				$("city").text	 				= getCityCode(rowHash.get("city"));
				$("construction").value 		= rowHash.get("constructionCd");
				$("front").value 				= rowHash.get("front");
				$("district").value	 			= rowHash.get("districtNo");
				$("constructionRemarks").value 	= rowHash.get("constructionRemarks");
				$("right").value 				= rowHash.get("right");
				$("block").value 				= rowHash.get("blockId");
				$("occupancy").value 			= rowHash.get("occupancyCd");
				$("left").value 				= rowHash.get("left");
				$("risk").value 				= rowHash.get("riskCd");
				$("occupancyRemarks").value 	= rowHash.get("occupancyRemarks");
				$("rear").value 				= rowHash.get("rear");
			}
			
			
			$("varCopyItemTag").value = "Y";
			//checkTableItemInfo("itemTable","parItemTableContainer","rowItem");
			
			if($("deductiblesTable2") != null){
				var nextItemNo = getNextItemNo("itemTable", "rowItem");
												
				// item deductibles				
				$$("div#deductiblesTable2 div[name='ded2']").each(
					function(row){					
						if(row.getAttribute("item") == copyItemNo){
							var itemNo			= nextItemNo;
							var dedLevel		= "2";
							var perilName 		= row.down("input", 1).value;
							var perilCd 		= row.down("input", 2).value;				
							var deductibleTitle = row.down("input", 3).value;
							var deductibleCd 	= row.down("input", 4).value;
							var deductibleAmt 	= row.down("input", 5).value;
							var deductibleRate 	= row.down("input", 6).value;
							var deductibleText 	= row.down("input", 7).value;
							var aggregateSw 	= row.down("input", 8).value;
							var ceilingSw	 	= row.down("input", 9).value;
							var deductibleType	= row.down("input", 10).value;
							var id				= dedLevel + itemNo + perilCd + deductibleCd;

							if($("ded" + id) == null){
								content = 	'<input type="hidden" id="insDedItemNo'+id+'" 			name="insDedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
											'<input type="hidden" id="insDedPerilName'+id+'" 		name="insDedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
											'<input type="hidden" id="insDedPerilCd'+id+'" 			name="insDedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
											'<input type="hidden" id="insDedTitle'+id+'" 			name="insDedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
											'<input type="hidden" id="insDedDeductibleCd'+id+'"		name="insDedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
											'<input type="hidden" id="insDedAmount'+id+'" 			name="insDedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
											'<input type="hidden" id="insDedRate'+id+'"				name="insDedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
											'<input type="hidden" id="insDedText'+id+'"				name="insDedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
											'<input type="hidden" id="insDedAggregateSw'+id+'"		name="insDedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
											'<input type="hidden" id="insDedCeilingSw'+id+'"		name="insDedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
											'<input type="hidden" id="insDedDeductibleType'+id+'" 	name="insDedDeductibleType'+dedLevel+'"	value="'+deductibleType+'" />'+
											'<label style="width: 36px; text-align: right; margin-right: 10px;">'+itemNo+'</label>'+												
											'<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'">'+deductibleTitle.truncate(25, "...")+'</label>'+		
											'<label style="width: 119px; text-align: right;">'+(deductibleRate == "" ? "-" : formatToNineDecimal(deductibleRate))+'</label>'+
											'<label style="width: 119px; text-align: right;">'+(deductibleAmt == "" ? "-" : formatCurrency(deductibleAmt))+'</label>'+							 
											'<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
											'<label style="width: 33px; text-align: center;">';
					
								var newDiv = new Element('div');
								newDiv.setAttribute("name", "ded"+dedLevel);
								newDiv.setAttribute("id", "ded"+id);
								newDiv.setAttribute("item", itemNo);
								newDiv.setAttribute("dedCd", deductibleCd);
								newDiv.addClassName("tableRow");
								newDiv.setStyle("display: none;");
								
								newDiv.update(content);
								$("wdeductibleListing"+dedLevel).insert({bottom: newDiv});
			
								loadDeductibleNewRecordObserve(newDiv, dedLevel);
							}													
						}							
					});			
				
				checkPopupsTable("deductiblesTable2", "wdeductibleListing2", "ded2");	
				//setTotalAmount(2, $F("itemNo")); // andrew - 09.22.2010 - commented this line, added the next line 
				setTotalAmount(2, $F("itemNo"), 0);
			}
        }

        if($F("copyPeril") == "Y"){			
			copyItemPerilInfo(copyItemNo);
		}else{			
			showMessageBox("Item " + (new Number(copyItemNo)).toPaddedString(3) + " successfully copied to Item No. " + (new Number($F("itemNo"))).toPaddedString(3), imgMessage.INFO);
		}
		
        changeTag = 1;
		checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");        
	}
	
	function updateVariablesDiscExist(){		
		$("varDiscExist").value = 'N';		
	}	

	/*	Created by	: mark jm 09.14.2010
	*	Description	: Copy the perils of selected item by creating new div with the same peril details 
	*/
	function copyItemPerilInfo(itemNoValue){
		var nextItemNo = getNextItemNo("itemTable", "rowItem");
		
		$$("div#itemPerilMotherDiv" + itemNoValue + " div[name='row2']").each(
			function(row){
				var perilTable 			= $("itemPerilMainDiv");
				var itemPerilMotherDiv 	= $("itemPerilMotherDiv" + nextItemNo);		
				var newDiv 	= new Element("div");
				var isNew 	= false;
				
				if (itemPerilMotherDiv == undefined)	{
					isNew = true;
					itemPerilMotherDiv = new Element("div");
					itemPerilMotherDiv.setAttribute("id", "itemPerilMotherDiv" + nextItemNo);
					itemPerilMotherDiv.setAttribute("name", "itemPerilMotherDiv");
					itemPerilMotherDiv.setAttribute("class", "tableContainer");
				}
				
				if($("rowPeril" + nextItemNo + row.down("input", 3).value) == null){
					copyOfPeril = generatePerilClone(row);
					
					var perilCd = row.down("input", 3).value;				
					var content = copyOfPeril[0] + copyOfPeril[1];				
					newDiv.setAttribute("id", "rowPeril" + nextItemNo + perilCd);
					newDiv.setAttribute("name", "row2");
					newDiv.setAttribute("item", nextItemNo);
					newDiv.setAttribute("peril", perilCd);
					newDiv.addClassName("tableRow");		
					newDiv.update(content);

					itemPerilMotherDiv.insert({bottom : newDiv});
					
					if(isNew){
						perilTable.insert({bottom : itemPerilMotherDiv});
					}

					loadPerilNewRecordObserver(newDiv);
				}												
			});				
		
		//checkTableItemInfo("parItemPerilTable","itemPerilMainDiv","row2");
		$("itemPerilMotherDiv"+$F("itemNo")).hide();
		$("itemPerilMainDiv").hide();			
		$("perilTotalTsiAmt").value = formatCurrency(0);
		$("perilTotalPremAmt").value = formatCurrency(0);
		
		checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");		
		hideItemPerilInfos();
		getTotalAmounts();		
		showMessageBox("Item " + (new Number(itemNoValue)).toPaddedString(3) + " successfully copied to Item No. " + (new Number($F("itemNo"))).toPaddedString(3), imgMessage.INFO);		
	}	
	
	function confirmRenumber(){
		var consecutive = true;
		var previousValue = 0;
		
		if($$("div#itemTable div[name='rowItem']").size() > 0){
			$$("div#itemTable div[name='rowItem']").each(
				function(row){
					if((parseInt(row.down("input", 1).value) - parseInt(previousValue)) == 1 ){
						previousValue = parseInt(row.down("input", 1).value);
					}else{
						consecutive = false;
					}
				});

			if(consecutive){
				showMessageBox("Renumber will only work if item are not arranged consecutively.", imgMessage.INFO);
			}else{
				showConfirmBox("Renumber", "Renumber will automatically reorder your item number(s) sequentially. Do you want to continue?",
						"Continue", "Cancel", renumber, stopProcess);
			}
		}else{
			showMessageBox("Renumber will only work if there are existing items.", imgMessage.INFO);
		}					
	}

	/*	Created by	: mark jm 09.15.2010
	*	Description	: Renumber item and their detail records
	*/
	function renumber(){
		var previousValue = 1;
		var objPerilsToAdd = new Array();
		var objPErilsToDel = new Array();
		
		$$("div#itemTable div[name='rowItem']").each(
			function(row){
				if((parseInt(row.down("input", 1).value) == parseInt(previousValue))){
					//previousValue = parseInt(row.down("input", 1).value);
				}else{
					//renumbering goes here					
					var itemNo 			= previousValue;
					var itemTitle 		= row.down("input", 2).value;
					var itemDesc 		= row.down("input", 4).value;
					var itemDesc2 		= row.down("input", 5).value;					
					var currencyText 	= getTextInSelectList("currency", row.down("input", 11).value);
					var rate 			= row.down("input", 12).value;					
					var coverageText 	= getTextInSelectList("coverage", row.down("input", 19).value);
					var currentItemNo	= row.down("input", 1).value
					var content			= "";					

					// renumber item and details
					content = 	'<label name="textItem" style="width: 5%; text-align: right; margin-right: 10px;">'+itemNo+'</label>' +						
								'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemTitle+'">'+(itemTitle == "" ? "---" : itemTitle.truncate(15, "..."))+'</label>'+
								'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemDesc+'">'+(itemDesc == "" ? "---" : itemDesc.truncate(15, "..."))+'</label>' +
								'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "---" : itemDesc2.truncate(15, "..."))+'</label>' +
								'<label name="textItem2" style="width: 10%; text-align: left;" title="'+currencyText+'">'+currencyText.truncate(10, "...")+'</label>' +
								'<label name="textItem" style="width: 10%; text-align: right; margin-right: 10px;">'+formatToNineDecimal(rate)+'</label>' +
								'<label name="textItem" style="text-align: left;" title="'+coverageText+'">'+(coverageText == "" ? "---" :coverageText.truncate(15, "..."))+'</label>';					
					
					$("row"+currentItemNo).setAttribute("id", "row" + itemNo);					
					$("row"+itemNo).update(						
							generateAdditionalItems(true, row, $F("globalLineCd"), itemNo) + content);

					loadDispalyTextTruncator();

					// added 1/14/2011
					var newDiv = new Element("div");
					
					$("deleteItemNumbers").value = $F("deleteItemNumbers") + currentItemNo + " ";
					
					newDiv.setAttribute("id", "rowDelete"+currentItemNo);
					newDiv.setAttribute("name", "rowDelete");
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display : none");
					newDiv.update(
						'<input type="hidden" name="delParIds" 	value="'+$F("globalParId")+'" />' +
						'<input type="hidden" name="delItemNos" value="'+currentItemNo+'" />');
					$("parItemTableContainer").insert({bottom : newDiv});
					//			
					if($F("globalLineCd") == "MC"){
						// mortgagee
						$$("div#mortgageeTable div[name='rowMortg']").each(
							function(row){
								if(row.getAttribute("item") == currentItemNo){
									var mortgCd		= row.down("input", 1).value;	
									var mortgName	= getTextInSelectList("mortgageeName", mortgCd);								
									var amount		= row.down("input", 2).value;
									
									content = 	'<input type="hidden" name="insMortgItemNos" 	value="'+itemNo+'" />' +
												'<input type="hidden" name="insMortgCds" 		value="'+mortgCd+'" />' +
												'<input type="hidden" name="insMortgAmounts" 	value="'+amount+'" />' +
												'<label style="width: 5%; text-align: right; margin-right: 10px;">'+itemNo+'</label>' +
												'<label style="width: 55%; padding-left: 20px;">'+mortgName+'</label>' +
												'<label style="width: 30%; text-align: right;" class="money" name="lblMoney">'+formatCurrency(amount)+'</label>';

									$("row"+currentItemNo+mortgCd).setAttribute("id", "row" + itemNo + mortgCd);
									$("row"+itemNo+mortgCd).setAttribute("item", itemNo);
									$("row"+itemNo+mortgCd).update(content);
								}
							});
						
						// accessory
						$$("div#accessoryTable div[name='acc']").each(
							function(row){
								if(row.getAttribute("item") == currentItemNo){
									var accParId 	= row.down("input", 0).value;									
									var accCd 		= row.down("input", 2).value;
									var accDesc 	= row.down("input", 3).value;
									var accAmt 		= row.down("input", 4).value;
						
									content = '<input type="hidden" id="accParIds" 		name="accParIds" 	value="'+accParId+'" />'+
							 	  			  '<input type="hidden" id="accItemNos" 	name="accItemNos" 	value="'+itemNo+'" />'+ 
											  '<input type="hidden" id="accCds"			name="accCds" 		value="'+accCd+'" />'+
										 	  '<input type="hidden" id="accDescs" 		name="accDescs" 	value="'+accDesc+'" />'+ 
										 	  '<input type="hidden" id="accAmts" 		name="accAmts" 		value="'+accAmt+'" class="money" />'+
										 	  '<label name="text" style="text-align: right; width: 5%; margin-right: 10px;" for="accessory'+itemNo+'">'+itemNo+'</label>'+
										 	  '<label name="text" style="text-align: left; width: 55%; margin-right: 8px;" for="accessory'+accCd+'">'+accDesc.truncate(35, "...")+'</label>'+
											  '<label name="text" style="text-align: right; width: 37%;" class="money" for="accessory'+accCd+'">'+accAmt+'</label>';

									$("rowAcc"+currentItemNo+accCd).setAttribute("id", "rowAcc" + itemNo + accCd);
									$("rowAcc"+itemNo+accCd).setAttribute("item", itemNo);
									$("rowAcc"+itemNo+accCd).update(content);	
								}							
							});						
					}

					// item deductibles
					$$("div#deductiblesTable2 div[name='ded2']").each(
						function(row){
							if(row.getAttribute("item") == currentItemNo){
								var dedLevel		= "2";
								var perilName 		= row.down("input", 1).value;
								var perilCd 		= row.down("input", 2).value;				
								var deductibleTitle = row.down("input", 3).value;
								var deductibleCd 	= row.down("input", 4).value;
								var deductibleAmt 	= row.down("input", 5).value;
								var deductibleRate 	= row.down("input", 6).value;
								var deductibleText 	= row.down("input", 7).value;
								var aggregateSw 	= row.down("input", 8).value;
								var ceilingSw	 	= row.down("input", 9).value;
								var deductibleType	= row.down("input", 10).value;
								var id				= dedLevel + itemNo + perilCd + deductibleCd;

								var minAmt			= row.down("input", 14).value == "" ? "" : parseFloat((row.down("input", 14).value).replace(/,/g, ""));
								var maxAmt 			= row.down("input", 15).value == "" ? "" : parseFloat((row.down("input", 15).value).replace(/,/g, ""));
								var rangeSw			= row.down("input", 16).value;				

								//salert("min/max :: " + minAmt + "/" + maxAmt);
								content = 	'<input type="hidden" id="insDedItemNo'+id+'" 			name="insDedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
											'<input type="hidden" id="insDedPerilName'+id+'" 		name="insDedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
											'<input type="hidden" id="insDedPerilCd'+id+'" 			name="insDedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
											'<input type="hidden" id="insDedTitle'+id+'" 			name="insDedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
											'<input type="hidden" id="insDedDeductibleCd'+id+'"		name="insDedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
											'<input type="hidden" id="insDedAmount'+id+'" 			name="insDedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
											'<input type="hidden" id="insDedRate'+id+'"				name="insDedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
											'<input type="hidden" id="insDedText'+id+'"				name="insDedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
											'<input type="hidden" id="insDedAggregateSw'+id+'"		name="insDedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
											'<input type="hidden" id="insDedCeilingSw'+id+'"		name="insDedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
											'<input type="hidden" id="insDedDeductibleType'+id+'" 	name="insDedDeductibleType'+dedLevel+'"	value="'+deductibleType+'" />'+
											'<input type="hidden" id="insDedMinimumAmount'+id+'" 	name="insDedMinimumAmount'+dedLevel+'"	value="'+minAmt+'" />' +
									 		'<input type="hidden" id="insDedMaximumAmount'+id+'" 	name="insDedMaximumAmount'+dedLevel+'"	value="'+maxAmt+'" />'+
									 		'<input type="hidden" id="insDedRangeSw'+id+'" 			name="insDedRangeSw'+dedLevel+'"		value="'+rangeSw+'" />' +
									 		 
											'<label style="width: 36px; text-align: right; margin-right: 10px;">'+itemNo+'</label>'+												
											'<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'">'+deductibleTitle.truncate(25, "...")+'</label>'+		
											'<label style="width: 119px; text-align: right;">'+(deductibleRate == "" ? "-" : formatToNineDecimal(deductibleRate))+'</label>'+
											'<label style="width: 119px; text-align: right;">'+(deductibleAmt == "" ? "-" : formatCurrency(deductibleAmt))+'</label>'+							 
											'<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
											'<label style="width: 33px; text-align: center;">';
								
								$("ded"+dedLevel+currentItemNo+perilCd+deductibleCd).setAttribute("id", "ded" + dedLevel + itemNo + perilCd + deductibleCd);
								$("ded"+dedLevel+itemNo+perilCd+deductibleCd).setAttribute("item", itemNo);
								$("ded"+dedLevel+itemNo+perilCd+deductibleCd).update(content);

								var deleteContent  = '<input type="hidden" id="delDedItemNo'+ currentItemNo +'"			name="delDedItemNo'+dedLevel+'" 		value="'+ currentItemNo +'" />'+
													 '<input type="hidden" id="delDedPerilCd'+ currentItemNo +'"		name="delDedPerilCd'+dedLevel+'" 		value="'+ perilCd +'" />'+
													 '<input type="hidden" id="delDedDeductibleCd'+ currentItemNo +'"	name="delDedDeductibleCd'+dedLevel+'" 	value="'+ deductibleCd +'" />';

								var delDiv = new Element("div");
								delDiv.setAttribute("name", "delDed"+dedLevel);
								delDiv.setAttribute("id", "delDed"+currentItemNo);
								delDiv.setStyle("display: none;");
								delDiv.update(deleteContent);
								$("dedForDeleteDiv"+dedLevel).insert({bottom : delDiv});

								if($("insDed"+dedLevel+currentItemNo+perilCd+deductibleCd) != null){																		
									$("insDed"+dedLevel+currentItemNo+perilCd+deductibleCd).setAttribute("id", "insDed" + dedLevel + itemNo + perilCd + deductibleCd);
									$("insDed"+dedLevel+itemNo+perilCd+deductibleCd).update("");
								}
																
							}							
						});

					if(checkIfItemHashExistingPeril2(currentItemNo)){						
						// perils
						var deletedPerilObj 	= new Object();
						var objPeril = new Object();
						
						for(var i=0; i<objGIPIWItemPeril.length; i++) {
							var perilCd = objGIPIWItemPeril[i].perilCd;
							if(currentItemNo == objGIPIWItemPeril[i].itemNo) {
								
								objPeril.itemNo			= itemNo;
								objPeril.parId			= $F("globalParId");
								objPeril.lineCd 		= objGIPIWItemPeril[i].lineCd;
								objPeril.perilName 		= objGIPIWItemPeril[i].perilName;
								objPeril.perilCd 		= objGIPIWItemPeril[i].perilCd;
								objPeril.premRt 		= objGIPIWItemPeril[i].premRt;
								objPeril.tsiAmt 		= objGIPIWItemPeril[i].tsiAmt;
								objPeril.premAmt 		= objGIPIWItemPeril[i].premAmt;
								objPeril.compRem 		= objGIPIWItemPeril[i].compRem;
								objPeril.perilType 		= objGIPIWItemPeril[i].perilType;
								objPeril.wcSw 			= objGIPIWItemPeril[i].wcSw;
								objPeril.tarfCd 		= objGIPIWItemPeril[i].tarfCd;
								objPeril.annTsiAmt 		= objGIPIWItemPeril[i].annTsiAmt;
								objPeril.annPremAmt 	= objGIPIWItemPeril[i].annPremAmt;
								objPeril.prtFlag 		= objGIPIWItemPeril[i].prtFlag;
								objPeril.riCommRate 	= objGIPIWItemPeril[i].riCommRate;
								objPeril.riCommAmt 		= objGIPIWItemPeril[i].riCommAmt;
								objPeril.surchargeSw 	= objGIPIWItemPeril[i].surchargeSw;
								objPeril.baseAmt 		= objGIPIWItemPeril[i].baseAmt;
								objPeril.aggregateSw 	= objGIPIWItemPeril[i].aggregateSw;
								objPeril.discountSw 	= objGIPIWItemPeril[i].discountSw;
								//addNewPerilObject(objPeril);
								addObjToPerilTable(objPeril);
								objPerilsToAdd.push(objPeril);
								deletedPerilObj = objGIPIWItemPeril[i];
							}
							addDeletedObjPeril(objGIPIWItemPeril, deletedPerilObj);
							prepareItemPerilforDelete(1);
						}						
						/*
						$$("div#itemPerilMotherDiv" + currentItemNo + " div[name='row2']").each(
							function(row){								
								var lineCd 			= row.down("input", 1).value;
								var perilName 		= row.down("input", 2).value;
								var perilCd 		= row.down("input", 3).value;								
								var perilRate 		= row.down("input", 4).value;
								var tsiAmt 			= row.down("input", 5).value;
								var premAmt 		= row.down("input", 6).value;
								var compRem 		= row.down("input", 7).value;
								var perilType		= row.down("input", 8).value;
								var wcSw 			= row.down("input", 9).value;
								var tarfCd 			= row.down("input", 10).value;
								var annTsiAmt 		= row.down("input", 11).value;
								var annPremAmt 		= row.down("input", 12).value;
								var prtFlag 		= row.down("input", 13).value;
								var riCommRate 		= row.down("input", 14).value;
								var riCommAmt 		= row.down("input", 15).value;
								var surchargeSw 	= row.down("input", 16).value;
								var baseAmt 		= row.down("input", 17).value;
								var aggregateSw 	= row.down("input", 18).value;
								var discountSw 		= row.down("input", 19).value;

								content = 	'<input type="hidden" name="perilItemNos"		value="'+itemNo+'" />'+
											'<input type="hidden" name="perilLineCds"		value="'+lineCd+'" />'+
											'<input type="hidden" name="perilPerilNames" 	value="'+perilName+'" />'+
											'<input type="hidden" name="perilPerilCds" 		value="'+perilCd+'" />'+
											'<input type="hidden" name="perilPremRts" 		class="moneyRate" 	value="'+perilRate+'" />'+
											'<input type="hidden" name="perilTsiAmts" 		class="money" 		value="'+tsiAmt+'" />'+
											'<input type="hidden" name="perilPremAmts" 		class="money" 		value="'+premAmt+'" />'+
											'<input type="hidden" name="perilCompRems" 		value="'+compRem+'" />'+
											'<input type="hidden" name="perilPerilTypes"	value="'+perilType+'" />'+
											'<input type="hidden" name="perilWcSws"			value="'+wcSw+'" />'+
											'<input type="hidden" name="perilTarfCds" 		value="'+tarfCd+'" />'+
											'<input type="hidden" name="perilAnnTsiAmts" 	value="'+annTsiAmt+'" />'+
											'<input type="hidden" name="perilAnnPremAmts" 	value="'+annPremAmt+'" />'+
											'<input type="hidden" name="perilPrtFlags" 		value="'+prtFlag+'" />'+
											'<input type="hidden" name="perilRiCommRates" 	value="'+riCommRate+'" />'+
											'<input type="hidden" name="perilRiCommAmts" 	value="'+riCommAmt+'" />'+
											'<input type="hidden" name="perilSurchargeSws" 	value="'+surchargeSw+'" />'+
											'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
											'<input type="hidden" name="perilAggregateSws" 	value="'+aggregateSw+'" />'+
											'<input type="hidden" name="perilDiscountSws" 	value="'+discountSw+'" />' +
											'<label name="text" style="width: 5%; text-align: right; margin-right: 10px;">'+itemNo+'</label>'+
											'<label name="text" style="width: 20%; text-align: left; margin-left: 10px;">'+perilName+'</label>'+
											'<label name="text" style="width: 10%; text-align: right;" class="moneyRate">'+perilRate+'</label>'+
											'<label name="text" style="width: 10%; text-align: right;" class="money">'+tsiAmt+'</label>'+
											'<label name="text" style="width: 15%; text-align: right;" class="money">'+premAmt+'</label>'+
											'<label name="text" style="width: 25%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>'+
											'<label style="width: 5%; text-align: right;">';

								if (aggregateSw == "Y"){
									content = content + '<img name="checkedImg" style="width: 10px; height: 10px; text-align: right; display: block; margin-left: 1px; float: right;" />' + "</label>";
								} else {
									content = content + '<span style="float: right; width: 10px; height: 10px;">-</span>' + "</label>";
								}

								$("rowPeril"+currentItemNo+perilCd).setAttribute("id", "rowPeril" + itemNo + perilCd);
								$("rowPeril"+itemNo+perilCd).setAttribute("item", itemNo);
								$("rowPeril"+itemNo+perilCd).update(content);
							});
						
						$("itemPerilMotherDiv"+currentItemNo).setAttribute("id", "itemPerilMotherDiv" + itemNo);
						*/
						// item peril deductibles
						$$("div#deductiblesTable3 div[name='ded3']").each(
							function(row){
								if(row.getAttribute("item") == currentItemNo){
									var dedLevel		= "3";
									var perilName 		= row.down("input", 1).value;
									var perilCd 		= row.down("input", 2).value;				
									var deductibleTitle = row.down("input", 3).value;
									var deductibleCd 	= row.down("input", 4).value;
									var deductibleAmt 	= row.down("input", 5).value;
									var deductibleRate 	= row.down("input", 6).value;
									var deductibleText 	= row.down("input", 7).value;
									var aggregateSw 	= row.down("input", 8).value;
									var ceilingSw	 	= row.down("input", 9).value;
									var deductibleType	= row.down("input", 10).value;
									var id				= dedLevel + itemNo + perilCd + deductibleCd;			

									var minAmt			= parseFloat((row.down("input", 14).value).replace(/,/g, ""));
									var maxAmt 			= parseFloat((row.down("input", 15).value).replace(/,/g, ""));
									var rangeSw			= row.down("input", 16).value;		
									content = 	'<input type="hidden" id="insDedItemNo'+id+'" 			name="insDedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
												'<input type="hidden" id="insDedPerilName'+id+'" 		name="insDedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
												'<input type="hidden" id="insDedPerilCd'+id+'" 			name="insDedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
												'<input type="hidden" id="insDedTitle'+id+'" 			name="insDedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
												'<input type="hidden" id="insDedDeductibleCd'+id+'"		name="insDedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
												'<input type="hidden" id="insDedAmount'+id+'" 			name="insDedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
												'<input type="hidden" id="insDedRate'+id+'"				name="insDedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
												'<input type="hidden" id="insDedText'+id+'"				name="insDedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
												'<input type="hidden" id="insDedAggregateSw'+id+'"		name="insDedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
												'<input type="hidden" id="insDedCeilingSw'+id+'"		name="insDedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
												'<input type="hidden" id="insDedDeductibleType'+id+'" 	name="insDedDeductibleType'+dedLevel+'"	value="'+deductibleType+'" />'+
												'<input type="hidden" id="insDedMinimumAmount'+id+'" 	name="insDedMinimumAmount'+dedLevel+'"	value="'+minAmt+'" />' +
										 		'<input type="hidden" id="insDedMaximumAmount'+id+'" 	name="insDedMaximumAmount'+dedLevel+'"	value="'+maxAmt+'" />'+
										 		'<input type="hidden" id="insDedRangeSw'+id+'" 			name="insDedRangeSw'+dedLevel+'"		value="'+rangeSw+'" />';
										 		 
												'<label style="width: 36px; text-align: right; margin-right: 10px;">'+itemNo+'</label>'+
												'<label style="width: 160px; text-align: left; " title="'+perilName+'">'+perilName.truncate(20, "...")+'</label>' +	
												'<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'">'+deductibleTitle.truncate(25, "...")+'</label>'+		
												'<label style="width: 119px; text-align: right;">'+(deductibleRate == "" ? "-" : formatToNineDecimal(deductibleRate))+'</label>'+
												'<label style="width: 119px; text-align: right;">'+(deductibleAmt == "" ? "-" : formatCurrency(deductibleAmt))+'</label>'+							 
												'<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
												'<label style="width: 33px; text-align: center;">';
									
									$("ded"+dedLevel+currentItemNo+perilCd+deductibleCd).setAttribute("id", "ded" + dedLevel + itemNo + perilCd + deductibleCd);
									$("ded"+dedLevel+itemNo+perilCd+deductibleCd).setAttribute("item", itemNo);
									$("ded"+dedLevel+itemNo+perilCd+deductibleCd).update(content);

									var deleteContent  = '<input type="hidden" id="delDedItemNo'+ currentItemNo +'"			name="delDedItemNo'+dedLevel+'" 		value="'+ currentItemNo +'" />'+
									 '<input type="hidden" id="delDedPerilCd'+ currentItemNo +'"		name="delDedPerilCd'+dedLevel+'" 		value="'+ perilCd +'" />'+
									 '<input type="hidden" id="delDedDeductibleCd'+ currentItemNo +'"	name="delDedDeductibleCd'+dedLevel+'" 	value="'+ deductibleCd +'" />';

									var delDiv = new Element("div");
									delDiv.setAttribute("name", "delDed"+dedLevel);
									delDiv.setAttribute("id", "delDed"+currentItemNo);
									delDiv.setStyle("display: none;");
									delDiv.update(deleteContent);
									$("dedForDeleteDiv"+dedLevel).insert({bottom : delDiv});

									if($("insDed"+dedLevel+currentItemNo+perilCd+deductibleCd) != null){
										$("insDed"+dedLevel+currentItemNo+perilCd+deductibleCd).setAttribute("id", "insDed" + dedLevel + itemNo + perilCd + deductibleCd);
										$("insDed"+dedLevel+itemNo+perilCd+deductibleCd).update("");
									}									
								}							
							});
					}					
				}
				previousValue ++;
			});
		
		setDefaultValues();									
		buttonBehavior("Add");
		hideItemPerilInfos();
		if(objPerilsToAdd != null) {
			for(var i=0; i<objPerilsToAdd.length; i++) {
				addNewPerilObject(objPerilsToAdd[i]);
			}
		}
		if($("mortgageeTable") != null){
			initializeSubPagesTableListing("mortgageeTable", "rowMortg");
		}
		
		initializeSubPagesTableListing("deductiblesTable2", "ded2");
		checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");

		showMessageBox("Item/s have been renumbered.", imgMessage.INFO);
	}	
	
	function confirmAssignDeductibles(){
		var hashItemItemNo	= new Hash();
		var hashDedItemNo 	= new Hash();
		var itemNo 			= "";
		var exists1			= false;
		var exists2			= true;		
		
		$$("div#deductiblesTable2 div[name='ded2']").each(
			function(row){
				itemNo = row.getAttribute("item");

				if(itemNo == $F("itemNo")){
					exists1 = true;					
				}

				if(hashDedItemNo.get(itemNo) == undefined){
					hashDedItemNo.set(itemNo, itemNo);
				}
			});

		$$("div#itemTable div[name='rowItem']").each(
			function(row){
				itemNo = row.down("input", 1).value;
				hashItemItemNo.set(itemNo, itemNo);
			});

		// item numbers against deductibles item numbers
		if(hashItemItemNo.size() == hashDedItemNo.size()){
			exists2 = false;
		}				

		hashItemItemNo.each(
			function(pair){
				if(hashDedItemNo.get(pair.key) == undefined){
					if(pair.key == $F("itemNo")){
						exists2 = true;
					}					
				}
			});		
			
		// get item_no from deductible listing
		/*
		$$("div#deductiblesTable2 div[name='ded2']").each(
			function(row){
				itemNo = row.getAttribute("item");

				if(itemNo == $F("itemNo")){
					exists2 = true;
				}				
			});
		*/
		if(exists1 && exists2){
			showConfirmBox("Deductibles", "Assign Deductibles, will automatically copy the current item deductibles " +
					"to other items without deductibles yet. Do you want to continue?", "Yes", "No", assignDeductibles, stopProcess);
		}else if(!exists1){
			itemNo = new Number($F("itemNo"));
			showMessageBox("Item " + itemNo.toPaddedString(3) + " has no existing deductible(s). " +
				"You cannot assign a null deductible(s).", imgMessage.INFO);
		}else if(!exists2){
			showMessageBox("All existing items already have deductible(s).", imgMessage.INFO);
		}
	}

	/*	Created by	: mark jm 09.16.2010
	*	Description	: Copy deductibles of selected item record to all items who has no deductibles
	*/
	function assignDeductibles(){		
		var hashItemItemNo 	= new Hash();
		var hashDedItemNo	= new Hash();
		var hashNoDedItemNo	= new Hash();

		// save item numbers to hash
		$$("div#itemTable div[name='rowItem']").each(
			function(row){
				itemNo = row.down("input", 1).value;
				hashItemItemNo.set(itemNo, itemNo);
			});

		// save deductible's item numbers to hash
		$$("div#deductiblesTable2 div[name='ded2']").each(
			function(row){
				itemNo = row.getAttribute("item");				
	
				if(hashDedItemNo.get(itemNo) == undefined){
					hashDedItemNo.set(itemNo, itemNo);
				}
			});

		// save item numbes that has no deductibles to hash
		hashItemItemNo.each(
			function(pair){
				if(hashDedItemNo.get(pair.key) == undefined){
					hashNoDedItemNo.set(pair.key, pair.key);
				}
			});		
		
		// item deductibles
		$$("div#deductiblesTable2 div[name='ded2']").each(
			function(row){
				var selectedItemNo = $F("itemNo");
				if(row.getAttribute("item") == selectedItemNo){

					// copy deductible to items that has no deductibles
					hashNoDedItemNo.each(
						function(pair){
							var itemNo			= pair.key;
							var dedLevel		= "2";
							var perilName 		= row.down("input", 1).value;
							var perilCd 		= row.down("input", 2).value;				
							var deductibleTitle = row.down("input", 3).value;
							var deductibleCd 	= row.down("input", 4).value;
							var deductibleAmt 	= row.down("input", 5).value;
							var deductibleRate 	= row.down("input", 6).value;
							var deductibleText 	= row.down("input", 7).value;
							var aggregateSw 	= row.down("input", 8).value;
							var ceilingSw	 	= row.down("input", 9).value;
							var deductibleType	= row.down("input", 10).value;
							var id				= dedLevel + itemNo + perilCd + deductibleCd;
							var minAmt			= (deductibleType == "L" || deductibleType == "I" || deductibleType == "T") ? 
													parseFloat((row.down("input", 14).value).replace(/,/g, "")) : "";
							var maxAmt 			= (deductibleType == "L" || deductibleType == "I" || deductibleType == "T") ? 
													parseFloat((row.down("input", 15).value).replace(/,/g, "")) : "";
							var rangeSw			= row.down("input", 16).value;	

							objDeductibleListing = JSON.parse('${objDeductibleListing}');
							//added 1/13/2011, blank
							for(var i=0; i<objDeductibleListing.length; i++) {
								if(deductibleCd == objDeductibleListing[i].deductibleCd) {
									if(deductibleType == "T") {
										var rate = objDeductibleListing[i].deductibleRate == null ? 0 : objDeductibleListing[i].deductibleRate;
										var amount  = parseFloat(getAmount(dedLevel, itemNo)) * (parseFloat(rate)/100);
										if(rate != ""){
											if (minAmt != "" && maxAmt != ""){
												if (rangeSw == "H"){
													deductibleAmt = formatCurrency(Math.min(Math.max(amount, minAmt), maxAmt));
												} else if (rangeSw == "L"){
													deductibleAmt = formatCurrency(Math.min(Math.max(amount, minAmt), maxAmt));
												} else {
													deductibleAmt = formatCurrency(maxAmt);
												}
											} else if (minAmt != ""){
												deductibleAmt = formatCurrency(Math.max(amount, minAmt));	
											} else if (maxAmt != ""){
												deductibleAmt = formatCurrency(Math.min(amount, maxAmt));
											} else{
												deductibleAmt = formatCurrency(amount);
											}
										}else{
											if (minAmt != ""){
												deductibleAmt = formatCurrency(minAmt);
											} else if (maxAmt != ""){
												deductibleAmt = formatCurrency(maxAmt);
											}
										}	
									}
								}
								
							}				
							
							content = 	'<input type="hidden" id="insDedItemNo'+id+'" 			name="insDedItemNo'+dedLevel+'" 		value="'+itemNo+'" />'+
										'<input type="hidden" id="insDedPerilName'+id+'" 		name="insDedPerilName'+dedLevel+'" 		value="'+perilName+'" />'+ 
										'<input type="hidden" id="insDedPerilCd'+id+'" 			name="insDedPerilCd'+dedLevel+'" 		value="'+perilCd+'" />'+
										'<input type="hidden" id="insDedTitle'+id+'" 			name="insDedTitle'+dedLevel+'" 			value="'+deductibleTitle+'" />'+
										'<input type="hidden" id="insDedDeductibleCd'+id+'"		name="insDedDeductibleCd'+dedLevel+'" 	value="'+deductibleCd+'" />'+
										'<input type="hidden" id="insDedAmount'+id+'" 			name="insDedAmount'+dedLevel+'"			value="'+deductibleAmt+'" />'+
										'<input type="hidden" id="insDedRate'+id+'"				name="insDedRate'+dedLevel+'" 			value="'+deductibleRate+'" />'+
										'<input type="hidden" id="insDedText'+id+'"				name="insDedText'+dedLevel+'" 			value="'+deductibleText+'" />'+
										'<input type="hidden" id="insDedAggregateSw'+id+'"		name="insDedAggregateSw'+dedLevel+'"	value="'+aggregateSw+'" />'+
										'<input type="hidden" id="insDedCeilingSw'+id+'"		name="insDedCeilingSw'+dedLevel+'" 		value="'+ceilingSw+'" />' + 
										'<input type="hidden" id="insDedDeductibleType'+id+'" 	name="insDedDeductibleType'+dedLevel+'"	value="'+deductibleType+'" />'+
										'<input type="hidden" id="insDedMinimumAmount'+id+'" 	name="insDedMinimumAmount'+dedLevel+'"	value="'+minAmt+'" />' +
								 		'<input type="hidden" id="insDedMaximumAmount'+id+'" 	name="insDedMaximumAmount'+dedLevel+'"	value="'+maxAmt+'" />'+
								 		'<input type="hidden" id="insDedRangeSw'+id+'" 			name="insDedRangeSw'+dedLevel+'"		value="'+rangeSw+'" />' +
										'<label style="width: 36px; text-align: right; margin-right: 10px;">'+itemNo+'</label>'+												
										'<label style="width: 213px; text-align: left; margin-left: 6px;" title="'+deductibleTitle+'">'+deductibleTitle.truncate(25, "...")+'</label>'+		
										'<label style="width: 119px; text-align: right;">'+(deductibleRate == "" ? "-" : formatToNineDecimal(deductibleRate))+'</label>'+
										'<label style="width: 119px; text-align: right;">'+(deductibleAmt == "" ? "-" : formatCurrency(deductibleAmt))+'</label>'+							 
										'<label style="width: 155px; text-align: left;  margin-left: 20px;" title="'+deductibleText+'">'+deductibleText.truncate(20, "...")+'</label>'+
										'<label style="width: 33px; text-align: center;">';

							var newDiv = new Element('div');
							newDiv.setAttribute("name", "ded"+dedLevel);
							newDiv.setAttribute("id", "ded"+id);
							newDiv.setAttribute("item", itemNo);
							newDiv.setAttribute("dedCd", deductibleCd);
							newDiv.addClassName("tableRow");
							newDiv.setStyle("display: none;");

							newDiv.update(content);
							$("wdeductibleListing"+dedLevel).insert({bottom: newDiv});

							//loadDeductibleNewRecordObserve(newDiv, dedLevel);							
									
							newDiv.observe("mouseover", function ()	{
								newDiv.addClassName("lightblue");
							});
							
							newDiv.observe("mouseout", function ()	{
								newDiv.removeClassName("lightblue");
							});
							
							newDiv.observe("click", function ()	{
								newDiv.toggleClassName("selectedRow");
								if (newDiv.hasClassName("selectedRow"))	{
									$$("div[name='ded"+dedLevel+"']").each(
										function (row)	{
											if (newDiv.getAttribute("id") != row.getAttribute("id"))	{
												row.removeClassName("selectedRow");
										}
									});	
									setDeductibleForm(newDiv, 2);
								} else {
									setDeductibleForm(null, 2);
								}
							});
							
							Effect.Appear(newDiv, {
								duration: .5, 
								afterFinish: function ()	{
									//checkIfToResizeTable2("wdeductibleListing"+dedLevel, "ded"+dedLevel);
									//checkTableIfEmpty2("ded"+dedLevel, "deductiblesTable"+dedLevel);
									//checkPopupsTable("deductiblesTable" + dedLevel, "wdeductibleListing" + dedLevel, "ded" + dedLevel);	
									//setTotalAmount(dedLevel, newDiv.down("input", 0).value);
								}
							});
						});
												
				}							
			});

		checkPopupsTable("deductiblesTable2", "wdeductibleListing2", "ded2");	
		//setTotalAmount(2, $F("itemNo")); // andrew - 09.22.2010 - commented this line, added the next line 
		setTotalAmount(2, $F("itemNo"), 0);
		
		showMessageBox("Deductibles has been assigned.", imgMessage.INFO);		
	}			
	
	function generateItemInfo(){		
		//orio to generate the correct next item no
		var itemNoSize = $$("div#itemTable div[name='rowItem']").size();
		var getItemNo = 0;
		if (itemNoSize > 0){
			$$("div#itemTable div[name='rowItem']").each(function (a){
					getItemNo = getItemNo+ " " +a.down("input",1).value;
			});	
		}
		$("itemNoArray").value = (getItemNo == "" ? "0 ": getItemNo);
		var newItemNo = sortNumbers($("itemNoArray").value).last();
		$("itemNo").value = parseInt(newItemNo)+1;	
	}

	/*	Created by	: mark jm 
	*	Description	: Generate the content of a div (item record)
	*	Parameters	: renumber - boolean used to determine if the function will be used for renumbering or not
	*				: row - div used to get details when renumber is set to true
	*				: lineCd - lineCd to determine what elements/details should be put in the div
	*				: renumberItemNo - itemNo used in renumbering (default 0) 
	*/
	function generateAdditionalItems(renumber, row, lineCd, renumberItemNo){	
		var lineCd			= $F("globalLineCd");
		var sublineCd		= $F("sublineCd") /* $F("globalSublineCd") */;
		var parId 			= renumber ? row.down("input", 0).value : $F("globalParId");
		var itemNo 			= renumber ? renumberItemNo : $F("itemNo");
		var itemTitle 		= renumber ? row.down("input", 2).value : $F("itemTitle");
		var itemGrp 		= renumber ? row.down("input", 3).value : ($F("itemGrp")== "") ? 1: $F("itemGrp"); // modified by: nica to set default value of item_grp to 1 if item_grp does not exist
		var itemDesc 		= renumber ? row.down("input", 4).value : $F("itemDesc");
		var itemDesc2 		= renumber ? row.down("input", 5).value : $F("itemDesc2");
		var tsiAmt 			= renumber ? row.down("input", 6).value : "0.00";
		var premAmt 		= renumber ? row.down("input", 7).value : "0.00";
		var annPremAmt 		= renumber ? row.down("input", 8).value : "0.00";
		var annTsiAmt 		= renumber ? row.down("input", 9).value : "0.00";
		var recFlag 		= renumber ? row.down("input", 10).value : ((($F("recFlag") == "")) ? "A" : $F("recFlag"));
		var currencyCd 		= renumber ? row.down("input", 11).value : $F("currency");
		var currencyRt 		= renumber ? row.down("input", 12).value : $F("rate");
		var groupCd 		= renumber ? row.down("input", 13).value : $F("groupCd");
		var fromDate 		= renumber ? row.down("input", 14).value : (lineCd == "AH") ? $F("accidentFromDate") : $F("fromDate");
		var toDate 			= renumber ? row.down("input", 15).value : (lineCd == "AH") ? $F("accidentToDate") : $F("toDate");
		var packLineCd 		= renumber ? row.down("input", 16).value : ($F("packLineCd") == null) ? null :  $F("packLineCd");
		var packSublineCd 	= renumber ? row.down("input", 17).value : ($F("packSublineCd") == null) ? null : $F("packSublineCd");
		var discountSw 		= renumber ? row.down("input", 18).value : $("discountSw").checked == false ? "N" :$F("discountSw");
		var coverageCd 		= renumber ? row.down("input", 19).value : $F("coverage");
		var otherInfo 		= renumber ? row.down("input", 20).value : $F("otherInfo");
		var surchargeSw 	= renumber ? row.down("input", 21).value : $("surchargeSw").checked == false ? "N" :$F("surchargeSw");
		var regionCd 		= renumber ? row.down("input", 22).value : (lineCd == "FI") ? $F("regionCd") : $F("region");
		var changedTag 		= renumber ? row.down("input", 23).value : "";
		var prorateFlag 	= renumber ? row.down("input", 24).value : (lineCd == "AH") ? $F("accidentProrateFlag") : "";
		var compSw 			= renumber ? row.down("input", 25).value : (lineCd == "AH") ? $F("accidentCompSw") : "";
		var shortRtPercent 	= renumber ? row.down("input", 26).value : (lineCd == "AH") ? ($F("accidentShortRatePercent")== "" || $F("accidentShortRatePercent")== "NaN" ? "" :$F("accidentShortRatePercent")) : "";
		var packBenCd 		= renumber ? row.down("input", 27).value : (lineCd == "AH") ? $F("accidentPackBenCd") : "";
		var paytTerms 		= renumber ? row.down("input", 28).value : (lineCd == "AH") ? $F("accidentPaytTerms") : ""; 
		var riskNo 			= renumber ? row.down("input", 29).value : (lineCd == "FI") ? $F("riskNo") : "";
		var riskItemNo 		= renumber ? row.down("input", 30).value : (lineCd == "FI") ? $F("riskItemNo") : "";
		var nextItemNo		= getNextItemNo("itemTable", "rowItem");
		var itemArray = '';
		
		itemArray = 
			//'<input type="hidden" name="itemLineCds" 			value="'+ lineCd +'" />' +
			//'<input type="hidden" name="itemSublineCds" 		value="'+ sublineCd +'" />' +
			'<input type="hidden" name="itemParIds" 			value="'+ parId +'" />' +
			'<input type="hidden" name="itemItemNos" 			value="'+ itemNo +'" />' +
			'<input type="hidden" name="itemItemTitles" 		value="'+ changeSingleAndDoubleQuotes2(itemTitle) +'" />' +
			'<input type="hidden" name="itemItemGrps" 			value="'+ itemGrp +'" />' +
			'<input type="hidden" name="itemItemDescs" 			value="'+ changeSingleAndDoubleQuotes2(itemDesc) +'" />' +
			'<input type="hidden" name="itemItemDesc2s" 		value="'+ changeSingleAndDoubleQuotes2(itemDesc2) +'" />' +
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
			'<input type="hidden" name="itemOtherInfos" 		value="'+ changeSingleAndDoubleQuotes2(otherInfo) +'" />' +
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
			var assignee 			= renumber ? row.down("input", 31).value : $F("assignee");
			var acquiredFrom		= renumber ? row.down("input", 32).value : $F("acquiredFrom");
			var motorNo				= renumber ? row.down("input", 33).value : $F("motorNo");
			var origin				= renumber ? row.down("input", 34).value : $F("origin");
			var destination			= renumber ? row.down("input", 35).value : $F("destination");
			var typeOfBody			= renumber ? row.down("input", 36).value : $F("typeOfBody");
			var plateNo				= renumber ? row.down("input", 37).value : $F("plateNo");
			var modelYear			= renumber ? row.down("input", 38).value : $F("modelYear");
			var carCompany			= renumber ? row.down("input", 39).value : $F("carCompany");
			var mvFileNo			= renumber ? row.down("input", 40).value : $F("mvFileNo");
			var noOfPass			= renumber ? row.down("input", 41).value : $F("noOfPass");
			var makeCd				= renumber ? row.down("input", 42).value : $F("makeCd");			
			var basicColor			= renumber ? row.down("input", 43).value : $F("basicColor");
			var color				= renumber ? row.down("input", 44).value : $("colorCd").options[$("colorCd").selectedIndex].text;
			var colorCd				= renumber ? row.down("input", 45).value : $F("colorCd");
			var engineSeries		= renumber ? row.down("input", 46).value : $F("engineSeries");
			var motorType			= renumber ? row.down("input", 47).value : $F("motorType");
			var unladenWt			= renumber ? row.down("input", 48).value : $F("unladenWt");
			var towLimit			= renumber ? row.down("input", 49).value : $F("towLimit");
			var serialNo			= renumber ? row.down("input", 50).value : $F("serialNo");
			var sublineType			= renumber ? row.down("input", 51).value : $F("sublineType");
			var deductibleAmount	= renumber ? row.down("input", 52).value : $F("deductibleAmount");
			var cocType				= renumber ? row.down("input", 53).value : $F("cocType");
			var cocSerialNo			= renumber ? row.down("input", 54).value : $F("cocSerialNo");
			var cocYy				= renumber ? row.down("input", 55).value : $F("cocYy");
			var ctv					= renumber ? row.down("input", 56).value : $("ctv").checked ? 'Y' : 'N';
			var repairLimit			= renumber ? row.down("input", 57).value : $F("repairLimit");
			var motorCoverage		= renumber ? row.down("input", 58).value : $F("motorCoverage");
			var sublineCd			= renumber ? row.down("input", 59).value : $F("sublineCd") /* $F("globalSublineCd") */;			
			var cocSerialSw			= renumber ? row.down("input", 60).value : $("generateCOCSerialNo").checked ? "Y" : "N";			
			var estValue			= renumber ? row.down("input", 61).value : "0.00";
			var tariffZone			= renumber ? row.down("input", 62).value : "";
			var cocIssueDate		= renumber ? row.down("input", 63).value : "";
			var cocSeqNo			= renumber ? row.down("input", 64).value : 0;
			var cocAtcn				= renumber ? row.down("input", 65).value : "N";
			var make				= renumber ? row.down("input", 66).value : $("makeCd").options[$("makeCd").selectedIndex].text;
			var engSeriesVal		= renumber ? row.down("input", 46).getAttribute("engSeriesVal") : $("engineSeries").options[$("engineSeries").selectedIndex].getAttribute("engSeriesVal"); 			
			
			itemArray = itemArray +
				'<input type="hidden" name="addlInfoAssignees" 			value="'+ changeSingleAndDoubleQuotes2(assignee) +'" />' +
				'<input type="hidden" name="addlInfoAcquiredFroms" 		value="'+ changeSingleAndDoubleQuotes2(acquiredFrom) +'" />' +
				'<input type="hidden" name="addlInfoMotorNos"			value="'+ changeSingleAndDoubleQuotes2(motorNo) +'" />' +
				'<input type="hidden" name="addlInfoOrigins"			value="'+ changeSingleAndDoubleQuotes2(origin) +'" />' +
				'<input type="hidden" name="addlInfoDestinations"		value="'+ changeSingleAndDoubleQuotes2(destination) +'" />' +
				'<input type="hidden" name="addlInfoTypeOfBodyCds"		value="'+ typeOfBody +'" />' +
				'<input type="hidden" name="addlInfoPlateNos" 			value="'+ changeSingleAndDoubleQuotes2(plateNo) +'" />' +
				'<input type="hidden" name="addlInfoModelYears" 		value="'+ modelYear +'" />' +
				'<input type="hidden" name="addlInfoCarCompanyCds" 		value="'+ carCompany +'" />' +
				'<input type="hidden" name="addlInfoMVFileNos" 			value="'+ changeSingleAndDoubleQuotes2(mvFileNo) +'" />' +
				'<input type="hidden" name="addlInfoNoOfPasss" 			value="'+ noOfPass +'" />' +
				'<input type="hidden" name="addlInfoMakeCds" 			value="'+ makeCd +'" />' +
				'<input type="hidden" name="addlInfoBasicColorCds" 		value="'+ basicColor +'" />' +
				'<input type="hidden" name="addlInfoColors" 			value="'+ color +'" />' +
				'<input type="hidden" name="addlInfoColorCds" 			value="'+ colorCd +'" />' +
				'<input type="hidden" name="addlInfoEngineSeriess" 		value="'+ engineSeries +'"/>' +
				'<input type="hidden" name="addlInfoMotorTypes" 		value="'+ motorType +'" />' +
				'<input type="hidden" name="addlInfoUnladenWts" 		value="'+ unladenWt +'" />' +
				'<input type="hidden" name="addlInfoTowings" 			value="'+ formatCurrency(towLimit) +'" />' +
				'<input type="hidden" name="addlInfoSerialNos" 			value="'+ changeSingleAndDoubleQuotes2(serialNo) +'" />' +
				'<input type="hidden" name="addlInfoSublineTypeCds" 	value="'+ sublineType +'" />' +
				'<input type="hidden" name="addlInfoDeductibleAmounts" 	value="'+ formatCurrency(deductibleAmount) +'" />' +
				'<input type="hidden" name="addlInfoCOCTypes" 			value="'+ cocType +'" />' +
				'<input type="hidden" name="addlInfoCOCSerialNos" 		value="'+ cocSerialNo +'" />' +
				'<input type="hidden" name="addlInfoCOCYys" 			value="'+ cocYy +'" />' +
				'<input type="hidden" name="addlInfoCTVs" 				value="'+ ctv +'" />' +
				'<input type="hidden" name="addlInfoRepairLimits" 		value="'+ formatCurrency(repairLimit) +'" />' +
				'<input type="hidden" name="addlInfoMotorCoverages" 	value="'+ motorCoverage +'" />' +
				'<input type="hidden" name="addlInfoSublineCds" 		value="'+ sublineCd +'" />' +				
				'<input type="hidden" name="addlInfoCOCSerialSws" 		value="'+ cocSerialSw +'" />' +				
				'<input type="hidden" name="addlInfoEstValues" 			value="'+ estValue +'" />' +
				'<input type="hidden" name="addlInfoTariffZones" 		value="'+ tariffZone +'" />' +
				'<input type="hidden" name="addlInfoCOCIssueDates" 		value="'+ cocIssueDate +'" />' +
				'<input type="hidden" name="addlInfoCOCSeqNos" 			value="'+ cocSeqNo +'" />' +
				'<input type="hidden" name="addlInfoCOCAtcns" 			value="'+ cocAtcn +'" />' +
				'<input type="hidden" name="addlInfoMakes" 				value="'+ make +'" />' +
				'<input type="hidden" name="addlInfoItemNos"			value="'+ itemNo + '" />';
		} else if(lineCd == "FI"){			
			var riskNo 				= renumber ? row.down("input",29).value : $F("riskNo");
			var riskItemNo			= renumber ? row.down("input",30).value : $F("riskItemNo");
			var eqZone				= renumber ? row.down("input",31).value : $F("eqZone");
			var fromDate			= renumber ? row.down("input",32).value : $F("fireFromDate");
			var assignee			= renumber ? row.down("input",33).value : changeSingleAndDoubleQuotes2($F("assignee"));
			var typhoonZone			= renumber ? row.down("input",34).value : $F("typhoonZone");
			var toDate				= renumber ? row.down("input",35).value : $F("fireToDate");
			var frItemType			= renumber ? row.down("input",36).value : $F("frItemType");
			var floodZone			= renumber ? row.down("input",37).value : $F("floodZone");
			var locRisk1			= renumber ? row.down("input",38).value : changeSingleAndDoubleQuotes2($F("locRisk1"));
			var regionCd			= renumber ? row.down("input",39).value : $F("fireRegionCd");
			var tariffZone			= renumber ? row.down("input",40).value : $F("tariffZone");
			var locRisk2			= renumber ? row.down("input",41).value : changeSingleAndDoubleQuotes2($F("locRisk2"));
			var provinceCd			= renumber ? row.down("input",42).value : $F("province");
			var tarfCd				= renumber ? row.down("input",43).value : $F("tarfCd");
			var locRisk3			= renumber ? row.down("input",44).value : changeSingleAndDoubleQuotes2($F("locRisk3"));
			var city				= renumber ? row.down("input",45).value : $("city").options[$("city").selectedIndex].text;
			var constructionCd		= renumber ? row.down("input",46).value : $F("construction");
			var front				= renumber ? row.down("input",47).value : changeSingleAndDoubleQuotes2($F("front"));
			var district			= renumber ? row.down("input",48).value : $F("district");
			var constructionRemarks	= renumber ? row.down("input",49).value : changeSingleAndDoubleQuotes2($F("constructionRemarks"));
			var right				= renumber ? row.down("input",50).value : changeSingleAndDoubleQuotes2($F("right"));
			var blockNo				= renumber ? row.down("input",51).value : $F("block"); //$("block").options[$("block").selectedIndex].text;
			var occupancyCd			= renumber ? row.down("input",52).value : $F("occupancy");
			var left				= renumber ? row.down("input",53).value : changeSingleAndDoubleQuotes2($F("left"));
			var riskCd				= renumber ? row.down("input",54).value : $F("risk");
			var occupancyRemarks	= renumber ? row.down("input",55).value : changeSingleAndDoubleQuotes2($F("occupancyRemarks"));
			var rear				= renumber ? row.down("input",56).value : changeSingleAndDoubleQuotes2($F("rear"));
			var blockId				= renumber ? row.down("input",57).value : $F("block");
			var provinceDesc		= renumber ? row.down("input",58).value : $("province").options[$("province").selectedIndex].text;

			itemArray = itemArray + 				
				'<input type="hidden" name="addlInfoEQZones" 				value="'+eqZone+'" />' +
				'<input type="hidden" name="addlInfoFromDates" 				value="'+fromDate+'" />' +
				'<input type="hidden" name="addlInfoAssignees" 				value="'+assignee+'" />' +
				'<input type="hidden" name="addlInfoTyphoonZones" 			value="'+typhoonZone+'" />' +
				'<input type="hidden" name="addlInfoToDates" 				value="'+toDate+'" />' +
				'<input type="hidden" name="addlInfoFRItemTypes" 			value="'+frItemType+'" />' +
				'<input type="hidden" name="addlInfoFloodZones" 			value="'+floodZone+'" />' +
				'<input type="hidden" name="addlInfoLocRisk1s" 				value="'+locRisk1+'" />' +
				'<input type="hidden" name="addlInfoRegionCds" 				value="'+regionCd+'" />' +
				'<input type="hidden" name="addlInfoTariffZones" 			value="'+tariffZone+'" />' +
				'<input type="hidden" name="addlInfoLocRisk2s" 				value="'+locRisk2+'" />' +
				'<input type="hidden" name="addlInfoProvinceCds" 			value="'+provinceCd+'" />' +
				'<input type="hidden" name="addlInfoTarfCds" 				value="'+tarfCd+'" />' +
				'<input type="hidden" name="addlInfoLocRisk3s" 				value="'+locRisk3+'" />' +
				'<input type="hidden" name="addlInfoCitys" 					value="'+city+'" />' +
				'<input type="hidden" name="addlInfoConstructionCds" 		value="'+constructionCd+'" />' +
				'<input type="hidden" name="addlInfoFronts" 				value="'+front+'" />' +
				'<input type="hidden" name="addlInfoDistrictNos" 			value="'+district+'" />' +
				'<input type="hidden" name="addlInfoConstructionRemarkss"	value="'+constructionRemarks+'" />' +
				'<input type="hidden" name="addlInfoRights"					value="'+right+'" />' +
				'<input type="hidden" name="addlInfoBlockNos" 				value="'+blockNo+'" />' +
				'<input type="hidden" name="addlInfoOccupancyCds" 			value="'+occupancyCd+'" />' +
				'<input type="hidden" name="addlInfoLefts" 					value="'+left+'" />' +
				'<input type="hidden" name="addlInfoRiskCds" 				value="'+riskCd+'" />' +
				'<input type="hidden" name="addlInfoOccupancyRemarkss" 		value="'+occupancyRemarks+'" />' +
				'<input type="hidden" name="addlInfoRears" 					value="'+rear+'" />' +
				'<input type="hidden" name="addlInfoBlockIds" 				value="'+blockId+'" />' +
				'<input type="hidden" name="addlInfoProvinceDescs"			value="'+provinceDesc+'" />';			
		} else if(lineCd == "MN"){	
			var packMethod 				= changeSingleAndDoubleQuotes2($F("packMethod"));
			var blAwb					= changeSingleAndDoubleQuotes2($F("blAwb"));
			var transhipOrigin		    = changeSingleAndDoubleQuotes2($F("transhipOrigin"));
			var transhipDestination		= changeSingleAndDoubleQuotes2($F("transhipDestination"));
			var voyageNo				= changeSingleAndDoubleQuotes2($F("voyageNo"));
			var lcNo					= changeSingleAndDoubleQuotes2($F("lcNo"));
			var etd						= $F("etd");
			var eta						= $F("eta");
			var origin					= changeSingleAndDoubleQuotes2($F("origin"));
			var destn					= changeSingleAndDoubleQuotes2($F("destn"));
			var invCurrRt				= $F("invCurrRt");
			var invoiceValue			= $F("invoiceValue");
			var markupRate				= $F("markupRate");
			var recFlagWCargo			= $F("recFlagWCargo");
			var cpiRecNo				= $F("cpiRecNo");
			var cpiBranchCd				= $F("cpiBranchCd");
			var deductText				= $F("deductText");
			var geogCd					= $F("geogCd");
			var vesselCd				= $F("vesselCd");
			var cargoClassCd			= $F("cargoClassCd");
			var cargoType				= $F("cargoType");
			var printTag				= $F("printTag");
			var invCurrCd				= $F("invCurrCd");
			var deleteWVes				= $F("deleteWVes");
			
			itemArray = itemArray + 				
				'<input type="hidden" name="packMethods" 				value="'+packMethod+'" />' +
				'<input type="hidden" name="blAwbs"						value="'+blAwb+'" />'+
				'<input type="hidden" name="transhipOrigins" 			value="'+transhipOrigin+'" />' +
				'<input type="hidden" name="transhipDestinations" 		value="'+transhipDestination+'" />' +
				'<input type="hidden" name="voyageNos" 					value="'+voyageNo+'" />' +
				'<input type="hidden" name="lcNos" 						value="'+lcNo+'" />' +
				'<input type="hidden" name="etds" 						value="'+etd+'" />' +
				'<input type="hidden" name="etas" 						value="'+eta+'" />' +
				'<input type="hidden" name="origins" 					value="'+origin+'" />'+
				'<input type="hidden" name="destns" 					value="'+destn+'" />'+
				'<input type="hidden" name="invCurrRts" 				value="'+invCurrRt+'" />'+
				'<input type="hidden" name="invoiceValues" 				value="'+invoiceValue+'" />'+
				'<input type="hidden" name="markupRates" 				value="'+markupRate+'" />'+
				'<input type="hidden" name="recFlagWCargos" 			value="'+recFlagWCargo+'" />'+
				'<input type="hidden" name="cpiRecNos" 					value="'+cpiRecNo+'" />'+
				'<input type="hidden" name="cpiBranchCds" 				value="'+cpiBranchCd+'" />'+
				'<input type="hidden" name="deductTexts" 				value="'+deductText+'" />'+
				'<input type="hidden" name="geogCds" 					value="'+geogCd+'" />'+
				'<input type="hidden" name="vesselCds" 					value="'+vesselCd+'" />'+
				'<input type="hidden" name="cargoClassCds" 				value="'+cargoClassCd+'" />'+
				'<input type="hidden" name="cargoTypes" 				value="'+cargoType+'" />'+
				'<input type="hidden" name="printTags" 					value="'+printTag+'" />'+
				'<input type="hidden" name="invCurrCds" 				value="'+invCurrCd+'" />'+
				'<input type="hidden" name="deleteWVess" 				value="'+deleteWVes+'" />';

				if ($("vesselCd").value != $("multiVesselCd").value) {
					$$("div[name='carr']").each(function (a)	{
						if (a.getAttribute("item") == $F("itemNo")){
							a.remove();
						}	
					});
				}	
		} else if(lineCd == "AV"){
			var purpose 				= changeSingleAndDoubleQuotes2($F("purpose"));
			var deductText 				= changeSingleAndDoubleQuotes2($F("deductText"));
			var prevUtilHrs 			= $F("prevUtilHrs");
			var estUtilHrs 				= $F("estUtilHrs");
			var totalFlyTime 			= $F("totalFlyTime");
			var qualification 			= changeSingleAndDoubleQuotes2($F("qualification"));
			var geogLimit 				= changeSingleAndDoubleQuotes2($F("geogLimit"));
			var vesselCd 				= $F("vesselCd");
			var recFlagAv				= ($F("recFlagAv") == "" ? "A" : $F("recFlagAv"));

			itemArray = itemArray + 
				'<input type="hidden" name="purposes" 				value="'+purpose+'" />' +
				'<input type="hidden" name="deductTexts" 			value="'+deductText+'" />' +
				'<input type="hidden" name="prevUtilHrss" 			value="'+prevUtilHrs+'" />' +
				'<input type="hidden" name="estUtilHrss" 			value="'+estUtilHrs+'" />' +
				'<input type="hidden" name="totalFlyTimes" 			value="'+totalFlyTime+'" />' +
				'<input type="hidden" name="qualifications" 		value="'+qualification+'" />' +
				'<input type="hidden" name="geogLimits" 			value="'+geogLimit+'" />' +
				'<input type="hidden" name="vesselCds" 				value="'+vesselCd+'" />'+
				'<input type="hidden" name="recFlagAvs" 			value="'+recFlagAv+'" />';
		} else if(lineCd == "CA"){
			var location 				= changeSingleAndDoubleQuotes2($F("location"));
			var limitOfLiability 		= changeSingleAndDoubleQuotes2($F("limitOfLiability"));
			var sectionLineCd 			= $F("sectionLineCd");
			var sectionSublineCd 		= $F("sectionSublineCd");
			var interestOnPremises 		= changeSingleAndDoubleQuotes2($F("interestOnPremises"));
			var sectionOrHazardInfo 	= changeSingleAndDoubleQuotes2($F("sectionOrHazardInfo"));
			var conveyanceInfo 			= changeSingleAndDoubleQuotes2($F("conveyanceInfo"));
			var propertyNo 				= changeSingleAndDoubleQuotes2($F("propertyNo"));
			var locationCd 				= $F("locationCd");
			var sectionOrHazardCd 		= $F("sectionOrHazardCd");
			var capacityCd 				= $F("capacityCd");
			var propertyNoType 			= $F("propertyNoType");
			
			itemArray = itemArray + 
				'<input type="hidden" name="locations" 				value="'+location+'" />' +
				'<input type="hidden" name="limitOfLiabilitys" 		value="'+limitOfLiability+'" />' +
				'<input type="hidden" name="sectionLineCds" 		value="'+sectionLineCd+'" />' +
				'<input type="hidden" name="sectionSublineCds" 		value="'+sectionSublineCd+'" />' +
				'<input type="hidden" name="interestOnPremisess" 	value="'+interestOnPremises+'" />' +
				'<input type="hidden" name="sectionOrHazardInfos" 	value="'+sectionOrHazardInfo+'" />' +
				'<input type="hidden" name="conveyanceInfos" 		value="'+conveyanceInfo+'" />' +
				'<input type="hidden" name="propertyNos" 			value="'+propertyNo+'" />'+
				'<input type="hidden" name="locationCds" 			value="'+locationCd+'" />'+
				'<input type="hidden" name="sectionOrHazardCds" 	value="'+sectionOrHazardCd+'" />'+
				'<input type="hidden" name="capacityCds" 			value="'+capacityCd+'" />'+
				'<input type="hidden" name="propertyNoTypes" 		value="'+propertyNoType+'" />';
		} else if(lineCd == "AH"){
			var noOfPerson 					= $F("noOfPerson");
			var destination 				= changeSingleAndDoubleQuotes2($F("destination"));
			var monthlySalary 				= $F("monthlySalary");
			var salaryGrade 				= changeSingleAndDoubleQuotes2($F("salaryGrade"));
			var positionCd 					= $F("positionCd");
			var delGrpItem					= $F("deleteGroupedItemsInItem");
			var dateOfBirth  				= $F("pDateOfBirth");
			var	age 						= $F("pAge");
			var	civilStatus 				= $F("pCivilStatus");
			var	sex 						= $F("pSex");
			var	height 						= $F("pHeight");
			var	weight 						= $F("pWeight");
			var groupPrintSw				= $F("groupPrintSw");
			var acClassCd					= $F("acClassCd");
			var levelCd						= $F("levelCd");
			var parentLevelCd				= $F("parentLevelCd");
			var itemWitmperlExist 			= $F("itemWitmperlExist");	
			var itemWitmperlGroupedExist 	= $F("itemWitmperlGroupedExist");
			var populatePerils				= $F("populatePerils");
			var itemWgroupedItemsExist  	= $F("itemWgroupedItemsExist");
			var accidentDeleteBill			= $F("accidentDeleteBill");
			
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
			    
		} else if(lineCd == "MH"){
			var vesselCd 		= $F("vesselCd");
			var vesselName 		= $F("vesselName");
			var vesselOldName 	= $F("vesselOldName");
			var vesTypeDesc 	= $F("vesTypeDesc");
     		var propelSw 		= $F("propelSw");
     	    var vessClassDesc 	= $F("vessClassDesc");
     	    var hullDesc 		= $F("hullDesc"); 
     	    var regOwner 		= $F("regOwner");	
      		var regPlace 		= $F("regPlace");
      		var grossTon 		= $F("grossTon"); 
      		var vesselLength 	= $F("vesselLength");
      		var yearBuilt 		= $F("yearBuilt");
      		var netTon 			= $F("netTon");
      		var vesselBreadth 	= $F("vesselBreadth");
      		var noCrew 			= $F("noCrew");
      		var deadWeight 		= $F("deadWeight");
      		var vesselDepth 	= $F("vesselDepth");
      		var crewNat 		= $F("crewNat");
      		var dryPlace 		= $F("dryPlace");
      		var dryDate 		= $F("dryDate");
      		//	var recFlag = $F("recFlag");
			var deductText 		= $F("deductText");
			var geogLimit 		= $F("geogLimit");

			itemArray = itemArray + 
			'<input type="hidden" name="vesselCds" 			value="'+vesselCd+'" />' +
			'<input type="hidden" name="vesselNames" 		value="'+vesselName+'" />' +
			'<input type="hidden" name="vesselOldNames" 	value="'+vesselOldName+'" />' +
			'<input type="hidden" name="vesTypeDescs" 		value="'+vesTypeDesc+'" />' +
			'<input type="hidden" name="propelSws" 			value="'+propelSw+'" />' +
			'<input type="hidden" name="vessClassDescs" 	value="'+vessClassDesc+'" />' +
			'<input type="hidden" name="hullDescs" 			value="'+hullDesc+'" />' +
			'<input type="hidden" name="regOwners" 			value="'+regOwner+'" />' +
			'<input type="hidden" name="regPlaces" 			value="'+regPlace+'" />' +
			'<input type="hidden" name="grossTons" 			value="'+grossTon+'" />' +
			'<input type="hidden" name="vesselLengths" 		value="'+vesselLength+'" />' +
			'<input type="hidden" name="yearBuilts" 		value="'+yearBuilt+'" />' +
			'<input type="hidden" name="netTons" 			value="'+netTon+'" />' +
			'<input type="hidden" name="vesselBreadths" 	value="'+vesselBreadth+'" />' +
			'<input type="hidden" name="noCrews" 			value="'+noCrew+'" />' +
			'<input type="hidden" name="deadWeights" 		value="'+deadWeight+'" />' +
			'<input type="hidden" name="vesselDepths" 		value="'+vesselDepth+'" />' +
			'<input type="hidden" name="crewNats" 			value="'+crewNat+'" />' +
			'<input type="hidden" name="dryPlaces" 			value="'+dryPlace+'" />' +
			'<input type="hidden" name="dryDates" 			value="'+dryDate+'" />' +
			'<input type="hidden" name="geogLimits" 		value="'+geogLimit+'" />' +
			'<input type="hidden" name="deductTexts" 		value="'+deductText+'" />';
		}			
		return itemArray;
	}
	
	function checkCOCSerialNoInPolicy(){		
		new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=checkCOCSerialNoInPolicy",{
			method : "GET",
			parameters : {
				globalParId : $F("globalParId"),
				cocSerialNo : $F("cocSerialNo")
			},
			asynchronous : false,
			evalScripts : true,	
			//onCreate : showNotice("Checking COC Serial No. in Policy, please wait..."),		
			onComplete : 
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("");
						if(response.responseText != 'Empty'){
							showMessageBox(response.responseText, imgMessage.INFO);						
							$("tempVariable").value = 1;						
						}
					}				
				} 
		});		
	}
	
	function checkCOCSerialNoInPar(){
		var parId = $F("globalParId");
		var itemNo = $F("itemNo");
		var cocSerialNo = $F("cocSerialNo");
		var cocType = $F("cocType");
		
		new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=checkCOCSerialNoInPar", {
			method : "GET",
			parameters : {
				globalParId : parId,
				itemNo : itemNo,
				cocSerialNo : cocSerialNo,
				cocType : cocType
			},
			asynchronous : false,
			evalScripts : true,
			//onCreate : showNotice("Checking COC Serial No. in Par, please wait..."),
			onComplete :
				function(response){
					if (checkErrorOnResponse(response)) {
						hideNotice("");
						if(response.responseText != 'Empty'){
							showMessageBox(response.responseText, imgMessage.INFO);
							$("tempVariable").value = 1;
						}
					}
				}
		});		
	}
	
	/* Perils Function */
	function hideAllPerilDivs()	{
		$$("div[name='itemPerilMotherDiv']").each(function (perilDiv)	{
			perilDiv.hide();
		}); 
	}
	
	function clearItemFields(){
		$("itemNo").value 				= "";
		$("itemPackLineCd").value 		= "";
		$("itemPackSublineCd").value 	= "";
		$("prorateFlag").value 			= "";
		$("shortRtPercent").value		= "";
	}	
	
	function showPerilDiv(){
		new Effect.toggle("perilInformationDiv", "blind", {duration: .2});
	}

	/* End for Peril Functions */	
	
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

		if($F("globalLineCd") != "MN" && $F("globalLineCd") != "AV" && $F("globalLineCd") != "CA" && $F("globalLineCd") != "AH" && $F("globalLineCd") != "MH" && $F("globalLineCd") != "EN"){ //orio

			if(!($("mortgageeInfo").empty())){
				$("mortgageeName").value = "";
				$("mortgageeAmount").value = "0.00";
				$("mortgageeItemNo").value = $F("itemNo");

				disableButton("btnDeleteMortgagee");
				$("btnAddMortgagee").value = "Add";
			}
		} else if ($F("globalLineCd") == "MN"){
			if(!($("listOfCarriersInfo").empty())){
				$("carrier").selectedIndex = 0;
				$("carrierPlateNo").value = "";
				$("carrierMotorNo").value = "";
				$("carrierSerialNo").value = "";
				$("carrierLimitLiab").value = "";
				$("btnAddCarrier").value = "Add";
				disableButton("btnDeleteCarrier");
				$("carrierEtd").value = "";
				$("carrierEta").value = "";
				$("carrierOrigin").value = "";
				$("carrierDestn").value = "";
				$("carrierDeleteSw").value = "";
				$("carrierVoyLimit").value = "";
				checkTableItemInfoAdditional("carrierTable","carrierListing","carr","item",$F("itemNo"));
			}	
		}		

		if ($F("globalLineCd") == "CA"){
			if (!($("groupedItemsInfo").empty())){
				$("groupedItemTitle").value = "";
				$("groupItemCd").selectedIndex = 0;
				$("amountCovered").value = "";
				$("remarks").value = "";
				$("includeTag").value = "Y";
				$("btnAddGroupedItems").value = "Add";
				disableButton("btnDeleteGroupedItems");
				$$("div[name='grpItem']").each(function (div) {
					div.removeClassName("selectedRow");
				});
				checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
			}
			if (!($("personnelInformationInfo").empty())){
				$("personnelName").value = "";
				$("capacityCdP").selectedIndex = 0;
				$("amountCoveredP").value = "";
				$("remarksP").value = "";
				$("includeTagP").value = "Y";
				$("btnAddPersonnel").value = "Add";
				disableButton("btnDeletePersonnel");
				$$("div[name='per']").each(function (div) {
					div.removeClassName("selectedRow");
				});
				checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
			}	
		}	

		if ($F("globalLineCd") == "AH"){
			if (!($("beneficiaryInformationInfo").empty())){
				$$("div[name='ben']").each(function (div) {
					div.removeClassName("selectedRow");
				});
				checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
			}
		}	
			
		if($F("globalLineCd") == "MC"){
			if(!($("accessory").empty())){
				$("selAccessory").value = "";
				$("accessoryAmount").clear();

				disableButton("btnDeleteA");
				$("btnAddA").value = "Add";
				checkTableItemInfoAdditional("accessoryTable","accListing","acc","item",$F("itemNo"));		
			}
		}		

		$("perilCd").value = "";
		$("perilRate").value = "0";
		$("perilTsiAmt").value = "0.00";
		$("premiumAmt").value = "0.00";
		$("compRem").value = "";

		disableButton("btnDeletePeril");
		$("btnAddItemPeril").value = "Add";

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
	
	function aviationFilterLOV(){
		showListing($("vesselCd"));
		$$("div#itemTable div[name='rowItem']").each(function(row){
			if (row.down("input", 0).getAttribute("name") != "delParIds"){
				var vesselCd = row.down("input", 38).value;
				for(var i = 1; i < $("vesselCd").options.length; i++){ 
					if (vesselCd == $("vesselCd").options[i].value){
						$("vesselCd").options[i].hide();
						$("vesselCd").options[i].disabled = true;
					}
				}
			}
		});
	}

	if ($F("globalLineCd") == "AV"){
		aviationFilterLOV();
	}
	
	function clearAviationModule(){
		$("region").addClassName("required");
		$("vesselCd").selectedIndex = 0;
		$("airType").value = "";
		$("rpcNo").value = "";
		$("prevUtilHrs").value = "";
		$("estUtilHrs").value = "";
		$("totalFlyTime").value = "";
		$("purpose").value = "";
		$("deductText").value = "";
		$("qualification").value = "";
		$("geogLimit").value = "";
		$("recFlagAv").value = "A";
		if ($F("globalParType") == "E"){
			$("qualification").removeClassName("required");
			$("geogLimit").removeClassName("required");
		}
		hideCoverage();
	}	
	
	function clearMarineHullModule(){
		$("vesselCd").selectedIndex = 0;
		$("vesselOldName").value = "";
		$("vesTypeDesc").value = "";
		$("propelSw").value = "";
		$("vessClassDesc").value = "";
		$("hullDesc").value = "";
		$("regOwner").value = "";
		$("regPlace").value = "";
		$("grossTon").value = "";
		$("netTon").value = "";
		$("deadWeight").value = "";
		$("yearBuilt").value = "";
		$("vesselLength").value = "";
		$("vesselDepth").value = "";
		$("vesselBreadth").value = "";
		$("noCrew").value = "";
		$("crewNat").value = "";
		$("dryPlace").value = "";
		$("dryDate").value = "";
		$("geogLimit").value = "";
	}
	
	function clearCasualtyModule(){
		$("region").addClassName("required");
		$("location").value = "";
		$("limitOfLiability").value = "";
		$("sectionLineCd").value = "";
		$("sectionSublineCd").value = "";
		$("interestOnPremises").value = "";
		$("sectionOrHazardInfo").value = "";
		$("conveyanceInfo").value = "";
		$("propertyNo").value = "";
		$("locationCd").selectedIndex = 0;
		$("sectionOrHazardCd").selectedIndex = 0;
		$("capacityCd").selectedIndex = 0;
		$("propertyNoType").selectedIndex = 0; 
		generateSequenceItemInfo("grpItem","groupedItemNo","item",$F("itemNo"),"nextItemNo");
		checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
		generateSequenceItemInfo("per","personnelNo","item",$F("itemNo"),"nextItemNoP");
		checkTableItemInfoAdditional("personnelTable","personnelListing","per","item",$F("itemNo"));
		hideCoverage();
	}	
	
	function clearAccidentModule(){
		$("accidentFromDate").value = "";
		$("accidentToDate").value = "";
		$("accidentPackBenCd").selectedIndex = 0;
		$("accidentPaytTerms").selectedIndex = 0;
		$("accidentProrateFlag").value = "2";
		$("accidentProrateFlag").removeClassName("required");
		$("accidentProrateFlag").disable();
		$("shortRateSelectedAccident").hide();
		$("prorateSelectedAccident").hide();
		$("accidentNoOfDays").value = "";
		$("accidentShortRatePercent").value = "";
		$("accidentCompSw").selectedIndex = 2;
		$("noOfPerson").value = "";
		$("destination").value = "";
		$("monthlySalary").value = "";
		$("salaryGrade").value = "";
		$("positionCd").selectedIndex = 0;
		generateSequenceItemInfo("ben","beneficiaryNo","item",$F("itemNo"),"nextItemNoBen");
		checkTableItemInfoAdditional("benefeciaryTable","beneficiaryListing","ben","item",$F("itemNo"));
		$("personalAdditionalInfoDetail").hide();
		$("personalAdditionalInformationInfo").hide();
		$("showPersonalAdditionalInfo").update("Show");
		disableButton("btnGroupedItems");
		enableButton("btnPersonalAddtlInfo");	

		$("pDateOfBirth").value = "";
		$("pAge").value = "";
		$("pCivilStatus").selectedIndex = 0;
		$("pSex").selectedIndex = 0;
		$("pHeight").value = "";
		$("pWeight").value = "";
		$("groupPrintSw").value = "";
		$("acClassCd").value = "";
		$("levelCd").value = "";
		$("parentLevelCd").value = "";
		$("itemWitmperlExist").value = "";
		$("itemWitmperlGroupedExist").value = "";
		$("accidentFromDate").enable();
		$("hrefAccidentFromDate").setAttribute("onClick","scwShow($('accidentFromDate'),this, null);");
		$("accidentToDate").enable();
		$("hrefAccidentToDate").setAttribute("onClick","scwShow($('accidentToDate'),this, null);");
		$("accidentPackBenCd").enable();
		$("populatePerils").value = "";
		$("itemWgroupedItemsExist").value = "";
		$("currency").enable();
	}	
		
	if ($F("globalLineCd") != "AH"){
		$("accidentFromDate").up("tr",0).hide();
		$("accidentPackBenCd").up("tr",0).hide();
		$("paramAccidentProrateFlag").up("td",0).hide();
		$("accidentCondition").up("td",0).hide();
	} else{ 
		initAccident();
	}			
	var objBenDtlsListing = eval('${benDtlsListing}');
	var vAlert = 1;
	
	function initAccident(){
		$("region").addClassName("required");

		$("accidentPackBenCd").observe("change", function() {
			if ($F("accidentPackBenCd") != "" && $F("itemWgroupedItemsExist") == "Y"){
				showConfirmBox("Message", "There are existing grouped items and system will populate/overwrite perils on ALL grouped items. Would you like to automatically populate peils?",  
						"Yes", "No", onOkFunc, onCancelFunc);
			} else { // adds peril packa for plan if no constraints for selected pack ben cd BRYAN 11/17/2010
				if ($F("accidentPackBenCd") != ""){
					showConfirmBox("Update Plan", "Updating the plan will overwrite existing plan.", "Ok", "Cancel", 
						function(){
							if (countPerilsForItem($F("itemNo")) > 0){
								showConfirmBox("Information", "Inserting a new plan will overwrite existing perils for this item, would you like to continue?", "Yes", "No",
									addPlanPackPerils, 
									function(){
										$("accidentPackBenCd").value = $("vOldPlan").value;
									}
								);
							} else {
								addPlanPackPerils();
							}
						}, 
						function(){
							$("accidentPackBenCd").value = $("vOldPlan").value;
						}
					);
				}
			}	
		});	
		function onOkFunc(){
			$("populatePerils").value = "Y";
			
			//added for population of perils under plan when accidentPackBenCd is changed BRYAN 11/17/2010
			deleteItemPerilsForItemNo($F("itemNo"));
			addPlanPackPerils();
		}

		function addPlanPackPerils(){
			$("perilPackageCd").value = $("accidentPackBenCd").value;
			$("vOldPlan").value = $("accidentPackBenCd").value;
			
			var vNoOfDays 			= computeNoOfDays($F("globalEffDate"), $F("globalExpiryDate"), "");
			var vPolProrateFlag 	= $F("globalProrateFlag");
			var vPolCompSw 			= $F("globalCompSw");
			var vPolShortRtPercent 	= parseFloat($F("globalShortRtPercent"));
			//GIPI_WITEM VALUES
			var vItemDays 			= computeNoOfDays($F("fromDate"), $F("toDate"), "");
			var vItemProrateFlag 	= $F("prorateFlag");
			var vItemCompSw 		= $F("compSw");
			var vItemShortRtPercent = parseFloat($F("shortRtPercent"));
			//
			var vTsiAmt				= 0.00;
			var vYear				= 0;
			var now 				= new Date();
			//var now 				= new Date();
			for (x=0; x<objBenDtlsListing.length; x++){
				if (objBenDtlsListing[x].packBenCd == $("perilPackageCd").value){
					vTsiAmt = nvl( objBenDtlsListing[x].benefit, 0.00)*(nvl( objBenDtlsListing[x].noOfDays, (nvl( vItemDays,  vNoOfDays))));
					vYear = now.getFullYear(); 
					if (("" != $F("fromDate")) && ("" != $F("toDate"))){
						if ("1" == vItemProrateFlag){
							if ("Y" == vItemCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)* vTsiAmt*(vItemDays+1)/checkDuration($F("fromDate"), $F("toDate"));
							} else if ("M" == vItemCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)* vTsiAmt*(vItemDays-1)/checkDuration($F("fromDate"), $F("toDate"));
							} else {
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)* vTsiAmt*(vItemDays)/checkDuration($F("fromDate"), $F("toDate"));
							}
						} else if ("2" == vItemProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)*vTsiAmt;
						} else if ("3" == vItemProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)*vTsiAmt*nvl(vItemShortRtPercent, 0)/100;
						}
					} else {
						if ("1" == vPolProrateFlag){
							if ("Y" == vPolCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(vNoOfDays+1)/checkDuration($F("globalEffDate"), $F("globalExpiryDate"));
							} else if ("M" == vPolCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(vNoOfDays-1)/checkDuration($F("globalEffDate"), $F("globalExpiryDate"));
							} else {
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(vNoOfDays)/checkDuration($F("globalEffDate"), $F("globalExpiryDate"));
							}
						} else if ("2" == vPolProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0);
						} else if ("3" == vPolProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(nvl(vPolShortRtPercent, 0))/100;
						}
					}
					
					//ADDING PERILS
					var itemNoOfPeril = $F("itemNo");
					var lineCd = $F("globalLineCd");
					var perilCd = objBenDtlsListing[x].perilCd;
					var perilName = objBenDtlsListing[x].perilName;
					var perilRate = formatToNineDecimal(0);
					var tsiAmt = formatCurrency(nvl(vTsiAmt, 0));
					var premAmt = formatCurrency(nvl(objBenDtlsListing[x].premAmt, 0));
					var compRem = "---";
					var perilType = objBenDtlsListing[x].perilType;
					var wcSw = "N";
					var tarfCd = "";
					var annTsiAmt = formatCurrency(nvl(vTsiAmt, 0));
					var annPremAmt = formatCurrency(nvl(objBenDtlsListing[x].premAmt, 0));
					var prtFlag = "";
					var riCommRate = "";
					var riCommAmt = "";
					var surchargeSw = "";
					var baseAmt = formatCurrency(nvl(objBenDtlsListing[x].benefit, 0));
					var aggregateSw = "";
					var discountSw = "";
					var bascPerlCd = "";
					var noOfDays = nvl(nvl(objBenDtlsListing[x].noOfDays, nvl(vItemDays, vNoOfDays)), 0);
					var labelContent = 	'<label name="text" style="width: 5%; text-align: right; margin-right: 5px;" labelName="itemNo">'+itemNoOfPeril+'</label>'+
									'<label name="text" style="width: 20%; text-align: left; margin-left: 5px;">'+perilName+'</label>'+
									'<label name="text" style="width: 15%; text-align: right;" class="moneyRate">'+perilRate+'</label>'+
									'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+tsiAmt+'</label>'+
									'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money";>'+premAmt+'</label>'+
									'<label name="text" style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>';
					$("addItemNo").value = itemNoOfPeril;
					$("addPerilCd").value = perilCd;
					var itemPerilTable = $("itemPerilMainDiv"); //$("parItemPerilTable");
					var itemPerilMotherDiv = $("itemPerilMotherDiv"+itemNoOfPeril);
					var isNew = false;
					if (itemPerilMotherDiv == undefined)	{
						isNew = true;
						itemPerilMotherDiv = new Element("div");
						itemPerilMotherDiv.setAttribute("id", "itemPerilMotherDiv"+itemNoOfPeril);
						itemPerilMotherDiv.setAttribute("name", "itemPerilMotherDiv");
						itemPerilMotherDiv.addClassName("tableContainer");
					}
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "rowPeril"+itemNoOfPeril+perilCd);
					newDiv.setAttribute("name", "row2");
					newDiv.setAttribute("item", itemNoOfPeril);
					newDiv.setAttribute("peril", perilCd);
					newDiv.addClassName("tableRow");
					//newDiv.setStyle("display: none;");
					newDiv.update(labelContent +
						'<input type="hidden" name="perilItemNos"		value="'+itemNoOfPeril+'" />'+
						'<input type="hidden" name="perilLineCds"		value="'+lineCd+'" />'+
						'<input type="hidden" name="perilPerilNames" 	value="'+perilName+'" />'+
						'<input type="hidden" name="perilPerilCds" 		value="'+perilCd+'" />'+
						'<input type="hidden" name="perilPremRts" 		class="moneyRate" 	value="'+perilRate+'" />'+
						'<input type="hidden" name="perilTsiAmts" 		class="money" 		value="'+tsiAmt+'" />'+
						'<input type="hidden" name="perilPremAmts" 		class="money" 		value="'+premAmt+'" />'+
						'<input type="hidden" name="perilCompRems" 		value="'+compRem+'" />'+
						'<input type="hidden" name="perilPerilTypes"	value="'+perilType+'" />'+
						'<input type="hidden" name="perilWcSws"			value="'+wcSw+'" />'+
						'<input type="hidden" name="perilTarfCds" 		value="'+tarfCd+'" />'+
						'<input type="hidden" name="perilAnnTsiAmts" 	value="'+annTsiAmt+'" />'+
						'<input type="hidden" name="perilAnnPremAmts" 	value="'+annPremAmt+'" />'+
						'<input type="hidden" name="perilPrtFlags" 		value="'+prtFlag+'" />'+
						'<input type="hidden" name="perilRiCommRates" 	value="'+riCommRate+'" />'+
						'<input type="hidden" name="perilRiCommAmts" 	value="'+riCommAmt+'" />'+
						'<input type="hidden" name="perilSurchargeSws" 	value="'+surchargeSw+'" />'+
						'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
						'<input type="hidden" name="perilAggregateSws" 	value="'+aggregateSw+'" />'+
						'<input type="hidden" name="perilDiscountSws" 	value="'+discountSw+'" />'+
						'<input type="hidden" name="perilBascPerlCds" 	value="'+bascPerlCd+'" />'+
						'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
						'<input type="hidden" name="perilNoOfDayss" 	value="'+noOfDays+'" />');
					itemPerilMotherDiv.insert({bottom: newDiv});						
					if (isNew)	{							
						itemPerilTable.insert({bottom: itemPerilMotherDiv});
					}
					initializePerilRow(newDiv);
					$$("label[name='text']").each(function (label)	{
						if ((label.innerHTML).length > 15)    {
				            label.update((label.innerHTML).truncate(30, "..."));
				        }
					});
					Effect.Appear("rowPeril"+itemNoOfPeril+perilCd, {
						duration: .2,
						afterFinish: function () {
							clearItemPerilFields();
							$("dumPerilCd").value = "";								
							hideAllItemPerilOptions();
							selectItemPerilOptionsToShow();
							hideExistingItemPerilOptions();
							changeCheckImageColor();
							checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
							$("itemPerilMainDiv").show();
							$("itemPerilMotherDiv"+$F("itemNo")).show();
							getTotalAmounts();
						}
					});								
					$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);		
				}
			}
			$("vOldPlan").value = $("perilPackageCd").value;
		}
			
		function onCancelFunc(){
			var temp = "";
			$$("div#itemTable div[name='rowItem']").each(function(a){
				if (a.hasClassName("selectedRow")){
					temp = a.down("input",27).value;		
				}	
			});	
			if (temp != ""){
				$("accidentPackBenCd").value = temp;
			}
			$("populatePerils").value = "";
		}	

		var prorateFlagText = "";
		var compSw = "";
		var shortRatePercent = "";
		var accidentNoOfDays = "";
		var accidentNoOfDays2 = "";
		var accidentDaysOfTravel = "";
		var accidentToDate = "";
		var accidentFromDate = "";
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
			$$("div#itemTable div[name='rowItem']").each(function(row){
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
				$$("div#itemTable div[name='rowItem']").each(function(row){
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
			$$("div#itemTable div[name='rowItem']").each(function(row){
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
		});	

		$("accidentFromDate").observe("blur", function() {
			$$("div#itemTable div[name='rowItem']").each(function(row){
				if(row.hasClassName("selectedRow")){			
					accidentFromDate  = row.down("input", 14).value;
					accidentToDate    = row.down("input", 15).value;
				}	
			});

			if ($F("itemWitmperlExist") == "Y"){
				if ($F("accidentDeleteBill") != "Y"){
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
				$("accidentDeleteBill").value = "Y";
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
				showRelatedSpan();
				getNewExpiry();
				validate();
			}
			function onCancelFuncNoOfDays(){
				$("accidentNoOfDays").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
				$("accidentDaysOfTravel").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
				$("accidentFromDate").value = accidentFromDate;
				showRelatedSpan();
			}

			function validate(){
				var fromDate = makeDate($F("accidentFromDate"));
				var toDate = makeDate($F("accidentToDate"));
				var iDate = makeDate($F("wpolbasInceptDate"));
				var eDate = makeDate($F("wpolbasExpiryDate"));
				if (fromDate > toDate){
					showMessageBox("Start of Effectivity date should not be later than the End of Effectivity date.", imgMessage.ERROR);
					$("accidentFromDate").value = "";
					$("accidentFromDate").focus();
					$("accidentDaysOfTravel").value = "";
				} else if (fromDate > eDate){
					showMessageBox("Start of Effectivity date should not be later than the Policy Expiry date.", imgMessage.ERROR);
					$("accidentFromDate").value = "";
					$("accidentFromDate").focus();
					$("accidentDaysOfTravel").value = "";
				} else if (fromDate < iDate){
					showMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date.", imgMessage.ERROR);
					$("accidentFromDate").value = "";
					$("accidentFromDate").focus();	
					$("accidentDaysOfTravel").value = "";
				} else{
					if ($F("accidentFromDate") != ""){
						$("accidentToDate").value = $F("wpolbasExpiryDate");
						$("accidentToDate").focus();
					}
					$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
				}
				showRelatedSpan();
	
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
				}
			}	
		});
		 
		$("accidentToDate").observe("blur", function() {
			$$("div#itemTable div[name='rowItem']").each(function(row){
				if(row.hasClassName("selectedRow")){			
					accidentFromDate  = row.down("input", 14).value;
					accidentToDate    = row.down("input", 15).value;
				}	
			});
				
			if ($F("itemWitmperlExist") == "Y"){
				if ($F("accidentDeleteBill") != "Y"){
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
				$("accidentDeleteBill").value = "Y";
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
				showRelatedSpan();
				getNewExpiry();
				validate();
			}
			function onCancelFuncNoOfDays(){
				$("accidentNoOfDays").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
				$("accidentDaysOfTravel").value = computeNoOfDays(accidentFromDate,accidentToDate,"");
				$("accidentToDate").value = accidentToDate;
				showRelatedSpan();
			}

			function validate(){
				var fromDate = makeDate($F("accidentFromDate"));
				var toDate = makeDate($F("accidentToDate"));
				var iDate = makeDate($F("wpolbasInceptDate"));
				var eDate = makeDate($F("wpolbasExpiryDate"));
				if (toDate < fromDate){
					showMessageBox("End of Effectivity date should not be earlier than the Start of Effectivity date.", imgMessage.ERROR);
					$("accidentToDate").value = "";
					$("accidentToDate").focus();	
					$("accidentDaysOfTravel").value = "";			
				} else if (toDate > eDate){
					showMessageBox("End of Effectivity date should not be later than the Policy Expiry date.", imgMessage.ERROR);
					$("accidentToDate").value = "";
					$("accidentToDate").focus();
					$("accidentDaysOfTravel").value = "";
				} else if (toDate < iDate){
					showMessageBox("End of Effectivity date should not be earlier than the Policy inception date.", imgMessage.ERROR);
					$("accidentToDate").value = "";
					$("accidentToDate").focus();
					$("accidentDaysOfTravel").value = "";
				} else{
					$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
				}
				
				showRelatedSpan();
				
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
				}
			}
		});	
	}
	
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
	}
	
	function getNewExpiry(){
		if ($F("accidentNoOfDays") != "" && $F("accidentNoOfDays") != "NaN"){
			var compSw = $F("accidentCompSw");
			var newDate = Date.parse($F("accidentFromDate"));
			var num = $F("accidentNoOfDays");
			if (compSw == "Y"){
				num = parseInt(num)-1;
			}else if (compSw == "M"){
				num = parseInt(num)+1;
			}else{
				num = parseInt(num);		
			}
			newDate.add(num).days();
			var month = newDate.getMonth()+1 < 10 ? "0" + (newDate.getMonth()+1) : newDate.getMonth()+1;
			$("accidentToDate").value =  month + "-" + ((newDate.getDate()< 10) ? "0"+newDate.getDate() :newDate.getDate()) + "-" + newDate.getFullYear();
			$("accidentDaysOfTravel").value = computeNoOfDays($F("accidentFromDate"),$F("accidentToDate"),"");
			$("accidentToDate").focus();
		}else if ($F("accidentNoOfDays") == "NaN"){
			$("accidentToDate").clear();
			$("accidentNoOfDays").clear();
			$("accidentDaysOfTravel").clear();
			$("accidentToDate").focus();
			showRelatedSpan();
		}	
	}
	
	function hideCoverage(){
		$("hideCoverage").up("td",0).hide();
		$("coverage").up("td",0).hide();
		$("hideCoverage").value = "Y";
	}
	
	function postFormsCommit(){
		if($F("varPost2") == "N"){
			stopProcess();
		}

		if($F("varPost").blank()){
			/* converted validate_other_info from oracle forms */
			var motor = $F("motorNumbers").trim().split("\n");
			var serial = $F("serialNumbers").trim().split("\n");
			var plate = $F("plateNumbers").trim().split("\n");
			
			if((motor.indexOf($F("motorNo")) > -1) || (serial.indexOf($F("serialNo")) > -1) || (plate.indexOf($F("plateNo")) > -1)){
				showMessageBox("Vehicle item information (plate no, chassis no, engine no) already exist in other record/s. " + 
						"Please check the details at View motor issuance screen.", imgMessage.WARNING);	/* C */
				$("parOtherSw").value = "N"; 
			} else{
				if($F("parOtherSw") != "Y"){
					new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=validateOtherInfo",{
						method : "GET",
						parameters : {
							globalParId : $F("globalParId")
						},					
						asynchronous : false,
						evalScripts : true,			
						onComplete : 
							function(response){
								if (checkErrorOnResponse(response)) {
									if(response.responseText != 'Empty'){
										showMessageBox(response.responseText, imgMessage.WARNING);	/* C */										
										return false; 					
									}				
								}
							} 
					});
					$("parOtherSw").value = "N";	
				}					
			}
			/* end of validate_other_info */
		}
		if($F("varPost").blank() && $F("nbtInvoiceSw") == "Y"){
			new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=preFormsCommit",{
				method : "POST",
				parameters : {
					globalParId : $F("globalParId"),
					lineCd : $F("globalLineCd"),
					parStatus : $F("globalParStatus"),
					invoiceSw : $F("nbtInvoiceSw")
				},					
				asynchronous : false,
				evalScripts : true,			
				onComplete : 
					function(response){
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							if(result.msgType == "ALERT"){
								showMessageBox(result.msgAlert, imgMessage.ERROR);	/* C */										
								return false; 					
							}else if(result.msgType == "CONFIRM"){
								showConfirmBox("Item Info", result.msgAlert, "Yes", "No", stopProcess, stopProcess);
							}
						}
					} 
			});
		}		
	}

	function stopProcess(){
		return false;
	}
	
	function subpagesTableListingBehavior(blnLoadRelatedRecords){
		try{
			if(blnLoadRelatedRecords){
				if($F("globalLineCd") == "MC" || $F("globalLineCd") == "FI"){
					// mortgagee
					
					if($("mortgageeTable") != null){
						setMortgageeForm(null);
						//checkPopupsTable("mortgageeTable","mortgageeListing","rowMortg");						
						
						toggleSubpagesRecord(objMortgagees, objItemNoList, $F("itemNo"), "row", "mortgCd",
								"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeTable", "amount", false);

						//filterLOV3("mortgageeName", "rowMortg", $F("mortgageeName"), "item", $F("itemNo"), "mortgCd");
						filterLOV3("mortgageeName", "rowMortg", "mortgCd", "item", $F("itemNo"));

						checkPopupsTableWithTotalAmountbyObject(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
								"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount");
					}				
				}

				// item deductibles
				if($("deductiblesTable2") != null){
					checkPopupsTable("deductiblesTable2","wdeductibleListing2","ded2");
					//setTotalAmount(2, $F("itemNo"));// andrew - 09.22.2010 - commented this line, added the next line 
					setTotalAmount(2, $F("itemNo"), 0);
				}			
			}else{
				if($F("globalLineCd") == "MC" || $F("globalLineCd") == "FI"){
					// mortgagee
					if($("mortgageeTable") != null){
						initializeSubPagesTableListing("mortgageeTable", "rowMortg");
						setMortgageeForm(null);						
						reloadLOV("mortgageeName");
					}			
				}

				if($("deductiblesTable2") != null){
					initializeSubPagesTableListing("deductiblesTable2", "ded2");				
				}

				// item peril deductibles
				if($("deductiblesTable3") != null){
					initializeSubPagesTableListing("deductiblesTable3", "ded3");				
				}	
			}	
		}catch(e){
			showErrorMessage("subpagesTableListingBehavior", e);
			//showMessageBox("subpagesTableListingBehavior : " + e.message);
		}					
	}	

	function togglePerilSubpageRecords(){
		$$("div[name='itemPerilMotherDiv']").each(function(motherDiv){
			if (motherDiv.getAttribute("id") == "itemPerilMotherDiv"+$F("itemNo")){
				motherDiv.show();
			} else {
				motherDiv.hide();
			}
		});
	}
	
	function getNextItemNo(tableName, rowName){
		var itemNos = "";
		var nextItemNo = 1;
		
		$$("div#" + tableName + " div[name='" + rowName + "']").each(
			function (row){
				itemNos = itemNos + row.down("input", 1).value + " ";
		});

		nextItemNo = parseInt(nextItemNo) + parseInt(sortNumbers(itemNos.trim()).last());
		return nextItemNo;
	}

	/*	Created by	: mark jm 09.13.2010
	*	Description	: Returns a copy of selected item record in string format
	*	Parameter	: row - div to be copied
	*/
	
	function generateItemClone(row){
		var arr =  $(row).childElements();
		
		var contentArray = new Array(3);		
			
		var inspectedElement = "";
		var elementType = "";
		var elementName = "";
		var elementId = "";
		var elementValue = "";
		var elementTitle = "";
		var elementStyle = "";
		var elementInnerHTML = "";
		var labelElement = "";
		var inputElement = "";

		contentArray[0] = "";
		contentArray[1] = "";
		contentArray[2] = "";
		
		arr.each(function(element){			
			inspectedElement = element.inspect();
			elementType = element.getAttribute("type");
			elementName = element.getAttribute("name") == null ? "" : element.getAttribute("name");
			elementId = element.identify("id");
			elementStyle = element.getAttribute("style");
			
			elementInnerHTML = element.innerHTML;
			
			if(element instanceof HTMLLabelElement){
				if(element.getAttribute("labelName") == "itemNo"){
					elementInnerHTML = getNextItemNo("itemTable", "rowItem");
					labelElement = '<label name="' + elementName + '" style="' + elementStyle + '" labelName="itemNo" title="' + elementTitle + '">' + elementInnerHTML + '</label>'; 
				}else{
					labelElement = '<label name="' + elementName + '" style="' + elementStyle + '" title="' + elementTitle + '">' + elementInnerHTML + '</label>';
				}				
								
				contentArray[2] = contentArray[2] + labelElement + "\n";
			}else if(element instanceof HTMLInputElement){

					if(elementName == "masterItemNos" || elementName == "itemItemNos" || elementName == "detailItemNos"){
						elementValue = getNextItemNo("itemTable", "rowItem");
					}else if(elementName == "detailMotorNos" || elementName == "detailSerialNos" || elementName == "detailCOCSerialNos" ||
							elementName == "addlInfoMotorNos" || elementName == "addlInfoSerialNos" || elementName == "addlInfoCOCSerialNos"){
						elementValue = "";
					}else{
						elementValue = changeSingleAndDoubleQuotes2($F(elementId));
					}					

					if(elementName.startsWith("master")){
						elementName = elementName.replace("master", "item");
						inputElement = '<input type="' + elementType + '" name="' + elementName + '" value="' + elementValue + '" />';
						contentArray[0] = contentArray[0] + inputElement + "\n";
					}else if(elementName.startsWith("detail")){
						elementName = elementName.replace("detail", "addlInfo");
						inputElement = '<input type="' + elementType + '" name="' + elementName + '" value="' + elementValue + '" />';
						contentArray[1] = contentArray[1] + inputElement + "\n";
					}else if(elementName.startsWith("item")){
						inputElement = '<input type="' + elementType + '" name="' + elementName + '" value="' + elementValue + '" />';
						contentArray[0] = contentArray[0] + inputElement + "\n";
					}else if(elementName.startsWith("addlInfo")){
						inputElement = '<input type="' + elementType + '" name="' + elementName + '" value="' + elementValue + '" />';
						contentArray[1] = contentArray[1] + inputElement + "\n";
					}										
			}			 
		});		

		return contentArray;
	}

	/*	Created by	: mark jm 09.23.2010
	*	Description	: Returns a copy of selected item record in string format
	*	Parameter	: row - row to be copied
	*/
	function generateItemRowHashMap(row){
		var arr = $(row).childElements();
		var rowHash = new Hash();
		var elementName = "";
		var elementValue = "";
		
		arr.each(
			function(element){
				if(element instanceof HTMLInputElement){
					elementName = element.getAttribute("name");
					elementValue = element.getAttribute("value");
					
					if(elementName.startsWith("master") || elementName.startsWith("detail")){
						elementName = elementName.substr(6, elementName.length - 7);					
					}else if(elementName.startsWith("item")){
						elementName = elementName.substr(4, elementName.length - 5); 
					}else if(elementName.startsWith("addlInfo")){
						elementName = elementName.substr(8, elementName.length - 9);
					}

					elementName = elementName.substr(0,1).toLowerCase() + elementName.substr(1, elementName.length - 1);					
					
					if(elementName == "itemNo"){
						elementValue = getNextItemNo("itemTable", "rowItem");
					}else{
						elementValue = changeSingleAndDoubleQuotes2($F(element.identify("id")));
					}
					
					rowHash.set(elementName, elementValue);
				}
			});

		return rowHash;
	}

	/*	Created by	: mark jm 09.14.2010
	*	Description	: Returns a copy of selected peril record in string format
	*	Parameter	: row - div to be copied
	*/
	
	function generatePerilClone(row){
		var arr =  $(row).childElements();
		
		var contentArray = new Array(2);
		var currentItemNo = getNextItemNo("itemTable", "rowItem");

		var inspectedElement = "";
		var elementType = "";
		var elementName = "";
		var elementId = "";
		var elementValue = "";
		var elementTitle = "";
		var elementStyle = "";
		var elementInnerHTML = "";
		var labelElement = "";
		var inputElement = "";

		contentArray[0] = "";
		contentArray[1] = "";
		
		arr.each(
			function(element){
				inspectedElement = element.inspect();
				elementType = element.getAttribute("type");
				elementName = element.getAttribute("name") == null ? "" : element.getAttribute("name");
				elementId = element.identify("id");
				elementStyle = element.getAttribute("style");
				elementValue = element.getAttribute("value");				
				
				elementInnerHTML = element.innerHTML;
				
				if(element instanceof HTMLLabelElement){
					if(element.getAttribute("labelName") == "itemNo"){
						elementInnerHTML = currentItemNo;
						labelElement = '<label name="' + elementName + '" style="' + elementStyle + '" labelName="itemNo" title="' + elementTitle + '">' + elementInnerHTML + '</label>';
					}else{
						labelElement = '<label name="' + elementName + '" style="' + elementStyle + '" title="' + elementTitle + '">' + elementInnerHTML + '</label>';
					}					
									
					contentArray[1] = contentArray[1] + labelElement + "\n";
				}else if(element instanceof HTMLInputElement){					
					//elementValue = ((elementName == "itemNo" + row.down("input", 0).value) || elementName == "perilItemNos")  ? currentItemNo : element.getAttribute("value");

					if(elementName.startsWith("itemPeril")){
						elementName = elementName.substr(9, elementName.length - 9);
						elementName = "peril" + elementName.substr(0,1).capitalize() + elementName.substr(1, (elementName.length - 2)) + "s";
					}

					if(elementName == "perilItemNos"){
						elementValue = currentItemNo;
					}else{
						elementValue = element.getAttribute("value");
					}																				
					
					inputElement = '<input type="' + elementType + '" name="' + elementName + '" value="' + elementValue + '" />';
					contentArray[0] = contentArray[0] + inputElement + "\n";					
				}
				
			});			

		return contentArray;
	}

	function loadDeductibleTables(){		
		if($("deductiblesTable2") == null){
			showDeductibleModal(2);
		}

		if($("deductiblesTable3") == null){
			showDeductibleModal(3);
		}
	}

	function showOtherDetails(){
		showEditor("otherInfo", 2000);
	}	

	function loadDispalyTextTruncator(){
		$$("label[name='textItem']").each(function (label)    {
	        if ((label.innerHTML).length > 15)    {
	            label.update((label.innerHTML).truncate(15, "..."));
	        }
	    });
	    $$("label[name='textItem2']").each(function (label)    {
	        if ((label.innerHTML).length > 10)    {
	            label.update((label.innerHTML).truncate(10, "..."));
	        }
	    });
	    $$("label[name='textRate']").each(function (label)    {
	        if ((label.innerHTML).length > 10)    {
	            label.update((label.innerHTML).truncate(10, "..."));
	        }
	    });
	}

	function loadUnselectedItemRowProcedures(itemNo){
		if($("itemPerilMotherDiv"+itemNo) != null){			
			hidePerils();
		}
		
		buttonBehavior("Add");
		hideAllPerilDivs();
		hideItemPerilInfos();								
		setDefaultValues();
		setRecordListPerItem(false);
		subpagesTableListingBehavior(false);
		loadUnselectedItemRowOnPerilProcedures();
	}

	function loadSelectedItemRowProcedures(){		
		var row = selectedItemRow;
		var itemNo = $F("itemNo");
		
		supplyItemInfo(true, row, row.down("input", 1).value);				
		buttonBehavior("Update");
		setRecordListPerItem(true);
		subpagesTableListingBehavior(true);
		clearPopupFields();
		loadSelectedItemRowOnPerilProcedures(itemNo);
		//changeTag = 0;
	}

	function hidePerils(){
		$("itemPerilMotherDiv"+$F("itemNo")).hide();
		$("itemPerilMainDiv").hide();			
		$("perilTotalTsiAmt").value = formatCurrency(0);
		$("perilTotalPremAmt").value = formatCurrency(0);
	}
	
	$("btnCopyItemInfo").observe("click", confirmCopyItem);
	$("btnCopyItemPerilInfo").observe("click", confirmCopyItemPeril);
	$("btnRenumber").observe("click", confirmRenumber);	
	$("btnAssignDeductibles").observe("click", confirmAssignDeductibles);
	$("btnOtherDetails").observe("click", showOtherDetails);	
	
	checkTableItemInfo("itemTable","parItemTableContainer","rowItem");
	getRates();
	generateItemInfo();
	setDefaultValues();	

	/*********************additional functions for pack benefits***************/
	$("perilPackageCd").observe("change", function(){
		/*if(!(checkItemExists(getItemNumbersFromTableListing("rowItem", 1), $F("itemNo")))){
			$("perilPackageCd").selectedIndex = 0;
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}*/
		if (checkItemExists2($F("itemNo"))){
			$("perilPackageCd").selectedIndex = 0;
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}
		$("varVPackageSw").value = "Y";
		if ("" != $("perilPackageCd").value){
			if ("" != $F("vOldPlan")){
				showConfirmBox("Update Plan", "Updating the plan will overwrite existing plan.", "Ok", "Cancel", packageBen, ""); 
			} else {
				packageBen();
			}
		} else {
			$("vOldPlan").value = $("perilPackageCd").value;
			$("accidentPackBenCd").value = $("perilPackageCd").value;
		}
	});

	function packageBen(){
		var vExist = "N";
		
		if ("Y" == $F("varVPackageSw")){
			if (countPerilsForItem($F("itemNo")) > 0){
				vExist = "Y";
			}
		}

		if ("Y" == vExist){
			showConfirmBox("Information", "Inserting a new plan will overwrite existing perils for this item, would you like to continue?", "Yes", "No",
					packageBen1, 
					"");
		} else {
			packageBen2();
		}
	}

	function packageBen1(){
		deleteItemPerilsForItemNo($F("itemNo"));
		vAlert = 1;
		packageBen2();
	}

	function packageBen2(){
		//GIPI_WPOLBAS VALUES
		var vNoOfDays 			= computeNoOfDays($F("globalEffDate"), $F("globalExpiryDate"), "");
		var vPolProrateFlag 	= $F("globalProrateFlag");
		var vPolCompSw 			= $F("globalCompSw");
		var vPolShortRtPercent 	= parseFloat($F("globalShortRtPercent"));
		//GIPI_WITEM VALUES
		var vItemDays 			= computeNoOfDays($F("fromDate"), $F("toDate"), "");
		var vItemProrateFlag 	= $F("prorateFlag");
		var vItemCompSw 		= $F("compSw");
		var vItemShortRtPercent = parseFloat($F("shortRtPercent"));
		//
		var vTsiAmt				= 0.00;
		var vYear				= 0;
		var now 				= new Date();
		//var now 				= new Date();
		
		if (1 == vAlert){
			for (x=0; x<objBenDtlsListing.length; x++){
				if (objBenDtlsListing[x].packBenCd == $("perilPackageCd").value){
					vTsiAmt = nvl( objBenDtlsListing[x].benefit, 0.00)*(nvl( objBenDtlsListing[x].noOfDays, (nvl( vItemDays,  vNoOfDays))));
					vYear = now.getFullYear(); 
					if (("" != $F("fromDate")) && ("" != $F("toDate"))){
						if ("1" == vItemProrateFlag){
							if ("Y" == vItemCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)* vTsiAmt*(vItemDays+1)/checkDuration($F("fromDate"), $F("toDate"));
							} else if ("M" == vItemCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)* vTsiAmt*(vItemDays-1)/checkDuration($F("fromDate"), $F("toDate"));
							} else {
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)* vTsiAmt*(vItemDays)/checkDuration($F("fromDate"), $F("toDate"));
							}
						} else if ("2" == vItemProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)*vTsiAmt;
						} else if ("3" == vItemProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100)*vTsiAmt*nvl(vItemShortRtPercent, 0)/100;
						}
					} else {
						if ("1" == vPolProrateFlag){
							if ("Y" == vPolCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(vNoOfDays+1)/checkDuration($F("globalEffDate"), $F("globalExpiryDate"));
							} else if ("M" == vPolCompSw){
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(vNoOfDays-1)/checkDuration($F("globalEffDate"), $F("globalExpiryDate"));
							} else {
								vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(vNoOfDays)/checkDuration($F("globalEffDate"), $F("globalExpiryDate"));
							}
						} else if ("2" == vPolProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0);
						} else if ("3" == vPolProrateFlag){
							vPremAmt = (nvl(objBenDtlsListing[x].premPct, 0)/100) * nvl(vTsiAmt, 0)*(nvl(vPolShortRtPercent, 0))/100;
						}
					}
					
					//ADDING PERILS
					var objPeril 			= new Object();
					objPeril.parId 			= $F("globalParId");
					objPeril.itemNo 		= $F("itemNo");
					objPeril.lineCd 		= $F("globalLineCd");
					objPeril.perilCd 		= objBenDtlsListing[x].perilCd;
					objPeril.perilName 		= objBenDtlsListing[x].perilName;
					objPeril.perilType 		= objBenDtlsListing[x].perilType;
					objPeril.tarfCd 		= null;
					objPeril.premRt 		= 0.000000000;
					objPeril.tsiAmt 		= nvl(vTsiAmt, 0.00);
					objPeril.premAmt 		= nvl(objBenDtlsListing[x].premAmt, 0.00)
					objPeril.annTsiAmt 		= nvl(vTsiAmt, 0.00);
					objPeril.annPremAmt 	= nvl(objBenDtlsListing[x].premAmt, 0);
					objPeril.recFlag 		= null;
					objPeril.compRem 		= null;
					objPeril.discountSw 	= null;
					objPeril.prtFlag 		= null;
					objPeril.riCommRate 	= null;
					objPeril.riCommAmt 		= null;
					objPeril.asChargeSw 	= null;
					objPeril.surchargeSw 	= null;
					objPeril.noOfDays 		= nvl(nvl(objBenDtlsListing[x].noOfDays, nvl(vItemDays, vNoOfDays)), 0);
					objPeril.baseAmt 		= nvl(objBenDtlsListing[x].benefit, 0);
					objPeril.aggregateSw 	= null;
					objPeril.bascPerlCd 	= null;

					addObjToPerilTable(objPeril);
					addNewPerilObject(objPeril);
					
					/*var itemNoOfPeril = $F("itemNo");
					var lineCd = $F("globalLineCd");
					var perilCd = objBenDtlsListing[x].perilCd;
					var perilName = objBenDtlsListing[x].perilName;
					var perilRate = formatToNineDecimal(0);
					var tsiAmt = formatCurrency(nvl(vTsiAmt, 0));
					var premAmt = formatCurrency(nvl(objBenDtlsListing[x].premAmt, 0));
					var compRem = "---";
					var perilType = objBenDtlsListing[x].perilType;
					var wcSw = "N";
					var tarfCd = "";
					var annTsiAmt = formatCurrency(nvl(vTsiAmt, 0));
					var annPremAmt = formatCurrency(nvl(objBenDtlsListing[x].premAmt, 0));
					var prtFlag = "";
					var riCommRate = "";
					var riCommAmt = "";
					var surchargeSw = "";
					var baseAmt = formatCurrency(nvl(objBenDtlsListing[x].benefit, 0));
					var aggregateSw = "";
					var discountSw = "";
					var bascPerlCd = "";
					var noOfDays = nvl(nvl(objBenDtlsListing[x].noOfDays, nvl(vItemDays, vNoOfDays)), 0);
					var labelContent = 	'<label name="text" style="width: 5%; text-align: right; margin-right: 5px;" labelName="itemNo">'+itemNoOfPeril+'</label>'+
									'<label name="text" style="width: 20%; text-align: left; margin-left: 5px;">'+perilName+'</label>'+
									'<label name="text" style="width: 15%; text-align: right;" class="moneyRate">'+perilRate+'</label>'+
									'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+tsiAmt+'</label>'+
									'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money";>'+premAmt+'</label>'+
									'<label name="text" style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>'+
									'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ '</label>';
					$("addItemNo").value = itemNoOfPeril;
					$("addPerilCd").value = perilCd;
					var itemPerilTable = $("itemPerilMainDiv"); //$("parItemPerilTable");
					var itemPerilMotherDiv = $("itemPerilMotherDiv"+itemNoOfPeril);
					var isNew = false;
					if (itemPerilMotherDiv == undefined)	{
						isNew = true;
						itemPerilMotherDiv = new Element("div");
						itemPerilMotherDiv.setAttribute("id", "itemPerilMotherDiv"+itemNoOfPeril);
						itemPerilMotherDiv.setAttribute("name", "itemPerilMotherDiv");
						itemPerilMotherDiv.addClassName("tableContainer");
					}
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "rowPeril"+itemNoOfPeril+perilCd);
					newDiv.setAttribute("name", "row2");
					newDiv.setAttribute("item", itemNoOfPeril);
					newDiv.setAttribute("peril", perilCd);
					newDiv.addClassName("tableRow");
					//newDiv.setStyle("display: none;");
					newDiv.update(labelContent +
						'<input type="hidden" name="perilItemNos"		value="'+itemNoOfPeril+'" />'+
						'<input type="hidden" name="perilLineCds"		value="'+lineCd+'" />'+
						'<input type="hidden" name="perilPerilNames" 	value="'+perilName+'" />'+
						'<input type="hidden" name="perilPerilCds" 		value="'+perilCd+'" />'+
						'<input type="hidden" name="perilPremRts" 		class="moneyRate" 	value="'+perilRate+'" />'+
						'<input type="hidden" name="perilTsiAmts" 		class="money" 		value="'+tsiAmt+'" />'+
						'<input type="hidden" name="perilPremAmts" 		class="money" 		value="'+premAmt+'" />'+
						'<input type="hidden" name="perilCompRems" 		value="'+compRem+'" />'+
						'<input type="hidden" name="perilPerilTypes"	value="'+perilType+'" />'+
						'<input type="hidden" name="perilWcSws"			value="'+wcSw+'" />'+
						'<input type="hidden" name="perilTarfCds" 		value="'+tarfCd+'" />'+
						'<input type="hidden" name="perilAnnTsiAmts" 	value="'+annTsiAmt+'" />'+
						'<input type="hidden" name="perilAnnPremAmts" 	value="'+annPremAmt+'" />'+
						'<input type="hidden" name="perilPrtFlags" 		value="'+prtFlag+'" />'+
						'<input type="hidden" name="perilRiCommRates" 	value="'+riCommRate+'" />'+
						'<input type="hidden" name="perilRiCommAmts" 	value="'+riCommAmt+'" />'+
						'<input type="hidden" name="perilSurchargeSws" 	value="'+surchargeSw+'" />'+
						'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
						'<input type="hidden" name="perilAggregateSws" 	value="'+aggregateSw+'" />'+
						'<input type="hidden" name="perilDiscountSws" 	value="'+discountSw+'" />'+
						'<input type="hidden" name="perilBascPerlCds" 	value="'+bascPerlCd+'" />'+
						'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
						'<input type="hidden" name="perilNoOfDayss" 	value="'+noOfDays+'" />');
					itemPerilMotherDiv.insert({bottom: newDiv});						
					if (isNew)	{							
						itemPerilTable.insert({bottom: itemPerilMotherDiv});
					}
					initializePerilRow(newDiv);
					$$("label[name='text']").each(function (label)	{
						if ((label.innerHTML).length > 15)    {
				            label.update((label.innerHTML).truncate(30, "..."));
				        }
					});
					Effect.Appear("rowPeril"+itemNoOfPeril+perilCd, {
						duration: .2,
						afterFinish: function () {
							clearItemPerilFields();
							$("dumPerilCd").value = "";								
							hideAllItemPerilOptions();
							selectItemPerilOptionsToShow();
							hideExistingItemPerilOptions();
							changeCheckImageColor();
							checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
							$("itemPerilMainDiv").show();
							$("itemPerilMotherDiv"+$F("itemNo")).show();
							getTotalAmounts();
						}
					});	*/							
					$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);		
				}
			}
		}
		$("vOldPlan").value = $("perilPackageCd").value;
		$("accidentPackBenCd").value = $("perilPackageCd").value;
		$("accidentPackBenCd").disable();
		
		/****update the item*****/
		var changes = changeTag;
		var parId			= $F("globalParId");
		var itemNo 			= $F("itemNo");
		var itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
		var itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
		var itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
		var currency		= $F("currency");
		var currencyText 	= $("currency").options[$("currency").selectedIndex].text;
		var rate 			= $F("rate");
		var coverage 		= $F("coverage");
		var coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
		var content			= "";
		content = 	'<label name="textItem" style="width: 5%; text-align: right; margin-right: 10px;" labelName="itemNo">'+itemNo+'</label>' +						
					'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemTitle+'">'+(itemTitle == "" ? "---" : itemTitle.truncate(15, "..."))+'</label>'+
					'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemDesc+'">'+(itemDesc == "" ? "---" : itemDesc.truncate(15, "..."))+'</label>' +
					'<label name="textItem" style="width: 20%; text-align: left;" title="'+itemDesc2+'">'+(itemDesc2 == "" ? "---" : itemDesc2.truncate(15, "..."))+'</label>' +
					'<label name="textItem2" style="width: 10%; text-align: left;" title="'+currencyText+'">'+currencyText.truncate(10, "...")+'</label>' +
					'<label name="textRate" style="width: 10%; text-align: right; margin-right: 10px;">'+formatToNineDecimal(rate)+'</label>' +
					'<label name="textItem" style="text-align: left;" title="'+coverageText+'">'+(coverageText == "" ? "---" :coverageText.truncate(15, "..."))+'</label>';
		if($F("btnAdd") == "Update"){						
			$("row"+itemNo).update(						
					generateAdditionalItems(false, null, $F("globalLineCd"), 0) + content);						
			//reset
			updateTempNumbers();								
			setDefaultValues();									
			buttonBehavior("Add");

			changes = 0;
			masterDetail = false;

			hideItemPerilInfos();
			//setRecordListPerItem(false);
			//checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
											
		} else{		
			var itemTable = $("parItemTableContainer");
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "row"+itemNo);
			newDiv.setAttribute("name", "rowItem");
			newDiv.setAttribute("item", itemNo);
			newDiv.addClassName("tableRow");
			//newDiv.setStyle("display : none");
			newDiv.update(						
				generateAdditionalItems(false, null, $F("globalLineCd"), 0) + content);		
			itemTable.insert({bottom : newDiv});
			//supplyItemInfo(false, null, newDiv.down("input", 1).value);					
			updateTempNumbers();
			setDefaultValues();
			//generateItemInfo();
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
					selectedItemRow = newDiv;
					preLoadSelectedItemRowProcedures();
					/*
					if(changeTag == 1){			
						showConfirmBox("Confirmation", "There are unsaved changes you have made. Do you want to cancel it?", "Yes", "No", loadSelectedItemRowProcedures, untoggleSelectedRow);			
					}else{
						preLoadSelectedItemRowProcedures();									
					}
					*/							
			});	
			//$("wItemParCount").value = parseInt($F("wItemParCount")) + 1;
			setCopyPerilButton();
			changes = 0;
			masterDetail = false;														
		}
		generateItemInfo();	
		checkTableItemInfo("itemTable","parItemTableContainer","rowItem");
		loadDispalyTextTruncator();
		
		showMessageBox("Plan successfully created.", imgMessage.SUCCESS);
	}
</script>