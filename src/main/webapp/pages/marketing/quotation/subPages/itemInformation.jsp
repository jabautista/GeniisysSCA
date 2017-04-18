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
   			<label id="itemInfoLbl" name="gro">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="itemInformationDiv">
	<div id="itemInformation" style="width: 100%;">
		<div id="searchResultQuoteItem" align="center" style="margin: 10px;">
			<div style="width: 100%;" id="itemTable" name="itemTable">
				<div class="tableHeader">
					<label style="width: 5%; text-align: center; margin-left: 10px;">No</label>
					<label style="width: 15%; text-align: left;">Item Title</label>
			   		<label style="width: 14%; text-align: left; margin-left: 10px;">Description 1</label>
			   		<label style="width: 14%; text-align: left; margin-left: 10px;">Description 2</label>
					<label style="width: 14%; text-align: left; margin-left: 10px;">Currency</label>
					<label style="width: 9.5%; text-align: right;">Rate</label>
					<label style="width: 18%; text-align: left; margin-left: 12px;">Coverage</label>
				</div>
				<div id="quoteItemTableContainer" class="tableContainer" style="">
				</div>
			</div>
		</div>
	</div>
	<input type="hidden" id="defaultCurrencyCode" name="defaultCurrencyCode" value="${defaultCurrency.code}" />
	<div style="margin: 10px;" id="quoteItemForm">
		<table cellspacing="1" border="0" style="margin: 10px auto;">
	 		<tr>
				<td class="rightAligned" style="width: 100px;">Item No. </td>
				<td class="leftAligned" style="width: 210px;">
					<input id="txtItemNo" name="txtItemNo" type="text" style="width: 210px;" readonly="readonly" class="required"/>
				</td>
				<td class="rightAligned" style="width: 100px;" name="itemTitleTd">Item Title </td>
				<td class="leftAligned">
					<input id="txtItemTitle" name="txtItemTitle" type="text" style="width: 210px;" maxlength="50" class="required upper"/>
<!--					<input id="txtItemTitle" name="txtItemTitle" type="text" style="width: 210px;" maxlength="250" class="required upper"/>-->
				</td>
			</tr>
		 	<tr>
				<td class="rightAligned">Description 1</td>
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 20px; width: 544px;">
						<textarea id="txtItemDesc" name="txtItemDesc" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;" tabindex="1"></textarea>
						<img id="editDesc" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit"  />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Description 2</td>
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 20px; width: 544px;">
						<textarea id="txtItemDesc2" name="txtItemDesc2" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="width: 490px; border: none; height: 13px;" tabindex="2"></textarea>
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
		<div align="center">
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
					<!-- <td><input type="button" class="disabledButton" style="width: 90px;" id="btnShowPerils" name="btnShowPerils" value="Show Perils" disabled="disabled" /></td> -->
				</tr>
			</table>
		</div>
	</div>
</div>

<script>
var lineCd = getLineCdMarketing();
	//added item for deductible

if(isMakeQuotationInformationFormsHidden == 1) {
	$("btnAddItem").hide();
	$("btnDeleteItem").hide();
	$("txtItemDesc").readOnly = true;
	$("txtItemDesc2").readOnly = true;
	$("txtItemTitle").readOnly = true;
	$("selCoverage").disabled = true;
}

