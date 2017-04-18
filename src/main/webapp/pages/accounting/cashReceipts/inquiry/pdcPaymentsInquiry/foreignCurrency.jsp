<div id="orParticularsDiv" style="width: 390px; margin: 0 auto;">
	<div class="sectionDiv" style="margin: 7px auto 0; padding: 5px 0;">
		<table align="center">
			<tr>
				<td>Currency</td>
				<td><input type="text" id="txtCurrencyDesc" readonly="readonly" style="width: 200px; margin-left: 5px;" tabindex="1001"/></td>
			</tr>
			<tr>
				<td>Convert Rate</td>
				<td><input type="text" id="txtCurrencyRt" readonly="readonly" style="width: 200px; margin-left: 5px;" tabindex="1002"/></td>
			</tr>
			<tr>
				<td>Foreign Currency Amt</td>
				<td><input type="text" id="txtFCurrencyAmt" readonly="readonly" style="width: 200px; margin-left: 5px;" tabindex="1003"/></td>
			</tr>
		</table>
		<center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px; width: 100px;" tabindex="1004"/></center>
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("txtCurrencyDesc").focus();
		$("txtCurrencyDesc").value = objGIACS092.currencyDesc;
		$("txtCurrencyRt").value = objGIACS092.currencyRt;
		$("txtFCurrencyAmt").value = objGIACS092.fcurrencyAmt;
		
		$("btnReturn").observe("click", function(){
			overlayForeignCurrency.close();
			delete overlayForeignCurrency;
		});
	} catch (e) {
		showErrorMessage("Error : " , e);
	}
</script>