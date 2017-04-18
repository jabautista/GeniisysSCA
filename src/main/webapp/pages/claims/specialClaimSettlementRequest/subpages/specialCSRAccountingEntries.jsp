<div id="giacAcctEntriesHeaderDiv" name="giacAcctEntriesHeaderDiv" style="margin-top: 50px;">
	<div id="giacAcctEntriesListTableGridDiv" name="giacAcctEntriesListTableGridDiv" style="margin: 10px;">
		<div id="giacAcctEntriesListTableGrid" style="height: 180px;"></div>
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
<script>
	try{
		
		var objAcctEntriesTG = JSON.parse('${acctEntriesTG}'.replace(/\\/g, '\\\\'));
		
		var acctEntriesModel = { 
				url: contextPath+"/GIACBatchDVController?action=getGIACS086AcctEntriesTableGrid&refresh=1&tranId="+nvl($F("selectedTranId"), 0),
				options:{
					title: '',
					width: '645px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = acctEntriesTableGrid._mtgId;
						var record = acctEntriesTableGrid.geniisysRows[y];
						$("acctName").value = unescapeHTML2(record.dspGlAcctName);
					},
					onRemoveRowFocus: function(element, value, x, y, id){
						$("acctName").value = "";
					}/* ,onRefresh: function(){
						acctEntriesTableGrid.url = contextPath+"/GIACBatchDVController?action=getGIACS086AcctEntriesTableGrid&refresh=1&tranId="+nvl($F("selectedTranId"), 0);
					} */,
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN]
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
					{	id: 'glAcctCategory',
						width: '0',
						title: 'GL Account Category',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glControlAcct',
						width: '0',
						title: 'GL Control Account',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct1',
						width: '0',
						title: 'GL Sub-Account 1',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct2',
						width: '0',
						title: 'GL Sub-Account 2',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct3',
						width: '0',
						title: 'GL Sub-Account 3',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct4',
						width: '0',
						title: 'GL Sub-Account 4',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct5',
						width: '0',
						title: 'GL Sub-Account 5',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct6',
						width: '0',
						title: 'GL Sub-Account 6',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glSubAcct7',
						width: '0',
						title: 'GL Sub-Account 7',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'glAcctCd',
						title: 'GL Account Code',
						width: '200px',
						titleAlign: 'center'
					},
					{	id: 'slCd',
						title: 'SL Code',
						width: '128px',
						titleAlign: 'center',
						align: 'center',
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{	id: 'debitAmt',
						title: 'Debit Amount',
						width: '140px',
						geniisysClass: 'money',
						align: 'right',
						titleAlign: 'center',
						filterOption: true,
						filterOptionType: 'number'
					},
					{	id: 'creditAmt',
						title: 'Credit Amount',
						width: '140px',
						geniisysClass: 'money',
						align: 'right',
						titleAlign: 'center',
						filterOption: true,
						filterOptionType: 'number'
					},
					{	id: 'dspGlAcctName',
						title: '',
						width: '0',
						visible: false,
						filterOption: false
					}
				],
				rows: objAcctEntriesTG.rows
			};
			
			acctEntriesTableGrid = new MyTableGrid(acctEntriesModel);
			acctEntriesTableGrid.pager = objAcctEntriesTG;
			acctEntriesTableGrid.render('giacAcctEntriesListTableGrid');
	}catch(e){
		showErrorMessage("acctrans table grid.",e);
	}
	
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