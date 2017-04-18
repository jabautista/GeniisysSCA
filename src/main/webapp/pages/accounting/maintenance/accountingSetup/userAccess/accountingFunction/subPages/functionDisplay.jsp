<div class="sectionDiv" style="width: 543px;margin-top: 5px;">
	<div id="functionColumnTableDiv" style="padding-top: 10px;">
		<div id="functionColumnTable" style="height: 251px; padding-left: 20px;"></div>
	</div>
	<div align="center" id="functionColumnFormDiv">
		<table style="margin-top: 5px;">
			<tr>
				<td class="rightAligned" style="padding-right: 8px;">Display Column</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 405px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtColumnName" name="txtColumnName" style="width: 373px; float: left; border: none; height: 13px;" ignoreDelKey="1" class="required allCaps" maxlength="100" tabindex="202" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDisplayColumn" name="searchDisplayColumn" alt="Go" style="float: right;">
					</span> 
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">User ID</td>
				<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="206"></td>
				<td width="80px" class="rightAligned" style="padding-right: 5px;">Last Update</td>
				<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="207"></td>
			</tr>			
		</table>
	</div>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
		<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
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
			parameters : {action : "saveColumnDisplay",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objFunctionDisplay.exitPage != null) {
							objFunctionDisplay.exitPage();
						} else {
							tbgFunctionColumn._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	var objFunctionDisplay = {};
	var objCurrentItem = null;
	objFunctionDisplay.functionColumnList = JSON.parse('${jsonFunctionDisplay}');
	objFunctionDisplay.exitPage = null;
	objFunctionDisplay.displayColId = null;
	
	var functionColumnTable = {
			url : contextPath + "/GIACFunctionController?action=showFunctionDisplay&refresh=1"+"&moduleId="+'${moduleId}'+"&functionCode="+'${functionCode}',
			options : {
				width : '505px',
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
					$("txtColumnName").focus();
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
				},/*{
					id : 'displayColId',
					title : "Column Id",
					filterOption : true,
					width : '100px',
					align : "right",
					titleAlign : "right",
					filterOptionType: 'integerNoNegative'
				},*/
				{
					id : 'displayColName',
					title : "Display Column",
					filterOption : true,
					width : '480px'
				}
			],
			rows : objFunctionDisplay.functionColumnList.rows
		};

		tbgFunctionColumn = new MyTableGrid(functionColumnTable);
		tbgFunctionColumn.pager = objFunctionDisplay.functionColumnList;
		tbgFunctionColumn.render("functionColumnTable");
	
	function setFieldValues(rec){
		try{
			objFunctionDisplay.displayColId = (rec == null ? "" : rec.displayColId);
			$("txtColumnName").value = (rec == null ? "" : unescapeHTML2(rec.displayColName));
			$("txtColumnName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.displayColName)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			//rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? enableButton("btnAdd") : disableButton("btnAdd");
			rec == null ? $("txtColumnName").readOnly = false : $("txtColumnName").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? enableSearch("searchDisplayColumn") : disableSearch("searchDisplayColumn");
			objCurrentItem = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.moduleId = '${moduleId}';
			obj.functionCd = '${functionCode}';
			obj.displayColId = objFunctionDisplay.displayColId;
			obj.displayColName = escapeHTML2($F("txtColumnName"));
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
			if($F("btnAdd") == "Add"){
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
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgFunctionColumn.geniisysRows.length; i++) {
						if (tbgFunctionColumn.geniisysRows[i].recordStatus == 0 || tbgFunctionColumn.geniisysRows[i].recordStatus == 1) {
							if (tbgFunctionColumn.geniisysRows[i].displayColId == objFunctionDisplay.displayColId) {
								addedSameExists = true;
							}
						} else if (tbgFunctionColumn.geniisysRows[i].recordStatus == -1) {
							if (tbgFunctionColumn.geniisysRows[i].displayColId == objFunctionDisplay.displayColId) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same display_col_id.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACFunctionController", {
						parameters : {
							action : "valAddColumnDisplay",
							moduleId : '${moduleId}',
							functionCd : '${functionCode}',
							displayColId : objFunctionDisplay.displayColId
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
		changeTag = 0;
		overlayFunctionDisplay.close();
		delete overlayFunctionDisplay;
	}

	function cancelGiacs323() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objFunctionDisplay.exitPage = exitPage;
						saveFunctionColumn();
					}, function() {
						changeTag = 0;
						overlayFunctionDisplay.close();
						delete overlayFunctionDisplay;
					}, "");
		} else {
			changeTag = 0;
			overlayFunctionDisplay.close();
			delete overlayFunctionDisplay;
		}
	}

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveFunctionColumn);
	$("btnCancel").observe("click", cancelGiacs323);
	$("btnAdd").observe("click", valAddFunctionColumn);
	$("btnDelete").observe("click", deleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtColumnName").focus();
	
	function showDisplayColumnLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs314DisplayLOV",
					  search : x,
						page : 1
				},
				title: "List of Display Columns",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'displayColId',
						title: 'Display Column Id',
						width : '120px',
						align: 'right',
						titleAlign: 'right'
					},
					{
						id : 'displayColName',
						title: 'Display Column Name',
						width : '250px',
						align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtColumnName").value = unescapeHTML2(row.displayColName);
						objFunctionDisplay.displayColId = row.displayColId;
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
			showErrorMessage("showDisplayColumnLOV",e);
		}
	}
	
	function validateDisplayColumn(){
		new Ajax.Request(contextPath+"/GIACFunctionController", {
			method: "POST",
			parameters: {
				action: "validateGiacs314Display",
				displayColName: $("txtColumnName").value
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.displayColName, "") == ""){
						/* showWaitingMessageBox("No record found.", "I", function(){
							$("txtColumnName").focus();
							$("txtColumnName").value = "";
							objFunctionDisplay.displayColId = "";
						}); */
						showDisplayColumnLOV($("txtColumnName").value);
					} else if (obj.displayColName == "---"){
						showDisplayColumnLOV($("txtColumnName").value);
					}
					else{
						$("txtColumnName").value = unescapeHTML2(obj.displayColName);
						objFunctionDisplay.displayColId = obj.displayColId;
						$("txtColumnName").setAttribute("lastValidValue",  unescapeHTML2(obj.displayColName));
					}
				}
			}
		});
	}
	
	$("searchDisplayColumn").observe("click", function(){
		showDisplayColumnLOV("%");
	});
	
	$("txtColumnName").observe("change",function(){
		if($("txtColumnName").value != ""){
			validateDisplayColumn();
		} else {
			$("txtColumnName").setAttribute("lastValidValue",  "");
		}
	});
	
</script>