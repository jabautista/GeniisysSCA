<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="adjusterHistMainDiv" name="adjusterHistMainDiv">
	<div id="adjusterHistTableGridDiv" align="center" style="margin-top: 5px; width: 788px;">
		<div id="adjusterGridHistDiv" style="height: 86px; margin-top: 5px;" class="sectionDiv">
			<div id="adjusterHistTableGrid" style="height: 81px; width: 770px; margin-top: 5px;"></div>
		</div>
		<div style="margin-top: 5px;" class="sectionDiv">
			<div id="adjHistSubInfoDiv" style="margin-top: 10px;">
			</div>
			<div class="buttonsDiv" align="center" style="margin-bottom: 15px; margin-top: 50px;">
				<input type="button" id="btnExitAdjHist" name="btnExitAdjHist" style="width: 140px;" class="button hover"   value="Return" />
			</div>
		</div>	
	</div>	
</div>
<script type="text/javascript">
try{
	objCLM.adjHistListGrid = JSON.parse('${adjHistListGrid}'.replace(/\\/g, '\\\\'));
	objCLM.adjHistList = objCLM.adjHistListGrid.rows || [];
	
	var adjHistTableModel = {
			url: contextPath+"/GICLClmAdjHistController?action=showClmAdjHist&claimId=" + objCLMGlobal.claimId+"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				pager: {} 
			},
			columnModel : [
		   			{ 								// this column will only use for deletion
		   				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
		   				title: '&#160;D',
		   			 	altTitle: 'Delete?',
		   			 	titleAlign: 'center',
		   		 		width: 19,
		   		 		sortable: false,
		   			 	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
		   			  	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
		   			 	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
		   		 		editor: 'checkbox',
		   			 	hideSelectAllBox: true,
		   			 	visible: false 
		   			},
		   			{
		   				id: 'divCtrId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	}, 
					{
					    id: 'adjCompanyCd dspAdjCoName',
					    title: 'Adjusting Company',
					    width : 368,
					    children : [
				            {
				                id : 'adjCompanyCd',
				                width: 100
				            },
				            {
				                id : 'dspAdjCoName', 
				                width: 268
				            }
						]
					},
					{
					    id: 'privAdjCd dspPrivAdjName',
					    title: 'Adjuster',
					    width : 367,
					    children : [
				            {
				                id : 'privAdjCd',
				                width: 100
				            },
				            {
				                id : 'dspPrivAdjName', 
				                width: 267
				            }
						]
					},
					{
					    id: 'claimId',
					    title: '',
					    width: '0',
					    visible: false
					 }
				],
			resetChangeTag: true,
			requiredColumns: '',
			rows : objCLM.adjHistList,
			id: 2
		};  
	
	adjHistTableGrid = new MyTableGrid(adjHistTableModel);
	adjHistTableGrid.pager = objCLM.adjHistListGrid;
	adjHistTableGrid.afterRender = function(){
		if (adjHistTableGrid.rows.length > 0){
			new Ajax.Updater("adjHistSubInfoDiv", contextPath+"/GICLClmAdjHistController",{
				parameters:{
					action: "showClmAdjHistSubList",
					claimId: objCLMGlobal.claimId,
					adjCompanyCd: nvl(adjHistTableGrid.getValueAt(adjHistTableGrid.getColumnIndex('adjCompanyCd'), 0),""),
					privAdjCd: nvl(adjHistTableGrid.getValueAt(adjHistTableGrid.getColumnIndex('privAdjCd'), 0), "")
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					if (checkErrorOnResponse(response)) {
						null;
					}	
				}
			});
		}	
	};	
	adjHistTableGrid._mtgId = 2;
	adjHistTableGrid.render('adjusterHistTableGrid');
	
	$("btnExitAdjHist").observe("click", function(){
		Windows.close("clm_adj_hist_view");	
	});
	
}catch(e){
	showErrorMessage("Claim Adjuster History Page", e);
}	
</script>