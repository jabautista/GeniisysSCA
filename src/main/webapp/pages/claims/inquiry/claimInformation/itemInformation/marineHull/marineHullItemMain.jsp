<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div  id="marineHullItemSectionDiv" class="sectionDiv" style="border: 0px;">
	<table border="0" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned" style="width: 120px;">Item No</td>
			<td class="leftAligned">
				<input type="text" id="txtItemNo" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtItemTitle" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned">
				<input type="checkbox" id="totalLossTagMH" style="margin-left: 13px; float: left;" />
				<label for="totalLossTagMH" style="margin-left: 5px; float: left;">Loss Date</label>
			</td>
			<td class="leftAligned">
				<input type="text" id="txtLossDateMH"style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Vessel</td>
			<td class="leftAligned">
				<input type="text" id="txtVesselCd" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtNbtVesselName" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyCd" style="width: 65px; text-align: right;" readonly="readonly">
				<input type="text" id="txtNbtCurrencyDesc" style="width: 173px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Vessel Type</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtVesType" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyRate" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Vessel Class</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtVesClass" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Old Name</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtOldName" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Registered Owner</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtRegOwner" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Prop. Type</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtPropType" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Registered Place</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtRegPlace" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Hull Type</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtHullType" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Gross Tonnage</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtGrossTon" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Nationality</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtCrewNat" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Net Tonnage</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtNetTon" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Vessel Length</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtVesLength" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Dead wt. Tonnage</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtDeadwt" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Vessel Breadth</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtVesBreadth" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">No. of Crew</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtNoCrew" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Vessel Depth</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtVesDepth" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Dry Place</td>
			<td class="leftAligned">
				<input type="text" id="txtDryPlace" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Year Built</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtYrBuilt" style="width: 60px; text-align: right; float: left;" readonly="readonly"/>
				<label style="margin-left: 5px; margin-top: 6px;">Dry Date</label>
				<input type="text" id="txtDryDate" style="margin-left: 5px; width: 120px; float: left;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Geographical Limit</td>
			<td class="leftAligned">
				<input type="text" id="txtGeogLimit" style="width: 250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Deductible Text</td>
			<td class="leftAligned">
				<input type="text" id="txtDeductText" style="width: 250px;" readonly="readonly"/>
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
	showErrorMessage("Claim Information - Marine Hull Item Information", e);
}
</script>