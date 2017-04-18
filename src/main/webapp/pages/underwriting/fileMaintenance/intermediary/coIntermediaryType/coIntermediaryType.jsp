<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss075MainDiv" name="giiss075MainDiv" style="">
	<div id="coIntrmdryTypesExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Co-Intermediary Type Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss075" name="giiss075">		
		<div class="sectionDiv">
			<div id="coIntrmdryTypesTableDiv" style="padding-top: 10px;">
				<div id="coIntrmdryTypesTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="coIntrmdryTypesFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Type</td>
						<td	>
							<input id="txtCoIntmType" class="required" type="text" style="width: 200px;margin-bottom:0" maxlength="5" tabindex="201">
						</td>		
						<td align="right" style="width: 100px;">Issue Source</td>
						<td><span class="lovSpan" style="width: 100px; height:19px;margin-top:2px;margin-bottom: 0px">
								<input id="txtIssCd" class="required" maxlength="2" type="text" style="width:75px;height: 13px;border: 0;margin: 0" tabindex="202"><img
								src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
								id="imgSearchIssueSource" class="required" alt="Go" style="float: right; margin-top: 2px;" tabindex="203"/>
							</span>	
						</td>
						<td><input id="txtIssName" readonly="readonly" type="text" style="width:200px;margin-bottom: 0px" tabindex="204"></td>		
					</tr>	
					<tr>
						<td align="right">Type Name</td>
						<td colspan="4">
							<input id="txtTypeName" type="text" class="required" style="width: 622px;" maxlength="100" tabindex="205">
						</td>
					</tr>				
					<tr>
						<td align="right">Remarks</td>
						<td colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 628px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 602px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td align="right">User ID</td>
						<td><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td align="right" colspan="2">Last Update</td>
						<td><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="210">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="211">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS075");
	setDocumentTitle("Co-Intermediary Type Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss075(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		} 
		var setRows = getAddedAndModifiedJSONObjects(tbgCoIntrmdryTypes.geniisysRows);		
		var delRows = getDeletedJSONObjects(tbgCoIntrmdryTypes.geniisysRows);
		new Ajax.Request(contextPath+"/GIISCoIntrmdryTypesController", {
			method: "POST",
			parameters : {action : "saveGiiss075",
						 setRows : prepareJsonAsParameter(setRows),
					 	 delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS075.exitPage != null) {
							objGIISS075.exitPage();
						} else {
							tbgCoIntrmdryTypes._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		}); 
	}
	
	observeReloadForm("reloadForm", showGiiss075);
	
	var objGIISS075 = {};
	var objCurrCoIntrmdryTypes = null;
	objGIISS075.coIntrmdryTypesList = JSON.parse('${jsonCoIntrmdryTypesList}');
	objGIISS075.exitPage = null;
	
	var coIntrmdryTypesTable = {
			url : contextPath + "/GIISCoIntrmdryTypesController?action=showGiiss075&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrCoIntrmdryTypes = tbgCoIntrmdryTypes.geniisysRows[y];
					setFieldValues(objCurrCoIntrmdryTypes);
					tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
					tbgCoIntrmdryTypes.keys.releaseKeys();
					$("txtTypeName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
					tbgCoIntrmdryTypes.keys.releaseKeys();
					$("txtCoIntmType").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
						tbgCoIntrmdryTypes.keys.releaseKeys();
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
					tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
					tbgCoIntrmdryTypes.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
					tbgCoIntrmdryTypes.keys.releaseKeys();
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
					tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
					tbgCoIntrmdryTypes.keys.releaseKeys();
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
				},{
					id : 'issCd issName',
					title : "Issue Source",			
					width : '320px',			
					children : [{
		                id : 'issCd',
		                title:'Issue Code',
		                width: 100,
		                filterOption: true
		            },{
		                id : 'issName',
		                title: 'Issue Name',
		                width: 220,
		                filterOption: true
		            }]				
				},
				{
					id : "coIntmType",
					title : "Type",
					width : '120px',
					filterOption : true
				},						
				{
					id : 'typeName',			
					title : 'Type Name',
					width : '415px',
					filterOption : true,
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
			rows : objGIISS075.coIntrmdryTypesList.rows
		};

		tbgCoIntrmdryTypes = new MyTableGrid(coIntrmdryTypesTable);
		tbgCoIntrmdryTypes.pager = objGIISS075.coIntrmdryTypesList;
		tbgCoIntrmdryTypes.render("coIntrmdryTypesTable");
	
	function setFieldValues(rec){
		try{
			$("txtIssCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("txtIssName").value = (rec == null ? "" : unescapeHTML2(rec.issName));			
			$("txtCoIntmType").value = (rec == null ? "" : unescapeHTML2(rec.coIntmType));	
			$("txtTypeName").value = (rec == null ? "" : unescapeHTML2(rec.typeName));	
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtIssCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.issCd)));
			$("txtIssName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.issName)));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtCoIntmType").readOnly = false : $("txtCoIntmType").readOnly = true;
			rec == null ? $("txtIssCd").readOnly = false : $("txtIssCd").readOnly = true;
			rec == null ? enableSearch("imgSearchIssueSource") : disableSearch("imgSearchIssueSource");
			objCurrCoIntrmdryTypes = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.issName = escapeHTML2($F("txtIssName"));
			obj.coIntmType = escapeHTML2($F("txtCoIntmType"));
			obj.typeName = escapeHTML2($F("txtTypeName"));			
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss075;
			var dept = setRec(objCurrCoIntrmdryTypes);
			if($F("btnAdd") == "Add"){
				tbgCoIntrmdryTypes.addBottomRow(dept);
			} else {
				tbgCoIntrmdryTypes.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCoIntrmdryTypes.keys.removeFocus(tbgCoIntrmdryTypes.keys._nCurrentFocus, true);
			tbgCoIntrmdryTypes.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("coIntrmdryTypesFormDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgCoIntrmdryTypes.geniisysRows.length; i++) {
						if (tbgCoIntrmdryTypes.geniisysRows[i].recordStatus == 0
								|| tbgCoIntrmdryTypes.geniisysRows[i].recordStatus == 1) {
							if (tbgCoIntrmdryTypes.geniisysRows[i].coIntmType == escapeHTML2($F("txtCoIntmType"))&& tbgCoIntrmdryTypes.geniisysRows[i].issCd == $F("txtIssCd")) {
								addedSameExists = true;
							}
						} else if (tbgCoIntrmdryTypes.geniisysRows[i].recordStatus == -1) {
							if (tbgCoIntrmdryTypes.geniisysRows[i].coIntmType == escapeHTML2($F("txtCoIntmType"))&& tbgCoIntrmdryTypes.geniisysRows[i].issCd == $F("txtIssCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same iss_cd and co_intm_type.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISCoIntrmdryTypesController", {
						parameters : {
							action : "valAddRec",
							coIntmType : $F("txtCoIntmType"),
							issCd : $F("txtIssCd")
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
		changeTagFunc = saveGiiss075;
		objCurrCoIntrmdryTypes.recordStatus = -1;
		objCurrCoIntrmdryTypes.coIntmType = escapeHTML2($F("txtCoIntmType"));
		tbgCoIntrmdryTypes.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISCoIntrmdryTypesController", {
				parameters : {
					action : "valDeleteRec",
					coIntmType : $F("txtCoIntmType"),
					issCd : $F("txtIssCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)
							&& checkCustomErrorOnResponse(response)) {
						deleteRec();
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

	function cancelGiiss075() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS075.exitPage = exitPage;
						saveGiiss075();
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
	
	function showIssueSourceLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "showIssueSourceLOV",
				searchString : ($("txtIssCd").readAttribute("lastValidValue") != $F("txtIssCd") ? nvl($F("txtIssCd"),"%") : "%"),
				page : 1,				
			},
			title : "List of Issue Sources",
			width : 416,
			height : 386,
			columnModel : [ {
				id : "issCd",
				title : "Issue Code",
				width : '135px'
			},{
				id : "issName",
				title : "Issue Name",
				width : '250px'
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtIssCd").readAttribute("lastValidValue") != $F("txtIssCd") ? nvl($F("txtIssCd"),"%") : "%"),
			onSelect : function(row) {
				$("txtIssCd").value = unescapeHTML2(row.issCd);	
				$("txtIssName").value = unescapeHTML2(row.issName);				
				$("txtIssCd").setAttribute("lastValidValue", row.issCd);
				$("txtIssName").setAttribute("lastValidValue", row.issName);
			},
			onCancel : function() {
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
				$("txtIssName").value=$("txtIssName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtIssCd");	
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
				$("txtIssName").value=$("txtIssName").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	

	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	$("imgSearchIssueSource").observe("click", function() {
		showIssueSourceLOV();
	});
	
	$("txtIssCd").observe("keyup", function() {
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});	
	
	$("txtIssCd").observe("change", function() {
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
		if($F("txtIssCd").trim()!=""&& $("txtIssCd").value != $("txtIssCd").readAttribute("lastValidValue")){						
			showIssueSourceLOV();			
		}else if($F("txtIssCd").trim()==""){
			$("txtIssCd").value="";	
			$("txtIssName").value="";	
			$("txtIssCd").setAttribute("lastValidValue","");
			$("txtIssName").setAttribute("lastValidValue","");
		}					
	});	
	
	$("txtCoIntmType").observe("keyup", function() {
		$("txtCoIntmType").value = $F("txtCoIntmType").toUpperCase();
	});	
	
	$("txtCoIntmType").observe("change", function() {
		$("txtCoIntmType").value = $F("txtCoIntmType").toUpperCase();
	});	
	
	$("txtTypeName").observe("keyup", function() {
		$("txtTypeName").value = $F("txtTypeName").toUpperCase();
	});	
	
	$("txtTypeName").observe("change", function() {
		$("txtTypeName").value = $F("txtTypeName").toUpperCase();
	});	
		
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss075);
	$("btnCancel").observe("click", cancelGiiss075);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtCoIntmType").focus();
</script>