<div style="padding: 10px;">
	<div id="giacAcctEntriesListTableGridDiv" name="giacAcctEntriesListTableGridDiv" class="sectionDiv">
		<div id="giacAcctEntriesListTableGrid" style="height: 190px;"></div>
	</div>
	<div id="giclAcctEntriesDiv" name="giclAcctEntriesDiv" style="margin-top: 50px;" class="sectionDiv">
		<table align="center">
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
			<tr>
				<td align="right">SL Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="acctNameSpan" style="border: 1px solid gray; width: 510px; height: 21px; float: left;"> 
						<input type="text" id="slName" name="slName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" /> 
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnAcctName" name="btnAcctName" alt="Go" style="background: transparent;"/>
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 30px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" style="width: 100px;" id="btnAcctEntriesReturn" name="btnAcctEntriesReturn" value="Return">
		</div>
	</div>
	<input id="dvTranId"  type="hidden" value="${dvTranId}"/>
</div>
<script>

	var objAcctEntriesTG = JSON.parse('${acctEntriesTG}'.replace(/\\/g, '\\\\'));
	try{
		
	
		var acctEntriesModel = { 
			url: contextPath+"/GIACBatchDVController?action=getGIACS086AcctEntriesTableGrid&refresh=1&tranId="+nvl($F("dvTranId"), 0),
			options:{
				title: '',
				onCellFocus: function(element, value, x, y, id){
					var record = acctEntriesTableGrid.geniisysRows[y];
					$("acctName").value = unescapeHTML2(record.dspGlAcctName);
					$("slName").value = unescapeHTML2(record.dspSlName);
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					$("acctName").value = "";
					$("slName").value = "";
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
					width: '290px',
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
		accountingEntriesOverlay.close();
	});
	
	
	initializeAllMoneyFields();
</script>