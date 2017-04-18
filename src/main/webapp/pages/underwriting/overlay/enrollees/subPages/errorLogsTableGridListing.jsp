<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
	
<div id="errorLogTableGridSectionDiv" class="">
	<div id="errorLogTableGridDiv" style="padding: 10px;">
		<div id="errorLogTableGrid" style="height: 198px; width: 100%;"></div>
	</div>
</div>

<script type="text/javascript">
try{
	var objErrorLog = JSON.parse('${tgErrorLog}');
	var tbErrorLog = {
		url : contextPath + "/UploadEnrolleesController?action=viewErrorLogTG&refresh=1&fileName=" +$F("file"), 
		options : {
			width : '660px',
			page : {},
			onCellFocus : function(element, value, x, y, id){
				tbgErrorLog.keys.removeFocus(tbgErrorLog.keys._nCurrentFocus, true);
				tbgErrorLog.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				tbgErrorLog.keys.removeFocus(tbgErrorLog.keys._nCurrentFocus, true);
				tbgErrorLog.keys.releaseKeys();
			},
		},
		columnModel : [
			{
				id : 'recordStatus',
				width : '20px',
				editor : 'checkbox',
				visible : false
			},
			{
				id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{
				id : 'uploadNo',
				title : 'Upload No.',
				width : '75px',
				sortable : true
			},
			{
				id : 'filename',
				title : 'Filename',
				width : '150px',
				sortable : true
			},
			{
				id : 'groupedItemNo',
				title : 'G.I. No.',
				width : '50px',
				sortable : true
			},
			{
				id : 'groupedItemTitle',
				title : 'Title',
				width : '175px',
				sortable : true
			},
			{
				id : 'sex',
				title : 'S',
				width : '40px',
				sortable : true
			},
			{
				id : 'civilStatus',
				title : 'C',
				width : '30px',
				sortable : true
			},
			{
				id : 'dateOfBirth',
				title : 'Birthday',
				width : '80px',
				align : 'center',
				titleAlign: 'center',
				sortable : true,
				renderer : function(value){
					return (value == null || value == undefined || value == "") ? "" : dateFormat(value, "mm-dd-yyyy");
				}
			},
			{
				id : 'age',
				title : 'Age',
				width : '40px',
				align : 'right',
				sortable : true
			},
			{
				id : 'salary',
				title : 'Salary',
				width : '100px',
				align : 'right',
				titleAlign: 'right',
				sortable : true,
				geniisysClass : 'money'
			},
			{
				id : 'salaryGrade',
				width : '40px',
				title : 'SG',
				sortable : true
			},
			{
				id : 'amountCoverage',
				width : '115px',
				title : 'Amount Covered',
				align : 'right',
				sortable : true,
				geniisysClass : 'money'
			}
		               ],
		rows : objErrorLog.rows,
		id : 33
	};

	tbgErrorLog = new MyTableGrid(tbErrorLog);
	tbgErrorLog.pager = objErrorLog;
	tbgErrorLog._mtgId = 33;
	tbgErrorLog.render('errorLogTableGrid');
	tbgErrorLog.afterRender = function(){
		tbgErrorLog.keys.removeFocus(tbgErrorLog.keys._nCurrentFocus, true);
		tbgErrorLog.keys.releaseKeys();
	};
}catch(e){
	showErrorMessage("Errog Log Listing", e);
}
</script>