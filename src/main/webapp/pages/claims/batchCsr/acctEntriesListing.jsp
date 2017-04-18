<div id="giclAcctEntriesHeaderDiv" name="giclAcctEntriesHeaderDiv" style="margin-top: 10px;">
	<table>
		<tr>
			<td align="right" style="width: 100px;">Claim Number</td>
			<td style="padding-left: 5px;">
				<input type="text" id="acctEntriesClaimNo" name="acctEntriesClaimNo" readonly="readonly" style="width: 200px;" value="${claimNo}"/>
			</td>
			<td align="right" style="width: 110px;">Request Number</td>
			<td style="padding-left: 5px;">
				<input type="text" id="acctEntriesRequestNo" name="acctEntriesRequestNo" readonly="readonly" style="width: 200px;" value="${requestNo}"/>
			</td>
		</tr>
		<tr>
			<td align="right" style="width: 100px;">Advice Number</td>
			<td style="padding-left: 5px;">
				<input type="text" id="acctEntriesAdviceNo" name="acctEntriesAdviceNo" readonly="readonly" style="width: 200px;" value="${adviceNo}"/>
			</td>
		</tr>
	</table>
	<div id="giclAcctEntriesListTableGridDiv" name="giclAcctEntriesListTableGridDiv" style="margin: 10px;">
		<div id="giclAcctEntriesListTableGrid" style="height: 180px;"></div>
	</div>
</div>
<div id="giclAcctEntriesDiv" name="giclAcctEntriesDiv" align="center" style="margin-top: 40px;">
	<table>
		<tr>
			<td align="right" style="width: 115px;">Total Debit Amount</td>
			<td style="padding-left: 5px;">
				<input type="text" id="totalDebitAmount" name="totalDebitAmount" readonly="readonly" style="width: 180px;" class="money" value="${totalDebitAmt}"/>
			</td>
			<td align="right" style="width: 125px;">Total Credit Amount</td>
			<td style="padding-left: 5px;">
				<input type="text" id="totalCreditAmount" name="totalCreditAmount" readonly="readonly" style="width: 180px;" class="money" value="${totalCreditAmt}"/>
			</td>
		</tr>
		<tr>
			<td align="right">Account Name</td>
			<td class="leftAligned" style="padding-left: 5px;" colspan="3">
				<span id="acctNameSpan" style="border: 1px solid gray; width: 510px; height: 21px; float: left;"> 
					<input type="text" id="acctName" name="acctName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" /> 
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnAcctName" name="btnAcctName" alt="Go" style="background: transparent;"/>
				</span>
			</td>
		</tr>
	</table>
	<div style="margin-top: 10px;">
		<input type="button" class="button" style="width: 100px;" id="btnAcctEntriesReturn" name="btnAcctEntriesReturn" value="Return">
	</div>
</div>

<script type="text/javascript">
	var objAcctEntries = new Object();
	objAcctEntries.objAcctEntriesTableGrid = JSON.parse('${jsonAcctEntries}');
	objAcctEntries.objAcctEntriesList = objAcctEntries.objAcctEntriesTableGrid.rows || [];
	
	var acctEntriesModel = {
		url: contextPath+"/GICLBatchCsrController?action=getGiclAcctEntriesTableGrid&adviceId="+nvl($F("hidCurrAdviceId"), 0)+"&claimId="+nvl($F("hidCurrClaimId"), 0),
		options:{
			title: '',
			width: '645px',
			onCellFocus: function(element, value, x, y, id){
				var mtgId = acctEntriesTableGrid._mtgId;
				var record = acctEntriesTableGrid.geniisysRows[y];
				$("acctName").value = record.nbtGlAcctName;
			},
			onRemoveRowFocus: function(element, value, x, y, id){
				$("acctName").value = "";
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
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
			{	id: 'adviceId',
				width: '0',
				visible: false
			},
			{	id: 'claimId',
				width: '0',
				visible: false
			},
			{	id: 'glAccountCategory',
				width: '0',
				title: 'GL Account Category',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glControlAccount',
				width: '0',
				title: 'GL Control Account',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount1',
				width: '0',
				title: 'GL Sub-Account 1',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount2',
				width: '0',
				title: 'GL Sub-Account 2',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount3',
				width: '0',
				title: 'GL Sub-Account 3',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount4',
				width: '0',
				title: 'GL Sub-Account 4',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount5',
				width: '0',
				title: 'GL Sub-Account 5',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount6',
				width: '0',
				title: 'GL Sub-Account 6',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glSubAccount7',
				width: '0',
				title: 'GL Sub-Account 7',
				visible: false,
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'glAcctCode',
				title: 'GL Account Code',
				width: '200px',
				titleAlign: 'center'
			},
			{	id: 'slCode',
				title: 'SL Code',
				width: '128px',
				titleAlign: 'center',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'debitAmount',
				title: 'Debit Amount',
				width: '140px',
				geniisysClass: 'money',
				align: 'right',
				titleAlign: 'center',
				filterOption: true,
				filterOptionType: 'number'
			},
			{	id: 'creditAmount',
				title: 'Credit Amount',
				width: '140px',
				geniisysClass: 'money',
				align: 'right',
				titleAlign: 'center',
				filterOption: true,
				filterOptionType: 'number'
			},
		],
		requiredColumns: 'batchCsrId adviceId glAcctCode',
		rows: objAcctEntries.objAcctEntriesList
	};
	
	acctEntriesTableGrid = new MyTableGrid(acctEntriesModel);
	acctEntriesTableGrid.pager = objAcctEntries.objAcctEntriesTableGrid;
	acctEntriesTableGrid.render('giclAcctEntriesListTableGrid');
	
	$("btnAcctEntriesReturn").observe("click", function(){
		winFCurr.close();
		acctEntriesTableGrid.keys.removeFocus(acctEntriesTableGrid.keys._nCurrentFocus, true);
		acctEntriesTableGrid.keys.releaseKeys();
	});
	
	$("btnAcctName").observe("click", function(){
		showEditor("acctName", 600, 'true');
	});
	
	$("totalDebitAmount").value = formatCurrency($("totalDebitAmount").value);
	$("totalCreditAmount").value = formatCurrency($("totalCreditAmount").value);
	
</script>