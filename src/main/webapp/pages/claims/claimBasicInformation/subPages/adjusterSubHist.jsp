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
<div id="adjusterSubHistTableGrid" style="height: 181px; width: 770px; margin-top: 5px;"></div>
<script type="text/javascript">
try{
	objCLM.adjSubHistListGrid = JSON.parse('${adjHistSubListGrid}'.replace(/\\/g, '\\\\'));
	objCLM.adjSubHistList = objCLM.adjSubHistListGrid.rows || [];
	
	var adjSubHistTableModel = {
			url: contextPath+"/GICLClmAdjHistController?action=showClmAdjHistSubList&claimId=" + objCLMGlobal.claimId+"&refresh=1"+
					"&adjCompanyCd="+nvl(adjHistTableGrid.getValueAt(adjHistTableGrid.getColumnIndex('adjCompanyCd'), 0),"")+
					"&privAdjCd="+nvl(adjHistTableGrid.getValueAt(adjHistTableGrid.getColumnIndex('privAdjCd'), 0), ""),
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
						id: 'strAssignDate',
						title: 'Date Assigned',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'strCompltDate',
						title: 'Date Completed',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'strCancelDate',
						title: 'Date Cancelled',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'strDeleteDate',
						title: 'Date Deleted',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'userId',
						title: 'User Id',
						width: '120px',
						sortable: true, 
						visible: true
					},
					{
						id: 'strLastUpdate',
						title: 'Last Update',
						width: '131px',
						sortable: true,
						align: 'left',
						visible: true
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
			rows : objCLM.adjSubHistList,
			id: 3
		};  
	
	adjSubHistTableGrid = new MyTableGrid(adjSubHistTableModel);
	adjSubHistTableGrid.pager = objCLM.adjSubHistListGrid;
	adjSubHistTableGrid._mtgId = 3;
	adjSubHistTableGrid.render('adjusterSubHistTableGrid');
	
	hideNotice("");
}catch(e){
	showErrorMessage("Claim Adjuster Sub History Page", e);
}	
</script>