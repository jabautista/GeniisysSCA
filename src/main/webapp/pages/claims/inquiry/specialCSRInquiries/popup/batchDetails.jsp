<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="batchDetailsDiv" style="margin: 3px;">
	<div class="">
		<div id="batchDetailsTableDiv" style="margin: 5px;">
			<div id="batchDetailsGridDiv" style="height: 331px; margin-left: 0px;"></div>
		</div>
			
		<input type="hidden" id="hidBatchDvId" value='${batchDvId}'/>
		<div class="buttonsDiv" style="margin: 10px 0 10px 0;">
			<input type="button" class="button" id="btnReturn" value="Return" tabindex="209">
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	var selectedIndex = -1;	//holds the selected index
	var selectedRow = null;	//holds the selected row info
	
	var objBatchDetails = new Object();
	objBatchDetails.batchDetailsTG = JSON.parse('${batchDetailsList}'.replace(/\\/g, '\\\\'));
	objBatchDetails.batchDetailsObjRows = objBatchDetails.batchDetailsTG.rows || [];
	objBatchDetails.batchDetailsList = [];	// holds all the geniisys rows
	
	var objBatchDetailsRow = null;
		
	try{
		var batchDetailsTableModel = {
			url: contextPath+"/GIACBatchDVController?action=showGIACS087BatchDetails&refresh=1&batchDvId="+$F("hidBatchDvId"),
			options: {
				width:	'785px',
				height: '307px',
				hideColumnChildTitle : true,
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = batchDetailsTG.geniisysRows[y];
				},
				onRemoveRowFocus: function(){
					batchDetailsTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = "";
				},
				onRefresh: function(){
					batchDetailsTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						batchDetailsTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{
					id: 'batchDivId',
					width: '0px',
					visible: false
				},
				{
					id: 'payeeClassCd',
					width: '0px',
					visible: false
				},
				{
					id: 'payeeCd',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtPayee',
					width: '0px',
					visible: false
				},
				{
					id: 'payeeRemarks',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtPaidAmt',
					width: '0px',
					visible: false
				},
				{
					id: 'currencyCd',
					width: '0px',
					visible: false
				},
				{
					id: 'convertRate',
					width: '0px',
					visible: false
				},
				{
					id: 'userId',
					width: '0px',
					visible: false
				},
				{
					id: 'lastUpdate',
					width: '0px',
					visible: false
				},
				{
					id : 'chkGen',
					title: 'G',
					altTitle: 'Tag for generation of accounting records',
					width : '25px',
					align : 'center',
					editable : false,
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id : "lineCd issCd adviceYear adviceSeqNo",
					title : "Advice Number",
					children : [
						{
							id: 'lineCd',
							title: 'Line Cd',
							width: 25,
							filterOption: true
						},
						{
							id: 'issCd',
							title: 'Issue Cd',
							width: 25,
							filterOption: true
						},
						{
							id: 'adviceYear',
							title: 'Advice Year',
							align: 'right',
							width: 35,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'adviceSeqNo',
							title: 'Advice Seq No',
							align: 'right',
							width: 50,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							renderer: function(value){
								return lpad(value, 6, 0);
							}
						}
					]
				},
				{
					id : "nbtClmLineCd nbtClmSublineCd nbtClmIssCd nbtClmClmYy nbtClmClmSeqNo",
					title : "Claim Number",
					titleAlign: 'center',
					children : [
						{
							id: 'nbtClmLineCd',
							title: 'Claim Line Cd',
							width: 25,
							filterOption: true
						},
						{
							id: 'nbtClmSublineCd',
							title: 'Claim Subline Cd',
							width: 50,
							filterOption: true
						},
						{
							id: 'nbtClmIssCd',
							title: 'Claim Iss Cd',
							width: 25,
							filterOption: true
						},
						{
							id: 'nbtClmClmYy',
							title: 'Claim Year',
							align: 'right',
							width: 25,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'nbtClmClmSeqNo',
							title: 'Claim Seq No',
							align: 'right',
							width: 50,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							renderer: function(value){
								return lpad(value, 7, 0);
							}
						}
					]
				},		
				{
					id : "nbtPolLineCd nbtPolSublineCd nbtPolPolIssCd nbtPolIssueYy nbtPolPolSeqNo nbtPolRenewNo",
					title : "Policy Number",
					titleAlign: 'center',
					children : [
						{
							id: 'nbtPolLineCd',
							title: 'Pol Line Cd',
							width: 25,
							filterOption: true
						},
						{
							id: 'nbtPolSublineCd',
							title: 'Pol Subline Cd',
							width: 50,
							filterOption: true
						},
						{
							id: 'nbtPolPolIssCd',
							title: 'Pol Iss Cd',
							width: 25,
							filterOption: true
						},
						{
							id: 'nbtPolIssueYy',
							title: 'Pol Issue Yy',
							align: 'right',
							width: 25,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'nbtPolPolSeqNo',
							title: 'Pol Seq No',
							align: 'right',
							width: 50,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							renderer: function(value){
								return lpad(value, 7, 0);
							}
						},
						{
							id: 'nbtPolRenewNo',
							title: 'Pol Renew No',
							align: 'right',
							width: 20,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							renderer: function(value){
								return lpad(value, 2, 0);
							}
						}
					]
				},			
				{
					id : "nbtAssdNo nbtAssdName",
					title : "Assured",
					titleAlign: 'center',
					children : [
						{
							id: 'nbtAssdNo',
							title: 'Assd No',
							align: 'right',
							width: 90,
							filterOption: true,
							filterOptionType: 'integerNoNegative',
							renderer: function(value){
								return lpad(value, 12, 0);
							}
						},
						{
							id: 'nbtAssdName',
							title: 'Assd Name',
							width: 300,
							filterOption: true
						},
					]
				},				
				{
					id : "clmStatCd nbtClmStatDesc",
					title : "Claim Status",
					titleAlign: 'center',
					children : [
						{
							id: 'clmStatCd',
							title: 'Clm Stat Cd',
							width: 30,
							filterOption: true
						},
						{
							id: 'nbtClmStatDesc',
							title: 'Clm Stat Desc',
							width: 120,
							filterOption: false
						},
					]
				},
				{
					id: 'nbtDspLossDate',
					title: 'Loss Date',
					titleAlign: 'center',
					align: 'center',
					width: '70px',
					renderer: function(value){
						return value == "" ? "" : dateFormat(value, "mm-dd-yyyy");
					},
					filterOptionType: 'formattedDate'
				},
				{
					id : "payeeClassCd payeeCd nbtPayee payeeRemarks",
					title : "Payee",
					titleAlign: 'center',
					children : [
						{
							id: 'payeeClassCd',
							title: 'Payee Class Cd',
							width: 30,
							filterOption: true
						},
						{
							id: 'payeeCd',
							title: 'Payee Cd',
							width: 90,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'nbtPayee',
							title: 'Payee Name',
							width: 320,
							filterOption: true
						},
						{
							id: 'payeeRemarks',
							title: 'payeeRemarks',
							width: 320,
							filterOption: false
						}
					]
				},
				{
					id: 'nbtPaidAmt',
					title: 'Paid Amount',
					titleAlign: 'right',
					align: 'right',
					width: '120px',
					renderer: function(value){
						return value == "" ? "" : formatCurrency(value);
					},
					filterOption: false
				},
				{
					id: 'currencyCd',
					title: 'Currency',
					titleAlign: 'right',
					align: 'right',
					width: '60px',
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'convertRate',
					title: 'Convert Rate',
					titleAlign: 'right',
					align: 'right',
					width: '100px',
					renderer: function(value){
						return value == "" ? "" : formatToNineDecimal(value);
					},
					filterOption: false
				}	
			],
			rows: objBatchDetails.batchDetailsObjRows
		};

		batchDetailsTG = new MyTableGrid(batchDetailsTableModel);
		batchDetailsTG.pager = objBatchDetails.batchDetailsTG;
		batchDetailsTG.render('batchDetailsGridDiv');
	}catch(e){
		showErrorMessage("Batch Details tablegrid", e);
	}	
	
	$("btnReturn").observe("click", function(){
		batchDetailsTG.keys.releaseKeys();
		objOverlay.close();
	});
}catch(e){
	showErrorMessage("Batch Details page", e);
}
</script>