<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="itemInformationMainDiv" name="itemInformationMainDiv">
	<form id="itemInformationListingForm" name="itemInformationListingForm">
		<div id="itemInformationFormDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Item Information</label> <span class="refreshers"
						style="margin-top: 0;"> <label id="itemInfoLbl" name="gro">Hide</label>
					</span>
				</div>
			</div>
			<div id="itemInformationDiv" class="sectionDiv">
				<div id="itemInformationListMainDIv" style="padding: 10px;">
					<div id="itemInformationListTableGridSectionDiv"
						style="height: 210px;">
						<div id="itemInformationListTableGridDiv">
							<div id="itemInformationListTableGrid"></div>
						</div>
					</div>
					<div id="hidden" style="display: none;">
						<input type="hidden" id="txtPremAmt" name="txtPremAmt">
						<input type="hidden" id="txtTsiAmt" name="txtTsiAmt">
						<input type="hidden" id="txtCurrencyCd" name="txtCurrencyCd">
						<input type="hidden" id="txtCoverageCd" name="txtCoverageCd">
						<input type="hidden" id="txtPackLineCd" name="txtPackLineCd">
						<input type="hidden" id="txtPackSublineCd" name="txtPackSublineCd">
						<input type="hidden" id="txtQuoteId" name="txtQuoteId">
						<input type="hidden" id="txtDateFrom" name="txtDateFrom">
						<input type="hidden" id="txtDateTo" name="txtDateTo">
					</div>
					<div style="margin: 10px;" id="quoteItemForm">
						<table cellspacing="1" border="0" style="margin: auto;">
							<tr>
								<td class="rightAligned" style="width: 100px;">Item No.</td>
								<td class="leftAligned" style="width: 210px;"><input
									id="txtItemNo" name="txtItemNo" type="text"
									style="width: 210px;" readonly="readonly" class="required rightAligned" tabindex="201"/></td>
								<td class="rightAligned" style="width: 100px;"
									name="itemTitleTd">Item Title</td>
								<td class="leftAligned"><input id="txtItemTitle"
									name="txtItemTitle" type="text" style="width: 210px;"
									maxlength="50" class="required upper" tabindex="202"/></td>
							</tr>
							<tr>
								<td class="rightAligned">Description</td>
								<td class="leftAligned" colspan="3">
									<div
										style="border: 1px solid gray; height: 20px; width: 544px;">
										<textarea id="txtItemDesc" name="txtItemDesc"
											onKeyDown="limitText(this,2000);"
											onKeyUp="limitText(this,2000);"
											style="width: 490px; border: none; height: 13px;" class="" tabindex="203"></textarea>
										<img id="editDesc" class="hover"
											src="${pageContext.request.contextPath}/images/misc/edit.png"
											style="width: 14px; height: 14px; margin: 3px; float: right;"
											alt="Edit" tabindex="204"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned"></td>
								<td class="leftAligned" colspan="3">
									<div
										style="border: 1px solid gray; height: 20px; width: 544px;">
										<textarea id="txtItemDesc2" name="txtItemDesc2"
											onKeyDown="limitText(this,2000);"
											onKeyUp="limitText(this,2000);"
											style="width: 490px; border: none; height: 13px;" class="" tabindex="205"></textarea>
										<img id="editDesc2" class="hover"
											src="${pageContext.request.contextPath}/images/misc/edit.png"
											style="width: 14px; height: 14px; margin: 3px; float: right;"
											alt="Edit" tabindex="206"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Currency</td>
								<td class="leftAligned"><select style="width: 218px;"
									id="selCurrency" name="selCurrency" tabindex="207">
										<option value="" ></option>
								</select></td>
								<td class="rightAligned">Rate</td>
								<td class="leftAligned"><input id="txtCurrencyRate"
									name="txtCurrencyRate" type="text" class="moneyRate"
									style="width: 210px;" maxlength="13" min="0.000000001"
									max="999.999999999"
									errorMsg="Invalid Currency Rate. Value should be from 0.000000001 to 999.999999999." tabindex="208"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Coverage</td>
								<td class="leftAligned"><select style="width: 218px;"
									id="selCoverage" name="selCoverage" tabindex="209">
								</select></td>
							</tr>
						</table>
						<div class="buttonsDiv" style="margin-bottom: 10px;">
							<input type="button" class="button" style="width: 90px;" id="btnAddItem" name="btnAddItem" value="Add" tabindex="210"/>
							<input type="button" class="disabledButton" style="width: 90px;" id="btnDeleteItem" name="btnDeleteItem" value="Delete" disabled="disabled" tabindex="211"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<script>
