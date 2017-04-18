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
     <label>Item Information</label> 
      <span class="refreshers" style="margin-top: 0;"> 
       <label name="gro" style="margin-left: 5px;">Hide</label> 
      </span>
  </div>
</div>
<div class="sectionDiv" id="itemInformationDiv">	
	<div style="width: 100%;" id="itemInformationDivList" class="tableContainer" style="margin-top: 10px;">
		<jsp:include page="/pages/underwriting/endt/engineering/subPages/endtEngineeringItemInformationListing.jsp"></jsp:include>
	</div>	   
	<table style="margin-top: 10px;" width="80%" cellspacing="2" align="center" border="0">
		<tr>
			<td class="rightAligned" style="width: 17%;">Item No. </td>
			<td class="leftAligned" style="width: 20%;">
				<input type="text" style="width: 100%; padding: 2px;" id="itemNo" name="itemNo" value="" maxlength="9" class="required enRequired" />
			</td>
			<td class="rightAligned" style="width: 17%;">Item Title </td>
			<td class="leftAligned">
				<input type="text" style="width: 100%; padding: 2px;" id="itemTitle" name="itemTitle" value="${item.itemTitle}" maxlength="250" class="required enRequired" />						
			</td>
			<td rowspan="6"  style="width: 20%;">
				<table cellpadding="1" border="0" align="center">
					<tr align="right"><td><input type="button" style="width: 100%;" id="btnNegateItem" 		    name="btnNegateItem" 		class="disabledButton" value="Neg/Remove Item" /></td></tr>
					<tr align="right"><td><input type="button" style="width: 100%;" id="btnAddDeleteItem" 	    name="btnAddDeleteItem" class="button" value="Delete/Add All Items" /></td></tr>
					<tr align="right"><td><input type="button" style="width: 100%;" id="btnAssignDeductibles" 	name="btnAssignDeductibles" class="disabledButton" value="Assign Deductibles" /></td></tr>
					<tr align="right"><td><input type="button" style="width: 100%;" id="btnOtherDetails" 		name="btnOtherDetails" 		class="disabledButton" value="Other Details" /></td></tr>
					<tr align="right"><td><input type="button" style="width: 100%;" id="btnAttachMedia" 		name="btnAttachMedia" 		class="disabledButton" value="Attach Media" /></td></tr>
				</table>						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 17%;">Description 1</td>
			<td class="leftAligned" colspan="3">
				<input type="text" style="width: 100%; padding: 2px;" id="itemDesc" name="itemDesc" value="${item.itemDesc}" maxlength="2000" />						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 17%;">Description 2</td>
			<td class="leftAligned" colspan="3">
				<input type="text" style="width: 100%; padding: 2px;" id="itemDesc2" name="itemDesc2" value="${item.itemDesc2}" maxlength="2000" />						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 17%;">Currency </td>
			<td class="leftAligned" style="width: 20%;">
				<select id="currency" name="currency" style="width: 100%;" class="required enRequired">				
					<c:forEach var="currency" items="${currency}">
						<option currRate="${currency.valueFloat}" value="${currency.code}"
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
				<input type="text" style="width: 100%; padding: 2px;" id="rate" name="rate" class="moneyRate required enRequired" value="1.00" maxlength="12" readonly="readonly"/>						
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 17%;">Group </td>
			<td class="leftAligned" style="width: 20%;">
				<select tabindex="8" id="groupCd" name="groupCd" style="width: 100%;">
					<option value=""></option>
					<c:forEach var="group" items="${groups}">
						<option value="${group.groupCd}"
						<c:if test="${item.groupCd == group.groupCd}">
							selected="selected"
						</c:if>>${group.groupDesc}</option>				
					</c:forEach>
				</select>
			</td>	
			<td class="rightAligned" style="width: 17%;">Region </td>
			<td class="leftAligned"  style="width: 20%;">
				<select tabindex="7" id="region" name="region" style="width: 103%;" class="required enRequired">
					<option value=""></option>
					<c:forEach var="region" items="${regions}">
						<option value="${region.regionCd}"
						<c:if test="${regionCd == region.regionCd}">
							selected="selected"
						</c:if>>${region.regionDesc}</option>				
					</c:forEach>
				</select>
			</td>	
		</tr>
	</table>
	<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 20px;">	
		<input type="button" style="width: 80px; " id="btnAddItem" class="button" value="Add" />
		<input type="button" style="width: 80px;" id="btnDeleteItem" class="disabledButton" value="Delete" />
	</div>
