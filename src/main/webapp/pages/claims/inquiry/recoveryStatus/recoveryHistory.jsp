<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryHistoryDiv" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 786px; height: 250px;">
		<div id="historyTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<center>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	</center>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
	try{
		var jsonRecoveryHistory = JSON.parse('${jsonRecoveryHistory}');
		
		historyTableModel = {
			id  : "recoveryHistory",	
			url : contextPath+"/GICLLossRecoveryStatusController?action=showGICLS269RecoveryHistory&refresh=1&recoveryId="+"${recoveryId}",
			options: {
				hideColumnChildTitle: true,
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '776px', height: '230px', 
				onCellFocus : function(element, value, x, y, id) {
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgHistory.keys.removeFocus(tbgHistory.keys._nCurrentFocus, true);
					tbgHistory.keys.releaseKeys();
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
					id : "recHistNo",
					title: "Hist No.",
					width: '70px',
					visible: true,
					filterOption: true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id : "recStatCd recStatDesc",
					title: "Status&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp",
					width: '150px',
					children : [{
		                id : 'recStatCd',
		                title:'Recovery Status Code',
		                align : 'left',
		                width: 50,
		                filterOption: true
		            },{
		                id : 'recStatDesc',
		                title: 'Recovery Status Description',
		                align : 'left',
		                width: 100,
		                filterOption: true
		            }]
				},				
				{
					id : "remarks",
					title: "Remarks",
					width: '260px',
					visible: true,
					filterOption: true
				},
				{
					id : "userId",
					title: "User ID",
					width: '90px',
					visible: true,
					filterOption: true
				},
				{
					id : "lastUpdate",
					title: "Last Update",
					width: '180px',
					visible: true,
					filterOption: false
				}
			],
			rows: jsonRecoveryHistory.rows
		};
	
		tbgHistory = new MyTableGrid(historyTableModel);
		tbgHistory.pager = jsonRecoveryHistory;
		tbgHistory.render('historyTable');
		tbgHistory.afterRender = function() {
		};
		
		
		$("btnReturn").observe("click", function(){
			overlayRecoveryHistory.close();
			delete overlayRecoveryHistory;
		});

	}catch(e){
		showMessageBox("Error in recoveryHistory.jsp " + e, imgMessage.ERROR);
	}
</script>