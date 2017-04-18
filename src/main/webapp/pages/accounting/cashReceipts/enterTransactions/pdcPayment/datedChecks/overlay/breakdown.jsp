<div align="center" class="sectionDiv" style="width: 400px; margin-top: 5px;">
	<table cellspacing="3" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td><label style="width: 100px; text-align: right;" >Premium Amount</label></td>
			<td class="leftAligned">
				<input id="txtPremAmt" type="text" ignoreDelKey="1" class="rightAligned" style="width: 130px;" tabindex="101" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td><label style="width: 100px; text-align: right;" >Tax Amount</label></td>
			<td class="leftAligned">
				<input id="txtTaxAmt" type="text" ignoreDelKey="1" class="rightAligned" style="width: 130px;" tabindex="102" readonly="readonly">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnReturn2" value="Return" tabindex="201">
	</div>
</div>
<script type="text/javascript">
	var objParams = JSON.parse('${objectParams}');
	
	$("txtPremAmt").value = formatCurrency(objParams.premiumAmt);
	$("txtTaxAmt").value = formatCurrency(objParams.taxAmt);
	
	$("btnReturn2").observe("click", function(){
		overlayBreakdown.close();
		delete overlayBreakdown;
	});
</script>