<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewHistoryMainDiv" name="viewHistoryMainDiv" class="sectionDiv" style="border: none;">
	<div id="viewHistoryTableGridDiv" style="margin: 10px;">
		<div id="viewHistoryTableGrid" style="height: 181px; width: 890px;"></div>
	</div>
	<div id="copyHistDiv" name="copyHistDiv" style="border: none; margin: 0px 10px; display: none;">
		<table>
			<tr>
				<td align="left">Copy History No.</td>
				<td>
					<input type="text" id="txtCopyHistNo" name="txtCopyHistNo" value="" style="width: 100px; margin-left: 5px; text-align: right;" readonly="readonly"/>
				</td>
				<td style="width: 550px; margin-right: 5px;" align="right">
					<input type="button" class="button" id="btnCopyHistory"    	  name="btnCopyHistory"    	value="Copy History" style="width:100px;"></td>
				<td><input type="button" class="button" id="btnCancelCopyHist"    name="btnCancelCopyHist"  value="Cancel" 		 style="width:100px;"></td>
			</tr>
		</table>
	</div>
	<div align="center" id="returnDiv" name="returnDiv">
		<input type="button" class="button" id="viewHistoryReturn" name="viewHistoryReturn" value="Return" style="width:90px;">
	</div>
</div>

<script type="text/javascript">
try{
	var objViewHistoryTG = JSON.parse('${jsonViewHistory}');
	var objViewHistory = objViewHistoryTG.rows || []; 
	
	var viewHistoryTableModel = {
		id : 18,
		url : contextPath + "/GICLClaimLossExpenseController?action=getViewHistoryListing&claimId="+ nvl(objCurrGICLLossExpPayees.claimId, 0) +"&lineCd="+objCLMGlobal.lineCd+
		                    "&payeeType="+objCurrGICLLossExpPayees.payeeType+"&payeeClassCd="+objCurrGICLLossExpPayees.payeeClassCd+"&payeeCd="+objCurrGICLLossExpPayees.payeeCd+
		                    "&itemNo="+objCurrGICLLossExpPayees.itemNo+"&perilCd="+objCurrGICLLossExpPayees.perilCd,
		options:{
			title: '',
			pager: { },
			width: '890px',
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN/*, MyTableGrid.FILTER_BTN*/],
				onRefresh: function(){
					clearViewHistoryForm();
				},
				onFilter: function(){
					clearViewHistoryForm();
				}
			},
			onCellFocus: function(element, value, x, y, id){
				var hist = viewHistoryTableGrid.geniisysRows[y];
				$("txtCopyHistNo").value = hist.historySequenceNumber;
				viewHistoryTableGrid.releaseKeys();
			},
			onRemoveRowFocus: function() {
				clearViewHistoryForm();
			},
			onSort: function(){
				clearViewHistoryForm();
			}
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
			{	id: 'historySequenceNumber',
				align: 'right',
			  	title: 'Hist.',
			  	titleAlign: 'center',
			  	width: '50px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true,
			  	filterOptionType: 'integerNoNegative',
			  	renderer : function(value){
					return lpad(value.toString(), 3, "0");					
				}
			},
			{	id: 'clmLossExpStatDesc',
				align: 'left',
			  	title: 'History Status',
			  	titleAlign: 'center',
			  	width: '150px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true
			},
			{	id: 'distSw',
				align: 'left',
			  	title: 'D',
			  	altTitle: "Distribution Switch",
			  	titleAlign: 'center',
			  	width: '25px',
			  	editable: false,
			  	sortable: true
			},
			{	id: 'itemNo',
				align: 'right',
			  	title: 'Item',
			  	titleAlign: 'center',
			  	width: '50px',
			  	editable: false,
			  	sortable: true,
			  	renderer : function(value){
					return lpad(value.toString(), 3, "0");					
				}
			},
			{	id: 'perilSname',
				align: 'left',
			  	title: 'Peril',
			  	titleAlign: 'center',
			  	width: '60px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true
			},
			{	id: 'payeeClassCode',
				align: 'right',
			  	title: 'Class',
			  	titleAlign: 'center',
			  	width: '50px',
			  	editable: false,
			  	sortable: true
			},
			{	id: 'payee',
				align: 'left',
			  	title: 'Payee Name',
			  	titleAlign: 'center',
			  	width: '168px',
			  	editable: false,
			  	sortable: true,
			  	filterOption: true
			},
			{
			   	id: 'paidAmount',
			   	title: 'Paid Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '100px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'netAmount',
			   	title: 'Net Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '100px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			},
			{
			   	id: 'adviceAmount',
			   	title: 'Advice Amount',
			   	titleAlign: 'center',
			   	type : 'number',
			  	width: '110px',
			  	geniisysClass : 'money',
			  	filterOption: true,
				filterOptionType: 'number'
			}
			
		],
		rows : objViewHistory,
		requiredColumns: ''
	};
	viewHistoryTableGrid = new MyTableGrid(viewHistoryTableModel);
	viewHistoryTableGrid.pager = objViewHistoryTG;
	viewHistoryTableGrid.render('viewHistoryTableGrid');
	
}catch(e){
	showErrorMessage("Loss Expense Hist - View History", e);
}

if('${copySw}' == "Y"){
	$("returnDiv").hide();
	$("copyHistDiv").show();
}else{
	$("copyHistDiv").hide();
	$("returnDiv").show();
}

$("viewHistoryReturn").observe("click", function(){
	lossExpHistWin.close();
});

$("btnCancelCopyHist").observe("click", function(){
	lossExpHistWin.close();
});

$("btnCopyHistory").observe("click", function(){
	var histSeqNo = $("txtCopyHistNo").value;
	if(histSeqNo == ""){ //added condition by robert to prevent error 10.24.2013
		showMessageBox("Please select a history record first.", "I");
	}else{
		copyHistory(histSeqNo);
		lossExpHistWin.close();
	}
});

function clearViewHistoryForm(){
	$("txtCopyHistNo").value = "";
	viewHistoryTableGrid.releaseKeys();
}

hideNotice();
</script>