try{
	var lineCd = getLineCd(objGIPIQuote.lineCd); //getLineCdMarketing(); Gzelle 05222015 SR4112

	//initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	
	if(isMakeQuotationInformationFormsHidden == 1) {
		$("btnAddItem").hide();
		$("btnDeleteItem").hide();
	}
	
	objQuote.itemInfo = [];
	var objItemInfo = new Object(); 
	var selectedItemInfo = null;
	var selectedItemInfoRow = new Object();
	var mtgId = null;
	objItemInfo.itemInfoListTableGrid = JSON.parse('${itemInfoGrid}');
	objItemInfo.itemInfo= objItemInfo.itemInfoListTableGrid.rows || [];
	objQuote.selectedItemInfoRow = "";	//objQuote to be used in other subpages needing item infos as params
	try {
		var itemInfoListingTable = {
			url: contextPath+"/GIPIQuoteController?action=refreshQuotationListing&lineCd="+lineCd+"&quoteId="+objGIPIQuote.quoteId,
			options: {
				id : 1, 
				newRowPosition: 'bottom',
				title: '',
				width: '900px',
				height: '181px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id) {
					removeItemInfoFocus();
					mtgId = itemInfoGrid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						if(hasPendingChildRecords()){
							showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
									objQuoteGlobal.saveAllQuotationInformation, 
									function(){
										showAllRelatedDetails(y);
									}, "");	
						}else{
							showAllRelatedDetails(y);
						}
					}
				},
				onRemoveRowFocus : function(){
					if(hasPendingChildRecords()){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
								objQuoteGlobal.saveAllQuotationInformation, removeAllRelatedDetails, "");						
					}else{
						removeAllRelatedDetails();
					}
			  	},
			  	beforeSort: function(){
			  		if(hasPendingChildRecords()){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
								objQuoteGlobal.saveAllQuotationInformation, showQuotationInformation, "");						
					}
				},
			  	onSort : function(){
			  		removeAllRelatedDetails();
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						removeAllRelatedDetails();
                	},
                	onFilter: function(){
                		removeAllRelatedDetails();
                	}
				}
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id : "itemNo",
					title : "Item No.",
					width : '60px',
					type : 'number',
					titleAlign: 'right',
					align: 'right',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer : function(value){
						return lpad(value.toString(), 5, "0");					
					}
				},
				{
					id : "itemTitle",
					title : "Item Title",
					width : '172px',
					filterOption : true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : 'itemDesc itemDesc2',
					title : 'Description',
					width : '350px',
					sortable : false,					
					children : [
						{
							id : 'itemDesc',							
							width : 175,							
							sortable : false,
							editable : false,							
							renderer : function(value){
								return unescapeHTML2(value);
							}
						},
						{
							id : 'itemDesc2',							
							width : 175,
							sortable : false,
							editable : false,							
							renderer : function(value){
								return unescapeHTML2(value);
							}
						}
					            ]					
				},	
				{
					id : "currencyDesc",
					title : "Currency",
					width : '180px',
					sortable : false,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id: 'currencyRate',
					title: 'Rate',
					width: '100',
					sortable : false,
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'rate',
				}, 
				{
					id : "coverageDesc",
					width : '0',
					visible : false
				},
				{
					id: 'premAmt',
					width: '0',
					visible: false
				},
				{
					id: 'tsiAmt',
					width: '0',
					visible: false
				},
				{
					id: 'currencyCd',
					width: '0',
					visible: false
				},
				{
					id: 'coverageCd',
					width: '0',
					visible: false
				},
				{
					id: 'packLineCd',
					width: '0',
					visible: false
				},
				{
					id: 'packSublineCd',
					width: '0',
					visible: false
				},
				{
					id: 'quoteId',
					width: '0',
					visible: false
				},
				{
					id: 'dateFrom',
					width: '0',
					visible: false
				},
				{
					id: 'itemTitle',
					width: '0',
					visible: false
				},
			],
			resetChangeTag: true,
			rows: objItemInfo.itemInfo
			//id : 1
		};
		itemInfoGrid = new MyTableGrid(itemInfoListingTable);
		itemInfoGrid.pager = objItemInfo.itemInfoListTableGrid;
		itemInfoGrid.render('itemInformationListTableGrid');
		itemInfoGrid.afterRender = function(){
			objQuote.itemInfo = itemInfoGrid.geniisysRows;
			toggleButtonsForBonds("item");
		};
	}catch(e) {
		showErrorMessage("itemInfoGrid", e);
	}
	
	function removeItemInfoFocus(){
		itemInfoGrid.keys.removeFocus(itemInfoGrid.keys._nCurrentFocus, true);
		itemInfoGrid.keys.releaseKeys();
	}
	
	function setItemInfoDetails(obj) {
		try {
			$("txtPremAmt").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.premAmt,""))) :null;
			$("txtTsiAmt").value								= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.tsiAmt,""))) :null;
			$("txtCurrencyCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.currencyCd,""))) :null;
			$("txtCoverageCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.coverageCd,""))) :null;
			$("txtPackLineCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.packLineCd,""))) :null;
			$("txtPackSublineCd").value				= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.packSublineCd,""))) :null;
			$("txtQuoteId").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.quoteId,""))) :null;
			$("txtDateFrom").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dateFrom,""))) :null;
			$("txtDateTo").value								= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dateTo,""))) :null;
			$("txtItemNo").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(lpad(obj.itemNo, 5, "0"),""))) :null;
			$("txtItemTitle").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemTitle,""))) :null;
			$("txtItemDesc").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemDesc,""))) :null;
			$("txtItemDesc2").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemDesc2,""))) :null;
			$("txtCurrencyRate").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(formatToNineDecimal(obj.currencyRate),""))) :null;
			$("selCurrency").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.currencyCd,""))) :null;
			$("selCoverage").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.coverageCd,""))) :null;
			$("btnAddItem").value 							= obj == null ? "Add" : "Update";
			$("btnAddItem").value							!= "Add" ? enableButton("btnDeleteItem") : disableButton("btnDeleteItem");
			toggleButtonsForBonds("item");
		} catch(e) {
			showErrorMessage("setItemInfoDetails", e);
		}
	}
	
	function createItemInfoDtls(func){
		try {
			var itemInfo 						= new Object() ;			
			itemInfo.recordStatus 		= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			itemInfo.premAmt 			= escapeHTML2($F("txtPremAmt"));
			itemInfo.tsiAmt 					= escapeHTML2($F("txtTsiAmt"));
			itemInfo.currencyCd 			= escapeHTML2($F("selCurrency"));
			itemInfo.coverageCd 		= escapeHTML2($F("selCoverage"));
			itemInfo.packLineCd 			= escapeHTML2($F("txtPackLineCd"));
			itemInfo.packSublineCd 	= escapeHTML2($F("txtPackSublineCd"));
			itemInfo.quoteId 				= nvl(escapeHTML2($F("txtQuoteId")),objGIPIQuote.quoteId);
			itemInfo.itemNo 				= escapeHTML2($F("txtItemNo"));
			itemInfo.itemTitle 				= escapeHTML2($F("txtItemTitle"));
			itemInfo.itemDesc 				= escapeHTML2($F("txtItemDesc"));
			itemInfo.itemDesc2 			= escapeHTML2($F("txtItemDesc2"));
			itemInfo.currencyRate 		= escapeHTML2($F("txtCurrencyRate"));
			itemInfo.currencyDesc 		= $("selCurrency").options[$("selCurrency").selectedIndex].text;
			itemInfo.coverageDesc 	= $("selCoverage").options[$("selCoverage").selectedIndex].text;
			var lineCd = getLineCd(objGIPIQuote.lineCd);//getLineCdMarketing();  Gzelle 05222015 SR4112
		    if (lineCd == "AC" || lineCd == "PA"){
		    	itemInfo.gipiQuoteACItem = createAdditionalInfoAC();
		    }else if (lineCd == "FI"){
		    	itemInfo.gipiQuoteFIItem = createAdditionalInfoFI();
		    	itemInfo.dateFrom 		= nvl(escapeHTML2($F("txtNbtFromDt"), null));
				itemInfo.dateTo 		= nvl(escapeHTML2($F("txtNbtToDt"), null));
		    }else if (lineCd == "EN"){
		    	itemInfo.gipiQuoteENItem = createAdditionalInfoEN();
		    }else if(lineCd == "MH"){
		    	itemInfo.gipiQuoteMHItem = createAdditionalInfoMH();
		    }else if(lineCd == "MN"){
		    	itemInfo.gipiQuoteMNItem = createAdditionalInfoMN();
		    }else if (lineCd == "AV"){
		    	itemInfo.gipiQuoteAVItem = createAdditionalInfoAV();
		    }else if (lineCd == "MC"){
		    	itemInfo.gipiQuoteItemMC = createAdditionalInfoMC();
		    }else if(lineCd == "CA"){
		    	itemInfo.gipiQuoteCAItem = createAdditionalInfoCA();
		    }
			return itemInfo;
		} catch (e){
			showErrorMessage("createItemInfoDtls", e);
		}			
	}
	
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
	
	function getAdditionalQuoteInfo(obj){
		clearChangeAttribute("itemInformationDiv");
		checkLineCdForAddInfoDiv();
		var objAdditionalInfo = null;
		if (lineCd == "FI") {
			 objAdditionalInfo = obj.gipiQuoteFIItem;
		} else if (lineCd == "AC" || lineCd == "PA") {
			objAdditionalInfo = obj.gipiQuoteACItem;
		} else if (lineCd == "MC") {
			objAdditionalInfo = obj.gipiQuoteItemMC;
		} else if (lineCd == "AV") {
			objAdditionalInfo = obj.gipiQuoteAVItem;
		} else if (lineCd == "EN") { 
			objAdditionalInfo = obj.gipiQuoteENItem;
		} else if (lineCd == "CA") {
			objAdditionalInfo = obj.gipiQuoteCAItem;
		} else if (lineCd == "MN") {
			objAdditionalInfo = obj.gipiQuoteMNItem;
			//showMessageBox(JSON.stringify(objAdditionalInfo));
		} else if (lineCd == "MH") {
			objAdditionalInfo = obj.gipiQuoteMHItem;
		}
		showAdditionalInfoPage2(objAdditionalInfo);
	}

	var objDefaultCurrency = '${defaultCurrencyCd}';
	
	if(objDefaultCurrency.blank()){
		objDefaultCurrency = null;
	}
	objItemCurrencyLov = JSON.parse('${currencyLovJSON}'.replace(/\\/g, '\\\\'));
	objItemCoverageLov = JSON.parse('${coverageLovJSON}'.replace(/\\/g, '\\\\'));
	
	setCurrencyLov(objDefaultCurrency);
	setCoverageLov();

	$("editDesc").observe("click", function () {
		showEditor("txtItemDesc", 2000);
	});
	
	$("editDesc").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtItemDesc", 2000);
		}
	});

	$("editDesc2").observe("click", function () {
		showEditor("txtItemDesc2", 2000);
	});
	
	$("editDesc2").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtItemDesc2", 2000);
		}
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
	
	$("btnAddItem").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("quoteItemForm")){	
			var item = createItemInfoDtls($F("btnAddItem"));
			if($F("btnAddItem") == "Add"){	
				objQuote.itemInfo.push(item);
				itemInfoGrid.addBottomRow(item);
			} else {		
				itemInfoGrid.updateRowAt(item, selectedItemInfo);
				$("mortgageeInformationMotherDiv").hide();
			}
			setItemInfoDetails(null);
			clearRelatedDtls();
			generateQuoteNo();
			setCurrencyLov(objDefaultCurrency);
			setCoverageLov();
			showPerilInformation(false);
			objQuoteGlobal.toggleInfos(false);
			//nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			//objQuoteGlobal.showDeductibleInfoTG(false); 
			objQuoteGlobal.showPerilItemDeductibleInfo(false);
			objQuoteGlobal.showItemDeductibleInfo(false); 
			//objQuoteGlobal.setDeductibleInfoForm(null); 
			objQuoteGlobal.setQuotePerilItem(null); 
			objQuoteGlobal.setQuote(null);	
			//nieko 02172016 end
			clearChangeAttribute("itemInformationDiv");
			objQuoteGlobal.selected = false;
			objQuoteGlobal.hasPendingAdditional = false;
		}
	});
	
	function deleteItem(){
		var item = createItemInfoDtls("Delete");
		objQuote.itemInfo.splice(selectedItemInfo, 1, item);
		itemInfoGrid.deleteVisibleRowOnly(selectedItemInfo);
		removeAllRelatedDetails();
		//marco - 08.12.2014 - add recordStatus -1 to child records
		for(var i = 0; i < objQuote.objPeril.length; i++){
			objQuote.objPeril[i].recordStatus = -1;
		}
		for(var i = 0; i < objQuote.objMortgagee.length; i++){
			objQuote.objMortgagee[i].recordStatus = -1;
		}
		for(var i = 0; i < objQuote.objDeductibleInfo.length; i++){
			objQuote.objDeductibleInfo[i].recordStatus = -1;
		}
	}
	
	$("btnDeleteItem").observe("click", function(){
		if (nvl(itemInfoGrid,null) instanceof MyTableGrid);
		if(quoteItemHasChildInformation()){
			showConfirmBox(
					"Delete Item?", 
					"Quotation Item has child information. Deleting this item will also delete related information. Proceed deleting this item?", 
					"Yes", "No", deleteItem, "");
		}else{
			deleteItem();
		}
	});
	
	function generateQuoteNo() {
			var maxItemNo = '${maxQuoteItemNo}';
			var lastItemNo = 0;
			var rows = itemInfoGrid.geniisysRows;
			
			for ( var i = 0; i < rows.length; i++) {
				//if ((parseInt(rows[i].itemNo) > lastItemNo) && (rows[i].recordStatus != -1)) { -- marco - 09.24.2012
				if ((parseInt(removeLeadingZero(rows[i].itemNo.toString())) > lastItemNo) && (rows[i].recordStatus != -1)) {
					//lastItemNo = parseInt(rows[i].itemNo);
					lastItemNo = parseInt(removeLeadingZero(rows[i].itemNo.toString()));
				}
			}
			
			if (parseInt(maxItemNo) > parseInt(lastItemNo)) {
				lastItemNo = parseInt(maxItemNo);
			}
			$("txtItemNo").value = (parseInt(lastItemNo) + 1).toPaddedString(5);
		}

		generateQuoteNo();
		objQuoteGlobal.generatedQuoteNo = $F("txtItemNo");		

		function showAdditionalInfoPage2(obj) {
			console.log("triggered nfo");
			try {
				var lineCd = getLineCd(objGIPIQuote.lineCd);//getLineCdMarketing();  Gzelle 05222015 SR4112

				if (lineCd == "FI") {
					setAdditionalInfoFI(obj);
				} else if (lineCd == "AC" || lineCd == "PA") {
					setAdditionalInfoAC(obj);
				} else if (lineCd == "AV") {
					setAdditionalInfoAV(obj);
				} else if (lineCd == "MN") {
					setAdditionalInfoMN(obj);
				} else if (lineCd == "EN") {
					setAdditionalInfoEN(obj);
				} else if (lineCd == "CA") {
					setAdditionalInfoCA(obj);
				} else if (lineCd == "MC") {
					setAdditionalInfoMC(obj);
				} else if (lineCd == "MH") {
					setAdditionalInfoMH(obj);
				}
			} catch (e) {
				showErrorMessage("showAdditionalInfoPage2", e);
			}
		}

		function clearRelatedDtls() {
			try {
				var lineCd = getLineCd();

				switch (lineCd) {
				case "AC":
					setAdditionalInfoAC(null);
					break;
				case "CA":
					setAdditionalInfoCA(null);
					break;
				case "AV":
					setAdditionalInfoAV(null);
					break;
				case "EN":
					setAdditionalInfoEN(null);
					break;
				case "FI":
					setAdditionalInfoFI(null);
					break;
				case "MC":
					setAdditionalInfoMC(null);
					break;
				case "MH":
					setAdditionalInfoMH(null);
					break;
				case "MN":
					setAdditionalInfoMN(null);
					break;
				}
			} catch (e) {
				showErrorMessage("clearRelatedDtls", e);
			}
		}

		function setAdditionalInfoAC(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtPositionCd").value    = obj == null ? "" : obj.positionCd == null ? "" : obj.positionCd;
				$("txtNoOfPersons").value   = obj == null ? "" : obj.noOfPersons == null ? "": formatNumber(obj.noOfPersons);
				$("txtDspOccupation").value = obj == null ? "" : obj.dspOccupation == null ? "" : unescapeHTML2(obj.dspOccupation);
				$("txtDestination").value   = obj == null ? "" : obj.destination == null ? "" : unescapeHTML2(obj.destination);
				$("txtMonthlySalary").value = obj == null ? "" : obj.monthlySalary == null ? "" : formatCurrency(obj.monthlySalary);
				$("txtSalaryGrade").value   = obj == null ? "" : obj.salaryGrade == null ? "" : unescapeHTML2(obj.salaryGrade);
				$("txtDateOfBirth").value   = obj == null ? "" : obj.dateOfBirth == null ? "" : dateFormat(obj.dateOfBirth, "mm-dd-yyyy");
				$("txtCivilStatus").value   = obj == null ? "" : obj.civilStatus == null ? "" : unescapeHTML2(obj.civilStatus);
				$("txtAge").value           = obj == null ? "" : obj.age == null ? "" : obj.age;
				$("txtWeight").value        = obj == null ? "" : obj.weight == null ? "" : unescapeHTML2(obj.weight);
				$("txtHeight").value        = obj == null ? "" : obj.height == null ? "" : unescapeHTML2(obj.height);
				$("txtSex").value           = obj == null ? "" : obj.sex == null ? "" : unescapeHTML2(obj.sex);
			} catch (e) {
				showErrorMessage("setAdditionalInfoAC", e);
			}
		}

		function createAdditionalInfoAC() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.positionCd = nvl($F("txtPositionCd"), null);
				newObj.noOfPersons = nvl(unformatNumber($F("txtNoOfPersons")),
						null);
				newObj.dspOccupation = escapeHTML2($F("txtDspOccupation"));
				newObj.destination = escapeHTML2($F("txtDestination"));
				newObj.monthlySalary = nvl(
						unformatCurrencyValue($F("txtMonthlySalary")), null);
				newObj.salaryGrade = escapeHTML2($F("txtSalaryGrade"));
				newObj.dateOfBirth = nvl(escapeHTML2($F("txtDateOfBirth")),null);
				newObj.civilStatus = escapeHTML2($F("txtCivilStatus"));
				newObj.age = nvl(escapeHTML2($F("txtAge")), null);
				newObj.weight = escapeHTML2($F("txtWeight"));
				newObj.height = escapeHTML2($F("txtHeight"));
				newObj.sex = escapeHTML2($F("txtSex"));
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoAC", e);
			}
		}

		function setAdditionalInfoAV(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtVesselName").value = obj == null ? "" : obj.dspVesselName == null ? "" : unescapeHTML2(obj.dspVesselName);
				$("txtAirType").value = obj == null ? "" : obj.dspAirDesc == null ? "" : unescapeHTML2(obj.dspAirDesc);
				$("txtRpcNo").value = obj == null ? "" : obj.dspRpcNo == null ? "" : unescapeHTML2(obj.dspRpcNo);
				$("txtPurpose").value = obj == null ? "" : obj.purpose == null ? "" : unescapeHTML2(obj.purpose);
				$("txtDeductText").value = obj == null ? "" : obj.deductText == null ? "" : unescapeHTML2(obj.deductText);
				$("txtPrevUtilHrs").value = obj == null ? "": obj.prevUtilHrs == null ? "" : obj.prevUtilHrs;
				$("txtEstUtilHrs").value = obj == null ? "" : obj.estUtilHrs == null ? "" : obj.estUtilHrs;
				$("txtTotalFlyTime").value = obj == null ? "" : obj.totalFlyTime == null ? "" : obj.totalFlyTime;
				$("txtQualification").value = obj == null ? "": obj.qualification == null ? "" : unescapeHTML2(obj.qualification);
				$("txtGeogLimit").value = obj == null ? "" : obj.geogLimit == null ? "" : unescapeHTML2(obj.geogLimit);
				$("txtVesselCd").value = obj == null ? "" : obj.vesselCd == null ? "" : unescapeHTML2(obj.vesselCd);
			} catch (e) {
				showErrorMessage("setAdditionalInfoAV", e);
			}
		}

		function createAdditionalInfoAV() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.purpose = escapeHTML2($F("txtPurpose"));
				newObj.deductText = escapeHTML2($F("txtDeductText"));
				newObj.prevUtilHrs = nvl(escapeHTML2($F("txtPrevUtilHrs")),
						null);
				newObj.estUtilHrs = nvl(escapeHTML2($F("txtEstUtilHrs")), null);
				newObj.totalFlyTime = nvl(escapeHTML2($F("txtTotalFlyTime")),
						null);
				newObj.qualification = escapeHTML2($F("txtQualification"));
				newObj.geogLimit = escapeHTML2($F("txtGeogLimit"));
				newObj.vesselCd = escapeHTML2($F("txtVesselCd"));
				newObj.dspVesselName = escapeHTML2($F("txtVesselName"));
				newObj.dspAirDesc = escapeHTML2($F("txtAirType"));
				newObj.dspRpcNo = escapeHTML2($F("txtRpcNo"));
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoAV", e);
			}
		}

		function setAdditionalInfoCA(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtLocation").value = obj == null ? "" : obj.location == null ? "" : unescapeHTML2(obj.location);
				$("txtSectionOrHazardCd").value = obj == null ? "" : obj.sectionOrHazardCd == null ? "" : obj.sectionOrHazardCd;
				$("txtSectionOrHazardTitle").value = obj == null ? "" : obj.dspSectionOrHazardTitle == null ? "" : unescapeHTML2(obj.dspSectionOrHazardTitle);
				$("txtCapacityCd").value = obj == null ? "" : obj.capacityCd == null ? "" : obj.capacityCd;
				$("txtPosition").value = obj == null ? "" : obj.dspPosition == null ? "" : unescapeHTML2(obj.dspPosition);
				$("txtLimitOfLiability").value = obj == null ? "" : obj.limitOfLiability == null ? "" : unescapeHTML2(obj.limitOfLiability);
			} catch (e) {
				showErrorMessage("setAdditionalInfoCA", e);
			}
		}

		function createAdditionalInfoCA() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.location = escapeHTML2($F("txtLocation"));
				newObj.sectionOrHazardCd = escapeHTML2($F("txtSectionOrHazardCd"));
				newObj.limitOfLiability = escapeHTML2($F("txtLimitOfLiability"));
				newObj.capacityCd = nvl(escapeHTML2($F("txtCapacityCd")), null);
				newObj.dspSectionOrHazardTitle = escapeHTML2($F("txtSectionOrHazardTitle"));
				newObj.dspPosition = escapeHTML2($F("txtPosition"));
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoCA", e);
			}
		}

		function setAdditionalInfoEN(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtEnggBasicInfoNum").value = obj == null ? "" : obj.enggBasicInfonum == null ? "" : obj.enggBasicInfonum;
				$("txtConProjBussTitle").value = obj == null ? "" : obj.contractProjBussTitle == null ? "" : unescapeHTML2(obj.contractProjBussTitle);
				$("txtSiteLocation").value = obj == null ? "" : obj.siteLocation == null ? "" : unescapeHTML2(obj.siteLocation);
				$("txtConstructStartDate").value = obj == null ? "" : obj.constructStartDate == null ? "" : dateFormat(obj.constructStartDate, "mm-dd-yyyy");
				$("txtConstructEndDate").value = obj == null ? "" : obj.constructEndDate == null ? "" : dateFormat(obj.constructEndDate, "mm-dd-yyyy");
				$("txtMaintainStartDate").value = obj == null ? "" : obj.maintainStartDate == null ? "" : dateFormat(obj.maintainStartDate, "mm-dd-yyyy");
				$("txtMaintainEndDate").value = obj == null ? "" : obj.maintainEndDate == null ? "" : dateFormat(obj.maintainEndDate, "mm-dd-yyyy");
			} catch (e) {
				showErrorMessage("setAdditionalInfoEN", e);
			}
		}

		function createAdditionalInfoEN() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.enggBasicInfonum = nvl($F("txtEnggBasicInfoNum"), 1);
				newObj.contractProjBussTitle = escapeHTML2($F("txtConProjBussTitle"));
				newObj.siteLocation = escapeHTML2($F("txtSiteLocation"));
				newObj.constructStartDate = nvl(
						escapeHTML2($F("txtConstructStartDate")), null);
				newObj.constructEndDate = nvl(
						escapeHTML2($F("txtConstructEndDate")), null);
				newObj.maintainStartDate = nvl(
						escapeHTML2($F("txtMaintainStartDate")), null);
				newObj.maintainEndDate = nvl(
						escapeHTML2($F("txtMaintainEndDate")), null);
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoEN", e);
			}
		}

		function setAdditionalInfoMH(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtVesselCd").value = obj == null ? "" : obj.vesselCd == null ? "" : unescapeHTML2(obj.vesselCd);
				$("txtVesselName").value = obj == null ? "" : obj.dspVesselName == null ? "" : unescapeHTML2(obj.dspVesselName);
				$("txtVesselOldName").value = obj == null ? "" : obj.dspVesselOldName == null ? "" : unescapeHTML2(obj.dspVesselOldName);
				$("txtVestypeDesc").value = obj == null ? "" : obj.dspVestypeDesc == null ? "" : unescapeHTML2(obj.dspVestypeDesc);
				$("txtPropelSw").value = obj == null ? "" : obj.dspPropelSw == null ? "" : (obj.dspPropelSw == "S" ? "SELF-PROPELLED" : "NON-PROPELLED");
				$("txtVessClassDesc").value = obj == null ? "" : obj.dspVessClassDesc == null ? "" : unescapeHTML2(obj.dspVessClassDesc);
				$("txtHullDesc").value = obj == null ? "" : obj.dspHullDesc == null ? "" : unescapeHTML2(obj.dspHullDesc);
				$("txtRegOwner").value = obj == null ? "" : obj.dspRegOwner == null ? "" : unescapeHTML2(obj.dspRegOwner);
				$("txtRegPlace").value = obj == null ? "" : obj.dspRegPlace == null ? "" : unescapeHTML2(obj.dspRegPlace);
				$("txtGrossTon").value = obj == null ? "" : obj.dspGrossTon == null ? "" : unescapeHTML2(obj.dspGrossTon);
				$("txtVesselLength").value = obj == null ? "" : obj.dspVesselLength == null ? "" : unescapeHTML2(obj.dspVesselLength);
				$("txtYearBuilt").value = obj == null ? "" : obj.dspYearBuilt == null ? "" : obj.dspYearBuilt;
				$("txtNetTon").value = obj == null ? "" : obj.dspNetTon == null ? "" : unescapeHTML2(obj.dspNetTon);
				$("txtVesselBreadth").value = obj == null ? "" : obj.dspVesselBreadth == null ? "" : unescapeHTML2(obj.dspVesselBreadth);
				$("txtNoCrew").value = obj == null ? "" : obj.dspNoCrew == null ? "" : obj.dspNoCrew;
				$("txtDeadweight").value = obj == null ? "" : obj.dspDeadWeight == null ? "" : obj.dspDeadWeight;
				$("txtVesselDepth").value = obj == null ? "": obj.dspVesselDepth == null ? "" : unescapeHTML2(obj.dspVesselDepth);
				$("txtCrewNat").value = obj == null ? "" : obj.dspCrewNat == null ? "" : unescapeHTML2(obj.dspCrewNat);
				$("txtDryPlace").value = obj == null ? "" : obj.dryPlace == null ? "" : unescapeHTML2(obj.dryPlace);
				$("txtDryDate").value = obj == null ? "" : obj.dryDate == null ? "" : dateFormat(obj.dryDate, "mm-dd-yyyy");
				$("txtGeogLimit").value = obj == null ? "" : obj.geogLimit == null ? "" : unescapeHTML2(obj.geogLimit);
			} catch (e) {
				showErrorMessage("setAdditionalInfoMH", e);
			}
		}

		function createAdditionalInfoMH() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.vesselCd = escapeHTML2($F("txtVesselCd"));
				newObj.dryPlace = escapeHTML2($F("txtDryPlace"));
				newObj.dryDate = nvl(escapeHTML2($F("txtDryDate")), null);
				newObj.geogLimit = escapeHTML2($F("txtGeogLimit"));
				newObj.dspVesselName = escapeHTML2($F("txtVesselName"));
				newObj.dspVesselOldName = escapeHTML2($F("txtVesselOldName"));
				newObj.dspVestypeDesc = escapeHTML2($F("txtVestypeDesc"));
				newObj.dspPropelSw = escapeHTML2($F("txtPropelSw"));
				newObj.dspVessClassDesc = escapeHTML2($F("txtVessClassDesc"));
				newObj.dspHullDesc = escapeHTML2($F("txtHullDesc"));
				newObj.dspRegOwner = escapeHTML2($F("txtRegOwner"));
				newObj.dspRegPlace = escapeHTML2($F("txtRegPlace"));
				newObj.dspCrewNat = escapeHTML2($F("txtCrewNat"));
				newObj.dspGrossTon = nvl(escapeHTML2($F("txtGrossTon")), null);
				newObj.dspVesselLength = nvl(
						escapeHTML2($F("txtVesselLength")), null);
				newObj.dspYearBuilt = nvl(escapeHTML2($F("txtYearBuilt")), null);
				newObj.dspNetTon = nvl(escapeHTML2($F("txtNetTon")), null);
				newObj.dspVesselBreadth = nvl(
						escapeHTML2($F("txtVesselBreadth")), null);
				newObj.dspNoCrew = nvl(escapeHTML2($F("txtNoCrew")), null);
				newObj.dspDeadWeight = nvl(escapeHTML2($F("txtDeadweight")),
						null);
				newObj.dspVesselDepth = nvl(escapeHTML2($F("txtVesselDepth")),
						null);
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoMH", e);
			}
		}

		function setAdditionalInfoMN(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("cargoClassCd").value = obj == null ? "" : obj.cargoClassCd == null ? "" : obj.cargoClassCd;
				$("txtPackMethod").value = obj == null ? "" : obj.packMethod == null ? "" : unescapeHTML2(obj.packMethod);
				$("txtBlAwb").value = obj == null ? "" : obj.blAwb == null ? "" : unescapeHTML2(obj.blAwb);
				$("txtTranshipOrigin").value = obj == null ? "" : obj.transhipOrigin == null ? "" : unescapeHTML2(obj.transhipOrigin);
				$("txtTranshipDestination").value = obj == null ? "" : obj.transhipDestination == null ? "" : unescapeHTML2(obj.transhipDestination);
				$("txtVoyageNo").value = obj == null ? "" : obj.voyageNo == null ? "" : unescapeHTML2(obj.voyageNo);
				$("txtLcNo").value = obj == null ? "" : obj.lcNo == null ? "" : unescapeHTML2(obj.lcNo);
				$("txtEtd").value = obj == null ? "" : obj.etd == null ? "" : dateFormat(obj.etd, "mm-dd-yyyy");
				$("txtEta").value = obj == null ? "" : obj.eta == null ? "" : dateFormat(obj.eta, "mm-dd-yyyy");
				$("txtOrigin").value = obj == null ? "" : obj.origin == null ? "" : unescapeHTML2(obj.origin);
				$("txtDestn").value = obj == null ? "" : obj.destn == null ? "" : unescapeHTML2(obj.destn);
				$("txtPrintTag").value = obj == null ? "" : obj.printTag == null ? "" : obj.printTag;
				$("txtVesselCd").value = obj == null ? "" : obj.vesselCd == null ? "" : unescapeHTML2(obj.vesselCd);
				$("txtGeogCd").value = obj == null ? "" : obj.geogCd == null ? "" : obj.geogCd;
				$("cargoType").value = obj == null ? "" : obj.cargoType == null ? "" : unescapeHTML2(obj.cargoType);
				$("txtDspGeogDesc").value = obj == null ? "" : obj.dspGeogDesc == null ? "" : unescapeHTML2(obj.dspGeogDesc);
				$("txtDspVesselName").value = obj == null ? "" : obj.dspVesselName == null ? "" : unescapeHTML2(obj.dspVesselName);
				$("cargoClass").value = obj == null ? "" : obj.dspCargoClassDesc == null ? "" : unescapeHTML2(obj.dspCargoClassDesc);
				$("cargoTypeDesc").value = obj == null ? "" : obj.dspCargoTypeDesc == null ? "" : unescapeHTML2(obj.dspCargoTypeDesc);
				$("txtDspPrintTagDesc").value = obj == null ? "" : obj.dspPrintTagDesc == null ? "" : unescapeHTML2(obj.dspPrintTagDesc);
			} catch (e) {
				showErrorMessage("setAdditionalInfoMN", e);
			}
		}

		function createAdditionalInfoMN() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.cargoClassCd = nvl(escapeHTML2($F("cargoClassCd")), null);
				newObj.packMethod = escapeHTML2($F("txtPackMethod"));
				newObj.blAwb = escapeHTML2($F("txtBlAwb"));
				newObj.transhipOrigin = escapeHTML2($F("txtTranshipOrigin"));
				newObj.transhipDestination = escapeHTML2($F("txtTranshipDestination"));
				newObj.voyageNo = escapeHTML2($F("txtVoyageNo"));
				newObj.lcNo = escapeHTML2($F("txtLcNo"));
				newObj.etd = nvl(escapeHTML2($F("txtEtd")), null);
				newObj.eta = nvl(escapeHTML2($F("txtEta")), null);
				newObj.origin = escapeHTML2($F("txtOrigin"));
				newObj.destn = escapeHTML2($F("txtDestn"));
				newObj.printTag = nvl(escapeHTML2($F("txtPrintTag")), null);
				newObj.vesselCd = escapeHTML2($F("txtVesselCd"));
				newObj.geogCd = nvl(escapeHTML2($F("txtGeogCd")), null);
				newObj.cargoType = escapeHTML2($F("cargoType"));
				newObj.dspGeogDesc = escapeHTML2($F("txtDspGeogDesc"));
				newObj.dspVesselName = escapeHTML2($F("txtDspVesselName"));
				newObj.dspCargoClassDesc = escapeHTML2($F("cargoClass"));
				newObj.dspCargoTypeDesc = escapeHTML2($F("cargoTypeDesc"));
				newObj.dspPrintTagDesc = escapeHTML2($F("txtDspPrintTagDesc"));
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoMN", e);
			}
		}

		function setAdditionalInfoFI(obj) { // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtAssignee").value = obj == null ? "" : obj.assignee == null ? "" : unescapeHTML2(obj.assignee);
				$("blockId").value 	   = obj == null ? "" : obj.blockId == null ? "" : obj.blockId;
				$("txtTarfCd").value   = obj == null ? "" : obj.tarfCd == null ? "" : unescapeHTML2(obj.tarfCd);
				$("txtConstructionRemarks").value = obj == null ? "" : obj.constructionRemarks == null ? "" : unescapeHTML2(obj.constructionRemarks);
				$("txtFront").value    = obj == null ? "" : obj.front == null ? "" : unescapeHTML2(obj.front);
				$("txtRight").value    = obj == null ? "" : obj.right == null ? "" : unescapeHTML2(obj.right);
				$("txtLeft").value 	   = obj == null ? "" : obj.left == null ? ""  : unescapeHTML2(obj.left);
				$("txtRear").value 	   = obj == null ? "" : obj.rear == null ? ""  : unescapeHTML2(obj.rear);
				$("txtOccupancyRemarks").value = obj == null ? "" : obj.occupancyRemarks == null ? "" : unescapeHTML2(obj.occupancyRemarks);
				$("txtLocRisk1").value = obj == null ? "" : obj.locRisk1 == null ? "" : unescapeHTML2(obj.locRisk1);
				$("txtLocRisk2").value = obj == null ? "" : obj.locRisk2 == null ? "" : unescapeHTML2(obj.locRisk2);
				$("txtLocRisk3").value = obj == null ? "" : obj.locRisk3 == null ? "" : unescapeHTML2(obj.locRisk3);
				$("blockNo").value 	   = obj == null ? "" : obj.blockNo == null ? "" : unescapeHTML2(obj.blockNo);
				$("districtNo").value  = obj == null ? "" : obj.districtNo == null ? "" : unescapeHTML2(obj.districtNo);
				$("eqZone").value 	   = obj == null ? "" : obj.eqZone == null ? "" : unescapeHTML2(obj.eqZone);
				$("txtFrItemType").value = obj == null ? "" : obj.frItemType == null ? "" : unescapeHTML2(obj.frItemType);
				$("typhoonZone").value = obj == null ? "" : obj.typhoonZone == null ? "" : unescapeHTML2(obj.typhoonZone);
				$("floodZone").value   = obj == null ? "" : obj.floodZone == null ? "" : unescapeHTML2(obj.floodZone);
				$("txtConstructionCd").value = obj == null ? "" : obj.constructionCd == null ? "" : unescapeHTML2(obj.constructionCd);
				$("occupancyCd").value = obj == null ? "" : obj.occupancyCd == null ? "" : unescapeHTML2(obj.occupancyCd);
				$("riskCd").value 	   = obj == null ? "" : obj.riskCd == null ? "" : unescapeHTML2(obj.riskCd);
				$("txtTariffZone").value = obj == null ? "" : obj.tariffZone == null ? "" : unescapeHTML2(obj.tariffZone);
				$("txtDspFrItemType").value = obj == null ? "" : obj.dspFrItemType == null ? "" : unescapeHTML2(obj.dspFrItemType);
				$("province").value    = obj == null ? "" : obj.dspProvince == null ? "" : unescapeHTML2(obj.dspProvince);
				$("city").value        = obj == null ? "" : obj.dspCity == null ? "" : unescapeHTML2(obj.dspCity);
				$("district").value    = obj == null ? "" : obj.dspDistrictDesc == null ? "" : unescapeHTML2(obj.dspDistrictDesc);
				$("block").value       = obj == null ? "" : obj.dspBlockNo == null ? "" : unescapeHTML2(obj.dspBlockNo);
				$("risk").value        = obj == null ? "" : obj.dspRisk == null ? "" : unescapeHTML2(obj.dspRisk);
				$("eqZoneDesc").value  = obj == null ? "" : obj.dspEqZone == null ? "" : unescapeHTML2(obj.dspEqZone);
				$("typhoonZoneDesc").value = obj == null ? "" : obj.dspTyphoonZone == null ? "" : unescapeHTML2(obj.dspTyphoonZone);
				$("floodZoneDesc").value = obj == null ? "" : obj.dspFloodZone == null ? "" : unescapeHTML2(obj.dspFloodZone);
				$("txtDspTariffZone").value = obj == null ? "" : obj.dspTariffZone == null ? "" : unescapeHTML2(obj.dspTariffZone);
				$("txtDspConstructionCd").value = obj == null ? "" : obj.dspConstructionCd == null ? "" : unescapeHTML2(obj.dspConstructionCd);
				$("txtNbtFromDt").value = obj == null ? "" : obj.nbtFromDt == null ? "" : dateFormat(obj.nbtFromDt, "mm-dd-yyyy");
				$("txtNbtToDt").value = obj == null ? "" : obj.nbtToDt == null ? "" : dateFormat(obj.nbtToDt,"mm-dd-yyyy");
				$("occupancy").value = obj == null ? "" : obj.dspOccupancyCd == null ? "" : unescapeHTML2(obj.dspOccupancyCd);
				/* sr5918 Added by MarkS 02/03/2017 */
				$("txtLatitude").value = obj == null ? "" : obj.latitude == null ? "" : unescapeHTML2(obj.latitude);
				$("txtLongitude").value = obj == null ? "" : obj.longitude == null ? "" : unescapeHTML2(obj.longitude);
			} catch (e) {
				showErrorMessage("setAdditionalInfoFI", e);
			}
		}

		function createAdditionalInfoFI() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.assignee = escapeHTML2($F("txtAssignee"));
				newObj.blockId = nvl(escapeHTML2($F("blockId")), null);
				newObj.tarfCd = escapeHTML2($F("txtTarfCd"));
				newObj.constructionRemarks = escapeHTML2($F("txtConstructionRemarks"));
				newObj.front = escapeHTML2($F("txtFront"));
				newObj.right = escapeHTML2($F("txtRight"));
				newObj.left = escapeHTML2($F("txtLeft"));
				newObj.rear = escapeHTML2($F("txtRear"));
				newObj.occupancyRemarks = escapeHTML2($F("txtOccupancyRemarks"));
				newObj.locRisk1 = escapeHTML2($F("txtLocRisk1"));
				newObj.locRisk2 = escapeHTML2($F("txtLocRisk2"));
				newObj.locRisk3 = escapeHTML2($F("txtLocRisk3"));
				newObj.blockNo = escapeHTML2($F("blockNo"));
				newObj.districtNo = escapeHTML2($F("districtNo"));
				newObj.eqZone = escapeHTML2($F("eqZone"));
				newObj.frItemType = escapeHTML2($F("txtFrItemType"));
				newObj.typhoonZone = escapeHTML2($F("typhoonZone"));
				newObj.floodZone = escapeHTML2($F("floodZone"));
				newObj.constructionCd = escapeHTML2($F("txtConstructionCd"));
				newObj.occupancyCd = escapeHTML2($F("occupancyCd"));
				newObj.riskCd = escapeHTML2($F("riskCd"));
				newObj.tariffZone = escapeHTML2($F("txtTariffZone"));
				newObj.dspFrItemType = escapeHTML2($F("txtDspFrItemType"));
				newObj.dspProvince = escapeHTML2($F("province"));
				newObj.dspCity = escapeHTML2($F("city"));
				newObj.dspDistrictDesc = escapeHTML2($F("district"));
				newObj.dspBlockNo = escapeHTML2($F("block"));
				newObj.dspRisk = escapeHTML2($F("risk"));
				newObj.dspEqZone = escapeHTML2($F("eqZoneDesc"));
				newObj.dspTyphoonZone = escapeHTML2($F("typhoonZoneDesc"));
				newObj.dspFloodZone = escapeHTML2($F("floodZoneDesc"));
				newObj.dspTariffZone = escapeHTML2($F("txtDspTariffZone"));
				newObj.dspConstructionCd = escapeHTML2($F("txtDspConstructionCd"));
				newObj.dspOccupancyCd = escapeHTML2($F("occupancy"));
				newObj.nbtFromDt = nvl(escapeHTML2($F("txtNbtFromDt")), null);
				newObj.nbtToDt = nvl(escapeHTML2($F("txtNbtToDt")), null);
				/* <!--Added by MarkS 02/03/2017 */
				newObj.latitude		= $F("txtLatitude"); 
				newObj.longitude	= $F("txtLongitude");
				console.log("tesfd"+$F("txtLongitude"));
				/*  */
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoFI", e);
			}
		}

		function setAdditionalInfoMC(obj) {  // modified by: Nica 06.11.2012 - added unescapeHTML2
			try {
				$("txtAssignee").value 	   = obj == null ? "" : obj.assignee == null ? "" : unescapeHTML2(obj.assignee);
				$("txtAcquiredFrom").value = obj == null ? "" : obj.acquiredFrom == null ? "" : unescapeHTML2(obj.acquiredFrom);
				$("txtOrigin").value       = obj == null ? "" : obj.origin == null ? "" : unescapeHTML2(obj.origin);
				$("txtDestination").value  = obj == null ? "" : obj.destination == null ? "" : unescapeHTML2(obj.destination);
				$("txtPlateNo").value      = obj == null ? "" : obj.plateNo == null ? "" : unescapeHTML2(obj.plateNo);
				$("txtModelYear").value    = obj == null ? "" : obj.modelYear == null ? "" : unescapeHTML2(obj.modelYear);
				$("txtMvFileNo").value     = obj == null ? "" : obj.mvFileNo == null ? "" : unescapeHTML2(obj.mvFileNo);
				$("txtNoOfPass").value     = obj == null ? "" : obj.noOfPass == null ? "" : obj.noOfPass;
				$("basicColorCd").value    = obj == null ? "" : obj.basicColorCd == null ? "" : unescapeHTML2(obj.basicColorCd);
				$("color").value           = obj == null ? "" : obj.color == null ? "" : unescapeHTML2(obj.color);
				$("txtTowing").value       = obj == null ? "" : obj.towing == null ? "" : obj.towing;
				$("towing").value          = obj == null ? "" : obj.towing == null ? "" : obj.towing;
				$("txtCocType").value      = obj == null ? "" : obj.cocType == null ? "" : unescapeHTML2(obj.cocType);
 				$("txtCocSerialNo").value  = obj == null ? "" : obj.cocSerialNo == null ? "" : /* unescapeHTML2 */obj.cocSerialNo; //remove by steven 1/8/2013  "unescapeHTML2" it causes a javascript error:ERROR MESSAGE: str.stripTags is not a function,saka ok lang kahit wala ung "unescapeHTML2" kasi number lang pwede i-enter dyan.
				$("txtCocYy").value        = obj == null ? "" : obj.cocYy == null ? "" : obj.cocYy;
				$("txtCtvTag").value       = obj == null ? "" : obj.ctvTag == null ? "" : unescapeHTML2(obj.ctvTag);
				$("chkCtv").checked        = obj == null ? "" : obj.ctvTag == "Y" ? true : false;
				$("txtTypeOfBodyCd").value = obj == null ? "" : obj.typeOfBodyCd == null ? "" : obj.typeOfBodyCd;
				$("txtCarCompanyCd").value = obj == null ? "" : obj.carCompanyCd == null ? "" : obj.carCompanyCd;
				$("txtMake").value         = obj == null ? "" : obj.make == null ? "" : unescapeHTML2(obj.make);
				$("txtSeriesCd").value     = obj == null ? "" : obj.seriesCd == null ? "" : obj.seriesCd;
				$("txtMotType").value      = obj == null ? "" : obj.motType == null ? "" : obj.motType;
				$("txtUnladenWt").value    = obj == null ? "" : obj.unladenWt == null ? "" : unescapeHTML2(obj.unladenWt);
				$("txtSerialNo").value     = obj == null ? "" : obj.serialNo == null ? "" : unescapeHTML2(obj.serialNo);
				$("txtSublineTypeCd").value = obj == null ? "": obj.sublineTypeCd == null ? "" : obj.sublineTypeCd;
				$("txtMotorNo").value      = obj == null ? "" : obj.motorNo == null ? "" : unescapeHTML2(obj.motorNo);
				$("txtMakeCd").value       = obj == null ? "" : obj.makeCd == null ? "" : obj.makeCd;
				$("colorCd").value         = obj == null ? "" : obj.colorCd == null ? "" : obj.colorCd;
				$("basicColor").value      = obj == null ? "" : obj.dspBasicColor == null ? "" : unescapeHTML2(obj.dspBasicColor);
				$("txtRepairLim").value    = obj == null ? "" : obj.repairLim == null ? "" : obj.repairLim;
				$("txtDspDeductibles").value = obj == null ? "" : obj.dspDeductibles == null ? "" : obj.dspDeductibles;
				$("txtDspRepairLim").value = obj == null ? "" : obj.dspRepairLim == null ? "" : obj.dspRepairLim;
				$("txtDspTypeOfBodyCd").value = obj == null ? "" : obj.dspTypeOfBodyCd == null ? "" : unescapeHTML2(obj.dspTypeOfBodyCd);
				$("txtDspCarCompanyCd").value = obj == null ? "" : obj.dspCarCompanyCd == null ? "" : unescapeHTML2(obj.dspCarCompanyCd);
				$("txtDspEngineSeries").value = obj == null ? "" : obj.dspEngineSeries == null ? "" : unescapeHTML2(obj.dspEngineSeries);
				$("txtDspMotType").value = obj == null ? "" : obj.dspMotType == null ? "" : unescapeHTML2(obj.dspMotType);
				$("txtDspSublineTypeCd").value = obj == null ? "" : obj.dspSublineTypeCd == null ? "" : unescapeHTML2(obj.dspSublineTypeCd);
			} catch (e) {
				showErrorMessage("setAdditionalInfoMC", e);
			}
		}

		function createAdditionalInfoMC() {
			try {
				var newObj = {};
				newObj.quoteId = objGIPIQuote.quoteId;
				newObj.itemNo = $F("txtItemNo");
				newObj.sublineCd = objGIPIQuote.sublineCd;
				newObj.assignee = escapeHTML2($F("txtAssignee"));
				newObj.acquiredFrom = escapeHTML2($F("txtAcquiredFrom"));
				newObj.origin = escapeHTML2($F("txtOrigin"));
				newObj.destination = escapeHTML2($F("txtDestination"));
				newObj.plateNo = escapeHTML2($F("txtPlateNo"));
				newObj.modelYear = escapeHTML2($F("txtModelYear"));
				newObj.mvFileNo = escapeHTML2($F("txtMvFileNo"));
				newObj.noOfPass = nvl($F("txtNoOfPass"), null);
				newObj.basicColorCd = escapeHTML2($F("basicColorCd"));
				newObj.color = escapeHTML2($F("color"));
				newObj.towing = nvl(unformatCurrencyValue($F("txtTowing")),
						null);
				newObj.cocType = escapeHTML2($F("txtCocType"));
				newObj.cocSerialNo = nvl($F("txtCocSerialNo"), null);
				newObj.cocYy = nvl($F("txtCocYy"), null);
				newObj.ctvTag = escapeHTML2($F("txtCtvTag"));
				newObj.typeOfBodyCd = nvl($F("txtTypeOfBodyCd"), null);
				newObj.carCompanyCd = nvl($F("txtCarCompanyCd"), null);
				newObj.make = escapeHTML2($F("txtMake"));
				newObj.seriesCd = nvl($F("txtSeriesCd"), null);
				newObj.motType = nvl($F("txtMotType"), null);
				newObj.unladenWt = escapeHTML2($F("txtUnladenWt"));
				newObj.serialNo = escapeHTML2($F("txtSerialNo"));
				newObj.sublineTypeCd = escapeHTML2($F("txtSublineTypeCd"));
				newObj.motorNo = escapeHTML2($F("txtMotorNo"));
				newObj.makeCd = nvl($F("txtMakeCd"), null);
				newObj.colorCd = nvl($F("colorCd"), null);
				newObj.dspBasicColor = escapeHTML2($F("basicColor"));
				newObj.dspDeductibles = escapeHTML2($F("txtDspDeductibles"));
				newObj.dspRepairLim = escapeHTML2($F("txtDspRepairLim"));
				newObj.dspTypeOfBodyCd = escapeHTML2($F("txtDspTypeOfBodyCd"));
				newObj.dspCarCompanyCd = escapeHTML2($F("txtDspCarCompanyCd"));
				newObj.dspEngineSeries = escapeHTML2($F("txtDspEngineSeries"));
				newObj.dspMotType = escapeHTML2($F("txtDspMotType"));
				newObj.dspSublineTypeCd = escapeHTML2($F("txtDspSublineTypeCd"));
				return newObj;
			} catch (e) {
				showErrorMessage("createAdditionalInfoMC", e);
			}
		}

		function showPerilInformation(show){	
			try{
				/*var quoteIdTG = show ? objGIPIQuote.quoteId : "";
				var itemNoTG = show ? selectedItemInfoRow.itemNo : "";
				var lineCdTG = show ? objGIPIQuote.lineCd : "";
				var packLineCdTG = show ? selectedItemInfoRow.packLineCd : "";
				
				perilTableGrid.url = contextPath+"/GIPIQuoteItmPerilController?action=getPerilInfoListing&refresh=1&quoteId="+quoteIdTG+
										"&itemNo="+itemNoTG+"&lineCd="+lineCdTG+"&packLineCd="+packLineCdTG;
				perilTableGrid._refreshList();*/ // moved by: Nica 06.19.2012
				
				if(show){
					var quoteIdTG = show ? objGIPIQuote.quoteId : "";
					var itemNoTG = show ? selectedItemInfoRow.itemNo : "";
					var lineCdTG = show ? objGIPIQuote.lineCd : "";
					var packLineCdTG = show ? selectedItemInfoRow.packLineCd : "";
					
					perilTableGrid.url = contextPath+"/GIPIQuoteItmPerilController?action=getPerilInfoListing&refresh=1&quoteId="+quoteIdTG+
											"&itemNo="+itemNoTG+"&lineCd="+lineCdTG+"&packLineCd="+packLineCdTG;
					perilTableGrid._refreshList(); // moved here - Nica
					
					enableSearch("searchPerilName");
					$("perilRate").readOnly = false;
					$("perilTsiAmt").readOnly = false;
					$("perilPremAmt").readOnly = false;
					$("perilRemarks").readOnly = false;
				}else{
					// added by: Nica 06.19.2012 - just clear the details of the table and 
					// does not reload peril page which causes the objQuote.objPeril to reset
					if($("perilInformationTGDiv") != null){
						clearTableGridDetails(perilTableGrid); 
					}
					disableSearch("searchPerilName");
					$("perilRate").readOnly = true;
					$("perilTsiAmt").readOnly = true;
					$("perilPremAmt").readOnly = true;
					$("perilRemarks").readOnly = true;
				}
			}catch(e){
				showErrorMessage("showPerilInformation",e);
			}
		}
	} catch (e) {
		showErrorMessage("itemInformation page", e);
	}

	
	/**
	 * @author rey
	 * @date 06-05-2012
	 */	
	function showMortgagee2(show){
		try{	
			/*mortgageeTableGrid.url = contextPath+ "/GIPIQuoteItmMortgageeController?action=getMortgageeList&refresh=1&quoteId="
												+ (show ? objGIPIQuote.quoteId : "") + "&itemNo=" + (show ? $("itemNoHid").value : "")
												+ "&issCd=" + (show ? objGIPIQuote.issCd : "");
			mortgageeTableGrid._refreshList();*/ // replaced by : Nica 06.19.2012
			if(show){
				mortgageeTableGrid.url = contextPath+ "/GIPIQuoteItmMortgageeController?action=getMortgageeList&refresh=1&quoteId="
										 + objGIPIQuote.quoteId + "&itemNo=" + $("itemNoHid").value
										 + "&issCd=" + objGIPIQuote.issCd;
				mortgageeTableGrid._refreshList();
			}else{ // added by: Nica 06.19.2012
				if($("mortgageeTableGrid") != null){
					clearTableGridDetails(mortgageeTableGrid); 
				}
			}
		}catch(e){
			showErrorMessage("showMortgagee2",e);
		}
	}
	
	function hasPendingChildRecords(){
		var hasPendingRecords = false;
		var hasPendingDeductibles = false;
		var hasPendingPerils = false;
		var hasPendingMortgagees = false;
		hasPendingDeductibles = getAddedAndModifiedJSONObjects(objQuote.objDeductibleInfo).length > 0 || getDeletedJSONObjects(objQuote.objDeductibleInfo).length > 0 ? true : false;
		hasPendingPerils = getAddedAndModifiedJSONObjects(objQuote.objPeril).length > 0 || getDeletedJSONObjects(objQuote.objPeril).length > 0 ? true : false;
		hasPendingMortgagees = getAddedAndModifiedJSONObjects(objQuote.objMortgagee).length > 0 || getDeletedJSONObjects(objQuote.objMortgagee).length > 0 ? true : false;
		if(hasPendingDeductibles || hasPendingPerils || hasPendingMortgagees || objQuoteGlobal.hasPendingAdditional){
			hasPendingRecords = true;
		}
		return hasPendingRecords;
	}
	
	function showAllRelatedDetails(y){
		selectedItemInfo = y;
		selectedItemInfoRow = itemInfoGrid.geniisysRows[y];
		setItemInfoDetails(selectedItemInfoRow);
		getAdditionalQuoteInfo(selectedItemInfoRow);
		objQuote.selectedItemInfoRow = itemInfoGrid.geniisysRows[y];
		showPerilInformation(true);
		$("itemNoHid").value = selectedItemInfoRow.itemNo;
		showMortgagee2(true);
		//nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		//objQuoteGlobal.showDeductibleInfoTG(false); 
		objQuoteGlobal.showPerilItemDeductibleInfo(false); 
		objQuoteGlobal.showItemDeductibleInfo(true);  
		//objQuoteGlobal.setDeductibleInfoForm(null); 
		objQuoteGlobal.setQuotePerilItem(null); 
		objQuoteGlobal.setQuote(null);				  
		//nieko 02172016 end
		objQuoteGlobal.selected = true;
		toggleSelCurrency(false);
	}
	
	function removeAllRelatedDetails(){
		//deleteItemAttachments();
		setItemInfoDetails(null);
		removeItemInfoFocus();
		clearRelatedDtls();
		setCurrencyLov(objDefaultCurrency);
		objQuote.selectedItemInfoRow = null;
		generateQuoteNo();
		objQuote.selectedItemInfoRow = "";
		showPerilInformation(false);
		showMortgagee2(false);
		// nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		//objQuoteGlobal.showDeductibleInfoTG(false); 
		objQuoteGlobal.showPerilItemDeductibleInfo(false); 
		objQuoteGlobal.showItemDeductibleInfo(false); 
		//objQuoteGlobal.setDeductibleInfoForm(null); 
		objQuoteGlobal.setQuotePerilItem(null); 
		objQuoteGlobal.setQuote(null);				  
		$("totalDeductibleAmount2").value = ""; 
		$("totalDeductibleAmount3").value = ""; 
		// nieko 02172016 end
		objQuoteGlobal.selected = false;
		toggleSelCurrency(true);
	}
	
	function quoteItemHasChildInformation(){
		if(objQuote.objPeril !=null){
			for(var i=0; i<objQuote.objPeril.length; i++){
				return true;
			}
		}
		if(objQuote.objMortgagee !=null){
			for(var i=0; i<objQuote.objMortgagee.length; i++){
				return true;
			}
		}
		return false;
	}
	
	function toggleSelCurrency(enable){
		if(enable){
			$("selCurrency").enable();
			$("txtCurrencyRate").readOnly = false;
		}else{			
			(nvl(perilTableGrid.rows, "") != "") ? $("selCurrency").disable() : $("selCurrency").enable();
			(nvl(perilTableGrid.rows, "") != "") ? $("txtCurrencyRate").readOnly = true : $("txtCurrencyRate").readOnly = false;
		}
	}
	
	$("txtCurrencyRate").observe("focus", function(){
		if($F("selCurrency") == "1"){
			customShowMessageBox("Currency Rate for Philippine Peso cannot be updated.", "E", "selCurrency");
		}
	});
	
	/* function deleteItemAttachments() {
		new Ajax.Request(contextPath + "/GIPIQuotePicturesController", {
			parameters: {
				action: "deleteItemAttachments",
				quoteId: objGIPIQuote.quoteId,
				itemNo: removeLeadingZero($F("txtItemNo"))
			}
		});
	} */
	
</script>
