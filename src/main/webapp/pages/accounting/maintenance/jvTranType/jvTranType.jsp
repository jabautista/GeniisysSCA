<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs323MainDiv" name="giacs323MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>JV Transaction Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs323" name="giacs323">		
		<div class="sectionDiv">
			<div id="jvTranTableDiv" style="padding-top: 10px;">
				<div id="jvTranTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="jvTranTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Tran Code</td>
						<td class="leftAligned">
							<input id="txtJvTranCd" type="text" class="required" style="width: 200px; text-align: right;" tabindex="201" maxlength="3">
						</td>
						<td class="rightAligned" width="113px">JV Tag</td>
						<td class="leftAligned">
							<select id="selJvTranTag" type="text" class="required" style="width: 207px;" tabindex="202">
								<option></option>
								<option value="C">Cash</option>
								<option value="NC">Non-Cash</option>
							</select>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">JV Tran Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtJvTranDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="100">
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
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
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
	setModuleId("GIACS323");
	setDocumentTitle("JV Transaction Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs323(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgJvTran.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgJvTran.geniisysRows);
		new Ajax.Request(contextPath+"/GIACJvTranController", {
			method: "POST",
			parameters : {action : "saveGiacs323",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS323.exitPage != null) {
							objGIACS323.exitPage();
						} else {
							tbgJvTran._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs323);
	
	var objGIACS323 = {};
	var objCurrJvTran = null;
	objGIACS323.jvTranList = JSON.parse('${jsonJvTranList}');
	objGIACS323.exitPage = null;
	
	var jvTranTable = {
			url : contextPath + "/GIACJvTranController?action=showGiacs323&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrJvTran = tbgJvTran.geniisysRows[y];
					setFieldValues(objCurrJvTran);
					tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
					tbgJvTran.keys.releaseKeys();
					$("txtJvTranDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
					tbgJvTran.keys.releaseKeys();
					$("txtJvTranCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
						tbgJvTran.keys.releaseKeys();
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
					tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
					tbgJvTran.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
					tbgJvTran.keys.releaseKeys();
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
					tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
					tbgJvTran.keys.releaseKeys();
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
					id : "jvTranCd",
					title : "Tran Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'jvTranDesc',
					filterOption : true,
					title : 'JV Tran Description',
					width : '480px'				
				},
				{
					id : 'dspJvTranTag',
					filterOption : true,
					title : 'JV Tag',
					width : '100px'				
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
			rows : objGIACS323.jvTranList.rows
		};

		tbgJvTran = new MyTableGrid(jvTranTable);
		tbgJvTran.pager = objGIACS323.jvTranList;
		tbgJvTran.render("jvTranTable");
	
	function setFieldValues(rec){
		try{
			$("txtJvTranCd").value = (rec == null ? "" : rec.jvTranCd);
			$("txtJvTranCd").setAttribute("lastValidValue", (rec == null ? "" : rec.jvTranCd));
			$("txtJvTranDesc").value = (rec == null ? "" : unescapeHTML2(rec.jvTranDesc));
			$("selJvTranTag").value = (rec == null ? "" : rec.jvTranTag);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtJvTranCd").readOnly = false : $("txtJvTranCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrJvTran = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.jvTranCd = $F("txtJvTranCd");
			obj.jvTranDesc = $F("txtJvTranDesc");
			obj.jvTranTag = $F("selJvTranTag");
			obj.dspJvTranTag = $("selJvTranTag").options[$("selJvTranTag").selectedIndex].text;
			obj.remarks = $F("txtRemarks");
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
			changeTagFunc = saveGiacs323;
			var dept = setRec(objCurrJvTran);
			if($F("btnAdd") == "Add"){
				tbgJvTran.addBottomRow(dept);
			} else {
				tbgJvTran.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgJvTran.keys.removeFocus(tbgJvTran.keys._nCurrentFocus, true);
			tbgJvTran.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("jvTranTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					new Ajax.Request(contextPath + "/GIACJvTranController", {
						parameters : {action : "valAddRec",
									  jvTranCd : $F("txtJvTranCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs323;
		objCurrJvTran.recordStatus = -1;
		tbgJvTran.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACJvTranController", {
				parameters : {action : "valDeleteRec",
							  jvTranCd : $F("txtJvTranCd")},
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
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs323(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS323.exitPage = exitPage;
						saveGiacs323();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtJvTranDesc").observe("keyup", function(){
		$("txtJvTranDesc").value = $F("txtJvTranDesc").toUpperCase();
	});
	
	$("txtJvTranCd").observe("keyup", function(){
		$("txtJvTranCd").value = $F("txtJvTranCd").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs323);
	$("btnCancel").observe("click", cancelGiacs323);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtJvTranCd").focus();	
</script>