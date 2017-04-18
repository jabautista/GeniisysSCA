<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="cancelledAdviceMainDiv" name="cancelledAdviceMainDiv" class="sectionDiv" style="border: none;">
	<div id="cancelledAdviceTableGridDiv" style="margin: 10px;">
		<div id="cancelledAdviceTableGrid" style="height: 181px; width: 500px;"></div>
	</div>
	<div align="center">
		<input type="button" class="button" id="cancelledAdviceReturn" name="cancelledAdviceReturn" value="Return" style="width:90px;">
	</div>
</div>

<script type="text/javascript">
try{
	var objCancelledAdviceTG = JSON.parse('${jsonCancelledAdvices}');
	var objCancelledAdvice = objCancelledAdviceTG.rows || []; 
	
	var cancelledAdviceTableModel = {
		id : 17,
		url : contextPath+"/GICLAdviceController?action=getCancelledAdviceList&claimId="+nvl(objCLMGlobal.claimId, 0),
		options:{
			title: '',
			pager: { },
			width: '510px',
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN]
			},
			onCellFocus: function(element, value, x, y, id){
				cancelledAdviceTableGrid.releaseKeys();
			},
			onRemoveRowFocus: function() {
				cancelledAdviceTableGrid.releaseKeys();
			},
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
			{	id: 'adviceNo',
				align: 'left',
			  	title: 'Advice Number',
			  	titleAlign: 'left',
			  	width: '178px',
			  	editable: false,
			  	sortable: true
			},
			{	id: 'userId',
				align: 'left',
			  	title: 'User ID',
			  	titleAlign: 'left',
			  	width: '120px',
			  	editable: false,
			  	sortable: true
			},
			{	id: 'lastUpdate',
				align: 'left',
			  	title: 'Last Update',
			  	titleAlign: 'left',
			  	type: 'date',
			  	format: 'mm-dd-yyyy hh:MM:ss TT',
			  	width: '200px',
			  	editable: false,
			  	sortable: true
			}
			
		],
		rows : objCancelledAdvice,
		requiredColumns: ''
	};
	cancelledAdviceTableGrid = new MyTableGrid(cancelledAdviceTableModel);
	cancelledAdviceTableGrid.pager = objCancelledAdviceTG;
	cancelledAdviceTableGrid.render('cancelledAdviceTableGrid');
	
}catch(e){
	showErrorMessage("Loss Expense Hist - List of Cancelled Advice", e);
}

$("cancelledAdviceReturn").observe("click", function(){
	lossExpHistWin.close();
});
</script>