</div>
<script>
objEndtENItems = JSON.parse('${itemsJSON}'.replace(/\\/g, '\\\\')); //eval('${itemsJSON}');  //
objPolbasics = JSON.parse('${gipiPolbasics2}'.replace(/\\/g, '\\\\'));
objCurrEndtItem = new Object();
objParPolbas = JSON.parse('${gipiWPolbas}');

showItemInformationList(objEndtENItems);
/*
$("btnDeleteItem").observe("click", function ()	{
	$$("div[name='row']").each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			markRecordAsDeleted($F("itemNo"));
			row.remove();
			clearValues();
			$("btnAddItem").value = "Add";
			disableButton("btnDeleteItem");
			checkTableIfEmpty("row", "itemTableContainer");	
		}				
	});
});
*/

$("btnDeleteItem").observe("click", function ()	{
	var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 2, "T");

	//if($$("div#deductiblesTable2 div[name='ded2']").size() > 0){
	if(itemTsiDeductibleExist){
		showConfirmBox("Item Deductible", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. " +
				"Continue?", "Yes", "No", function(){ deletePolicyDeductible(itemNo); }, stopProcess);
	}else{
		$$("div[name='row']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				Effect.Fade(row, {
					duration: .2,
					afterFinish: function ()	{
						markRecordAsDeleted($F("itemNo"));					
						row.remove();	
						clearValues();
						disableButton("btnDeleteItem");
						$("btnAddItem").value = "Add";
						checkTableIfEmpty("row", "parItemTableContainer");			
					}
				});
			}
		});
	}
});


function markRecordAsDeleted(itemNo){
	for(var i=0; i<objEndtENItems.length; i++) {		
		if (parseInt(itemNo) == parseInt(objEndtENItems[i].itemNo)){
			objEndtENItems[i].recordStatus = -1;
			break;
		}
	}		
}

function setAddedItemInfo(){
	var newObj = new Object();
	try{
		newObj.parId		= 	$F("globalParId");
		newObj.itemNo		=   $F("itemNo");
		newObj.itemTitle	= 	$F("itemTitle");
		newObj.itemDesc		=	$F("itemDesc");
		newObj.itemDesc2	=	$F("itemDesc2");
		newObj.currencyCd   = 	$F("currency");
		newObj.currencyRt	= 	$F("rate");
		newObj.regionCd		=   $F("region");
		newObj.groupCd		=   $F("groupCd");
		newObj.recFlag		=	"A";
		newObj.otherInfo	= 	$F("otherInfo");
		newObj.itemGrp		=   1;
		newObj.recordStatus = 0;

		objEndtENItems.push(newObj);
		/*for (var i=0; i<objArray.length; i++){
			if (objArray[i].recordStatus == 0){
			}
		}*/
		    			
	}catch(e){
		showErrorMessage("setAddedItemInfo", e);
		//showMessageBox("setAddedItemInfo : " + e.message);
	}
}

$("btnAddItem").observe("click", function () {
	if(nvl(objFormVariables[0].varDiscExist, "N") == "Y"){
		showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue ?",
				"Continue", "Cancel", updateVariableDiscExist, stopProcess);
	}else if(nvl(objFormParameters[0].parPolFlagSw, "N") != "N"){
		showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
	}else{
		var itemTable = $("parItemTableContainer");
		var newDiv = new Element("div");
		if ($F("btnAddItem") == "Add"){
			if (checkEnRequiredDisabledFields()){
				newDiv.setAttribute("id", "row"+$F("itemNo"));
				newDiv.setAttribute("name", "row");
				newDiv.setAttribute("item", $F("itemNo"));
				newDiv.addClassName("tableRow");
				
				var content = '<label style="width: 30px; text-align: right; margin-left: 10px;" id="lblItemNo'+$F("itemNo")+'">'+$F("itemNo")+'</label>' +						
				'<label style="width: 190px; text-align: left; margin-left: 10px;" title="'+$F("itemTitle")+'" id="lblItemTitle'+$F("itemNo")+'">'+$F("itemTitle")+'</label>'+
				'<label style="width: 180px; text-align: left; margin-left: 10px;" title="'+$F("itemDesc")+'" id="lblItemDescription1'+$F("itemNo")+'">'+($F("itemDesc") == "" ? "-" : $F("itemDesc"))+'</label>'+
				'<label style="width: 180px; text-align: left; margin-left: 10px;" title="'+$F("itemDesc2")+'" id="lblitemDescription2'+$F("itemNo")+'">'+($F("itemDesc2") == "" ? "-" : $F("itemDesc2"))+'</label>'+
				'<label style="width: 180px; text-align: left; margin-left: 10px;" title="'+($("currency").options[$("currency").selectedIndex].text)+'" id="lblCurrency'+($("currency").options[$("currency").selectedIndex].text)+'">'+($("currency").options[$("currency").selectedIndex].text)+'</label>'+
				'<label style="width: 70px; text-align: right; margin-left: 12px;" title="'+$F("rate")+'" id="lblRate'+$F("itemNo")+'">'+formatToNineDecimal($F("rate"))+'</label>';
		
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});
				divEvents(newDiv); 	
				setAddedItemInfo();
				clearValues();
		
			}else {
				showMessageBox("Please complete required fields.",  imgMessage.ERROR);
			}
		}else{
			if (checkEnRequiredDisabledFields()){
				removeOrigDtls($F("itemNo"));
				$("lblItemNo" + $F("itemNo")).innerHTML = $F("itemNo");
				$("lblItemTitle" + $F("itemNo")).innerHTML = $F("itemTitle");
				$("lblItemDescription1" + $F("itemNo")).innerHTML = $F("itemDesc") == "" ? "-" : $F("itemDesc");
				$("lblItemDescription2" + $F("itemNo")).innerHTML = $F("itemDesc2") == "" ? "-" : $F("itemDesc2");
				$("lblCurrency" + $F("itemNo")).innerHTML = $("currency").options[$("currency").selectedIndex].text;
				$("lblRate" + $F("itemNo")).innerHTML = $F("rate");
				
				$$("div[name='row']").each(function (r)	{
					r.removeClassName("selectedRow");
				});
				$("btnAddItem").value = "Add";
				disableButton("btnDeleteItem");		
				setAddedItemInfo();
				clearValues();
			}
		}
	}	
});

