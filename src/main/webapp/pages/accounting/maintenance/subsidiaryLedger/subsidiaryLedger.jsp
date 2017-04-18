<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs309MainDiv" name="giacs309MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Subsidiary Ledger Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs309" name="giacs309">		
		<div class="sectionDiv">
			<div style="" align="center" id="lineDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">SL Type</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 105px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtSlTypeCd" name="txtSlTypeCd" style="width: 80px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" ignoreDelKey="1" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSLTypeLOV" name="searchSLTypeLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtSlTypeName" name="txtSlTypeName" type="text" class="required" style="width: 350px;" value="" readonly="readonly" tabindex="103"/>
						</td>						
					</tr>
					<tr>
						<td class="rightAligned" style="" id="">SL Tag</td>
						<td class="leftAligned" colspan="3">
							<input class="allCaps" type="text" id="txtSlTag" name="txtSlTag" readonly="readonly" style="width: 100px;" maxlength="4" tabindex="104"/>								
							<input id="txtSlTagDesc" name="txtSlTagDesc" type="text" style="width: 350px;" value="" readonly="readonly" tabindex="105"/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="slListsTableDiv" style="padding-top: 10px;">
				<div id="slListsTable" style="height: 332px; margin-left: 135px;"></div>
			</div>
			<div align="center" id="slListsFormDiv">
				<table style="margin-top: 15px;">
					<tr>
						<td></td>
						<td>
							<input id="chkActiveTag" type="checkbox" style="float: left; margin: 0 7px 0 5px;"><label for="chkActiveTag" style="margin: 0 4px 2px 2px;">Active</label>
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td class="rightAligned">Company</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 200px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtFundCd" name="nbtFields" style="width: 175px; float: left; border: none; height: 15px; margin: 0;" maxlength="3" tabindex="201" ignoreDelKey="1" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundLOV" name="searchFundLOV" alt="Go" style="float: right;" tabindex="202"/>
							</span>
						</td>
						<td width="" class="rightAligned">SL Code</td>
						<td class="leftAligned" >
							<input class="required integerUnformattedOnBlur" type="text" id="txtSlCd" name="nbtFields" style="width: 200px; text-align: right;" maxlength="12" tabindex="204" min="-999999999999" max="999999999999" errorMsg="Invalid SL Code. Valid values should be from -999999999999 to 999999999999." />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">SL Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtSlName" name="nbtFields" class="required" type="text" style="width: 552px;" value="" maxlength="500" tabindex="205"/>
						</td>
					</tr>					
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 557px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 530px; margin-top: 0; border: none;" id="txtRemarks" name="nbtFields" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td width="" class="rightAligned" style="padding-left: 66px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px 0 10px 0;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="210">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="211">
			</div>
			<div id="sapSwDiv" style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input id="sapIntegrationSw" type="hidden" value="${sapIntegrationSw }"/>
				<input type="button" class="button" id="btnSapSw" value="SAP Accounts" tabindex="212" style="width: 100px;">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="223">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="224">
