<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss169MainDiv" name="giiss169MainDiv" style="">
	<div id="giiss169Menu">
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
	   		<label>Inspector Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss169" name="giiss169">		
		<div class="sectionDiv">
			<div id="inspectorTableDiv" style="padding-top: 10px;">
				<div id="inspectorTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="inspectorTypeFormDiv" style="margin-top: 10px;">
				<table>
					<tr>
						<td class="rightAligned">Inspector Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtInspCd" type="text" style="width: 200px; text-align: right;" tabindex="201" maxlength="13" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Inspector Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtInspName" type="text" class="required allCaps" style="width: 533px;" tabindex="203" maxlength="100">
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
			<div class="buttonsDiv" style="margin: 10px 0px 10px 0px;">
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
	setModuleId("GIISS169");
	setDocumentTitle("Inspector Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var inspNameList = JSON.parse('${inspNameList}');
	var lastInspName = "";
	
	function saveGiiss169(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgInspector.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgInspector.geniisysRows);
		new Ajax.Request(contextPath+"/GIISInspectorController", {
			method: "POST",
			parameters : {action : "saveGiiss169",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss169.exitPage != null) {
							objGiiss169.exitPage();
						} else {
							tbgInspector._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss169);
	
	var objGiiss169 = {};
	var objCurrInspector = null;
	objGiiss169.inspectorList = JSON.parse('${jsonInspectorList}');
	objGiiss169.exitPage = null;
	
	var inspectorTable = {
			url : contextPath + "/GIISInspectorController?action=showGiiss169&refresh=1",
			options : {
				width : '700px',
				height : '331px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrInspector = tbgInspector.geniisysRows[y];
					setFieldValues(objCurrInspector);
					tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
					tbgInspector.keys.releaseKeys();
					$("txtInspName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
					tbgInspector.keys.releaseKeys();
					$("txtInspCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
						tbgInspector.keys.releaseKeys();
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
					tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
					tbgInspector.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
					tbgInspector.keys.releaseKeys();
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
					tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
					tbgInspector.keys.releaseKeys();
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
					id : "inspCd",
					title : "Code",
					titleAlign : 'right',
					filterOption : true,
					width : '100px',
					align : 'right',
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'inspName',
					filterOption : true,
					title : 'Inspector Name',
					width : '584px'				
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
			rows : objGiiss169.inspectorList.rows
		};

		tbgInspector = new MyTableGrid(inspectorTable);
		tbgInspector.pager = objGiiss169.inspectorList;
		tbgInspector.render("inspectorTable");
		
	function setFieldValues(rec){
		try{
			$("txtInspCd").value = (rec == null ? "" : rec.inspCd);
			$("txtInspCd").setAttribute("lastValidValue", (rec == null ? "" : rec.inspCd));
			$("txtInspName").value = (rec == null ? "" : unescapeHTML2(rec.inspName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			lastInspName = (rec == null ? "" : unescapeHTML2(rec.inspName));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrInspector = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.inspCd = $F("txtInspCd");
			obj.inspName = escapeHTML2($F("txtInspName"));
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
			changeTagFunc = saveGiiss169;
			var dept = setRec(objCurrInspector);
			if($F("btnAdd") == "Add"){
				tbgInspector.addBottomRow(dept);
			} else {
				tbgInspector.updateVisibleRowOnly(dept, rowIndex, false);
				for(var i=0;i<inspNameList.length;i++){
					if (unescapeHTML2(inspNameList[i]) == lastInspName){
						inspNameList.splice(i, 1);
					}
				}
			}
			inspNameList.push($F("txtInspName"));
			changeTag = 1;
			setFieldValues(null);
			tbgInspector.keys.removeFocus(tbgInspector.keys._nCurrentFocus, true);
			tbgInspector.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("inspectorTypeFormDiv")){
				var addedSameInspName = false;
				var deletedSameInspName = false;
				for(var i=0; i<tbgInspector.geniisysRows.length; i++){
					if(tbgInspector.geniisysRows[i].recordStatus == 0 || tbgInspector.geniisysRows[i].recordStatus == 1){	
						if(unescapeHTML2(tbgInspector.geniisysRows[i].inspName) == $F("txtInspName")){
							addedSameInspName = true;	
						}
					}else if(tbgInspector.geniisysRows[i].recordStatus == -1){
						if(tbgInspector.geniisysRows[i].inspName == $F("txtInspName")){
							deletedSameInspName = true;
						}
					}
				}
				
				if($F("btnAdd") == "Add"){
					if(addedSameInspName && !deletedSameInspName){
						showMessageBox("Record already exists with the same insp_name.", "E");
						return;
					}
				}
				
				if(lastInspName != $F("txtInspName")){
					for(var i=0;i<inspNameList.length;i++){
						if(unescapeHTML2(inspNameList[i]) == $F("txtInspName")){
							showMessageBox("Record already exists with the same insp_name.", "E");
							return false;
						}
					}
					addRec();
				}else{
					addRec();	
				}
				
				/* new Ajax.Request(contextPath + "/GIISInspectorController", {
					parameters : {action : "valAddRec",
								  inspName : $F("txtInspName")},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRec();
						}
					}
				}); */
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss169;
		objCurrInspector.recordStatus = -1;
		tbgInspector.deleteRow(rowIndex);

		for(var i = inspNameList.length; i--;){
			if (unescapeHTML2(inspNameList[i]) == $F("txtInspName")){
				inspNameList.splice(i, 1);
			}
		}
		
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISInspectorController", {
				parameters : {action : "valDeleteRec",
							  inspCd : $F("txtInspCd")},
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
	
	function cancelGiiss169(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss169.exitPage = exitPage;
						saveGiiss169();
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
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss169);
	$("btnCancel").observe("click", cancelGiiss169);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtInspCd").focus();	
</script>