function removeOrigDtls(itemNo){
	for (var i=0; i<objEndtENItems.length; i++) {
		if (objEndtENItems[i].itemNo == itemNo){
			objEndtENItems.splice(i, 1);
		}
	}
}

function showItemInformationList(objEndtENItems){
	try {
		var itemTable = $("parItemTableContainer");
		
		for(var i=0; i<objEndtENItems.length; i++) {				
			var content = prepareItemInformationList(objEndtENItems[i]);										
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "row"+objEndtENItems[i].itemNo);
			newDiv.setAttribute("name", "row");
			newDiv.setAttribute("item", objEndtENItems[i].itemNo);
			newDiv.addClassName("tableRow");
			
			newDiv.update(content);
			itemTable.insert({bottom : newDiv});
			divEvents(newDiv);
				
		}
		checkTableIfEmpty("row", "parItemTableContainer");
	} catch (e) {
		showErrorMessage("showItemInformationList", e);
		//showMessageBox("showItemList : " + e.message);
	}
}

function prepareItemInformationList(obj){
	try {				
		var itemInformationList  = '<label style="width: 30px; text-align: right; margin-left: 10px;" id="lblItemNo'+obj.itemNo+'">'+obj.itemNo+'</label>' +						
						'<label style="width: 190px; text-align: left; margin-left: 10px;" title="'+obj.itemTitle+'" id="lblItemTitle'+obj.itemNo+'">'+obj.itemTitle+'</label>'+
						'<label style="width: 180px; text-align: left; margin-left: 10px;" title="'+obj.itemDesc+'" id="lblItemDescription1'+obj.itemNo+'">'+(obj.itemDesc == null ? "-" : obj.itemDesc)+'</label>'+
						'<label style="width: 180px; text-align: left; margin-left: 10px;" title="'+obj.itemDesc2+'" id="lblItemDescription2'+obj.itemNo+'">'+(obj.itemDesc2 == null ? "-" : obj.itemDesc2)+'</label>'+
						'<label style="width: 180px; text-align: left; margin-left: 10px;" title="'+obj.currencyDesc+'" id="lblCurrency'+obj.itemNo+'">'+obj.currencyDesc+'</label>'+
						'<label style="width: 70px; text-align: right; margin-left: 12px;" title="'+obj.currencyRt+'" id="lblRate'+obj.itemNo+'">'+formatToNineDecimal(obj.currencyRt)+'</label>';

		return itemInformationList;
	} catch (e) {
		showErrorMessage("prepareItemInformationList", e);
		//showMessageBox("preitemInformationListInfo : " + e.message);
	}
}

function divEvents(div) {
	div.observe("mouseover", function () {
		div.addClassName("lightblue");
	});
	
	div.observe("mouseout", function ()	{
		div.removeClassName("lightblue");
	});

	div.observe("click", function (row) {
		clickRow(div, objEndtENItems);
		enableButtons($F("itemNo") != "" ? true : false);
	});
}

