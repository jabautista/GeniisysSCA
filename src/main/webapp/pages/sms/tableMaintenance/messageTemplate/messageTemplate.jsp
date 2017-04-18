<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gisms002MainDiv" name="gisms002MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Message Template Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gisms002" name="gisms002">		
		<div class="sectionDiv">
			<div id="messageTemplateDiv" style="padding-top: 10px;">
				<div id="messageTemplateTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="messageTemplateFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Message Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtMessageCode" type="text" class="required" style="width: 550px; text-align: left;" tabindex="201" maxlength="20">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Keyword</td>
						<td class="leftAligned">
							<input id="txtKeyWord" type="text" class="" style="width: 200px;" tabindex="202" maxlength="20">
						</td>
						<td class="rightAligned" colspan="2">
							<label style="float: left; margin: 3px 2px 3px 0px;">Message Type:</label>
							<input type="radio" name="messageType" id="rdoUserDefined" value="U" style="float: left; margin: 3px 2px 3px 15px;" tabindex="203" />
							<label for="rdoUserDefined" style="float: left; height: 20px; padding-top: 3px;" title="User Defined">User Defined</label>
							<input type="radio" name="messageType" id="rdoSystemMessages" value="S" style="float: left; margin: 3px 2px 3px 15px;" tabindex="204" />
							<label for="rdoSystemMessages" style="float: left; height: 20px; padding-top: 3px;" title="System Messages">System Messages</label>
						</td>						
					</tr>	
					<tr>
						<td class="rightAligned" style="padding-bottom: 50px;">Message</td>
						<td class="leftAligned" colspan="3">
							<textarea class="text" id="txtMessage" name="txtMessage" maxlength="160" style="height: 55px; width: 550px; resize: none;" tabindex="205"></textarea>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 555px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 529px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td width="125px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="210">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="211">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnReserveWord" value="Reserve Word" style="width: 150px;" tabindex="212">
			</div>			
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="213">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="214">
</div>
<script type="text/javascript">	
	setModuleId("GISMS002");
	setDocumentTitle("Message Template Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGisms002(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgMessageTemplate.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgMessageTemplate.geniisysRows);
		new Ajax.Request(contextPath+"/GISMMessageTemplateController", {
			method: "POST",
			parameters : {action : "saveGisms002",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGISMS002.exitPage != null) {
							objGISMS002.exitPage();
						} else {
							tbgMessageTemplate._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function showGisms002() {
		try {
			new Ajax.Request(contextPath + "/GISMMessageTemplateController", {
					parameters : {action : "showGisms002"},
					onCreate : showNotice("Retrieving Message Template Maintenance, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
		} catch(e){
			showErrorMessage("showGisms002", e);
		}
	}
	
	observeReloadForm("reloadForm", showGisms002);
	
	var objGISMS002 = {};
	var objCurrMessageTemplate = null;
	objGISMS002.messageTemplateList = JSON.parse('${jsonMessageTemplateList}');
	objGISMS002.exitPage = null;
	
	var messageTemplateTable = {
			url : contextPath + "/GISMMessageTemplateController?action=showGisms002&refresh=1",
			options : {
				width : '690px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrMessageTemplate = tbgMessageTemplate.geniisysRows[y];
					setFieldValues(objCurrMessageTemplate);
					tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
					tbgMessageTemplate.keys.releaseKeys();
					$("txtMessage").focus();
					if (tbgMessageTemplate.geniisysRows[y].messageType == 'S') {
						disableButton("btnDelete");
					}
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
					tbgMessageTemplate.keys.releaseKeys();
					$("txtMessageCode").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
						tbgMessageTemplate.keys.releaseKeys();
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
					tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
					tbgMessageTemplate.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
					tbgMessageTemplate.keys.releaseKeys();
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
					tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
					tbgMessageTemplate.keys.releaseKeys();
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
					id : "messageCd",
					title : "Message Code",
					filterOption : true,
					width : '220px'
				},
				{
					id : 'keyWord',
					filterOption : true,
					title : 'Keyword',
					width : '210px'				
				},	
				{
					id : 'dspMessageType',
					filterOption : true,
					title : 'Message Type',
					width : '215 px'				
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
			rows : objGISMS002.messageTemplateList.rows
		};

		tbgMessageTemplate = new MyTableGrid(messageTemplateTable);
		tbgMessageTemplate.pager = objGISMS002.messageTemplateList;
		tbgMessageTemplate.render("messageTemplateTable");
	
	function setFieldValues(rec){
		try{
			$("txtMessageCode").value = (rec == null ? "" : rec.messageCd);
			$("txtMessageCode").setAttribute("lastValidValue", (rec == null ? "" : rec.messageCd));
			$("txtKeyWord").value = (rec == null ? "" : unescapeHTML2(rec.keyWord));
			$("txtMessage").value = (rec == null ? "" : unescapeHTML2(rec.message));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("rdoSystemMessages").checked = (rec == null ? false : rec.messageType == "S" ? true : false);
			$("rdoUserDefined").checked = (rec == null ? false : rec.messageType == "U" ? true : false);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtMessageCode").readOnly = false : $("txtMessageCode").readOnly = true;
			rec == null ? "" : $("rdoSystemMessages").disabled = true;
			rec == null ? $("rdoUserDefined").disabled = false : $("rdoUserDefined").disabled = true;
			rec == null ? $("rdoUserDefined").checked = true : "";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrMessageTemplate = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		$$("input[name='messageType']").each(function(btn){
			if (btn.checked){
				messageType = btn.value;
				if (messageType == "U") {
					dspMessageType = "User Defined";
				}else {
					dspMessageType = "System Messages";
				}
			}			
		});
		try {
			var obj = (rec == null ? {} : rec);
			obj.messageCd = $F("txtMessageCode");
			obj.keyWord = $F("txtKeyWord");
			obj.message = escapeHTML2($F("txtMessage"));
			obj.messageType = messageType;
			obj.dspMessageType = dspMessageType;
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
			changeTagFunc = saveGisms002;
			var dept = setRec(objCurrMessageTemplate);
			if($F("btnAdd") == "Add"){
				tbgMessageTemplate.addBottomRow(dept);
			} else {
				tbgMessageTemplate.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgMessageTemplate.keys.removeFocus(tbgMessageTemplate.keys._nCurrentFocus, true);
			tbgMessageTemplate.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("messageTemplateFormDiv")){
				addRec();
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGisms002;
		objCurrMessageTemplate.recordStatus = -1;
		tbgMessageTemplate.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			deleteRec();
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToSms", "SMS Main", null);
	}	
	
	function cancelGisms002(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGISMS002.exitPage = exitPage;
						saveGisms002();
					}, function(){
						changeTag = 0;
						goToModule("/GIISUserController?action=goToSms", "SMS Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToSms", "SMS Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGisms002);
	$("btnCancel").observe("click", cancelGisms002);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtMessageCode").focus();
	$("rdoSystemMessages").disabled = true;
	$("rdoUserDefined").checked = true;
	if ($("rdoUserDefined").checked) {
		disableInputField("txtKeyWord");
	}
	
	$("btnReserveWord").observe("click", function() {
		if (changeTag == 1){
    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			try{
				overlayReserveWord = Overlay.show(contextPath+"/GISMMessageTemplateController?", {
					urlContent: true,
					urlParameters: {
						action : "showReserveWord",
						messageCd : null
					},
				    title: "Reserve Word",
				    height : '420px',
					width : '510px',
				    draggable: true
				});
			}catch(e){
				showErrorMessage("btnReserveWord", e);
			}
		}
	});
</script>