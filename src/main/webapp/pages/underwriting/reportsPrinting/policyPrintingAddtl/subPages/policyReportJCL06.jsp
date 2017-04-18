<div style="width: 405px; float: left;">
	<table align="center" style="">
		<tr>
			<td class="rightAligned" width="120px">Bond Title </td>
			<td class="leftAligned" width="">
				<input type="text" id="bondTitle" name="bondTitle" style="margin-left: 10px; width: 200px;" value="${bondTitle}" maxlength="200"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Reason </td>
			<td class="leftAligned" width="">
				<input type="text" id="reason" name="reason" style="margin-left: 10px; width: 200px;" value="${reason}"  maxlength="1000"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="">Savings Account No. </td>
			<td class="leftAligned" width="">
				<input type="text" id="savingsAcctNo" name="savingsAcctNo" style="margin-left: 10px; width: 200px;" value="${savingsAcctNo}"  maxlength="30"/>
			</td>
		</tr>
	</table>
</div>
<script>
	$("bondTitle").focus();
</script>