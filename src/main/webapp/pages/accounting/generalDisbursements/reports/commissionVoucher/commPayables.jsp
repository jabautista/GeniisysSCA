<div id="commInvoiceDiv" class="" style="width: 650px; margin: 5px 0;">
	<div class="sectionDiv" style="padding: 10px 20px 10px 20px;">
		<table align="center" border="0" style="border-spacing: 0; border-collapse: collapse;">
			<tr>
				<td class="rightAligned">
					Invoice No.
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtInvoiceBranchCd" readonly="readonly" style="width: 55px;" />
					<input type="text" id="txtInvoicePremSeqNo" readonly="readonly" style="width: 111px; text-align: right;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					Intermediary
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtIntermediary2" readonly="readonly" style="width: 511px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					Assured
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtAssured" readonly="readonly" style="width: 511px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					Policy No.
				</td>
				<td style="padding-left: 5px;" colspan="3">
					<input type="text" id="txtPolicyNo" readonly="readonly" style="width: 511px;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					Collection Amount
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtCollectionAmt" readonly="readonly" style="margin-right: 20px; width: 180px; text-align: right;" />
				</td>
				<td class="rightAligned">
					Commission Amount
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtCommissionAmt" readonly="readonly" style="width: 180px; text-align: right;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					Premium Amount
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtPremiumAmt" readonly="readonly" style="margin-right: 20px; width: 180px; text-align: right;" />
				</td>
				<td class="rightAligned">
					Tax Withheld
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtTaxWithheld" readonly="readonly" style="width: 180px; text-align: right;" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					Tax Amount
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtTaxAmt" readonly="readonly" style="margin-right: 20px; width: 180px; text-align: right;" />
				</td>
				<td class="rightAligned">
					Input VAT
				</td>
				<td style="padding-left: 5px;">
					<input type="text" id="txtInputVat" readonly="readonly" style="width: 180px; text-align: right;"/>
				</td>
			</tr>
			
			<!-- <tr>
				
			</tr> -->
		</table>
		<div style="margin: 20px auto 5px;">
			<table align="center" border="0" style="border-spacing: 0; border-collapse: collapse;">
				<tr>
				<td class="rightAligned" colspan="2">
					Net Amount
				</td>
				<td style="padding-left: 5px;" colspan="2">
					<input type="text" id="txtNetAmt" readonly="readonly" style="width: 180px; text-align: right;"/>
				</td>
			</tr>
			</table>
		</div>
	</div>
	<div style="float: left; width: 100%; text-align: center; padding: 0 20px 0 20px;">
		<input type="button" class="button" id="btnReturn" value="Return" style="float: none; margin-top: 10px; width: 120px;" />
	</div> 
</div>
<script>
	try {
		
		var jsonCommPayables = JSON.parse('${jsonCommPayables}');
		if(jsonCommPayables.nullCheck != 'Y') {
			$("txtInvoiceBranchCd").value = objGIACS155.branchCd;
			$("txtInvoicePremSeqNo").value = formatNumberDigits(objGIACS155.premSeqNo, 8);
			$("txtIntermediary2").value = unescapeHTML2(objGIACS155.intmName);
			$("txtAssured").value = unescapeHTML2(jsonCommPayables.assdName);
			$("txtPolicyNo").value = objGIACS155.policyNo;
			$("txtCollectionAmt").value = formatCurrency(jsonCommPayables.collectionAmt);
			$("txtPremiumAmt").value = formatCurrency(jsonCommPayables.premiumAmt);
			$("txtTaxAmt").value = formatCurrency(jsonCommPayables.taxAmt);
			$("txtCommissionAmt").value = formatCurrency(jsonCommPayables.commissionAmt);
			$("txtTaxWithheld").value = formatCurrency(jsonCommPayables.wholdingTax);
			$("txtInputVat").value = formatCurrency(jsonCommPayables.vatAmt);
			$("txtNetAmt").value = formatCurrency(jsonCommPayables.netAmt);
			$("txtInvoiceBranchCd").focus();
		} else {
			$("txtInvoiceBranchCd").value = objGIACS155.branchCd;
			$("txtInvoicePremSeqNo").value = formatNumberDigits(objGIACS155.premSeqNo, 8);
			$("txtIntermediary2").value = "";
			$("txtAssured").value = "";
			$("txtPolicyNo").value = "";
			$("txtCollectionAmt").value = "0.00";
			$("txtPremiumAmt").value = "0.00";
			$("txtTaxAmt").value = "0.00";
			$("txtCommissionAmt").value = "0.00";
			$("txtTaxWithheld").value = "0.00";
			$("txtInputVat").value = "0.00";
			$("txtNetAmt").value = "0.00";
			$("txtInvoiceBranchCd").focus();
		}		
		
		$("btnReturn").observe("click", function(){
			delete jsonCommPayables;
			overlayCommPayable.close();
			delete overlayCommPayable;
		});
		
		initializeAll();
		hideNotice();
	} catch (e) {
		showErrorMessage("Commission Payables Overlay : ", e);
	}
</script>