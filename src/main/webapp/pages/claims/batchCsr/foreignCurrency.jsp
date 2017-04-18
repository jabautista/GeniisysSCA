<div id="fCurrencyDiv" name="fCurrencyDiv" style="margin: 10px;" align="center">
	<table id="fCurrencyTable" name="fCurrencyTable" cellpadding="1">
		<tr>
			<td align="right">Paid Amount</td>
			<td class="leftAligned" style="padding-left: 5px;">
				<input type="text" id="fCurrPaidAmount" name="fCurrPaidAmount" readonly="readonly" style="width: 150px;" class="money"/>
			</td>
		</tr>
		<tr>
			<td align="right">Net Amount</td>
			<td class="leftAligned" style="padding-left: 5px;">
				<input type="text" id="fCurrNetAmount" name="fCurrNetAmount" readonly="readonly" style="width: 150px;" class="money"/>
			</td>
		</tr>
		<tr>
			<td align="right">Advice Amount</td>
			<td class="leftAligned" style="padding-left: 5px;">
				<input type="text" id="fCurrAdviceAmount" name="fCurrAdviceAmount" readonly="readonly" style="width: 150px;" class="money"/>
			</td>
		</tr>
	</table>
	<div style="margin: 10px 0px;">
		<input type="button" class="button" style="width: 100px;" id="btnFCurrReturn" name="btnFCurrReturn" value="Return">
	</div>
</div>

<script type="text/javascript">
	$("fCurrPaidAmount").value = formatCurrency(objBatchCsr.paidForeignCurrencyAmount);
	$("fCurrNetAmount").value  = formatCurrency(objBatchCsr.netForeignCurrencyAmount);
	$("fCurrAdviceAmount").value = formatCurrency(objBatchCsr.adviceForeignCurrencyAmount);
	
	$("btnFCurrReturn").observe("click", function(){
		winFCurr.close();
	});
</script>