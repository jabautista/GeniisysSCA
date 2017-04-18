<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<script type="text/javascript">
	clearAllItemRelatedObjects();
	lastAction = null;
</script>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="itemInformationDiv">
	<jsp:include page="/pages/underwriting/parTableGrid/common/itemInfoTableGridListing.jsp"></jsp:include>
	<div style="margin: 10px;" id="parItemForm" changeTagAttr="true"> <!-- added changeTagAttr="true" by steven 8.22.2012 -->
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
							<td class="rightAligned" style="width: 100px;" for="itemNo">Item No. </td>
							<td class="leftAligned" style="width: 200px;" colspan="3">
								<input type="text" tabindex="1001" style="width: 150px; padding: 2px; margin-right: 20px;" id="itemNo" name="itemNo" class="applyWholeNosRegExp required" regExpPatt="pDigit09" min="1" max="999999999" />
								Item Title 
								<input type="text" tabindex="1002" style="width: 350px; padding: 2px;" id="itemTitle" name="itemTitle" class="required allCaps" maxlength="50"/>
							</td>
							
							<!-- 
							<td class="rightAligned" style="width: 100px;">Item No. </td>
							<td class="leftAligned" style="width: 200px;"><input type="text" tabindex="1001" style="width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999" /></td>
							<td class="rightAligned" style="width: 100px;">Item Title </td>
							<td class="leftAligned" style="width: 220px;"><input type="text" tabindex="1002" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" maxlength="50" class="required"/></td>
							 -->	
							
							<td rowspan="6">
								<table cellpadding="1" border="0" align="center" style="width: 150px;">
									<tr align="center"><td><input type="button" tabindex="1022" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" tabindex="1023" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" tabindex="1024" style="width: 100%;" id="btnRenumber" 			name="btnWItemRenumber" 	class="button" 			value="Renumber" /></td></tr>						
									<tr align="center"><td><input type="button" tabindex="1025" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
									<tr align="center"><td><input type="button" tabindex="1026" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Info" 				disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" tabindex="1027" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>									
								</table>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Description</td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
								<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="1003" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none; resize: none;" id="itemDesc" name="itemDesc"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;"></td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
								<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="1004" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none; resize: none;" id="itemDesc2" name="itemDesc2"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc2" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Currency </td>
							<td class="leftAligned">
								<select tabindex="1005" id="currency" name="currency" style="width: 230px;" class="required">
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
							<td class="rightAligned" for="rate">Rate </td>
							<td class="leftAligned" style="width: 220px;">
								<!-- 
								<input type="text" tabindex="1006" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
								 -->
								<input type="text" tabindex="1006" style="width: 224px; padding: 2px;" id="rate" name="rate" class="applyDecimalRegExp required" regExpPatt="pDeci0309" maxlength="13" value="" min="0.000000001" max="999.999999999" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Coverage </td>
							<td class="leftAligned" style="width: 220px;">
								<select tabindex="1007" id="coverage" name="coverage" style="width: 230px;" class="">
									<option value=""></option>					
									<c:forEach var="coverage" items="${coverages}">
										<option value="${coverage.code}"
										<c:if test="${item.coverageCd == coverage.code}">
											selected="selected"
										</c:if>>${fn:escapeXml(coverage.desc)}</option>				
									</c:forEach>
								</select>
							</td>
							<td class="rightAligned">Group </td>
							<td class="leftAligned">
								<select tabindex="1008" id="groupCd" name="groupCd" style="width: 230px;">
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
						    		<input tabindex="1009" style="width: 124px; border: none;" id="fromDate" name="fromDate" type="text" value="" readonly="readonly"/>
						    		<img id="hrefAccidentFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fromDate'),this, null);" alt="From Date" class="hover" />
								</div>
								<div style="float:left; border: solid 1px gray; width: 150px; height: 21px; margin-right:3px;">
						    		<input tabindex="1010" style="width: 124px; border: none;" id="toDate" name="toDate" type="text" value="" readonly="readonly"/>
						    		<img id="hrefAccidentToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);" alt="To Date" class="hover" />
								</div>
								<div style="float:left; width: 150px; margin: none;">
									<input tabindex="1011" class="rightAligned" type="text" id="accidentDaysOfTravel" name="accidentDaysOfTravel" value="" style="width: 100px; height: 15px; margin-top : 0px;" disabled="disabled"> days
								</div>								
							</td>
						</tr>						
						<tr>
							<td class="rightAligned" style="width: 100px;">Plan </td>
							<td class="leftAligned" style="width: 220px;">
								<select tabindex="1012" id="accidentPackBenCd" name="accidentPackBenCd" style="width: 230px;">
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
							<td class="leftAligned" style="width: 220px;">
								<select tabindex="1013" id="accidentPaytTerms" name="accidentPaytTerms" style="width: 230px;">
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
							<td class="rightAligned" style="width: 100px;">Region</td>
							<td class="leftAligned"  style="width: 220px;">
								<select tabindex="1014" id="region" name="region" class="required" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}">${region.regionDesc}</option>				
									</c:forEach>
								</select>
							</td>							
							<td class="rightAligned">Condition</td>
							<td class="leftAligned">
								<input type="hidden" id="accidentCondition" name="accidentCondition" />
								<input type="hidden" id="paramAccidentProrateFlag" name="paramAccidentProrateFlag" value="" />
								<select tabindex="1015" id="accidentProrateFlag" name="accidentProrateFlag" style="width:230px;" class="required">
										<option value="1">Prorate</option>
										<option value="2">Straight</option>
										<option value="3">Short Rate</option>
								</select>
							</td>
							<td class="leftAligned">	
								<span id="prorateSelectedAccident" name="prorateSelectedAccident" style="display: none; margin-left: 3px;">
									<input type="hidden" style="width: 45px;" id="paramAccidentNoOfDays" name="paramAccidentNoOfDays" value="" />
									<!-- 
									<input tabindex="1016" class="required integerUnformattedOnBlur" type="text" style="width: 45px;" id="accidentNoOfDays" name="accidentNoOfDays" value="" maxlength="3" min="0" max="999" errorMsg="Entered pro-rate number of days is invalid. Valid value is from 0 to 999." />
									 -->
									<input tabindex="1016" class="required applyWholeNosRegExp" regExpPatt="pDigit03" type="text" style="width: 45px;" id="accidentNoOfDays" name="accidentNoOfDays" value="" maxlength="3" min="0" max="999" hasOwnBlur="Y" hasOwnKeyUp="Y" hasOwnChange="Y" /> 
									<select tabindex="1017" class="required" id="accidentCompSw" name="accidentCompSw" style="width: 80px;" >
										<option value="Y" >+1 day</option>
										<option value="M" >-1 day</option>
										<option value="N" >Ordinary</option>
									</select>
								</span>
								<span id="shortRateSelectedAccident" name="shortRateSelectedAccident" style="display: none;">
								    <input type="hidden" id="paramAccidentShortRatePercent" name="paramAccidentShortRatePercent" class="moneyRate" style="width: 90px;" maxlength="13" value="" />
								    <!-- 
								    <input tabindex="1018" type="text" id="accidentShortRatePercent" name="accidentShortRatePercent" class="moneyRate2 required" style="width: 90px;" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Short Rate Percent. Value should be from 0.000000001 to 999.999999999."/>
								     -->
									<input tabindex="1018" type="text" id="accidentShortRatePercent" name="accidentShortRatePercent" class="applyDecimalRegExp required" regExpPatt="pDeci0309" style="width: 90px;" maxlength="13" value="" min="0.000000001" max="100" hasOwnKeyUp="Y" hasOwnBlur="Y" hasOwnChange="Y" />
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
													<input tabindex="1019" type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" tabindex="12" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Surcharge </label>
												</span>
												<span style="display: inline-block; margin-left: 5px;">
													<input tabindex="1020" type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" tabindex="13" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Discount </label>
												</span>												
												<span style="display: inline-block; margin-left: 5px;">
													<input tabindex="1021" type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" tabindex="14" style="float: left;" />
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
	<jsp:include page="/pages/underwriting/parTableGrid/accident/subPages/accidentItemInfoAdditional.jsp"></jsp:include>
