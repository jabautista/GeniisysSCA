<div>
	<table style="margin:5px auto 0px auto;">
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Annual Premium</td>
			<td>
				<input type="text" id="txtItemDefaultCurrency" name="txtItemDefaultCurrency" style="width:30px;" readonly="readonly"/>
			</td>
			<td>
				<input type="text" id="txtItemAnnPremAmt" name="txtItemAnnPremAmt" style="text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Annual TSI</td>
			<td>
				<input type="text" id="txtItemDefaultCurrency2" name="txtItemDefaultCurrency2" style="width:30px;" readonly="readonly"/>			
			</td>
			<td>
				<input type="text" id="txtItemAnnTsiAmt" name="txtItemAnnTsiAmt" style="text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div style="text-align:center;margin:10px auto 10px auto;">
					<input type="button" class="button" id="btnItemAnnAmtOk" value="OK" style="margin:0px auto 0px auto;width:100px;"/>
				</div>
			</td>
		</tr>
	</table>
	
</div>
<script>

	$("txtItemAnnPremAmt").value = $("txtAnnPremium").value;
	$("txtItemAnnTsiAmt").value = $("txtAnnSumInsured").value;
	$("txtItemDefaultCurrency").value = $("hidDefaultCurrency").value;
	$("txtItemDefaultCurrency2").value = $("hidDefaultCurrency").value;
	$("btnItemAnnAmtOk").observe("click", function(){
		overlayItemAnnualizedAmt.close();
	});
</script>