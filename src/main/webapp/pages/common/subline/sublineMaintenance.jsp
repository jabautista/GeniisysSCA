<!-- 
Remarks  : Subline Maintenance TableGrid
Date     : 09.26.2012
Developer: Irene 
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="sublineMaintenanceMainDiv" name="sublineMaintenanceMainDiv" style="float: left; width: 100%;">
	<div id="sublineMaintenanceTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="sublineMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="sublineMaintenanceDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Subline Maintenance</label>
				<span class="refreshers" style="padding-top: 0;">
					<label name="gro" style="padding-left: 5px;">Hide</label> 
					<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="sublineMaintenance" style="height: 759px;"><!--modified by apollo, 05.20.2015 - sr#4245  -->
			<div class="sectionDiv" id="lineSectionDiv" style="height: 245px;">
				<div id="lineTableDiv" style="margin-left: 240px; margin-top: 10px;" >
					<div id="lineMaintenanceTable" padding-top: 10px;></div>
				</div>
			</div>	
			<div class="sectionDiv" id="sublineSectionDiv" style="height: 510px;"><!--modified by apollo, 05.20.2015 - sr#4245  -->
				<jsp:include page="/pages/common/subline/subpages/sublineMaintenanceInfo.jsp"></jsp:include>
			</div>
		</div>
	</div>
	<div class="buttonsDiv" align="center" style="padding-left: 6px;">
		<input type="button" class="button" id="btnCancelSubline" name="btnCancelSubline" value="Cancel"/>
		<input type="button" class="button" id="btnSaveSubline" name="btnSaveSubline" value="Save"/>
	</div>	
</div>
	
<script type="text/javascript">
	setModuleId("GIISS002");
	setDocumentTitle("Subline Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	changeTag = 0;
	var objLineMaintain = null;
	objUW.hideGIIS002= {};
	hasChangesInSubline = new Object();
 	disableButton("btnAddSubline");
 	disableButton("btnDeleteSubline");
 	
	try{
		
		var row = 0;
		var objSublineMain = [];
	   
		var objLine = new Object();
		objLine.objLineListing = JSON.parse('${sublineMaintenance}'.replace(/\\/g, '\\\\'));
		objLine.objLineMaintenance = objLine.objLineListing.rows || [];
		
		var lineMaintenanceTG = {
			url: contextPath+"/GIISSublineController?action=getSublineMaintenance",
			options: {
				width: '460px',
				height: '200px',	
				onCellFocus: function(element, value, x, y, id){
					row = y;
				    objLineMaintain = lineMaintenanceTableGrid.geniisysRows[y];
				    sublineMaintenanceTableGrid.url = contextPath+"/GIISSublineController?action=getSublineLov" + "&lineCd="+objLineMaintain.lineCd;
				    lineMaintenanceTableGrid.keys.releaseKeys();
				    enableButton("btnAddSubline");
				    enableFields(false);
				    sublineMaintenanceTableGrid.refreshURL(sublineMaintenanceTableGrid);
				    sublineMaintenanceTableGrid.refresh();
				    if (changeTag == 1){
						return false;
                	} else {
                		objUW.hideGIIS002.lineCd = objLineMaintain.lineCd;
                		sublineMaintenanceTableGrid.refreshURL(sublineMaintenanceTableGrid);
     				    sublineMaintenanceTableGrid._refreshList();
                	}
				},
				onRemoveRowFocus: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		objLineMaintain = null;
	   					objUW.hideGIIS002.lineCd = null;
	   					sublineMaintenanceTableGrid.url = contextPath+"/GIISSublineController?action=getSublineLov";
	   					sublineMaintenanceTableGrid.refreshURL(sublineMaintenanceTableGrid);
	   					sublineMaintenanceTableGrid.refresh();
	   					disableButton("btnAddSubline");
	   					enableFields(true);
	   					lineMaintenanceTableGrid.keys.releaseKeys();
                	}
	            },
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}else{
	            		lineMaintenanceTableGrid.onRemoveRowFocus();
	            	}
                },
                onSort: function(){
                	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}else{
	            		lineMaintenanceTableGrid.onRemoveRowFocus();
	            	}
                },
                prePager : function(){
                	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}else{
	            		lineMaintenanceTableGrid.onRemoveRowFocus();
	            	}
				},
				onRefresh: function(){
					if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
	            	}else{
	            		lineMaintenanceTableGrid.onRemoveRowFocus();
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
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						if(changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
		            	}else{
		            		lineMaintenanceTableGrid.onRemoveRowFocus();
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
				    width: '98px',
				    filterOption: true
				},
				{	id: 'lineName',
					title: 'Line Name',
					width: '335px',
					filterOption: true
				}
				],
			rows: objLine.objLineMaintenance
		};
		
		lineMaintenanceTableGrid = new MyTableGrid(lineMaintenanceTG);
		lineMaintenanceTableGrid.pager = objLine.objLineListing;
		lineMaintenanceTableGrid.render('lineMaintenanceTable');
		lineMaintenanceTableGrid.afterRender = function(){
			objSublineMain = lineMaintenanceTableGrid.geniisysRows;
			changeTag = 0;
		};
		
	}catch (e) {
		showErrorMessage("Subline Management Table Grid", e);
	}
	
	function enableFields(enable) {
	   	$("txtSublineCd").readOnly = enable;
	   	$("txtSublineName").readOnly = enable;
	    $("txtAccountCode").readOnly = enable;
	    $("txtMinPremAmt").readOnly = enable;
	   	$("txtSublineTime").readOnly = enable;
	   	$("txtRemarks").readOnly = enable;
		$("chkOpenPolDtl").disabled = enable;
		$("chkOpenPol").disabled = enable;
		$("chkPirntTag").disabled = enable;
		$("chkEndOfDay").disabled = enable;
		$("chkNoTax").disabled = enable;
		$("chkExclude").disabled = enable;
		$("chkProfCommTag").disabled = enable;
		$("chkNonRenewal").disabled	= enable;
		$("chkEDSTSw").disabled	= enable;
		$("chkEnrolleeTag").disabled	= enable;
		$("chkMicroSw").disabled	= enable; //added by apollo, 05.20.2015 - sr#4245
	}
	
	enableFields(true);
</script>