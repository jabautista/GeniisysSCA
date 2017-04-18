<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="eventColumnMainDiv" name="eventColumnMainDiv" style="width: 670px; height: 500px; padding-top: 10px;">
	<div id="eventColumn" name="eventColumn">		
		<div class="sectionDiv">
			<div id="giisEventsColumnTableDiv" style="padding-top: 10px;">
				<div id="giisEventsColumnTable" style="height: 310px; padding-left: 10px;"></div>
			</div>
			<div align="center" id="giisEventsColumnFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned" style="padding-right:3px;">Table Name</td>
						<td class="leftAligned">
							<input id="txtEventColCd" type="hidden">
							<span class="required lovSpan" style="width: 206px;">
								<input lastValidValue="" type="text" id="txtTableName" name="txtTableName" style=" width: 175px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101"></input>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTableName" name="searchTableName" alt="Go" style="float: right;"/>
							</span>
						</td>
						<td width="" class="rightAligned" style="padding-right:3px;">Column Name</td>
						<td class="leftAligned">	
							<span class="required lovSpan" style="width: 206px;">
								<input lastValidValue="" type="text" id="txtColumnName" name="txtColumnName" style=" width: 175px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="102"></input>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchColumnName" name="searchColumnName" alt="Go" style="float: right;"/>
							</span>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned" style="padding-right:3px;">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv2" name="remarksDiv2" style="float: left; width: 533px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 507px; margin-top: 0; border: none;" id="txtRemarks2" name="txtRemarks2" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="103"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks2"  tabindex="104"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right:3px;">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="105"></td>
						<td width="" class="rightAligned" style="padding-left: 47px; padding-right:3px;" >Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="106"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAdd2" value="Add" tabindex="107">
				<input type="button" class="button" id="btnDelete2" value="Delete" tabindex="108">
			</div>
			<div class="sectionDiv" style="margin-left:20px; width:630px; border-bottom: none; border-left: none; border-right: none;" align="center">
				<input type="button" class="button" style="margin: 10px 0 10px 0;" id="btnDisplayColumns" name="btnDisplayColumns" value="Display Columns" tabindex="109"/>
			</div>
		</div>
	</div>
</div>
<div align="center" style="padding-top: 10px;">
	<input type="button" class="button" id="btnCancel2" value="Cancel" tabindex="110">
	<input type="button" class="button" id="btnSave2" value="Save" tabindex="111">
