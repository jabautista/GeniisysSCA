<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
    
<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Item Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="itemInformationDiv">
	<div id="itemInformation" style="width: 100%;">
		<div id="quoteItemTable" align="center" style="margin: 10px;">
			<div style="width: 100%;" id="itemTable" name="itemTable">
				<div class="tableHeader">
					<label style="width: 5%; text-align: center; margin-left: 10px;">No</label>
					<label style="width: 15%; text-align: left;">Item Title</label>
			   		<label style="width: 14%; text-align: left; margin-left: 10px;">Description 1</label>
			   		<label style="width: 14%; text-align: left; margin-left: 10px;">Description 2</label>
					<label style="width: 14%; text-align: left; margin-left: 10px;">Currency</label>
					<label style="width: 9.5%; text-align: right;">Rate</label>
					<label style="width: 18%; text-align: left; margin-left: 15px;">Coverage</label>
				</div>
				<div id="quoteItemTableContainer" class="tableContainer" style="">
				</div>
			</div>
		</div>
	</div>
	<input type="hidden" id="defaultCurrencyCode" name="defaultCurrencyCode" value="${defaultCurrency.code}" />
	<div style="margin: 10px;" id="quoteItemForm" class="quoteChildRecord">
		<table cellspacing="1" border="0" style="margin: 10px auto;">
	 		<tr>
				<td class="rightAligned" style="width: 100px;">Item No. </td>
				<td class="leftAligned" style="width: 210px;">
					<input id="txtItemNo" name="txtItemNo" type="text" style="width: 210px;" readonly="readonly" class="required"/>
				</td>
				<td class="rightAligned" style="width: 100px;" name="itemTitleTd">Item Title </td>
				<td class="leftAligned">
					<input id="txtItemTitle" name="txtItemTitle" type="text" style="width: 210px;" maxlength="50" class="required allCaps"/>
				</td>
			</tr>
		 	<tr>
				<td class="rightAligned">Description 1</td>
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 20px; width: 544px;">
						<textarea id="txtItemDesc" name="txtItemDesc" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;"></textarea>
						<img id="editDesc" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit"  />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Description 2</td>
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 20px; width: 544px;">
						<textarea id="txtItemDesc2" name="txtItemDesc2" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;"></textarea>
						<img id="editDesc2" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit"  />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned">
					<select style="width: 218px;" id="selCurrency" name="selCurrency">
						<option value=""></option>
					</select>
				</td>
				<td class="rightAligned">Rate</td>
				<td class="leftAligned">
					<input id="txtCurrencyRate" name="txtCurrencyRate" type="text" class="moneyRate2" style="width: 210px;" maxlength="13" min="0.000000001" max="999.999999999" errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Coverage </td>
				<td class="leftAligned">
					<select style="width: 218px;" id="selCoverage" name="selCoverage">
					</select>
				</td>
			</tr>
		</table>
		<div align="center" changeTagAttr="true">
			<table>
				<tr>
					<td>
						<input type="button" class="button" style="width: 90px;" id="btnAddItem" name="btnAddItem" value="Add" />
					</td>
					<td></td>
					<td>
						<input type="button" class="disabledButton" style="width: 90px;" id="btnDeleteItem" name="btnDeleteItem" value="Delete" disabled="disabled" />
					</td>
					<td></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
	
	objItemCurrencyLov = JSON.parse('${currencyLovJSON}'.replace(/\\/g, '\\\\'));
	objItemCoverageLov = JSON.parse('${coverageLovJSON}'.replace(/\\/g, '\\\\'));
	
	objDefaultCurrency = '${defaultCurrencyCd}';
	if(objDefaultCurrency.blank()){
		objDefaultCurrency = null;
	}

	setCurrencyLov(objDefaultCurrency);
	setCoverageLov();
	initializeAllMoneyFields();

	$("txtItemNo").observe("blur", function(){
		if(this.getAttribute("readonly") != "readonly"){
			if(!verifyQuoteItemNo(this.value)){
				$("txtItemNo").value = getNextQuoteItemNo(objPackQuoteItemList);
			};
		}
	});

	$("editDesc").observe("click", function () {
		showEditor("txtItemDesc", 2000);
	});

	$("editDesc2").observe("click", function () {
		showEditor("txtItemDesc2", 2000);
	});
	
	$("selCurrency").observe("change", function(){
		var ratez = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate");
		if(ratez.blank() || ratez == null){
			$("txtCurrencyRate").value = formatToNineDecimal(0);
		}else{
			$("txtCurrencyRate").value = formatToNineDecimal(ratez);
		}
	});

	$("btnAddItem").observe("click", function (){
		var quoteId = getSelectedPackQuoteId();
		
		if(quoteId == "") return;
		if(validateBeforeAddOrUpdateItem()){
			if($("btnAddItem").value == "Update"){
				var updatedQuoteItemObject = setQuoteItemObject(quoteId, true);
				var selectedItemRow = getSelectedRow("row");
				addModifiedJSONObject(objPackQuoteItemList, updatedQuoteItemObject);
				var updatedRow = prepareQuoteItemTable(updatedQuoteItemObject);
				selectedItemRow.update(updatedRow);
				fireEvent(selectedItemRow, "click");
				
			}else{
				var newQuoteItemObject = setQuoteItemObject(quoteId, false);
				addNewItemObject(objPackQuoteItemList, newQuoteItemObject);
				var newRow = createQuoteItemRow(newQuoteItemObject);
	
				$("quoteItemTableContainer").insert({bottom : newRow}); 
				setQuoteItemRowObserver(newRow);
			}
			
			resizeTableBasedOnVisibleRows("quoteItemTable", "quoteItemTableContainer");
			setQuoteItemInfoForm(null);
		}
		//computeInvoiceTsiAmountsAndPremiumAmounts();
	});

	$("btnDeleteItem").observe("click", function(){
		showConfirmBox("Delete Item", "Quotation Item has child information. Deleting this item will also delete related information. Proceed deleting this item?",
						"Yes", "No", deletePackQuoteItem, "");
	});

	function validateBeforeAddOrUpdateItem(){
		var itemNo = $F("txtItemNo");
		var itemTitle = $F("txtItemTitle");
		var currency = $F("selCurrency");
		var rate = $F("txtCurrencyRate");

		if(itemNo.blank()) {
			showMessageBox("Item No. is required.", imgMessage.ERROR);
			return false;
		}else if(itemTitle.blank()) {
			showMessageBox("Item Title is required.", imgMessage.ERROR);
			return false;
		}else if (currency.blank() || "0.000000000" == rate) {
			showMessageBox("Currency rate is required!", imgMessage.ERROR);
			return false;
		}else if($F("txtCurrencyRate").match("-")) {
			showMessageBox("Invalid currency rate.", imgMessage.ERROR);
			return false;
		}

		return true;
	}

	function deletePackQuoteItem(){
		var selectedItemRow = getSelectedRow("row");

		for (var i = 0; i < objPackQuoteItemList.length; i++){
			if (objPackQuoteItemList[i].quoteId == objCurrPackQuote.quoteId 
				&& objPackQuoteItemList[i].itemNo == $F("txtItemNo")){
				objPackQuoteItemList[i].lineCd = objCurrPackQuote.lineCd;
				objPackQuoteItemList[i].menuLineCd = objCurrPackQuote.menuLineCd;
				objPackQuoteItemList[i].recordStatus = -1;
				deleteAllQuoteItemPerils(objPackQuoteItemList[i].quoteId, objPackQuoteItemList[i].itemNo);
				deleteAllQuoteItemDeductibles(objPackQuoteItemList[i].quoteId, objPackQuoteItemList[i].itemNo);
				quotePerilChangeTag = 1;
				var currInv = getCurrPackQuoteInvoice(selectedItemRow);
				if(currInv != null){
					currInv.recordStatus = 1;
				}
			}
		}
		fireEvent(selectedItemRow, "click");
		selectedItemRow.remove();
		resizeTableBasedOnVisibleRows("quoteItemTable", "quoteItemTableContainer");
	}	
		
</script>
