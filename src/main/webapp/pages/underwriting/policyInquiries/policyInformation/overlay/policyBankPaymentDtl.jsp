
<table style="width:600px;margin:10px; auto 0 auto;" cellspacing="2">
	<tr>
		<td style="width:140px; padding-right: 5px;" class="rightAligned">Company</td>
		<td style="width:60px;">
			<input type="text" id="txtCompanyCd" name="txtCompanyCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td>
			<input type="text" id="txtCompanyName" name="txtCompanyName" style="width:98%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="padding-right: 5px;">Employee</td>
		<td>
			<input type="text" id="txtEmployeeCd" name="txtEmployeeCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td>
			<input type="text" id="txtEmployeeName" name="txtEmployeeName" style="width:98%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="padding-right: 5px;">Bank Reference Number</td>
		<td colspan="2">
			<input type="text" id="txtBankRefNo" name="txtBankRefNo" style="width:98.4%;" readonly="readonly"/>
		</td>
	</tr>
</table>
<div style="text-align:center;">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px;"/>
</div>

<script>

	try{
		
		var objPolBankPaymentDtl = JSON.parse('${polBankPaymentDtl}'.replace(/\\/g, '\\\\'));
		
	}catch(e){}

	if(objPolBankPaymentDtl != null){
		
		$("txtCompanyCd").value		= objPolBankPaymentDtl.companyCd;
		$("txtCompanyName").value	= unescapeHTML2(objPolBankPaymentDtl.companyName);
		$("txtEmployeeCd").value	= objPolBankPaymentDtl.employeeCd;
		$("txtEmployeeName").value	= unescapeHTML2(objPolBankPaymentDtl.employeeName);
		$("txtBankRefNo").value		= unescapeHTML2(objPolBankPaymentDtl.bankRefNo);
		
	}
	
	$("btnReturn").observe("click", function(){
		overlayBankPaymentDtl.close();
	});

</script>