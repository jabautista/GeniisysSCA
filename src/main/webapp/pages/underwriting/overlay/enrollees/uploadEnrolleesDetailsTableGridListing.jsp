<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="uploadEnrolleeDetailsTable" name="uploadEnrolleeDetailsTable" style="width : 100%;">
	<div id="uploadEnrolleeDetailsTableGridSectionDiv" class="">
		<div id="uploadEnrolleeDetailsTableGridDiv" style="padding: 10px;">
			<div id="uploadEnrolleeDetailsTableGrid" style="height: 198px; width: 100%;"></div>
		</div>
	</div>	
</div>

<script type="text/javascript">
try{
	var objUploadTemp = JSON.parse('${tgUploadTemp}');
	var tbUploadDetails = {
		url : contextPath + "/GIPIUploadTempController?action=getGIPIUploadTempTableGrid&uploadNo=" + $F("uploadNo") + "&refresh=1",
		options : {
			width : '660px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				//
			},
			onRemoveRowFocus : function(){
				
			}/*,
			toolbar : {
				elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
			}*/
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
				width : '0px',
				visible : false
			},
			{
				id : 'controlCd',
				width : '90px',
				title : 'Control Code',				
				sortable : true
			},
			{
				id : 'groupedItemTitle',
				width : '175px',
				title : 'Grouped Item Title',
				sortable : true
			},
			{
				id : 'sex',
				width : '40px',
				title : 'Sex',
				sortable : true
			},
			{
				id : 'civilStatus',
				width : '80px',
				title : 'Civil Status',
				sortable : true
			},
			{
				id : 'dateOfBirth',
				width : '90px',
				title : 'Date of Birth',
				align: 'center',
				titleAlign: 'center',
				sortable : true,
				renderer : function(value){
					return (value == null || value == undefined || value == "") ? "" : dateFormat(value, "mm-dd-yyyy");
				}
			},
			{
				id : 'fromDate',
				width : '90px',
				title : 'From Date',
				align: 'center',
				titleAlign: 'center',
				sortable : true,
				renderer : function(value){					
					return (value == null || value == undefined || value == "") ? "" : dateFormat(value, "mm-dd-yyyy");
				}
			},
			{
				id : 'toDate',
				width : '90px',
				title : 'To Date',
				align: 'center',
				titleAlign: 'center',
				sortable : true,
				renderer : function(value){
					return (value == null || value == undefined || value == "") ? "" : dateFormat(value, "mm-dd-yyyy");
				}
			},
			{
				id : 'age',
				width : '40px',
				title : 'Age',
				align : 'right',
				titleAlign: 'right',
				sortable : true
			},
			{
				id : 'salary',
				width : '100px',
				title : 'Salary',
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
				id : 'uploadDate',
				width : '85px',
				title : 'Upload Date',
				align: 'center',
				titleAlign: 'center',
				sortable : true,
				renderer : function(value){
					return (value == null || value == undefined || value == "") ? "" : dateFormat(value, "mm-dd-yyyy");
				}
			},
			{
				id : 'amountCoverage',
				width : '115px',
				title : 'Amount Covered',
				align : 'right',
				titleAlign: 'right',
				sortable : true,
				geniisysClass : 'money'
			}
		               ],
		rows : objUploadTemp.rows,
		id : 32
	};
	
	tbgUploadDetails = new MyTableGrid(tbUploadDetails);
	tbgUploadDetails.pager = objUploadTemp;
	tbgUploadDetails._mtgId = 32;
	tbgUploadDetails.render('uploadEnrolleeDetailsTableGrid');
}catch(e){
	showErrorMessage("Upload Enrollee Details Listing", e);
}
</script>