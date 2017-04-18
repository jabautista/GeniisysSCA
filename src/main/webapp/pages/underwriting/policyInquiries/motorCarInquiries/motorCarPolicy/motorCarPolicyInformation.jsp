<div id="policyInformationDiv" name="policyInformationDiv">
	<div class="sectionDiv" style="width:98%; margin-top: 10px; margin-bottom: 10px; margin-left: 6px; margin-right: 5px;">
		<div id="policyInformationFormDiv" name="policyInformationFormDiv" align="center" style="margin-top: 10px; margin-left: 10px; margin-right: 10px; margin-bottom: 10px;">
			<table style="float: left; padding-left: 68px;">
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Policy No.</td>
					<td class="leftAligned" style="padding-right: 30px;">
						<input type="text" id="txtPolicyNo" name="txtPolicyNo" readonly="readonly" style="width: 295px;" tabindex="301"/>
					</td>
					<td class="rightAligned" style="padding-right: 3px;">Endorsement No</td>
					<td class="leftAligned">
						<input type="text" id="txtEndtNo" name="txtEndtNo" readonly="readonly" style="width: 180px;" tabindex="302"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Assured</td>
					<td class="leftAligned" colspan="3">
						<input type="text" id="txtAssured" name="txtAssured" readonly="readonly" style="width: 614px;" tabindex="303"/>
					</td>
				</tr>
			</table>
			<table style="float: left; padding-left: 73px;">
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Item No.</td>
					<td class="leftAligned" style="padding-right: 2px;">
						<input type="text" id="txtItemNo" name="txtItemNo" readonly="readonly" style="width: 60px; text-align: right;" tabindex="304"/>
					</td>
					<td class="leftAligned">
						<input type="text" id="txtItemDesc" name="txtItemDesc" readonly="readonly" style="width: 544px;" tabindex="305"/>
					</td>
				</tr>
			</table>
			<table style="float: left; padding-left: 23px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Period of Cover</td>
					<td class="leftAligned" style="padding-right: 115px;">
						<input type="text" id="txtPeriodOfCover" name="txtPeriodOfCover" readonly="readonly" style="width: 220px;" tabindex="306"/>
					</td>
					<td class="rightAligned" style="padding-right: 3px;">To</td>
					<td class="leftAligned">
						<input type="text" id="txtTo" name="txtTo" readonly="readonly" style="width: 182px;" tabindex="307"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 3px;">Ann Sum Insured</td>
					<td class="leftAligned" style="padding-right: 115px;">
						<input type="text" id="txtAnnSumInsured" name="txtAnnSumInsured" readonly="readonly" style="width: 220px; text-align: right;" tabindex="308"/>
					</td>
					<td class="rightAligned" style="padding-right: 3px;">Ann Prem Amt</td>
					<td class="leftAligned">
						<input type="text" id="txtAnnPremAmt" name="txtAnnPremAmt" readonly="readonly" style="width: 182px; text-align: right;" tabindex="309"/>
					</td>
				</tr>
			</table>
			<div style="margin-top: 10px; float: left; margin-left: 130px; margin-bottom: 10px;">
				<table>
					<tr>
						<td></td>
						<td class="rightAligned" colspan="1">
							<div style="float: left; margin-right: 90px;">
							<input type="checkbox" id="chkPaid" name="chkPaid" style="float: left; margin: 0pt; width: 13px; height: 13px;" disabled="disabled"/>
							<label for="chkPaid" style="float: left; margin-left: 3px;" tabindex="310">Paid</label>
							</div>
							<input type="checkbox" id="chkWithClaim" name="chkWithClaim" style="float: left; margin: 0pt; width: 13px; height: 13px;" disabled="disabled"/>
							<label for="chkWithClaim" style="float: left; margin-left: 3px;" tabindex="311">With Claim</label>
						</td>
					</tr>
				</table>	
			</div>
		</div>
	</div>
	<div style="text-align: center;">
		<input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnReturn" name="btnReturn" value="Return" />
	</div>
</div>

<script type="text/JavaScript">

	makeInputFieldUpperCase();
	initializeAll();
	
	$("txtPolicyNo").value = objGIPIS116.policyNo;
	$("txtEndtNo").value = objGIPIS116.endtNo;
	$("txtAssured").value = objGIPIS116.assured;
	$("txtItemNo").value = objGIPIS116.itemNo;
	$("txtItemDesc").value = objGIPIS116.itemTitle;
	$("txtPeriodOfCover").value = objGIPIS116.fromDate;
	$("txtTo").value = objGIPIS116.toDate;
	$("txtAnnSumInsured").value = objGIPIS116.annTsiAmt;
	$("txtAnnPremAmt").value = objGIPIS116.annPremAmt;
	$("chkPaid").checked = objGIPIS116.piadTag == "Y" ? true : false;
	$("chkWithClaim").checked = objGIPIS116.claimTag == "Y" ? true : false;
		
	$("btnReturn").observe("click", function() {
		overlayPolicyInformation.close();
	});

</script>