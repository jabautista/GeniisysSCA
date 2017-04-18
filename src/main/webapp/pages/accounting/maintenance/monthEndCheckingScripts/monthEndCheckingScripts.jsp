<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs352MainDiv" name="giacs352MainDiv" style="">
	<div id="giacs352MenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Month-end Checking Scripts Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giacs352" name="giacs352">
		<div class="sectionDiv">
			<div id="giacs352TableDiv" style="padding-top: 10px;">
				<div id="giacs352Table" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="giacs352FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">EOM Script No</td>
						<td class="leftAligned" colspan="3">
							<input id="txtEomScriptNo" type="text" readonly="readonly" style="width: 200px; text-align: right;" tabindex="201" maxlength="3">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">EOM Script Title</td>
						<td class="leftAligned" colspan="3">
							<input id="txtEomScriptTitle" type="text" class="required" style="width: 533px; text-align: left;" tabindex="202" maxlength="200">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">EOM Script Query</td>
						<td class="leftAligned" colspan="3">
							<div id="eomScriptText1Div" name="eomScriptText1Div" class="required" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea class="required" style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtEomScriptText1" name="txtEomScriptText1" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="203"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit EOM Script Text 1" id="editEomScriptText1"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td class="leftAligned" colspan="3">
							<div id="eomScriptText2Div" name="eomScriptText2Div" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtEomScriptText2" name="txtEomScriptText2" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit EOM Script Text 2" id="editEomScriptText2"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">EOM Script Solution</td>
						<td class="leftAligned" colspan="3">
							<div id="eomScriptSolnDiv" name="eomScriptSolnDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtEomScriptSoln" name="txtEomScriptSoln" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit EOM Script Soln" id="editEomScriptSoln"/>
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="209">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="212">
</div>
<script type="text/javascript">
	setModuleId("GIACS352");
	setDocumentTitle("Month-end Checking Scripts Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	observeReloadForm("reloadForm", showGiacs352);
	
	var objGiacs352 = {};
	var objCurrMonthEndCheckingScripts = null;
	objGiacs352.monthEndCheckingScriptsList = JSON.parse('${jsonMonthEndCheckingScriptsList}');
	objGiacs352.exitPage = null;
	
	var giacs352Table = {
			url : contextPath + "/GIACEomCheckingScriptsController?action=showGiacs352&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrMonthEndCheckingScripts = tbgMonthEndCheckingScripts.geniisysRows[y];
					setFieldValues(objCurrMonthEndCheckingScripts);
					tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
					tbgMonthEndCheckingScripts.keys.releaseKeys();
					$("txtEomScriptTitle").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
					tbgMonthEndCheckingScripts.keys.releaseKeys();
					$("txtEomScriptTitle").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
						tbgMonthEndCheckingScripts.keys.releaseKeys();
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
					tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
					tbgMonthEndCheckingScripts.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
					tbgMonthEndCheckingScripts.keys.releaseKeys();
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
					tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
					tbgMonthEndCheckingScripts.keys.releaseKeys();
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
					id : "eomScriptNo",
					title : "EOM Script No",
					filterOption : true,
					titleAlign : 'right',
					align : 'right',
					filterOptionType : 'integerNoNegative',
					width : '100px'
				},
				{
					id : 'eomScriptTitle',
					filterOption : true,
					title : 'EOM Script Title',
					width : '230px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{
					id : 'eomScriptText1',
					filterOption : true,
					title : 'EOM Script Query',
					width : '280px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{
					id : 'eomScriptText2',
					width : '0',
					visible : false
				},
				{
					id : 'eomScriptSoln',
					filterOption : true,
					title : 'EOM Script Solution',
					width : '280px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
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
			rows : objGiacs352.monthEndCheckingScriptsList.rows
	};
	tbgMonthEndCheckingScripts = new MyTableGrid(giacs352Table);
	tbgMonthEndCheckingScripts.pager = objGiacs352.monthEndCheckingScriptsList;
	tbgMonthEndCheckingScripts.render("giacs352Table");
	
	function setFieldValues(rec){
		try{
			$("txtEomScriptNo").value = (rec == null ? "" : rec.eomScriptNo);
			$("txtEomScriptTitle").value = (rec == null ? "" : unescapeHTML2(rec.eomScriptTitle));
			$("txtEomScriptText1").value = (rec == null ? "" : unescapeHTML2(rec.eomScriptText1));
			$("txtEomScriptText2").value = (rec == null ? "" : unescapeHTML2(rec.eomScriptText2));
			$("txtEomScriptSoln").value = (rec == null ? "" : unescapeHTML2(rec.eomScriptSoln));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrMonthEndCheckingScripts = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function cancelGiacs352(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiacs352.exitPage = exitPage;
						saveGiacs352();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("giacs352FormDiv")){
				changeTagFunc = saveGiacs352;
				var eomCheckingScripts = setRec(objCurrMonthEndCheckingScripts);
				if($F("btnAdd") == "Add"){
					tbgMonthEndCheckingScripts.addBottomRow(eomCheckingScripts);
				} else {
					tbgMonthEndCheckingScripts.updateVisibleRowOnly(eomCheckingScripts, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgMonthEndCheckingScripts.keys.removeFocus(tbgMonthEndCheckingScripts.keys._nCurrentFocus, true);
				tbgMonthEndCheckingScripts.keys.releaseKeys();	
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.eomScriptNo = $F("txtEomScriptNo");
			obj.eomScriptTitle = $F("txtEomScriptTitle");
			obj.eomScriptText1 = $F("txtEomScriptText1");
			obj.eomScriptText2 = $F("txtEomScriptText2");
			obj.eomScriptSoln = $F("txtEomScriptSoln");
			obj.remarks = $F("txtRemarks");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs352;
		objCurrMonthEndCheckingScripts.recordStatus = -1;
		tbgMonthEndCheckingScripts.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiacs352(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgMonthEndCheckingScripts.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgMonthEndCheckingScripts.geniisysRows);

		new Ajax.Request(contextPath+"/GIACEomCheckingScriptsController", {
			method: "POST",
			parameters : {
				action  : "saveGiacs352",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiacs352.exitPage != null) {
							objGiacs352.exitPage = exitPage();
						} else {
							tbgMonthEndCheckingScripts._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("editEomScriptText1").observe("click", function(){
		showOverlayEditor("txtEomScriptText1", 4000, $("txtEomScriptText1").hasAttribute("readonly"));
	});
	
	$("editEomScriptText2").observe("click", function(){
		showOverlayEditor("txtEomScriptText2", 4000, $("txtEomScriptText2").hasAttribute("readonly"));
	});
	
	$("editEomScriptSoln").observe("click", function(){
		showOverlayEditor("txtEomScriptSoln", 4000, $("txtEomScriptSoln").hasAttribute("readonly"));
	});
	
	$("btnCancel").observe("click", cancelGiacs352);
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", deleteRec);
	observeSaveForm("btnSave", saveGiacs352);
	
	$("txtEomScriptTitle").focus();	
	disableButton("btnDelete");
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
</script>