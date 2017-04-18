<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs308MainDiv" name="giacs308MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Subsidiary Ledger Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs308" name="giacs308">		
		<div class="sectionDiv">
			<div id="slTypeTableDiv" style="padding-top: 10px;">
				<div id="slTypeTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="slTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">SL Type Code</td>
						<td class="leftAligned">
							<input id="txtSlTypeCd" type="text" class="required" style="width: 200px;" tabindex="201" maxlength="2">
						</td>
						<td class="rightAligned" width="113px">SL Tag</td>
						<td class="leftAligned">
							<select id="selSlTag" style="width: 207px; height: 24px;" class="required" tabindex="202">
								<option value=""></option>
								<c:forEach var="slTag" items="${slTagLOV}">
									<option value="${slTag.rvLowValue}">${slTag.rvMeaning}</option>
								</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">SL Type Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtSlTypeName" type="text" class="required" style="width: 533px;" tabindex="203" maxlength="100">
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
	setModuleId("GIACS308");
	setDocumentTitle("Subsidiary Ledger Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs308(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var depts = getAddedAndModifiedJSONObjects(tbgSlType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgSlType.geniisysRows);
		new Ajax.Request(contextPath+"/GIACSlTypeController", {
			method: "POST",
			parameters : {action : "saveGiacs308",
					 	  setRows : prepareJsonAsParameter(depts),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS308.exitPage != null) {
							objGIACS308.exitPage();
						} else {
							tbgSlType._refreshList();
						}
					});
					changeTag = 0;					
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs308);
	
	var objGIACS308 = {};
	var objCurrSlType = null;
	objGIACS308.slTypeList = JSON.parse('${jsonSlTypeList}');
	objGIACS308.exitPage = null;
	
	var slTypeTable = {
			url : contextPath + "/GIACSlTypeController?action=showGiacs308&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrSlType = tbgSlType.geniisysRows[y];
					setFieldValues(objCurrSlType);
					tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
					tbgSlType.keys.releaseKeys();
					$("txtSlTypeName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
					tbgSlType.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
						tbgSlType.keys.releaseKeys();
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
					tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
					tbgSlType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
					tbgSlType.keys.releaseKeys();
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
					tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
					tbgSlType.keys.releaseKeys();
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
					id : "slTypeCd",
					title : "SL Type Code",
					filterOption : true,
					width : '100px'
				},
				{
					id : 'slTypeName',
					filterOption : true,
					title : 'SL Name',
					width : '550px'				
				},
				{
					id : 'dspSlTagMeaning',
					filterOption : true,
					title : 'SL Tag',
					width : '200px'				
				},
				{
					id : 'slTag',
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
			rows : objGIACS308.slTypeList.rows
		};

		tbgSlType = new MyTableGrid(slTypeTable);
		tbgSlType.pager = objGIACS308.slTypeList;
		tbgSlType.render("slTypeTable");
	
	function setFieldValues(rec){
		try{
			$("txtSlTypeCd").value = (rec == null ? "" : rec.slTypeCd);
			$("txtSlTypeCd").setAttribute("lastValidValue", (rec == null ? "" : rec.slTypeCd));
			$("txtSlTypeName").value = (rec == null ? "" : unescapeHTML2(rec.slTypeName));
			$("selSlTag").value = (rec == null ? "" : rec.slTag);
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtSlTypeCd").readOnly = false : $("txtSlTypeCd").readOnly = true;
			rec == null ? $("selSlTag").disabled = false : $("selSlTag").disabled = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrSlType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setSlType(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.slTypeCd = $F("txtSlTypeCd");
			obj.slTypeName = $F("txtSlTypeName");
			obj.slTag = $F("selSlTag");
			obj.dspSlTagMeaning = $("selSlTag").options[$("selSlTag").selectedIndex].text;
			obj.remarks = $F("txtRemarks");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setSlType", e);
		}
	}
	
	function addSlType(){
		try {
			changeTagFunc = saveGiacs308;
			var dept = setSlType(objCurrSlType);
			if($F("btnAdd") == "Add"){
				tbgSlType.addBottomRow(dept);
			} else {
				tbgSlType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgSlType.keys.removeFocus(tbgSlType.keys._nCurrentFocus, true);
			tbgSlType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addSlType", e);
		}
	}		
	
	function deleteSlType(){
		changeTagFunc = saveGiacs308;
		objCurrSlType.recordStatus = -1;
		tbgSlType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valAddSlType(){
		try{
			if(checkAllRequiredFieldsInDiv("slTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					new Ajax.Request(contextPath + "/GIACSlTypeController", {
						parameters : {action : "valAddSlType",
									  slTypeCd : $F("txtSlTypeCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addSlType();
							}
						}
					});
				} else {
					addSlType();
				}
			}
		} catch(e){
			showErrorMessage("valAddSlType", e);
		}
	}
	
	function valDeleteSlType(){
		try{
			new Ajax.Request(contextPath + "/GIACSlTypeController", {
				parameters : {action : "valDeleteSlType",
							  slTypeCd : $F("txtSlTypeCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteSlType();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteSlType", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs308(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS308.exitPage = exitPage;
						saveGiacs308();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}

	$("txtSlTypeName").observe("keyup", function(e) {
		$("txtSlTypeName").value = $F("txtSlTypeName").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiacs308);
	$("btnCancel").observe("click", cancelGiacs308);
	$("btnAdd").observe("click", valAddSlType);
	$("btnDelete").observe("click", valDeleteSlType);

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtSlTypeCd").focus();
</script>