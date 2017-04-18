<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div id="casualtyItemMainDiv" class="sectionDiv" style="border: none;">
	<table border="0" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned" style="width: 80px;">Item</td>
			<td class="leftAligned">
				<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 65px; text-align: right;" maxlength="9" readonly="readonly">
				<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned" >
				<input type="checkbox" id="totalLossTagAV" style="float: left; margin-left: 53px;" />
				<label for="totalLossTagAV" style="margin-left: 5px; float: left;">Currency</label>
			</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyCd" style="width: 65px; text-align: right;" readonly="readonly" />
				<input type="text" id="txtNbtCurrencyDesc" style="width: 173px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Aircraft Name</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtVesselName" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyRate" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
		</tr>	
		<tr>
			<td class="rightAligned" >Air Type</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtAirType" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned">
				<input type="text" id="txtLossDateAV" style="width: 250px;" readonly="readonly">
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">RPC No.</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtRpcNo" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Prev. Utilization Hours</td>
			<td class="leftAligned">
				<input type="text" id="txtPrevUtilHrs" style="width: 250px;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Fly Time</td>
			<td class="leftAligned">
				<input type="text" id="txtTotalFlyTime" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Est. Utilization Hours</td>
			<td class="leftAligned">
				<input type="text" id="txtEstUtilHrs" style="width: 250px;" readonly="readonly">
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Purpose</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtPurpose" name="txtPurpose" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtPurpose" id="editTxtPurpose" />
				</div>
			</td>
			<td class="rightAligned" >Qualification</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtQualification" name="txtQualification" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtQualification" id="editTxtQualification" />
				</div>
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Excesses</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtDeductText" name="txtDeductText" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtDeductText" id="editTxtDeductText" />
				</div>
			</td>
			<td class="rightAligned" >Geography Limit</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtGeogLimit" name="txtGeogLimit" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtGeogLimit" id="editTxtGeogLimit" />
				</div>
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
	
	$("editTxtPurpose").observe("click", function(){showEditor("txtPurpose", 2000, 'true');});
	$("editTxtQualification").observe("click", function(){showEditor("txtQualification", 2000, 'true');});
	$("editTxtDeductText").observe("click", function(){showEditor("txtDeductText", 2000, 'true');});
	$("editTxtGeogLimit").observe("click", function(){showEditor("txtGeogLimit", 2000, 'true');});
}catch(e){
	showErrorMessage("Claim Information - Aviation Item Information", e);
}
</script>