<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gisms003MainDiv" name="gisms003MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>SMS User Group Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gisms003" name="gisms003">		
		<div class="sectionDiv">
			<div id="smsUserGroupDiv" style="padding-top: 10px;">
				<div id="smsUserGroupTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="" id="smsUserGroupFormDiv" style="margin-left: 70px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned" style="width: 100px;">User Group</td>
						<td class="leftAligned" colspan="3">
							<input type="text" id="txtGroupCd" name="txtGroupCd" class="rightAligned" readonly="readonly" style="float: left; width: 95px; margin-right: 5px; margin-top: 2px;" maxlength="3" tabindex="101"/>
							<input id="txtGroupName" name="txtGroupName" type="text" style="width: 445px;" value="" tabindex="102" maxlength="50"/>
						</td>	
					</tr>	
				    <tr>
						<td class="rightAligned" style="width: 100px;">Table</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required"  style="float: left; width: 559px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtTableColumn" name="txtTableColumn" style="width: 524px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="103" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgTableLOV" name="imgTableLOV" alt="Go" style="float: right;" tabindex="104"/>
							</span>
						</td>	
					</tr>	
				    <tr>
						<td class="rightAligned" style="width: 150px;">Primary Key Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 206px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtPkColumn" name="txtPkColumn" style="width: 181px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="105" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPkLOV" name="imgPkLOV" alt="Go" style="float: right;" tabindex="106"/>
							</span>
						</td>
						<td class="rightAligned" style="width: 120px;">Name Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 209px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtNameColumn" name="txtNameColumn" style="width: 184px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="114" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgNameLOV" name="imgNameLOV" alt="Go" style="float: right;" tabindex="115"/>
							</span>
						</td>	
					</tr>	
				    <tr>
						<td class="rightAligned" style="width: 150px;">Type Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 206px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtTypeColumn" name="txtTypeColumn" style="width: 181px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="107" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgTypeLOV" name="imgTypeLOV" alt="Go" style="float: right;" tabindex="108"/>
							</span>
						</td>
						<td class="rightAligned" style="width: 120px;">Cellphone Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 209px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtCpColumn" name="txtCpColumn" style="width: 184px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="116" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCpLOV" name="imgCpLOV" alt="Go" style="float: right;" tabindex="117"/>
							</span>
						</td>	
					</tr>
				    <tr>
						<td width="" class="rightAligned">Type Value</td>
						<td class="leftAligned">
							<input id="txtTypeValue" type="text" class="" style="width: 200px;" tabindex="109" maxlength="20">
						</td>	
						<td class="rightAligned" style="width: 120px;">Globe Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 209px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtGlobeColumn" name="txtGlobeColumn" style="width: 184px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="118" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgGlobeLOV" name="imgGlobeLOV" alt="Go" style="float: right;" tabindex="119"/>
							</span>
						</td>	
					</tr>																		
					<tr>
						<td width="" class="rightAligned">Keyword</td>
						<td class="leftAligned">
							<input id="txtKeyWord" type="text" class="" style="width: 200px;" tabindex="110" maxlength="20">
						</td>
						<td class="rightAligned" style="width: 120px;">Smart Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 209px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtSmartColumn" name="txtSmartColumn" style="width: 184px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="120" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSmartLOV" name="imgSmartLOV" alt="Go" style="float: right;" tabindex="121"/>
							</span>
						</td>												
					</tr>	
				    <tr>
						<td class="rightAligned" style="width: 150px;">Birthday Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 206px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtBdayColumn" name="txtBdayColumn" style="width: 181px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="111 lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBdayLOV" name="imgBdayLOV" alt="Go" style="float: right;" tabindex="112"/>
							</span>
						</td>
						<td class="rightAligned" style="width: 120px;">Sun Column</td>
						<td class="leftAligned">
							<span class="lovSpan"  style="float: left; width: 209px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtSunColumn" name="txtSunColumn" style="width: 184px; float: left; border: none; height: 15px; margin: 0;" maxlength="100" tabindex="122" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSunLOV" name="imgSunLOV" alt="Go" style="float: right;" tabindex="123"/>
							</span>
						</td>	
					</tr>	
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="113"></td>
						<td width="125px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 203px;" readonly="readonly" tabindex="124"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="201">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="202">
			</div>		
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="203">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="204">
</div>
<script type="text/javascript">	
	setModuleId("GISMS003");
	setDocumentTitle("SMS User Group Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGisms003(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgRecipientGroup.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgRecipientGroup.geniisysRows);
		new Ajax.Request(contextPath+"/GISMRecipientGroupController", {
			method: "POST",
			parameters : {action : "saveGisms003",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGISMS003.exitPage != null) {
							objGISMS003.exitPage();
						} else {
							tbgRecipientGroup._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function showGisms003() {
		try {
			new Ajax.Request(contextPath + "/GISMRecipientGroupController", {
					parameters : {action : "showGisms003"},
					onCreate : showNotice("Retrieving SMS User Group Maintenance, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
		} catch(e){
			showErrorMessage("showGisms003", e);
		}
	}
	
	observeReloadForm("reloadForm", showGisms003);
	
	var objGISMS003 = {};
	var objCurrRecipientGroup = null;
	objGISMS003.smsUserGroupList = JSON.parse('${jsonRecipientGroupList}');
	objGISMS003.exitPage = null;
	
	var smsUserGroupTable = {
			url : contextPath + "/GISMRecipientGroupController?action=showGisms003&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRecipientGroup = tbgRecipientGroup.geniisysRows[y];
					setFieldValues(objCurrRecipientGroup);
					setImgLOV(true);
					tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
					tbgRecipientGroup.keys.releaseKeys();
					$("txtGroupName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					setImgLOV(false);
					tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
					tbgRecipientGroup.keys.releaseKeys();
					$("txtGroupName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						setImgLOV(false);
						tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
						tbgRecipientGroup.keys.releaseKeys();
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
					setImgLOV(false);
					tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
					tbgRecipientGroup.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					setImgLOV(false);
					tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
					tbgRecipientGroup.keys.releaseKeys();
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
					setImgLOV(false);
					tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
					tbgRecipientGroup.keys.releaseKeys();
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
					id : "groupCd groupName",
					title : "User Group",
					align : 'left',
					titleAlign : 'left',
					width : '250px',
					children :[
						{	id: 'groupCd',							
							width: 70,		
							align : 'right',	
							sortable: false
						},
						{	id: 'groupName',							
							width: 180,
							sortable: false
						}
					]
				},
				{
					id : 'tableName',
					filterOption : true,
					title : 'Table',
					width : '200px'				
				},	
				{
					id : 'pkColumn',
					filterOption : true,
					title : 'Primary Key Column',
					width : '200px'				
				},
				{
					id : 'typeColumn',
					filterOption : true,
					title : 'Type Column',
					width : '200px'				
				},				
				{
					id : 'groupName',
					filterOption : true,
					title : 'Group Name',
					width : '0',
					visible: false				
				},
				{
					id : 'groupCd',
					filterOption : true,
					title : 'Group Cd',
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
			rows : objGISMS003.smsUserGroupList.rows
		};

		tbgRecipientGroup = new MyTableGrid(smsUserGroupTable);
		tbgRecipientGroup.pager = objGISMS003.smsUserGroupList;
		tbgRecipientGroup.render("smsUserGroupTable");
	
	function setFieldValues(rec){
		try{
			$("txtGroupCd").value 		= (rec == null ? "" : rec.groupCd);
			$("txtGroupCd").setAttribute("lastValidValue", (rec == null ? "" : rec.groupCd));
			$("txtGroupName").value 	= (rec == null ? "" : unescapeHTML2(rec.groupName));
			$("txtTableColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.tableName));
			$("txtPkColumn").value 		= (rec == null ? "" : unescapeHTML2(rec.pkColumn));
			$("txtTypeColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.typeColumn));
			$("txtTypeValue").value 	= (rec == null ? "" : unescapeHTML2(rec.typeValue));
			$("txtKeyWord").value 		= (rec == null ? "" : unescapeHTML2(rec.keyWord));
			$("txtBdayColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.bdayColumn));
			$("txtNameColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.nameColumn));
			$("txtCpColumn").value 		= (rec == null ? "" : unescapeHTML2(rec.cpColumn));
			$("txtGlobeColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.globeColumn));
			$("txtSmartColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.smartColumn));
			$("txtSunColumn").value 	= (rec == null ? "" : unescapeHTML2(rec.sunColumn));
			$("txtUserId").value 		= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 	= (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRecipientGroup = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.groupCd 	= escapeHTML2($F("txtGroupCd"));
			obj.groupName 	= escapeHTML2($F("txtGroupName"));
			obj.tableName 	= escapeHTML2($F("txtTableColumn"));
			obj.pkColumn 	= escapeHTML2($F("txtPkColumn"));
			obj.typeColumn 	= escapeHTML2($F("txtTypeColumn"));
			obj.typeValue 	= escapeHTML2($F("txtTypeValue"));
			obj.bdayColumn 	= escapeHTML2($F("txtBdayColumn"));
			obj.nameColumn 	= escapeHTML2($F("txtNameColumn"));
			obj.cpColumn 	= escapeHTML2($F("txtCpColumn"));
			obj.globeColumn = escapeHTML2($F("txtGlobeColumn"));
			obj.smartColumn = escapeHTML2($F("txtSmartColumn"));
			obj.sunColumn 	= escapeHTML2($F("txtSunColumn"));
			obj.keyWord 	= escapeHTML2($F("txtKeyWord"));
			obj.userId 		= userId;
			var lastUpdate 	= new Date();
			obj.lastUpdate 	= dateFormat(lastUpdate, 'mm-dd-yyyy');
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGisms003;
			var dept = setRec(objCurrRecipientGroup);
			if($F("btnAdd") == "Add"){
				tbgRecipientGroup.addBottomRow(dept);
			} else {
				tbgRecipientGroup.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgRecipientGroup.keys.removeFocus(tbgRecipientGroup.keys._nCurrentFocus, true);
			tbgRecipientGroup.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("smsUserGroupFormDiv")){
				addRec();
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGisms003;
		objCurrRecipientGroup.recordStatus = -1;
		tbgRecipientGroup.deleteRow(rowIndex);
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
	
	function cancelGisms003(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGISMS003.exitPage = exitPage;
						saveGisms003();
					}, function(){
						changeTag = 0;
						goToModule("/GIISUserController?action=goToSms", "SMS Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToSms", "SMS Main", null);
		}
	}
	
	function setImgLOV(enable) {
		if (enable) {
			enableSearch("imgNameLOV");
			enableSearch("imgPkLOV");
			enableSearch("imgTypeLOV");
			enableSearch("imgBdayLOV");
			enableSearch("imgCpLOV");
			enableSearch("imgGlobeLOV");
			enableSearch("imgSmartLOV");
			enableSearch("imgSunLOV");
		}else {
			disableSearch("imgNameLOV");
			disableSearch("imgPkLOV");
			disableSearch("imgTypeLOV");
			disableSearch("imgBdayLOV");
			disableSearch("imgCpLOV");
			disableSearch("imgGlobeLOV");
			disableSearch("imgSmartLOV");
			disableSearch("imgSunLOV");
		}
	}
	
	function showTableLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtTableColumn").trim() == "" ? "%" : $F("txtTableColumn"));
			
			LOV.show({
				controller : "SmsLOVController",
				urlParameters : {
					action : "getGisms003TableRecList",
					search : search + "%",
					page: 1
				},
				title : "List of Tables",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "tableName",
					title : "Table Name",
					width : '465px'
				}],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtTableColumn").value = row.tableName;
						$("txtTableColumn").setAttribute("lastValidValue", row.tableName);
						setImgLOV(true);
					}
				},
				onCancel : function() {
					$("txtTableColumn").focus();
					$("txtTableColumn").value = $("txtTableColumn").readAttribute("lastValidValue");
					setImgLOV(false);
				},
				onUndefinedRow : function() {
					$("txtTableColumn").value = $("txtTableColumn").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTableColumn");
					setImgLOV(false);
				}
			});
		} catch (e) {
			showErrorMessage("showTablesLOV", e);
		}
	}
	
	function showColumnLOV(isIconClicked, field, title) {
		try {
			var search = isIconClicked ? "%" : ($F(field).trim() == "" ? "%" : $F(field));
			
			LOV.show({
				controller : "SmsLOVController",
				urlParameters : {
					action : "getGisms003ColumnRecList",
					search : search + "%",
					tableName : $F("txtTableColumn"),
					page: 1
				},
				title : title,
				width : 480,
				height : 386,
				columnModel : [ {
					id : "columnName",
					title : "Column Name",
					width : '465px'
				}],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$(field).value = row.columnName;
						$(field).setAttribute("lastValidValue", row.columnName);
					}
				},
				onCancel : function() {
					$(field).focus();
					$(field).value = $(field).readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$(field).value = $(field).readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, field);
				}
			});
		} catch (e) {
			showErrorMessage("showColumnLOV", e);
		}
	}	

	$("txtGroupName").observe("keyup", function(){
		$("txtGroupName").value = $F("txtGroupName").toUpperCase();
	});
	
	$("imgTableLOV").observe("click", function() {
		showTableLOV(true);
	});

	$("txtTableColumn").observe("change", function() {
		if (this.value != "") {
			showTableLOV(false);
		} else {
			setImgLOV(false);
			$("txtTableColumn").value = "";
			$("txtTableColumn").setAttribute("lastValidValue", "");
		}
	});
	
	$("imgNameLOV").observe("click", function() {
		showColumnLOV(true, "txtNameColumn", "List of Names Columns");
	});

	$("txtNameColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtNameColumn", "List of Names Columns");
		} else {
			$("txtNameColumn").value = "";
			$("txtNameColumn").setAttribute("lastValidValue", "");
		}
	});

	$("imgBdayLOV").observe("click", function() {
		showColumnLOV(true, "txtBdayColumn", "List of Birthday Column");
	});

	$("txtBdayColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtBdayColumn", "List of Birthday Column");
		} else {
			$("txtBdayColumn").value = "";
			$("txtBdayColumn").setAttribute("lastValidValue", "");
		}
	});

	$("imgPkLOV").observe("click", function() {
		showColumnLOV(true, "txtPkColumn", "List of Primary Key Column");
	});

	$("txtPkColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtPkColumn", "List of Primary Key Column");
		} else {
			$("txtPkColumn").value = "";
			$("txtPkColumn").setAttribute("lastValidValue", "");
		}
	});
	
	$("imgTypeLOV").observe("click", function() {
		showColumnLOV(true, "txtTypeColumn", "List of Type Column");
	});

	$("txtTypeColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtTypeColumn", "List of Type Column");
		} else {
			$("txtTypeColumn").value = "";
			$("txtTypeColumn").setAttribute("lastValidValue", "");
		}
	});

	$("imgCpLOV").observe("click", function() {
		showColumnLOV(true, "txtCpColumn", "List of Cellphone Nos Column");
	});

	$("txtCpColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtCpColumn", "List of Cellphone Nos Column");
		} else {
			$("txtCpColumn").value = "";
			$("txtCpColumn").setAttribute("lastValidValue", "");
		}
	});

	$("imgGlobeLOV").observe("click", function() {
		showColumnLOV(true, "txtGlobeColumn", "List of Globe Cellphone Nos Column");
	});

	$("txtGlobeColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtGlobeColumn", "List of Globe Cellphone Nos Column");
		} else {
			$("txtGlobeColumn").value = "";
			$("txtGlobeColumn").setAttribute("lastValidValue", "");
		}
	});

	$("imgSmartLOV").observe("click", function() {
		showColumnLOV(true, "txtSmartColumn", "List of Smart Cellphone Nos Column");
	});

	$("txtSmartColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtSmartColumn", "List of Smart Cellphone Nos Column");
		} else {
			$("txtSmartColumn").value = "";
			$("txtSmartColumn").setAttribute("lastValidValue", "");
		}
	});

	$("imgSunLOV").observe("click", function() {
		showColumnLOV(true, "txtSunColumn", "List of Sun Cellphone Nos Column");
	});

	$("txtSunColumn").observe("change", function() {
		if (this.value != "") {
			showColumnLOV(false, "txtSunColumn", "List of Sun Cellphone Nos Column");
		} else {
			$("txtSunColumn").value = "";
			$("txtSunColumn").setAttribute("lastValidValue", "");
		}
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGisms003);
	$("btnCancel").observe("click", cancelGisms003);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtGroupName").focus();
	setImgLOV(false);
</script>