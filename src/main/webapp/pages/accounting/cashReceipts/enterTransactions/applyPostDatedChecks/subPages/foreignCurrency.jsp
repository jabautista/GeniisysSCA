<div align="center" class="sectionDiv" style="width: 400px; margin-top: 5px;">
	<table cellspacing="3" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td><label style="width: 130px; text-align: right;" >Currency</label></td>
			<td class="leftAligned">
				<input id="txtCurrencyCd" type="text" ignoreDelKey="1" class="rightAligned" style="width: 30px;" tabindex="101" maxlength="550" readonly="readonly">
				<input id="txtCurrencyDesc" type="text" ignoreDelKey="1" class="" style="width: 158px;" tabindex="102" maxlength="550" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td><label style="width: 130px; text-align: right;" >Convert Rate</label></td>
			<td class="leftAligned">
				<input id="txtConvertRate" type="text" ignoreDelKey="1" class="rightAligned" style="width: 200px;" tabindex="103" maxlength="50" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td><label style="width: 130px; text-align: right;" >Foreign Currency Amt</label></td>
			<td class="leftAligned">
				<input id="txtForeignCurrencyAmt" type="text" ignoreDelKey="1" class="rightAligned" style="width: 200px;" tabindex="104" maxlength="50" readonly="readonly">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnReturn" value="Return" tabindex="201">
	</div>
</div>
<script type="text/javascript">
	var objParams = JSON.parse('${object}');
	
	function closeOverlay(){
		overlayForeignCurrency.close();
		delete overlayForeignCurrency;
	}
	
	$("btnReturn").observe("click", closeOverlay);
	
	$("txtCurrencyCd").value = objParams.currencyCd;
	$("txtCurrencyDesc").value = objParams.currencyDesc;
	$("txtConvertRate").value = formatToNthDecimal(objParams.currencyRt,9);
	$("txtForeignCurrencyAmt").value = formatCurrency(objParams.fcurrencyAmt);
	
</script>