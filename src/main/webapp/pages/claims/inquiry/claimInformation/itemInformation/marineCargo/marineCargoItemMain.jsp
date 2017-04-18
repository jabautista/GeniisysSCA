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
			<td class="rightAligned" width="100px">
				<input type="checkbox" id="totalLossTagMN" style="margin-left: 27px; float: left;" />
				<label for="totalLossTagMN" style="margin-left: 5px; float: left;">Currency</label>
			</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtCurrencyDesc" style="width: 173px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Carrier</td>
			<td class="leftAligned">
				<input type="text" id="txtVesselCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtVesselName" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyRate" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Geog. Desc</td>
			<td class="leftAligned">
				<input type="text" id="txtGeogCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtGeogDesc" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">LC No.</td>
			<td class="leftAligned">
				<input type="text" id="txtLcNo" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Cargo Class</td>
			<td class="leftAligned">
				<input type="text" id="txtCargoClassCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtCargoDesc" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">BL/AWB</td>
			<td class="leftAligned">
				<input type="text" id="txtBlAwb" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Type of Packing</td>
			<td class="leftAligned">
				<input type="text" id="txtPackMethod" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Cargo Type</td>
			<td class="leftAligned">
				<input type="text" id="txtCargoType" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Tranship Origin</td>
			<td class="leftAligned">
				<input type="text" id="txtTranshipOrigin" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Origin</td>
			<td class="leftAligned">
				<input type="text" id="txtOrigin" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Tranship Destn</td>
			<td class="leftAligned">
				<input type="text" id="txtTranshipDestination" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Destination</td>
			<td class="leftAligned">
				<input type="text" id="txtDestn" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Voyage No.</td>
			<td class="leftAligned">
				<input type="text" id="txtVoyageNo" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">ETD</td>
			<td class="leftAligned">
				<input type="text" id="txtEtd" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Deductible/Remarks</td>
			<td class="leftAligned">
				<input type="text" id="txtDeductText" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">ETA</td>
			<td class="leftAligned">
				<input type="text" id="txtEta" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned"></td>
			<td class="leftAligned"></td>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned">
				<input type="text" id="txtLossDateMN" style="width: 250px;" readonly="readonly"/>
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
	showErrorMessage("Claim Information - Accident Item Information", e);
}
</script>