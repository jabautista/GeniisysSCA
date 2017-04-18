<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss099MainDiv" name="giiss099MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Bond Clause Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss099" name="giiss099">		
		<div class="sectionDiv">
			<div id="bondClauseTypeDiv" style="padding-top: 10px;">
				<div id="bondClauseTypeTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="bondClauseTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Clause Type</td>
						<td class="leftAligned">
							<input id="txtClauseType" type="text" class="required" style="width: 200px; text-align: left;" tabindex="201" maxlength="1">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Clause Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtClauseDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="50">
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
						<td width="110px;" class="rightAligned">Last Update</td>
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
	setModuleId("GIISS099");
	setDocumentTitle("Bond Clause Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss099(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBondClause.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBondClause.geniisysRows);
		new Ajax.Request(contextPath+"/GIISBondClassClauseController", {
			method: "POST",
			parameters : {action : "saveGiiss099",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS099.exitPage != null) {
							objGIISS099.exitPage();
						} else {
							tbgBondClause._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss099);
	
	var objGIISS099 = {};
	var objCurrBondClause = null;
	objGIISS099.bondClassClauseList = JSON.parse('${jsonBondClassClauseList}');
	objGIISS099.exitPage = null;
	
	var bondClauseTypeTable = {
			url : contextPath + "/GIISBondClassClauseController?action=showGiiss099&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBondClause = tbgBondClause.geniisysRows[y];
					setFieldValues(objCurrBondClause);
					tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
					tbgBondClause.keys.releaseKeys();
					$("txtClauseDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
					tbgBondClause.keys.releaseKeys();
					$("txtClauseType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
						tbgBondClause.keys.releaseKeys();
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
					tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
					tbgBondClause.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
					tbgBondClause.keys.releaseKeys();
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
					tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
					tbgBondClause.keys.releaseKeys();
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "clauseType",
					title : "Clause Type",
					filterOption : true,
					width : '180px'
				},
				{
					id : 'clauseDesc',
					filterOption : true,
					title : 'Clause Description',
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
			rows : objGIISS099.bondClassClauseList.rows
		};

		tbgBondClause = new MyTableGrid(bondClauseTypeTable);
		tbgBondClause.pager = objGIISS099.bondClassClauseList;
		tbgBondClause.render("bondClauseTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtClauseType").value = (rec == null ? "" : unescapeHTML2(rec.clauseType));
			$("txtClauseType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.clauseType)));
			$("txtClauseDesc").value = (rec == null ? "" : unescapeHTML2(rec.clauseDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtClauseType").readOnly = false : $("txtClauseType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrBondClause = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.clauseType = escapeHTML2($F("txtClauseType"));
			obj.clauseDesc = escapeHTML2($F("txtClauseDesc"));
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
			changeTagFunc = saveGiiss099;
			var dept = setRec(objCurrBondClause);
			if($F("btnAdd") == "Add"){
				tbgBondClause.addBottomRow(dept);
			} else {
				tbgBondClause.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBondClause.keys.removeFocus(tbgBondClause.keys._nCurrentFocus, true);
			tbgBondClause.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("bondClauseTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgBondClause.geniisysRows.length; i++){
						if(tbgBondClause.geniisysRows[i].recordStatus == 0 || tbgBondClause.geniisysRows[i].recordStatus == 1){								
							if(tbgBondClause.geniisysRows[i].clauseType == $F("txtClauseType")){
								addedSameExists = true;								
							}							
						} else if(tbgBondClause.geniisysRows[i].recordStatus == -1){
							if(tbgBondClause.geniisysRows[i].clauseType == $F("txtClauseType")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same clause_type.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISBondClassClauseController", {
						parameters : {action : "valAddRec",
									  clauseType : $F("txtClauseType")},
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
		changeTagFunc = saveGiiss099;
		objCurrBondClause.recordStatus = -1;
		tbgBondClause.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISBondClassClauseController", {
				parameters : {action : "valDeleteRec",
							  clauseType : $F("txtClauseType")},
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
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss099(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS099.exitPage = exitPage;
						saveGiiss099();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
// 	$("txtClauseDesc").observe("keyup", function(){
// 		$("txtClauseDesc").value = $F("txtClauseDesc").toUpperCase();
// 	});
	
	$("txtClauseType").observe("keyup", function(){
		$("txtClauseType").value = $F("txtClauseType").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss099);
	$("btnCancel").observe("click", cancelGiiss099);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtClauseType").focus();	
</script>