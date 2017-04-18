<div align="center" class="sectionDiv" style="width: 597px; margin-top: 5px;">
	<table cellspacing="3" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td>
				<label for="txtCurrCd">Currency</label>
			</td>
			<td>
				<input type="text" id="txtCurrCd" ignoreDelKey="true" name="txtCurrCd" style="width: 40px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="4"  tabindex="1004" readonly="readonly"/>  
			</td>
			<td>
				<input type="text" id="txtCurrDesc" ignoreDelKey="true" name="txtCollectionAmt" style="width: 150px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="4"  tabindex="1004" readonly="readonly"/>  
			</td>
			<td>
				<label for="txtCollectionAmt" style="width: 120px;" class="rightAligned">Collection Amount</label>
			</td>
			<td>
				<input type="text" id="txtCollectionAmt" ignoreDelKey="true" name="txtCollectionAmt" style="width: 170px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="4"  tabindex="1004" readonly="readonly"/>  
			</td>
		</tr>
		<tr>
			<td>
				<label for="txtConvertRate">Convert Rate</label>
			</td>
			<td colspan="2">
				<input type="text" id="txtConvertRate" ignoreDelKey="true" name="txtConvertRate" style="width: 202px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="4"  tabindex="1004" readonly="readonly"/>  
			</td>
			<td>
				<label for="txtDifference" style="width: 120px;" class="rightAligned">Difference</label>
			</td>
			<td>
				<input type="text" id="txtDifference" ignoreDelKey="true" name="txtDifference" style="width: 170px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="4"  tabindex="1004" readonly="readonly"/>  
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnReturn" value="Return" tabindex="201">
	</div>
</div>
<script type="text/javascript">
	
	function closeOverlay(){
		overlayForeignCurrency.close();
		delete overlayForeignCurrency;
	}
	
	$("btnReturn").observe("click", closeOverlay);
	
	$("txtCurrCd").value = objCurrGiacs603.currencyCd;
	$("txtCurrDesc").value = objCurrGiacs603.dspCurrency;
	$("txtCollectionAmt").value = formatCurrency(objCurrGiacs603.fcollectionAmt);
	$("txtConvertRate").value = formatToNthDecimal(objCurrGiacs603.convertRate,9);
	$("txtDifference").value = formatCurrency(objCurrGiacs603.dspDifference);
</script>