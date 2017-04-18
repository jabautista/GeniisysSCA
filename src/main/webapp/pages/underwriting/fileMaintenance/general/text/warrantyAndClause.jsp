<!-- 
Remarks  : Warranty and Clause
Date     : 10.16.2012
Developer: Gzelle 
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="warrantyAndClauseMainDiv" name="warrantyAndClauseMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="warrantyAndClauseExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="warrantyAndClauseDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Warranties And Clauses Maintenance </label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="warrantyAndClauseSectionDiv" >
			<div id="lineMaintenanceTableDiv" class= "sectionDiv" style="height: 245px;">
				<div id="lineMaintenanceTable" style="position:relative; left:275px;top:10px;" ></div>
			</div>
			<div id="warrantyAndClauseTableDiv" class= "sectionDiv" style="height: 470px; bottom: 10px; top: 10px;">
				<div id="warrClaMaintenanceTable" style="height: 245px; position:relative; left: 10px; top:10px; bottom: 10px;"></div>
					<jsp:include page="/pages/underwriting/fileMaintenance/general/text/subPages/warrantyAndClauseInfo.jsp"></jsp:include>
		 			<input type="hidden" id="lineCd" name="lineCd" />
		 	</div>
		</div>	
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%; top: 10px;">
		<input type="button" class="button" id="btnCancelWarrantyAndClause" name="btnCancelWarrantyAndClause" value="Cancel"/>
		<input type="button" class="button" id="btnSaveWarrantyAndClause" name="btnSaveWarrantyAndClause" value="Save"/>
	</div>
</div>

<script type="text/javascript">

	setModuleId("GIISS034");
	setDocumentTitle("Warranties And Clauses");
	initializeAccordion();
	displayValue();
	changeTag = 0;
	objLineMaintain = null;
	var objLineCd;
	
	try{
		var row = 0;
		var objWarrClaMain = [];
		var objLine = new Object();
		objLine.objLineListing = JSON.parse('${warrClaMaintenance}'.replace(/\\/g, '\\\\'));
		objLine.objLineMaintenance = objLine.objLineListing.rows || [];
		var lineMaintenanceTG = {
				url: contextPath+"/GIISWarrClaController?action=getGIISLine",
			options: {
				width: '399px',
				height: '200px',
				id: 1,
				onCellFocus: function(element, value, x, y, id){
					row = y;
 				    objLineMaintain = lineMaintenanceTableGrid.geniisysRows[y]; 
 				   	warrClaMaintenanceTableGrid.url = contextPath + "/GIISWarrClaController?action=getGIISWarrCla"
					 											  + "&lineCd="+objLineMaintain.lineCd;
 				    clearFields();
 				   	displayValue();
 				   	enableForm();
				},
				onRemoveRowFocus: function(){
					clearFields();
					refreshWarrCla();
					displayValue();
					disableForm();
	            },
	            beforeSort: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		clearFields();
                		displayValue();		
                	}
                },
                onSort: function(){
                	clearFields();
					refreshWarrCla();
					displayValue();
					disableForm();
                },
                prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	            		
                		clearFields();
    					refreshWarrCla();
    					displayValue();
    					disableForm();
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
				onRefresh: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		clearFields();
    					refreshWarrCla();
    					displayValue();
    					disableForm();
                	}
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		clearFields();
	    					refreshWarrCla();
	    					displayValue();
	    					disableForm();
	                	}
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
			    {   id: 'lineCd',
				    title: 'Line Code',
				    width: '100px',
				    visible: true,
				    filterOption: true,
				    sortable:true
				},
				{	id: 'lineName',
					title: 'Line Name',
					width: '271px',
					visible: true,
					filterOption: true,
					sortable:true
				}
				],
			rows: objLine.objLineMaintenance
		};
		
		lineMaintenanceTableGrid = new MyTableGrid(lineMaintenanceTG);
		lineMaintenanceTableGrid.pager = objLine.objLineListing;
		lineMaintenanceTableGrid.render('lineMaintenanceTable');
		lineMaintenanceTableGrid.afterRender = function(){
			objWarrClaMain = lineMaintenanceTableGrid.geniisysRows;
		}; 
		
	}catch (e) {
		showErrorMessage("Line Maintenance Table Grid", e);
	}

	//display current date and user on page load * last update for display only
	function displayValue() {
		$("lastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
		$("userId").value = "${PARAMETERS['USER'].userId}";
		$("printSw").checked = true;
	}
	
	//clearfields 
	function clearFields() {
		$("mainWcCd").value = ""; 				
		$("lineCd").value 	= "";			
		$("wcTitle").value 	= "";				
		$("wcSw").value 	= "";				
		$("printSw").checked = false;			
		$("wcText").value 	= "";				
		$("remarks").value 	= "";
		lineMaintenanceTableGrid.keys.releaseKeys();
		warrClaMaintenanceTableGrid.refresh();
	}
	
	function enableForm() {
		enableInputField("mainWcCd");
		enableInputField("wcTitle");
		$("wcSwDesc").disabled = false;
		$("printSw").disabled = false;
		$("chkActiveTag").disabled = false; //carlo 01-26-2017
		enableInputField("wcText");
		enableInputField("remarks"); 
		$("mainWcCd").focus();
	   	enableButton("btnAdd");
	}
	
	function disableForm() {
		disableInputField("mainWcCd");
		disableInputField("origWcCd");
		disableInputField("hidWcCd");
		disableInputField("wcTitle");
		$("wcSwDesc").disabled = true;
		$("printSw").disabled = true;
		disableInputField("wcText");
		disableInputField("remarks"); 
		disableButton("btnAdd");
	}
	
	//refresh warranty and clause tablegrid
	function refreshWarrCla() {
		warrClaMaintenanceTableGrid.url = contextPath+"/GIISWarrClaController?action=getGIISWarrCla";
		warrClaMaintenanceTableGrid._refreshList();
	}
	
	//button section - observer 
	observeReloadForm("reloadForm", showWarrantyAndClause);
	
</script>