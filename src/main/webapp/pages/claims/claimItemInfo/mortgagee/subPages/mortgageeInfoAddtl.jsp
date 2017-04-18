<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mortgageeInfoGrid" style="position: relative; height: 206px; margin: auto; margin-top: 10px; margin-bottom: 10px; width: 641px;"> </div>

<script type="text/javascript">
try{
	objCLMItem.objMortgageeTableGrid = JSON.parse('${giclMortgagee}'.replace(/\\/g, '\\\\'));
	objCLMItem.objGiclMortgagee = objCLMItem.objMortgageeTableGrid.rows;
	objCLMItem.objGiclMortgagee.length > 5 ? $("mortgageeInfoGrid").setStyle("height: 331px") :$("mortgageeInfoGrid").setStyle("height: 206px");
	
	mortgageeModel = {
		url: contextPath+"/GICLMortgageeController?action=getMortgageeGrid&claimId="+objCLMGlobal.claimId+"&itemNo="+$F("txtItemNo"),
		options : {
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
					
			},
			onCellBlur : function(element, value, x, y, id) {
					
			},
			onRemoveRowFocus: function() {
			},
			toolbar: {
				
			}
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
			   	id: 'claimId',
			   	width: '0',
			   	visible: false 
			},
			{
			   	id: 'itemNo',
			   	width: '0',
			   	visible: false 
			},
		 	{
				id: 'userId',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'lastUpdate',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'issCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
			   	id: 'mortgCd',
			   	title: 'Code',
			  	width: 100
			},
			{
			   	id: 'nbtMortgNm',
			   	title: 'Mortgagee',
			  	width: 300
			},
			{
			   	id: 'amount',
			   	title: 'Amount',
			   	type : 'number',
			  	width: 200,
			  	geniisysClass : 'money'
			}
		],
		resetChangeTag: true,
		requiredColumns: '',
		rows : objCLMItem.objGiclMortgagee,
		id: 30
	};   
	
	mortgageeGrid = new MyTableGrid(mortgageeModel);
	mortgageeGrid.pager = objCLMItem.objMortgageeTableGrid;
	mortgageeGrid._mtgId = 30;
	mortgageeGrid.render('mortgageeInfoGrid');
	
	$("groMortgagee").show();
	$("loadMortgagee").hide();
}catch(e){
	showErrorMessage("Claims item mortgagee info", e);		
}
</script>