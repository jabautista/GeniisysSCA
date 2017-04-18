<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss218MainDiv" name="giiss218MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="menuFileMaintenanceExit" name="menuFileMaintenanceExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Bancassurance Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss218" name="giiss218">		
		<div class="sectionDiv">
			<div id="bancTypeTableDiv" style="padding-top: 10px;">
				<div id="bancTypeTable" style="height: 260px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="bancTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Bancassurance Type</td>
						<td class="leftAligned">
							<input id="bancTypeCd" type="text" class="required upper" style="width: 190px; margin-right: 26px;" tabindex="101" maxlength="5">
						</td>
						<td class="rightAligned">Bancassurance Rate</td>
						<td>
							<input id="rate" class="required" type="text" style="width: 190px; text-align: right;" tabindex="102" maxlength="13" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="bancTypeDesc" type="text" class="required upper" style="width: 539px;" tabindex="103" maxlength="50">
						</td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="104">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="105">
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Bancassurance Type Detail</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
	   	</div>
	</div>
	<div id="giiss218Dtl" class="sectionDiv">
		<div id="bancTypeDtlTableDiv" style="padding-top: 10px;">
			<div id="bancTypeDtlTable" style="height: 260px; margin-left: 115px;"></div>
			
			<label class="rightAligned" style="margin: 6px 5px 0 660px;">Total</label>
			<input id="pctTotal" name="pctTotal" type="text" readonly="readonly" value="" style="width: 96px; text-align: right;" tabindex="201"/>
		</div>
		<div align="center" id="bancTypeDtlFormDiv">
			<table style="margin-top: 5px;">
				<tr>
					<td class="rightAligned">Item No.</td>
					<td class="leftAligned">
						<input id="itemNo" type="text" class="required" style="width: 200px;" tabindex="202" maxlength="3" lastValidValue="">
					</td>
					<td class="leftAligned" colspan="2">
						<input id="fixedTag" type="checkbox" title="Fixed Tag" style="margin: 0 5px 0 5px;" tabindex="203">
						<label for="fixedTag" style="margin-left: 120px;">Fixed Tag</label>
					</td>
				</tr>	
				<tr>
					<td width="" class="rightAligned">Intermediary</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 207px; height: 21px; margin: 0; float: left;">
							<input id="intmNo" type="text" class="upper integerNoNegativeUnformatted" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="204" maxlength="12" ignoreDelKey="true" lastValidValue="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;">
						</span> 
					</td>
					<td class="leftAligned" colspan="2">
						<input id="intmName" type="text" style="width: 316px;" tabindex="205" maxlength="50" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Intermediary Type</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 207px; height: 21px; margin: 0; float: left;">
							<input id="intmType" type="hidden">
							<input id="intmDesc" type="text" class="upper" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="206" maxlength="20" ignoreDelKey="true" lastValidValue="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;">
						</span> 
					</td>
					<td class="rightAligned">Pct. Share</td>
					<td class="leftAligned">
						<input id="sharePercentage" type="text" class="required" style="width: 200px; text-align: right; height: 13px; float: left;" tabindex="207" maxlength="13">
					</td>
				</tr>
				<tr>
					<td width="" class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="remarks" name="txtRemarks" maxlength="2000" onkeyup="limitText(this,2000);" ignoreDelKey="true" tabindex="208"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Id</td>
					<td class="leftAligned"><input id="userId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					<td width="" class="rightAligned"><label style="float: right; margin-left: 45px;">Last Update</label></td>
					<td class="leftAligned"><input id="lastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="210"></td>
				</tr>			
			</table>
		</div>
		<div style="margin: 10px;" align="center">
			<input type="button" class="button" id="btnAddDtl" value="Add" tabindex="211">
			<input type="button" class="disabledButton" id="btnDeleteDtl" value="Delete" tabindex="212">
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="301">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="302">
</div>

