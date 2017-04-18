<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss074MainDiv" name="giiss074MainDiv" style="">
	<!-- <div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="acExit">Exit</a></li>
			</ul>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Reinsurance Document Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss074" name="giiss074">		
		<div id="riFormDiv" align="center" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px;">
			<table cellspacing="0" width: 900px;">
				<tr>
					<td class="rightAligned" style="width:50px;">RI Type</td>
					<td class="leftAligned" style="width:400px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtRiType" name="txtRiType" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey" maxlength="2" tabindex="101" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiType" name="searchRiType" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtRiTypeDesc" name="txtRiTypeDesc" ignoreDelKey="1" style="width: 300px; float: left; height: 15px;" class="allCaps required" maxlength="30" readonly="readonly" tabindex="102" />
						</span>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv">
			<div id="riDocTypeTableDiv" style="padding-top: 10px;">
				<div id="riDocTypeTable" style="height: 331px; padding-left: 165px;"></div>
			</div>
			<div align="center" id="riDocTypeFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="tbgRiDocType" type="text" class="required allCaps" style="width: 210px; text-align: left;" tabindex="201" maxlength="3" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Document Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDocName" type="text" class="required allCaps" style="width: 533px;" tabindex="203" maxlength="50" readonly="readonly">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea readonly="readonly" style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 210px;" readonly="readonly" tabindex="206"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="rightAligned"><input id="txtLastUpdate" type="text" class="" style="width: 210px;" readonly="readonly" tabindex="207"></td>
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
	setModuleId("GIISS074");
	setDocumentTitle("Reinsurance Document Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	showToolbarButton("btnToolbarSave"); 
	hideToolbarButton("btnToolbarPrint"); 
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableButton("btnAdd");
	$("txtRiType").focus();
	
	function saveGiiss074(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgRiDocType.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgRiDocType.geniisysRows);
		new Ajax.Request(contextPath+"/GIISRiTypeDocsController", {
			method: "POST",
			parameters : {action : "saveGIISS074",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS074.exitPage != null) {
							objGIISS074.exitPage();
						} else {
							tbgRiDocType._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGIISS074);
	
	var objGIISS074 = {};
	var objCurrRiDocType = null;
	objGIISS074.riTypeDocsList = JSON.parse('${jsonRiTypeDocs}');
	objGIISS074.exitPage = null;
	
	var riDocTypeTable = {
			url : contextPath + "/GIISRiTypeDocsController?action=showGIISS074&refresh=1",
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRiDocType = tbgRiDocType.geniisysRows[y];
					setFieldValues(objCurrRiDocType);
					tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
					tbgRiDocType.keys.releaseKeys();
					$("txtDocName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
					tbgRiDocType.keys.releaseKeys();
					$("tbgRiDocType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
						tbgRiDocType.keys.releaseKeys();
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
					tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
					tbgRiDocType.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
					tbgRiDocType.keys.releaseKeys();
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
					tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
					tbgRiDocType.keys.releaseKeys();
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
					id : 'docCd',
					title : "Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'docName',
					filterOption : true,
					title : 'Document Name',
					width : '480px'				
				},
				{
					id : 'riType',
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
			rows : objGIISS074.riTypeDocsList.rows
		};

		tbgRiDocType = new MyTableGrid(riDocTypeTable);
		tbgRiDocType.pager = objGIISS074.riTypeDocsList;
		tbgRiDocType.render("riDocTypeTable");
	
	function setFieldValues(rec){
		try{
			$("tbgRiDocType").value = (rec == null ? "" : unescapeHTML2(rec.docCd));
			$("tbgRiDocType").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.docCd)));
			$("txtDocName").value = (rec == null ? "" : unescapeHTML2(rec.docName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("tbgRiDocType").readOnly = false : $("tbgRiDocType").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRiDocType = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.riType = escapeHTML2($F("txtRiType"));
			obj.docCd = escapeHTML2($F("tbgRiDocType"));
			obj.docName = escapeHTML2($F("txtDocName"));
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
			changeTagFunc = saveGiiss074;
			var dept = setRec(objCurrRiDocType);
			if($F("btnAdd") == "Add"){
				tbgRiDocType.addBottomRow(dept);
			} else {
				tbgRiDocType.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgRiDocType.keys.removeFocus(tbgRiDocType.keys._nCurrentFocus, true);
			tbgRiDocType.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("riDocTypeFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgRiDocType.geniisysRows.length; i++) {
						if (tbgRiDocType.geniisysRows[i].recordStatus == 0 || tbgRiDocType.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgRiDocType.geniisysRows[i].docCd) == $F("tbgRiDocType")) {
								addedSameExists = true;
							}
						} else if (tbgRiDocType.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgRiDocType.geniisysRows[i].docCd) == $F("tbgRiDocType")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same ri_type and doc_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISRiTypeDocsController", {
						parameters : {
							action : "valAddRec",
							riType : $F("txtRiType"),
							docCd : $F("tbgRiDocType")
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
		changeTagFunc = saveGiiss074;
		objCurrRiDocType.recordStatus = -1;
		tbgRiDocType.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISRiTypeDocsController", {
				parameters : {
					action : "valDeleteRec",
					docCd : $F("tbgRiDocType")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if(response.responseText == "Y"){
						
					} else{
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
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

	function cancelGiiss074() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS074.exitPage = exitPage;
						saveGiiss074();
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
	
	$("searchRiType").observe("click",function(){
		showRITypeLOV("%");
	});
	
	function showRITypeLOV(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "getGiiss074LOV",
					  search : x,
						page : 1
				},
				title: "List of RI Types",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'riType',
						title: 'RI Type',
						width : '100px',
						align: 'left'
					},
					{
						id : 'riTypeDesc',
						title: 'RI Type Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText : nvl(escapeHTML2(x), "%"),
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtRiType").value = unescapeHTML2(row.riType);
						$("txtRiTypeDesc").value = unescapeHTML2(row.riTypeDesc);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						$("txtRiType").setAttribute("lastValidValue", unescapeHTML2(row.riType));
						$("txtRiTypeDesc").setAttribute("lastValidValue", unescapeHTML2(row.riTypeDesc));
					}
				},
				onCancel: function(){
					$("txtRiType").focus();
					$("txtRiType").value = $("txtRiType").getAttribute("lastValidValue");
					$("txtRiTypeDesc").value = $("txtRiTypeDesc").getAttribute("lastValidValue");
					
		  		},
		  		onUndefinedRow: function(){
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtRiType");
		  			$("txtRiType").value = $("txtRiType").getAttribute("lastValidValue");
					$("txtRiTypeDesc").value = $("txtRiTypeDesc").getAttribute("lastValidValue");
		  		}
			});
		}catch(e){
			showErrorMessage("showRITypeLOV",e);
		}
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		tbgRiDocType.url = contextPath +"/GIISRiTypeDocsController?action=showGIISS074&refresh=1&riType="+$F("txtRiType");
		tbgRiDocType._refreshList();
		changeTag = 0;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableButton("btnAdd");
		$("txtRiType").readOnly = true;
		$("tbgRiDocType").readOnly = false;
		$("txtDocName").readOnly = false;
		$("txtRemarks").readOnly = false;
		disableSearch("searchRiType");
		$("tbgRiDocType").focus();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS074.exitPage = pageRefresh;
						saveGiiss074();
					}, function() {
						pageRefresh();
					}, "");
		} else {
			pageRefresh();
		}
	});
	
	function pageRefresh(){
		tbgRiDocType.url = contextPath +"/GIISRiTypeDocsController?action=showGIISS074&refresh=1";
		tbgRiDocType._refreshList();
		$("txtRiType").value = "";
		$("txtRiTypeDesc").value = "";
		$("tbgRiDocType").readOnly = true;
		$("txtDocName").readOnly = true;
		$("txtRemarks").readOnly = true;
		$("txtRiType").readOnly = false;
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		$("txtRiType").setAttribute("lastValidValue", "");
		$("txtRiTypeDesc").setAttribute("lastValidValue", "");
		enableSearch("searchRiType");
		disableButton("btnAdd");
		changeTag = 0;
	}
	
	$("txtRiType").observe("change",function(){
		if($("txtRiType").value==""){
			$("txtRiTypeDesc").value = "";
			$("txtRiType").setAttribute("lastValidValue", "");
			$("txtRiTypeDesc").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else if($("txtRiType").value!=""){
			enableToolbarButton("btnToolbarEnterQuery");
			validateRiType();
		}
	});
	
	function validateRiType(){
		new Ajax.Request(contextPath+"/GIISRiTypeDocsController", {
			method: "POST",
			parameters: {
				action: "validateRiType",
				riType: $("txtRiType").value
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.riType, "") == ""){
						showRITypeLOV($("txtRiType").value);
					} else if(obj.riType == "---"){
						showRITypeLOV($("txtRiType").value);
					} else{
						$("txtRiType").value = unescapeHTML2(obj.riType);
						$("txtRiTypeDesc").value = unescapeHTML2(obj.riTypeDesc);
						enableToolbarButton("btnToolbarExecuteQuery");
						$("txtRiType").setAttribute("lastValidValue", unescapeHTML2(obj.riType));
						$("txtRiTypeDesc").setAttribute("lastValidValue", unescapeHTML2(obj.riTypeDesc));
					}
				}
			}
		});
	}
	
	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");

	observeSaveForm("btnSave", saveGiiss074);
	$("btnCancel").observe("click", cancelGiiss074);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	observeSaveForm("btnToolbarSave", saveGiiss074);
</script>