<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss094MainDiv" name="giiss094MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Treaty Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss094" name="giiss094">		
		<div class="sectionDiv">
			<div id="caTrtyTypeTableDiv" style="padding-top: 10px;">
				<div id="caTrtyTypeTable" style="height: 332px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="caTrtyTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtCaTrtyType" type="text" class="required integerUnformattedOnBlur" style="width: 200px; text-align: right;" tabindex="201" maxlength="3">
						</td>	
						<td class="rightAligned" width="160px">Treaty Type Short Name</td>
						<td class="leftAligned">
							<input id="txtTrtySname" type="text" class="required" style="width: 200px;" tabindex="202" maxlength="15">
						</td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Treaty Type</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTrtyLname" type="text" class="required" style="width: 580px;" tabindex="203" maxlength="30">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 586px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 560px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
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
	setModuleId("GIISS094");
	setDocumentTitle("Treaty Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss094(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCaTrtyType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCaTrtyType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISCaTrtyTypeController", {
			method: "POST",
			parameters : {action : "saveGiiss094",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS094.exitPage != null) {
							objGIISS094.exitPage();
						} else {
							tbgCaTrtyType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss094);
	
	var objGIISS094 = {};
	var objCurrCaTrtyType = null;
	objGIISS094.caTrtyTypeList = JSON.parse('${jsonCaTrtyTypeList}');
	objGIISS094.exitPage = null;
	
	var caTrtyTypeTable = {
			url : contextPath + "/GIISCaTrtyTypeController?action=showGiiss094&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCaTrtyType = tbgCaTrtyType.geniisysRows[y];
					setFieldValues(objCurrCaTrtyType);
					tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
					tbgCaTrtyType.keys.releaseKeys();
					$("txtTrtySname").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
					tbgCaTrtyType.keys.releaseKeys();
					$("txtCaTrtyType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
						tbgCaTrtyType.keys.releaseKeys();
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
					tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
					tbgCaTrtyType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
					tbgCaTrtyType.keys.releaseKeys();
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
					tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
					tbgCaTrtyType.keys.releaseKeys();
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
					id : "caTrtyType",
					title : "Code",
					filterOption : true,
					filterOptionType: "integer",
					width : '100px',
					titleAlign : "right",
					align : "right"
				},
				{
					id : 'trtySname',
					title : 'Treaty Type Short Name',
					filterOption : true,
					width : '200px'				
				},				
				{
					id : 'trtyLname',
					title : 'Treaty Type',
					filterOption : true,
					width : '360px'							
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
			rows : objGIISS094.caTrtyTypeList.rows
		};

		tbgCaTrtyType = new MyTableGrid(caTrtyTypeTable);
		tbgCaTrtyType.pager = objGIISS094.caTrtyTypeList;
		tbgCaTrtyType.render("caTrtyTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtCaTrtyType").value = (rec == null ? "" : rec.caTrtyType);
			$("txtCaTrtyType").setAttribute("lastValidValue", (rec == null ? "" : rec.caTrtyType));
			$("txtTrtySname").value = (rec == null ? "" : unescapeHTML2(rec.trtySname));
			$("txtTrtyLname").value = (rec == null ? "" : unescapeHTML2(rec.trtyLname));			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtCaTrtyType").readOnly = false : $("txtCaTrtyType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrCaTrtyType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.caTrtyType = $F("txtCaTrtyType");
			obj.trtySname = escapeHTML2($F("txtTrtySname"));
			obj.trtyLname = escapeHTML2($F("txtTrtyLname"));
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
			changeTagFunc = saveGiiss094;
			var dept = setRec(objCurrCaTrtyType);
			if($F("btnAdd") == "Add"){
				tbgCaTrtyType.addBottomRow(dept);
			} else {
				tbgCaTrtyType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCaTrtyType.keys.removeFocus(tbgCaTrtyType.keys._nCurrentFocus, true);
			tbgCaTrtyType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}				
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("caTrtyTypeFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgCaTrtyType.geniisysRows.length; i++) {
						if (tbgCaTrtyType.geniisysRows[i].recordStatus == 0
								|| tbgCaTrtyType.geniisysRows[i].recordStatus == 1) {
							if (tbgCaTrtyType.geniisysRows[i].caTrtyType == $F("txtCaTrtyType")) {
								addedSameExists = true;
							}
						} else if (tbgCaTrtyType.geniisysRows[i].recordStatus == -1) {
							if (tbgCaTrtyType.geniisysRows[i].caTrtyType == $F("txtCaTrtyType")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same ca_trty_type.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISCaTrtyTypeController", {
						parameters : {
							action : "valAddRec",
							caTrtyType : $F("txtCaTrtyType")
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
		changeTagFunc = saveGiiss094;
		objCurrCaTrtyType.recordStatus = -1;
		tbgCaTrtyType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}

	function cancelGiiss094() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS094.exitPage = exitPage;
						saveGiiss094();
					}, function() {
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}

	$("editRemarks").observe("click",function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtCaTrtyType").observe("change", function() {
		if($F("txtCaTrtyType").trim()!=""){
			if(parseInt($F("txtCaTrtyType")) < 100 && parseInt($F("txtCaTrtyType")) > -100){
				$("txtCaTrtyType").setAttribute("lastValidValue",$F("txtCaTrtyType"));
			}else{
				showWaitingMessageBox("Invalid code. Valid value should be from -99 to 99.", imgMessage.INFO, function(){
					$("txtCaTrtyType").value = $("txtCaTrtyType").readAttribute("lastValidValue");
					$("txtCaTrtyType").focus();
				});			
			}					
		}else{
			$("txtCaTrtyType").value = "";
			$("txtCaTrtyType").setAttribute("lastValidValue","");
		}
	});

	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss094);
	$("btnCancel").observe("click", cancelGiiss094);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtCaTrtyType").focus();
</script>