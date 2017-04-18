<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
							<td class="leftAligned" style="width: 200px;"><input type="text" tabindex="1" style="width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999" /></td>
							<td class="rightAligned" style="width: 100px;">Item Title </td>
							<td class="leftAligned" style="width: 220px;"><input type="text" tabindex="2" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="50" /></td>
							 -->		
							
							<td rowspan="6">
								<table cellpadding="1" border="0" align="center" style="width: 150px;">
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnRenumber" 			name="btnWItemRenumber" 	class="button" 			value="Renumber" /></td></tr>						
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Info" 				disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>									
								</table>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Description</td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
								<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none; resize: none;" id="itemDesc" name="itemDesc"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;"></td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
								<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="4" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none; resize: none;" id="itemDesc2" name="itemDesc2"></textarea>
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
							<td class="rightAligned" for="rate">Rate </td>
							<td class="leftAligned" style="width: 220px;">
								<!-- 
								<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
								 -->								
								<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="applyDecimalRegExp required" regExpPatt="pDeci0309" maxlength="13" value="" min="0.000000001" max="999.999999999" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Coverage</td>
							<td class="leftAligned">
								<select tabindex="7" id="coverage" name="coverage" style="width: 230px;">
									<option value=""></option>						
									<!-- marco - 06.19.2014 - escape HTML tags -->
									<c:forEach var="coverage" items="${coverages}">
										<option value="${coverage.code}" >${fn:escapeXml(coverage.desc)}</option>
									</c:forEach>
								</select>
							</td>
							<td class="rightAligned" style="width: 100px;">Group </td>
							<td class="leftAligned" style="width: 220px;">
								<select tabindex="8" id="groupCd" name="groupCd" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="group" items="${groups}">
										<option value="${group.groupCd}">${group.groupDesc}</option>				
									</c:forEach>
								</select>
							</td>												
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Region</td>
							<td class="leftAligned">
								<select tabindex="9" id="region" name="region" class="required" style="width: 230px;">
									<option value=""></option>
									<!-- marco - 06.19.2014 - escape HTML tags -->
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}" >${fn:escapeXml(region.regionDesc)}</option>
									</c:forEach>
								</select>
							</td>							
							<td id="riskCell1" style="display: none;" class="rightAligned" for="riskNo">Risk No.</td>
							<td id="riskCell2" style="display: none;" class="leftAligned">								
								<table style="width: 230px;" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td class="leftAligned" style="padding-left: 0px; width: 40px;">
											<!-- 
											<input type="text" tabindex="10" style="width: 40px;" id="riskNo" name="riskNo" class="integerUnformattedOnBlur" maxlength="5" errorMsg="Invalid Risk No. Valid value should be from 1 to 99,999." min="1" max="99999" />
											 -->
											<input type="text" tabindex="10" style="width: 40px;" id="riskNo" name="riskNo" class="applyWholeNosRegExp" regExpPatt="pDigit05" maxlength="5" min="1" max="99999" />
										</td>
										<td class="rightAligned" for="riskItemNo">Risk Item No.</td>
										<td class="leftAligned" style="width: 70px;">
											<!-- 
											<input type="text" tabindex="11" style="width: 70px; padding: 2px;" id="riskItemNo" name="riskItemNo" class="integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Risk Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999"  />
											 -->
											<input type="text" tabindex="11" style="width: 70px; padding: 2px;" id="riskItemNo" name="riskItemNo" class="applyWholeNosRegExp" regExpPatt="pDigit09" maxlength="9" min="1" max="999999999"  />
										</td>										
									</tr>
								</table>								 
							</td>
						</tr>						
						<tr>
							<td colspan="4" style="width: 100%;" align="center">
								<table style="margin:auto; width:100%" border="0">
									<tr style="width: 100%;">
										<td>&nbsp;</td>
									</tr>
									<tr style="width: 100%;">
										<td class="rightAligned">
											<div style="text-align : center;">												
												<span style="display: inline-block;">
													<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" tabindex="12" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Surcharge &nbsp;</label>
												</span>
												<span style="display: inline-block;">
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
	<jsp:include page="/pages/underwriting/parTableGrid/fire/subPages/fireItemInfoAdditional.jsp"></jsp:include>
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
	
	/* UCPBGEN */
	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	// initialized values
	// Kailangan i-parse yung object para hindi sya magreference dun sa formMap :D	
	
	//objGIPIWItem = JSON.parse(Object.toJSON(formMap.itemFires));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	//objMortgagees = JSON.parse(Object.toJSON(formMap.objGIPIWMortgagee));
	
	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);	
	/* end */
	
	function addItem(){
		try{
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

			if(itemTitle.blank()){
				if($F("frItemType").empty()){
					//customShowMessageBox("Please enter the item title first.", imgMessage.ERROR, "itemTitle");					
					customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "itemTitle");
					return false;
				}else{
					$("itemTitle").value = $("frItemType").options[$("frItemType").selectedIndex].text;
				}
			}
			
			if('${requireLatLong}' == 'N') { //Added by Jerome 11.25.2016 SR 5749
				if($F("txtLatitude") == "" && $F("txtLongitude") != "") {
					showMessageBox("Please input latitude.","E");
					return false;
				}else if($F("txtLatitude") != "" && $F("txtLongitude") == ""){
					showMessageBox("Please input longitude.","E");
					return false;
				}
			}
			
			if(isParItemInfoValid()){
				var startDate = $F("fromDate");
				var endDate = $F("toDate");
				
				if(objFormParameters.paramParam4 == "Y" && $F("riskNo").empty()){
					customShowMessageBox("Required fields must be entered!!!!.", imgMessage.ERROR, "riskNo");
					return false;
				}else if(!(startDate.empty()) && endDate.empty()){
					customShowMessageBox("If start date is entered, end date is required.", imgMessage.WARNING, "toDate");				
					return false;
				}else if(!(endDate.empty()) && startDate.empty()){
					customShowMessageBox("If end date is entered, start date is required.", imgMessage.WARNING, "fromDate");				
					return false;
				}
				
				if($F("btnAddItem") == "Add" && "N" == objFormMiscVariables.miscDeletePerilDiscById) {
					parItemDeleteDiscount(false);
				}	
				
				var prevButtonText = $F("btnAddItem");
				
				objFormMiscVariables.miscNbtInvoiceSw = "Y";
				addParItemTG();
				
				if(objFormMiscVariables.miscCopy == "Y"){
					updateObjCopyToInsert(objDeductibles, itemNo);	
					updateObjCopyToInsert(objMortgagees, itemNo);
					updateObjCopyToInsert(objGIPIWItemPeril, itemNo);
					objFormMiscVariables.miscCopy = "N";
				}

				//saveFireItems(true);
				updateTGPager(tbgItemTable);
				
				if(prevButtonText == "Add")
					objUWGlobal.parItemPerilChangeTag = 1; //Apollo 09.11.2014
				
				//$("btnSave").click();
				if(!(hasPendingChildRecords()) && objGIPIWItemPeril.length < 1 && prevButtonText == "Add"){ //modified by Apollo Cruz 09.09.2014
					validateSaving(true);
				}
				/*if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
					objFormMiscVariables.miscDeletePerilDiscById = "Y";
				}*/ // belle 03312011
			}else{			
				return false;
			}
		}catch(e){
			showErrorMessage("addItem", e);
		}		
	}	
	
	$("region").observe("change", function(){		
		$("provinceCd").value 	= "";
		$("province").value		= "";
		$("cityCd").value 		= ""; 
		$("city").value 		= "";
		$("districtNo").value 	= "";
		$("district").value 	= "";
		$("blockId").value 		= "";
		$("block").value 		= "";
		$("riskCd").value		= "";
		$("risk").value			= "";		
	});	

	observeItemButtons();
	observeItemCommonElements();
	observeAddItemButton(addItem);
	observeDeleteItemButton();
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Page", e);
}	
</script>