<!-- Created by hdrtagudin 07302015 SR 18751 - Initial Acceptance -->
<div id="initialAcceptanceSectionDiv" style="margin: 0px auto 0px auto;">
	<div id="initialAcceptanceOuterDiv" class="sectionDiv"
		style="border: none;">
		<div id="initialAcceptanceInnerDiv" style="border: none;"
			class="sectionDiv">
						<table cellspacing="2" border="0" style="margin:25px auto;">
							<tbody>
				<tr>
					<td class="rightAligned" style="width: 120px;">Policy No. </td>
					<td class="leftAligned" style="width: 250px;"><input
						type="text" id="txtPolicyNo" style="width: 250px;" tabindex=""
						readonly="readonly" /></td>
					<td class="rightAligned" style="width:120px;">Endorsement No. </td>
					<td class="leftAligned" style="width: 250px;"><input
						type="text" id="txtEndtNo" style="width: 250px;" tabindex=""
						readonly="readonly" /></td>
				</tr>
				<tr>

					<td class="rightAligned" style="width: 120px;">PAR No. </td>
					<td class="leftAligned"><input type="text" id="txtParNo"
						style="width: 250px;" tabindex="" readonly="readonly" /></td>
					<td class="rightAligned">Assured </td>
					<td class="leftAligned"><input type="text" id="txtAssured"
						style="width: 250px;" tabindex="" readonly="readonly" /></td>
				</tr>
				<tr>
				<td colspan='4'> </td>
				</tr>
				</table>
			<div id="bodyDiv" class="sectionDiv" style="border: 0px;">
					<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned" style="width:140px;">Acceptance No. </td>
					<td class="leftAligned" style="width: 200px;"><input
						type="text" id="txtAcceptanceNo" style="width: 200px;" tabindex=""
						readonly="readonly" /></td>
					<td class="rightAligned" style="width:140px;">Ref. Accept No. </td>
					<td class="leftAligned" style="width: 200px;"><input
						type="text" id="txtRefAcceptNo" style="width: 200px;" tabindex=""
						readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:140px;">Accepted By </td>
					<td class="leftAligned"><input type="text" id="txtAcceptedBy"
						style="width: 200px;" tabindex="" readonly="readonly" /></td>
					<td class="rightAligned" style="width: 140px;">Accept Date </td>
					<td class="leftAligned"><input type="text" id="txtAcceptDate"
						style="width: 200px;" tabindex="" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:140px;">Ceding Company </td>
					<td class="leftAligned"><input type="text"
						id="txtCedingCompany" style="width: 200px;" tabindex=""
						readonly="readonly" /></td>
					<td class="rightAligned" style="width:140px;">Reassured </td>
					<td class="leftAligned"><input type="text" id="txtReassured"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:140px;">RI Policy No. </td>
					<td class="leftAligned"><input type="text" id="txtRiPolNo"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
					<td class="rightAligned" style="width:140px;">RI Binder No. </td>
					<td class="leftAligned"><input type="text" id="txtRiBinderNo"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:140px;">RI Endt. No. </td>
					<td class="leftAligned"><input type="text" id="txtRiEndtNo"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
					<td class="rightAligned" style="width:140px;">Date Offered </td>
					<td class="leftAligned"><input type="text" id="txtDateOffered"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:140px;">Orig. TSI Amount </td>
					<td class="leftAligned"><input type="text" id="txtOrigTSIAmt"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
					<td class="rightAligned" style="width:140px;">Orig. Premium </td>
					<td class="leftAligned"><input type="text" id="txtOrigPremium"
						style="width: 200px; text-align: right;" tabindex=""
						readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:140px;">Remarks </td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv"
							style="float: left; width: 566px; border: 1px solid gray; height: 22px; margin-top: 2px;">
							<textarea
								style="float: left; height: 16px; width: 540px; margin-top: 0; border: none; resize:none;"
								id="txtRemarks" name="txtRemarks" maxlength="4000"
								onkeyup="limitText(this,4000);" tabindex="" readonly="readonly"
								ignoreDelKey="true"></textarea>
							<img
								src="${pageContext.request.contextPath}/images/misc/edit.png"
								style="width: 14px; height: 14px; margin: 3px; float: right;"
								alt="Edit" id="editRemarks" tabindex="205" />
						</div>
					</td>
				</tr>
			</table>
		</div>

	<div style="text-align: center;">

		<input type="button" class="button" id="btnReturn" value="Return"
			style="width: 100px;" />
	</div>
</div>

<script>
initializeAll();
var obj = new Object();
obj = JSON.parse('${json}'.replace(/\\/g,'\\\\'));
//console.log(obj.riPolicyNo + ' ');
populateInitialAcceptance(obj);

function populateInitialAcceptance(obj){

	$("txtPolicyNo").value  		= (obj == null ? "" : nvl(obj.policyNo,""));
	$("txtParNo").value  			= (obj == null ? "" : nvl(obj.parNo,""));
	$("txtEndtNo").value  			= (obj == null ? "" : nvl(obj.endtNo,""));
	$("txtAssured").value 	 		= (obj == null ? "" : unescapeHTML2(nvl(obj.assdName,"")));
	$("txtAcceptanceNo").value  	= (obj == null ? "" : nvl(obj.acceptNo,""));
	$("txtRiPolNo").value  			= (obj == null ? "" : unescapeHTML2(nvl(obj.riPolicyNo,"")));
	$("txtAcceptedBy").value  		= (obj == null ? "" : unescapeHTML2(nvl(obj.acceptBy,"")));
	$("txtCedingCompany").value  	= (obj == null ? "" : unescapeHTML2(nvl(obj.riName,"")));
	$("txtRiEndtNo").value  		= (obj == null ? "" : unescapeHTML2(nvl(obj.riEndtNo,"")));
	$("txtOrigTSIAmt").value  		= (obj == null ? "" : formatCurrency(nvl(obj.origTSIAmt,"")));
	$("txtRefAcceptNo").value  		= (obj == null ? "" : unescapeHTML2(nvl(obj.refAcceptNo,"")));
	$("txtRiBinderNo").value  		= (obj == null ? "" : unescapeHTML2(nvl(obj.riBinderNo,"")));
	$("txtAcceptDate").value  		= (obj == null ? "" : nvl(obj.acceptDate,""));
	$("txtReassured").value  		= (obj == null ? "" : unescapeHTML2(nvl(obj.reassured,"")));
	$("txtDateOffered").value  		= (obj == null ? "" : nvl(obj.offerDate,""));
	$("txtOrigPremium").value  		= (obj == null ? "" : formatCurrency(nvl(obj.origPremAmt,"")));
	$("txtRemarks").value  			= (obj == null ? "" : unescapeHTML2(nvl(obj.remarks,"")));
	
}

	$("editRemarks").observe("click", function () {
			showEditor("txtRemarks", 2000, 'true');
		});

	$("btnReturn").observe("click", function() {
		overlayInitialAcceptance.close();
	});
</script>