</div>
<script type="text/javascript">	
	setModuleId("GIACS309");
	setDocumentTitle("Subsidiary Ledger Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiacs309(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgSlList.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgSlList.geniisysRows);
		new Ajax.Request(contextPath+"/GIACSlListsController", {
			method: "POST",
			parameters : {action : "saveGiacs309",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS309.afterSave != null) {
							objGIACS309.afterSave();
							objGIACS309.afterSave = null;
						} else {
							tbgSlList._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs309);
	
	var objGIACS309 = {};
	var objSlList = null;
	objGIACS309.slList = JSON.parse('${jsonSlLists}');
	objGIACS309.afterSave = null;
	
	var slListsTable = {
			url : contextPath + "/GIACSlListsController?action=showGiacs309&refresh=1",
			options : {
				width : '675px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objSlList = tbgSlList.geniisysRows[y];
					setFieldValues(objSlList);
					tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
					tbgSlList.keys.releaseKeys();
					$("txtSlName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
					tbgSlList.keys.releaseKeys();
					$("txtFundCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
						tbgSlList.keys.releaseKeys();
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
					tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
					tbgSlList.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
					tbgSlList.keys.releaseKeys();
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
					tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
					tbgSlList.keys.releaseKeys();
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
					id : 'slTypeCd',
					width : '0',
					visible : false
				},
				{
					id : 'slTag',
					width : '0',
					visible : false
				},		
				{ 	id:			'activeTag',
					sortable:	false,
					align:		'center',
					altTitle:  	'Active',
					title:   	'Active',
					titleAlign:	'center',
					width:		'50px',
				    sortable: true,
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},
				{
					id : "fundCd",
					title : "Company",
					width : '80px',
					filterOption : true
				},
				{
					id : "slCd",
					title : "SL Code",
					align: 'right',
					titleAlign: 'right',
					width : '150px',
					filterOption : true,
					filterOptionType :'integer'
				},
				{
					id: "slName",
					title: "SL Name",
					width: '350px',
					filterOption: true
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
			rows : objGIACS309.slList.rows
		};

		tbgSlList = new MyTableGrid(slListsTable);
		tbgSlList.pager = objGIACS309.slList;
		tbgSlList.render("slListsTable");
	
	function setFieldValues(rec){
		try {
			$("txtFundCd").value = (rec == null ? "" : unescapeHTML2(rec.fundCd));
			$("txtSlName").value = (rec == null ? "" : unescapeHTML2(rec.slName));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtSlCd").value = (rec == null ? "" : rec.slCd);
			$("txtSlCd").setAttribute("lastValidValue", (rec == null ? "" : rec.slCd ));
			$("chkActiveTag").checked = (rec == null ? false : (rec.activeTag == "Y" ? true: false) );
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
						
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? ($F("txtSlTag") == "S" ? toggleSlListFields(false) : toggleSlListFields(true)) 
								: toggleSlListFields(true);
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			objSlList = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.activeTag = $("chkActiveTag").checked ? "Y" : "N";
			obj.slCd = $F("txtSlCd");
			obj.slName = escapeHTML2($F("txtSlName"));
			obj.fundCd = escapeHTML2($F("txtFundCd"));
			obj.slTypeCd = escapeHTML2($F("txtSlTypeCd"));
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
			changeTagFunc = saveGiacs309;
			var dept = setRec(objSlList);
			if($F("btnAdd") == "Add"){
				tbgSlList.addBottomRow(dept);
			} else {
				tbgSlList.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgSlList.keys.removeFocus(tbgSlList.keys._nCurrentFocus, true);
			tbgSlList.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("slListsFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgSlList.geniisysRows.length; i++){
						if(tbgSlList.geniisysRows[i].recordStatus == 0 || tbgSlList.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgSlList.geniisysRows[i].fundCd) == $F("txtFundCd") /*&& unescapeHTML2(tbgSlList.geniisysRows[i].slTypeCd) == unescapeHTML2($F("txtSlTypeCd"))*/
									&& tbgSlList.geniisysRows[i].slCd == $F("txtSlCd")){
								addedSameExists = true;								
							}							
						} else if(tbgSlList.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgSlList.geniisysRows[i].fundCd) == $F("txtFundCd") /*&& unescapeHTML2(tbgSlList.geniisysRows[i].slTypeCd) == unescapeHTML2($F("txtSlTypeCd"))*/
									&& tbgSlList.geniisysRows[i].slCd == $F("txtSlCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same fund_cd, sl_type_cd and sl_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACSlListsController", {
						parameters : {action : 		"valAddRec",
									  fundCd:   	$F("txtFundCd"),
									  slTypeCd:		$F("txtSlTypeCd"),
									  slCd : 		$F("txtSlCd")},
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
		changeTagFunc = saveGiacs309;
		objSlList.recordStatus = -1;
		tbgSlList.geniisysRows[rowIndex].slTypeCd = escapeHTML2(tbgSlList.geniisysRows[rowIndex].slTypeCd);
		tbgSlList.geniisysRows[rowIndex].fundCd = tbgSlList.geniisysRows[rowIndex].fundCd.replace(/\\/g,"&#92;");
		tbgSlList.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		/*try{
			new Ajax.Request(contextPath + "/GIACSlListsController", {
				parameters : {action : 		"valDeleteRec",
							  fundCd:   	$F("txtFundCd"),
							  slTypeCd:		$F("txtSlTypeCd"),
							  slCd : 		$F("txtSlCd")},
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
		}*/
		deleteRec();
		
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs309(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS309.afterSave = exitPage;
						saveGiacs309();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showSLTypeLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtSlTypeCd").trim() == "" ? "%" : $F("txtSlTypeCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs309SlTypeLOV",
					searchString : searchString,
					moduleId: 'GIACS309',
					page : 1
				},
				title : "List of Subsidiary Types",
				width : 500,
				height : 386,
				columnModel : [ {
					id : "slTypeCd",
					title : "SL Type Cd",
					width : '70px',
					renderer: function(value){
						return unescapeHTML2(value);
					}
				}, {
					id : "slTypeName",
					title : "SL Type Name",
					width : '280px'
				},{
					id : "slTag",
					title : "SL Tag",
					width : '50px',
				}, {
					id : "slTagDesc",
					title : "SL Tag Desc",
					width : '80px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtSlTypeCd").value = unescapeHTML2(row.slTypeCd);
						$("txtSlTypeCd").setAttribute("lastValidValue", unescapeHTML2(row.slTypeCd));
						$("txtSlTypeName").value = unescapeHTML2(row.slTypeName);
						$("txtSlTag").value = unescapeHTML2(row.slTag);
						$("txtSlTagDesc").value = unescapeHTML2(row.slTagDesc);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtSlTypeCd").focus();
					$("txtSlTypeCd").value = $("txtSlTypeCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtSlTypeCd").value = $("txtSlTypeCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSlTypeCd");
				} 
			});
		}catch(e){
			showErrorMessage("showSLTypeLOV", e);
		}		
	}
	
	function showFundLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtFundCd").trim() == "" ? "%" : $F("txtFundCd"));	
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getCompanyLOV",
					searchString : searchString+"%",
					moduleId: 'GIACS309',
					page : 1
				},
				title : "List of Companies",
				width : 360,
				height : 386,
				columnModel : [ 
				{
					id : "fundCd",
					title : "Fund Cd",
					width : '120px',
				}, {
					id : "fundDesc",
					title : "Fund Desc",
					width : '225px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtFundCd").value = unescapeHTML2(row.fundCd);
						$("txtFundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
					}
				},
				onCancel: function(){
					$("txtFundCd").focus();
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundCd");
				} 
			});
		}catch(e){
			showErrorMessage("showFundLOV", e);
		}		
	}
	
	
	function toggleSlListFields(enable){
		try{
			if (enable){
				$("chkActiveTag").disabled = false;
				if ($F("txtSlTag") != "S"){
					if ($F("txtFundCd") == ""){
						$("txtFundCd").readOnly = false;
						enableSearch("searchFundLOV");
						$("txtSlCd").readOnly = false;						
					}else{
						$("txtFundCd").readOnly = true;
						disableSearch("searchFundLOV");
						$("txtSlCd").readOnly = true;
					}
					$("txtSlName").readOnly = false;
					$("txtRemarks").readOnly = false;					
				}
				enableButton("btnAdd");	
				enableButton("btnSapSw");		
			}else{		
				$("chkActiveTag").disabled = true;
				$("txtFundCd").readOnly = true;
				disableSearch("searchFundLOV");
				$("txtSlCd").readOnly = true;
				$("txtSlName").readOnly = true;
				$("txtRemarks").readOnly = true;
				disableButton("btnAdd");	
				disableButton("btnSapSw");	
			}
		}catch(e){
			showErrorMessage("toggleSlListFields", e);
		}
	}
	
	function enterQuery(){
		changeTag = 0;
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableSearch("searchSLTypeLOV");
		$("txtSlTypeCd").readOnly = false;
		tbgSlList.url = contextPath+"/GIACSlListsController?action=showGiacs309&refresh=1";
		tbgSlList._refreshList();
		$("txtSlTypeCd").setAttribute("lastValidValue", "");
		$("txtSlTypeCd").clear();
		$("txtSlTypeName").clear();
		$("txtSlTag").clear();
		$("txtSlTagDesc").clear();
		toggleSlListFields(false);
		$("txtSlTypeCd").focus();
	}
	
	$("searchSLTypeLOV").observe("click", function(){
		showSLTypeLOV(true);
	});
	
	$("txtSlTypeCd").observe("change", function(){
		if (this.value != ""){
			showSLTypeLOV(false);
		}else{
			$("txtSlTypeName").clear();
			$("txtSlTag").clear();
			$("txtSlTagDesc").clear();
			$("txtSlTypeCd").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("txtSlTypeCd").observe("keydown", function(e){
		if (this.readOnly){
			if (e.keyCode == 46){
				$("txtSlTypeCd").blur();
				$("txtSlTypeCd").value = $("txtSlTypeCd").readAttribute("lastValidValue");
			}
		}
	});
	
	$$("input[name='nbtFields'], textarea[name='nbtFields']").each(function(txt){
		txt.observe("click", function(){
			if($F("txtSlTag") == "S"){
				//showMessageBox("Update of a system-generated record is not allowed.", "E");
			}
		});
	});
	
	
	$("searchFundLOV").observe("click", function(){
		showFundLOV(true);
	});
	
	$("txtFundCd").observe("change", function(){
		if (this.value != ""){
			showFundLOV(false);
		}else{
			$("txtFundCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtFundCd").observe("keyup", function(){
		$("txtFundCd").value = $F("txtFundCd").toUpperCase();
	});
	
	
	
	$("btnSapSw").observe("click", function(){
		showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		//showGiacs800();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGIACS309.afterSave = enterQuery;
						saveGiacs309();
					},
					function(){
						enterQuery();
					},
					""
			);
		}else{
			enterQuery();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		disableToolbarButton(this.id);
		enableToolbarButton("btnToolbarEnterQuery");
		disableSearch("searchSLTypeLOV");
		$("txtSlTypeCd").readOnly = true;
		tbgSlList.url = contextPath+"/GIACSlListsController?action=showGiacs309&refresh=1&slTypeCd="+encodeURIComponent($F("txtSlTypeCd"));
		tbgSlList._refreshList();
		if (tbgSlList.rows.length == 0){
			showWaitingMessageBox("Query caused no record to be retrieved.", "I", function(){
				if ($F("txtSlTag") == "S"){
					showWaitingMessageBox("Creation of records is not allowed here.", "E", function(){
						toggleSlListFields(false);
					});
				}else{
					toggleSlListFields(true);	
				}	
			});
		}else{
			if ($F("txtSlTag") == "S"){
				showWaitingMessageBox("Creation of records is not allowed here.", "E", function(){
					toggleSlListFields(false);
				});
			}else{
				toggleSlListFields(true);	
			}	
		}	
	});
	
	disableButton("btnDelete");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	observeSaveForm("btnSave", saveGiacs309);
	observeSaveForm("btnToolbarSave", saveGiacs309);
	$("btnCancel").observe("click", cancelGiacs309);
	$("btnAdd").observe("click", valAddRec);
	
	$("btnDelete").observe("click", function(){
		if ($F("txtSlTag") == "S"){
			showMessageBox("Deletion of a system-generated record is not allowed.", "E");
		}else{
			valDeleteRec();	
		}
	});

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$$("div#slListsFormDiv input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	
	$("txtSlTypeCd").focus();	
	
	/* SAP modules will not be converted yet : 12.19.2013 
	if ($F("sapIntegrationSw") == "Y"){
		$("sapSwDiv").show();	
	}else{*/
		$("sapSwDiv").hide();		
	//}
	
	
	toggleSlListFields(false);
</script>