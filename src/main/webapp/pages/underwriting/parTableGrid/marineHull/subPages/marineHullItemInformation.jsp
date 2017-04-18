<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-Control", "No-Cache");
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
	
	<input type="hidden" id="pageName"			name="pageName"			value="itemInformation" />
	<input type="hidden" id="userId"			name="userId" 			value="${USER.userId}" />
	<input type="hidden" id="dateFormatted"		name="dateFormatted"	value="N" />
	
	<!-- GIPI_WITEM remaining fields -->
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
	<input type="hidden"	id="coverage"			name="coverage"			value="" />	
		
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
							<td class="leftAligned" style="width: 220px;"><input type="text" tabindex="1002" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" maxlength="50" class="required" /></td>
							 -->
						<td rowspan="6">
							<table cellpadding="1" border="0" align="center" style="width: 150px;">
								<tr align="center"><td><input type="button" tabindex="1012" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
								<tr align="center"><td><input type="button" tabindex="1013" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
								<tr align="center"><td><input type="button" tabindex="1014" style="width: 100%;" id="btnRenumber" 			name="btnWItemRenumber" 	class="button" 			value="Renumber" /></td></tr>						
								<tr align="center"><td><input type="button" tabindex="1015" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
								<tr align="center"><td><input type="button" tabindex="1016" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Info" 				disabled="disabled" /></td></tr>
								<tr align="center"><td><input type="button" tabindex="1017" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>									
							</table>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 100px;">Description</td>
						<td class="leftAligned" colspan="4" style="width: 551px;">						
							<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
								<textarea tabindex="1003" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none;" id="itemDesc" name="itemDesc"/></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 100px;"></td>
						<td class="leftAligned" colspan="4" style="width: 551px;">						
							<div style="width: 593px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
								<textarea tabindex="1004" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 565px; height: 13px; float: left; border: none;" id="itemDesc2" name="itemDesc2"></textarea>
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
						<td class="rightAligned">Rate </td>
						<td class="leftAligned" style="width: 220px;">
							<input type="text" tabindex="1006" style="width: 224px; padding: 2px;" id="rate" name="rate" class="applyDecimalRegExp required" regExpPatt="pDeci0309" maxlength="13" value="" min="0.000000001" max="999.999999999" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 100px;">Group</td>
						<td class="leftAligned" style="width: 220px;">
							<select tabindex="1007" id="groupCd" name="groupCd" style="width: 230px;">
								<option value=""></option>
								<c:forEach var="group" items="${groups}">
									<option value="${group.groupCd}">${group.groupDesc}</option>				
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width: 100px;">Region</td>
						<td class="leftAligned">
							<select tabindex="1008" id="region" name="region" class="required" style="width: 230px;">
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
									<td class="rightAligned">
										<div style="text-align : center;">												
											<span style="display: inline-block;">
												<input tabindex="1009" type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" tabindex="12" disabled="disabled" style="float: left;" />
												<label style="margin: auto;" > W/ Surcharge &nbsp;</label>
											</span>
											<span style="display: inline-block;">
												<input tabindex="1010" type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" tabindex="13" disabled="disabled" style="float: left;" />
												<label style="margin: auto;" > W/ Discount &nbsp;</label>
											</span>												
											<span style="display: inline-block;">
												<input tabindex="1011" type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" tabindex="14" style="float: left;" />
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
	<jsp:include page="/pages/underwriting/parTableGrid/marineHull/subPages/marineHullItemInfoAdditional.jsp"></jsp:include>
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
	var region			= "";
	var regionText		= "";
	var stop 			= false;
	
	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));	
	
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));	

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
		region			= $F("region");
		regionText		= $("region").options[$("region").selectedIndex].text;
		vessel			= $F("vesselCd");
		geogLimit		= $F("geogLimit");

		if(isParItemInfoValid()){
			if(!(itemTitle.blank()) && vessel.blank()){
				customShowMessageBox("Please enter the necessary vessel information for Item No. "+itemNo+".",
						imgMessage.INFO, "vesselCd");
				return false;
			} else if (geogLimit.blank()) {
				//customShowMessageBox("Please complete additional information for Item No. " + itemNo + " before saving. ", 
				//		imgMessage.INFO, "geogLimit");				
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "geogLimit");
				return false;
			}
			
			if($F("btnAddItem") == "Add" && "N" == objFormMiscVariables.miscDeletePerilDiscById) {
				parItemDeleteDiscount(false);
			}

			objFormMiscVariables.miscNbtInvoiceSw = "Y";
			addParItemTG();

			if(objFormMiscVariables.miscCopy == "Y"){
				updateObjCopyToInsert(objDeductibles, itemNo);	
				updateObjCopyToInsert(objGIPIWItemPeril, itemNo);
				objFormMiscVariables.miscCopy = "N";
			}

			/*if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
				objFormMiscVariables.miscDeletePerilDiscById = "Y";
			}*/ //belle 03312011
			
			updateTGPager(tbgItemTable);			
			
			if(!(hasPendingChildRecords()) && objGIPIWItemPeril.length < 1){
				validateSaving(true);
			}
		}else{			
			return false;
		}
	}
	
	observeItemButtons();
	observeItemCommonElements();
	observeAddItemButton(addItem);
	observeDeleteItemButton();
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Page", e);
}
</script>