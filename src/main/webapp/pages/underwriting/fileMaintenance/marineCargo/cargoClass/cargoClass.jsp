<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss051MainDiv" name="giiss051MainDiv" style="">
	<div id="cargoClassExitDiv">
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
	   		<label>Cargo Classification Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss051" name="giiss051">		
		<div class="sectionDiv">
			<div id="cargoClassTableDiv" style="padding-top: 10px;">
				<div id="cargoClassTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="cargoClassFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Cargo Class</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCargoClassCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
						</td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCargoClassDesc" type="text" class="required" style="width: 533px;" tabindex="202" maxlength="300">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
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
<script type="text/javascript">	
	setModuleId("GIISS051");
	setDocumentTitle("Cargo Classification Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss051(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCargoClass.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCargoClass.geniisysRows);
		new Ajax.Request(contextPath+"/GIISCargoClassController", {
			method: "POST",
			parameters : {action : "saveGiiss051",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS051.exitPage != null) {
							objGIISS051.exitPage();
						} else {
							tbgCargoClass._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss051);
	
	var objGIISS051 = {};
	var objCurrCargoClass = null;
	objGIISS051.cargoClassList = JSON.parse('${jsonCargoClassList}');
	objGIISS051.exitPage = null;
	
	var cargoClassTable = {
			url : contextPath + "/GIISCargoClassController?action=showGiiss051&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCargoClass = tbgCargoClass.geniisysRows[y];
					setFieldValues(objCurrCargoClass);
					tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();
					$("txtCargoClassDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();
					$("txtCargoClassCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
						tbgCargoClass.keys.releaseKeys();
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
					tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();
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
					tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
					tbgCargoClass.keys.releaseKeys();
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
					id : "cargoClassCd",
					title : "Cargo Class",
					filterOption : true,
					width : '130px',
					titleAlign : 'right',
					align : 'right',
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'cargoClassDesc',
					filterOption : true,
					title : 'Description',
					width : '530px'				
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
			rows : objGIISS051.cargoClassList.rows
		};

		tbgCargoClass = new MyTableGrid(cargoClassTable);
		tbgCargoClass.pager = objGIISS051.cargoClassList;
		tbgCargoClass.render("cargoClassTable");
	
	function setFieldValues(rec){
		try{
			$("txtCargoClassCd").value = (rec == null ? "" : rec.cargoClassCd);
			$("txtCargoClassDesc").value = (rec == null ? "" : unescapeHTML2(rec.cargoClassDesc));			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtCargoClassCd").readOnly = false : $("txtCargoClassCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrCargoClass = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.cargoClassCd = escapeHTML2($F("txtCargoClassCd"));
			obj.cargoClassDesc = escapeHTML2($F("txtCargoClassDesc"));
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
			changeTagFunc = saveGiiss051;
			var dept = setRec(objCurrCargoClass);
			if($F("btnAdd") == "Add"){
				tbgCargoClass.addBottomRow(dept);
			} else {
				tbgCargoClass.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCargoClass.keys.removeFocus(tbgCargoClass.keys._nCurrentFocus, true);
			tbgCargoClass.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("cargoClassFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgCargoClass.geniisysRows.length; i++) {
						if (tbgCargoClass.geniisysRows[i].recordStatus == 0
								|| tbgCargoClass.geniisysRows[i].recordStatus == 1) {
							if (tbgCargoClass.geniisysRows[i].cargoClassCd == $F("txtCargoClassCd")) {
								addedSameExists = true;
							}
						} else if (tbgCargoClass.geniisysRows[i].recordStatus == -1) {
							if (tbgCargoClass.geniisysRows[i].cargoClassCd == $F("txtCargoClassCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same cargo_class_cd.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISCargoClassController", {
						parameters : {
							action : "valAddRec",
							cargoClassCd : $F("txtCargoClassCd")
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
		changeTagFunc = saveGiiss051;
		objCurrCargoClass.recordStatus = -1;
		tbgCargoClass.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISCargoClassController", {
				parameters : {
					action : "valDeleteRec",
					cargoClassCd : $F("txtCargoClassCd")
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

	function cancelGiiss051() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS051.exitPage = exitPage;
						saveGiiss051();
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

	$("editRemarks").observe("click",function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	

	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss051);
	$("btnCancel").observe("click", cancelGiiss051);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtCargoClassCd").focus();
</script>