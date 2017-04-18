<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giacs323MainDiv" name="giacs323MainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Tax Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giacs320" name="giacs320">
		<div class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="taxTableDiv" style="height: 340px; margin-left: 10px;"></div>
			</div>
			
			<div align="center" id="taxFormDiv" style="margin-right: 45px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Fund Code</td>
						<td class="leftAligned">
							<span class="required lovSpan" style="width: 207px; height: 21px; margin: 0; float: left;">
								<input id="fundCd" type="text" class="required upper" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="101" maxlength="3" ignoreDelKey="true" lastValidValue="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundCd" name="searchFundCd" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Tax Code</td>
						<td class="leftAligned"><input id="taxCd" type="text" class="required integerNoNegativeUnformatted" style="width: 200px; text-align: right;" maxlength="2" lastValidValue="" tabindex="102"></td>
					</tr>
					<tr>
						<td class="rightAligned">Tax Name</td>
						<td class="leftAligned" colspan="3"><input id="taxName" type="text" class="required upper" style="width: 533px;" maxlength="100" tabindex="103"></td>
					</tr>
					<tr>
						<td class="rightAligned">Tax Type</td>
						<td class="leftAligned">
							<span class="required lovSpan" style="width: 207px; height: 21px; margin: 0; float: left;">
								<input id="taxType" type="text" class="required upper" style="width: 175px; height: 13px; float: left; border: none;" lastValidValue="" maxlength="1" tabindex="104" ignoreDelKey="true">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTaxType" name="searchTaxType" alt="Go" style="float: right;">
							</span>
						</td>
						<td class="rightAligned">Priority Code</td>
						<td class="leftAligned"><input id="priorityCd" type="text" class="required integerNoNegativeUnformatted" style="width: 200px; text-align: right;" lastValidValue="" maxlength="2" tabindex="105"></td>
					</tr>
					<tr>
						<td class="rightAligned">GL Account Code</td>
						<td class="leftAligned" colspan="3">
							<div>
								<input id="glAcctId" type="hidden" value="">
								<input id="glAcctCategory" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="1" tabindex="106">
								<input id="glControlAcct" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="107">
								<input id="glSubAcct1" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="108">
								<input id="glSubAcct2" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="109">
								<input id="glSubAcct3" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="110">
								<input id="glSubAcct4" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="111">
								<input id="glSubAcct5" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="112">
								<input id="glSubAcct6" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="113">
								<input id="glSubAcct7" name="glField" type="text" class="required integerNoNegativeUnformatted" style="width: 45px; text-align: right;" lastValidValue="" maxlength="2" tabindex="114">
								<span><img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchGL" name="searchGL" alt="Go" style="float: right; padding: 2px 2px 0 0;"></span>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 538px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 511px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="115"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="userId" type="text" class="" style="width: 200px; margin-right: 37px;" readonly="readonly" tabindex="117"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="118"></td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="119">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="120">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="121">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="122">
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIACS320 = {};
	var selectedRow = null;
	objGIACS320.taxList = JSON.parse('${taxJSON}');
	objGIACS320.exitPage = null;
	
	var taxTable = {
		url: contextPath + "/GIACTaxesController?action=showGIACS320&refresh=1",
		options: {
			width: '900px',
			height: '306px',
			hideColumnChildTitle: true,
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = taxTG.geniisysRows[y];
				setFieldValues(selectedRow);
				taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
				taxTG.keys.releaseKeys();
				$("fundCd").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
				taxTG.keys.releaseKeys();
				$("fundCd").focus();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
					taxTG.keys.releaseKeys();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				rowIndex = -1;
				setFieldValues(null);
				taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
				taxTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
				taxTG.keys.releaseKeys();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				rowIndex = -1;
				setFieldValues(null);
				taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
				taxTG.keys.releaseKeys();
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
		columnModel : [
			{	id: 'recordStatus',
			    width: '0',				    
			    visible : false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},	
			{
				id: "fundCd",
				title: "Fund Code",
				width: '80px',
				filterOption: true
			},
			{	id: 'taxCd',
				title: 'Tax Code',
				align: 'right',
				width: '70px',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'taxName',
				title: 'Tax Name',
				width: '270px',
				filterOption: true
			},
			{	id: 'taxType',
				title: 'Tax Type',
				width: '67px',
				filterOption: true
			},
			{	id: 'priorityCd',
				title: 'Priority Code',
				align: 'right',
				width: '90px',
				filterOption: true,
				filterOptionType: 'integerNoNegative',
				renderer: function(value){
					return lpad(value, 2, "0");
				}
			},
			{	id: 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
				title: 'GL Account Code',
				titleAlign: 'right',
				width: '200px',
				sortable: true,
				children: [
					{	id: 'glAcctCategory',
						title: 'GL Acct Category',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
					},
					{	id: 'glControlAcct',
						title: 'GL Control Acct',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct1',
						title: 'GL Sub Acct1',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct2',
						title: 'GL Sub Acct2',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct3',
						title: 'GL Sub Acct3',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct4',
						title: 'GL Sub Acct4',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct5',
						title: 'GL Sub Acct5',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct6',
						title: 'GL Sub Acct6',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					},
					{	id: 'glSubAcct7',
						title: 'GL Sub Acct7',
						align: 'right',
						width: 30,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer: function(value){
							return lpad(value, 2, "0");
						}
					}
				]
			}
		],
		rows: objGIACS320.taxList.rows
	};
	taxTG = new MyTableGrid(taxTable);
	taxTG.pager = objGIACS320.taxList;
	taxTG.render("taxTableDiv");
	
	function newFormInstance(){
		$("fundCd").focus();
		setModuleId("GIACS320");
		setDocumentTitle("Tax Maintenance");
		initializeAll();
		makeInputFieldUpperCase();
		setLastValidValueAttributes();
		changeTag = 0;
	}
	
	function setFieldValues(rec){
		try{
			$("fundCd").value = (rec == null ? "" : unescapeHTML2(rec.fundCd));
			$("fundCd").setAttribute("lastValidValue", rec == null ? "" : unescapeHTML2(rec.fundCd));
			$("taxCd").value = (rec == null ? "" : rec.taxCd);
			$("taxName").value = (rec == null ? "" : unescapeHTML2(rec.taxName));
			$("taxType").value = (rec == null ? "" : unescapeHTML2(rec.taxType));
			$("priorityCd").value = (rec == null ? "" : lpad(rec.priorityCd, 2, "0"));
			$("glAcctId").value = (rec == null ? "" : rec.glAcctId);
			$("glAcctCategory").value = (rec == null ? "" : rec.glAcctCategory);
			$("glControlAcct").value = (rec == null ? "" : lpad(rec.glControlAcct, 2, "0"));
			$("glSubAcct1").value = (rec == null ? "" : lpad(rec.glSubAcct1, 2, "0"));
			$("glSubAcct2").value = (rec == null ? "" : lpad(rec.glSubAcct2, 2, "0"));
			$("glSubAcct3").value = (rec == null ? "" : lpad(rec.glSubAcct3, 2, "0"));
			$("glSubAcct4").value = (rec == null ? "" : lpad(rec.glSubAcct4, 2, "0"));
			$("glSubAcct5").value = (rec == null ? "" : lpad(rec.glSubAcct5, 2, "0"));
			$("glSubAcct6").value = (rec == null ? "" : lpad(rec.glSubAcct6, 2, "0"));
			$("glSubAcct7").value = (rec == null ? "" : lpad(rec.glSubAcct7, 2, "0"));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
			
			$("taxType").setAttribute("lastValidValue", $F("taxType"));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("fundCd").readOnly = false : $("fundCd").readOnly = true;
			rec == null ? $("taxCd").readOnly = false : $("taxCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableSearch("searchFundCd") : disableSearch("searchFundCd");
			
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function showTaxTypeLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGiacs320TaxTypeLOV",
				filterText: $F("taxType") != $("taxType").getAttribute("lastValidValue") ? nvl($F("taxType"), "%") : "%"
			},
			title: "List of Tax Types",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "rvLowValue",
								title: "Code",
								width: "100px"
							},
							{	id: "rvMeaning",
								title: "Tax Type",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("taxType") != $("taxType").getAttribute("lastValidValue") ? nvl($F("taxType"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("taxType").focus();
					$("taxType").setAttribute("lastValidValue", row.rvLowValue);
					$("taxType").value = row.rvLowValue;
				}
			},
			onCancel: function(){
				$("taxType").value = $("taxType").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("taxType").value = $("taxType").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showGlLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGiacs320GlLOV"
			},
			title: "List of GL Accounts",
			width: 425,
			height: 386,
			columnModel:[
							{	id: "glAcctName",
								title: "Account Name",
								width: "411px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("glAcctId").value = row.glAcctId;
					$("glAcctCategory").value = row.glAcctCategory;
					$("glControlAcct").value = lpad(row.glControlAcct, 2, "0");
					$("glSubAcct1").value = lpad(row.glSubAcct1, 2, "0");
					$("glSubAcct2").value = lpad(row.glSubAcct2, 2, "0");
					$("glSubAcct3").value = lpad(row.glSubAcct3, 2, "0");
					$("glSubAcct4").value = lpad(row.glSubAcct4, 2, "0");
					$("glSubAcct5").value = lpad(row.glSubAcct5, 2, "0");
					$("glSubAcct6").value = lpad(row.glSubAcct6, 2, "0");
					$("glSubAcct7").value = lpad(row.glSubAcct7, 2, "0");
				}
			},
			onCancel: function(){
				
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACTaxesController", {
				parameters: {
					action: "valDeleteRec",
					fundCd: $F("fundCd"),
					taxCd: $F("taxCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGIACS320;
		selectedRow.recordStatus = -1;
		taxTG.geniisysRows[rowIndex].fundCd = escapeHTML2(taxTG.geniisysRows[rowIndex].fundCd);
		taxTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("taxFormDiv")){
				if($F("btnAdd") == "Add"){
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<taxTG.geniisysRows.length; i++){
						if(taxTG.geniisysRows[i].recordStatus == 0 || taxTG.geniisysRows[i].recordStatus == 1){	
							if(unescapeHTML2(taxTG.geniisysRows[i].fundCd) == $F("fundCd") && taxTG.geniisysRows[i].taxCd == $F("taxCd")){
								addedSameExists = true;	
							}
						}else if(taxTG.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(taxTG.geniisysRows[i].fundCd) == $F("fundCd") && taxTG.geniisysRows[i].taxCd == $F("taxCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same fund_cd and tax_cd.", "E");
						return;
					}else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACTaxesController", {
						parameters: {
							action: "valAddRec",
							fundCd: $F("fundCd"),
							taxCd: $F("taxCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				}else{
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.fundCd = escapeHTML2($F("fundCd"));
			obj.taxCd = $F("taxCd");
			obj.taxName = escapeHTML2($F("taxName"));
			obj.taxType = escapeHTML2($F("taxType"));
			obj.priorityCd = $F("priorityCd");
			obj.glAcctId = $F("glAcctId");
			obj.glAcctCategory = $F("glAcctCategory");
			obj.glControlAcct = $F("glControlAcct");
			obj.glSubAcct1 = $F("glSubAcct1");
			obj.glSubAcct2 = $F("glSubAcct2");
			obj.glSubAcct3 = $F("glSubAcct3");
			obj.glSubAcct4 = $F("glSubAcct4");
			obj.glSubAcct5 = $F("glSubAcct5");
			obj.glSubAcct6 = $F("glSubAcct6");
			obj.glSubAcct7 = $F("glSubAcct7");
			obj.remarks = escapeHTML2($F("remarks"));
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		if(checkAllRequiredFieldsInDiv("taxFormDiv")){
			changeTagFunc = saveGIACS320;
			var rec = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				taxTG.addBottomRow(rec);
			} else {
				taxTG.updateVisibleRowOnly(rec, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			taxTG.keys.removeFocus(taxTG.keys._nCurrentFocus, true);
			taxTG.keys.releaseKeys();
		}
	}
	
	function saveGIACS320(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(taxTG.geniisysRows);
		var delRows = getDeletedJSONObjects(taxTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIACTaxesController", {
			method: "POST",
			parameters: {
				action: "saveGIACS320",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS320.exitPage != null) {
							objGIACS320.exitPage();
						} else {
							taxTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function cancelGIACS320(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS320.exitPage = exitPage;
						saveGIACS320();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function setLastValidValueAttributes(){
		$w("taxCd taxType priorityCd glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7").each(function(e){
			$(e).observe("focus", function(){
				$(e).setAttribute("lastValidValue", $F(e));
			});
		});
	}
	
	function checkAccountCode(e){
		new Ajax.Request(contextPath+"/GIACTaxesController", {
			method: "GET",
			parameters: {
				action: "checkAccountCode",
				glAcctCategory: $F("glAcctCategory"),
				glControlAcct: $F("glControlAcct"),
				glSubAcct1: $F("glSubAcct1"),
				glSubAcct2: $F("glSubAcct2"),
				glSubAcct3: $F("glSubAcct3"),
				glSubAcct4: $F("glSubAcct4"),
				glSubAcct5: $F("glSubAcct5"),
				glSubAcct6: $F("glSubAcct6"),
				glSubAcct7: $F("glSubAcct7")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					$("glAcctId").value = response.responseText;
				}else{
					e.value = e.getAttribute("lastValidValue");
				}
			}
		});
	}
	
	function showFundLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getGIACS320FundLOV",
				filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%"
			},
			title: "List of Funds",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "fundCd",
								title: "Code",
								width: "100px"
							},
							{	id: "fundDesc",
								title: "Description",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("fundCd").focus();
					$("fundCd").value = unescapeHTML2(row.fundCd);
					$("fundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
				}
			},
			onCancel: function(){
				$("fundCd").value = $("fundCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("fundCd").value = $("fundCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$$("input[name='glField']").each(function(e){
		e.observe("change", function(){
			if(e.value != "" && e.id != "glAcctCategory"){
				e.value = lpad(e.value, 2, "0");
			}
			
			var isComplete = "Y";
			$$("input[name='glField']").each(function(f){
				if(f.value == ""){
					isComplete = "N";
				}
			});
			
			if(isComplete == "Y"){
				checkAccountCode(e);
			}
		});
	});
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("fundCd").observe("change", function(){
		if($F("fundCd") == ""){
			$("fundCd").setAttribute("lastValidValue", "");
		}else{
			showFundLOV();
		}
	});
	
	$("taxType").observe("change", function(){
		if($F("taxType") == ""){
			$("taxType").setAttribute("lastValidValue", "");
		}else{
			showTaxTypeLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("searchFundCd").observe("click", showFundLOV);
	$("searchTaxType").observe("click", showTaxTypeLOV);
	$("searchGL").observe("click", showGlLOV);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnAdd").observe("click", valAddRec);
	$("btnCancel").observe("click", cancelGIACS320);
	$("btnSave").observe("click", saveGIACS320);
	
	observeReloadForm("reloadForm", showGIACS320);
	newFormInstance();
</script>