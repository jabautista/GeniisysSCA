<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="uploadEnrolleeTable" name="uploadEnrolleeTable" style="width : 100%;">
	<div id="uploadEnrolleeTableGridSectionDiv" class="">
		<div id="uploadEnrolleeTableGridDiv" style="padding: 10px;">
			<div id="uploadEnrolleeTableGrid" style="height: 198px; width: 100%;"></div>
		</div>
	</div>	
</div>

<script type="text/javascript">
try{
	var objUploadEnrollees = JSON.parse('${tgLoadHist}');
	var tbUploadEnrollees = {
		url : contextPath + "/GIPILoadHistController?action=refreshUploadEnrolleeTable",
		options : {
			width : '660px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgUploadEnrollees.geniisysRows[y];
				
				$("uploadNo").value = objSelected.uploadNo;
				$("createToParDiv").down("label",0).update("Loading data " + objSelected.filename + " to " + $F("parNo"));
				
				enableButton("btnUploadEnrolleesDetails");
				enableButton("btnUploadEnrolleesCreateToPar");
				tbgUploadEnrollees.keys.removeFocus(tbgUploadEnrollees.keys._nCurrentFocus, true);
				tbgUploadEnrollees.keys.releaseKeys();
				
				new Ajax.Updater("uploadEnrolleeDetailsTable", contextPath + "/GIPIUploadTempController?action=getGIPIUploadTempTableGrid&uploadNo=" + objSelected.uploadNo + "&refresh=0", {
					method : "GET",
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						$("uploadEnrolleeDetailsTable").hide();
					},
					onComplete: function(){
						$("uploadEnrolleeDetailsTable").show();				
					}
				});
			},
			onRemoveRowFocus : function(){
				$("uploadNo").value = "";					
				$("createToParDiv").hide();
				$("viewUploadedFilesDetail").hide();
				
				disableButton("btnUploadEnrolleesDetails");
				disableButton("btnUploadEnrolleesCreateToPar");
				tbgUploadEnrollees.keys.removeFocus(tbgUploadEnrollees.keys._nCurrentFocus, true);
				tbgUploadEnrollees.keys.releaseKeys();
			},
			toolbar : {
				elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
			}
		
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
				id : 'parId',
				width : '0px',
				visible : false
			},
			{
				id : 'uploadNo',
				width : '70px',
				title : 'Upload No.',
				titleAlign: 'right',
				align : 'right',
				sortable : true
			},
			{
				id : 'filename',
				width : '300px',
				title : 'Filename',
				sortable : true,
				filterOption : true
			},
			{
				id : 'noOfRecords',
				width : '90px',
				title : 'No. of Records',
				titleAlign: 'right',
				align : 'right',
				sortable : true					
			},
			{
				id : 'userId',
				width : '60px',
				title : 'User ID',
				sortable : true
			},
			{
				id : 'dateLoaded',
				width : '80px',
				title : 'Date Loaded',
				titleAlign: 'center',
				align: 'center',
				sortable : true,
				renderer : function(value){
					return dateFormat(value, "mm-dd-yyyy");
				}
			}
		],
		rows : objUploadEnrollees.rows,
		id : 31
	};
	tbgUploadEnrollees = new MyTableGrid(tbUploadEnrollees);
	tbgUploadEnrollees.pager = objUploadEnrollees;
	tbgUploadEnrollees._mtgId = 31;
	tbgUploadEnrollees.render('uploadEnrolleeTableGrid');
	tbgUploadEnrollees.afterRender = function(){
		tbgUploadEnrollees.resize();
		tbgUploadEnrollees.onRemoveRowFocus();
	};
}catch(e){
	showErrorMessage("Upload Enrollee Listing", e);
}
</script>