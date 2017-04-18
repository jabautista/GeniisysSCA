<div>
	<table style="margin:5px auto 0px auto;">
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Annual Premium</td>
			<td>
				<input type="text" id="txtDefaultCurrency" name="txtDefaultCurrency" style="width:30px;" readonly="readonly"/>
			</td>
			<td>
				<input type="text" id="txtAnnPremAmt" name="txtAnnPremAmt" style="text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Annual TSI</td>
			<td>
				<input type="text" id="txtDefaultCurrency2" name="txtDefaultCurrency2" style="width:30px;" readonly="readonly"/>			
			</td>
			<td>
				<input type="text" id="txtAnnTsiAmt" name="txtAnnTsiAmt" style="text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div style="text-align:center;margin:10px auto 10px auto;">
					<input type="button" class="button" id="btnOk" value="OK" style="margin:0px auto 0px auto;width:100px;"/>
				</div>
			</td>
		</tr>
	</table>
	
</div>
<script>

	$("txtAnnPremAmt").value = formatCurrency($("hidAnnPremAmt").value);
	$("txtAnnTsiAmt").value = formatCurrency($("hidAnnTsiAmt").value);
	$("txtDefaultCurrency").value = $("hidDefaultCurrency").value;
	$("txtDefaultCurrency2").value = $("hidDefaultCurrency").value;
	$("btnOk").observe("click", function(){
			overlayAnnAmounts.close();
	});
</script>