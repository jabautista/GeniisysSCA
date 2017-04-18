<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
		<input type="hidden" id="fromDate"			name="fromDate"			value="" />
		<input type="hidden" id="toDate"			name="toDate"			value="" />
		<input type="hidden" id="riskNo"			name="riskNo"			value="" />
		<input type="hidden" id="riskItemNo"		name="riskItemNo"		value="" />
		
		<table id="tableTest" width="100%">
			<tr>
				<td style="width: 920px;">
					<table cellspacing="0" border="0" style="margin-bottom: 0px; width: 895px;">					
						<tr>
							<td class="rightAligned" style="width: 100px;" for="itemNo">Item No. </td>
							<td class="leftAligned" colspan="3">
								<input type="text" tabindex="1001" style="width: 150px; padding: 2px; margin-right: 20px;" id="itemNo" name="itemNo" class="applyWholeNosRegExp required" regExpPatt="pDigit09" min="1" max="999999999" />
								Item Title 
								<input type="text" tabindex="1002" style="width: 350px; padding: 2px;" id="itemTitle" name="itemTitle" class="required allCaps" maxlength="50"/>
							</td>
							
							<!-- 
							<td class="rightAligned" style="width: 100px;">Item No. </td>
							<td class="leftAligned" style="width: 200px;"><input type="text" tabindex="1001" style="width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999" /></td>
							<td class="rightAligned" style="width: 120px;">Item Title </td>
							<td class="leftAligned"><input type="text" tabindex="1002" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" maxlength="50" class="required" /></td>
							 -->		
							
							<td rowspan="6">
								<table cellpadding="1" border="0" align="center" style="width: 150px;">
									<tr align="center"><td><input type="button" tabindex="1015" style="width: 100%;" id="btnCopyItemInfo" 		name="btnWItem" 			class="disabledButton" 	value="Copy Item Info" 			disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" tabindex="1016" style="width: 100%;" id="btnCopyItemPerilInfo" 	name="btnWItem" 			class="disabledButton" 	value="Copy Item/Peril Info" 	disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" tabindex="1017" style="width: 100%;" id="btnRenumber" 			name="btnWItemRenumber" 	class="button" 			value="Renumber" /></td></tr>						
									<tr align="center"><td><input type="button" tabindex="1018" style="width: 100%;" id="btnAssignDeductibles" 	name="btnWItem" 			class="disabledButton" 	value="Assign Deductibles" 		disabled="disabled" /></td></tr>						
									<tr align="center"><td><input type="button" tabindex="1019" style="width: 100%;" id="btnOtherDetails" 		name="btnWItem" 			class="disabledButton" 	value="Other Info" 				disabled="disabled" /></td></tr>
									<tr align="center"><td><input type="button" tabindex="1020" style="width: 100%;" id="btnAttachMedia" 		name="btnWItem" 			class="disabledButton" 	value="Attach Media" 			disabled="disabled" /></td></tr>									
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
								<select tabindex="1005" id="currency" name="currency" style="width: 220px;" class="required">
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
							<td class="leftAligned">
								<!-- 
								<input type="text" tabindex="1006" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
								 -->
								<input type="text" tabindex="1006" style="width: 224px; padding: 2px;" id="rate" name="rate" class="applyDecimalRegExp required" regExpPatt="pDeci0309" maxlength="13" value="" min="0.000000001" max="999.999999999" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Coverage</td>
							<td class="leftAligned" style="width: 120px;">
								<select tabindex="1007" id="coverage" name="coverage" style="width: 220px;" class="required">
									<!-- marco - 06.19.2014 - escape HTML tags -->
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
							<td class="rightAligned">Region</td>
							<td class="leftAligned">
								<select tabindex="1009" id="region" name="region" class="required" style="width: 220px;">
									<option value=""></option>
									<!-- marco - 06.19.2014 - escape HTML tags -->
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}" >${fn:escapeXml(region.regionDesc)}</option>
									</c:forEach>
								</select>
							</td>
							<c:choose>
								<c:when test="${displayMotorCoverage eq 'Y'}">
									<td class="rightAligned" style="width: 120px;">Motor Coverage</td>
									<td class="leftAligned">
										<select tabindex="1010" id="motorCoverage" name="motorCoverage" style="width: 230px;">
											<option value=""></option>
											<c:forEach var="mcCoverage" items="${motorCoverages}">
												<option value="${mcCoverage.rvLowValue}">${mcCoverage.rvMeaning}</option>
											</c:forEach>
										</select>
									</td>								
								</c:when>
								<c:otherwise>
									<td class="rightAligned" style="width: 120px;"></td>
									<td class="leftAligned">
										<select tabindex="1010" id="motorCoverage" name="motorCoverage" style="width: 230px; display: none;">
											<option value=""></option>
										</select>
									</td>
								</c:otherwise>
							</c:choose>								
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
												<span id="generateCocSerialNoSpan" style="display: inline-block;">
													<input tabindex="1011" type="checkbox" id="cocSerialSw" name="cocSerialSw" style="float: left;" />
													<label id="lblGenerateCOCSerialNo" for="generateCOCSerialNo" style="margin: auto;" > Generate COC Serial No. &nbsp;</label>
												</span>
												<span style="display: inline-block;">
													<input tabindex="1012" type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Surcharge &nbsp;</label>
												</span>
												<span style="display: inline-block;">
													<input tabindex="1013" type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Discount &nbsp;</label>
												</span>												
												<span style="display: inline-block;">
													<input tabindex="1014" type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" style="float: left;" />
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
	<jsp:include page="/pages/underwriting/parTableGrid/motorcar/subPages/motorItemInfoAdditional.jsp"></jsp:include>
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
	
	/* @UCPBGEN */
	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	// initialized values
	// Kailangan i-parse yung object para hindi sya magreference dun sa formMap :D	
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));	
	
	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
	/* end */	

	function continueValidation(){
		try{
			function proceed(){
				updateTGPager(tbgItemTable);			
				//$("btnSave").click();
				if(!(hasPendingChildRecords()) && objGIPIWItemPeril.length < 1){
					validateSaving(true);
				}
			}
			
			if(!(itemNo.blank()) && !(itemTitle.blank())){														
				if($F("assignee").blank()){
					$("cocType").value = objGIPIWPolbas.sublineCd == objFormVariables.varSublineLto ? objFormVariables.varCocLto : objFormVariables.varCocNlto;	
				}									
				$("cocYy").value = $F("cocYy").blank() ? (objUWGlobal.packParId != null ? objCurrPackPar.parYy : $F("globalParYy")) : $F("cocYy");						
			}
			
			if(region.blank() && !(itemTitle.blank())){
				customShowMessageBox("Region code must be entered.", imgMessage.ERROR, "region");
				stop = true;
				return false;				
			}

			// pre-commit on forms
			if(objFormVariables.varPost == null){
				if($F("makeCd") != "" && $F("carCompany") == ""){						
					showMessageBox("Car Company is required if make is entered.", imgMessage.INFO); /* I */
					stop = true;
					return false;					
				} else if($F("engineSeries") != "" && $F("makeCd") == ""){						
					showMessageBox("Make is required if engine series is entered.", imgMessage.INFO); /* I */					
					stop = true;
					return false;					
				}
			}				
			
			if((objUWGlobal.packParId != null ? objCurrPackPar.parStatus : $F("globalParStatus")) < 3){
				showMessageBox("You are not granted access to this form. The changes that you have made " +
						"will not be committed to the database.", imgMessage.ERROR);				
				stop = true;
				return false;
			}			
			
			if($F("btnAddItem") == "Add" && "N" == objFormMiscVariables.miscDeletePerilDiscById) {
				parItemDeleteDiscount(false);
			}	
					
			objFormVariables.varInsertDeleteSw = "Y";
			objFormMiscVariables.miscNbtInvoiceSw = "Y";
			addParItemTG();

			if(objFormMiscVariables.miscCopy == "Y"){
				updateObjCopyToInsert(objDeductibles, itemNo);	
				updateObjCopyToInsert(objMortgagees, itemNo);
				updateObjCopyToInsert(objGIPIWMcAcc, itemNo);
				updateObjCopyToInsert(objGIPIWItemPeril, itemNo);
				objFormMiscVariables.miscCopy = "N";
			}
			
			//setDefaultItemForm();

			if(objFormParameters.paramOtherSw != "Y"){				
				var objParameters = {
					setItemRows : prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGIPIWItem)),
					delItemRows	: prepareJsonAsParameter(getDeletedJSONObjects(objGIPIWItem)),
					misc		: prepareJsonAsParameter(objFormMiscVariables),
					gipiWPolbas	: prepareJsonAsParameter(objGIPIWPolbas)
				};				
				
				new Ajax.Request(contextPath + "/GIPIWVehicleController?action=validateOtherInfo2",{
					method : "POST",
					parameters : { parameters : JSON.stringify(objParameters)},												
					asynchronous : true,
					evalScripts : true,			
					onComplete : 
						function(response){							
							if (checkErrorOnResponse(response)) {
								if(response.responseText != 'Empty'){
									objFormParameters.paramOtherSw = "N";									
									showWaitingMessageBox(response.responseText, imgMessage.WARNING, function(){
										setDefaultItemForm();
										proceed();
									});									
								}else{
									setDefaultItemForm();
									proceed();							
								}	
							}
						} 
				});						
			}else{				
				proceed();
			}			
		}catch(e){
			showErrorMessage("continueValidation", e);			
		}		
	}

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
			
			if(itemTitle.blank() && !($F("motorNo").blank())){
				if(!($F("typeOfBody").blank()) || !($F("carCompany").blank()) || !($F("make").blank()) || !($F("engineSeries").blank())){
					// added substr by robert 09.13.2013 since max length of item_title is 50
					$("itemTitle").value = ($F("modelYear") + " " + $F("carCompany") + " " +
						$F("make") + " " + $F("engineSeries") + " " + $("typeOfBody").options[$("typeOfBody").selectedIndex].text).trim().substr(0,50);
				}else{
					//customShowMessageBox("Please enter the item title first.", imgMessage.ERROR, "itemTitle");
					customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "itemTitle");
					return false;					
				}
			}
			//added by robert SR 20485 10.28.15
			if($F("serialNo").trim().empty()) {
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "serialNo");
				return false;
			}else if($F("motorNo").trim().empty()) {
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "motorNo");
				return false;
			}
			//end robert SR 20485 10.28.15
			if(isParItemInfoValid()){
				// key-commit on forms
				if($F("cocSerialNo") != ""){
					new Ajax.Request(contextPath + "/GIPIWVehicleController?action=checkCOCSerialNoInPolicyAndPar",{
						method : "GET",
						parameters : {
							parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")),
							itemNo : $F("itemNo"),
							cocSerialNo : $F("cocSerialNo"),
							cocType : $F("cocType")
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
										stop = false;
										stopProcess();
									}else{										
										continueValidation();										
										if(stop){
											stopProcess();
										}
									}								
								}				
							} 
					});	
				}else{
					continueValidation();
					if(stop){
						stopProcess();
					}
				}											
			}else{
				return false;
			}
		}catch(e){
			showErrorMessage("addItem", e);
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