/* MAKE_ROW functions ----------------------------------------------
 * 	-  it is assumed that the object parameters are correct and complete  
 *  -  function will only return the element
 *  -  functions will not add the row element to their respective tables
*/
function makeGIPIQuoteItemRow(gipiQuoteItemObj){
	var itemRowElement = new Element("div");
	itemRowElement.setAttribute("id", "itemRow" + gipiQuoteItemObj.itemNo);
	itemRowElement.setAttribute("name","itemRow");
	itemRowElement.addClassName("tableRow");
	
	var itemTitle = (gipiQuoteItemObj.itemTitle == "")? "-" : gipiQuoteItemObj.itemTitle.truncate(20,"...");
	var itemDesc = (gipiQuoteItemObj.itemDesc == "" || gipiQuoteItemObj.itemDesc== null)? "-" : gipiQuoteItemObj.itemDesc.truncate(20,"...");
	var itemDescTitle  = (gipiQuoteItemObj.itemDesc == "" || gipiQuoteItemObj.itemDesc== null)? "" : gipiQuoteItemObj.itemDesc;
	var itemDesc2 = (gipiQuoteItemObj.itemDesc2 == "" || gipiQuoteItemObj.itemDesc2== null)? "-" : gipiQuoteItemObj.itemDesc2.truncate(20,"...");
	var itemDesc2Title = (gipiQuoteItemObj.itemDesc2 == "" || gipiQuoteItemObj.itemDesc2== null)? "" : gipiQuoteItemObj.itemDesc2;
	var currencyDesc = (gipiQuoteItemObj.currencyDesc == "" || gipiQuoteItemObj.currencyDesc==null)? "-" : gipiQuoteItemObj.currencyDesc.truncate(15,"...");
	var currencyDescTitle = (gipiQuoteItemObj.currencyDesc == "" || gipiQuoteItemObj.currencyDesc==null)? "-" : gipiQuoteItemObj.currencyDesc;
	var coverageDesc = (gipiQuoteItemObj.coverageDesc == "" || gipiQuoteItemObj.coverageDesc==null)? "-" : gipiQuoteItemObj.coverageDesc.truncate(15,"...");
	var coverageDescTitle = (gipiQuoteItemObj.coverageDesc == "" || gipiQuoteItemObj.coverageDesc== null)? "" : gipiQuoteItemObj.coverageDesc;
	
	itemRowElement.update(
		'<label style="width: 5%; text-align: center; margin-left: 15px;">' + gipiQuoteItemObj.itemNo + '</label>'+
		'<label style="width: 14.5%; text-align: left;" title="'+itemTitle+'">' + unescapeHTML2(itemTitle) +'</label>'+
		'<label style="width: 14%; text-align: left; margin-left: 10px;" title="'+ unescapeHTML2(itemDesc)+ '">' + 
			itemDesc + '</label>' +
		'<label style="width: 14%; text-align: left; margin-left: 10px;" title="'+ unescapeHTML2(itemDesc2)+ '">' + 
			itemDesc2 + '</label>'+
		'<label style="width: 16%; text-align: left; margin-left: 10px;" title="' + gipiQuoteItemObj.currencyDesc + '">' + 
			currencyDesc + '</label>'+
		'<label style="width: 8%; text-align: right;">' + 
			formatToNineDecimal(gipiQuoteItemObj.currencyRate) + '</label>' +
		'<label style="width: 19%; text-align: left; margin-left: 10px;" title="' + coverageDescTitle+'">' + 
			coverageDesc +'</label>');
	
	loadRowMouseOverMouseOutObserver(itemRowElement);
	
	itemRowElement.observe("click",function(){
		changeTag = 0; // Patrick 02.14.2012
		var blnEnable = true;
		
		itemRowElement.toggleClassName("selectedRow");
		if(itemRowElement.hasClassName("selectedRow")){ // SELECT

			$$("div[name='itemRow']").each(function(itemRow){
				if(itemRow.getAttribute("id") != itemRowElement.getAttribute("id")){
					itemRow.removeClassName("selectedRow");
					clearChangeAttribute("itemInformationDiv");
					clearChangeAttribute("perilInformationDiv");
					checkLineCdForAddInfoDiv();
					/* clearChangeAttribute("deductibleInformationSectionDiv");
					clearChangeAttribute("mortgageeInformationSectionDiv");
					clearChangeAttribute("mainInvoiceForm"); */
				}
			});
			
			// recheck if item will still be visible during observe
			$("txtItemNo").value = gipiQuoteItemObj.itemNo;
			$("txtItemTitle").value = unescapeHTML2(gipiQuoteItemObj.itemTitle);
			$("txtItemDesc").value = unescapeHTML2(gipiQuoteItemObj.itemDesc);
			$("txtItemDesc2").value = unescapeHTML2(gipiQuoteItemObj.itemDesc2);
			
			// find currency index
			var currencyOpts = $("selCurrency").options;
			for(var i=0; i<currencyOpts.length; i++){
				if(currencyOpts[i].getAttribute("currencyCd") == gipiQuoteItemObj.currencyCd){
					$("txtCurrencyRate").value = formatToNineDecimal(currencyOpts[i].getAttribute("currencyRate"));
					$("selCurrency").selectedIndex = i;
					i = currencyOpts.length;
				}
			}
			
			var coverageOpts = $("selCoverage");
			for(var i=0; i<coverageOpts.length; i++){
				if(coverageOpts[i].getAttribute("coverageCd")==gipiQuoteItemObj.coverageCd){
					$("selCoverage").selectedIndex = i;
					i = coverageOpts.length;
				}
			}
			
			$("btnAddItem").value = "Update";
			enableButton("btnDeleteItem");

			// subpage handlers
			var objAdditionalInfo = null;
			if (lineCd == "FI") {
				 objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemFI;
			} else if (lineCd == "AC" || lineCd == "PA") {
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemAC;
			} else if (lineCd == "MC") {
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemMC;
			} else if (lineCd == "AV") {
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemAV;
				objGIPIWItem = objGIPIQuoteItemList;
			} else if (lineCd == "EN") { 
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemEN;
			} else if (lineCd == "CA") {
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemCA;
			} else if (lineCd == "MN") {
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemMN;
			} else if (lineCd == "MH") {
				objAdditionalInfo = gipiQuoteItemObj.gipiQuoteItemMH;
			}
			
			showAdditionalInfoPage(objAdditionalInfo);
			
			showPerilInformationSubpage();
			blnEnable = (gipiQuoteItemObj == null ? true : ($$('div#itemPerilTable div[itemNo="' + $F("txtItemNo") + '"]').size() > 0 ? false : true));
			blnEnable ? $("selCurrency").enable() : $("selCurrency").disable();
			blnEnable ? $("txtCurrencyRate").removeAttribute("readonly") : $("txtCurrencyRate").setAttribute("readonly", "readonly");

			if($("invoiceAccordionLbl").innerHTML == "Hide"){
				showInvoice2(); // <--
			}

			observeDeductibleListingAndForm();
			//showInvoiceOfSelectedItem();
			if($("mortgageeAccordionLbl").innerHTML=="Hide"){
				showQuoteItemMortgagees();
			}
			showAttachedMediaPerItem();
			
		}else{    // DESELECT
			checkLineCdForAddInfoDiv();
			clearChangeAttribute("itemInformationDiv");
			clearChangeAttribute("perilInformationDiv");
			//clearChangeAttribute("deductibleInformationSectionDiv");
			//clearChangeAttribute("mortgageeInformationSectionDiv");
			//clearChangeAttribute("mainInvoiceForm");
			clearQuoteItemForm();
			$("btnAddItem").value = "Add";
			disableButton("btnDeleteItem");
			generateQuoteItemNo();
			//showAdditionalInfoPage(null); //nok
			
			blnEnable = (gipiQuoteItemObj == null ? true : ($$('div#itemPerilTable div[itemNo="' + $F("txtItemNo") + '"]').size() > 0 ? false : true));
			blnEnable ? $("selCurrency").enable() : $("selCurrency").disable();
			blnEnable ? $("txtCurrencyRate").removeAttribute("readonly") : $("txtCurrencyRate").setAttribute("readonly", "readonly");
			//observeDeductibleListingAndForm();
			showAttachedMediaPerItem();
		}
		showAccordionHeaders();
	});
	return itemRowElement;
}

