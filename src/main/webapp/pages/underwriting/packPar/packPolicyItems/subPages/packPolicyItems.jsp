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
		<label>Package Policy Items</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="packPolicyItemsInfoDiv">
	<jsp:include page="/pages/underwriting/par/common/itemInformationListingTable.jsp"></jsp:include>
	
	<div style="margin : 10px;" id="packPolicyItemsForm">
		<input type="hidden" id="pageName"			name="pageName"			value="packagePolicyItems" />
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
		<input type="hidden" id="groupCd"			name="groupCd"			value="" />
		<input type="hidden" id="region"			name="region"			value="" />
		<input type="hidden" id="coverage"			name="coverage"			value="" />
		<input type="hidden" id="riskNo"			name="riskNo"			value="" />
		<input type="hidden" id="riskItemNo"		name="riskItemNo"		value="" />
		<input type="hidden" id="fromDate"			name="fromDate"			value="" />
		<input type="hidden" id="toDate"			name="toDate"			value="" />		
		
		<table width="100%">
			<tr>
				<td style="width: 920px;">
					<table cellspacing="0" border="0" style="margin-bottom: 0px; width: 895px;">					
						<tr>				
							<td class="rightAligned" style="width: 150px;">Item No. </td>
							<td class="leftAligned" style="width: 100px;"><input type="text" tabindex="1" style="width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999" readonly="readonly"/></td>
							<td class="rightAligned" style="width: 100px;">Item Title </td>							
							<td class="leftAligned" style="width: 280px;"><input type="text" tabindex="2" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" class="required" maxlength="50" /></td>
							<!-- 
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
							 -->
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;">Item Desc.</td>
							<td class="leftAligned" colspan="3">
								<div style="width: 618px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="3" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 592px; height: 13px; float: left; border: none;" id="itemDesc" name="itemDesc"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc" class="hover" />
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 100px;"></td>
							<td class="leftAligned" colspan="3">
								<div style="width: 618px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
									<textarea tabindex="4" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 592px; height: 13px; float: left; border: none;" id="itemDesc2" name="itemDesc2""></textarea>
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
								<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="nthDecimal required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
							</td>
						</tr>
						<tr>
							<td colspan="4" style="width: 100%;" align="center">
								<table style="margin:auto; width:100%" border="0">									
									<tr style="width: 100%;">
										<td class="rightAligned">
											<div style="text-align : center;">												
												<span style="display: inline-block;">
													<input type="checkbox" id="surchargeSw" 	name="surchargeSw" 		value="Y" tabindex="12" disabled="disabled" style="float: left; display: none;" />
													<label style="margin: auto; display: none;" > W/ Surcharge &nbsp;</label>
												</span>
												<span style="display: inline-block;">
													<input type="checkbox" id="discountSw" 		name="discountSw" 		value="Y" tabindex="13" disabled="disabled" style="float: left; display: none;" />
													<label style="margin: auto; display: none;" > W/ Discount &nbsp;</label>
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
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align: center;">
					<input type="button" id="btnAddItem" 	class="button" value="Add" />
					<input type="button" id="btnDeleteItem"	class="disabledButton" value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	objUWGlobal.hidGIPIS095PerilExist = "0"; //added by steven 12.10.2013
	var objPackLineSubline = JSON.parse(Object.toJSON(formMap.packLineSublineList));
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
	
	$("itemTitle").observe("keyup", function(){
		$("itemTitle").value = $F("itemTitle").toUpperCase();
	});

	$("editDesc").observe("click", function () {
		showOverlayEditor("itemDesc", 2000, $("itemDesc").hasAttribute("readonly"));
	});

	$("itemDesc").observe("keyup", function () {
		limitText(this, 2000);
	});

	$("editDesc2").observe("click", function () {
		showOverlayEditor("itemDesc2", 2000, $("itemDesc2").hasAttribute("readonly"));
	});

	$("itemDesc2").observe("keyup", function () {
		limitText(this, 2000);
	});
	
	//added by jeff04.29.2013 disable [rate] field when currency value = 1 (Philippine Peso)
	$("rate").observe("focus", function () {
		$("rate").readOnly = $("currency").value == 1 ? true : false;
		objUWGlobal.hidGIPIS095PerilExist != "0" ? $("rate").readOnly = true : $("rate").readOnly = false; //added by steven 10.18.2013
	});
	//------------------------
	
	$("currency").observe("change", function(){		
		if(!($F("currency").empty())){				
			/*
			if(objFormVariables.varOldCurrencyCd != $F("currency")){
				objFormVariables.varGroupSw = "Y";				
			}
			*/				
			getRates();
			$("rate").readOnly = $("currency").value == 1 ? true : false;
		}else{
			$("rate").value = "";
		}						
	});

	function addItem(){
		try{
			var mainRow = ($$("div#packageParPolicyTable .selectedRow"))[0];
			var newObj = setItemObj();
			var content = prepareEndtItemInfo(newObj);

			if($F("btnAddItem") == "Update"){			
				addModifiedJSONObject(objGIPIWItem, newObj);
				$("row" + newObj.itemNo).update(content);
				$("row" + newObj.itemNo).update(content).removeClassName("selectedRow");
			}else{
				newObj.recordStatus = 0;
				objGIPIWItem.push(newObj);				
				
				var newDiv = new Element("div");
				var itemTable = $("parItemTableContainer");
				
				newDiv.setAttribute("id", "row"+newObj.itemNo);
				newDiv.setAttribute("name", "row");
				newDiv.setAttribute("parId", newObj.parId);
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});

				//setItemRowObserver(newDiv); changed - irwin 11.14.11
				setPackagePolicyItemRowObserver(newDiv);

				objItemNoList.push({"itemNo" : newObj.itemNo});
				
				resizeTableBasedOnVisibleRows("itemTable", "parItemTableContainer");
				
				new Effect.Appear("row"+newObj.itemNo, {
					duration: 0.2
				});
			}

			//setMainItemForm(null); changed - irwin 11.21.11
			setMainPackagePolicyItemForm(null);
			$("packLineCd").value = mainRow.getAttribute("lineCd");					
			$("packSublineCd").value = mainRow.getAttribute("sublineCd");
			$("region").value = mainRow.getAttribute("regionCd");
			($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");			
		}catch(e){			
			showErrorMessage("addItem", e);
		}	
	}

	$("btnAddItem").observe("click", function(){
		if(($$("div#packageParPolicyTable .selectedRow")).length < 1){
			showMessageBox("Please select PAR first.", imgMessage.ERROR);
		}else{
			var row = ($$("div#packageParPolicyTable .selectedRow"))[0];
			var parId = row.getAttribute("parId");
			var lineCd = row.getAttribute("lineCd");
			var sublineCd = row.getAttribute("sublineCd");

			var objLineSublineList = objPackLineSubline.filter(function(obj){	return obj.parId == parId && obj.packLineCd == lineCd && obj.packSublineCd == sublineCd;	});

			if(objFormParameters.paramOra2010Sw == "Y" && nvl(objGIPIWPolbas.planSw, "N") == "Y" && $F("packLineCd") != "FI"){ //added by steven 10.17.2013 base on test case.
				if(objLineSublineList.length > 0){
					showMessageBox("This is a Package Plan Policy. Only one (1) item per Line/Subline is allowed.", imgMessage.INFO);
					return false;
				}				
			}
			
			itemNo 			= $F("itemNo");
			itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
			itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
			itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
			currency		= $F("currency");
			currencyText 	= $("currency").options[$("currency").selectedIndex].text;
			rate 			= $F("rate");
			//coverage 		= $F("coverage");
			//coverageText 	= $("coverage").options[$("coverage").selectedIndex].text;
			//region			= $F("region");
			//regionText		= $("region").options[$("region").selectedIndex].text;		

			if (checkAllRequiredFieldsInDiv("packPolicyItemsForm")) {
				if($F("btnAddItem") == "Add" && $("row" + $F("itemNo")) != undefined){
					customShowMessageBox("Item Number already exists.", imgMessage.ERROR, "itemNo");
					return false;		
// 				}else if($F("currency").blank() || "0.000000000" == $F("rate")){
// 					customShowMessageBox(objCommonMessage.REQUIRED, "I", "currency");
// 					return false;
				}else if($F("rate").match("-") || $F("rate").blank()) {
					customShowMessageBox("Invalid currency rate.", imgMessage.ERROR, "rate");
					return false;
				}
				addItem();
				objPackLineSubline.push({"parId" : parId, "itemNo" : itemNo, "packLineCd" : lineCd, "packSublineCd" : sublineCd, "recordStatus" : 0});
				objFormVariables.varSwitchInsert = "Y";	
				clearChangeAttribute("packPolicyItemsDiv");
			}
		}		
	});

	function delRecords(delObj){
		try{
			var blnConfirm = false;
			var obj = null;	
			var perilLength = 0;
			var deductiblesLength = 0;		
			
			obj = (objGIPIWItem.filter(function (o){	return o.parId == delObj.parId && o.itemNo == delObj.itemNo && nvl(o.recordStatus, 0) != -1;	}))[0];
			if(obj != null){
				perilLength = obj.gipiWItemPeril == undefined ? 0 : 1;
				deductiblesLength = obj.gipiWDeductible == undefined ? 0 : 1;
				
				//added by steven 10.18.2013
				perilLength = perilLength == 0 ? 0 : obj.gipiWItemPeril.length;
				deductiblesLength = deductiblesLength == 0 ? 0 : obj.gipiWDeductible.length;
				if (perilLength == 0) {
					perilLength = obj.gipiWItemPerilListing == undefined ? 0 : 1;
					perilLength = perilLength == 0 ? 0 : obj.gipiWItemPerilListing.length;
				}
				
				if(delObj.lineCd == objFormVariables.varFI){
					var fireItmLength = obj.gipiWFireItm == undefined ? 0 : 1;
					
					if(perilLength > 0 && fireItmLength > 0){
						blnConfirm = true;
					}else if(perilLength > 0 && fireItmLength == 0){
						blnConfirm = true;
					}else if(perilLength == 0 && fireItmLength > 0){
						blnConfirm = true;
					}
				}else if(delObj.lineCd == objFormVariables.varAV || delObj.lineCd == objFormVariables.varMH){
					var aviationLength = obj.gipiWAviationItem == undefined ? 0 : 1;
					var itemVesLength = obj.gipiWItemVes == undefined ? 0 : 1;
					
					if(perilLength > 0 && (aviationLength > 0 || itemVesLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (aviationLength == 0 || itemVesLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (aviationLength > 0 || itemVesLength > 0)){
						blnConfirm = true;
					}
				}else if(delObj.lineCd == objFormVariables.varCA){
					var casItemLength = obj.gipiWCasualtyItem == undefined || obj.gipiWCasualtyItem == null ? 0 : 1;
					var casPerLength = obj.gipiWCasualtyPersonnel == undefined ? 0 : 1;
					var groupedItemsLength = obj.gipiWGroupedItems == undefined ? 0 : 1;
					
					casPerLength = casPerLength == 0 ? 0 : obj.gipiWCasualtyPersonnel.length; //added by steven 10.18.2013
					groupedItemsLength = groupedItemsLength == 0 ? 0 : obj.gipiWGroupedItems.length; //added by steven 10.18.2013
					
					if(perilLength > 0 && (casItemLength > 0 || casPerLength > 0 || groupedItemsLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (casItemLength == 0 || casPerLength == 0 || groupedItemsLength == 0 || deductiblesLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (casItemLength > 0 || casPerLength > 0 || groupedItemsLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}
				}else if(delObj.lineCd == objFormVariables.varEN){
					var locationLength = obj.gipiWLocation == undefined ? 0 : 1;
					
					if(perilLength > 0 && (locationLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (locationLength == 0 || deductiblesLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (locationLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}
				}else if(delObj.lineCd == objFormVariables.varAC){
					var accidentLength = obj.gipiWAccidentItem == undefined ? 0 : 1;
					var uppaLength = 0;
					
					if(perilLength > 0 && (accidentLength > 0 || uppaLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (accidentLength == 0 || uppaLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (accidentLength > 0 || uppaLength > 0)){
						blnConfirm = true;
					}
				}else if(delObj.lineCd == objFormVariables.varMN){
					var cargoLength = obj.gipiWCargo == undefined ? 0 : 1;
					
					if(perilLength > 0 && cargoLength > 0){
						blnConfirm = true;
					}else if(perilLength > 0 && cargoLength == 0){
						blnConfirm = true;
					}else if(perilLength == 0 && cargoLength > 0){
						blnConfirm = true;
					}
				}else if(delObj.lineCd == objFormVariables.varMC){										
					var vehicleLength = obj.gipiWVehicle == undefined ? 0 : 1;
					var accessoryLength = obj.gipiWMcAcc == undefined ? 0 : 1;
					
					accessoryLength = accessoryLength == 0 ? 0 : obj.gipiWMcAcc.length; //added by steven 10.18.2013
					
					if(perilLength > 0 && (vehicleLength > 0 || accessoryLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (vehicleLength == 0 || accessoryLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (vehicleLength > 0 || accessoryLength > 0)){
						blnConfirm = true;
					}
				}
				
				if(blnConfirm){
					showConfirmBox("Delete", "There are records connected on this item. " + 
							"Additional item information, Invoice and Preliminary Distribution will also be deleted. Delete anyway?",
							"Ok", "Cancel", function(){	continueDelete(delObj);	}, stopProcess);
				}else{
					continueDelete(delObj);
				}
			}
		}catch(e){
			showErrorMessage("delRecords", e);
		}	
	}	

	function continueDelete(delObj){
		try{
			var mainRow = ($$("div#packageParPolicyTable .selectedRow"))[0];
			var row = $("row" + delObj.itemNo);
			
			if(delObj.itemGrp > 0){
				objGIPIWPackageInvTax.push(delObj);
				objGIPIWCommInvPerils.push(delObj);
				objGIPIWCommInvoices.push(delObj);
				objGIPIWInvoice.push(delObj);
			}	
							
			addDeletedJSONObject(objGIPIWItem, delObj);

			var objArrTemp = objPackLineSubline.filter(function(obj){	return obj.parId != delObj.parId;	});

			objPackLineSubline = [];
			objPackLineSubline = objArrTemp;
			
			Effect.Fade(row, {
				duration : .2,
				afterFinish : function(){
					row.remove();
					resizeTableBasedOnVisibleRows("itemTable", "parItemTableContainer");				
				}
			});
			
			//setMainItemForm(null); changed. irwin - 11.21.11
			setMainPackagePolicyItemForm(null);
			$("packLineCd").value = mainRow.getAttribute("lineCd");					
			$("packSublineCd").value = mainRow.getAttribute("sublineCd");
			$("region").value = mainRow.getAttribute("regionCd");
			($$("div#packPolicyItemsInfoDiv [changed=changed]")).invoke("removeAttribute", "changed");
			objFormVariables.varSwitchDelete = "Y";
		}catch(e){
			showErrorMessage("continueDelete", e);
		}		
	}

	$("btnDeleteItem").observe("click", function(){
		if(($$("div#packageParPolicyTable .selectedRow")).length < 1){
			showMessageBox("Please select PAR first.", imgMessage.ERROR);
		}else{
			$$("div#itemTable .selectedRow").each(function(row){
				var packParId = $F("globalPackParId");
				var parId = row.getAttribute("parId");
				var itemNo = row.getAttribute("item");					
				var itemGrp = nvl((objGIPIWItem.filter(function(obj){	return obj.parId == parId && obj.itemNo == itemNo;	}))[0].itemGrp, 0);
				var delObj = {};

				delObj.parId = parId;
				delObj.itemNo = itemNo;
				delObj.itemGrp = itemGrp;
				delObj.packParId = packParId;
				delObj.lineCd = ($$("div#packageParPolicyTable .selectedRow"))[0].getAttribute("lineCd");
				delObj.recordStatus = 0;

				delRecords(delObj);			
			});
		}		
	});
	
	//added by steven 12.10.2013
	if (objUWGlobal.hidGIPIS095DefualtCurrencyCd == $("currency").value) {
		$("rate").disabled = true;
	} else {
		$("rate").disabled = false;
	}
	
	$("currency").observe("change", function(){
		if (objUWGlobal.hidGIPIS095PerilExist != "0") {
			showMessageBox("Cannot change currency code." , "E");
			$("currency").value = objCurrItem.currencyCd;
			$("rate").value = formatToNineDecimal(nvl(objCurrItem.currencyRt, ""));
		}
		if (objUWGlobal.hidGIPIS095DefualtCurrencyCd === $("currency").value) {
			$("rate").disabled = true;
		} else {
			$("rate").disabled = false;
		}
	});
	
	
</script>