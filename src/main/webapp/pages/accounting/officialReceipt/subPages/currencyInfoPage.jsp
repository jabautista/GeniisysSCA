<table align="center" style="margin: 10px:">
	<tr>
		<td class="rightAligned" style="width: 180px;">Currency Code</td>
		<td class="leftAligned" style="width: 50px;">
			<input type="text" style="width: 70px; text-align: right" id="txtCurrencyCd" name="txtCurrencyCd" value="${dfltCurrencyCd }"/>
			<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmCurrency" name="oscmCurrency" alt="Go" style="display: none"/>
			<!-- 
				the button for currency LOV is hidden.
				it depends on the page if the currency LOV will be enabled.
				just change the display style of this button if LOV is enabled.
				then add the observe function on your page
			-->
		</td>
		<td></td>
		<td class="rightAligned" style="width: 180px;">Currency Rate</td>
		<td class="leftAligned" style="width: 250px;"><input type="text" style="width: 170px; text-align: right" class="moneyRate" id="txtConvertRate" name="txtConvertRate" value="${dfltCurrencyRt }"  /></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 180px;">Currency Description</td>
		<td class="leftAligned" colspan="2"><input type="text" style="width: 170px; text-align: left" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="${dfltCurrencyDesc }"  /></td>
		<td class="rightAligned" style="width: 180px;">Foreign Currency Amount</td>
		<td class="leftAligned" style="width: 250px;"><input type="text" style="width: 170px; text-align: right" class="money" id="txtForeignCurrAmt" name="txtForeignCurrAmt" value="" /></td>
	</tr>
	<tr>
		<td width="100%" style="text-align: center;" colspan="4">
			<input type="button" style="width: 80px;" id="btnHideCurrPage" 	   class="button" value="Return"/>
		</td>
	</tr>
</table>