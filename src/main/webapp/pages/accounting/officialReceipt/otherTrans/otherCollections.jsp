<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv" id="otherCollectionDiv">

	<div id="otherCollectionTableGridDiv" style="padding: 10px;">
		<div id="otherCollectionTableGrid" style="height: 224px;"></div>
	</div>
	<div style="width: 900px; padding-bottom: 40px;">
		<table align="right" style="padding-right: 6px;">
			<tr>
				<td class="rightAligned">Total Collection:</td>
				<td><input class="rightAligned" type="text" id="txtClnAmtTotal"
					readonly="readonly" style="width: 105px;" /></td>
			</tr>
		</table>
	</div>
	<div id="otherCollectionFormDiv" name="otherCollectionFormDiv">
		<table align="center">
			<tr>
				<td class="rightAligned"">Item No.</td>
				<td class="leftAligned"><input type="text" id="txtItemNoClns" name="Item No" style="width: 150px;" class="rightAligned required" maxlength="2" tabIndex="197" /></td>
				<td class="rightAligned" style="padding-left: 20px;">Tran Type</td>
				<td class="leftAligned">
					<input type="text" id="txtTranTypeClns" style="width: 59px;" value="" tabIndex="198" class="rightAligned required" /> 
					<input type="text" id="txtTranMeaningClns" style="width: 250px;" value="" tabIndex="199" readonly="readonly" /> 
					<img id="hrefTranTypeClns" name="imgSearch" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" style="float: right;" tabIndex="200" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Old Item No.</td>
				<td class="leftAligned">	
					<div style="width: 180px;">
						<input type="text" id="txtOldItemNoClns" name="Old Item No" style="width: 150px;" class="rightAligned refund" maxlength="2" tabIndex="201" readonly="readonly" /> 
						<img id="hrefOldItemNoClns" name="imgSearch" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" style="float: right;" tabIndex="202" />
					</div>
				</td>
				<td class="rightAligned" style="padding-left: 20px;">Old Tran No.</td>
				<td class="leftAligned">
					<div style="width: 190px;">
						<input type="text" id="txtTranYearClns" name="Old Tran No" maxLength="4" style="width: 59px;" value="" class="rightAligned refund" tabIndex="203" readonly="readonly" />
						<input type="text" id="txtTranMonthClns" name="Old Tran No" maxLength="2" style="width: 25px;" value="" class="rightAligned refund" tabIndex="204" readonly="readonly" />
						<input type="text" id="txtTranSeqNoClns" name="Old Tran No" maxLength="5" style="width: 50px;" value="" class="rightAligned refund" tabIndex="205" readonly="readonly" />
						<img id="hrefOldTranNoClns" name="imgSearch" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" style="float: right;" tabIndex="206" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Amount</td>
				<td class="leftAligned" colspan="3"><input type="text" id="txtAmountClns" style="width: 231px;" value="" class="rightAligned required" tabIndex="207" readonly="readonly" maxlength="25" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Account Code</td>
				<td class="leftAligned">
					<input type="text" id="txtGlAcctCategoryClns" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="208" readonly="readonly" />
					<input type="text" id="txtGlControlAcctClns" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="209" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns1" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="210" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns2" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="211" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns3" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="212" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns4" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="213" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns5" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="214" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns6" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="215" readonly="readonly" />
					<input type="text" id="txtAcctCode1Clns7" style="width: 15px;" maxLength="2" class="rightAligned acctCds" tabIndex="216" readonly="readonly" />
					<img id="hrefAcctCodeClns" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" style="float: right;" tabIndex="217" />
				</td>
				<td class="rightAligned" style="padding-left: 20px;">Account Name</td>
				<td class="leftAligned"><input type="text" id="txtAcctNameClns" style="width: 319px;" tabIndex="218" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned">SL Code</td>
				<td class="leftAligned">
					<input type="text" id="txtSlCodeClns" style="width: 231px;" class="rightAligned" tabIndex="219" readonly="readonly" maxLength="12" />
					<img id="hrefSlCodeClns" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" style="float: right;" tabIndex="220" />
				</td>
				<td class="rightAligned" style="padding-left: 20px;">SL Name</td>
				<td class="leftAligned"><input id="txtSlNameClns" type="text"
					value="" style="width: 319px;" tabIndex="221" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Particulars</td>
				<td class="leftAligned" colspan="3">
					<div id="otherCollectionsParticularsDiv" style="border: 1px solid gray; height: 21px; width: 695px;">
						<input type="text" id="txtParticularsClns" style="width: 665px; border: none; height: 13px; float: left;" tabIndex="222" maxlength="500" />
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="hrefParticularsClns" tabIndex="223" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin-top: 30px; margin-bottom: 10px;">
		<input type="button" style="width: 90px;" id="btnAddClns" name="btnAddClns" class="button cancelORBtn" value="Add" tabIndex="224" />
		<input type="button" style="width: 90px;" id="btnDeleteClns" name="btnDeleteClns" class="button" value="Delete" tabIndex="225" />
	</div>
</div>
<div id="otherCollectionsFormButtonsDiv" class="buttonsDiv" style="float: left; width: 100%;">
	<input type="button" style="width: 90px;" id="btnCancelClns" name="btnCancelClns" class="button" value="Cancel" tabIndex="226" />
	<input type="button" style="width: 90px;" id="btnSaveClns" name="btnCancelClns" class="button cancelORBtn" value="Save" tabIndex="227" />
</div>
<div>
	<input type="hidden" id="hidAcctIdClns" />
	<input type="hidden" id="hidGotcTranIdClns" />
