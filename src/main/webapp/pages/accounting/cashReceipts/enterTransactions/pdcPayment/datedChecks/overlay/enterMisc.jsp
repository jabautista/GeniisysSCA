<div align="center" class="sectionDiv" style="width: 550px; margin-top: 5px;">
	<table cellspacing="10" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<th><label style="width: 100px; text-align: right;" >Gross Amount</label></th>
			<th><label style="width: 100px; text-align: right;" >Comm. Amount</label></th>
			<th><label style="width: 100px; text-align: right;" >V.A.T. Amount</label></th>
		</tr>
		<tr>
			<td class="rightAligned">
				<input id="txtGrossAmt" type="text" ignoreDelKey="1" class=" " style="width: 80px;" tabindex="101" maxlength="30" readonly="readonly">
			</td>
			<td class="rightAligned">
				<input id="txtCommissionAmt" type="text" ignoreDelKey="1" class=" " style="width: 80px;" tabindex="102" maxlength="30" readonly="readonly"> 
			</td>
			<td class="rightAligned">
				<input id="txtVATAmt" type="text" ignoreDelKey="1" class=" " style="width: 80px;" tabindex="103" maxlength="30" readonly="readonly">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnReturn" value="Return" tabindex="201">
	</div>
</div>
<script type="text/javascript">
	var objParams = JSON.parse('${objectParams}');
	
	$("txtGrossAmt").value = formatCurrency(objParams.grossAmt);
	$("txtCommissionAmt").value = formatCurrency(objParams.commissionAmt);
	$("txtVATAmt").value = formatCurrency(objParams.vatAmt);
	
	function closeOverlay(){
		overlayEnterMisc.close();
		delete overlayEnterMisc;
	}
	
	$("btnReturn").observe("click", closeOverlay);
</script>