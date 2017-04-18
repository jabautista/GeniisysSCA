<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="processorHistoryDiv" style="width: 99.5%; padding-top: 5px; margin-top: 5px;">
   <div id="processorHistoryTable" style="height: 170px; margin-left: auto;"></div>
   <center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px;" /></center>
</div>
<script type="text/javascript">
	try {
		var jsonProcessorHistory = JSON.parse('${jsonProcessorHistory}');
		
		processorHistoryTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showProcessorHistory&refresh=1&claimId=" + objRecovery.claimId,
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
					id: 'inHouAdj',
					title: 'Claim Processor',
					width: 200
				},
				{
					id: 'userId',
					title: 'User ID',
					width: 200
				},
				{
					id: 'lastUpdate',
					title: 'Last Update',
					width: 252/* ,
					renderer : function(value){
						return  dateFormat(value, "mm-dd-yyyy hh:MM:ss TT");
					} */
				}
			],
			rows: jsonProcessorHistory.rows
		};

		tbgProcessorHistory = new MyTableGrid(processorHistoryTableModel);
		tbgProcessorHistory.pager = jsonProcessorHistory;
		tbgProcessorHistory.render('processorHistoryTable');
		
		
		$("btnReturn").observe("click", function(){
			overlayProcessorHistory.close();
			delete overlayProcessorHistory;
		});
	} catch (e) {
		showMessageBox("Error in processorHistory.jsp " + e, imgMessage.ERROR);
	}
</script>