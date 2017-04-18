<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div id="otherLinesItemMainDiv" class="sectionDiv" style="border: none;">
	<table width="87%" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned" width="80px">Item No.</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtItemNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtItemTitle" style="width: 588px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Other Info</td>
			<td class="leftAligned" colspan="3">
				<textarea id="txtOtherInfo" style="width: 94%; resize: none;" maxlength="2000" rows="2" readonly="readonly"></textarea>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned" width="238px">
				<input type="text" id="txtCurrencyCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtCurrencyDesc" style="width: 153px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyRate" style="width: 105px; text-align: right; float: left;" readonly="readonly"/>
				<label style="margin-left: 5px; margin-top: 6px;">Loss Date</label>
				<input type="text" id="txtLossDateOL" style="width: 145px; margin-left: 5px;" readonly="readonly"/>
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
		showGICLS260PerilStatus(objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value, $("txtItemNo").value);
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