function clearQuoteItemForm(){
	$("txtItemTitle").value = "";
	$("txtItemDesc").value = "";
	$("txtItemDesc2").value = "";
	var selOpts = $("selCurrency").options;

	for(var i=0; i<selOpts.length; i++){
		if(selOpts[i].hasAttribute("isDefault")){
			if(selOpts[i].getAttribute("isDefault") == "true"){
				$("txtCurrencyRate").value = formatToNineDecimal(selOpts[i].getAttribute("currencyRate"));
				$("selCurrency").selectedIndex = i;
				selOpts[i].setAttribute("selected","selected");
				i = selOpts.length;
			}
		}
	}
	
	$("selCoverage").selectedIndex = 0;
	
	$("btnAddItem").value = "Add";
	disableButton("btnDeleteItem");
}

//in item infomation
function setCurrencyLov(defaultCurrencyCd){
	var selCurrency = $("selCurrency");
	var currencyObj = null;
	selCurrency.update("<option></option>");
	for(var i=0; i<objItemCurrencyLov.length; i++){
		currencyObj = objItemCurrencyLov[i];
		var currencyOption = new Element("option");
		currencyOption.innerHTML = currencyObj.desc;
		currencyOption.setAttribute("value", currencyObj.code);
		currencyOption.setAttribute("currencyCd", currencyObj.code);
		currencyOption.setAttribute("currencyRate", currencyObj.valueFloat);
		currencyOption.setAttribute("currencyDesc", currencyObj.desc);
		if(defaultCurrencyCd!=null){
			if(defaultCurrencyCd == currencyObj.code){
				currencyOption.setAttribute("selected", "selected");
				currencyOption.setAttribute("isdefault", "true");
				$("txtCurrencyRate").value = formatToNineDecimal(currencyObj.valueFloat);
			}
		}
		selCurrency.add(currencyOption,null);
	}
}

