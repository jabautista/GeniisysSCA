<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs510MainDiv" name="giacs510MainDiv" style="height: 920px;">
    <div id="toolbarDiv" name="toolbarDiv">
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/print.png) left center no-repeat;" id="btnToolbarPrint">Print</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/printDisabled.png) left center no-repeat;" id="btnToolbarPrintDisabled">Print</span>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Subsidiary of Expenses</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs510" name="giacs510">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="budgetYearListTable" style="height: 230px;margin-left:200px;width:700px;"></div>
			</div>
			<div>
				<div align="center" id="budgetYearFormDiv">
					<table>
						<tr>
							<td align="rightAligned">Budget for the Year</td>	
							<td class="leftAligned">
								<input id="txtYear" name="txtYear" class="required" type="text"  tabindex="201" maxlength="4" style="width: 150px; text-align: right;">
							</td>
						</tr>
					</table>
				</div>
				<div style="margin: 10px;">
					<input type="button" class="button" id="btnAddYear" value="Add" tabindex="202">
				</div>
			</div>	
		</div>
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="budgetPerYearListTable" style="height: 331px;width:900px;"></div>
			</div>
			<div align="left" id="detailsCopyBudgetButDiv" style="width: 20%; padding-left: 10px; float: left;">
				<table>
					<tr>
						<td>
							<input type="button" class="button" id="btnDetails" value="Details" style="width: 100px;" tabindex="203">
						</td>
					</tr>
					<tr>
						<td>
							<input type="button" class="button" id="btnCopyBudget" value="Copy Budget" style="width: 100px;" tabindex="204">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" id="glAccountDetailsFormDiv" style="width: 57%; float: left;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">GL Account No</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGlAcctCat"  type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="1" style="width: 20px; padding-right: 3px;" tabindex="205"> 
							<input id="txtGlControlAcct" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="206" > 
							<input id="txtGlSubAcct1" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="207" > 
							<input id="txtGlSubAcct2" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="208" > 
							<input id="txtGlSubAcct3" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="209" > 
							<input id="txtGlSubAcct4" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="210" > 
							<input id="txtGlSubAcct5" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="211" > 
							<input id="txtGlSubAcct6" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="212" > 
							<input id="txtGlSubAcct7" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="213">	
							<img id="searchGLAcctLOV" alt="GL Account No" style="height: 17px; cursor: pointer;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">GL Account Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGlAcctName" type="text" readonly="readonly" style="width: 387px;" tabindex="214" maxlength="100">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Budget</td>
						<td class="leftAligned" colspan="3">
							<input class="money2" id="txtBudget" type="text" style="width: 147px; text-align: right;" tabindex="215" maxlength="100">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 392px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 350px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="216"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="217"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 147px;" readonly="readonly" tabindex="218"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 151px;" readonly="readonly" tabindex="219"></td>
					</tr>
					<tr>
						<td colspan="4" style="padding-top: 10px; padding-bottom: 10px; padding-left: 188px;">
							<input type="button" class="button" id="btnAdd" value="Add" tabindex="220">
							<input type="button" class="button" id="btnDelete" value="Delete" tabindex="221">
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="222">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="223">
</div>
<script type="text/javascript">
	setModuleId("GIACS510");
	setDocumentTitle("Subsidiary Of Expenses");
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	changeTag = 0;
	var glAcctId;
	var glAcctIdAdd;
	var rowYearIndex = -1;
	var rowBudgetPerYearIndex = -1;
	var onSelect = "N";
	
	var objGIACS510YearList = {};
	var objCurrYear = null;
	objGIACS510YearList.yearList = JSON.parse('${jsonGiacBudgetYearList}');
	
	var yearListTable = {
			url : contextPath + "/GIACBudgetController?action=showGiacs510&refresh=1",
			options : {
				width : '500px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							
						});
						return false;
					} else {
						rowYearIndex = y;
						objCurrYear = tbgYearList.geniisysRows[y];
						setYearFieldValues(objCurrYear);
						setBudgetForYear(objCurrYear);
						disableButton("btnCopyBudget");
					}
				},
				onRemoveRowFocus : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							
						});
						return false;
					} else {
						rowYearIndex = -1;
						setYearFieldValues(null);
						setBudgetForYear(null);
						tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
						tbgYearList.keys.releaseKeys();
						enableButton("btnCopyBudget");
					}
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						if(changeTag == 1){
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								
							});
							return false;
						} else {
							rowYearIndex = -1;
							setYearFieldValues(null);
							setBudgetForYear(null);
							tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
							tbgYearList.keys.releaseKeys();
						}
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							
						});
						return false;
					} else {
						rowYearIndex = -1;
						setYearFieldValues(null);
						setBudgetForYear(null);
						tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
						tbgYearList.keys.releaseKeys();
					}
				},
				onSort: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							
						});
						return false;
					} else {
						rowYearIndex = -1;
						setYearFieldValues(null);
						setBudgetForYear(null);
						tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
						tbgYearList.keys.releaseKeys();
					}
				},
				onRefresh: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							
						});
						return false;
					} else {
						rowYearIndex = -1;
						setYearFieldValues(null);
						setBudgetForYear(null);
						tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
						tbgYearList.keys.releaseKeys();
					}
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							
						});
						return false;
					} else {
						rowYearIndex = -1;
						setYearFieldValues(null);
						setBudgetForYear(null);
						tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
						tbgYearList.keys.releaseKeys();
					}
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
						id : "year",
						title : "Year",
						filterOption : true,
						filterOptionType: 'integerNoNegative',
						width : '490px',
						titleAlign : "right",
						align : "right"
					}
			],
			rows : objGIACS510YearList.yearList.rows
	};
	tbgYearList = new MyTableGrid(yearListTable);
	tbgYearList.pager = objGIACS510YearList.yearList;
	tbgYearList.render("budgetYearListTable");
	
	var objBudgetPerYearList = {};
	var objCurrBudgetPerYear = null;
	objBudgetPerYearList.budgetPerYearList = JSON.parse('${jsonGiacBudgetPerYearList}');
	
	var budgetPerYearTable = {
			url : contextPath + "/GIACBudgetController?action=showBudgetPerYear&refresh=1",
			options : {
				width : '900px',
				pager : {},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter: function(){	
						if(changeTag==0){
							rowBudgetPerYearIndex = -1;
							setBudgetPerYearFieldValues(null);
							enableButton("btnAdd");
							tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
							tbgBudgetPerYear.keys.releaseKeys();
							disableButton("btnDetails");
						}else{
							showMessageBox("Please save changes first.", imgMessage.INFO);	
							return false;
						}		
					}					
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
				},
				prePager : function(element, value, x, y, id) {
					if(changeTag==0){
						rowBudgetPerYearIndex = -1;
						setBudgetPerYearFieldValues(null);
						tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
						tbgBudgetPerYear.keys.releaseKeys();
						disableButton("btnDetails");
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}								
				},
				onCellFocus : function(element, value, x, y, id) {						
					rowBudgetPerYearIndex = y;
					objCurrBudgetPerYear = tbgBudgetPerYear.geniisysRows[y];
					setBudgetPerYearFieldValues(objCurrBudgetPerYear);
					enableButton("btnDetails");
				},
				onRemoveRowFocus : function(element, value, x, y, id) {				
					rowBudgetPerYearIndex = -1;
					setBudgetPerYearFieldValues(null);
					tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
					tbgBudgetPerYear.keys.releaseKeys();
					disableButton("btnDetails");
				},
				beforeSort : function() {			
					if(changeTag==0){
						rowBudgetPerYearIndex = -1;
						setBudgetPerYearFieldValues(null);
						tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
						tbgBudgetPerYear.keys.releaseKeys();
						disableButton("btnDetails");
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}					
				},
				onSort : function() {				
					if(changeTag==0){
						rowBudgetPerYearIndex = -1;
						setBudgetPerYearFieldValues(null);
						tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
						tbgBudgetPerYear.keys.releaseKeys();	
						disableButton("btnDetails");
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}			
				},
				onRefresh : function() {				
					if(changeTag==0){
						rowBudgetPerYearIndex = -1;
						setBudgetPerYearFieldValues(null);
						tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
						tbgBudgetPerYear.keys.releaseKeys();	
						disableButton("btnDetails");
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}			
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
					id : 'glAccountNo',
					filterOption : true,
					title : 'GL Account No',
					width : '230px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{
					id : 'glAcctName',
					filterOption : true,
					title : 'GL Account Name',
					width : '520px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{
					id : "budget",
					title : "Budget",
					titleAlign : 'right',
					width : '130px',
					geniisysClass: 'money',
					align : 'right',
				},
				{   id: 'year',
				    width: '0px',
				    visible: false
				},
				{   id: 'glAcctId',
				    width: '0px',
				    visible: false
				},
				{   id: 'budget',
				    width: '0px',
				    visible: false
				},
				{   id: 'remarks',
				    width: '0px',
				    visible: false
				}
			],
			rows : objBudgetPerYearList.budgetPerYearList.rows
	};
	tbgBudgetPerYear = new MyTableGrid(budgetPerYearTable);
	tbgBudgetPerYear.pager = objBudgetPerYearList.budgetPerYearList;
	tbgBudgetPerYear.render("budgetPerYearListTable");
	
	function setYearFieldValues(rec){
		try{
			$("txtYear").value = (rec == null ? "" : rec.year);
			onSelect = (rec == null ? "N" : "Y");
			rec == null ? $("txtYear").readOnly = false : $("txtYear").readOnly = true;
			objCurrYear = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setBudgetForYear(obj) {
		var year;
		year = obj == null? "": (obj.year == null ? "" : obj.year);			
		tbgBudgetPerYear.url = contextPath
				+ "/GIACBudgetController?action=showBudgetPerYear&refresh=1&year="
				+ year;
		tbgBudgetPerYear._refreshList();
	}
	
	function setBudgetPerYearFieldValues(rec){
		try{
			$("txtGlAcctCat").value = (rec == null ? "" : rec.glAcctCategory);
			$("txtGlControlAcct").value = (rec == null ? "" : formatNumberDigits(rec.glControlAcct, 2));
			$("txtGlSubAcct1").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct1, 2));
			$("txtGlSubAcct2").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct2, 2));
			$("txtGlSubAcct3").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct3, 2));
			$("txtGlSubAcct4").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct4, 2));
			$("txtGlSubAcct5").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct5, 2));
			$("txtGlSubAcct6").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct6, 2));
			$("txtGlSubAcct7").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct7, 2));
			$("txtGlAcctName").value = (rec == null ? "" : rec.glAcctName);
			$("txtBudget").value = (rec == null ? "" : formatCurrency(rec.budget));
			$("txtRemarks").value = (rec == null ? "" : rec.remarks);
			$("txtUserId").value = (rec == null ? "" : rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			glAcctId = (rec == null ? "" : rec.glAcctId);
			
			rec == null ? $("txtGlAcctCat").readOnly = false : $("txtGlAcctCat").readOnly = true;
			rec == null ? $("txtGlControlAcct").readOnly = false : $("txtGlControlAcct").readOnly = true;
			rec == null ? $("txtGlSubAcct1").readOnly = false : $("txtGlSubAcct1").readOnly = true;
			rec == null ? $("txtGlSubAcct2").readOnly = false : $("txtGlSubAcct2").readOnly = true;
			rec == null ? $("txtGlSubAcct3").readOnly = false : $("txtGlSubAcct3").readOnly = true;
			rec == null ? $("txtGlSubAcct4").readOnly = false : $("txtGlSubAcct4").readOnly = true;
			rec == null ? $("txtGlSubAcct5").readOnly = false : $("txtGlSubAcct5").readOnly = true;
			rec == null ? $("txtGlSubAcct6").readOnly = false : $("txtGlSubAcct6").readOnly = true;
			rec == null ? $("txtGlSubAcct7").readOnly = false : $("txtGlSubAcct7").readOnly = true;
			//rec == null ? $("txtBudget").readOnly = true : $("txtBudget").readOnly = false;
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrBudgetPerYear = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	/* Functions related to adding a year.*/
	function addGiacBudgetYear(){
		try {
			if(checkAllRequiredFieldsInDiv("budgetYearFormDiv")){
				validateYear("Add");
			}
		} catch(e){
			showErrorMessage("addGiacBudgetYear", e);
		}
	}
	
	function setBudgetYear(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.year = $F("txtYear");
			
			return obj;
		} catch(e){
			showErrorMessage("setBudgetYear", e);
		}
	}
	
	function validateYear(action){
		try{
			new Ajax.Request(contextPath + "/GIACBudgetController", {
				parameters : {action : "valAddBudgetYear",
					  	      year : $F("txtYear")},
				onCreate : showNotice("Validating year, please wait..."),
				onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(action == "Add"){
						var year = setBudgetYear(objCurrYear);
						tbgYearList.addBottomRow(year);
						showConfirmBox("Add Entry", "Do you want to copy informations from existing year?","Yes","No", 
						   function(){
							copyBudgetPushed();
						}, function(){
							$("txtYear").value = "";
							return false;
						});
					} else if(action == "Copy"){
						copyBudgetPushed();	
					}
				}
		}
			});
		} catch(e){
			showErrorMessage("validateYear", e);
		}
	}
	
	function copyBudgetPushed(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					 action   : "copyBudgetPushedLovYear",
					 page : 1
				},
				title: "List of Years",
				width: 400,
				height: 380,
				columnModel: [
					{
						id : 'year',
						title: 'Year',
						width : '385px',
						align: 'right',
						titleAlign : "right",
					}
				],
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						copyBudgetProceed(row.year);
					}
				}
			});
		}catch(e){
			showErrorMessage("copyBudgetPushed",e);
		}
	}
	
	function copyBudgetProceed(paramYear){
		try{
			new Ajax.Request(contextPath+"/GIACBudgetController", {
				method: "POST",
				parameters : {action       : "copyBudget",
				 	          copiedYear   : paramYear,
				 	          year         : $F("txtYear")
				 	          
				},
				onCreate : showNotice("Copying budget, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						tbgYearList._refreshList();
						setYearFieldValues(null);
						tbgYearList.keys.removeFocus(tbgYearList.keys._nCurrentFocus, true);
						tbgYearList.keys.releaseKeys();
					}
				}
			});
		} catch(e){
			showErrorMessage("copyBudgetProceed",e);
		}
	}
	/* End of functions related to adding a year. */
	
	function showGLAcctLOV(table, year){
		try {
			giacBudgetLOVOVerlay = Overlay.show(contextPath+"/GIACBudgetController", {
				urlContent: true,
				urlParameters: {action    : "showGLAcctLOV",																
								ajax      : "1",
								table     : table,
								year      : year,
								glAcctCat : $F("txtGlAcctCat"),
								glAcctControlAcct : $F("txtGlControlAcct"),
								glSubAcct1 : $F("txtGlSubAcct1"),
								glSubAcct2 : $F("txtGlSubAcct2"),
								glSubAcct3 : $F("txtGlSubAcct3"),
								glSubAcct4 : $F("txtGlSubAcct4"),
								glSubAcct5 : $F("txtGlSubAcct5"),
								glSubAcct6 : $F("txtGlSubAcct6"),
								glSubAcct7 : $F("txtGlSubAcct7")
				},
			    title: "Chart of Accounts",
			    height: 400,
			    width: 600,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("GIAC_BUDGET Overlay Error: " , e);
		}
	}
	
	$("searchGLAcctLOV").observe("click", function(){
		if(onSelect == "Y"){
			showGLAcctLOV("GIAC_BUDGET", $F("txtYear"));
		} else {
			showMessageBox("Required fields must be entered.", imgMessage.INFO);	
			return false;
		}
	});
	
	function showBudgetDtlOverlay(year, glAcctId, nbtGlAcctNameMaster){
		try {
			giacBudgetDtlOVerlay = Overlay.show(contextPath+"/GIACBudgetController", {
				urlContent: true,
				urlParameters: {action    : "showBudgetDtlOverlay",																
								ajax      : "1",
								year      : year,
								glAcctId  : glAcctId,
								nbtGlAcctNameMaster : nbtGlAcctNameMaster
				},
			    title: "Budget Detail",
			    height: 500,
			    width: 650,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("GIAC_BUDGET_DTL Overlay Error: " , e);
		}
	}
	
	$("btnDetails").observe("click", function(){
		showBudgetDtlOverlay($F("txtYear"), glAcctId, $F("txtGlAcctName"));
	});
	
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function saveGiacs510(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var budgetPerYear = getAddedAndModifiedJSONObjects(tbgBudgetPerYear.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBudgetPerYear.geniisysRows);
		new Ajax.Request(contextPath+"/GIACBudgetController", {
			method: "POST",
			parameters : {action : "saveGiacs510",
					 	  setRows : prepareJsonAsParameter(budgetPerYear),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					changeTag = 0;
					tbgBudgetPerYear._refreshList();
					showGiacs510();
				}
			}
		});
	}
	
	function cancelGiacs510(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs510();
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function valDeleteBudgetPerYear(){
		try{
			new Ajax.Request(contextPath + "/GIACBudgetController", {
				parameters : {action   : "valDeleteBudgetPerYear",
					          glAcctId : glAcctId,
					          year     : $F("txtYear")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteGiacBudgetPerYear();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteBudgetPerYear", e);
		}
	}
	
	function deleteGiacBudgetPerYear(){
		objCurrBudgetPerYear.recordStatus = -1;
		tbgBudgetPerYear.deleteRow(rowBudgetPerYearIndex);
		changeTag = 1;
		setBudgetPerYearFieldValues(null);
	}
	
	function setBudgetPerYearMain(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.year = $F("txtYear");
			obj.glAccountNo = $F("txtGlAcctCat") + "-" + formatNumberDigits($F("txtGlControlAcct"), 2) + "-" +
							  formatNumberDigits($F("txtGlSubAcct1"), 2) + "-" + formatNumberDigits($F("txtGlSubAcct2"), 2) + "-" +
							  formatNumberDigits($F("txtGlSubAcct3"), 2) + "-" + formatNumberDigits($F("txtGlSubAcct4"), 2) + "-" +
							  formatNumberDigits($F("txtGlSubAcct5"), 2) + "-" + formatNumberDigits($F("txtGlSubAcct6"), 2) + "-" +
							  formatNumberDigits($F("txtGlSubAcct7"), 2);
			obj.glAcctId = obj.glAcctId == null ? glAcctIdAdd : obj.glAcctId;
			obj.glAcctName = $F("txtGlAcctName");
			obj.budget = $F("txtBudget");
			obj.remarks = $F("txtRemarks");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setBudgetPerYearMain", e);
		}
	}
	
	function addGiacBudgetPerYear(){
		try {
			if(checkAllRequiredFieldsInDiv("glAccountDetailsFormDiv")){
				var budgetPerYear = setBudgetPerYearMain(objCurrBudgetPerYear);
				if($F("btnAdd") == "Add"){
					tbgBudgetPerYear.addBottomRow(budgetPerYear);
				} else {
					tbgBudgetPerYear.updateVisibleRowOnly(budgetPerYear, rowBudgetPerYearIndex, false);
				}
				changeTag = 1;
				setBudgetPerYearFieldValues(null);
				tbgBudgetPerYear.keys.removeFocus(tbgBudgetPerYear.keys._nCurrentFocus, true);
				tbgBudgetPerYear.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addGiacBudgetPerYear", e);
		}
	}
	
	function whenValidateItemGL(year, elemName, formatDigitTo){
		if(onSelect == "N" && year != ""){
			showMessageBox("Year must be added and selected first.", imgMessage.INFO);
			elemName.value = "";
			return false;
		} else if(onSelect == "N" && year == ""){
			showMessageBox("Valid year must be selected.", imgMessage.INFO);
			elemName.value = "";
			return false;
		} else {
			if($F("txtGlAcctCat") != "" && $F("txtGlControlAcct") != "" && $F("txtGlSubAcct1") != "" &&
			   $F("txtGlSubAcct2") != "" && $F("txtGlSubAcct3") != "" && $F("txtGlSubAcct4") != "" && 
			   $F("txtGlSubAcct5") != "" && $F("txtGlSubAcct6") != "" && $F("txtGlSubAcct7") != ""){
				validateGLAcctNo(elemName, formatDigitTo);
			} else {
				elemName.value = formatNumberDigits(elemName.value,formatDigitTo);
			}
		}
	}
	
	$("txtGlAcctCat").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlAcctCat"), "1");
	});
	
	$("txtGlControlAcct").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlControlAcct"), "2");
	});
	
	$("txtGlSubAcct1").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct1"), "2");
	});
	
	$("txtGlSubAcct2").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct2"), "2");
	});
	
	$("txtGlSubAcct3").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct3"), "2");
	});
	
	$("txtGlSubAcct4").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct4"), "2");
	});
	
	$("txtGlSubAcct5").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct5"), "2");
	});
	
	$("txtGlSubAcct6").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct6"), "2");
	});
	
	$("txtGlSubAcct7").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtGlSubAcct7"), "2");
	});
	
	function validateGLAcctNo(elemName, formatDigitTo){
		new Ajax.Request(contextPath+"/GIACBudgetController?action=validateGLAcctNo",{
			parameters: {
				year : $F("txtYear"),
				table : "GIAC_BUDGET",
				glAcctCat : $F("txtGlAcctCat"),
				glAcctControlAcct : $F("txtGlControlAcct"),
				glSubAcct1 : $F("txtGlSubAcct1"),
				glSubAcct2 : $F("txtGlSubAcct2"),
				glSubAcct3 : $F("txtGlSubAcct3"),
				glSubAcct4 : $F("txtGlSubAcct4"),
				glSubAcct5 : $F("txtGlSubAcct5"),
				glSubAcct6 : $F("txtGlSubAcct6"),
				glSubAcct7 : $F("txtGlSubAcct7"),
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.exist == "N"){
						showMessageBox("Invalid GL Account No.", "E");
						elemName.value = "";
						glAcctIdAdd = "";
						return false;
					} else {
						elemName.value = formatNumberDigits(elemName.value, formatDigitTo);
						$("txtGlAcctName").value = res.glAcctName;
						glAcctIdAdd = res.glAcctId;
					}
				}
			}
		});
	}
	
	$("btnCopyBudget").observe("click", function(){
		try {
			if(checkAllRequiredFieldsInDiv("budgetYearFormDiv")){
				validateYear("Copy");
			}
		} catch(e){
			showErrorMessage("addGiacBudgetYear", e);
		}
	});
	
	$("btnToolbarPrint").observe("click", function(){
		if(onSelect == "N"){
			showMessageBox("Required fields must be entered.", imgMessage.INFO);	
			return false;
		}
		
		showGenericPrintDialog("Print Comparative Gen. & Admin. Expenses", onOkPrintGiacs510, onLoadPrintGiacs510, true);
	});
	
	var dateBasis = "1";
	var tranFlag = "D";
	function onLoadPrintGiacs510(){
		var content = "<div class='' id='rdoDiv'>" +
		               		"<table align = 'center' style='padding: 10px;'>" +
		               			"<tr>" +
		               				"<td>" +
		               					"<input type='radio' checked='checked' name='rdoTranPost' id='rdoTranPost' value='1' title='Transaction Date' style='float: left;'/>" +
		               					"<label for='rdoTranPost' style='float: left; height: 20px; padding-top: 3px;'>Based on Transaction Date</label>" +
		               				"</td>" +
		               			"</tr>" +
		               			"<tr>" +
	               					"<td>" +
	               						"<input type='radio' name='rdoTranPost' id='rdoTranPost' value='2' title='Posting Date' style='float: left;'/>" +
	               						"<label for='rdoTranPost' style='float: left; height: 20px; padding-top: 3px;'>Based on Date Posted</label>" +
	               					"</td>" +
	               				"</tr>" +
		               		"</table>" +
		               		"<table align = 'center' style='padding-bottom: 10px;'>" +
		               			"<tr>" +
       								"<td class='rightAligned'>" +
       									"<input type='checkbox' id='chkExcludeOpenTran' name='chkExcludeOpenTran'/>" +
       								"</td>" +
       								"<td class='leftAligned'>" +
       									"<label for='lblChkExcludeOpenTran' id='lblChkExcludeOpenTran'>&nbsp; Exclude Open Transactions</label>" +
   									"</td>" +
   									"<td style='padding-left: 5px;'>" +
   										"<input id='btnExtract' class='button' type='button' style='width: 80px;' value='Extract' name='btnExtract'>" +
									"</td>" +
       							"</tr>" + 
		               		"</table>" +
	                  "</div>";
		$("printDialogFormDiv3").update(content); 
		$("printDialogFormDiv3").show();
		$("printDialogMainDiv").up("div",1).style.height = "285px";
		$("printDialogMainDiv").style.width = "98.5%";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "317px";
		
		$("btnExtract").observe("click", checkExistBeforeExtractGiacs510);
		
		$$("input[name='rdoTranPost']").each(function(radio){
			radio.observe("click", function(){
				dateBasis = radio.value;
			});
		});
		
		$$("input[name='chkExcludeOpenTran']").each(function(radio){
			radio.observe("click", function(){
				if(radio.checked){
					tranFlag = 'O';
				} else {
					tranFlag = 'D';
				}
			});
		});
		
		disableButton("btnPrint");
	}
	
	function checkExistBeforeExtractGiacs510(){
		new Ajax.Request(contextPath+"/GIACBudgetController?action=checkExistBeforeExtractGiacs510",{
			parameters: {
				year : $F("txtYear")
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.exist == "Y"){
						showConfirmBox("Warning", "There are GL Accounts with no detail.", "View", "Continue", viewNoDtl, extractGiacs510, null);
					} else {
						extractGiacs510();
					}
				}
			}
		});
	}
	
	function extractGiacs510(){
		try {
			new Ajax.Request(contextPath+"/GIACBudgetController",{
				method: "POST",
				parameters : {action : "extractGiacs510",
							  year   : $F("txtYear"),
							  dateBasis : dateBasis,
							  tranFlag : tranFlag
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Extracting, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					var result = JSON.parse(response.responseText);
					if (checkErrorOnResponse(response)){
						if (result.exist == "0") {
							showMessageBox("No records extracted.","I");
						}else{
							showMessageBox("Extraction complete. ", imgMessage.SUCCESS);
						}
						enableButton("btnPrint");
					}
				}
			});
		} catch (e) {
			showErrorMessage("extractGiacs510",e);
		}
	}
	
	function viewNoDtl(){
		try {
			giacBudgetNoDtlOverlay = Overlay.show(contextPath+"/GIACBudgetController", {
				urlContent: true,
				urlParameters: {action    : "viewNoDtl",																
								ajax      : "1",
								year      : $F("txtYear"),
								dateBasis : dateBasis,
								tranFlag  : tranFlag
				},
			    title: "GL Account W/O Detail",
			    height: 400,
			    width: 600,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("GL accounts with no detail overlay error: " , e);
		}
	}
	
	var reports = [];
	function onOkPrintGiacs510(){
		var reportId = 'GIACR510';
		var reportTitle = 'COMPARATIVE GEN. COMPARATIVE GEN. & ADMIN. EXPENSES EXPENSES';
		
		var content;
		
		content = contextPath+"/GeneralLedgerPrintController?action=printReport&reportId=" + reportId 
				+ "&printerName=" + $F("selPrinter")
				+ "&year=" + $F("txtYear")
		        + "&dateBasis=" + dateBasis
		        + "&tranFlag=" + tranFlag
		        + "&reportTitle=" + reportTitle;
		
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : reportTitle});			
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
					
					}
				}
			});
		}else if($F("selDestination") == "file"){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						copyFileToLocal(response);
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
						}
					}
				}
			});
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}

	
	observeSaveForm("btnSave", saveGiacs510);
	$("btnAddYear").observe("click", addGiacBudgetYear);
	$("btnAdd").observe("click", addGiacBudgetPerYear);
	$("btnDelete").observe("click", valDeleteBudgetPerYear);
	$("btnCancel").observe("click", cancelGiacs510);
	observeReloadForm("reloadForm", showGiacs510);
	disableButton("btnDelete");
	disableButton("btnDetails");
	$("txtYear").focus();
</script>