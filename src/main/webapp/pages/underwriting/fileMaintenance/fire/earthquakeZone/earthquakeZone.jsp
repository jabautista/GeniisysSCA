<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giiss011MainDiv" name="eqZoneMaintenance" style="float: left; width: 100%;">
	<div id="eqZoneExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Earthquake Zone Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="giiss011" name="giiss011">		
		<div class="sectionDiv">
			<div id="eqZoneTableDiv" style="padding-top: 10px;">
				<div id="eqZoneTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="eqZoneFormDiv">
				<table>					
					<tr>
						<td align="right">Eq Zone</td>
						<td><input class="required leftAligned"" id="txtEqZone" maxlength="2" type="text" style="margin-bottom:0;width:200px;" class="rightAligned"></td>
						<td align="right" style="width: 136px;">Zone Group</td>
						<td><span class="lovSpan" style="width: 206px; height:19px;margin-top:1px; margin-bottom:0">
								<input id="txtZoneGrp" maxlength="2" type="text" style="width:154px;margin: 0;height: 13px;border: 0" class="leftAligned"><img
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchZoneGrp" alt="Go" style="float: right; margin-top: 2px;" />
							</span>	
						</td>					
					</tr>	
					<tr>
						<td align="right">Description</td>
						<td colspan="3">								
							<input class="required" maxlength="500" style="width: 552px;" type="text" id="txtEqDesc" /> 
							<input id="txtOrigEqDesc" type="hidden">
						</td>
					</tr>										
					<tr>
						<td align="right">Remarks</td>
						<td colspan="3">
							<div style="border: 1px solid gray; height: 21px; width: 558px">
								<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 532px" maxlength="4000"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">User ID</td>
						<td><input id="txtUserId" type="text" style="width:200px" readonly="readonly"></td>
						<td align="right" style="width: 136px;">Last Update</td>
						<td><input id="txtLastUpdate" type="text"  style="width:200px" readonly="readonly"></td>
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
	setModuleId("GIISS011");
	setDocumentTitle("Earthquake Zone Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var allRecObj = {};
	
	function saveGiiss011(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgEQZone.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgEQZone.geniisysRows);
		new Ajax.Request(contextPath+"/GIISEQZoneController", {
			method: "POST",
			parameters : {action : "saveGiiss011",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS011.exitPage != null) {
							objGIISS011.exitPage();
						} else {
							tbgEQZone._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss011);
	
	var objGIISS011 = {};
	var objCurrEQZone = null;
	objGIISS011.eqZoneList = JSON.parse('${jsonEQZoneList}');
	objGIISS011.exitPage = null;
	
	var eqZoneTable = {
			url : contextPath + "/GIISEQZoneController?action=showGiiss011&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrEQZone = tbgEQZone.geniisysRows[y];
					setFieldValues(objCurrEQZone);
					tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
					tbgEQZone.keys.releaseKeys();
					$("txtEqDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
					tbgEQZone.keys.releaseKeys();
					$("txtEqZone").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
						tbgEQZone.keys.releaseKeys();
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
					tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
					tbgEQZone.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
					tbgEQZone.keys.releaseKeys();
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
					tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
					tbgEQZone.keys.releaseKeys();
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
					id : "eqZone",
					title : "Eq Zone",
					width : '140px',
					align : "left",
					titleAlign : "left",
					filterOption : true
				},
				{
					id : "eqDesc",
					title : "Description",			
					width : '578px',
					align : "left",
					titleAlign : "left",
					filterOption : true			
				},
				{
					id : "zoneGrp",
					title : "Zone Group",			
					width : '140px',
					align : "left",
					titleAlign : "left",
					filterOption : true		
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
			rows : objGIISS011.eqZoneList.rows
		};

		tbgEQZone = new MyTableGrid(eqZoneTable);
		tbgEQZone.pager = objGIISS011.eqZoneList;
		tbgEQZone.render("eqZoneTable");
		tbgEQZone.afterRender = function(){
     		allRecObj = getAllRecord();				
		};
			
	function setFieldValues(rec){
		try{
			$("txtEqZone").value = (rec == null ? "" : unescapeHTML2(rec.eqZone));
			$("txtEqDesc").value = (rec == null ? "" : unescapeHTML2(rec.eqDesc));		
			$("txtOrigEqDesc").value = (rec == null ? "" : unescapeHTML2(rec.eqDesc));
			$("txtZoneGrp").value = (rec == null ? "" : unescapeHTML2(rec.zoneGrp));		
			$("txtZoneGrp").setAttribute("lastValidValue", (rec == null ? "" : (rec.zoneGrp == null ? "" : rec.zoneGrp)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtEqZone").readOnly = false : $("txtEqZone").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrEQZone = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eqZone = escapeHTML2($F("txtEqZone"));
			obj.eqDesc = escapeHTML2($F("txtEqDesc"));
			obj.zoneGrp = escapeHTML2($F("txtZoneGrp"));
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
			changeTagFunc = saveGiiss011;
			var dept = setRec(objCurrEQZone);
			var newObj = setRec(null);
			if($F("btnAdd") == "Add"){
				tbgEQZone.addBottomRow(dept);
				newObj.recordStatus = 0;
				allRecObj.push(newObj);
			} else {
				tbgEQZone.updateVisibleRowOnly(dept, rowIndex, false);
				for(var i = 0; i<allRecObj.length; i++){
					if ((allRecObj[i].eqZone == newObj.eqZone)&&(allRecObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRecObj.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValues(null);
			tbgEQZone.keys.removeFocus(tbgEQZone.keys._nCurrentFocus, true);
			tbgEQZone.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("eqZoneFormDiv")) {
				for(var i=0; i<allRecObj.length; i++){
					if(allRecObj[i].recordStatus != -1 ){
						if ($F("btnAdd") == "Add") {
							if(unescapeHTML2(allRecObj[i].eqZone.toUpperCase()) == $F("txtEqZone").toUpperCase()){
								showMessageBox("Record already exists with the same eq_zone.", "E");
								return;
							}else if(unescapeHTML2(allRecObj[i].eqDesc) == $F("txtEqDesc")){
								showMessageBox("Record already exists with the same eq_desc.", "E");
								return;
							}
						} else{
							if($F("txtOrigEqDesc") != $F("txtEqDesc") && unescapeHTML2(allRecObj[i].eqDesc) == $F("txtEqDesc")){
								showMessageBox("Record already exists with the same eq_desc.", "E");
								return;
							}
						}
					} 
				}
				addRec();				
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss011;
		var newObj = setRec(null);
		objCurrEQZone.recordStatus = -1;
		tbgEQZone.deleteRow(rowIndex);
		tbgEQZone.geniisysRows[rowIndex].eqZone = escapeHTML2($F("txtEqZone"));
		for(var i = 0; i<allRecObj.length; i++){
			if ((allRecObj[i].eqZone == unescapeHTML2(newObj.eqZone))&&(allRecObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRecObj.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISEQZoneController", {
				parameters : {
					action : "valDeleteRec",
					eqZone : $F("txtEqZone")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)
							&& checkCustomErrorOnResponse(response)) {
						deleteRec();
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

	function cancelGiiss011() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS011.exitPage = exitPage;
						saveGiiss011();
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
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISEQZoneController", {
				parameters : {action : "showAllGiiss011"},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText.replace(/\\\\/g, '\\'));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
	function showZoneGroupLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "showZoneGroupLOV",
				searchString : ($("txtZoneGrp").readAttribute("lastValidValue") != $F("txtZoneGrp") ? nvl($F("txtZoneGrp"),"%") : "%"),
				page : 1,				
			},
			title : "List of Zone Groups",
			width : 416,
			height : 386,
			columnModel : [ {
				id : "zoneGrp",
				title : "Zone Group",
				width : '135px',
				filterOptionType : 'integerNoNegative'
			},{
				id : "zoneGrpDesc",
				title : "Zone Meaning",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtZoneGrp").readAttribute("lastValidValue") != $F("txtZoneGrp") ? nvl($F("txtZoneGrp"),"%") : "%"),
			onSelect : function(row) {
				$("txtZoneGrp").value = unescapeHTML2(row.zoneGrp);				
				$("txtZoneGrp").setAttribute("lastValidValue", row.zoneGrp);
			},
			onCancel : function() {
				$("txtZoneGrp").value = $("txtZoneGrp").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtZoneGrp");	
				$("txtZoneGrp").value = $("txtZoneGrp").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$("imgSearchZoneGrp").observe("click", function() {
		showZoneGroupLOV();
	});
	
	$("txtZoneGrp").observe("change", function() {		
		if($F("txtZoneGrp").trim()!=""&& $("txtZoneGrp").value != $("txtZoneGrp").readAttribute("lastValidValue")){						
			showZoneGroupLOV();			
		}else if($F("txtZoneGrp").trim()==""){
			$("txtZoneGrp").value="";	
			$("txtZoneGrp").setAttribute("lastValidValue","");
		}					
	});	

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss011);
	$("btnCancel").observe("click", cancelGiiss011);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtRiType").focus();
</script>