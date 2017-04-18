<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giiss167MainDiv" name="giiss167MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Events Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss167" name="giiss167">
		<div class="sectionDiv" id="giiss167LovDiv">
			<div style="" align="center" id="lovDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned">Display Column</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 90px; height: 22px; margin: 2px 2px 0 0; float: left;">
								<input id="txtDspColId" name="txtDspColId" type="text" class="required integerNoNegativeUnformatted" style="width: 57px; text-align: right; height: 13px; float: left; border: none;" tabindex="201" maxlength="2">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchColumn" name="imgSearchColumn" alt="Go" style="float: right;">
							</span>
							<input id="txtDspColName" name="txtDspColName" type="text" style="width: 400px; height: 16px;" readonly="readonly" tabindex="202"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="giisDspColumnTableDiv" style="padding-top: 10px;">
				<div id="giisDspColumnTable" style="height: 340px; margin-left: 90px;"></div>
			</div>
			<div id="giisDspColumnFormDiv" style="margin-left: 150px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Table Name</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 540px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtTableName" name="txtTableName" style="width: 512px; float: left; border: none; height: 15px; margin: 0;" maxlength="50" tabindex="203" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchTableName" name="imgSearchTableName" alt="Go" style="float: right;">
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Column Name</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 540px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtColumnName" name="txtColumnName" style="width: 512px; float: left; border: none; height: 15px; margin: 0;" maxlength="50" tabindex="204" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchColumnName" name="imgSearchColumnName" alt="Go" style="float: right;">
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="207">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="208">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="209">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="210">
</div>
<input type="hidden" id="txtOldTableName"/>
<input type="hidden" id="txtOldColumnName"/>
<input type="hidden" id="txtDatabaseTag"/>
<script type="text/javascript">
	setModuleId("GIISS167");
	setDocumentTitle("Events Maintenance");
	$("mainNav").hide();
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	setForm(false);
	function setForm(enable){
		if(enable){
			$("txtTableName").readOnly = false;
			$("txtColumnName").readOnly = false;
			enableSearch("imgSearchTableName");
			enableSearch("imgSearchColumnName");
			//$("imgSearchTableName").show();
			//$("imgSearchColumnName").show();
			enableButton("btnAdd");
		} else {
			$("txtTableName").readOnly = true;
			$("txtColumnName").readOnly = true;
			disableSearch("imgSearchTableName");
			disableSearch("imgSearchColumnName");
			//$("imgSearchTableName").hide();
			//$("imgSearchColumnName").hide();
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	var objGIISS167 = {};
	var objCurrDspColumn = null;
	objGIISS167.dspColumnList = JSON.parse('${jsonDspColumnsList}');
	objGIISS167.exitPage = null;
	
	var giisDspColumnTableModel = {
			url : contextPath + "/GIISDspColumnController?action=showDisplayColumns&refresh=1",
			options : {
				width : '750px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrDspColumn = tbgGiisDspColumn.geniisysRows[y];
					setFieldValues(objCurrDspColumn);
					tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
					tbgGiisDspColumn.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
					tbgGiisDspColumn.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
						tbgGiisDspColumn.keys.releaseKeys();
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
					tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
					tbgGiisDspColumn.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
					tbgGiisDspColumn.keys.releaseKeys();
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
					tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
					tbgGiisDspColumn.keys.releaseKeys();
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
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'tableName',
					filterOption : true,
					title : 'Table Name',
					width : '350px'				
				},
				{
					id : 'columnName',
					filterOption : true,
					title : 'Column Name',
					width : '350px'				
				},
				{
					id : 'dspColId',
					width : '0',
					visible: false
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				},
				{
					id : 'oldTableName',
					width : '0',
					visible: false				
				},
				{
					id : 'oldColumnName',
					width : '0',
					visible: false
				},
				{
					id : 'databaseTag',
					width : '0',
					visible : false
				}
			],
			rows : objGIISS167.dspColumnList.rows
	};
	tbgGiisDspColumn = new MyTableGrid(giisDspColumnTableModel);
	tbgGiisDspColumn.pager = objGIISS167.dspColumnList;
	tbgGiisDspColumn.render("giisDspColumnTable");
	
	function setFieldValues(rec){
		try{
			$("txtTableName").value = (rec == null ? "" : unescapeHTML2(rec.tableName));
			$("txtTableName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.tableName)));
			rec == null ? enableSearch("imgSearchTableName") : (rec.databaseTag == "Y" ? disableSearch("imgSearchTableName") : enableSearch("imgSearchTableName"));
			rec == null ? $("txtTableName").readOnly = false : (rec.databaseTag == "Y" ? $("txtTableName").readOnly = true : $("txtTableName").readOnly = false);
			$("txtColumnName").value = (rec == null ? "" : unescapeHTML2(rec.columnName));
			$("txtColumnName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.columnName)));
			rec == null ? enableSearch("imgSearchColumnName") : (rec.databaseTag == "Y" ? disableSearch("imgSearchColumnName") : enableSearch("imgSearchColumnName"));
			rec == null ? $("txtColumnName").readOnly = false : (rec.databaseTag == "Y" ? $("txtColumnName").readOnly = true : $("txtColumnName").readOnly = false);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			$("txtOldTableName").value = (rec == null ? "" : unescapeHTML2(rec.oldTableName));
			$("txtOldColumnName").value = (rec == null ? "" : unescapeHTML2(rec.oldColumnName));
			
			$("txtDatabaseTag").value = (rec == null ? "" : rec.databaseTag);
			
			rec == null ? enableButton("btnAdd") : (rec.databaseTag == "Y" ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update");
			rec == null ? $("btnAdd").value = "Add" : (rec.databaseTag == "Y" ? disableButton("btnAdd") : enableButton("btnAdd"));
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrDspColumn = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("txtDspColId").setAttribute("lastValidValue", "");
	$("imgSearchColumn").observe("click", showGiiss167Column);
	$("txtDspColId").observe("keyup", function(){
		$("txtDspColId").value = $F("txtDspColId").toUpperCase();
	});
	$("txtDspColId").observe("change", function() {
		if($F("txtDspColId").trim() == "") {
			$("txtDspColId").value = "";
			$("txtDspColId").setAttribute("lastValidValue", "");
			$("txtDspColName").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtDspColId").trim() != "" && $F("txtDspColId") != $("txtDspColId").readAttribute("lastValidValue")) {
				showGiiss167Column();
			}
		}
	});
	
	function showGiiss167Column(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss167Column",
				filterText : ($("txtDspColId").readAttribute("lastValidValue").trim() != $F("txtDspColId").trim() ? $F("txtDspColId").trim() : ""),
				page : 1
			},
			title: "List of Columns",
			width: 450,
			height: 400,
			columnModel : [
					{
						id : "colId",
						title: "Column ID.",
						width: '100px',
						filterOption: true
					},
					{
						id : "colName",
						title: "Column Name",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspColId").readAttribute("lastValidValue").trim() != $F("txtDspColId").trim() ? $F("txtDspColId").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
				$("txtDspColId").value = row.colId;
				$("txtDspColId").setAttribute("lastValidValue", row.colId);
				$("txtDspColName").value = unescapeHTML2(row.colName);
			},
			onCancel: function (){
				$("txtDspColId").value = $("txtDspColId").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspColId").value = $("txtDspColId").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("lovDiv")) {			
			tbgGiisDspColumn.url = contextPath + "/GIISDspColumnController?action=showDisplayColumns&refresh=1&dspColId=" + $F("txtDspColId");
			tbgGiisDspColumn._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtDspColId").readOnly = true;
			disableSearch("imgSearchColumn");
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtDspColId").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				
				$("txtDspColId").value = "";
				$("txtDspColId").setAttribute("lastValidValue", "");
				$("txtDspColName").value = "";
				$("txtDspColId").readOnly = false;
				
				enableSearch("imgSearchColumn");
				
				tbgGiisDspColumn.url = contextPath + "/GIISDspColumnController?action=showDisplayColumns&refresh=1&dspColId=" + $F("txtDspColId");
				tbgGiisDspColumn._refreshList();
				setFieldValues(null);
				changeTagFunc = "";
				changeTag = 0;
				$("txtDspColId").focus();
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
			}
		}
		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiiss167();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	$("txtTableName").setAttribute("lastValidValue", "");
	$("imgSearchTableName").observe("click", showGiiss167TableName);
	$("txtTableName").observe("keyup", function(){
		$("txtTableName").value = $F("txtTableName").toUpperCase();
	});
	$("txtTableName").observe("change", function() {
		if($F("txtTableName").trim() == "") {
			$("txtTableName").value = "";
			$("txtTableName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtTableName").trim() != "" && $F("txtTableName") != $("txtTableName").readAttribute("lastValidValue")) {
				showGiiss167TableName();
			}
		}
	});
	
	function showGiiss167TableName(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss167TableNameLov",
				filterText : ($("txtTableName").readAttribute("lastValidValue").trim() != $F("txtTableName").trim() ? $F("txtTableName").trim() : ""),
				columnName : $F("txtColumnName"),
				page : 1
			},
			title: "List of Table Name",
			width: 450,
			height: 400,
			columnModel : [
					{
						id : "tableName",
						title: "Table Name",
						width: '425px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtTableName").readAttribute("lastValidValue").trim() != $F("txtTableName").trim() ? $F("txtTableName").trim() : ""),
			onSelect: function(row) {
				$("txtTableName").value = row.tableName;
				$("txtTableName").setAttribute("lastValidValue", row.tableName);
			},
			onCancel: function (){
				$("txtTableName").value = $("txtTableName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtTableName").value = $("txtTableName").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("txtColumnName").setAttribute("lastValidValue", "");
	$("imgSearchColumnName").observe("click", showGiiss167ColumnName);
	$("txtColumnName").observe("keyup", function(){
		$("txtColumnName").value = $F("txtColumnName").toUpperCase();
	});
	$("txtColumnName").observe("change", function() {
		if($F("txtColumnName").trim() == "") {
			$("txtColumnName").value = "";
			$("txtColumnName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtColumnName").trim() != "" && $F("txtColumnName") != $("txtColumnName").readAttribute("lastValidValue")) {
				showGiiss167ColumnName();
			}
		}
	});
	
	function showGiiss167ColumnName(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss167ColumnNameLov",
				filterText : ($("txtColumnName").readAttribute("lastValidValue").trim() != $F("txtColumnName").trim() ? $F("txtColumnName").trim() : ""),
				tableName : $F("txtTableName"),
				dspColId : $F("txtDspColId"),
				page : 1
			},
			title: "List of Column Name",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "columnName",
						title: "Column Name",
						width: '425px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtColumnName").readAttribute("lastValidValue").trim() != $F("txtColumnName").trim() ? $F("txtColumnName").trim() : ""),
			onSelect: function(row) {
				$("txtColumnName").value = row.columnName;
				$("txtColumnName").setAttribute("lastValidValue", row.columnName);
			},
			onCancel: function (){
				$("txtColumnName").value = $("txtColumnName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtColumnName").value = $("txtColumnName").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisDspColumnFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;					
				
				for(var i = 0; i<tbgGiisDspColumn.geniisysRows.length; i++){
					if(tbgGiisDspColumn.geniisysRows[i].recordStatus == 0 || tbgGiisDspColumn.geniisysRows[i].recordStatus == 1){								
						if(tbgGiisDspColumn.geniisysRows[i].tableName == $F("txtTableName") && tbgGiisDspColumn.geniisysRows[i].columnName == $F("txtColumnName")){
							addedSameExists = true;								
						}							
					} else if(tbgGiisDspColumn.geniisysRows[i].recordStatus == -1){
						if(tbgGiisDspColumn.geniisysRows[i].tableName == $F("txtTableName") && tbgGiisDspColumn.geniisysRows[i].columnName == $F("txtColumnName")){
							deletedSameExists = true;
						}
					}
				}
				
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					showMessageBox("Record already exists with the same table_name and column_name.", "E");
					return;
				} else if(deletedSameExists && !addedSameExists){
					addRec();
					return;
				}
				
				new Ajax.Request(contextPath + "/GIISDspColumnController", {
					parameters : {
						action : "valAddRec",
						dspColId : $F("txtDspColId"),
						tableName : $F("txtTableName"),
						columnName : $F("txtColumnName")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRec();
						}
					}
				});
			} 
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss167;
			var dspColumn = setRec(objCurrDspColumn);
			if($F("btnAdd") == "Add"){
				tbgGiisDspColumn.addBottomRow(dspColumn);
			} else {
				tbgGiisDspColumn.updateVisibleRowOnly(dspColumn, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGiisDspColumn.keys.removeFocus(tbgGiisDspColumn.keys._nCurrentFocus, true);
			tbgGiisDspColumn.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.dspColId = $F("txtDspColId");
			obj.tableName = $F("txtTableName");
			obj.oldTableName = $F("txtOldTableName");
			obj.columnName = $F("txtColumnName");
			obj.oldColumnName = $F("txtOldColumnName");
			obj.databaseTag = $F("txtDatabaseTag");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss167;
		objCurrDspColumn.recordStatus = -1;
		tbgGiisDspColumn.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function cancelGiiss167(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS167.exitPage = exitPage;
						saveGiiss167();						
					}, function(){
						goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
						changeTag = 0;
						changeTagFunc = "";
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToWorkflow", "Workflow Main", null);
	}
	
	function saveGiiss167(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGiisDspColumn.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGiisDspColumn.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIISDspColumnController", {
			method: "POST",
			parameters : {
				action : "saveGiiss167",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS167.exitPage != null) {
							objGIISS167.exitPage();
						} else {
							tbgGiisDspColumn._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnCancel").observe("click", cancelGiiss167);
	observeSaveForm("btnSave", saveGiiss167);
	observeSaveForm("btnToolbarSave", saveGiiss167);
	
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	observeReloadForm("reloadForm", showDisplayColumns);
	$("txtDspColId").focus();
</script>