<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="claimStatusHistoryDiv" style="width: 99.5%; padding-top: 5px; margin-top: 5px;">
   <div id="claimStatusHistoryTable" style="height: 170px; margin-left: auto;"></div>
   <center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px;" /></center>
</div>
<script type="text/javascript">
	try {
		var jsonClaimStatusHistory = JSON.parse('${jsonClaimStatusHistory}');
		
		claimStatusHistoryTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClaimStatusHistory&refresh=1&claimId=" + objRecovery.claimId,
			options: {/* 
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				}, */
				width: '665px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					
				},
				prePager: function(){

				},
				onRemoveRowFocus : function(element, value, x, y, id){
					
				},
				afterRender : function (){
					
				},
				onSort : function(){		
				},
				onRefresh : function() {

				}
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id: 'clmStatCd',
					title: 'Claim Status Code',
					width: 120
				},
				{
					id: 'clmStatDesc',
					title: 'Description',
					width: 150
				},
				{
					id: 'userId',
					title: 'User ID',
					width: 150
				},
				{
					id: 'clmStatDt',
					title: 'Date',
					width: 231/* ,
					renderer : function(value){
						return  dateFormat(value, "mm-dd-yyyy hh:MM:ss TT");
					} */
				}
			],
			rows: jsonClaimStatusHistory.rows
		};

		tbgClaimStatusHistory = new MyTableGrid(claimStatusHistoryTableModel);
		tbgClaimStatusHistory.pager = jsonClaimStatusHistory;
		tbgClaimStatusHistory.render('claimStatusHistoryTable');
		
		
		$("btnReturn").observe("click", function(){
			overlayClaimStatusHistory.close();
			delete overlayClaimStatusHistory;
		});
	} catch (e) {
		showMessageBox("Error in processorHistory.jsp " + e, imgMessage.ERROR);
	}
</script>