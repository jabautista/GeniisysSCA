<div style="width:350px;margin:10px auto 10px auto" id="openPolicyOverlayDiv">
	<table width="350px;">
		<tr>
			<td colspan="6">Reference Open Policy No.</td>
		</tr>
		<tr>
			<td colspan="6">
				<input type="text" id="txtOpenPolRefOpenPolNo" style="width:96.9%"/>
			</td>
		</tr>
		<tr>
			<td colspan="6">Open Policy Info</td>
		</tr>
		<tr>
			<td style="width:35px">
				<input type="text" id="txtOpenPolLineCd" style="width:75%;"/>
			</td>
			<td style="width:60px">
				<input type="text" id="txtOpenPolOpSublineCd" style="width:85%;"/>
			</td>
			<td style="width:35px">
				<input type="text" id="txtOpenPolOpIssCd" style="width:75%;"/>
			</td>
			<td style="width:35px">
				<input type="text" id="txtOpenPolOpIssueYy" style="width:75%;"/>
			</td>
			<td style="width:60px">
				<input type="text" id="txtOpenPolOpPolSeqNo" style="width:85%;"/>
			</td>
			<td style="width:35px">
				<input type="text" id="txtOpenPolRenewNo" style="width:75%;"/>
			</td>
		</tr>
		<tr>
			<td colspan="6">Declaration Number</td>
		</tr>
		<tr>
			<td colspan="6">
				<input type="text" id="txtOpenPolDecltnNo" style="width:96.9%"/>
			</td>
		</tr>
	</table>
</div>

<div style="text-align:center;">
	<input type="button" class="button" id="btnReturnOpenPolicy" name="btnReturnOpenPolicy" value="Ok" style="width:130px;"/>
</div>
<script>

	try{
		
		var objOpenPolicy = JSON.parse('${openPolicy}'.replace(/\\/g, '\\\\'));
		
	}catch(e){}
	
	$$("div#openPolicyOverlayDiv input[type='text']").each(function(obj){
		obj.readOnly = true;
	});

	if(objOpenPolicy != null){

		$("txtOpenPolRefOpenPolNo").value	= objOpenPolicy.refOpenPolNo;
		$("txtOpenPolLineCd").value			= objOpenPolicy.lineCd;
		$("txtOpenPolOpSublineCd").value	= objOpenPolicy.opSublineCd;
		$("txtOpenPolOpIssCd").value		= objOpenPolicy.opIssCd;
		$("txtOpenPolOpIssueYy").value		= objOpenPolicy.opIssueYy;
		$("txtOpenPolOpPolSeqNo").value		= objOpenPolicy.opPolSeqno;
		$("txtOpenPolRenewNo").value		= objOpenPolicy.opRenewNo;
		$("txtOpenPolDecltnNo").value		= objOpenPolicy.decltnNo;
	
	}
	$("btnReturnOpenPolicy").observe("click", function(){
		openPolicyOverlay.close();
	});
</script>