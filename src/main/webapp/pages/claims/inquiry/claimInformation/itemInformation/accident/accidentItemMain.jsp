<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div id="accidentItemMainDiv" class="sectionDiv" style="border: none;">
	<table width="87%" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned" width="120px">Item No.</td>
			<td class="leftAligned">
				<input type="text" id="txtItemNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtItemTitle" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" width="119px">
				<input type="checkbox" id="totalLossTagAC" style="margin-left: 69px; float: left;" />
				<label for="totalLossTagAC" style="margin-left: 5px; float: left;">Level</label>
			</td>
			<td class="leftAligned">
				<input type="text" id="txtLevelCd" style="width: 65px; text-align: right; float: left;" readonly="readonly"/>
				<label style="margin-left: 5px; margin-top: 6px;">Salary Grade</label>
				<input type="text" id="txtSalaryGrade" style="width: 91px; margin-left: 5px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Grouped Item</td>
			<td class="leftAligned">
				<input type="text" id="txtGroupedItemNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtGroupedItemTitle" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned">
				<input type="text" id="txtLossDateAC" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtCurrencyDesc" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Date of Birth</td>
			<td class="leftAligned">
				<input type="text" id="txtDateOfBirth" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyRate" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Civil Status</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtCivilStat" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Position</td>
			<td class="leftAligned">
				<input type="text" id="txtPositionCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtPosition" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Sex</td>
			<td class="leftAligned">
				<input type="text" id="txtDspSex" style="width: 65px; float: left;" readonly="readonly"/>
				<label style="margin-left: 59px; margin-top: 6px;">Age</label>
				<input type="text" id="txtAge" style="width: 91px; margin-left: 5px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Monthly Salary</td>
			<td class="leftAligned">
				<input type="text" id="txtMonthlySalary" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Amount of Coverage</td>
			<td class="leftAligned">
				<input type="text" id="txtAmountCoverage" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table width="87%" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned" width="120px">Beneficiary</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtBeneficiaryNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtBeneficiaryName" style="width: 572px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Address</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtBeneficiaryAddr" style="width: 649px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Position</td>
			<td class="leftAligned">
				<input type="text" id="txtBenPositionCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtBenPosition" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" width="119px">Civil Status</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtCivilStatus" style="width: 65px; float: left;" readonly="readonly"/>
				<label style="margin-left: 59px; margin-top: 6px;">Sex</label>
				<input type="text" id="txtDspBenSex" style="width: 91px; margin-left: 5px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Relationship</td>
			<td class="leftAligned">
				<input type="text" id="txtRelation" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Date of Birth</td>
			<td class="leftAligned">
				<input type="text" id="txtBenDateOfBirth" style="width: 65px; float: left;" readonly="readonly"/>
				<label style="margin-left: 59px; margin-top: 6px;">Age</label>
				<input type="text" id="txtDspBenAge" style="width: 91px; margin-left: 5px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
	</table>
</div>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Peril Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="perilListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/perilInfoListing.jsp"></jsp:include>
</div>
<div class="buttonsDiv" style="margin-bottom: 10px">
	<table align="center" cellpadding="1">
		<tr>
			<td><input type="button" id="btnPerilStatus"	name="btnPerilStatus"     style="width: 100px;" class="disabledButton"	value="Peril Status" /></td>
			<td><input type="button" id="btnViewPictures"   name="btnViewPictures"    style="width: 100px;" class="disabledButton"	value="View Pictures" /></td>
		</tr>
	</table>			
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	
	$("btnPerilStatus").observe("click", function(){
		showGICLS260PerilStatus((objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value), $("txtItemNo").value);
	});
	
	$("btnViewPictures").observe("click", function(){
		var itemNo = $("txtItemNo").value;
		if(nvl(itemNo, "") == ""){
			showMessageBox("Please select an item first.", "I");
			return false;
		}
		viewAttachMediaModal("clmItemInfo");
	});
}catch(e){
	showErrorMessage("Claim Information - Marine Cargo Item Information", e);
}
</script>