function setCoverageLov(){
	var selCoverage = $("selCoverage");
	selCoverage.update("<option></option>");
	var coverageObj = null;
	for(var i=0; i<objItemCoverageLov.length; i++){
		coverageObj = objItemCoverageLov[i];
		var coverageOption = new Element("option");
		coverageOption.innerHTML = coverageObj.desc;
		coverageOption.setAttribute("coverageCd", coverageObj.code);
		coverageOption.setAttribute("coverageDesc", coverageObj.desc);
		coverageOption.setAttribute("value", coverageObj.code);
		selCoverage.add(coverageOption,null);
	}
}

try{
	var objDefaultCurrency = '${defaultCurrencyCd}';
	
	if(objDefaultCurrency.blank()){
		objDefaultCurrency = null;
	}
	objItemCurrencyLov = JSON.parse('${currencyLovJSON}'.replace(/\\/g, '\\\\'));
	objItemCoverageLov = JSON.parse('${coverageLovJSON}'.replace(/\\/g, '\\\\'));
	objGIPIQuoteItemList = JSON.parse('${gipiQuoteItemListJSON}'.replace(/\\/g, '\\\\'));
	{	var quoteItemObj = null;
		var quoteItemRow = null;
		for(var i=0; i<objGIPIQuoteItemList.length; i++){
			quoteItemObj = objGIPIQuoteItemList[i];
			quoteItemRow = makeGIPIQuoteItemRow(quoteItemObj);
			objGIPIQuoteItemList[i].gipiWAviationItem = quoteItemObj.gipiQuoteItemAV;
			$("quoteItemTableContainer").insert({bottom: quoteItemRow});
		}
		resetTableStyle("itemTable", "quoteItemTableContainer", "itemRow");
	}
	setCurrencyLov(objDefaultCurrency);
	setCoverageLov();

	$("editDesc").observe("click", function () {
		showEditor("txtItemDesc", 2000, ( isMakeQuotationInformationFormsHidden == 1 ? "true" : ""));
	});

	$("editDesc2").observe("click", function () {
		showEditor("txtItemDesc2", 2000,(isMakeQuotationInformationFormsHidden == 1 ? "true" : ""));
	});
	
	$("selCurrency").observe("change", function(){
		var ratez = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate");
		if(ratez!=null){
			if(ratez.blank()){
				$("txtCurrencyRate").value = formatToNineDecimal(0);
			}else{
				$("txtCurrencyRate").value = formatToNineDecimal(ratez);
			}
		}else{
			$("txtCurrencyRate").value = formatToNineDecimal(0);
		}
	});

	$("txtItemTitle").observe("keyup", function(){
		var txt = $F("txtItemTitle");
		$("txtItemTitle").value = txt.toUpperCase();
	});
	
	$("btnAddItem").observe("click", function (){
		var itemNo = $F("txtItemNo");
		var itemTitle = $F("txtItemTitle");
		var itemDesc = $F("txtItemDesc");
		var itemDesc2 = $F("txtItemDesc2");
		var currency = $F("selCurrency");
		var currencyText = $("selCurrency").options[$("selCurrency").selectedIndex].text;
		var rate = $F("txtCurrencyRate");
		var coverage = $F("selCoverage");
		var coverageText = $("selCoverage").options[$("selCoverage").selectedIndex].text;
		if(itemTitle.blank()) {
			showMessageBox("Item Title is required!", imgMessage.ERROR);
			return false;
		}else if (currency.blank() || "0.000000000" == rate) {
			showMessageBox("Currency rate is required!", imgMessage.ERROR);
			return false;
		}else if($F("txtCurrencyRate").match("-")) {
			showMessageBox("Invalid currency rate!", imgMessage.ERROR);
			return false;
		}else {
			if ($F("btnAddItem") == "Update"){
				checkLineCdForAddInfoDiv();
				clearChangeAttribute("itemInformationDiv");//clears changeattribute Patrick 01/18/2012
				var itemObjToBeUpdated = getGIPIQuoteItemFromList(itemNo); // do not base entirely on itemNo?
				for(var i=0; i<objGIPIQuoteItemList.length; i++){
					var tmp = objGIPIQuoteItemList[i];
					/*if(tmp.itemNo == itemObjToBeUpdated.itemNo && 
						tmp.quoteId == itemObjToBeUpdated.quoteId &&
						tmp.currencyCd == itemObjToBeUpdated.currencyCd){
						objGIPIQuoteItemList.pop(tmp);
					}*/
					if(tmp.itemNo == itemObjToBeUpdated.itemNo && 
						tmp.quoteId == itemObjToBeUpdated.quoteId){
						objGIPIQuoteItemList.splice(i,1);
					}
				}
				
				var itemRowToBeUpdated = getSelectedRow("itemRow");
				itemRowToBeUpdated.remove();

				var newItemObj = makeGIPIQuoteItemObject();
				newItemObj.recordStatus = 1;

				if(objGIPIQuoteItemList==null){
					objGIPIQuoteItemList = new Array();
				}
				
				objGIPIQuoteItemList.push(newItemObj);
				var newItemRow = makeGIPIQuoteItemRow(newItemObj);
				$("quoteItemTableContainer").insert({bottom: newItemRow});
			}else{
				var newItemObj = makeGIPIQuoteItemObject();
				objGIPIQuoteItemList.push(newItemObj);
				var newItemRow = makeGIPIQuoteItemRow(newItemObj);
				$("quoteItemTableContainer").insert({bottom: newItemRow});
				resetTableStyle("itemTable", "quoteItemTableContainer", "itemRow");
				//generateQuoteItemNo(); moved by: Nica 06.04.2012
			}
			showAccordionHeaders();
			clearQuoteItemForm();
			clearChangeAttribute("itemInformationDiv");//clears changeattribute Patrick 01/18/2012
			generateQuoteItemNo(); // Nica 06.04.2012 - moved here
			if($("addDeductibleForm")!=null){
				// check if deductibles info is loaded, reset its item lov	
				setQuoteDeductibleItemLov(); // ##CC
				setQuoteDeductiblePerilLov();
			}
		}
	});

// 	function resetAdditionalInformationUpdateBtn(){
// 		if($("aiUpdateBtn") != null){
			
// 		}
// 	}
	
	$("btnDeleteItem").observe("click", function(){ 
		// all subpages under this itemNo will also be deleted!
		var selectedItemRow = getSelectedRow("itemRow");
		var itemNo = $F("txtItemNo");
		if(quoteItemHasChildInformation()){
			showConfirmBox(
					"Delete Item?", 
					"Quotation Item has child information. Deleting this item will also delete related information. Proceed deleting this item?", 
					"Yes", "No", proceedDeletingChildInfo, onCancelFunc);
		}
		deleteItem(); //for deletion of item
		selectedItemRow.remove();
		resetTableStyle("itemTable", "quoteItemTableContainer", "itemRow");
		clearQuoteItemForm();
		showAccordionHeaders();
		if($("addDeductibleForm")!=null){ 
			// check if deductibles info is loaded, reset its item lov	
			setQuoteDeductibleItemLov();
		}
		generateQuoteItemNo();
	});

	function deleteItem(){
		for (var i = 0; i < objGIPIQuoteItemList.length; i++){
			if (objGIPIQuoteItemList[i].itemNo == $F("txtItemNo")){
				objGIPIQuoteItemList[i].recordStatus = -1;
				deleteItemChildValues(objGIPIQuoteItemList[i].itemNo); // also tags child elements for delete
				clearChangeAttribute("itemInformationDiv");//clears changeattribute Patrick 01/18/2012
			}
		}
	}
	
	function proceedDeletingChildInfo(){
		for(var i=0; i<objGIPIQuoteItemList.length;i++){
			var temp = objGIPIQuoteItemList[i];
			if(temp.itemNo == itemNo && temp.recordStatus != -1){
				temp.recordStatus = -1;	// todo delete child subpage values
				deleteItemChildValues(temp.itemNo);
				i = objGIPIQuoteItemList.length; // end loop
			}
		}
	}
	
	function onCancelFunc(){
		null;
	}
	
	function checkLineCdForAddInfoDiv(){//Check the clearChangeAttribute in Additional Information DIV
		if($("lineCdHidden").value == "AV" || $("lineCdHidden").value == "EN" || $("lineCdHidden").value == "MH" || $("lineCdHidden").value == "CA" || $("lineCdHidden").value == "MN" || $("lineCdHidden").value == "AC"){
			clearChangeAttribute("additionalInformationSectionDiv");
		}else if($("lineCdHidden").value == "FI" || $("lineCdHidden").value == "MC"){
			clearChangeAttribute("additionalItemInformation");
		}
	}
	initializeAll();
	generateQuoteItemNo();
	initializeChangeAttribute();
}catch(e){
	showErrorMessage("Error caught in itemInformationJSON.jsp", e);
}
</script>