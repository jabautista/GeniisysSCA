<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="historyMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="historyDiv">
		<div id="historyTableDiv" style="">
			<div id="historyTable" style="height: 295px"></div>
		</div>
	</div>
</div>
<div id="buttonsDiv" style="float: left; width: 100%;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 90px;" id="btnPrint" name="btnPrint" value="Print" />
				<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			</td>
		</tr>
	</table>
</div>	
<script type="text/javascript">		
	function printHistory(){
		new Ajax.Request(contextPath + "/GIPIUserEventHistController", {
			method: "POST",
			parameters: {action : "printHistory",
						 destination : $F("selDestination"),
						 printer : $F("selPrinter"),
						 noOfCopies : $F("txtNoOfCopies")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					overlayGenericPrintDialog.close();
				}
			}
		});
	}

	$("btnCancel").observe("click", function(){
		tbgWorkflowHistory.keys.releaseKeys();
		overlayWorkflowHistory.close();
	});

	$("btnPrint").observe("click", function(){
		tbgWorkflowHistory.keys.releaseKeys();
		showGenericPrintDialog("Print Transaction History", printHistory);
	});
	
	var objTGWorkflowHistory = JSON.parse('${historyTableGrid}'.replace(/\\/g, "\\\\"));	
	var workflowHistoryTable = {
			url: contextPath+"/GIPIUserEventHistController?action=getGIPIUserEventHistList&refresh=1&tranId="+objCurrEventDtl.tranId,
			options: {
				width: '597px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {

				},
				onRemoveRowFocus : function(element, value, x, y, id){	
				},
				prePager: function (){

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
					id : "dateReceived",
					title: "Date Received",
					width: '140px'					
				},
				{
					id : "oldUserId",
					title: "Old User Id",
					width: '95px'
				},
				{
					id : "newUserId",
					title: "New User Id",
					width: '95px'
				},
				{
					id : "remarks",
					title: "Remarks",
					width: '235px'
				}
				],
			rows: objTGWorkflowHistory.rows
		};

	tbgWorkflowHistory = new MyTableGrid(workflowHistoryTable);
	tbgWorkflowHistory.pager = objTGWorkflowHistory;
	tbgWorkflowHistory.render('historyTable');
</script>