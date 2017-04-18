<div style="padding: 10px;">
	<div id="giacAcctEntriesListTableGridDiv" name="giacAcctEntriesListTableGridDiv" style="height: 220px;">
		<div id="giacAcctEntriesListTableGrid" style="height: 190px;"></div>
	</div>

	<div id="replenishAcctEntriesDiv" name="replenishAcctEntriesDiv" style="padding-left: 260px;">
		<input type="text" id="balance" name="balance" readonly="readonly" style="width: 120px;" class="money"/>
		<input type="text" id="totalDebitAmount" name="totalDebitAmount" readonly="readonly" style="width: 130px;" class="money" />
		<input type="text" id="totalCreditAmount" name="totalCreditAmount" readonly="readonly" style="width: 130px;" class="money" />
	</div>
	
	<div id="giclAcctEntriesDiv" name="giclAcctEntriesDiv" style="margin-top: 10px;" class="sectionDiv">
		<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td align="right">Account Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="acctNameSpan" style="border: 1px solid gray; width: 510px; height: 21px; float: left;"> 
						<input type="text" id="acctName" name="acctName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" /> 
					</span>
				</td>
			</tr>
			<tr>
				<td align="right">SL Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="acctNameSpan" style="border: 1px solid gray; width: 510px; height: 21px; float: left;"> 
						<input type="text" id="slName" name="slName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" /> 
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonDiv" style="margin-top: 10px; margin-bottom:10px; float: left; padding-left: 300px;">
		<input type="button" class="button" style="width: 100px;" id="btnAcctEntriesReturn" name="btnAcctEntriesReturn" value="Return">
	</div>
</div>
<script>
	try{
		var objAcctEntriesTG = JSON.parse('${jsonReplenishmentSumAcctEnt}');
		var acctEntriesModel = { 
			url: contextPath+"/GIACReplenishDvController?action=showReplenishmentOfRevolvingFundSumAcctEnt&refresh=1&replenishId="+objReplenish.replenishId,
			options:{
				title: '',
				onCellFocus: function(element, value, x, y, id){
					var record = acctEntriesTableGrid.geniisysRows[y];
					$("acctName").value = unescapeHTML2(record.glAcctName);
					$("slName").value = unescapeHTML2(record.slName);
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					$("acctName").value = "";
					$("slName").value = "";
				},
				onSort: function() {
					$("acctName").value = "";
					$("slName").value = "";
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
				{	id: 'glAcctCode',
					title: 'GL Account Code',
					width: '245px'
				},
				{	id: 'slCode',
					title: 'SL Code',
					width: '120px',
					titleAlign: 'right',
					align: 'right'
				},
				{	id: 'debitAmt',
					title: 'Debit Amount',
					width: '140px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'creditAmt',
					title: 'Credit Amount',
					width: '140px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
				}
			],
			rows: objAcctEntriesTG.rows
		};
		
		acctEntriesTableGrid = new MyTableGrid(acctEntriesModel);
		acctEntriesTableGrid.pager = objAcctEntriesTG;
		acctEntriesTableGrid.render('giacAcctEntriesListTableGrid');
		acctEntriesTableGrid.afterRender = function() {
			$("totalDebitAmount").value = formatCurrency(acctEntriesTableGrid.geniisysRows[0].totalDebit);
			$("totalCreditAmount").value = formatCurrency(acctEntriesTableGrid.geniisysRows[0].totalCredit);
			$("balance").value = formatCurrency(acctEntriesTableGrid.geniisysRows[0].balance);
		};
	}catch(e){
		showErrorMessage("acctrans table grid.",e);
	}
	
	$("btnAcctEntriesReturn").observe("click", function(){
		replenishSummarizedEntriesOverlay.close();
	});
	
	initializeAllMoneyFields();
</script>