</div>
<script type="text/javascript">
try{
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
	var prorateFlagText = "";

	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	// initialized values
	// Kailangan i-parse yung object para hindi sya magreference dun sa formMap :D	
	
	objGIPIWPolbas = JSON.parse(Object.toJSON(formMap.gipiWPolbas));	
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));	

	formatGIPIWPolbasDateColumns();

	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
	
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
		
		function proceed(){			
			if($F("btnAddItem") == "Add" && "N" == objFormMiscVariables.miscDeletePerilDiscById) {
				parItemDeleteDiscount(false);
			}
			
			objFormMiscVariables.miscNbtInvoiceSw = "Y";
			addParItemTG();

			if(objFormMiscVariables.miscCopy == "Y"){
				updateObjCopyToInsert(objDeductibles, itemNo);
				updateObjCopyToInsert(objGIPIWGroupedItems, itemNo);
				updateObjCopyToInsert(objBeneficiaries, itemNo);
				updateObjCopyToInsert(objGIPIWGroupedItems, itemNo);
				updateObjCopyToInsert(objGIPIWGrpItemsBeneficiary, itemNo);
				updateObjCopyToInsert(objGIPIWItemPeril, itemNo);		
				objFormMiscVariables.miscCopy = "N";
			}

			/*if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
				objFormMiscVariables.miscDeletePerilDiscById = "Y";
			}*/ //belle 03312011
			
			updateTGPager(tbgItemTable);			
			//$("btnSave").click();
			if(!(hasPendingChildRecords()) && objGIPIWItemPeril.length < 1){
				validateSaving(true);
			}
		}

		if(isParItemInfoValid()){
			if(!(itemTitle.blank()) && $F("noOfPerson").blank()){
				customShowMessageBox("Please complete the additional accident information before proceeding to another item.",
						imgMessage.INFO, "noOfPerson");
				return false;
			}
			
			//proceed();
			if($F("accidentProrateFlag") == 3 && $F("accidentShortRatePercent").trim() == ""){ // added this validation by andrew - 02.07.2012
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, function(){
					$("accidentShortRatePercent").focus();
				});
			} else if ($F("accidentProrateFlag") == 1 && $F("accidentNoOfDays").trim() == ""){ // added this validation by andrew - 02.07.2012
				showWaitingMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, function(){
					$("accidentNoOfDays").focus();
				});
			} else {
				if((nvl(objFormVariables.varVOldNoOfDays, 0) != nvl($F("accidentNoOfDays"), 0)) && $F("accidentProrateFlag") == 1 &&
						(objFormVariables.varVOldNoOfDays != null || objFormVariables.varVOldNoOfDays != undefined)){
					if(objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length > 0){
						showConfirmBox("Confirmation", "You have updated policy's no . of days from " + objFormVariables.varVOldNoOfDays +
								" to " + $F("accidentNoOfDays") + ". Will now do the necessary changes.", "Ok", "Cancel",
								function(){ 
									objFormMiscVariables.miscDeleteBill = "Y";
									proceed();
								},
								function(){ 
									$("accidentNoOfDays").value = objFormVariables.varVOldNoOfDays;
									return false;
								});
					}else{
						proceed();
					}
				}else{				
					proceed();
				}
			}			
		}else{			
			return false;
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
	
	function setDaysTravel(){		
		$("accidentDaysOfTravel").value = computeNoOfDays($F("fromDate"),$F("toDate"));
		$("accidentProrateFlag").enable();
		//if($F("accidentProrateFlag") == "1") {
		//	setNoOfDays();
		//}
	}
	
	observeChangeTagOnDate("hrefAccidentFromDate", "fromDate");
	observeChangeTagOnDate("hrefAccidentToDate", "toDate");
	
	$("fromDate").observe("blur", function(){
		var fromDt = $F("fromDate");
		var toDt = $F("toDate");
		
		//if(!(fromDt.blank()) && !(toDt.blank())){
			if(!(fromDt.blank())){				
				fromDt = makeDate(fromDt);
				toDt = makeDate(toDt);
				
				if(fromDt > toDt){
					$("fromDate").value = $("fromDate").getAttribute("lastValidValue");					
					customShowMessageBox("Start of Effectivity date should not be later than the end of Effectivity date.", imgMessage.INFO, "fromDate");
					return false;
				//}else if(fromDt < makeDate((objGIPIWPolbas.inceptDate).split(" ")[0])){ // andrew - 02.07.2012 - use the java formatted inceptDate attribute to avoid issues in js dateFormat function
				}else if(fromDt < makeDate((objGIPIWPolbas.formattedInceptDate).split(" ")[0])){
					$("fromDate").value = $("fromDate").getAttribute("lastValidValue");
					customShowMessageBox("Start of Effectivity date should not be earlier than the Policy Inception date.", imgMessage.INFO, "fromDate");
					return false;
				//}else if(fromDt > makeDate((objGIPIWPolbas.expiryDate).split(" ")[0])){
				}else if(fromDt > makeDate((objGIPIWPolbas.formattedExpiryDate).split(" ")[0])){
					$("fromDate").value = $("fromDate").getAttribute("lastValidValue");
					customShowMessageBox("Start of Effectivity date should not be later than the Policy Expiry date.", imgMessage.INFO, "fromDate");
					return false;
				}else{
					$("fromDate").setAttribute("lastValidValue", $F("fromDate"));	
					setDaysTravel();
					setNoOfDays();
				}
			}else{
				$("accidentNoOfDays").value = "";
			}
		//}else{
		//	$("accidentNoOfDays").value = "";
		//}
	});

	$("toDate").observe("blur", function(){
		var fromDt = $F("fromDate");
		var toDt = $F("toDate");
		
		//if(!(fromDt.blank()) && !(toDt.blank())){
			if(!(toDt.blank())){
				fromDt = makeDate(fromDt);
				toDt = makeDate(toDt);
				
				if(toDt < fromDt){
					$("toDate").value = $("toDate").getAttribute("lastValidValue");
					customShowMessageBox("End of Effectivity date should not be earlier than the Start of Effectivity date.", imgMessage.INFO, "toDate");
					return false;
				//}else if(toDt < makeDate((objGIPIWPolbas.inceptDate).split(" ")[0])){
				}else if(toDt < makeDate((objGIPIWPolbas.formattedInceptDate).split(" ")[0])){
					$("toDate").value = $("toDate").getAttribute("lastValidValue");
					customShowMessageBox("End of Effectivity date should not be earlier than the Policy Inception date.", imgMessage.INFO, "toDate");
					return false;
				//}else if(toDt > makeDate((objGIPIWPolbas.expiryDate).split(" ")[0])){
				}else if(toDt > makeDate((objGIPIWPolbas.formattedExpiryDate).split(" ")[0])){
					$("toDate").value = $("toDate").getAttribute("lastValidValue");
					customShowMessageBox("End of Effectivity date should not be later than the Policy Expiry date.", imgMessage.INFO, "toDate");
					return false;
				}else{
					$("toDate").setAttribute("lastValidValue", $F("toDate"));
					setDaysTravel();
				}
			}else{
				$("accidentNoOfDays").value = "";
			}	
		//}else{
		//	$("accidentNoOfDays").value = "";
		//}	
	});	
	
	showACProrateSpan();
	
	$("accidentProrateFlag").observe("click", function(){
		prorateFlagText = getListTextValue("accidentProrateFlag");
	});
	
	$("accidentProrateFlag").observe("focus", function(){
		objFormVariables.varVOldProrateFlag = $F("accidentProrateFlag");
	});

	$("accidentProrateFlag").observe("change", function(){
		function onOkFuncDeleteBill(){
			objFormMiscVariables.miscDeleteBill = "Y";
			$("accidentDeleteBill").value = "Y";
			showACProrateSpan();
		}

		var itemNum;
		
		function onCancelFuncDeleteBill(){			
			//$$("div#itemTable div[name='rowItem']").each(function(row){
			//	if (row.hasClassName("selectedRow")){
			//		var itemNum = row.down("label", 0).innerHTML;
			//		//$("accidentProrateFlag").value = objGIPIWItem.prorateFlag;
			//		//$("accidentCompSw").value = objGIPIWItem.compSw;
			//		//$("accidentShortRatePercent").value = objGIPIWItem.shortRtPercent;
			//	}	
			//	showACProrateSpan();
			//});
			$("accidentProrateFlag").value = objFormVariables.varVOldProrateFlag;
			showACProrateSpan();
		}
		
		if ($F("itemWitmperlExist") == "Y"){
			if ($F("accidentDeleteBill") != "Y"){
				showConfirmBox("Message", "You have changed your item term from " +prorateFlagText +" to "+ getListTextValue("accidentProrateFlag")+ ". Will now do the necessary changes.",  
						"Ok", "Cancel", onOkFuncDeleteBill, onCancelFuncDeleteBill);
			}else{
				showACProrateSpan();
			}
		}else{
			showACProrateSpan();
		}		
	});
	
	$("accidentCompSw").observe("change", function(){
		var compSw = $F("accidentCompSw");
		
		function proceed(){
			var prorateDays = computeNoOfDays($F("fromDate"),$F("toDate"));			
			
			switch(compSw){
				case "Y"	: prorateDays = prorateDays + 1; break;
				case "M"	: prorateDays = prorateDays - 1; break;
				//default		: break;
			}
			
			$("accidentNoOfDays").value = prorateDays;
			$("accidentNoOfDays").focus();
			//setNoOfDays();
		}
		
		if(objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length > 0){
			if(objCurrItem.compSw != compSw){
				showConfirmBox("Message", "You have changed the computation for the item no of days. Will now do the necessary changes.", "Ok", "Cancel", 
						function(){ 
							objFormMiscVariables.miscDeleteBill = "Y";
							proceed();
						},
						function(){ 
							$("accidentCompSw").value = objCurrItem.compSw;
							$("accidentNoOfDays").value = computeNoOfDays($F("fromDate"),$F("toDate"));
							return false;
						});
			}else{
				proceed();
			}
		}else{
			proceed();
		}
	});
	
	$("accidentNoOfDays").observe("focus", function(){
		objFormVariables.varVOldNoOfDays = $F("accidentNoOfDays");
	});
	
	$("accidentNoOfDays").observe("keyup", function(e){
		var m = $("accidentNoOfDays");
		var pattern = m.getAttribute("regExpPatt");
		
		if(pattern.substr(0,1) == "p"){			
			if(m.value.include("-")){
				m.setAttribute("executeOnBlur", "N");
				showWaitingMessageBox("Invalid Prorate number of days. Valid value is from 0 to 999.", imgMessage.ERROR, function(){					
					m.value = m.getAttribute("lastValidValue");
					m.focus();
				});
				return false;
			}else{
				m.setAttribute("executeOnBlur", "Y");
				m.value = (m.value).match(RegExWholeNumber[pattern])[0];
			}		 
		}else{
			m.setAttribute("executeOnBlur", "Y");
			m.value = (m.value).match(RegExWholeNumber[pattern])[0];
		}			   						
	});
	
	function validateAccidentNoOfDays(){
		try{
			var fromDate = $F("fromDate");
			var prorateFlag = $F("accidentProrateFlag");
			var prorateDays = $F("accidentNoOfDays");
			
			function proceed(){
				if(!(fromDate.empty()) && prorateFlag == 1 && !(prorateDays.empty())){
					var dateArr = fromDate.split("-");
					var dt = new Date(dateArr[2], (dateArr[0] - 1), dateArr[1]);				
					var travelDays = parseInt($F("accidentNoOfDays"));				
					
					switch($F("accidentCompSw")){
						case "Y"	: travelDays = travelDays - 1; break;
						case "M"	: travelDays = travelDays + 1; break;
						//default		: break;
					}				
					//$("accidentDaysOfTravel").value = travelDays;
					$("toDate").value = dateFormat(dt.setDate(dt.getDate() + parseInt(travelDays)), "mm-dd-yyyy");				
				}
				
				$("accidentNoOfDays").setAttribute("lastValidValue", $("accidentNoOfDays").value);
			}
			
			if($("accidentNoOfDays").getAttribute("executeOnBlur") != "N"){
				if(nvl(objFormVariables.varVOldNoOfDays, 0) != nvl($F("accidentNoOfDays"), 0) && prorateFlag == 1 && objFormVariables.varVOldNoOfDays != null){
					if(objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length > 0){
						showConfirmBox("Message", "You have updated policy's no . of days from " + objFormVariables.varVOldNoOfDays + 
								" to " + $F("accidentNoOfDays") + ". Will now do the necessary changes.", "Ok", "Cancel", 
								function(){ 
									objFormMiscVariables.miscDeleteBill = "Y";
									proceed();
								},
								function(){ 							
									$("accidentNoOfDays").value = objFormVariables.varVOldNoOfDays;
									return false;
								});
					}else{
						proceed();
					}			
				}
			}
		}catch(e){
			showErrorMessage("validateAccidentNoOfDays", e);
		}
	}
	
	$("accidentNoOfDays").observe("change", function(){		
		validateAccidentNoOfDays();							
	});
	
	$("accidentNoOfDays").observe("blur", function(){		
		validateAccidentNoOfDays();							
	});
	
	$("accidentShortRatePercent").observe("keyup", function(e){		
		var m = $("accidentShortRatePercent");		
		var pattern = m.getAttribute("regExpPatt"); 				
		
		if(pattern.substr(0,1) == "p"){
			if(m.value.include("-")){
				m.setAttribute("executeOnBlur", "N");
				showWaitingMessageBox("Invalid Short Rate Percent. Valid value is from 0.000000001 to 100.", imgMessage.ERROR, function(){
					m.value = m.getAttribute("lastValidValue");
					m.focus();
				});
				return false;
			}else{						
				m.value = (m.value).match(RegExDecimal[pattern])[0];
				m.setAttribute("executeOnBlur", "Y");
			}
		}else{					
			m.value = (m.value).match(RegExDecimal[pattern])[0];
			m.setAttribute("executeOnBlur", "Y");
		}					    						
	});
	
	function validateShortRatePercent(m){
		try{						
			if(!((m.value).empty())){
				if(isNaN(parseInt((m.value).replace(/,/g, "")))){
					m.value = "";
					customShowMessageBox("Invalid Short Rate Percent. Valid value is from 0.000000001 to 100.", imgMessage.ERROR, m.id);
				}else{
					if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
						customShowMessageBox("Invalid Short Rate Percent. Valid value is from 0.000000001 to 100.", imgMessage.ERROR, m.id);
						return false;
					}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
						customShowMessageBox("Invalid Short Rate Percent. Valid value is from 0.000000001 to 100.", imgMessage.ERROR, m.id);
						return false;
					}else{
						if(m.getAttribute("executeOnBlur") != "N"){
							var whle = parseInt(m.value.match(/(?:\d+)/)[0].length, 10);
							var dcml = parseInt(removeLeadingZero(m.getAttribute("regExpPatt").match(/[0-9]+/).toString().substr(2,2)), 10);
							var val = "";						
							
							val = removeLeadingZero((m.value).replace(/,/g, ""));
							val = val + (val.indexOf(".") == -1 ? "." : "");
							val = rpad(val, whle + dcml + 1, "0");					
							
							//m.value = addSeparatorToNumber2(val, ",");
							m.value = val;
							
							if(objGIPIWItemPeril.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length > 0){
								if((nvl(objCurrItem.shortRtPercent, 0) != nvl($F("accidentShortRatePercent"), 0)) && $F("accidentProrateFlag") == 3 &&
										(objCurrItem.shortRtPercent != null || objCurrItem.shortRtPercent != undefined)){
									showConfirmBox("Message", "You have updated short rate percent from " + nvl(objCurrItem.shortRtPercent, 0) + 
											"% to " + nvl($F("accidentShortRatePercent"), 0) + "%. Will now do the necessary changes.", "Ok", "Cancel", 
											function(){ 
												objFormMiscVariables.miscDeleteBill = "Y";							
											},
											function(){ 							
												$("accidentShortRatePercent").value = formatTo9DecimalNoParseFloat(nvl(objCurrItem.shortRtPercent, 0));
												return false;
											});
								}
							}
							
							$("accidentShortRatePercent").setAttribute("lastValidValue", $F("accidentShortRatePercent"));
						}						
					}
				}
			}			
		}catch(e){
			showErrorMessage("validateShortRatePercent", e);
		}
	}
	
	$("accidentShortRatePercent").observe("blur", function(){		
		validateShortRatePercent($("accidentShortRatePercent"));		
	});
	
	$("accidentShortRatePercent").observe("change", function(){		
		validateShortRatePercent($("accidentShortRatePercent"));		
	});
	
	$("accidentPackBenCd").observe("focus", function(){
		objFormVariables.vOldPackBenCd = $F("accidentPackBenCd");
	});
	
	$("accidentPackBenCd").observe("change", function(){
		if(objGIPIWGroupedItems.filter(function(o){ return nvl(o.recordStatus, 0) != -1 && o.itemNo == $F("itemNo"); }).length > 0){
			showConfirmBox("Confirmation", "There are existing grouped items and system will populate/overwrite perils on ALL grouped items." +
					" Would you like to automatically populate perils?", "Yes", "No",
						function(){
							objFormMiscVariables.miscPlanPopulateBenefits = "Y";
						},
						function(){
							$("accidentPackBenCd").value = objFormVariables.vOldPackBenCd;
						});
		}
	});
	
	observeItemButtons();
	observeItemCommonElements();
	observeAddItemButton(addItem);
	observeDeleteItemButton();
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Page", e);
}
</script>