<script type="text/javascript">
	var objGIISS218 = {};
	var rowIndex = -1;
	var maxItemNo = 1;
	var objCurrType = null;
	objGIISS218.bancTypeList = JSON.parse('${jsonBancType}');
	objGIISS218.exitPage = null;

	var bancTypeTable = {
		url : contextPath + "/GIISBancTypeController?action=showGiiss218&refresh=1",
		options : {
			width : '700px',
			height : '255px',
			pager : {},
			beforeClick: function(){
				if(hasPendingBancChildRecords()){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				objCurrType = bancTypeTG.geniisysRows[y];
				setFieldValues(objCurrType);
				bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
				bancTypeTG.keys.releaseKeys();
				$("bancTypeCd").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
				bancTypeTG.keys.releaseKeys();
				$("bancTypeCd").focus();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
					bancTypeTG.keys.releaseKeys();
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
				bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
				bancTypeTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
				bancTypeTG.keys.releaseKeys();
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
				bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
				bancTypeTG.keys.releaseKeys();
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
			{		
			    id: 'recordStatus',
			    width: '0',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},	
			{
				id : "bancTypeCd",
				title : "Bancassurance Type",
				filterOption : true,
				width : '130px'
			},
			{
				id : 'bancTypeDesc',
				title : 'Description',
				filterOption : true,
				width : '420px'		
			},
			{
				id : 'rate',
				title: 'Rate',
				align: 'right',
				titleAlign: 'right',
				width : '120px',
				filterOption : true,
				filterOptionType: 'numberNoNegative',
				renderer : function(value){
					return formatToNthDecimal(value, 7);
				}
			}
		],
		rows : objGIISS218.bancTypeList.rows
	};
	bancTypeTG = new MyTableGrid(bancTypeTable);
	bancTypeTG.pager = objGIISS218.bancTypeList;
	bancTypeTG.render("bancTypeTable");
	
	var dtlRowIndex = -1;
	var objCurrDtl = null;
	
	var bancTypeDtlTable = {
		url : contextPath + "/GIISBancTypeController?action=showBancTypDtl&refresh=1",
		options : {
			width : '700px',
			height : '255px',
			hideColumnChildTitle: true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				dtlRowIndex = y;
				objCurrDtl = bancTypeDtlTG.geniisysRows[y];
				setDtlFieldValues(objCurrDtl);
				bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
				bancTypeDtlTG.keys.releaseKeys();
				$("itemNo").focus();
			},
			onRemoveRowFocus : function(){
				dtlRowIndex = -1;
				setDtlFieldValues(null);
				bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
				bancTypeDtlTG.keys.releaseKeys();
				$("itemNo").focus();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					dtlRowIndex = -1;
					setDtlFieldValues(null);
					bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
					bancTypeDtlTG.keys.releaseKeys();
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
				dtlRowIndex = -1;
				setDtlFieldValues(null);
				bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
				bancTypeDtlTG.keys.releaseKeys();
			},
			onRefresh: function(){
				dtlRowIndex = -1;
				setDtlFieldValues(null);
				bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
				bancTypeDtlTG.keys.releaseKeys();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				dtlRowIndex = -1;
				setDtlFieldValues(null);
				bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
				bancTypeDtlTG.keys.releaseKeys();
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
			{		
			    id: 'recordStatus',
			    width: '0',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			{
				id: 'fixedTag',
				title: '&#160;F',
            	width: '23px',
            	altTitle: 'Fixed',
            	titleAlign: 'center',
            	sortable: false,
            	editable: false,
            	hideSelectAllBox: true,
            	editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
		            	return value ? "Y" : "N";
	            	}
            	})
			},
			{
				id : "itemNo",
				title : "Item No.",
				filterOption : true,
				filterOptionType: 'integerNoNegative',
				width : '80px',
				renderer: function(value){
					return lpad(value, 3, "0");
				}
			},
			{	id: 'intmNoAndName',
				title: 'Intermediary',
				width: '310px',
				children: [
					{	id: 'intmNo',							
						width: 90,							
						sortable: false,
						renderer: function(value){
							return nvl(value, "") == "" ? "" : lpad(value, 12, "0");
						}
					},
					{	id: 'intmName',
						title: 'Intm Name',
						width: 220,
						sortable: false,
						filterOption: true
					}
				]
			},
			{
				id : 'intmTypeDesc',
				title : 'Intermediary Type',
				filterOption : true,
				width : '150px'		
			},
			{
				id : 'sharePercentage',
				title: 'Pct. Share',
				align: 'right',
				titleAlign: 'right',
				width : '100px',
				filterOption : true,
				filterOptionType: 'numberNoNegative',
				renderer: function(value){
					return formatToNineDecimal(value);
				}
			}
		],
		rows : []
	};
	bancTypeDtlTG = new MyTableGrid(bancTypeDtlTable);
	bancTypeDtlTG.pager = {};
	bancTypeDtlTG.render("bancTypeDtlTable");
	bancTypeDtlTG.afterRender = function(){
		if(bancTypeDtlTG.geniisysRows.length > 0){
			maxItemNo = bancTypeDtlTG.geniisysRows[0].maxItemNo;
			$("pctTotal").value = formatToNineDecimal(nvl(bancTypeDtlTG.pager.bancTypeDtlTotal, 0));
		}else{
			maxItemNo = 1;
			$("pctTotal").value = rowIndex == -1 ? "" : "0.000000000";
		}
	};
	
	function showIntmTypeLOV(){
		try{
			if($F("intmNo") != ""){
				showWaitingMessageBox("You cannot change intermediary type of this intermediary.", "I", function(){
					$("intmDesc").value = $("intmDesc").getAttribute("lastValidValue");
				});
				return;
			}
			
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss218IntmTypeLOV",
					filterText: $F("intmDesc") != $("intmDesc").getAttribute("lastValidValue") ? nvl($F("intmDesc"), "%") : "%"
				},
				title: "List of Intermediary Types",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "intmType",
									title: "Intm Type",
									width: "100px"
								},
								{	id: "intmName",
									title: "Intm Desc",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("intmDesc") != $("intmDesc").getAttribute("lastValidValue") ? nvl($F("intmDesc"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("intmType").value = row.intmType;
						$("intmDesc").value = unescapeHTML2(row.intmName);
						$("intmDesc").setAttribute("lastValidValue", row.intmName);
					}
				},
				onCancel: function(){
					$("intmDesc").value = $("intmDesc").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmDesc").value = $("intmDesc").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmTypeLOV", e);
		}
	}
	
	function createDtlNotInParam(){
		var notIn = "";
		var withPrevious = false;
		var rows = bancTypeDtlTG.geniisysRows;
		
		for(var i = 0; i < rows.length; i++){
			if(rows[i].recordStatus.toString() == "0" && rows[i].intmNo != ""){
				if(withPrevious){
					notIn += ",";
				}
				notIn += rows[i].intmNo;
				withPrevious = true;
			}
		}
		
		return (notIn != "" ? "("+notIn+")" : "");
	}
	
	function showIntmLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss218IntmLOV",
					bancTypeCd: $F("bancTypeCd"),
					filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%",
					notIn: createDtlNotInParam()
				},
				title: "List of Intermediaries",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "intmNo",
									title: "Intm No.",
									width: "100px"
								},
								{	id: "intmName",
									title: "Intm Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("intmNo").value = lpad(row.intmNo, 12, "0");
						$("intmName").value = unescapeHTML2(row.intmName);
						$("intmNo").setAttribute("lastValidValue", lpad(row.intmNo, 12, "0"));
						
						$("intmType").value = row.intmType;
						$("intmDesc").value = unescapeHTML2(row.intmDesc).toUpperCase(); ;
						$("intmDesc").setAttribute("lastValidValue", $F("intmDesc"));
						
						disableInputField("intmDesc");
						disableSearch("searchIntmType");
					}
				},
				onCancel: function(){
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmLOV", e);
		}
	}

	function newFormInstance(){
		initializeAll();
		initializeAccordion();
		makeInputFieldUpperCase();
		toggleDtlFields(true);
		
		changeTag = 0;
		
		$("bancTypeCd").focus();
		setModuleId("GIISS218");
		setDocumentTitle("Bancassurance Type Maintenance");
	}
	
	function setFieldValues(rec){
		try{
			$("bancTypeCd").value = (rec == null ? "" : unescapeHTML2(rec.bancTypeCd));
			$("bancTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.bancTypeDesc));
			$("rate").value = (rec == null ? "" : formatToNthDecimal(rec.rate, 7));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableInputField("bancTypeCd") : disableInputField("bancTypeCd");
			rec == null ? toggleDtlFields(true) : toggleDtlFields(false);
			
			objCurrType = rec;
			
			getBancTypeDtls(rec == null ? "" : unescapeHTML2(rec.bancTypeCd));
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setDtlFieldValues(rec){
		try{
			$("itemNo").value = (rec == null ? (maxItemNo == "" ? "" : lpad(maxItemNo, 3, "0")) : lpad(rec.itemNo, 3, "0"));
			$("intmType").value = (rec == null ? "" : rec.intmType);
			$("intmDesc").value = (rec == null ? "" : unescapeHTML2(rec.intmTypeDesc));
			$("intmDesc").setAttribute("lastValidValue", rec == null ? "" : unescapeHTML2(rec.intmTypeDesc));
			$("intmNo").value = (rec == null ? "" : (rec.intmNo == "" ? "" : lpad(rec.intmNo, 12, "0")));
			$("intmNo").setAttribute("lastValidValue", rec == null ? "" : lpad(rec.intmNo, 12, "0"));
			$("intmName").value = (rec == null ? "" : unescapeHTML2(rec.intmName));
			$("sharePercentage").value = (rec == null ? "" : formatToNineDecimal(rec.sharePercentage));
			$("fixedTag").checked = (rec == null ? false : (rec.fixedTag == "Y" ? true : false));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
			
			rec == null ? $("btnAddDtl").value = "Add" : $("btnAddDtl").value = "Update";
			rec == null ? disableButton("btnDeleteDtl") : enableButton("btnDeleteDtl");
			
			if(rec == null && rowIndex != -1){
				enableInputField("itemNo");
				
				enableInputField("intmDesc");
				enableSearch("searchIntmType");
			}else{
				if($F("intmNo") != ""){
					disableInputField("intmDesc");
					disableSearch("searchIntmType");
				}else{
					enableInputField("intmDesc");
					enableSearch("searchIntmType");
				}
				
				disableInputField("itemNo");
				if(rec == null && rowIndex == -1){
					$("itemNo").value = "";
					disableInputField("intmDesc");
					disableSearch("searchIntmType");
				}
			}
			
			if(rec == null) { //Apollo Cruz 11.18.2014
				$("intmNo").removeClassName("required");
				$("intmNo").up().removeClassName("required");
				$("intmDesc").removeClassName("required");
				$("intmDesc").up().removeClassName("required");
			} else {
				if($("fixedTag").checked) {
					$("intmNo").addClassName("required");
					$("intmNo").up().addClassName("required");
					$("intmDesc").addClassName("required");
					$("intmDesc").up().addClassName("required");
				} else {
					$("intmNo").removeClassName("required");
					$("intmNo").up().removeClassName("required");
					$("intmDesc").removeClassName("required");
					$("intmDesc").up().removeClassName("required");
				}
			}
			
			objCurrDtl = rec;
		} catch(e){
			showErrorMessage("setDtlFieldValues", e);
		}
	}
	
	function toggleDtlFields(readOnly){
		$("itemNo").readOnly = readOnly;
		$("intmNo").readOnly = readOnly;
		$("intmDesc").readOnly = readOnly;
		$("sharePercentage").readOnly = readOnly;
		$("remarks").readOnly = readOnly;
		$("fixedTag").disabled = readOnly;
		readOnly ? disableSearch("searchIntmNo") : enableSearch("searchIntmNo");
		readOnly ? disableSearch("searchIntmType") : enableSearch("searchIntmType");
		readOnly ? disableButton("btnAddDtl") : enableButton("btnAddDtl");
		readOnly ? disableButton("btnDeleteDtl") : enableButton("btnDeleteDtl");
	}
	
	function getBancTypeDtls(bancTypeCd){
		bancTypeDtlTG.url = contextPath +"/GIISBancTypeController?action=getBancTypeDtls&bancTypeCd="+bancTypeCd;
		bancTypeDtlTG._refreshList();
	}
	
	function hasPendingBancChildRecords(){
		try{
			return getDeletedJSONObjects(bancTypeDtlTG.geniisysRows).length > 0 ||
					getAddedAndModifiedJSONObjects(bancTypeDtlTG.geniisysRows).length > 0 ? true : false;
		}catch(e){
			showErrorMessage("hasPendingBancChildRecords", e);
		}
	}
	
	function validateRate(id){
		if($F(id) != ""){
			var field = id == "rate" ? "Rate" : "Pct. Share";
			var decimalPlaces = id == "rate" ? 7 : 9;
			
			if(isNaN($F(id)) || parseFloat($F(id)) < 0 || parseFloat($F(id)) > 100){
				showWaitingMessageBox("Invalid " + field + ". Valid value should be from 0.0000000 to 100.0000000.", "E", function(){
					$(id).value = formatToNthDecimal($(id).getAttribute("lastValidValue"), decimalPlaces);
					$(id).focus();
				});
			}else{
				$(id).value = formatToNthDecimal($F(id), decimalPlaces);
			}
		}
	}
	
	function validateItemNo(){
		if($F("itemNo") != ""){
			if(isNaN($F("itemNo")) || parseFloat($F("itemNo")) < 1 || parseFloat($F("itemNo")) > 999){
				showWaitingMessageBox("Invalid Item No. Valid value should be from 1 to 999.", "E", function(){
					$("itemNo").value = $("itemNo").getAttribute("lastValidValue");
					$("itemNo").focus();
				});
			}else{
				$("itemNo").value = lpad($F("itemNo"), 3, "0");
			}
		}
	}
	
	function valAddRec(){
		try{
			if(hasPendingBancChildRecords()){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				return;
			}
			
			if(checkAllRequiredFieldsInDiv("bancTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i = 0; i < bancTypeTG.geniisysRows.length; i++){
						if(bancTypeTG.geniisysRows[i].recordStatus == 0 || bancTypeTG.geniisysRows[i].recordStatus == 1){
							if(unescapeHTML2(bancTypeTG.geniisysRows[i].bancTypeCd) == $F("bancTypeCd")){
								addedSameExists = true;	
							}
						}else if(bancTypeTG.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(bancTypeTG.geniisysRows[i].bancTypeCd) == $F("bancTypeCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same banc_type_cd.", "E");
						return;
					}else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISBancTypeController", {
						parameters : {
							action : "valAddRec",
							bancTypeCd : $F("bancTypeCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss218;
			var rec = setRec(objCurrType);
			if($F("btnAdd") == "Add"){
				bancTypeTG.addBottomRow(rec);
			} else {
				bancTypeTG.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			bancTypeTG.keys.removeFocus(bancTypeTG.keys._nCurrentFocus, true);
			bancTypeTG.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			var lastUpdate = new Date();
			
			obj.bancTypeCd = escapeHTML2($F("bancTypeCd"));
			obj.bancTypeDesc = escapeHTML2($F("bancTypeDesc"));
			obj.rate = $F("rate");
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			maxItemNo = parseInt(maxItemNo) + 1;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valAddDtl(){
		try{
			if($F("intmNo") == "" && $F("intmDesc") == ""){
				showMessageBox("Please provide either Intermediary Number/Name or Intermediary Type.", "I");
				return;
			}
			
			if(checkAllRequiredFieldsInDiv("bancTypeDtlFormDiv")){
				if($F("btnAddDtl") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i = 0; i < bancTypeDtlTG.geniisysRows.length; i++){
						if(bancTypeDtlTG.geniisysRows[i].recordStatus == 0 || bancTypeDtlTG.geniisysRows[i].recordStatus == 1){
							if(bancTypeDtlTG.geniisysRows[i].itemNo == $F("itemNo")){
								addedSameExists = true;	
							}
						}else if(bancTypeDtlTG.geniisysRows[i].recordStatus == -1){
							if(bancTypeDtlTG.geniisysRows[i].itemNo == $F("itemNo")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same banc_type_cd and item_no.", "E");
						return;
					}else if(deletedSameExists && !addedSameExists){
						addDtl();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISBancTypeController", {
						parameters : {
							action : "valAddDtl",
							bancTypeCd : $F("bancTypeCd"),
							itemNo : $F("itemNo")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addDtl();
							}
						}
					});
				} else {
					addDtl();
				}
			}
		} catch(e){
			showErrorMessage("valAddDtl", e);
		}
	}
	
	function addDtl(){
		try {
			var oldPct = objCurrDtl == null ? 0 : objCurrDtl.sharePercentage;
			var newPct = 0;
			
			if($F("btnAddDtl") == "Add"){
				newPct = formatToNineDecimal(parseFloat($F("pctTotal")) + parseFloat(nvl($F("sharePercentage"), 0)));
			} else {
				newPct = formatToNineDecimal(parseFloat(parseFloat($F("pctTotal")) - parseFloat(nvl(oldPct, 0))) +
										parseFloat(nvl($F("sharePercentage"), 0)));
			}
			
			if(parseFloat(newPct) > parseFloat(100)){
				showMessageBox("Total rate should not exceed 100%.", "I");
				return;
			}
			
			changeTagFunc = saveGiiss218;
			var rec = setDtl(objCurrDtl);
			
			if($F("btnAddDtl") == "Add"){
				bancTypeDtlTG.addBottomRow(rec);
			} else {
				bancTypeDtlTG.updateVisibleRowOnly(rec, dtlRowIndex, false);
			}
			$("pctTotal").value = newPct;
			
			changeTag = 1;
			setDtlFieldValues(null);
			bancTypeDtlTG.keys.removeFocus(bancTypeDtlTG.keys._nCurrentFocus, true);
			bancTypeDtlTG.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addDtl", e);
		}
	}
	
	function setDtl(rec){
		try {
			var obj = (rec == null ? {} : rec);
			var lastUpdate = new Date();
			
			obj.bancTypeCd = $F("bancTypeCd");
			obj.itemNo = $F("itemNo");
			obj.intmNo = $F("intmNo");
			obj.intmName = $F("intmName");
			obj.intmType = $F("intmType");
			obj.intmTypeDesc = $F("intmDesc");
			obj.sharePercentage = $F("sharePercentage");
			obj.remarks = escapeHTML2($F("remarks"));
			obj.fixedTag = $("fixedTag").checked ? "Y" : "N";
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			maxItemNo =  parseInt(maxItemNo) + 1;
			
			return obj;
		} catch(e){
			showErrorMessage("setDtl", e);
		}
	}
	
	function deleteRec(){
		if(hasPendingBancChildRecords()){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		changeTagFunc = saveGiiss218;
		objCurrType.recordStatus = -1;
		bancTypeTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function deleteDtl(){
		if(parseInt($F("itemNo")) == maxItemNo-1){
			maxItemNo = $F("itemNo");
		}
		
		changeTagFunc = saveGiiss218;
		objCurrDtl.recordStatus = -1;
		$("pctTotal").value = formatToNineDecimal(parseFloat($F("pctTotal")) - parseFloat(nvl(objCurrDtl.sharePercentage, 0)));
		bancTypeDtlTG.deleteRow(dtlRowIndex);
		changeTag = 1;
		setDtlFieldValues(null);
	}
	
	function saveGiiss218(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(bancTypeTG.geniisysRows);
		var delRows = getDeletedJSONObjects(bancTypeTG.geniisysRows);
		var setDtlRows = getAddedAndModifiedJSONObjects(bancTypeDtlTG.geniisysRows);
		var delDtlRows = getDeletedJSONObjects(bancTypeDtlTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISBancTypeController", {
			method: "POST",
			parameters: {
				action: "saveGiiss218",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows),
				setDtlRows: prepareJsonAsParameter(setDtlRows),
				delDtlRows: prepareJsonAsParameter(delDtlRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS218.exitPage != null) {
							objGIISS218.exitPage();
						} else {
							bancTypeTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss218(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS218.exitPage = exitPage;
						saveGiiss218();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("itemNo").observe("focus", function(){
		$("itemNo").setAttribute("lastValidValue", $F("itemNo"));
	});
	
	$("itemNo").observe("change", function(){
		validateItemNo();
	});
	
	$("intmDesc").observe("change", function(){
		if($F("intmDesc") == ""){
			$("intmDesc").setAttribute("lastValidValue", "");
			$("intmType").value = "";
		}else{
			showIntmTypeLOV();
		}
	});
	
	$("intmNo").observe("change", function(){
		if($F("intmNo") == ""){
			$("intmNo").setAttribute("lastValidValue", "");
			$("intmName").value = "";
			
			enableInputField("intmDesc");
			enableSearch("searchIntmType");
		}else{
			showIntmLOV();
		}
	});
	
	$("rate").observe("focus", function(){
		$("rate").setAttribute("lastValidValue", formatToNthDecimal($F("rate"), 7));
	});
	
	$("sharePercentage").observe("focus", function(){
		$("sharePercentage").setAttribute("lastValidValue", formatToNineDecimal($F("sharePercentage")));
	});
	
	$("rate").observe("change", function(){
		validateRate("rate");
	});
	
	$("sharePercentage").observe("change", function(){
		validateRate("sharePercentage");
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 2000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnAddDtl").observe("click", valAddDtl);
	$("btnDeleteDtl").observe("click", deleteDtl);
	$("btnCancel").observe("click", cancelGiiss218);
	$("searchIntmType").observe("click", showIntmTypeLOV);
	$("searchIntmNo").observe("click", showIntmLOV);
	
	observeSaveForm("btnSave", saveGiiss218);
	observeReloadForm("reloadForm", showGiiss218);
	
	$("fixedTag").observe("click", function(){ //Apollo Cruz 11.18.2014
		if(this.checked){
			$("intmNo").addClassName("required");
			$("intmNo").up().addClassName("required");
			$("intmDesc").addClassName("required");
			$("intmDesc").up().addClassName("required");
		} else {
			$("intmNo").removeClassName("required");
			$("intmNo").up().removeClassName("required");
			$("intmDesc").removeClassName("required");
			$("intmDesc").up().removeClassName("required");
		}
	});
	
	newFormInstance();
</script>