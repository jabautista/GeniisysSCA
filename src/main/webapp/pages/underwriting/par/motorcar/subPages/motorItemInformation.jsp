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
								</table>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Description</td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
							<!-- <input type="text" tabindex="3" style="width: 600px; padding: 2px;" id="itemDesc" name="itemDesc" maxlength="2000" />  -->
								<div style="width: 604px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 575px; height: 13px; float: left; border: none;" id="itemDesc" name="itemDesc"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned"></td>
							<td class="leftAligned" colspan="4" style="width: 551px;">
							<!-- <input type="text" tabindex="4" style="width: 600px; padding: 2px;" id="itemDesc2" name="itemDesc2" maxlength="2000" />  -->
								<div style="width: 604px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
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
								<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Coverage</td>
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
							<td class="rightAligned">Region</td>
							<td class="leftAligned">
								<select tabindex="9" id="region" name="region" class="required" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="region" items="${regions}">
										<option value="${region.regionCd}">${region.regionDesc}</option>				
									</c:forEach>
								</select>
							</td>							
							<td class="rightAligned">Motor Coverages</td>
							<td class="leftAligned">
								<select tabindex="10" id="motorCoverage" name="motorCoverage" style="width: 230px;">
									<option value=""></option>
									<c:forEach var="mcCoverage" items="${motorCoverages}">
										<option value="${mcCoverage.rvLowValue}">${mcCoverage.rvMeaning}</option>
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
												<span id="generateCocSerialNoSpan" style="display: inline-block;">
													<input type="checkbox" id="cocSerialSw" name="cocSerialSw" style="float: left;" />
													<label id="lblGenerateCOCSerialNo" for="generateCOCSerialNo" style="margin: auto;" > Generate COC Serial No. &nbsp;</label>
												</span>
												<span style="display: inline-block;">
													<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Surcharge &nbsp;</label>
												</span>
												<span style="display: inline-block;">
													<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" disabled="disabled" style="float: left;" />
													<label style="margin: auto;" > W/ Discount &nbsp;</label>
												</span>												
												<span style="display: inline-block;">
													<input type="checkbox" id="cgCtrlIncludeSw" name="cgCtrlIncludeSw" 	value="Y" style="float: left;" />
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
	
	/* @UCPBGEN */
	formMap = eval((('(' + '${formMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	// initialized values
	// Kailangan i-parse yung object para hindi sya magreference dun sa formMap :D	
	objGIPIWItem = JSON.parse(Object.toJSON(formMap.itemVehicles));
	objGIPIWPerilDiscount = JSON.parse(Object.toJSON(formMap.gipiWPerilDiscount));
	objMortgagees = JSON.parse(Object.toJSON(formMap.objGIPIWMortgagee));	
	objGIPIWMcAcc = JSON.parse(Object.toJSON(formMap.objGIPIWMcAccs));
	
	loadFormVariables(formMap.vars);
	loadFormParameters(formMap.pars);
	loadFormMiscVariables(formMap.misc);
	/* end */

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

	function continueValidation(){
		try{			
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
		    addParItem();

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
									showWaitingMessageBox(response.responseText, imgMessage.WARNING, setDefaultItemForm);									
								}		
							}
						} 
				});						
			}
		}catch(e){
			showErrorMessage("continueValidation", e);
			//showMessageBox("continueValidation : " + e.message);
		}		
	}

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
		
		if(itemTitle.blank() && !($F("motorNo").blank())){
			if(!($F("typeOfBody").blank()) || !($F("carCompany").blank()) || !($F("make").blank()) || !($F("engineSeries").blank())){
				$("itemTitle").value = ($F("modelYear") + " " + $F("carCompany") + " " +
					$F("make") + " " + $F("engineSeries") + " " + $("typeOfBody").options[$("typeOfBody").selectedIndex].text).trim();
			}else{
				customShowMessageBox("Please enter the item title first.", imgMessage.ERROR, "itemTitle");					
				return false;					
			}
		}
		
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
	}

	$("btnAddItem").observe("click", function(){
		if("${isPack}" == "Y" && $F("btnAddItem") == "Add"){ // added by andrew - 03.17.2011 - added to validate if package
			showConfirmBox("Confirmation", "You are not allowed to create items here. Create a new item in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
			return false;			
		}
		if($F("btnAddItem") == "Add" && objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N" && objFormMiscVariables.miscCopy == "N" ){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
					"Continue", "Cancel", function(){
				deleteDiscounts();
				addItem();
			},stopProcess); 
			return false;
		}else{
			addItem();
		}		
	});

	function deleteChildRecords(itemNo){
		$$("#accessoryTable div[item='" + itemNo + "']").each(function(row){
			if(row.hasClassName("selectedRow")){
				fireEvent(row, "click");
			}			

			Effect.Fade(row, {
				duration : .03,
				afterFinish : function(){
					if(objGIPIWMcAcc != null && (objGIPIWMcAcc.filter(getRecordsWithSameItemNo)).length > 0){
						var delObj = new Object();

						delObj.parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
						delObj.itemNo = itemNo;
						delObj.accessoryCd = row.getAttribute("accCd");

						addDelObjByAttr(objGIPIWMcAcc, delObj, "accessoryCd");

						delete Obj;
					}
						
					row.remove();
					checkIfToResizeTable2("accListing", "rowAcc");
					checkTableIfEmpty2("rowAcc", "accessoryTable");  
				}
			});
		});
	}

	function deleteItem(){
		parItemDeleteDiscount(false);
		deleteParItem();
		deleteFromMortgagees(itemNo);
		deleteChildRecords(itemNo);

		if(checkDeductibleType(objDeductibles, 1, "T") && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
			objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		}
	}

	function delRec(){
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