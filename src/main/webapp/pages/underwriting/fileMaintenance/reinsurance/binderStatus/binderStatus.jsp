<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss209MainDiv" name="giiss209MainDiv" style="">
	<div id="binderStatusMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Binder Status Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss209" name="giiss209">	
		<div class="sectionDiv">
			<div id="binderStatusTableDiv" style="padding-top: 10px;">
				<div id="binderStatusTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="binderStatusFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtBndrStatCd" type="text" class="required" style="width: 200px;" tabindex="201" maxlength="3">
						</td>
						<td class="rightAligned" width="113px">Binder Status</td>
						<td class="leftAligned">
							<select id="selBndrTag" style="width: 207px; height: 24px;" class="required" tabindex="202">
								<option value=""></option>
								<c:forEach var="bndrTag" items="${bndrTagLOV}">
									<option value="${bndrTag.rvLowValue}">${bndrTag.rvMeaning}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Status Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtBndrStatDesc" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="25">
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
	setModuleId("GIISS209");
	setDocumentTitle("Binder Status Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIIS209 = {};
	var objCurrBinderStatus = null;
	objGIIS209.binderStatusList = JSON.parse('${jsonBinderStatusList}');
	
	var binderStatusTable = {
			url : contextPath + "/GIISBinderStatusController?action=showGiiss209&refresh=1",
			options : {
				width : '900px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBinderStatus = tbgBinderStatus.geniisysRows[y];
					setFieldValues(objCurrBinderStatus);
					tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
					tbgBinderStatus.keys.releaseKeys();
					$("txtBndrStatCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
					tbgBinderStatus.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
						tbgBinderStatus.keys.releaseKeys();
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
					tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
					tbgBinderStatus.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
					tbgBinderStatus.keys.releaseKeys();
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
					tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
					tbgBinderStatus.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
					{ 							// this column will only use for deletion
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
    					id : "bndrStatCd",
    					title : "Code",
    					filterOption : true,
    					width : '100px'
    				},
    				{
    					id : 'bndrStatDesc',
    					filterOption : true,
    					title : 'Status Description',
    					width : '530px'				
    				},
    				{
    					id : 'dspBndrTagMeaning',
    					filterOption : true,
    					title : 'Binder Status',
    					width : '250px'				
    				},
    				{
    					id : 'bndrTag',
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
			rows : objGIIS209.binderStatusList.rows
	};
	tbgBinderStatus = new MyTableGrid(binderStatusTable);
	tbgBinderStatus.pager = objGIIS209.binderStatusList;
	tbgBinderStatus.render("binderStatusTable");
	
	function setFieldValues(rec){
		try{
			$("txtBndrStatCd").value = (rec == null ? "" : unescapeHTML2(rec.bndrStatCd));
			$("txtBndrStatCd").setAttribute("lastValidValue", (rec == null ? "" : rec.bndrStatCd));
			$("txtBndrStatDesc").value = (rec == null ? "" : unescapeHTML2(rec.bndrStatDesc));
			$("txtBndrStatDesc").setAttribute("lastValidValue", (rec == null ? "" : rec.bndrStatDesc));
			$("selBndrTag").value = (rec == null ? "" : rec.bndrTag);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtBndrStatCd").readOnly = false : $("txtBndrStatCd").readOnly = true;
			rec == null ? $("txtBndrStatDesc").readOnly = false : rec.bndrTag == "S" ? $("txtBndrStatDesc").readOnly = true : $("txtBndrStatDesc").readOnly = false;
			rec == null ? $("selBndrTag").disabled = false : $("selBndrTag").disabled = true;
			rec == null ? $("txtRemarks").readOnly = false : rec.bndrTag == "S" ? $("txtRemarks").readOnly = true : $("txtRemarks").readOnly = false;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrBinderStatus = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function valAddBinderStatus(){
		try{
			if(checkAllRequiredFieldsInDiv("binderStatusFormDiv")){
				if($F("txtBndrStatDesc") != $("txtBndrStatDesc").readAttribute("lastValidValue")){
					var addedSameExistsDesc = false;
					var deletedSameExistsDesc = false;
					
					for(var i = 0; i<tbgBinderStatus.geniisysRows.length; i++){
						if(tbgBinderStatus.geniisysRows[i].recordStatus == 0 || tbgBinderStatus.geniisysRows[i].recordStatus == 1){								
							if(tbgBinderStatus.geniisysRows[i].bndrStatDesc == $F("txtBndrStatDesc")){
								addedSameExistsDesc = true;								
							}							
						} else if(tbgBinderStatus.geniisysRows[i].recordStatus == -1){
							if(tbgBinderStatus.geniisysRows[i].bndrStatDesc == $F("txtBndrStatDesc")){
								deletedSameExistsDesc = true;
							}
						}
					}
					
					if((addedSameExistsDesc && !deletedSameExistsDesc) || (deletedSameExistsDesc && addedSameExistsDesc)){
						showMessageBox("Record already exists with the same bndr_stat_desc.", "E");
						return;
					}
				}
				
				if($F("btnAdd") == "Add") {
					if($F("selBndrTag") == "S"){
						showMessageBox("You cannot insert a new system generated record.", "E");
						return;
					}
					
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i = 0; i<tbgBinderStatus.geniisysRows.length; i++){
						if(tbgBinderStatus.geniisysRows[i].recordStatus == 0 || tbgBinderStatus.geniisysRows[i].recordStatus == 1){								
							if(tbgBinderStatus.geniisysRows[i].bndrStatCd == $F("txtBndrStatCd")){
								addedSameExists = true;								
							}							
						} else if(tbgBinderStatus.geniisysRows[i].recordStatus == -1){
							if(tbgBinderStatus.geniisysRows[i].bndrStatCd == $F("txtBndrStatCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same bndr_stat_cd.", "E");
						return;
					} else if((deletedSameExists && !addedSameExists)){
						addBinderStatus();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISBinderStatusController", {
						parameters : {
							action : "valAddBinderStatus",
							bndrStatCd : $F("txtBndrStatCd"),
							bndrStatDesc : $F("txtBndrStatDesc")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addBinderStatus();
							}
						}
					});
				} else {
					if($F("selBndrTag") == "S"){
						showMessageBox("System Generated records cannot be updated.", "E");
						return;
					}
					
					addBinderStatus();
				}
			} 
		} catch(e){
			showErrorMessage("valAddBinderStatus", e);
		}
	}
	
	function addBinderStatus(){
		try {
			changeTagFunc = saveGiiss209;
			var bndrStat = setBinderStatus(objCurrBinderStatus);
			if($F("btnAdd") == "Add"){
				tbgBinderStatus.addBottomRow(bndrStat);
			} else {
				tbgBinderStatus.updateVisibleRowOnly(bndrStat, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBinderStatus.keys.removeFocus(tbgBinderStatus.keys._nCurrentFocus, true);
			tbgBinderStatus.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addBinderStatus", e);
		}
	}
	
	function valDeleteBinderStatus(){
		if($F("selBndrTag") == "S"){
			customShowMessageBox("System generated record cannot be deleted.", "I", "btnDelete");
		} else {
			try{
				new Ajax.Request(contextPath + "/GIISBinderStatusController", {
					parameters : {action : "valDeleteRec",
							      bndrStatCd : $F("txtBndrStatCd")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							deleteBinderStatus();
						}
					}
				});
			} catch(e){
				showErrorMessage("valDeleteBinderStatus", e);
			}
		}
	}
	
	function deleteBinderStatus(){
		objCurrBinderStatus.recordStatus = -1;
		tbgBinderStatus.deleteRow(rowIndex);
		changeTag = 1;
		changeTagFunc = saveGiiss209;
		setFieldValues(null);
	}
	
	function setBinderStatus(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.bndrStatCd = escapeHTML2($F("txtBndrStatCd"));
			obj.bndrStatDesc = escapeHTML2($F("txtBndrStatDesc"));
			obj.bndrTag = $F("selBndrTag");
			obj.dspBndrTagMeaning = $("selBndrTag").options[$("selBndrTag").selectedIndex].text;
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setSlType", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss209(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIIS209.exitPage = exitPage;
						saveGiiss209();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function saveGiiss209(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var binderStat = getAddedAndModifiedJSONObjects(tbgBinderStatus.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBinderStatus.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISBinderStatusController", {
			method: "POST",
			parameters : {action : "saveGiiss209",
					 	  setRows : prepareJsonAsParameter(binderStat),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTag = 0;
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIIS209.exitPage != null) {
							objGIIS209.exitPage();
						} else {
							tbgBinderStatus._refreshList();
						}
					});
				}
			}
		});
	}
	
	$("editRemarks").observe("click", function(){
		if($F("btnAdd") == "Add"){
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));	
		} else if($F("btnAdd") == "Update" && objCurrBinderStatus.bndrTag == "M"){
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
		}
	});
	
	disableButton("btnDelete");
	observeReloadForm("reloadForm", showGiiss209);
	observeSaveForm("btnSave", saveGiiss209);
	$("btnAdd").observe("click", valAddBinderStatus);
	$("btnDelete").observe("click", valDeleteBinderStatus);
	$("btnCancel").observe("click", cancelGiiss209);
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtBndrStatCd").focus();
	
	changeTagFunc = saveGiiss209;
</script>