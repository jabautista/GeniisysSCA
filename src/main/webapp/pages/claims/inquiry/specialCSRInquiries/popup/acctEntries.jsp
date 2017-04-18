<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="acctEntriesDiv" style="margin: 3px;">
	<div class="">			
		<input type="hidden" id="hidBatchDvId" value='${batchDvId}'/>
		
		<div id="acctEntriesTableDiv" style="margin: 5px;">
			<div id="acctEntriesGridDiv" style="height: 170px; margin-left: 0px;"></div>
		</div>
				
		<div id="acctEntriesDtlTableDiv" style="margin: 5px;">
			<div id="acctEntriesDtlGridDiv" style="height: 170px; margin-left: 0px;"></div>
		</div>
		
		<div align="right" id="acctEntDtlFormDiv" style="margin: 0px 10px 10px 10px;">
			<table>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Totals</td>
					<td class="leftAligned">
						<input id="txtSumDebitAmt" type="text" style="width: 95px; text-align: right;" tabindex="201" readonly="readonly">
					</td>		
					<td class="leftAligned">
						<input id="txtSumCreditAmt" type="text" style="width: 95px; text-align: right;" tabindex="202" readonly="readonly">
					</td>
				</tr>
			</table>
			<table style="margin-top: 2px;">
				<tr>
					<td class="rightAligned" style="padding-right: 8px;">Account Name</td>
					<td class="leftAligned">
						<input id="txtGlAcctName" type="text" style="width: 660px;" tabindex="201" readonly="readonly">
					</td>	
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" style="margin: 0px 0 0px 0;">
			<input type="button" class="button" id="btnReturn" value="Return" tabindex="209">
		</div>
	</div>
</div>

<script type="text/javascript">
try{	
	$("btnReturn").observe("click", function(){
		acctEntriesTG.keys.releaseKeys();
		acctEntriesDtlTG.keys.releaseKeys();
		objOverlay.close();
	});
	
	var selectedIndex = -1;	//holds the selected index
	var selectedRow = null;	//holds the selected row info
	
	var objAcctEntries = new Object();
	objAcctEntries.acctEntriesTG = JSON.parse('${acctEntriesList}'.replace(/\\/g, '\\\\'));
	objAcctEntries.acctEntriesObjRows = objAcctEntries.acctEntriesTG.rows || [];
	objAcctEntries.acctEntriesList = [];	// holds all the geniisys rows
			
	try{
		var acctEntriesTableModel = {
			url: contextPath+"/GIACBatchDVController?action=showGIACS087AcctEntries&refresh=1&batchDvId="+$F("hidBatchDvId"),
			options: {
				width:	'785px',
				height: '130px',
				hideColumnChildTitle : true,
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = acctEntriesTG.geniisysRows[y];
					populateChildTG(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					acctEntriesTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = "";
					populateChildTG(null);
				},
				onRefresh: function(){
					acctEntriesTG.onRemoveRowFocus();
				},
				onSort: function(){
					acctEntriesTG.onRemoveRowFocus();
				},
				prePager: function(){
					acctEntriesTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						acctEntriesTG.onRemoveRowFocus();
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
					id: 'tranId',
					width: '0px',
					visible: false
				},
				{
					id: 'branchCd',
					title: 'Branch',
					width: '70px',
					filterOption: true
				},
				{
					id: 'refNo',
					title: 'Reference No.',
					width: '150px',
					filterOption: true
				},
				{
					id: 'particulars',
					title: 'Particulars',
					width: '533px',
					filterOption: false
				},
			],
			rows: objAcctEntries.acctEntriesObjRows
		};

		acctEntriesTG = new MyTableGrid(acctEntriesTableModel);
		acctEntriesTG.pager = objAcctEntries.acctEntriesTG;
		acctEntriesTG.render('acctEntriesGridDiv');
	}catch(e){
		showErrorMessage("Accounting Entries Main tablegrid", e);
	}
	
	var objAcctEntriesDtl = new Object();
	//objAcctEntriesDtl.acctEntriesDtlTG = JSON.parse('${acctEntriesDtlList}'.replace(/\\/g, '\\\\'));
	objAcctEntriesDtl.acctEntriesDtlList = [];	// holds all the geniisys rows
	objAcctEntriesDtl.acctEntriesDtlObjRows = objAcctEntriesDtl.acctEntriesDtlList.rows || [];
				
	try{
		var acctEntriesDtlTableModel = {
			url: contextPath+"/GIACBatchDVController?action=getGIACS087AcctEntriesDtl&refresh=1",
			options: {
				width:	'785px',
				height: '140px',
				hideColumnChildTitle : true,
				onCellFocus: function(element, value, x, y, id){					
					$("txtGlAcctName").value = unescapeHTML2(acctEntriesDtlTG.geniisysRows[y].glAcctName);
				},
				onRemoveRowFocus: function(){
					acctEntriesDtlTG.keys.releaseKeys();
					$("txtGlAcctName").clear();
				},
				onRefresh: function(){
					acctEntriesDtlTG.onRemoveRowFocus();
				},
				onSort: function(){
					acctEntriesDtlTG.onRemoveRowFocus();
				},
				prePager: function(){
					acctEntriesDtlTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						acctEntriesDtlTG.onRemoveRowFocus();
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
					id: 'tranId',
					width: '0px',
					visible: false
				},
				{
					id: 'glAcctNo',
					title: 'GL Account No.',
					width: '150px',
					filterOption: true
				},
				{
					id: 'glAcctName',
					title: 'Account Name',
					width: '330px',
					filterOption: true
				},
				{
					id: 'slCd',
					title: 'SL Code',
					width: '70px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'debitAmt',
					title: 'Debit Amount',
					titleAlign: 'right',
					align: 'right',
					width: '100px',
					renderer: function(value){
						return value == "" ? "" : formatCurrency(value);
					},
					filterOption: true,
					filterOptionType: 'number'
				},
				{
					id: 'creditAmt',
					title: 'Credit Amount',
					titleAlign: 'right',
					align: 'right',
					width: '100px',
					renderer: function(value){
						return value == "" ? "" : formatCurrency(value);
					},
					filterOption: true,
					filterOptionType: 'number'
				}
			],
			rows: objAcctEntriesDtl.acctEntriesDtlObjRows
		};

		acctEntriesDtlTG = new MyTableGrid(acctEntriesDtlTableModel);
		acctEntriesDtlTG.pager = objAcctEntriesDtl.acctEntriesDtlList;
		acctEntriesDtlTG.render('acctEntriesDtlGridDiv');
	}catch(e){
		showErrorMessage("Accounting Entries Detail tablegrid", e);
	}
	
	function populateChildTG(row){
		if (row == null){
			acctEntriesDtlTG.url = contextPath+"/GIACBatchDVController?action=getGIACS087AcctEntriesDtl&refresh=1";
		}else{
			acctEntriesDtlTG.url = contextPath+"/GIACBatchDVController?action=getGIACS087AcctEntriesDtl&refresh=1&tranId="+row.tranId;
		}
		acctEntriesDtlTG._refreshList();
		
		new Ajax.Request(contextPath+"/GIACBatchDVController",{
			parameters: {
				action:	"getGIACS087AcctEntriesTotals",
				tranId:	row == null ? null : row.tranId,
				branchCd:	row == null ? null : row.branchCd		
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var json = JSON.parse(response.responseText);
					$("txtSumDebitAmt").value = formatCurrency(json.sumDebitAmt);
					$("txtSumCreditAmt").value = formatCurrency(json.sumCreditAmt);
				}
			}
		});
	}
}catch(e){
	showErrorMessage("Batch Details page", e);
}
</script>