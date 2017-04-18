<div class="sectionDiv" style="width: 317px; padding: 10px auto; margin: 10px auto;">
	<table align="center" cellspacing="5px" style="margin: 0 auto;">
		<tr>
			<td style="text-align: center;">
				<span>This Transaction No. :</span>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;">
				<span id="oldTranNoSpan"></span>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;">
				<span>Had Been Copied To New Transaction No. :</span>
			</td>
		</tr>
		<tr>
			<td style="text-align: center;">
				<span id="newTranNoSpan"></span>
			</td>
		</tr>
		<tr height="30px;" valign="bottom">
			<td>
				Process finished. Copy another journal voucher?
			</td>
		</tr>
		<tr height="35px;" valign="middle">
			<td style="text-align: center;">
				<input type="button" class="button" id="btnYes" value="Yes" style="width: 50px;" />
				<input type="button" class="button" id="btnNo" value="No" style="width: 50px;" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript" >
	$("oldTranNoSpan").innerHTML = "<strong>" + objGIACS051.oldTranNo + "</strong>";
	$("newTranNoSpan").innerHTML = "<strong>" + objGIACS051.newTranNo + "</strong>";
	
	$("btnYes").observe("click", function() {
		$("txtBranchCdFrom").focus();
		$("txtDocumentYearFrom").readOnly = true;
		$("txtDocumentMmFrom").readOnly = true;
		$("txtDocSeqNoFrom").readOnly = true;
		$("txtDocumentYearTo").readOnly = true;
		$("txtDocumentMmTo").readOnly = true;
		disableSearch("imgDocumentYearFrom");
		disableSearch("imgDocSeqNoFrom");
		disableDate("imgTranDate");
		$("imgTranDate").next().setStyle({margin : "1px 1px 0 0", cursor : "pointer"});
		disableButton("btnCopy");
		disableButton("btnEdit");
		enableSearch("imgBranchCdFrom");
		
		$("txtBranchCdFrom").clear();
		$("txtDocumentYearFrom").clear();
		$("txtDocumentMmFrom").clear();
		$("txtDocSeqNoFrom").clear();
		$("txtDocumentYearTo").clear();
		$("txtDocumentMmTo").clear();
		$("txtBranchCdTo").clear();
		$("txtTranDate").clear();
		
		objGIACS051 = new Object();
		overlayNewTransactionNo.close();
		delete overlayNewTransactionNo;
	});
	
	$("btnNo").observe("click", function() {
		disableButton("btnCopy");
		enableButton("btnEdit");
		disableDate("imgTranDate");
		disableSearch("imgBranchCdFrom");
		disableSearch("imgDocumentYearFrom");
		disableSearch("imgDocSeqNoFrom");
		disableSearch("imgBranchCdTo");
		//objGIACS051 = new Object();
		overlayNewTransactionNo.close();
		delete overlayNewTransactionNo;
	});
</script>