</div>
<script type="text/javascript">	
	initializeAll();
	var giisEventsColumnTag = 0;
	var rowIndex = -1;
	
	function saveGIISEventsColumn(){
		if(giisEventsColumnTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISEventsColumn.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISEventsColumn.geniisysRows);
		new Ajax.Request(contextPath+"/GIISEventController", {
			method: "POST",
			parameters : {action : "setGIISEventsColumn",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
// 					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISEventsColumn.exitPage != null) {
							objGIISEventsColumn.exitPage();
						} else {
							tbgGIISEventsColumn._refreshList();
						}
					});
					giisEventsColumnTag = 0;
				}
			}
		});
	}
	
	var origTableName = null;
	var origColumnName = null;
	
	var objGIISEventsColumn = {};
	var objCurrGIISEventsColumn = null;
	objGIISEventsColumn.giisEventsColumnList = JSON.parse('${jsonGIISEventColumn}');
	objGIISEventsColumn.exitPage = null;
	
	var giisEventsColumnTable = {
			url : contextPath + "/GIISEventController?action=getGIISEventColumn&refresh=1&eventCd="+$F("txtEventCd"),
			id : 'giisEventsColumn',
			options : {
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISEventsColumn = tbgGIISEventsColumn.geniisysRows[y];
					setFieldValues(objCurrGIISEventsColumn);
					tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
					tbgGIISEventsColumn.keys.releaseKeys();
					$("txtTableName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
					tbgGIISEventsColumn.keys.releaseKeys();
					$("txtTableName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
						tbgGIISEventsColumn.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(giisEventsColumnTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave2").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
					tbgGIISEventsColumn.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
					tbgGIISEventsColumn.keys.releaseKeys();
				},				
				prePager: function(){
					if(giisEventsColumnTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave2").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
					tbgGIISEventsColumn.keys.releaseKeys();
				},
				checkChanges: function(){
					return (giisEventsColumnTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (giisEventsColumnTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (giisEventsColumnTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (giisEventsColumnTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (giisEventsColumnTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (giisEventsColumnTag == 1 ? true : false);
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
					id : "tableName",
					title : "Table Name",
					filterOption : true,
					width : '290px'
				},
				{
					id : 'columnName',
					title : 'Column Name',
					filterOption : true,
					width : '290px'				
				},
				{
					id : 'remarks',
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
				}
			],
			rows : objGIISEventsColumn.giisEventsColumnList.rows
		};
	tbgGIISEventsColumn = new MyTableGrid(giisEventsColumnTable);
	tbgGIISEventsColumn.pager = objGIISEventsColumn.giisEventsColumnList;
	tbgGIISEventsColumn.render("giisEventsColumnTable");
	
	function showTableNameLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "GIIS166AllTabColLOV",
					filterText : ($("txtTableName").readAttribute("lastValidValue").trim() != $F("txtTableName").trim() ? $F("txtTableName").trim() : ""),
					page : 1
				},
				title : "Table Name and Column Name",
				width : 500,
				height : 400,
				columnModel : [ {
					id : "tableName",
					title : "Table Name",
					width : '200px'
				}, {
					id : "columnName",
					title : "Column Name",
					width : '200px'
				} ],
				autoSelectOneRecord: true,
				filterText : ($("txtTableName").readAttribute("lastValidValue").trim() != $F("txtTableName").trim() ? $F("txtTableName").trim() : ""),
				onSelect : function(row) {
					$("txtTableName").value = row.tableName;
					$("txtColumnName").value = unescapeHTML2(row.columnName);
					$("txtTableName").setAttribute("lastValidValue", unescapeHTML2(row.tableName));
					$("txtColumnName").setAttribute("lastValidValue", unescapeHTML2(row.columnName));
					enableSearch("searchColumnName");
					$("txtColumnName").readOnly = false;
				},
				onCancel: function (){
					$("txtTableName").value = escapeHTML2($("txtTableName").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtTableName").value = escapeHTML2($("txtTableName").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("showTableNameLOV", e);
		}
	}
	
	function showColumnNameLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "GIIS166AllTabCol2LOV",
					tableName : $F("txtTableName"),
					filterText : ($("txtColumnName").readAttribute("lastValidValue").trim() != $F("txtColumnName").trim() ? $F("txtColumnName").trim() : ""),
					page : 1
				},
				title : "Table Name and Column Name",
				width : 500,
				height : 400,
				columnModel : [ {
					id : "columnName",
					title : "Column Name",
					width : '300px'
				} ],
				autoSelectOneRecord: true,
				filterText : ($("txtColumnName").readAttribute("lastValidValue").trim() != $F("txtColumnName").trim() ? $F("txtColumnName").trim() : ""),
				onSelect : function(row) {
					$("txtColumnName").value = unescapeHTML2(row.columnName);
					$("txtColumnName").setAttribute("lastValidValue", unescapeHTML2(row.columnName));
				},
				onCancel: function (){
					$("txtColumnName").value = escapeHTML2($("txtColumnName").readAttribute("lastValidValue"));
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtColumnName").value = escapeHTML2($("txtColumnName").readAttribute("lastValidValue"));
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("showColumnNameLOV", e);
		}
	}
		
	function enableDisableFields(divArray,toDo){
		try{
			if (divArray!= null){
				for ( var i = 0; i < divArray.length; i++) {
					$$("div#"+divArray[i]+" input[type='text'], div#"+divArray[i]+" textarea, div#"+divArray[i]+" input[type='hidden']").each(function (b) {
						if (!($(b).hasClassName("readOnly"))) {
							toDo == "enable" ?  $(b).readOnly= false : $(b).readOnly= true;
						}
					});
					$$("div#"+divArray[i]+" img").each(function (img) {
						var src = img.src;
						if(nvl(img, null) != null){
							if(src.include("searchIcon.png")){
								toDo == "enable" ? enableSearch(img) : disableSearch(img);
							}
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("enableDisableFields", e);
		}
	}
	
	function setFieldValues(rec){
		try{
			$("txtEventColCd").value = (rec == null ? "" : unescapeHTML2(rec.eventColCd));
			$("txtColumnName").value = (rec == null ? "" : unescapeHTML2(rec.columnName));
			$("txtColumnName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.columnName)));
			$("txtTableName").value = (rec == null ? "" : unescapeHTML2(rec.tableName));
			$("txtTableName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.tableName)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks2").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			origTableName = (rec == null ? "" : unescapeHTML2(rec.tableName));
			origColumnName = (rec == null ? "" : unescapeHTML2(rec.columnName));
			
			rec == null ? $("btnAdd2").value = "Add" : $("btnAdd2").value = "Update";
			rec == null ? disableButton("btnDelete2") : enableButton("btnDelete2");
			rec == null ? disableButton("btnDisplayColumns") : enableButton("btnDisplayColumns");
			
			if (rec == null) {
				enableButton("btnAdd2");
				enableDisableFields(["giisEventsColumnFormDiv"], "enable");
			} else {
				if (rec.recordStatus !== "") {
					enableButton("btnAdd2");
					enableDisableFields(["giisEventsColumnFormDiv"], "enable");
				} else {
					disableButton("btnAdd2");
					enableDisableFields(["giisEventsColumnFormDiv"], "disable");
				}
			}
			objCurrGIISEventsColumn = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eventCd = $F("txtEventCd");
			obj.columnName = escapeHTML2($F("txtColumnName"));
			obj.tableName = escapeHTML2($F("txtTableName"));
			obj.remarks = escapeHTML2($F("txtRemarks2"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			obj.origTableName = escapeHTML2(origTableName == null ? $F("txtTableName") : origTableName);
			obj.origColumnName = escapeHTML2(origColumnName == null ? $F("txtColumnName") : origColumnName);
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			var dept = setRec(objCurrGIISEventsColumn);
			if($F("btnAdd2") == "Add"){
				tbgGIISEventsColumn.addBottomRow(dept);
			} else {
				tbgGIISEventsColumn.updateVisibleRowOnly(dept, rowIndex, false);
			}
			giisEventsColumnTag = 1;
			setFieldValues(null);
			tbgGIISEventsColumn.keys.removeFocus(tbgGIISEventsColumn.keys._nCurrentFocus, true);
			tbgGIISEventsColumn.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec(mode) {
		try {
			var addedSameExists = false;
			var deletedSameExists = false;	
			var addedSameExists2 = false;
			var deletedSameExists2 = false;
			var updatedSameExists2 = false;
			for(var i=0; i<tbgGIISEventsColumn.geniisysRows.length; i++){
				if(tbgGIISEventsColumn.geniisysRows[i].recordStatus == 0 || tbgGIISEventsColumn.geniisysRows[i].recordStatus == 1){	
					if(mode == "add" && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].tableName) == $F("txtTableName") && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].columnName) == $F("txtColumnName")){
						addedSameExists = true;								
					}	
					if((origTableName != $F("txtTableName") || origColumnName != $F("txtColumnName")) && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].tableName) == $F("txtTableName") && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].columnName) == $F("txtColumnName")){
						addedSameExists2 = true;								
					}	
					if((origTableName != $F("txtTableName") || origColumnName != $F("txtColumnName")) && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].origTableName) == $F("txtTableName") && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].origColumnName) == $F("txtColumnName")){
						updatedSameExists2 = true;								
					}
				} else if(tbgGIISEventsColumn.geniisysRows[i].recordStatus == -1){
					if(mode == "add" && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].tableName) == $F("txtTableName") && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].columnName) == $F("txtColumnName")){
						deletedSameExists = true;
					}
					if((origTableName != $F("txtTableName") || origColumnName != $F("txtColumnName")) && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].tableName) == $F("txtTableName") && unescapeHTML2(tbgGIISEventsColumn.geniisysRows[i].columnName) == $F("txtColumnName")){
						deletedSameExists2 = true;								
					}	
				}
			}
			if(mode == "add" && (addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Record already exists with the same table_name and column_name.", "E");
				return;
			}else if((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
				showMessageBox("Record already exists with the same table_name and column_name.", "E");
				return;
			} else if((deletedSameExists || updatedSameExists2) && !addedSameExists && (deletedSameExists2 || updatedSameExists2) && !addedSameExists2){
				addRec();
				return;
			} else if(mode == "update" && (deletedSameExists2 || updatedSameExists2) && !addedSameExists2){
				addRec();
				return;
			}
			
			new Ajax.Request(contextPath + "/GIISEventController", {
				parameters : {action : "valAddGIISEventsColumn",
					 		  tableName : origTableName != $F("txtTableName") ? $F("txtTableName") : null,
					  		  columnName : origColumnName != $F("txtColumnName") ? $F("txtColumnName") : null},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						addRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisEventsColumnFormDiv")){
				if($F("btnAdd") == "Add") {
					valAddUpdateRec("add");
				} else {
					valAddUpdateRec("update");
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRec(){
		objCurrGIISEventsColumn.recordStatus = -1;
		tbgGIISEventsColumn.deleteRow(rowIndex);
		giisEventsColumnTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISEventController", {
				parameters : {action : "valDeleteGIISEventsColumn",
							  eventColCd : $F("txtEventColCd")},
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
	
	function exitPage(){ 
		overlayColumnList.close();
	}	
	
	function cancelGIISEventsColumn(){
		if(giisEventsColumnTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISEventsColumn.exitPage = exitPage;
						saveGIISEventsColumn();
					}, function(){
						overlayColumnList.close();
					}, "");
		} else {
			overlayColumnList.close();
		}
	}
	
	$("editRemarks2").observe("click", function(){
		showOverlayEditor("txtRemarks2", 4000, $("txtRemarks2").hasAttribute("readonly"));
	});
	
	$("txtTableName").observe("keyup", function(){
		$("txtTableName").value = $F("txtTableName").toUpperCase();
	});
	
	$("txtColumnName").observe("keyup", function(){
		$("txtColumnName").value = $F("txtColumnName").toUpperCase();
	});
	
	$("searchTableName").observe("click", showTableNameLOV);
	$("searchColumnName").observe("click", showColumnNameLOV);
	
	$("txtTableName").observe("change", function() {
		if($F("txtTableName").trim() == "") {
			$("txtTableName").clear();
			$("txtColumnName").clear();
			$("txtTableName").setAttribute("lastValidValue", "");
			disableSearch("searchColumnName");
			$("txtColumnName").readOnly = true;
		} else {
			if($F("txtTableName").trim() != "" && $F("txtTableName") != unescapeHTML2($("txtTableName").readAttribute("lastValidValue"))) {
				showTableNameLOV();
			}
		}
	});
	
	$("txtColumnName").observe("change", function() {
		if($F("txtColumnName").trim() == "") {
			$("txtColumnName").clear();
			$("txtColumnName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtColumnName").trim() != "" && $F("txtColumnName") != unescapeHTML2($("txtColumnName").readAttribute("lastValidValue"))) {
				showColumnNameLOV();
			}
		}
	});
	
	$("btnDisplayColumns").observe("click",function(){
		if (objCurrGIISEventsColumn.colModuleCond == "N") {
			showMessageBox("Display Column must be added first in the display column maintenance.","I");
		} else {
			try {
				overlayDisplayList  = 
					Overlay.show(contextPath+"/GIISEventController", {
						urlContent: true,
						urlParameters: {
							action : "getGIISEventDisplay",
							eventColCd : $F("txtEventColCd"),
						},
					    title: "List of Valid Display Columns",
					    height: 450,
					    width: 470,
					    draggable: true
					});
				} catch (e) {
					showErrorMessage("btnDisplayColumns - overlayDisplayList" , e);
				}		
		}
	});
	
	disableButton("btnDelete2");
	disableButton("btnDisplayColumns");
	disableSearch("searchColumnName");
	$("txtColumnName").readOnly = true;
	$("btnSave2").observe("click", saveGIISEventsColumn);
	$("btnCancel2").observe("click", cancelGIISEventsColumn);
	$("btnAdd2").observe("click", valAddRec);
	$("btnDelete2").observe("click", valDeleteRec);

	$("txtTableName").focus();
</script>