</div>
<script type="text/javascript">
	setModuleId("GIACS015");
	setDocumentTitle("Other Collection");
	var itemNo = null;
	searchDisable(true);
	enableSearch("hrefTranTypeClns");
	var reverseAmt = null;
	var saveOn = null;
	addAmt = null;
	delAmt = null;
	changeTag = 0;
	disableButton("btnDeleteClns");
	lastValidAmt = "";
	try {
		var row = 0;
		var objOtherCollections = [];
		var objOtherCollns = new Object();
		objOtherCollns.objOtherCollections = JSON.parse('${jsonOtherCollns}'.replace(/\\/g, '\\\\'));
		objOtherCollns.otherColelctions = objOtherCollns.objOtherCollections.rows || [];

		var otherCollectionTableGrid = {
			url : contextPath + "/GIACOtherCollnsController?action=getGIACOtherCollns&gaccTranId=" + objACGlobal.gaccTranId + "&fundCd=" + objACGlobal.fundCd,
			options : {
				height : '200px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					otherCollection = otherCollectionsGrid.geniisysRows[y];
					populateOtherCollns(otherCollection);
					searchDisable(true);
					disableFormFilelds(true);
					disableButton("btnAddClns");
					enableButton("btnDeleteClns");
					otherCollectionsGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					populateOtherCollns(null);
					searchDisable(true);
					enableButton("btnAddClns");
					enableSearch("hrefTranTypeClns");
					disableButton("btnDeleteClns");
					$("txtItemNoClns").readOnly = false;
					$("txtTranTypeClns").readOnly = false;
					$("txtItemNoClns").value  = itemNo;
					$("txtSlCodeClns").readOnly = true;
					$("txtSlCodeClns").removeClassName("required");
					$("txtSlCodeClns").setStyle({backgroundColor: '#FFFFFF'});
					otherCollectionsGrid.keys.releaseKeys();
				},
				beforeSort : function() {
					if (changeTag == 1){
			    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
			    	} else {
			    		otherCollectionsGrid.onRemoveRowFocus();
			    	}
				},
				onSort : function() {
					if (changeTag == 1){
			    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
			    	} else {
			    		otherCollectionsGrid.onRemoveRowFocus();
			    	}
				},
				prePager : function() {
					if (changeTag == 1){
			    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
			    	} else {
			    		otherCollectionsGrid.onRemoveRowFocus();
			    	}
				},
				onRefresh : function() {
					if (changeTag == 1){
			    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
			    	} else {
			    		otherCollectionsGrid.onRemoveRowFocus();
			    	}
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						if (changeTag == 1){
				    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
				    	} else {
				    		otherCollectionsGrid.onRemoveRowFocus();
				    	}
					}
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'itemNo',
				title : 'Item No',
				width : '60px',
				visible : true,
				filterOption : true,
				align : 'right',
				titleAlign : 'right'
			}, {
				id : 'tranTypeDesc',
				title : 'Transaction Type',
				width : '125px',
				visible : true,
				filterOption : true
			}, {
				id : 'oldTransNo',
				title : 'Old Transaction No',
				width : '120px',
				visible : true,
				filterOption : true
			}, {
				id : 'oldItemNo',
				title : 'Old Item No',
				width : '70px',
				visible : true,
				filterOption : true,
				align : 'right',
				titleAlign : 'right'
			}, {
				id : 'dspAccountName',
				title : 'Account Name',
				width : '200px',
				visible : true,
				filterOption : true
			}, {
				id : 'particulars',
				title : 'Particulars',
				width : '168px',
				visible : true,
				filterOption : true
			}, {
				id : 'collectionAmt',
				title : 'Collection Amount',
				width : '110px',
				visible : true,
				filterOption : true,
				align : 'right',
				titleAlign : 'right',
				renderer : function(value) {
					return formatCurrency(value);
				}
			}, {
				id : 'dspTranYear',
				width : '0px',
				visible : false
			}, {
				id : 'dspTranMonth',
				width : '0px',
				visible : false
			}, {
				id : 'dspTranSeqNo',
				width : '0px',
				visible : false
			}, {
				id : 'maxItem',
				width : '0px',
				visible : false
			}, {
				id : 'totalAmounts',
				width : '0px',
				visible : false
			} ],
			rows : objOtherCollns.otherColelctions
		};
		otherCollectionsGrid = new MyTableGrid(otherCollectionTableGrid);
		otherCollectionsGrid.pager = objOtherCollns.objOtherCollections;
		otherCollectionsGrid.render('otherCollectionTableGrid');
		otherCollectionsGrid.afterRender = function(){
			objOtherCollections = otherCollectionsGrid.geniisysRows;
			if(otherCollectionsGrid.geniisysRows.length > 0){
				var rec = otherCollectionsGrid.geniisysRows[0];
				$("txtItemNoClns").value = parseInt(rec.maxItem) + 1;
				itemNo = parseInt($("txtItemNoClns").value);
				$("txtClnAmtTotal").value = formatCurrency(rec.totalAmounts);
			} else {
				$("txtItemNoClns").value = 1;
				itemNo = parseInt($("txtItemNoClns").value);
				$("txtClnAmtTotal").value = formatCurrency(0);
			}	
		};
	} catch (e) {
		showErrorMessage("Other Collections Table", e);
	}
	
	function populateOtherCollns(obj) {
		try {
			$("txtItemNoClns").value 			= obj == null ? "" : obj.itemNo;
			$("txtTranTypeClns").value 			= obj == null ? "" : (obj.transactionType);
			$("txtTranMeaningClns").value 		= obj == null ? "" : unescapeHTML2(obj.tranTypeMeaning);
			$("txtTranYearClns").value 			= obj == null ? "" : obj.dspTranYear;
			$("txtTranMonthClns").value 		= obj == null ? "" : obj.dspTranMonth;
			$("txtTranSeqNoClns").value 		= obj == null ? "" : obj.dspTranSeqNo; 
			$("txtGlAcctCategoryClns").value	= obj == null ? "" : formatNumberDigits(obj.glAcctCategory, 2);
			$("txtGlControlAcctClns").value 	= obj == null ? "" : formatNumberDigits(obj.glControlAcct, 2);
			$("txtAcctCode1Clns1").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct1, 2);
			$("txtAcctCode1Clns2").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct2, 2);
			$("txtAcctCode1Clns3").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct3, 2);
			$("txtAcctCode1Clns4").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct4, 2);
			$("txtAcctCode1Clns5").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct5, 2);
			$("txtAcctCode1Clns6").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct6, 2);
			$("txtAcctCode1Clns7").value 		= obj == null ? "" : formatNumberDigits(obj.glSubAcct7, 2);
			$("txtAcctNameClns").value 			= obj == null ? "" : unescapeHTML2(obj.dspAccountName);
			$("txtSlCodeClns").value 			= obj == null ? "" : obj.slCd == null || obj.slCd == ""? "" : formatNumberDigits(obj.slCd, 12);
			$("txtSlNameClns").value 			= obj == null ? "" : unescapeHTML2(obj.dspSlName);
			$("txtParticularsClns").value 		= obj == null ? "" : unescapeHTML2(obj.particulars);
			$("txtAmountClns").value 			= obj == null ? "" : formatCurrency(obj.collectionAmt);
			$("txtOldItemNoClns").value 		= obj == null ? "" : obj.oldItemNo;
			delAmt								= obj == null ? "" : obj.collectionAmt;
		} catch (e) {
			showErrorMessage("Populate other collection", e);
		}
	}

	function setOtherCollnsTableValues(){
		var rowOtherCollns = new Object(); 
		rowOtherCollns.gaccTranId	 	= objACGlobal.gaccTranId;
		rowOtherCollns.itemNo	 		= $("txtItemNoClns").value;
		rowOtherCollns.transactionType	= $("txtTranTypeClns").value;
		rowOtherCollns.collectionAmt	= $("txtAmountClns").value;
		rowOtherCollns.glAcctId	 		= $("hidAcctIdClns").value;
		rowOtherCollns.glAcctCategory	= $("txtGlAcctCategoryClns").value;
		rowOtherCollns.glControlAcct	= $("txtGlControlAcctClns").value;
		rowOtherCollns.glSubAcct1	 	= $("txtAcctCode1Clns1").value;
		rowOtherCollns.glSubAcct2	 	= $("txtAcctCode1Clns2").value;
		rowOtherCollns.glSubAcct3	 	= $("txtAcctCode1Clns3").value;
		rowOtherCollns.glSubAcct4	 	= $("txtAcctCode1Clns4").value;
		rowOtherCollns.glSubAcct5	 	= $("txtAcctCode1Clns5").value;
		rowOtherCollns.glSubAcct6	 	= $("txtAcctCode1Clns6").value;
		rowOtherCollns.glSubAcct7	 	= $("txtAcctCode1Clns7").value;
		rowOtherCollns.gotcGaccTranId	= $("hidGotcTranIdClns").value;
		rowOtherCollns.gotcItemNo	 	= $("txtOldItemNoClns").value;
		rowOtherCollns.orPrintTag	 	= "N";
		rowOtherCollns.slCd	 			= $("txtSlCodeClns").value;
		rowOtherCollns.dspSlName	 	= escapeHTML2($("txtSlNameClns").value);
		rowOtherCollns.particulars	 	= escapeHTML2($("txtParticularsClns").value);
		rowOtherCollns.tranTypeDesc	 	= $("txtTranTypeClns").value + " - " + $("txtTranMeaningClns").value;
		rowOtherCollns.dspAccountName	= $("txtAcctNameClns").value;
		rowOtherCollns.oldItemNo	 	= $("txtOldItemNoClns").value;
		rowOtherCollns.oldTransNo	 	= $("txtOldItemNoClns").value == "" ? "" : $("txtTranYearClns").value + " - " + $("txtTranMonthClns").value + " - " +  $("txtTranSeqNoClns").value;
		rowOtherCollns.dspTranYear 		= $("txtTranYearClns").value;
		rowOtherCollns.dspTranMonth 	= $("txtTranMonthClns").value;
		rowOtherCollns.dspTranSeqNo 	= $("txtTranSeqNoClns").value;
		rowOtherCollns.tranTypeMeaning	= $("txtTranMeaningClns").value;
		addAmt							= unformatCurrency("txtAmountClns");
		return rowOtherCollns;                         
	}
	
	function disableFormFilelds(read) {
		try {
			$$("div#otherCollectionFormDiv input[type='text']").each(function(a) {
				$(a).readOnly = read;
				$("txtSlCodeClns").readOnly = true;
				$("txtSlNameClns").readOnly = true;
				$("txtTranMeaningClns").readOnly = true;
			});
		} catch (e) {
			showErrorMessage("Disable form fields of other collection", e);
		}
	}

	function searchDisable(disable) {
		if (disable) {
			disableSearch("hrefTranTypeClns");
			disableSearch("hrefOldTranNoClns");
			disableSearch("hrefAcctCodeClns");
			disableSearch("hrefSlCodeClns");
			disableSearch("hrefOldItemNoClns");
			
		} else {
			enableSearch("hrefTranTypeClns");
			enableSearch("hrefOldTranNoClns");
			enableSearch("hrefAcctCodeClns");
			enableSearch("hrefSlCodeClns");
			enableSearch("hrefOldItemNoClns");
		}
	}

	function checkTranType(check) {
		if (check) {
			disableFormFilelds(false);
			searchDisable(false);
			$("txtAcctNameClns").readOnly = true; 
			disableSearch("hrefSlCodeClns");
			disableSearch("hrefOldItemNoClns");
			disableSearch("hrefOldTranNoClns");
			requireField("refund", "acctCds");
		} else {
			disableFormFilelds(false);
			searchDisable(false);
			$("txtAcctNameClns").readOnly = true;
			disableSearch("hrefSlCodeClns");
			disableSearch("hrefAcctCodeClns");
			requireField("acctCds", "refund");
		}
	}
	
	function updateTotal(){
		/* var firstTotal = 0;
		result = 0;
		for ( var i = 0; i < objOtherCollections.length; i++) {
			firstTotal = unformatNumber(otherCollectionsGrid.geniisysRows[i].collectionAmt);
			result = parseFloat(result) + parseFloat(firstTotal);
			$("txtClnAmtTotal").value = formatCurrency(result);
		} */
		$("txtClnAmtTotal").value = formatCurrency(parseInt(unformatCurrency("txtClnAmtTotal")) + (delAmt == "" ? parseInt(addAmt) : parseInt(delAmt)));
	}
	
	function checkItemNo(){
		var resultItem = true;
		for ( var i = 0; i < otherCollectionsGrid.rows.length; i++) {
			if(otherCollectionsGrid.rows[i][otherCollectionsGrid.getColumnIndex('itemNo')] == $F("txtItemNoClns")) {
				customShowMessageBox("Item no is already existing.", "I", "txtItemNoClns");
				$("txtItemNoClns").value = "";
				resultItem = false;
				break;
			}
		}
		return resultItem;
	}
	
	function checkItemNoFromDb(){
		var resultItem = true;
		new Ajax.Request(contextPath+"/GIACOtherCollnsController?action=validateItemNoGIACS015",{
			method: "POST",
			asynchronous: true,
			parameters:{
				itemNo: $("txtItemNoClns").value,
				gaccTranId: objACGlobal.gaccTranId
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "Y"){
						customShowMessageBox("Item no is already existing.", "I", "txtItemNoClns");
						$("txtItemNoClns").value = "";
						resultItem = false;
					}else{
						rowObj.recordStatus = 0;
						objOtherCollections.push(rowObj);
						otherCollectionsGrid.addBottomRow(rowObj);
						otherCollectionsGrid.onRemoveRowFocus();
						changeTag = 1;
						updateTotal();
						$("txtItemNoClns").value  = itemNo + 1;
						itemNo = parseInt($("txtItemNoClns").value);
						addAmt = null;
					}
				}
			}
		});
		return resultItem;
	}
	
	function checkDecimal(txtId){
		for(var i = 0; i < txtId.length; i++){
			if (txtId.charAt(i)=='.'){
				return true;
			}
		}
		return false;
	}
	
	function initializeAllAcctCdFields() {
		$$("input[type='text'].acctCds").each(function (m) {
			m.observe("change", function() {
				$("txtAcctNameClns").value = "";
				if (isNaN((m.value)) || parseInt(m.value) < 0 || checkDecimal(m.value) || parseInt(m.value) > 99) {
					customShowMessageBox("Invalid Account Code. Valid value should be from 01 to 99.", "I", m.id);
					m.clear();
				}else{
					m.value = m.value != "" ? formatNumberDigits(m.value, 2) : "";
				}
			});
		});
	}
	
	function initializeAllOldTranNoFields(){
		$$("input[type='text'].refund").each(function (m) {
			m.observe("change", function() {
				if (m.value == null || m.value == "") {
					customShowMessageBox("Field must be entered.", "I", m.id);
				}
				if (isNaN((m.value)) || parseInt(m.value) < 0 || checkDecimal(m.value)) {
					customShowMessageBox("Invalid " + m.name, "I", m.id);
					m.clear();
				}else{
					m.value = formatNumberDigits(m.value, m.maxLength);
				}
			});
		});
	} 
	
	function addOtherCollns(){  
		rowObj  = setOtherCollnsTableValues();
		if(checkAllRequiredFieldsInDiv("otherCollectionFormDiv")){
			checkItemNoFromDb();
		}
	}
	
	function deleteOtherCollns(){  
		delAmt = delAmt * -1;
		updateTotal();
		delAmt = null;
		delObj = setOtherCollnsTableValues();
		delObj.recordStatus = -1;
		objOtherCollections.splice(row, 1, delObj);
		otherCollectionsGrid.deleteVisibleRowOnly(row);
		otherCollectionsGrid.onRemoveRowFocus();
		changeTag = 1;
	}
	
	function validateDeleteGiacs015(){
		new Ajax.Request(contextPath+"/GIACOtherCollnsController?action=validateDeleteGiacs015",{
			method: "POST",
			asynchronous: true,
			parameters:{
				itemNo: $("txtItemNoClns").value,
				gaccTranId: objACGlobal.gaccTranId
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "Y"){
						customShowMessageBox("Cannot delete GI Unide while dependent GI Unidentified Collections exists", "I", "txtItemNoClns");
						return false;
					}else{
						deleteOtherCollns();
					}
				}
			}
		});
	}
	
	function saveOtherCollns(redirect){ 
		var objParams = new Object(); 
		objParams.setRows = getAddedAndModifiedJSONObjects(objOtherCollections); 
		objParams.delRows = getDeletedJSONObjects(objOtherCollections);
		new Ajax.Request(contextPath+"/GIACOtherCollnsController?action=setOtherCollnsDtls",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams),
				gaccTranId: objACGlobal.gaccTranId,
				fundCd: objACGlobal.fundCd,
				branchCd: objACGlobal.branchCd,
				tranSource: objACGlobal.tranSource,
				orFlag: objACGlobal.orFlag
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Other Collections, Please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				lastValidAmt = "";
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						changeTag = 0;
						if (redirect == null || redirect == "") {
	 						showMessageBox(objCommonMessage.SUCCESS, "S");
	 						otherCollectionsGrid.refresh();
	 						otherCollectionsGrid.onRemoveRowFocus();
						}else if(redirect == "OR"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function() {
								if(objACGlobal.tranSource == "OP" || objACGlobal.tranSource == "OR"){
									$("opPreview").up("li", 0).show();
									setSubMenuDivs();
									$("opPrev").show();
									showORPreview();
								} else {
									$("opPreview").up("li", 0).hide();
								}
							});
						}else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function() {
								redirect();
							});
						}
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	//To disable all fields if it is cancelled, closed or query only
	function disableGIACS015(){
		reqDivArray = new Array("otherCollectionFormDiv","otherCollectionsFormButtonsDiv"); 
		disableCancelORFields(reqDivArray);
	}
	//added cancelOtherOR by robert 10302013
	if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS015();
		disableButton("btnAddClns");
		disableSearch("hrefTranTypeClns");
	}
	
	//LOV functions
	function showGIACS015AccountCdLov() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS015AccountCdLov",
				glAcctCategory : $F("txtGlAcctCategoryClns"),
				glControlAcct : $F("txtGlControlAcctClns"),
				glSubAcct1 : $F("txtAcctCode1Clns1"),
				glSubAcct2 : $F("txtAcctCode1Clns2"),
				glSubAcct3 : $F("txtAcctCode1Clns3"),
				glSubAcct4 : $F("txtAcctCode1Clns4"),
				glSubAcct5 : $F("txtAcctCode1Clns5"),
				glSubAcct6 : $F("txtAcctCode1Clns6"),
				glSubAcct7 : $F("txtAcctCode1Clns7")
			},
			title : "List of Values: Account Code",
			width : 815,
			height : 390,
			columnModel : [ {
				id : 'glAcctCode',
				title : 'Acct Code',
				visible : true,
				width : '270px'
			}, {
				id : 'glAcctCategory',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glControlAcct',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct1',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct2',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct3',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct4',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct5',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct6',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct7',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glAcctName',
				title : 'Account Name',
				width : '400px',
				visible : true,
				align : 'left'
			}, {
				id : 'gsltSlTypeCd',
				title : 'SL Type',
				width : '92px',
				visible : true,
				align : 'left'
			}, {
				id : 'glAcctId',
				width : '0px',
				visible : false
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			onSelect : function(row) {
				$("txtGlAcctCategoryClns").value = parseInt(row.glAcctCategory).toPaddedString(2);
				$("txtGlControlAcctClns").value = parseInt(row.glControlAcct).toPaddedString(2);
				$("txtAcctCode1Clns1").value = parseInt(row.glSubAcct1).toPaddedString(2);
				$("txtAcctCode1Clns2").value = parseInt(row.glSubAcct2).toPaddedString(2);
				$("txtAcctCode1Clns3").value = parseInt(row.glSubAcct3).toPaddedString(2);
				$("txtAcctCode1Clns4").value = parseInt(row.glSubAcct4).toPaddedString(2);
				$("txtAcctCode1Clns5").value = parseInt(row.glSubAcct5).toPaddedString(2);
				$("txtAcctCode1Clns6").value = parseInt(row.glSubAcct6).toPaddedString(2);
				$("txtAcctCode1Clns7").value = parseInt(row.glSubAcct7).toPaddedString(2);
				$("txtAcctNameClns").value = unescapeHTML2(row.glAcctName);
				$("hidAcctIdClns").value = row.glAcctId;
				//added by John Daniel SR-5056
				$("txtSlCodeClns").setAttribute("slTypeCd",row.gsltSlTypeCd); 
				$("txtSlCodeClns").value = ""; 
				if(row.gsltSlTypeCd == null){
					$("txtSlCodeClns").readOnly = true;
					disableSearch("hrefSlCodeClns");
					//added by John Daniel SR-5056
					$("txtSlCodeClns").removeClassName("required"); 
					$("txtSlCodeClns").setStyle({backgroundColor: '#FFFFFF'});
				}else if(checkSLCode()){ //modified by John Daniel SR-5056
					$("txtSlCodeClns").addClassName("required");
					$("txtSlCodeClns").setStyle({backgroundColor: '#FFFACD'});
					$("txtSlCodeClns").readOnly = false;
					enableSearch("hrefSlCodeClns");
				}
			}
		});
	};
	
	function showGIACS015SlCdLov() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS015SlCdLov",
				slTypeCd : unformatNumber($("txtSlCodeClns").getAttribute("slTypeCd")), //added by John Daniel SR-5056; get slTypeCd from data retrived when querying for account number
				fundCd : objACGlobal.fundCd,
				slCd : unformatNumber($("txtSlCodeClns").value)
			},
			title : "SL Code",
			width : 450,
			height : 300,
			columnModel : [ {
				id : "slCd",
				title : "SL Code",
				width : '100px'
			}, {
				id : "slName",
				title : "SL Name",
				width : '317px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : unformatNumber($("txtSlCodeClns").value),
			onSelect : function(row) {
				$("txtSlCodeClns").value = formatNumberDigits(row.slCd, 12);
				$("txtSlNameClns").value = unescapeHTML2(row.slName);
			}
		});
	}
	
	function showGIACS015TranTypeLov() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS015TranTypeLov",
				transactionType : $("txtTranTypeClns").value
			},
			title : "Transaction Type",
			width : 450,
			height : 300,
			columnModel : [ {
				id : "transactionType",
				title : "Tran Type",
				width : '100px'
			}, {
				id : "tranTypeMeaning",
				title : "Meaning",
				width : '317px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : $("txtTranTypeClns").value,
			onSelect : function(row) {
				populateOtherCollns(null);
				$("txtItemNoClns").value = itemNo;
				$("txtTranTypeClns").value = formatNumberDigits(row.transactionType, 2);
				$("txtTranMeaningClns").value = unescapeHTML2(row.tranTypeMeaning);
				if($("txtTranTypeClns").value == 1){
					checkTranType(true);
				}else if($("txtTranTypeClns").value == 2){
					checkTranType(false);
				}
				
			}
		});
	}

	function requireField(remove, add){
		$$("input[type='text']." + remove).each(function (m) {
			m.removeClassName("required");
			m.readOnly = true;
		});
		$$("input[type='text']." + add).each(function (m) {
			m.addClassName("required");
			m.readOnly = false;
		});
	}
	
	function showGIACS015OldTranIdLov() {
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action : "getGIACS015OldTranIdLov",
				tranYear : $F("txtTranYearClns"),
				tranMonth : $F("txtTranMonthClns"),
				tranSeqNo : $F("txtTranSeqNoClns"),
				gaccTranId : objACGlobal.gaccTranId
			},
			title : "Old transaction no.",
			width : 800,
			height : 403,
			columnModel : [ {
				id : 'tranYear',
				title : 'Tran Year',
				visible : true,
				width : '100px'
			}, {
				id : 'tranMonth',
				title : 'Tran Month',
				visible : true,
				width : '100px'
			}, {
				id : 'tranSeqNo',
				title : 'Tran Seq No',
				visible : true,
				width : '100px'
			}, {
				id : 'OldItemNo',
				title : 'Old Item No',
				visible : true,
				width : '100px'
			}, {
				id : 'collectionAmt',
				title : 'Collection Amt',
				visible : true,
				width : '150px'
			}, {
				id : 'particulars',
				title : 'Particulars',
				visible : true,
				width : '380px'
			}, {
				id : 'gaccTranId',
				title : 'Gotc Tran Id',
				visible : false,
				width : '0px'
			}, {
				id : 'glAcctCategory',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glControlAcct',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct1',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct2',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct3',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct4',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct5',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct6',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'glSubAcct7',
				width : '0px',
				visible : false,
				renderer : function(value) {
					return lpad(value, 2, 0);
				}
			}, {
				id : 'dspAccountName',
				title : 'Account Name',
				width : '0px',
				visible : false,
				align : 'left'
			}, {
				id : 'glAcctId',
				width : '0px',
				visible : false
			}],
			draggable : true,
			autoSelectOneRecord : true,
			onSelect : function(row) {
				$("txtTranYearClns").value = formatNumberDigits(row.tranYear, 4 );
				$("txtTranMonthClns").value = formatNumberDigits(row.tranMonth, 2);
				$("txtTranSeqNoClns").value = formatNumberDigits(row.tranSeqNo, 5);
				$("txtOldItemNoClns").value = formatNumberDigits(row.OldItemNo, 2);
				$("txtAmountClns").value = formatCurrency(row.collectionAmt);
				reverseAmt = formatCurrency(row.collectionAmt);
				lastValidAmt = reverseAmt;
				$("txtParticularsClns").value = row.particulars;
				$("hidGotcTranIdClns").value = row.gaccTranId;
				$("txtGlAcctCategoryClns").value = parseInt(row.glAcctCategory).toPaddedString(2);
				$("txtGlControlAcctClns").value = parseInt(row.glControlAcct).toPaddedString(2);
				$("txtAcctCode1Clns1").value = parseInt(row.glSubAcct1).toPaddedString(2);
				$("txtAcctCode1Clns2").value = parseInt(row.glSubAcct2).toPaddedString(2);
				$("txtAcctCode1Clns3").value = parseInt(row.glSubAcct3).toPaddedString(2);
				$("txtAcctCode1Clns4").value = parseInt(row.glSubAcct4).toPaddedString(2);
				$("txtAcctCode1Clns5").value = parseInt(row.glSubAcct5).toPaddedString(2);
				$("txtAcctCode1Clns6").value = parseInt(row.glSubAcct6).toPaddedString(2);
				$("txtAcctCode1Clns7").value = parseInt(row.glSubAcct7).toPaddedString(2);
				$("txtAcctNameClns").value = unescapeHTML2(row.dspAccountName);
				$("hidAcctIdClns").value = row.glAcctId;
			}
		});
	};
	
	//Observe Items
	$("txtSlCodeClns").observe("change",function() {
		$("txtSlNameClns").value = "";
		if (isNaN(($("txtSlCodeClns").value)) || parseInt($("txtSlCodeClns").value) < 1 || checkDecimal($("txtSlCodeClns").value)) {
			customShowMessageBox("Invalid SL Code. Valid value should be from 000000000001 to 999999999999.", "I", "txtSlCodeClns");
			$("txtSlCodeClns").value = "";
		}
	});
	
	$("txtTranTypeClns").observe("change",function() {
		var type = $("txtTranTypeClns").value;
		populateOtherCollns(null);
		$("txtItemNoClns").value = itemNo;
		$("txtTranTypeClns").value = type;
		if (isNaN(($("txtTranTypeClns").value)) || parseInt($("txtTranTypeClns").value) < 1 || parseInt($("txtTranTypeClns").value) > 2 || checkDecimal($("txtTranTypeClns").value)) {
			customShowMessageBox("Invalid value for Transaction Type.", "I", "txtTranTypeClns");
			$("txtTranTypeClns").value = "";
		}
	});
	
	$("txtItemNoClns").observe("change",function() {
		if (isNaN(($("txtItemNoClns").value)) || parseInt($("txtItemNoClns").value) < 1 || checkDecimal($("txtItemNoClns").value) || parseInt($("txtItemNoClns").value) > 99) {
			customShowMessageBox("Invalid Item No. Valid value should be from 01 to 99.", "I", "txtItemNoClns");
			$("txtItemNoClns").value = "";
		}else{
			//checkItemNo();
			$("txtItemNoClns").value = $("txtItemNoClns").value != "" ? formatNumberDigits($("txtItemNoClns").value, 2) : "";
			itemNo = $("txtItemNoClns").value;
		}
	});
	
	$("txtAmountClns").observe("change",function() {
		var tryAmt = $F("txtAmountClns").replace(/,/g, "");
		if (isNaN(tryAmt) || parseFloat(tryAmt) > parseFloat(99999999999999.99)) {
			customShowMessageBox("Invalid Amount. Valid value should be from 0.01 to  99,999,999,999,999.99.", "I", "txtAmountClns");
			$("txtAmountClns").value = lastValidAmt;
		}else if ($("txtTranTypeClns").value == 1 && tryAmt <= 0){
			customShowMessageBox("Please enter collection amount.", "I", "txtAmountClns");
			$("txtAmountClns").value = lastValidAmt;
		}else if ($("txtTranTypeClns").value == 2 && tryAmt >= 0){
			customShowMessageBox("Amount should be negative.", "I", "txtAmountClns");
			$("txtAmountClns").value = lastValidAmt;
		}else if ($("txtTranTypeClns").value == 2 && Math.abs(tryAmt) > Math.abs(reverseAmt.replace(/,/g, ""))){
			customShowMessageBox("Reversible amount for this transaction should not exceed " + formatCurrency(Math.abs(reverseAmt.replace(/,/g, ""))) + ".", "I", "txtAmountClns");
			$("txtAmountClns").value = lastValidAmt;
		}else{
			$("txtAmountClns").value = formatCurrency($("txtAmountClns").value);
			lastValidAmt = $F("txtAmountClns");
		}
	});
	
	function onYesFunc() {
		if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
			showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
		}else if(objACGlobal.previousModule == "GIACS071"){
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else{
			editORInformation();
		}
	}
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION",
					objCommonMessage.WITH_CHANGES, "Yes", "No",
					"Cancel", function() {
						saveOtherCollns(previousMod);
					}, function() {
						previousMod();
						changeTag = 0;
					}, "");
		} else {
			previousMod();
		}
	});
	
	function previousMod(){
		if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
			showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
		}else if(objACGlobal.previousModule == "GIACS071"){
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
			$("giacs031MainDiv").hide();
			$("giacs032MainDiv").show();
			$("mainNav").hide();
		}else{
			editORInformation();
		}
	}
	
	//added by John Daniel SR-5056
	function checkSLCode(slCd, action){
		var result = false;
		var mode = action == null ? null : action;
		var slCode = slCd == null ? null : slCd;
		var slTypeCode = $("txtSlCodeClns").getAttribute("slTypeCd");
		var fundCode = objACGlobal.fundCd;
		
		new Ajax.Request(contextPath+"/GIACOtherCollnsController?action=checkSLCode",{
			method: "GET",
			parameters:{
				slTypeCd : slTypeCode,
				slCd: slCode,
				fundCd: fundCode
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					if (response.responseText == 'N') {
						if (mode == null){
							$("txtSlCodeClns").value = "";
							$("txtSlCodeClns").removeClassName("required"); 
							$("txtSlCodeClns").readOnly = true;
							$("txtSlCodeClns").setStyle({backgroundColor: '#FFFFFF'});
							disableSearch("hrefSlCodeClns");
							showMessageBox("There is no SL Code associated with this Account Code.", imgMessage.INFO);
						} else if(mode == 'Add' && slCode != "" && $("txtSlCodeClns").readOnly == false){
							$("txtSlCodeClns").value = "";
							showMessageBox("The SL Code entered is not associated with the Account Code.", imgMessage.INFO);
						}
					} else {
						result = true;
					}					
				}
			}
		});
		return result;
	}
	
	$("hrefParticularsClns").observe("click", function() {
		showOverlayEditor("txtParticularsClns", 500, $("txtParticularsClns").hasAttribute("readonly"), function() {
			limitText($("txtParticularsClns"), 500);
		});
	});
	
	$("btnCancelClns").observe("click", function() {
		fireEvent($("acExit"), "click");
	});
	
	$("txtParticularsClns").observe("keyup", function() {
		limitText(this, 500);
	});
	
	$("hrefAcctCodeClns").observe("click", function() {
		showGIACS015AccountCdLov();
	});

	$("hrefSlCodeClns").observe("click", function() {
		showGIACS015SlCdLov();
	});

	$("hrefTranTypeClns").observe("click", function() {
		showGIACS015TranTypeLov();
	});

	$("hrefOldTranNoClns").observe("click", function() {
		showGIACS015OldTranIdLov();
	});
	
	$("hrefOldItemNoClns").observe("click", function() {
		showGIACS015OldTranIdLov();
	});
	
	$("btnAddClns").observe("click", function() {
		if(checkItemNo() && checkSLCode($("txtSlCodeClns").value, 'Add')){ //modified by John Daniel SR-5056)
			addOtherCollns();
		}
	});

	$("btnDeleteClns").observe("click", function() {
		validateDeleteGiacs015();
	});
	
	//observeSaveForm("btnSaveClns", saveOtherCollns);
	
	$("btnSaveClns").observe("click", function() {
		//exitSave = 0;
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			//saveOn = "Y";
			saveOtherCollns(null);
		}
	});
	
	//function to other tabs
	
	function setSubMenuDivs() {
		$$("div[name='subMenuDiv']").each(function(row){
			row.hide();
		});
		objACGlobal.tranClass = '0';
	}

	function showDirectTransac(){
		setSubMenuDivs();
		objACGlobal.tranClass = '1';
		$("directTransTab1").innerHTML = 'Direct Premiums';
		$("directTransTab2").innerHTML = 'Premium Deposit';
		$("directTransTab3").innerHTML = 'Loss Recoveries';
		$("directTransTab4").innerHTML = 'Direct Claim Payts';
		$("directTransTab5").innerHTML = 'Commission Payts';
		$("directTransTab6").innerHTML = 'Input Vat';
		$("directTransTab7").innerHTML = 'Overriding Comm';
		if ($F("defaultModAccessTag") != '0'){
			$("directTransMenu").show();
			fireEvent($("directTransTab1"), "click");
		}else{
			showMessageBox("You are not allowed to access this module.", "I");
		}
	}

	function showRiTrans(){
		setSubMenuDivs();
		$("riTransTab1").innerHTML = 'Inw Facul Prem Collns';
		$("riTransTab2").innerHTML = 'Losses Recov from RI';
		$("riTransTab3").innerHTML = 'Facul Claim Payts';
		$("riTransTab4").innerHTML = 'Out Facul Prem Payts';
		$("riTransMenu").show();
		fireEvent($("riTransTab1"), "click");
	}

	$("directTransac").stopObserving("click");
	$("directTransac").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function() {
					saveOtherCollns(showDirectTransac);
					tabInitialize("tabComponents1", "directTransac", "selectedTab1");
				}, function(){
					changeTag = 0;
					tabInitialize("tabComponents1", "directTransac", "selectedTab1");
					showDirectTransac();
				}, "", "");
		}else {
			showDirectTransac();
		}
	});

	$("riTrans").stopObserving("click");
	$("riTrans").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
				function() {
					saveOtherCollns(showRiTrans);
					tabInitialize("tabComponents1", "riTrans", "selectedTab1");
				}, function(){
					changeTag = 0;
					tabInitialize("tabComponents1", "riTrans", "selectedTab1");
					showRiTrans();
				}, "", "");
		}else {
			showRiTrans();
		}
	});

	$("opPreview").stopObserving("click");
	$("opPreview").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function() {
					saveOtherCollns("OR");
					tabInitialize("tabComponents1", "opPreview", "selectedTab1");
				}, function(){
					changeTag = 0;
					tabInitialize("tabComponents1", "opPreview", "selectedTab1");
					if(objACGlobal.tranSource == "OP" || objACGlobal.tranSource == "OR"){
						$("opPreview").up("li", 0).show();
						setSubMenuDivs();
						$("opPrev").show();
						showORPreview();
					} else {
						$("opPreview").up("li", 0).hide();
					}
				}, "", "");
		}else {
			if(objACGlobal.tranSource == "OP" || objACGlobal.tranSource == "OR"){
				$("opPreview").up("li", 0).show();
				setSubMenuDivs();
				$("opPrev").show();
				showORPreview();
			} else {
				$("opPreview").up("li", 0).hide();
			}
		}
	});

	function showAccountingEntries(){
		setSubMenuDivs();
		showAcctEntries();
	}

	$("acctEntries").stopObserving("click");
	$("acctEntries").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
				function() {
					saveOtherCollns(showAccountingEntries);
					tabInitialize("tabComponents1", "acctEntries", "selectedTab1");
				}, function(){
					changeTag = 0;
					tabInitialize("tabComponents1", "acctEntries", "selectedTab1");
					showAccountingEntries();
				}, "", "");
		}else {
			showAccountingEntries();
		}
	});
	
	$("otherTransTab5").stopObserving("click");
	$("otherTransTab5").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION",
					objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
						saveOtherCollns(showOtherTransWithholdingTax);
						tabInitialize("tabComponents2", "otherTransTab5", "selectedTab2");
					}, function(){
						tabInitialize("tabComponents2", "otherTransTab5", "selectedTab2");
						showOtherTransWithholdingTax();
						changeTag = 0;
					}, "", "");
		}else {
			showOtherTransWithholdingTax();
		}
	});
	
	$("otherTransTab4").stopObserving("click");
	$("otherTransTab4").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION",
					objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
						saveOtherCollns(showTaxPayments);
						tabInitialize("tabComponents2", "otherTransTab4", "selectedTab2");
					}, function(){
						tabInitialize("tabComponents2", "otherTransTab4", "selectedTab2");
						showTaxPayments();
						changeTag = 0;
					}, "", "");
		}else {
			showTaxPayments();
		}
	});
	
	$("otherTransTab3").stopObserving("click");
	$("otherTransTab3").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION",
					objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
						saveOtherCollns(showUnidentifiedCollection);
						tabInitialize("tabComponents2", "otherTransTab3", "selectedTab2");
					}, function(){
						tabInitialize("tabComponents2", "otherTransTab3", "selectedTab2");
						showUnidentifiedCollection();
						changeTag = 0;
					}, "", "");
		}else {
			showUnidentifiedCollection();
		}
	});
	
	$("otherTransTab1").stopObserving("click");
	$("otherTransTab1").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("CONFIRMATION",
					objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
						saveOtherCollns(showCollnsForOtherOffices);
						tabInitialize("tabComponents2", "otherTransTab1", "selectedTab2");
					}, function(){
						tabInitialize("tabComponents2", "otherTransTab1", "selectedTab2");
						showCollnsForOtherOffices();
						changeTag = 0;
					}, "", "");
		}else {
			showCollnsForOtherOffices();
		}
	});
	
	
	function tabInitialize(tabNum, tab, selctedTab){
		$$("div." + tabNum + " a").each(function(a){
			if(a.id == tab) {
				$(tab).up("li").addClassName(selctedTab);
			}else{
				a.up("li").removeClassName(selctedTab);
			}
		});
	}
	initializeAllAcctCdFields();
	initializeAllOldTranNoFields();
	initializeChangeTagBehavior(saveOtherCollns);
	//initializeAll();
	initializeTabs();

</script>