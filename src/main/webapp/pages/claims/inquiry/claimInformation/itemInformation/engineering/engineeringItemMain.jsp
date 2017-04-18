<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div  id="engineeringItemSectionDiv" class="sectionDiv" style="border: 0px;">
	<table border="0" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned">Item No</td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtItemNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtItemTitle" style="width: 460px;" readonly="readonly"/>
				<input type="checkbox" id="totalLossTagEN"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Description</td>
			<td class="leftAligned" colspan="3">
				<!-- <input type="text" id="txtItemDesc" style="width: 562px;" readonly="readonly"/> -->
				<div id="txtItemDescDiv" style="border: 1px solid gray; height: 20px; width: 568px;">
					<textarea readonly="readonly" id="txtItemDesc" style="width: 540px; border: none; height: 13px;" maxlength="2000"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtItemDesc" />
				</div>
			</td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned" colspan="3">
				<!-- <input type="text" id="txtItemDesc2" style="width: 562px;" readonly="readonly"/> -->
				<div id="txtItemDesc2Div" style="border: 1px solid gray; height: 20px; width: 568px;">
					<textarea readonly="readonly" id="txtItemDesc2" style="width: 540px; border: none; height: 13px;" maxlength="2000"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtItemDesc2" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Region</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtRegion" style="width: 243px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Province</td>
			<td class="leftAligned">
				<input type="text" id="txtNbtProvince" style="width: 243px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="txtNbtCurrencyDesc" style="width: 166px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned">
				<input type="text" id="txtLossDateEN" style="width: 243px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned">
				<input type="text" id="txtCurrencyRate" style="width: 243px; text-align: right;" readonly="readonly"/>
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
	initializeAll(); //added by steven 6/3/2013
	
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
	$("editTxtItemDesc").observe("click", function(){
		showEditor("txtItemDesc", 2000,'true');
	});
	$("editTxtItemDesc2").observe("click", function(){
		showEditor("txtItemDesc2", 2000,'true');
	});
}catch(e){
	showErrorMessage("Claim Information - Engineering Item Information", e);
}
</script>