<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss025MainDiv" name="giiss025MainDiv" style="">
	<div id="reinsurerTypeExitDiv">
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
	   		<label>Reinsurer Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss025" name="giiss025">		
		<div class="sectionDiv">
			<div id="reinsurerTypeTableDiv" style="padding-top: 10px;">
				<div id="reinsurerTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="reinsurerTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Type</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRiType" type="text" class="required" style="width: 200px; text-align: left;" tabindex="201" maxlength="2">
						</td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRiTypeDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="30">
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
						<td width="113px" class="rightAligned">Last Update</td>
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
	setModuleId("GIISS025");
	setDocumentTitle("Reinsurer Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss025(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgReinsurerType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgReinsurerType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISReinsurerTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss025",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS025.exitPage != null) {
							objGIISS025.exitPage();
						} else {
							tbgReinsurerType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss025);
	
	var objGIISS025 = {};
	var objCurrReinsurerType = null;
	objGIISS025.reinsurerTypeList = JSON.parse('${jsonReinsurerTypeList}');
	objGIISS025.exitPage = null;
	
	var reinsurerTypeTable = {
			url : contextPath + "/GIISReinsurerTypeController?action=showGiiss025&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrReinsurerType = tbgReinsurerType.geniisysRows[y];
					setFieldValues(objCurrReinsurerType);
					tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
					tbgReinsurerType.keys.releaseKeys();
					$("txtRemarks").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
					tbgReinsurerType.keys.releaseKeys();
					$("txtRiType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
						tbgReinsurerType.keys.releaseKeys();
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
					tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
					tbgReinsurerType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
					tbgReinsurerType.keys.releaseKeys();
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
					tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
					tbgReinsurerType.keys.releaseKeys();
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
					id : "riType",
					title : "Type",
					filterOption : true,
					width : '130px'
				},
				{
					id : 'riTypeDesc',
					filterOption : true,
					title : 'Description',
					width : '530px'				
				},				
				{
					id : 'reinsurerTypeTag',
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
			rows : objGIISS025.reinsurerTypeList.rows
		};

		tbgReinsurerType = new MyTableGrid(reinsurerTypeTable);
		tbgReinsurerType.pager = objGIISS025.reinsurerTypeList;
		tbgReinsurerType.render("reinsurerTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtRiType").value = (rec == null ? "" : unescapeHTML2(rec.riType));
			$("txtRiTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.riTypeDesc));			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtRiType").readOnly = false : $("txtRiType").readOnly = true;
			rec == null ? $("txtRiTypeDesc").readOnly = false : $("txtRiTypeDesc").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrReinsurerType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.riType = escapeHTML2($F("txtRiType"));
			obj.riTypeDesc = escapeHTML2($F("txtRiTypeDesc"));
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
			changeTagFunc = saveGiiss025;
			var dept = setRec(objCurrReinsurerType);
			if($F("btnAdd") == "Add"){
				tbgReinsurerType.addBottomRow(dept);
			} else {
				tbgReinsurerType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgReinsurerType.keys.removeFocus(tbgReinsurerType.keys._nCurrentFocus, true);
			tbgReinsurerType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("reinsurerTypeFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgReinsurerType.geniisysRows.length; i++) {
						if (tbgReinsurerType.geniisysRows[i].recordStatus == 0
								|| tbgReinsurerType.geniisysRows[i].recordStatus == 1) {
							if (tbgReinsurerType.geniisysRows[i].riType == escapeHTML2($F("txtRiType"))) {
								addedSameExists = true;
							}
						} else if (tbgReinsurerType.geniisysRows[i].recordStatus == -1) {
							if (tbgReinsurerType.geniisysRows[i].riType == escapeHTML2($F("txtRiType"))) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same ri_type.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISReinsurerTypeController", {
						parameters : {
							action : "valAddRec",
							riType : $F("txtRiType")
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
		changeTagFunc = saveGiiss025;
		objCurrReinsurerType.recordStatus = -1;
		objCurrReinsurerType.riType = escapeHTML2($F("txtRiType"));
		tbgReinsurerType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISReinsurerTypeController", {
				parameters : {
					action : "valDeleteRec",
					riType : $F("txtRiType")
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

	function cancelGiiss025() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS025.exitPage = exitPage;
						saveGiiss025();
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

	$("txtRiTypeDesc").observe("keyup", function() {
		$("txtRiTypeDesc").value = $F("txtRiTypeDesc").toUpperCase();
	});

	$("txtRiType").observe("keyup", function() {
		$("txtRiType").value = $F("txtRiType").toUpperCase();
	});
	
	$("txtRiType").observe("change", function() {			
		if($F("txtRiType").trim()!=""){
			$("txtRiType").value = $F("txtRiType").toUpperCase();			
		}else{
			$("txtRiType").value = "";
		}	
	});	
	
	$("txtRiTypeDesc").observe("change", function() {			
		if($F("txtRiTypeDesc").trim()!=""){
			$("txtRiTypeDesc").value = $F("txtRiTypeDesc").toUpperCase();			
		}else{
			$("txtRiTypeDesc").value = "";
		}	
	});	

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiiss025);
	$("btnCancel").observe("click", cancelGiiss025);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtRiType").focus();
</script>