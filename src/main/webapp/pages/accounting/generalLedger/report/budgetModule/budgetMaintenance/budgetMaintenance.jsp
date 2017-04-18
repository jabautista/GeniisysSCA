<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs360MainDiv" name="giacs360MainDiv" style="">
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Budget Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs360" name="giacs360">		
		<div class="sectionDiv">
			<div style="" id="headerParamsDiv">
				<div style="padding:10px;">
					<div id="budgetYearTable" style="height: 230px; margin-left: 200px;"></div>
				</div>
				<div>
					<div align="center" id="budgetYearFormDiv">
						<table cellspacing="2" border="0" align="center">	 			
							<tr>
								<td class="rightAligned" style="" id="">Year</td>
								<td class="leftAligned" style="">
									<input class="required rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtYear" name="txtYear" style="width: 145px; float: left; border: none; height: 15px; margin: 0;" maxlength="4" tabindex="104" lastValidValue=""/>
								</td>
								<td class="rightAligned" style="width: 65px;" id="">Month</td>
								<td class="leftAligned">
									<span id="monthSpan" class="lovSpan required" style="float: left; width: 145px; margin-right: 5px; margin-top: 2px; height: 21px;">
										<input ignoreDelKey="" class="required" type="text" id="txtMonth" name="txtMonth" style="width: 120px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="104" lastValidValue=""/>
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgMonthLOV" name="imgMonthLOV" alt="Go" style="float: right;" tabindex="105"/>
									</span>
								</td>
							</tr>
						</table>			
					</div>
					<div style="margin: 10px;" align="center">
						<input type="button" class="button" id="btnAddYearMonth" value="Add" tabindex="202">
					</div>
				</div>
			</div>			
		</div>
		<div id="giacs360SubDiv" name="giacs360SubDiv">		
			<div class="sectionDiv">
				<div id="budgetDiv" style="padding-top: 10px;">
					<div id="budgetTable" style="height: 340px; margin-left: 115px;"></div>
				</div>
				<div align="" id="budgetFormDiv" style="margin-left: 75px;">
					<table style="margin-top: 5px;">
						<tr>
							<td width="146px;" class="rightAligned">Budget</td>
							<td class="leftAligned" colspan="3">
								<input id="txtBudget" type="text" class="rightAligned money4" maxlength="17" style="width: 195px;" tabindex="201" max = 999999999999.99 min = -999999999999.99 errorMsg="Invalid Budget. Valid value should be from -999,999,999,999.99 to 999,999,999,999.99.">
							</td>
						</tr>						
						<tr>	
							<td class="rightAligned" style="width: 100px;">Issuing Source</td>
							<td class="leftAligned" colspan="3">
								<span class="lovSpan required"  style="float: left; width: 125px; margin-right: 5px; margin-top: 2px; height: 21px;">
									<input ignoreDelKey="" class="required" type="text" id="txtIssCd" name="txtIssCd" style="width: 100px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIssLOV" name="imgIssLOV" alt="Go" style="float: right;" tabindex="102"/>
								</span>
								<input id="txtIssName" name="txtIssName" type="text" style="width: 428px;" value="" readonly="readonly" tabindex="103"/>
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 65px;" id="">Line</td>
							<td class="leftAligned" colspan="3">
								<span class="lovSpan required" style="float: left; width: 125px; margin-right: 5px; margin-top: 2px; height: 21px;">
									<input ignoreDelKey="" class="required" type="text" id="txtLineCd" name="txtLineCd" style="width: 100px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="104" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineLOV" name="imgLineLOV" alt="Go" style="float: right;" tabindex="105"/>
								</span>
								<input id="txtLineName" name="txtLineName" type="text" style="width: 428px;" value="" readonly="readonly" tabindex="106"/>
							</td>
						</tr>		
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 195px;" readonly="readonly" tabindex="212"></td>
							<td width="146px;" class="rightAligned">Last Update</td>
							<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 198px;" readonly="readonly" tabindex="213"></td>
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
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="401">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="402">
</div>
<script type="text/javascript">
	setModuleId("GIACS360");
	setDocumentTitle("Budget Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	var rowIndexYear = -1;
	var sysDate = new Date();
	objCurrPartCostId = "";
	
	function saveGiacs360() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBudget.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBudget.geniisysRows);
		new Ajax.Request(contextPath + "/GIACProdBudgetController", {
			method : "POST",
			parameters : {
				action : "saveGiacs360",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIACS360.exitPage != null) {
							objGIACS360.exitPage();
							objGIACS360.exitPage = null;
						} else {
							tbgBudgetYear.url = contextPath + "/GIACProdBudgetController?action=showGiacs360&refresh=1";
							tbgBudgetYear._refreshList();
							tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList&year="+$F("txtYear")+"&month="+$F("txtMonth");
							tbgBudget._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function valSaveRec() {
		if (tbgBudget.geniisysRows.length != 0) {
			saveGiacs360();
		}else {
			showWaitingMessageBox("Month / Year must have at least 1 child record.", imgMessage.INFO, function() {
				logOutOngoing = "N"; 
			});
		}
	}

	observeReloadForm("reloadForm", showGiacs360);

	objGIACS360 = {};
	var objCurrBudget = null;
	var objCurrBudgetYear = null;
	objGIACS360.budgetList = JSON.parse('${jsonBudgetList}');
	objGIACS360.budgetYearList = JSON.parse('${jsonBudgetYearList}');
	objGIACS360.exitPage = null;

	var budgetYearTable = {
			url : contextPath + "/GIACProdBudgetController?action=showGiacs360&refresh=1",
			options : {
				width : '500px',
				hideColumnChildTitle : true,
				masterDetail: true,
				masterDetailRequireSaving: true,
				pager : {},
				beforeClick: function(){
					if(changeTag == 1){
 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
 							$("btnSave").focus();
 						});
 						return false;
 					}
				},
				onCellFocus : function(element, value, x, y, id) {
					rowIndexYear = y;
					if (changeTag == 1 ) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							tbgBudgetYear.selectRow(y);	
						});
						return false;
					}else {
						objCurrBudgetYear = tbgBudgetYear.geniisysRows[y];
						setYearFieldValues(objCurrBudgetYear);
						tbgBudgetYear.keys.removeFocus(tbgBudgetYear.keys._nCurrentFocus, true);
						tbgBudgetYear.keys.releaseKeys();
						tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList&year="+$F("txtYear")+"&month="+$F("txtMonth");
						tbgBudget._refreshList();
						toggleBudgetFields(true);
						if (objCurrBudgetYear.recordStatus == '0' && changeTag == 1) {
							enableButton("btnAddYearMonth");
							enableSearch("imgMonthLOV");
						}
					}
				},
				onRemoveRowFocus : function() {
					if (changeTag == 1 ) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							tbgBudgetYear.selectRow(y);	
						});
						return false;
					}else {
						rowIndexYear = -1;
						setYearFieldValues(null);
						tbgBudgetYear.keys.removeFocus(tbgBudgetYear.keys._nCurrentFocus, true);
						tbgBudgetYear.keys.releaseKeys();
						toggleBudgetFields(false);
						tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList";
						tbgBudget._refreshList();
					}
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						rowIndexYear = -1;
						setYearFieldValues(null);
						tbgBudgetYear.keys.removeFocus(tbgBudgetYear.keys._nCurrentFocus, true);
						tbgBudgetYear.keys.releaseKeys();
						toggleBudgetFields(false);
						tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList";
						tbgBudget._refreshList();
					}
				},
				beforeSort : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort : function() {
					rowIndexYear = -1;
					setYearFieldValues(null);
					tbgBudgetYear.keys.removeFocus(tbgBudgetYear.keys._nCurrentFocus, true);
					tbgBudgetYear.keys.releaseKeys();
					toggleBudgetFields(false);
					tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList";
					tbgBudget._refreshList();
				},
				prePager : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexYear = -1;
					setYearFieldValues(null);
					tbgBudgetYear.keys.removeFocus(tbgBudgetYear.keys._nCurrentFocus, true);
					tbgBudgetYear.keys.releaseKeys();
					toggleBudgetFields(false);
					tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList";
					tbgBudget._refreshList();
				},
				checkChanges : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetail : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc : function() {
					return (changeTag == 1 ? true : false);
				},
				onRefresh : function() {
					rowIndexYear = -1;
					setYearFieldValues(null);
					tbgBudgetYear.keys.removeFocus(tbgBudgetYear.keys._nCurrentFocus, true);
					tbgBudgetYear.keys.releaseKeys();
					toggleBudgetFields(false);
					tbgBudget.url = contextPath + "/GIACProdBudgetController?action=getBudgetRecList";
					tbgBudget._refreshList();
				}
			},
			columnModel : [ 
				{ 						 // this column will only use for deletion
					id : 'recordStatus', // 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "year",
					title : "Year",
					align : 'right',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					titleAlign : 'right',
					width : '235px'
				},  
				{
					id : "month",
					title : "Month",
					filterOption : true,
					width : '235px'
				}
			],
			rows : objGIACS360.budgetYearList.rows
		};
		
		tbgBudgetYear = new MyTableGrid(budgetYearTable);
	 	tbgBudgetYear.pager = objGIACS360.budgetYearList;
		tbgBudgetYear.render("budgetYearTable");
		tbgBudgetYear.afterRender = function() {
			enableDisableFields("disable");
		};

	var budgetTable = {
			url : contextPath + "/GIACProdBudgetController?action=getBudgetRecList",
			options : {
				width : '700px',
				hideColumnChildTitle : true,
				masterDetail: true,
				masterDetailRequireSaving: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objCurrBudget = tbgBudget.geniisysRows[y];
					setFieldValues(objCurrBudget);
					tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
					tbgBudget.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
					tbgBudget.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						rowIndex = -1;
						setFieldValues(null);
						tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
						tbgBudget.keys.releaseKeys();
					}
				},
				beforeSort : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
					tbgBudget.keys.releaseKeys();
				},
				onRefresh : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
					tbgBudget.keys.releaseKeys();
				},
				prePager : function() {
					if (changeTag == 1) {
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
					tbgBudget.keys.releaseKeys();
				},
				checkChanges : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetail : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc : function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc : function() {
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [ 
				{ 						 // this column will only be use for deletion
					id : 'recordStatus', // 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "issCd dspIssName",
					title : "Issuing Source",
					align : 'left',
					titleAlign : 'left',
					width : '250px',
					children :[
						{	id: 'issCd',							
							width: 100,			
							sortable: false
						},
						{	id: 'dspIssName',							
							width: 150,
							sortable: false
						}
					]
				},  
				{
					id : "lineCd dspLineName",
					title : "Line",
					align : 'left',
					titleAlign : 'left',
					width : '250px',
					children :[
						{	id: 'lineCd',							
							width: 100,		
							sortable: false
						},
						{	id: 'dspLineName',							
							width: 150,
							sortable: false
						}
					]
				},
				{
					id : "budget",
					title : "Budget",
					filterOption : true,
					filterOptionType : 'number',
					geniisysClass : 'money',
					align : 'right',
					titleAlign : 'right',
					width : '155px'
				},
				{
					id : 'issCd',
					title : "Iss Cd",
					width : '0',
					filterOption : true,
					visible : false
				},
				{
					id : 'dspIssName',
					title : "Iss Name",
					width : '0',
					filterOption : true,
					visible : false
				},
				{
					id : 'lineCd',
					title : "Line Cd",
					width : '0',
					filterOption : true,
					visible : false
				},
				{
					id : 'dspLineName',
					title : "Line Name",
					width : '0',
					filterOption : true,
					visible : false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible : false
				},
				{
					id : 'userId',
					width : '0',
					visible : false
				}
			],
			rows : objGIACS360.budgetList.rows
		};
		
		tbgBudget = new MyTableGrid(budgetTable);
	 	tbgBudget.pager = objGIACS360.budgetList;
		tbgBudget.render("budgetTable");
		
	function enableDisableFields(toDo) {
		if (toDo == "enable") {
			$("txtBudget").readOnly = false;
			$("txtIssCd").readOnly = false;
			$("txtLineCd").readOnly = false;
			enableSearch("imgIssLOV");
			enableSearch("imgLineLOV");
			enableButton("btnAdd");
		} else {
			$("txtBudget").readOnly = true;
			$("txtIssCd").readOnly = true;
			$("txtLineCd").readOnly = true;
			disableSearch("imgIssLOV");
			disableSearch("imgLineLOV");
			disableButton("btnAdd");
		}
	}

	function setFieldValues(rec) {
		try {
			$("txtIssCd").value 	 = (rec == null ? "" : rec.issCd);
			$("txtIssCd").setAttribute("lastValidValue", (rec == null ? "" : rec.issCd));
			$("txtIssName").value    = (rec == null ? "" : unescapeHTML2(rec.dspIssName));
			$("txtLineCd").value 	 = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lineCd));
			$("txtLineName").value 	 = (rec == null ? "" : unescapeHTML2(rec.dspLineName));
			$("txtBudget").value 	 = (rec == null ? "" : formatCurrency(rec.budget));
			$("txtUserId").value 	 = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			if (rowIndexYear != -1) {
				rec == null ? $("txtIssCd").readOnly = false : $("txtIssCd").readOnly = true;
				rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
				rec == null ? enableSearch("imgIssLOV") : disableSearch("imgIssLOV");
				rec == null ? enableSearch("imgLineLOV") : disableSearch("imgLineLOV");
				rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
				rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			}
			objCurrBudget = rec;
		} catch (e) {
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setYearFieldValues(rec) {
		try {
			$("txtYear").value 	= (rec == null ? "" : rec.year);
			$("txtMonth").value = (rec == null ? "" : unescapeHTML2(rec.month));
			
			rec == null ? enableDisableFields("disable") : enableDisableFields("enable");
			objCurrBudgetYear = rec;
		} catch (e) {
			showErrorMessage("setYearFieldValues", e);
		}
	}

	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.year   		= $F("txtYear");
			obj.month 		= $F("txtMonth");
			obj.issCd		= escapeHTML2($F("txtIssCd"));
			obj.dspIssName	= escapeHTML2($F("txtIssName"));
			obj.lineCd	    = escapeHTML2($F("txtLineCd"));
			obj.dspLineName	= escapeHTML2($F("txtLineName"));
			obj.budget		= $F("txtBudget");
			obj.userId 		= userId;
			var lastUpdate 	= new Date();
			obj.lastUpdate 	= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addYearRec(){
		try {
			changeTagFunc = valSaveRec;
			var rec = setRec(objCurrBudgetYear);
			tbgBudgetYear.addBottomRow(rec);
			changeTag = 1;
			setFieldValues(null);
			tbgBudgetYear.selectRow(tbgBudgetYear.geniisysRows.length-1);	
			setYearFieldValues(rec);
			disableInputField("txtYear");
			disableInputField("txtMonth");
			disableSearch("imgMonthLOV");
			disableButton("btnAddYearMonth");
		} catch(e){
			showErrorMessage("addYearRec", e);
		}
	}		

	function valAddYearRec(){
		try{
			if(checkAllRequiredFieldsInDiv("budgetYearFormDiv")){
				if($F("btnAddYearMonth") == "Add") {
					var addedSameExists = false;
				
					for(var i=0; i<tbgBudgetYear.geniisysRows.length; i++){
						if(tbgBudgetYear.geniisysRows[i].recordStatus == 0 || tbgBudgetYear.geniisysRows[i].recordStatus == 1){								
							if(tbgBudgetYear.geniisysRows[i].year == $F("txtYear") && tbgBudgetYear.geniisysRows[i].month == $F("txtMonth")){
								addedSameExists = true;								
							}							
						}
					}
				
					if((addedSameExists)){
						showMessageBox("Record already exists with the same year and month.", "E");
						return;
					}
					new Ajax.Request(contextPath + "/GIACProdBudgetController", {
						parameters : {action : "valAddYearRec",
									    year : $F("txtYear"),
									   month : $F("txtMonth")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addYearRec();
							}
						}
					});
				} else {
					addYearRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddYearRec", e);
		}
	}		
	
	function addRec(){
		try {
			changeTagFunc = valSaveRec;
			var rec = setRec(objCurrBudget);
			if($F("btnAdd") == "Add"){
				tbgBudget.addBottomRow(rec);
			} else {
				tbgBudget.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBudget.keys.removeFocus(tbgBudget.keys._nCurrentFocus, true);
			tbgBudget.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		

	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("budgetFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgBudget.geniisysRows.length; i++){
						if(tbgBudget.geniisysRows[i].recordStatus == 0 || tbgBudget.geniisysRows[i].recordStatus == 1){								
							if(tbgBudget.geniisysRows[i].issCd == $F("txtIssCd") && tbgBudget.geniisysRows[i].lineCd == $F("txtLineCd") 
									&& tbgBudget.geniisysRows[i].year == $F("txtYear") && tbgBudget.geniisysRows[i].month == $F("txtMonth")){
								addedSameExists = true;								
							}							
						} else if(tbgBudget.geniisysRows[i].recordStatus == -1){
							if(tbgBudget.geniisysRows[i].issCd == $F("txtIssCd") && tbgBudget.geniisysRows[i].lineCd == $F("txtLineCd") 
									&& tbgBudget.geniisysRows[i].year == $F("txtYear") && tbgBudget.geniisysRows[i].month == $F("txtMonth")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same year, month, iss_cd, and line_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACProdBudgetController", {
						parameters : {action : "valAddRec",
									    year : $F("txtYear"),
									   month : $F("txtMonth"),
									   issCd : $F("txtIssCd"),
									  lineCd : $F("txtLineCd")},
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
		changeTagFunc = valSaveRec;
		objCurrBudget.recordStatus = -1;
		tbgBudget.deleteRow(rowIndex);
		tbgBudget.geniisysRows[rowIndex].issCd = escapeHTML2($F("txtIssCd"));
		tbgBudget.geniisysRows[rowIndex].lineCd = escapeHTML2($F("txtLineCd"));
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		deleteRec();
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}

	function cancelGiacs360() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIACS360.exitPage = exitPage;
				valSaveRec();
			}, function() {
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}

	function showMonthLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtMonth").trim() == "" ? "%" : $F("txtMonth"));
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs360MonthLOV",
					search : search + "%",
					page: 1
				},
				title : "List of Months",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "month",
					title : "Month",
					width : '465px'
				}],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtMonth").value = row.month;
						$("txtMonth").setAttribute("lastValidValue", row.month);
					}
				},
				onCancel : function() {
					$("txtMonth").focus();
					$("txtMonth").value = $("txtMonth").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtMonth").value = $("txtMonth").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtMonth");
				}
			});
		} catch (e) {
			showErrorMessage("showMonthLOV", e);
		}
	}

	function showIssLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtIssCd").trim() == "" ? "%" : $F("txtIssCd"));

			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs360IssLOV",
					search : search + "%",
					page : 1
				},
				title : "List of Issuing Sources",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Issue Code",
					width : '120px'
				}, {
					id : "issName",
					title : "Issue Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssName").value = unescapeHTML2(row.issName);
						$("txtIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
						$("txtLineCd").value = "";
						$("txtLineCd").setAttribute("lastValidValue", "");
						$("txtLineName").value = "";
					}
				},
				onCancel : function() {
					$("txtIssCd").focus();
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
				}
			});
		} catch (e) {
			showErrorMessage("showIssLOV", e);
		}
	}

	function showLineLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));

			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs360LineLOV",
					 issCd : $F("txtIssCd"), 
					search : search + "%",
					page : 1
				},
				title : "List of Lines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					}
				},
				onCancel : function() {
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	}

	function toggleBudgetFields(enable) {
		try {
			if (enable) {
				$("txtYear").readOnly = true;
				$("txtMonth").readOnly = true;
				disableSearch("imgMonthLOV");
				disableButton("btnAddYearMonth");
			} else {
				$("txtYear").readOnly = false;
				$("txtMonth").readOnly = false;
				enableSearch("imgMonthLOV");
				enableButton("btnAddYearMonth");
			}
		} catch (e) {
			showErrorMessage("toggleBudgetFields", e);
		}
	}

	$("txtYear").observe("change", function() {

	});
	
	$("txtMonth").observe("keyup", function() {
		$("txtMonth").value = $F("txtMonth").toUpperCase();
	});

	$("imgMonthLOV").observe("click", function() {
		showMonthLOV(true);
	});

	$("txtMonth").observe("change", function() {
		if (this.value != "") {
			showMonthLOV(false);
		} else {
			$("txtMonth").value = "";
			$("txtMonth").setAttribute("lastValidValue", "");
		}
	});
	
	$("imgIssLOV").observe("click", function() {
		showIssLOV(true);
	});
	
	$("txtIssCd").observe("change", function() {
		if (this.value != "") {
			showIssLOV(false);
		} else {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "";
		}
	});
	
	$("txtIssCd").observe("keyup", function() {
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	$("imgLineLOV").observe("click", function() {
		showLineLOV(true);
	});
	
	$("txtLineCd").observe("change", function() {
		if (this.value != "") {
			showLineLOV(false);
		} else {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		}
	});
	
	$("txtLineCd").observe("keyup", function() {
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
// 	$("txtBudget").observe("change", function() {
// 		var fieldValue = parseInt($F("txtBudget").toString().replace(/\$|\,/g,'').strip());
// 		var max = 999999999999.99;
// 		var min = -999999999999.99;
// 		if (fieldValue < parseInt(min) && fieldValue != "") {
// 			customShowMessageBox("Invalid Budget. Valid value should be from "+ formatCurrency(min) + " to " + formatCurrency(max) + ".", imgMessage.INFO, "txtBudget");
// 			$("txtBudget").clear();
// 		}else if ($F("txtBudget") != "" && isNaN(fieldValue)) {
// 			customShowMessageBox("Invalid Budget. Valid value should be from "+ formatCurrency(min) + " to " + formatCurrency(max) + ".", imgMessage.INFO, "txtBudget");
// 			$("txtBudget").clear();
// 		}else if (fieldValue > parseInt	(max) && fieldValue != ""){
// 			customShowMessageBox("Invalid Budget. Valid value should be from "+ formatCurrency(min) + " to " + formatCurrency(max) + ".", imgMessage.INFO, "txtBudget");
// 			$("txtBudget").clear();
// 		}else{
// 			var returnValue = "";
// 			var amt;
// 			amt = (($F("txtBudget")).include(".") ? $F("txtBudget") : ($F("txtBudget")).concat(".00")).split(".");
		
// 			if(2 < amt[1].length){
// 				returnValue = amt[0] + "." + amt[1].substring(0, 2);
// 				customShowMessageBox("Invalid Budget. Valid value should be from "+ formatCurrency(min) + " to " + formatCurrency(max) + ".", imgMessage.INFO, "txtBudget");
// 				$("txtBudget").clear();
// 			}else{				
// 				returnValue = amt[0] + "." + rpad(amt[1], 2, "0");
// 				$("txtBudget").value = formatCurrency(returnValue);
// 			}
// 		} 
// 	});

	disableButton("btnDelete");

	observeSaveForm("btnSave", valSaveRec);
 	$("btnCancel").observe("click", cancelGiacs360);
	$("btnAddYearMonth").observe("click", valAddYearRec);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);

	$("txtYear").focus();
	
	toggleBudgetFields(false);
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	}); 
</script>