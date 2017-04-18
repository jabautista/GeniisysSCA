<div class="sectionDiv" style="width: 523px; margin-top: 5px;">
	<div id="functionColumnTableDiv" style="padding-top: 10px;">
		<div id="functionColumnTable" style="height: 251px; padding-left: 15px;"></div>
	</div>
	<div align="center" id="functionColumnFormDiv">
		<table style="margin-top: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Table Name</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 398px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtTableName" name="txtTableName" ignoreDelKey="1" style="width: 366px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="50" tabindex="202" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTable" name="searchTable" alt="Go" style="float: right;">
					</span> 
				</td>
			</tr>	
			<tr>
				<td width="" class="rightAligned" style="padding-right: 7px;">Column Name</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 398px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtColumnName" name="txtColumnName" ignoreDelKey="1" style="width: 366px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="50" tabindex="202" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchColumn" name="searchColumn" alt="Go" style="float: right;">
					</span> 
				</td>
			</tr>				
			<tr>
				<td width="" class="rightAligned" style="padding-right: 7px;">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div id="remarksDiv" name="remarksDiv" style="float: left; width: 398px; border: 1px solid gray; height: 22px;">
						<textarea style="float: left; height: 16px; width: 370px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">User ID</td>
				<td class="leftAligned" width="100px"><input id="txtUserId" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="206"></td>
				<td width="73px" class="rightAligned" style="padding-right: 7px;">Last Update</td>
				<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="207"></td>
			</tr>			
		</table>
	</div>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnAdd2" value="Add" tabindex="208">
		<input type="button" class="button" id="btnDelete2" value="Delete" tabindex="209">
	</div>
