<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss048MainDiv" name="giiss048MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Aircraft Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss048" name="giiss048">		
		<div class="sectionDiv">
			<div id="aircraftTypeTableDiv" style="padding-top: 10px;">
				<div id="aircraftTypeTable" style="height: 331px; padding-left: 165px;"></div>
			</div>
			<div align="center" id="aircraftTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Air Type</td>
						<td class="leftAligned">
							<input id="txtAirType" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtAirDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="20">
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
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 223px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 223px;" readonly="readonly" tabindex="207"></td>
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
	setModuleId("GIISS048");
	setDocumentTitle("Aircraft Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss048(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAircraftType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgAircraftType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISAirTypeController", {
			method: "POST",
			parameters : {action : "saveGIISS048",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS048.exitPage != null) {
							objGIISS048.exitPage();
						} else {
							tbgAircraftType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGIISS048);
	
	var objGIISS048 = {};
	var objCurrAircraftType = null;
	objGIISS048.aircraftTypeList = JSON.parse('${jsonAirType}');
	objGIISS048.exitPage = null;
	
	var aircraftTypeTable = {
			url : contextPath + "/GIISAirTypeController?action=showGIISS048&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrAircraftType = tbgAircraftType.geniisysRows[y];
					setFieldValues(objCurrAircraftType);
					tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
					tbgAircraftType.keys.releaseKeys();
					$("txtAirDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
					tbgAircraftType.keys.releaseKeys();
					$("txtAirType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
						tbgAircraftType.keys.releaseKeys();
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
					tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
					tbgAircraftType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
					tbgAircraftType.keys.releaseKeys();
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
					tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
					tbgAircraftType.keys.releaseKeys();
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
					id : 'airTypeCd',
					title : "Air Type",
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					width : '80px',
					align: "right",
					titleAlign: "right"
				},
				{
					id : 'airDesc',
					filterOption : true,
					title : 'Description',
					width : '480px'				
				},
				{
					id : 'jvTranTag',
					width : '0',
					visible: false
					
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
			rows : objGIISS048.aircraftTypeList.rows
		};

		tbgAircraftType = new MyTableGrid(aircraftTypeTable);
		tbgAircraftType.pager = objGIISS048.aircraftTypeList;
		tbgAircraftType.render("aircraftTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtAirType").value = (rec == null ? "" : rec.airTypeCd);
			$("txtAirType").setAttribute("lastValidValue", (rec == null ? "" : rec.airTypeCd));
			$("txtAirDesc").value = (rec == null ? "" : unescapeHTML2(rec.airDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtAirType").readOnly = false : $("txtAirType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrAircraftType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.airTypeCd = $F("txtAirType");
			obj.airDesc = escapeHTML2($F("txtAirDesc"));
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
			changeTagFunc = saveGiiss048;
			var dept = setRec(objCurrAircraftType);
			if($F("btnAdd") == "Add"){
				tbgAircraftType.addBottomRow(dept);
			} else {
				tbgAircraftType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgAircraftType.keys.removeFocus(tbgAircraftType.keys._nCurrentFocus, true);
			tbgAircraftType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("aircraftTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgAircraftType.geniisysRows.length; i++) {
						if (tbgAircraftType.geniisysRows[i].recordStatus == 0 || tbgAircraftType.geniisysRows[i].recordStatus == 1) {
							if (tbgAircraftType.geniisysRows[i].airTypeCd == $F("txtAirType")) {
								addedSameExists = true;
							}
						} else if (tbgAircraftType.geniisysRows[i].recordStatus == -1) {
							if (tbgAircraftType.geniisysRows[i].airTypeCd == $F("txtAirType")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same air_type_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISAirTypeController", {
						parameters : {
							action : "valAddRec",
							airTypeCd : $F("txtAirType")
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
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss048;
		objCurrAircraftType.recordStatus = -1;
		tbgAircraftType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISAirTypeController", {
				parameters : {
					action : "valDeleteRec",
					airTypeCd : $F("txtAirType")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText == "Y"){
						showMessageBox("Cannot delete record from GIIS_AIR_TYPE while dependent record(s) in GIIS_VESSEL exists.", imgMessage.ERROR);
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
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

	function cancelGiiss048() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS048.exitPage = exitPage;
						saveGiiss048();
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

	$("txtAirDesc").observe("keyup", function() {
		$("txtAirDesc").value = $F("txtAirDesc").toUpperCase();
	});

	$("txtAirType").observe("keyup", function() {
		$("txtAirType").value = $F("txtAirType").toUpperCase();
	});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiiss048);
	$("btnCancel").observe("click", cancelGiiss048);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtAirType").focus();
</script>