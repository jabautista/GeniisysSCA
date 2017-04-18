<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss023MainDiv" name="giiss023MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="exit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Employee Position Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss023" name="giiss023">		
		<div class="sectionDiv">
			<div id="employeePositionTableDiv" style="padding-top: 10px;">
				<div id="employeePositionTable" style="height: 331px; padding-left: 165px;"></div>
			</div>
			<div align="center" id="employeePositionFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtPositionCd" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="4" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Position</td>
						<td class="leftAligned" colspan="3">
							<input id="txtPosition" type="text" class="required allCaps" style="width: 533px;" tabindex="203" maxlength="40">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned" style="width: 113px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS023");
	setDocumentTitle("Employee Position Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss023(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPosition.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPosition.geniisysRows);
		new Ajax.Request(contextPath+"/GIISPositionController", {
			method: "POST",
			parameters : {action : "saveGiiss023",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS023.exitPage != null) {
							objGIISS023.exitPage();
						} else {
							tbgPosition._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss023);
	
	var objGIISS023 = {};
	var objCurrPosition = null;
	objGIISS023.positionList = JSON.parse('${jsonPosition}');
	objGIISS023.positionListAllRec = JSON.parse('${jsonPositionAllRec}');
	objGIISS023.exitPage = null;
	objGIISS023.positionCd = "";
	
	var employeePositionTable = {
			url : contextPath + "/GIISPositionController?action=showGiiss023&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrPosition = tbgPosition.geniisysRows[y];
					setFieldValues(objCurrPosition);
					tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
					tbgPosition.keys.releaseKeys();
					$("txtPosition").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
					tbgPosition.keys.releaseKeys();
					$("txtPosition").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
						tbgPosition.keys.releaseKeys();
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
					tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
					tbgPosition.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
					tbgPosition.keys.releaseKeys();
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
					tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
					tbgPosition.keys.releaseKeys();
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
					id : 'positionCd',
					title : "Code",
					filterOption : true,
					width : '80px',
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'integerNoNegative',
					renderer: function(value){
						return value == "" ? "" : lpad(value,4,0);
					}
				},
				{
					id : 'position',
					filterOption : true,
					title : 'Position',
					width : '480px'				
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
			rows : objGIISS023.positionList.rows
		};

		tbgPosition = new MyTableGrid(employeePositionTable);
		tbgPosition.pager = objGIISS023.positionList;
		tbgPosition.render("employeePositionTable");
	
	function setFieldValues(rec){
		try{
			$("txtPositionCd").value = (rec == null ? "" : rec.positionCd == "" ? "" : lpad(rec.positionCd,4,0));
			objGIISS023.positionCd = (rec == null ? "" : rec.positionCd == "" ? "" : lpad(rec.positionCd,4,0));
			//$("txtPositionCd").setAttribute("lastValidValue", (rec == null ? "" : rec.positionCd));
			$("txtPosition").value = (rec == null ? "" : unescapeHTML2(rec.position));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtPositionCd").readOnly = false : $("txtPositionCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrPosition = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.positionCd = objGIISS023.positionCd;
			obj.position = escapeHTML2($F("txtPosition"));
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
			if(checkAllRequiredFieldsInDiv("employeePositionFormDiv")){
				changeTagFunc = saveGiiss023;
				var dept = setRec(objCurrPosition);
				if($F("btnAdd") == "Add"){
					tbgPosition.addBottomRow(dept);
				} else {
					tbgPosition.updateVisibleRowOnly(dept, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgPosition.keys.removeFocus(tbgPosition.keys._nCurrentFocus, true);
				tbgPosition.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("employeePositionFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgPosition.geniisysRows.length; i++) {
						if (tbgPosition.geniisysRows[i].recordStatus == 0 || tbgPosition.geniisysRows[i].recordStatus == 1) {
							if ((unescapeHTML2(tbgPosition.geniisysRows[i].position) == $F("txtPosition"))) {
								addedSameExists = true;
							}
						} else if (tbgPosition.geniisysRows[i].recordStatus == -1) {
							if ((unescapeHTML2(tbgPosition.geniisysRows[i].position) == $F("txtPosition"))) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same position.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISPositionController", {
						parameters : {
							action : "valAddRec",
							position : $F("txtPosition"),
							positionCd : $F("txtPositionCd")
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
					new Ajax.Request(contextPath + "/GIISPositionController", {
						parameters : {
							action : "valAddRec",
							position : $F("txtPosition"),
							positionCd : $F("txtPositionCd")
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
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function valAddRecNew(){
		var proceed = true;
		
		for (var i = 0; i < objGIISS023.positionListAllRec.rows.length; i++) {
			if(unescapeHTML2(objGIISS023.positionListAllRec.rows[i].position) == unescapeHTML2($F("txtPosition"))){
				if(($F("btnAdd") == "Update" && unescapeHTML2(objCurrPosition.position) != unescapeHTML2($F("txtPosition"))) || $F("btnAdd") == "Add"){
					proceed = false;
				}
			}
		}
		
		if(proceed){
			if($F("btnAdd") == "Add"){
				var rec = {};
				rec.position = escapeHTML2($F("txtPosition"));
				objGIISS023.positionListAllRec.rows.push(rec);
			}else{
				for(var i = 0; i < objGIISS023.positionListAllRec.rows.length; i++){
					if(unescapeHTML2(objGIISS023.positionListAllRec.rows[i].position) == unescapeHTML2(objCurrPosition.position)){
						var rec = objCurrPosition;
						rec.position = escapeHTML2($F("txtPosition"));
						objGIISS023.positionListAllRec.rows.splice(i, 1, rec);
					}
				}
			}
			
			addRec();
		}else{
			showMessageBox("Record already exists with the same position.", "E");
		}
	}
	
	function deleteRec() {
		changeTagFunc = saveGiiss023;
		objCurrPosition.recordStatus = -1;
		tbgPosition.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISPositionController", {
				parameters : {
					action : "valDeleteRec",
					positionCd : objGIISS023.positionCd
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText != "N"){
						showMessageBox("Cannot delete record from GIIS_POSITION while dependent record(s) in "+ response.responseText +" exists.", imgMessage.ERROR);
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							for(var i = 0; i < objGIISS023.positionListAllRec.rows.length; i++){
								if(unescapeHTML2(objGIISS023.positionListAllRec.rows[i].position) == unescapeHTML2(objCurrPosition.position)){
									objGIISS023.positionListAllRec.rows.splice(i, 1);
								}
							}
							deleteRec();
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss023() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS023.exitPage = exitPage;
						saveGiiss023();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiiss023);
	$("btnCancel").observe("click", cancelGiiss023);
	$("btnAdd").observe("click", valAddRecNew);
	$("btnDelete").observe("click", valDeleteRec);
	$("exit").stopObserving("click");
	$("exit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtPosition").focus();
</script>