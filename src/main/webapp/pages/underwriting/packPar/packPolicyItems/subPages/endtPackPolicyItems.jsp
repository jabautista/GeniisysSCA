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
							<td class="leftAligned" style="width: 100px;"><input type="text" tabindex="1" style="width: 224px; padding: 2px;" id="itemNo" name="itemNo" class="required integerUnformattedOnBlur" maxlength="9" errorMsg="Invalid Item No. Valid value should be from 1 to 999,999,999." min="1" max="999999999"/></td>
							<td class="rightAligned" style="width: 100px;">Item Title </td>							
							<td class="leftAligned" style="width: 280px;"><input type="text" tabindex="2" style="width: 224px; padding: 2px;" id="itemTitle" name="itemTitle" maxlength="50" class="required" /></td>
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
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditItemDesc" id="editDesc2" class="hover"  />
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
								<input type="text" tabindex="6" style="width: 224px; padding: 2px;" id="rate" name="rate" class="moneyRate2 required" maxlength="13" value="" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
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
					<input type="button" id="btnAddItem" 	 class="button" value="Add"  enValue="Add"/>
					<input type="button" id="btnDeleteItem"	 class="disabledButton" value="Delete" enValue="Delete"/>
					<input type="button" id="btnPolicyItems" class="button" value="Policy Items" enValue="Policy Items" style="width: 100px;"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
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

	$("itemNo").observe("blur", function(){
		if($("itemNo").readOnly == true){
			return false;
		}else if(!$F("itemNo").blank()){
			$("recFlag").value = "A";
			validateItemNo($F("itemNo"));
		}
	});
	
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

	$("currency").observe("change", function(){		
		if(!($F("currency").empty())){								
			getRates();
			$("rate").readOnly = $("currency").value == 1 ? true : false;
		}else{
			$("rate").value = "";
		}						
	});
	
	//added by jeffdojello 05.07.2013
	$("rate").observe("focus", function(){
		if(!($F("currency").empty())){								
			getRates();
			$("rate").readOnly = $("currency").value == 1 ? true : false;
		}else{
			$("rate").value = "";
		}						
	});

	function addItem(){
		try{
			var mainRow = ($$("div#packageParPolicyTable .selectedRow"))[0];
			$("packLineCd").value = mainRow.getAttribute("lineCd");					
			$("packSublineCd").value = mainRow.getAttribute("sublineCd");
			var newObj = setItemObj();
			var content = prepareEndtItemInfo(newObj);
			
			if($F("btnAddItem") == "Update"){				
				var row = ($$("div#packPolicyItemsInfoDiv .selectedRow"))[0];
				for (var i=0; i<objGIPIWItem.length; i++) {
					if(objGIPIWItem[i].itemNo == row.getAttribute("item")){
						newObj.recFlag = objGIPIWItem[i].recFlag; // added by Nica 10.14.2011 - to resolve null rec_flag value
						newObj.recordStatus = (objGIPIWItem[i].recordStatus == 0 ? 0 : 1);	
						objGIPIWItem.splice(i, 1);
					}
				}
				objGIPIWItem.push(newObj);
				row.update(content);
				row.update(content).removeClassName("selectedRow");
				row.setAttribute("item", newObj.itemNo);
				row.setAttribute("id", "row"+newObj.itemNo);
				
			}else{
				newObj.recFlag = $("recFlag").value; // added by Nica 10.14.2011 - to resolve null rec_flag value
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

				setEndtPackPolicyItemRowObserver(newDiv);

				objItemNoList.push({"itemNo" : newObj.itemNo});
				
				resizeTableBasedOnVisibleRows("itemTable", "parItemTableContainer");
				
				new Effect.Appear(newDiv.id, {
					duration: 0.2
				});
			}
			
			setMainItemForm(null);
			($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");			
		}catch(e){			
			showErrorMessage("addItem", e);
		}	
	}

	$("btnAddItem").observe("click", function(){
		if(($$("div#packageParPolicyTable .selectedRow")).length < 1){
			showMessageBox("Please select PAR first.", imgMessage.ERROR);
		}else if($F("itemNo").blank()){
			customShowMessageBox("Item Number is required.", imgMessage.ERROR, "itemNo");						
			return false;
		}else if($F("btnAddItem") == "Add" && $("row" + $F("itemNo")) != undefined){
			customShowMessageBox("Item Number already exists.", imgMessage.ERROR, "itemNo");
			return false;		
		}else if($F("currency").blank() || "0.000000000" == $F("rate")){
			customShowMessageBox("Currency rate is required.", imgMessage.ERROR, "currency");
			return false;
		}else if($F("rate").match("-") || $F("rate").blank()) {
			customShowMessageBox("Invalid currency rate.", imgMessage.ERROR, "rate");
			return false;
		}else if($F("itemTitle").blank() || $F("itemTitle") == "") {
			customShowMessageBox("Please enter the item title first.", imgMessage.ERROR, "itemTitle");
			return false;
		}else{
			if(objFormParameters.paramOra2010Sw == "Y" && nvl(objGIPIWPolbas.planSw, "N") == "Y"){
				if(objLineSublineList.length > 0){
					showMessageBox("This is a Package Plan Policy. Only one (1) item per Line/Subline is allowed.", imgMessage.INFO);
					return false;
				}				
			}
			
			var row = ($$("div#packageParPolicyTable .selectedRow"))[0];
			var parId = row.getAttribute("parId");
			var lineCd = row.getAttribute("lineCd");
			var sublineCd = row.getAttribute("sublineCd");

			var objLineSublineList = objPackLineSubline.filter(function(obj){	return obj.parId == parId && obj.packLineCd == lineCd && obj.packSublineCd == sublineCd;	});
			
			itemNo 			= $F("itemNo");
			itemTitle 		= changeSingleAndDoubleQuotes2($F("itemTitle"));
			itemDesc 		= changeSingleAndDoubleQuotes2($F("itemDesc"));
			itemDesc2 		= changeSingleAndDoubleQuotes2($F("itemDesc2"));
			currency		= $F("currency");
			currencyText 	= $("currency").options[$("currency").selectedIndex].text;
			rate 			= $F("rate");
			
			addItem();
			objPackLineSubline.push({"parId" : parId, "itemNo" : itemNo, "packLineCd" : lineCd, "packSublineCd" : sublineCd, "recordStatus" : 0});
			objFormVariables.varSwitchInsert = "Y";						
		}		
	});

	function delRecords(delObj){
		try{
			if(checkItemNo(delObj.parId, delObj.itemNo, delObj.lineCd)){
				showConfirmBox("Delete", "There are records connected on this item. " + 
						"Additional item information, Invoice and Preliminary Distribution will also be deleted. Delete anyway?",
						"Ok", "Cancel", function(){	continueDelete(delObj);	}, stopProcess);
			}else{
				continueDelete(delObj);
			}
			
		}catch(e){
			showErrorMessage("delRecords", e);
		}	
	}

	function checkItemNo(parId, itemNo, lineCd){
		try{
			var blnConfirm = false;
			var obj = null;	
			var perilLength = 0;
			var deductiblesLength = 0;		

			obj = (objGIPIWItem.filter(function (o){	return o.parId == parId && o.itemNo == itemNo && nvl(o.recordStatus, 0) != -1;	}))[0];
			
			if(obj != null){
				if(obj.gipiWItemPerilListing == undefined){
					perilLength = 0;
				}else{
					var itemPeril = obj.gipiWItemPerilListing.filter(function(peril){ return peril.itemNo == itemNo;});
					perilLength = itemPeril.length;
				}
				deductiblesLength = obj.gipiWDeductible == undefined ? 0 : 1;
				
				if(lineCd == objFormVariables.varFI){
					var fireItmLength = obj.gipiWFireItm == undefined ? 0 : 1;
					
					if(perilLength > 0 && fireItmLength > 0){
						blnConfirm = true;
					}else if(perilLength > 0 && fireItmLength == 0){
						blnConfirm = true;
					}else if(perilLength == 0 && fireItmLength > 0){
						blnConfirm = true;
					}
				}else if(lineCd == objFormVariables.varAV || lineCd == objFormVariables.varMH){
					var aviationLength = obj.gipiWAviationItem == undefined ? 0 : 1;
					var itemVesLength = obj.gipiWItemVes == undefined ? 0 : 1;
					
					if(perilLength > 0 && (aviationLength > 0 || itemVesLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (aviationLength == 0 || itemVesLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (aviationLength > 0 || itemVesLength > 0)){
						blnConfirm = true;
					}
				}else if(lineCd == objFormVariables.varCA){
					var casItemLength = obj.gipiWCasualtyItem == undefined ? 0 : 1;
					var casPerLength = obj.gipiWCasualtyPersonnel == undefined ? 0 : 1;
					var groupedItemsLength = obj.gipiWGroupedItems == undefined ? 0 : 1;
					
					if(perilLength > 0 && (casItemLength > 0 || casPerLength > 0 || groupedItemsLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (casItemLength == 0 || casPerLength == 0 || groupedItemsLength == 0 || deductiblesLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (casItemLength > 0 || casPerLength > 0 || groupedItemsLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}
				}else if(lineCd == objFormVariables.varEN){
					var locationLength = obj.gipiWLocation == undefined ? 0 : 1;
					
					if(perilLength > 0 && (locationLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (locationLength == 0 || deductiblesLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (locationLength > 0 || deductiblesLength > 0)){
						blnConfirm = true;
					}
				}else if(lineCd == objFormVariables.varAC){
					var accidentLength = obj.gipiWAccidentItem == undefined ? 0 : 1;
					var uppaLength = 0;
					
					if(perilLength > 0 && (accidentLength > 0 || uppaLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (accidentLength == 0 || uppaLength == 0)){
						blnConfirm = true;
					}else if(perilLength = 0 && (accidentLength > 0 || uppaLength > 0)){
						blnConfirm = true;
					}
				}else if(lineCd == objFormVariables.varMN){
					var cargoLength = obj.gipiWCargo == undefined ? 0 : obj.gipiWCargo.length;
					
					if(perilLength > 0 && cargoLength > 0){
						blnConfirm = true;
					}else if(perilLength > 0 && cargoLength == 0){
						blnConfirm = true;
					}else if(perilLength == 0 && cargoLength > 0){
						blnConfirm = true;
					}
				}else if(lineCd == objFormVariables.varMC){										
					var vehicleLength = obj.gipiWVehicle == undefined ? 0 : 1;
					var accessoryLength = obj.gipiWMcAcc == undefined ? 0 : 1;
					
					if(perilLength > 0 && (vehicleLength > 0 || accessoryLength > 0)){
						blnConfirm = true;
					}else if(perilLength > 0 && (vehicleLength == 0 || accessoryLength == 0)){
						blnConfirm = true;
					}else if(perilLength == 0 && (vehicleLength > 0 || accessoryLength > 0)){
						blnConfirm = true;
					}
				}
			}
			return blnConfirm;
		}catch(e){
			showErrorMessage("checkItemNo", e);
			return null;
		}
	}	

	function continueDelete(delObj){
		try{
			var mainRow = ($$("div#packageParPolicyTable .selectedRow"))[0];
			var row = ($$("div#packPolicyItemsInfoDiv .selectedRow"))[0];
							
			addDeletedJSONObject(objGIPIWItem, delObj);

			var objArrTemp = objPackLineSubline.filter(function(obj){	return obj.parId != delObj.parId;	});

			objPackLineSubline = [];
			objPackLineSubline = objArrTemp;
			
			Effect.Fade(row, {
				duration : .2,
				afterFinish : function(){
					row.remove();
					resizeTableBasedOnVisibleRows("itemTable", "parItemTableContainer");
					/*if(($$("div#packPolicyItemsInfoDiv div[parId ="+delObj.parId+"]").length) == 0){
						fireEvent($(mainRow.id), "click");
						mainRow.remove();
						checkIfToResizeTable("packageParPolicyTableContainer", "rowPackPar");
						checkTableIfEmpty("rowPackPar", "packageParPolicyTable");
					}else{
						$("packLineCd").value = mainRow.getAttribute("lineCd");					
						$("packSublineCd").value = mainRow.getAttribute("sublineCd");
						($$("div#packPolicyItemsInfoDiv [changed=changed]")).invoke("removeAttribute", "changed");
					}*/				
				}
			});
			
			setMainItemForm(null);	
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

	$("btnPolicyItems").observe("click", showPackPolicyItemsOverlay);
	
</script>