function setFormValues(itemNo){
	for (var i=0; i<objEndtENItems.length; i++){
		if (parseInt(itemNo) == parseInt(objEndtENItems[i].itemNo)){
			$("itemNo").value = objEndtENItems[i].itemNo;
			objCurrEndtItem.itemNo = objEndtENItems[i].itemNo;
			$("itemTitle").value = objEndtENItems[i].itemTitle;
			$("itemDesc").value = objEndtENItems[i].itemDesc;
			$("itemDesc2").value = objEndtENItems[i].itemDesc2;
			$("currency").value = objEndtENItems[i].currencyCd;
			$("rate").value = formatRate(objEndtENItems[i].currencyRt);
			$("region").value = objEndtENItems[i].regionCd;
			$("groupCd").value = objEndtENItems[i].groupCd;
			$("otherInfo").value = objEndtENItems[i].otherInfo; 
			break;
		}
	}
}

function clearValues(){
	$("itemNo").value = "";
	$("itemTitle").value = "";
	$("itemDesc").value = "";
	$("itemDesc2").value = "";
	$("currency").value = 1;
	$("rate").value = formatRate($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
	$("region").selectedIndex = 0;
	$("groupCd").selectedIndex = 0;
	$("otherInfo").value = "";
	//objCurrEndtItem.itemNo = 0;
	//generateItemNo();
}

function generateItemNo(){
	var counter = 0;
	var initialValue = 0;
	$$("div[name='row']").each(function (div) {
		if (counter == 0){
			initialValue = parseInt(div.down("label", 0).innerHTML);
		}
		counter += 1;
		currValue = parseInt(div.down("label", 0).innerHTML);
		if ($$("div[name='row']").size() > 0) {
			if (currValue > initialValue){
				initialValue = currValue;
			}
		}
	});
	$("itemNo").value = parseInt(initialValue + 1);
}

$("currency").observe("change", function (){
	//$("rate").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
	if(!($F("currency").empty())){
		if(objFormVariables[0].varOldCurrencyCd != $F("currency")){
			objFormVariables[0].varGroupSw = "Y";				
		}
			
		getRates();
		if ($("currency").value == "1"){
			$("rate").disable();
		}else{
			$("rate").enable();
		}
	}else{
		$("rate").value = "";
	}	
});

$("itemNo").observe("blur", function () {
	if (checkExistingItemNoInList()){
		customShowMessageBox("Item must be unique.", imgMessage.ERROR, "itemNo");
	}else if (isNaN($F("itemNo")) || $F("itemNo") == "" || parseInt($F("itemNo")) <= 0){
		customShowMessageBox("Must be in range 000000001 to 999999999.", imgMessage.ERROR, "itemNo");
	}
});

function checkExistingItemNoInList(){
	var exists = false;
	if ($$("div[name='row']").size() > 0){
		$$("div[name='row']").each(function (div) {
			if (parseInt($F("itemNo")) == parseInt(div.down("label", 0).innerHTML)) {
				exists = true;
			}
		});
	}
	return exists;
}

function checkEnRequiredDisabledFields() {
	var isComplete = true;
	$$(".enRequired").each(function (o) {
		if (o.value.blank() && o.disabled == false) {
			isComplete = false;
			$break;
		}
	});	
	return isComplete;
}

function enableButtons(enable){
	if (enable){
		enableButton("btnNegateItem");
		//enableButton("btnAddDeleteItem");
		enableButton("btnAssignDeductibles");
		enableButton("btnOtherDetails");
		enableButton("btnAttachMedia");
	}else{
		disableButton("btnNegateItem");
		//disableButton("btnAddDeleteItem");
		disableButton("btnAssignDeductibles");
		disableButton("btnOtherDetails");
		disableButton("btnAttachMedia");
	}
}

$("btnAttachMedia").observe("click", function(){
	// openAttachMediaModal("par");
	openAttachMediaOverlay("par"); // SR-5494 JET OCT-14-2016
});

$("btnOtherDetails").observe("click", function() {
	if ($F("itemNo").blank()) {
		showMessageBox("Please enter item number first.", imgMessage.ERROR);
		return false;
	} else {
		showOtherInfoEditor("otherInfo", 2000);
		objCurrEndtItem.otherInfo = $F("otherInfo");
	}
});

$("btnAssignDeductibles").observe("click", function() {
	if($("deductiblesTable2") == null){
		showDeductibleModal(2);
		window.setTimeout("assignDeductibles();", 700);
	} else {
		assignDeductibles();
	}
});	

$("btnAddDeleteItem").observe("click", function() {
	selectAddDeleteOption("parItemTableContainer", "row", objPolbasics);
});

$("btnNegateItem").observe("click", confirmNegateItem);
$("currency").value = 1;

initializeAllMoneyFields();
</script>