</div>
<div class="buttonsDiv" style="margin-bottom: 0px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveFunctionColumn(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgFunctionColumn.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgFunctionColumn.geniisysRows);
		new Ajax.Request(contextPath+"/GIACFunctionController", {
			method: "POST",
			parameters : {action : "saveFunctionColumn",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objFunctionColumn.exitPage != null) {
							objFunctionColumn.exitPage();
						} else {
							tbgFunctionColumn._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	var objFunctionColumn = {};
	var objCurrentItem = null;
	objFunctionColumn.functionColumnList = JSON.parse('${jsonFunctionColumn}');
	objFunctionColumn.exitPage = null;
	
	var functionColumnTable = {
			url : contextPath + "/GIACFunctionController?action=showFunctionColumn&refresh=1"+"&moduleId="+'${moduleId}'+"&functionCode="+'${functionCode}',
			options : {
				width : '490px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrentItem = tbgFunctionColumn.geniisysRows[y];
					setFieldValues(objCurrentItem);
					tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
					tbgFunctionColumn.keys.releaseKeys();
					$("txtColumnName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
					tbgFunctionColumn.keys.releaseKeys();
					$("txtTableName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
						tbgFunctionColumn.keys.releaseKeys();
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
					tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
					tbgFunctionColumn.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
					tbgFunctionColumn.keys.releaseKeys();
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
					tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
					tbgFunctionColumn.keys.releaseKeys();
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
					title : "Table Name",
					filterOption : true,
					width : '230px'
				},
				{
					id : 'columnName',
					filterOption : true,
					title : 'Column Name',
					width : '230px'				
				}
			],
			rows : objFunctionColumn.functionColumnList.rows
		};

		tbgFunctionColumn = new MyTableGrid(functionColumnTable);
		tbgFunctionColumn.pager = objFunctionColumn.functionColumnList;
		tbgFunctionColumn.render("functionColumnTable");
	
	function setFieldValues(rec){
		try{
			objFunctionColumn.functionColId = (rec == null ? "" : rec.functionColCd);
			$("txtTableName").value = (rec == null ? "" : unescapeHTML2(rec.tableName));
			$("txtTableName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.tableName)));
			$("txtColumnName").value = (rec == null ? "" : unescapeHTML2(rec.columnName));
			$("txtColumnName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.columnName)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? enableSearch("searchTable") : disableSearch("searchTable");
			rec == null ? enableSearch("searchColumn") : disableSearch("searchColumn");
			//rec == null ? $("btnAdd2").value = "Add" : $("btnAdd2").value = "Update";
			rec == null ? $("txtTableName").readOnly = false : $("txtTableName").readOnly = true;
			rec == null ? $("txtColumnName").readOnly = false : $("txtColumnName").readOnly = true;
			rec == null ? disableButton("btnDelete2") : enableButton("btnDelete2");
			rec == null ? enableButton("btnAdd2") : disableButton("btnAdd2");
			objCurrentItem = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.functionColCd = objFunctionColumn.functionColId;
			obj.moduleId = '${moduleId}';
			obj.functionCd = '${functionCode}';
			obj.tableName = escapeHTML2($F("txtTableName"));
			obj.columnName = escapeHTML2($F("txtColumnName"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveFunctionColumn;
			var dept = setRec(objCurrentItem);
			if($F("btnAdd2") == "Add"){
				tbgFunctionColumn.addBottomRow(dept);
			} else {
				tbgFunctionColumn.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgFunctionColumn.keys.removeFocus(tbgFunctionColumn.keys._nCurrentFocus, true);
			tbgFunctionColumn.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddFunctionColumn(){
		try{
			if(checkAllRequiredFieldsInDiv("functionColumnFormDiv")){
				if($F("btnAdd2") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgFunctionColumn.geniisysRows.length; i++) {
						if (tbgFunctionColumn.geniisysRows[i].recordStatus == 0 || tbgFunctionColumn.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgFunctionColumn.geniisysRows[i].tableName) == $F("txtTableName") && unescapeHTML2(tbgFunctionColumn.geniisysRows[i].columnName) == $F("txtColumnName")) {
								addedSameExists = true;
							}
						} else if (tbgFunctionColumn.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgFunctionColumn.geniisysRows[i].tableName) == $F("txtTableName") && unescapeHTML2(tbgFunctionColumn.geniisysRows[i].columnName) == $F("txtColumnName")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same table_name and column_name.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACFunctionController", {
						parameters : {
							action : "valAddFunctionColumn",
							moduleId : '${moduleId}',
							functionCd : '${functionCode}',
							tableName : $F("txtTableName"),
							columnName : $F("txtColumnName")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch (e) {
			showErrorMessage("valAddFunctionColumn", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveFunctionColumn;
		objCurrentItem.recordStatus = -1;
		tbgFunctionColumn.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function exitPage() {
		overlayFunctionColumn.close();
		delete overlayFunctionColumn;
	}

	function cancelFunctionColumn() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objFunctionColumn.exitPage = exitPage;
						saveFunctionColumn();
					}, function() {
						changeTag = 0;
						overlayFunctionColumn.close();
						delete overlayFunctionColumn;
					}, "");
		} else {
			changeTag = 0;
			overlayFunctionColumn.close();
			delete overlayFunctionColumn;
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete2");

	observeSaveForm("btnSave", saveFunctionColumn);
	$("btnCancel").observe("click", cancelFunctionColumn);
	$("btnAdd2").observe("click", valAddFunctionColumn);
	$("btnDelete2").observe("click", deleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtTableName").focus();
	
	function showTableLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs314TableLOV",
					  search : x,
						page : 1
				},
				title: "List of Table Names",
				width: 410,
				height: 400,
				columnModel: [
		 			{
						id : 'tableName',
						title: 'Table Name',
						width : '385px',
						align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtTableName").value = unescapeHTML2(row.tableName);
						if (row.tableName != $("txtTableName").getAttribute("lastValidValue")){
							$("txtColumnName").value = "";
							$("txtColumnName").setAttribute("lastValidValue",  "");
						}
						$("txtTableName").setAttribute("lastValidValue",  unescapeHTML2(row.tableName));
					}
				},
				onCancel: function(){
					$("txtTableName").focus();
					$("txtTableName").value = $("txtTableName").getAttribute("lastValidValue");
			  	},
			  	onUndefinedRow: function(){
		  			$("txtTableName").value = $("txtTableName").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTableName");
		  		}
			});
		}catch(e){
			showErrorMessage("showTableLOV",e);
		}
	}
	
	function showColumnLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs314ColumnLOV",
					  tableName: $("txtTableName").value,
					  search : x,
						page : 1
				},
				title: "List of Column Names",
				width: 410,
				height: 400,
				columnModel: [
		 			{
						id : 'columnName',
						title: 'Column Name',
						width : '385px',
						align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtColumnName").value = unescapeHTML2(row.columnName);
						$("txtColumnName").setAttribute("lastValidValue",  unescapeHTML2(row.columnName));
					}
				},
				onCancel: function(){
					$("txtColumnName").focus();
					$("txtColumnName").value = $("txtColumnName").getAttribute("lastValidValue");
			  	},
			  	onUndefinedRow: function(){
		  			$("txtColumnName").value = $("txtColumnName").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtColumnName");
		  		}
			});
		}catch(e){
			showErrorMessage("showColumnLOV",e);
		}
	}
	
	function validateTable(){
		new Ajax.Request(contextPath+"/GIACFunctionController", {
			method: "POST",
			parameters: {
				action: "validateGiacs314Table",
				tableName: $("txtTableName").value
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.tableName, "") == ""){
						showTableLOV($("txtTableName").value);
					} else if(obj.tableName == "---"){
						showTableLOV($("txtTableName").value);
					} else{
						$("txtTableName").value = unescapeHTML2(obj.tableName);
						if (obj.tableName != $("txtTableName").getAttribute("lastValidValue")){
							$("txtColumnName").value = "";
							$("txtColumnName").setAttribute("lastValidValue",  "");
						}
						$("txtTableName").setAttribute("lastValidValue",  unescapeHTML2(obj.tableName));
					}
				}
			}
		});
	}
	
	function validateColumn(){
		new Ajax.Request(contextPath+"/GIACFunctionController", {
			method: "POST",
			parameters: {
				action: "validateGiacs314Column",
				tableName: $("txtTableName").value,
				columnName : $("txtColumnName").value
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.columnName, "") == ""){
						showColumnLOV($("txtColumnName").value);
					} else if(obj.columnName == "---"){
						showColumnLOV($("txtColumnName").value);
					} else{
						$("txtColumnName").setAttribute("lastValidValue",  unescapeHTML2(obj.columnName));
						$("txtColumnName").value = unescapeHTML2(obj.columnName);
					}
				}
			}
		});
	}
	
	$("searchTable").observe("click", function(){
		showTableLOV("%");
	});
	
	$("searchColumn").observe("click", function(){
		/* if($("txtTableName").value == ""){
			showWaitingMessageBox("Enter Table Name.", "I", function(){
				$("txtTableName").focus();
				$("txtColumnName").value = "";
			});
		} else { */
			showColumnLOV("%");
		//}
	});
	
	$("txtTableName").observe("change", function(){
		if($("txtTableName").value != ""){
			validateTable();
		} else {
			$("txtTableName").setAttribute("lastValidValue",  "");
			$("txtColumnName").value = "";
			$("txtColumnName").setAttribute("lastValidValue",  "");
		}
	});
	
	$("txtColumnName").observe("change", function(){
		//if($("txtTableName").value != ""){
			if($("txtColumnName").value != ""){
				validateColumn();
			} else if ($("txtColumnName").value == ""){
				$("txtColumnName").setAttribute("lastValidValue",  "");
			}
		/*}  else {
			showWaitingMessageBox("Enter Table Name.", "I", function(){
				$("txtTableName").focus();
				$("txtColumnName").value = "";
			});
		} */
	});
</script>