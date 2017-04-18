<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div id="casualtyItemMainDiv" class="sectionDiv" style="border: none;">
	<table width="87%" style="margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned" width="120px">Item No.</td>
			<td class="leftAligned">
				<input type="text" id="txtItemNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="itemTitle" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">
				<input type="checkbox" id="totalLossTagCA" style="float: left;" />
				<label for="totalLossTagCA" style="float: left;">Amount of Coverage</label>
			</td>
			<td class="leftAligned">
				<input type="text" id="amountCoverage" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Grouped Item</td>
			<td class="leftAligned">
				<input type="text" id="groupedItemNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="groupedItemTitle" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Property</td>
			<td class="leftAligned">
				<input type="text" id="propertyNoType" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="propertyNo" style="width: 173px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency</td>
			<td class="leftAligned">
				<input type="text" id="currencyCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="currencyDesc" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Location</td>
			<td class="leftAligned">
				<input type="text" id="location" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Currency Rate</td>
			<td class="leftAligned">
				<input type="text" id="currencyRate" style="width: 250px; text-align: right;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Conveyance</td>
			<td class="leftAligned">
				<input type="text" id="conveyanceInfo" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Position</td>
			<td class="leftAligned">
				<input type="text" id="capacityCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="position" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Interest on Premises</td>
			<td class="leftAligned">
				<!-- <input type="text" id="interestOnPremises" style="width: 250px;" readonly="readonly"/> -->
				<div id="interestOnPremisesDiv" style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea readonly="readonly" id="interestOnPremises" style="width: 230px; border: none; height: 13px;" maxlength="500"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editInterestOnPremises" />
				</div>
				
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Section or Hazard</td>
			<td class="leftAligned">
				<input type="text" id="sectionOrHazardTitle" style="width: 65px; text-align: right;" readonly="readonly"/><!-- ito talaga ung title sa fmb :| -->
				<input type="text" id="sectionOrHazardCd" style="width: 173px;" readonly="readonly"/>
			</td>
			<td class="rightAligned">Limit of Liability</td>
			<td class="leftAligned">
				<!-- <input type="text" id="limitOfLiability" style="width: 250px;" readonly="readonly"/> -->
				<div id="limitOfLiabilityDiv" style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea readonly="readonly" id="limitOfLiability" style="width: 230px; border: none; height: 13px;" maxlength="500"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editLimitOfLiability" />
				</div>
			</td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned">
				<!-- <input type="text" id="sectionOrHazardInfo" style="width: 250px;" readonly="readonly"/> -->
				<div id="sectionOrHazardInfoDiv" style="border: 1px solid gray; height: 20px; width: 256px;">
					<textarea readonly="readonly" id="sectionOrHazardInfo" style="width: 230px; border: none; height: 13px;" maxlength="2000"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editSectionOrHazardInfo" />
				</div>
			</td>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned">
				<input type="text" id="lossDateCA" style="width: 250px;" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<div class="sectionDiv" style="margin-left: 205px; margin-right: 20px; margin-bottom: 30px; width: 120px; height: 65px;">
		<div class="sectionDiv" style="margin-top: 14px; border: none;">
			<input type="radio" id="beneficiary" name="detail" style="margin-left: 20px; float: left;" checked="checked" disabled="disabled"/> <!-- benjo 09.08.2015 GENQA-SR-4874 added disabled -->
			<label for="beneficiary" style="margin-top: 3px;">Beneficiary</label>
		</div>
		<div class="sectionDiv" style="border: none;">
			<input type="radio" id="personnel" name="detail" style="margin-left: 20px; float: left;" disabled="disabled"/> <!-- benjo 09.08.2015 GENQA-SR-4874 added disabled -->
			<label for="personnel" style="margin-top: 3px;">Personnel</label>
		</div>
	</div>
	<table width="43%">
		<tr>
			<td class="rightAligned">Personnel</td>
			<td class="leftAligned">
				<input type="text" id="personnelNo" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="name" style="width: 173px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Position</td>
			<td class="leftAligned">
				<input type="text" id="persCapacityCd" style="width: 65px; text-align: right;" readonly="readonly"/>
				<input type="text" id="nbtPosition" style="width: 173px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Amount of Coverage</td>
			<td class="leftAligned">
				<input type="text" id="amountCovered" style="width: 250px; text-align: right;" readonly="readonly"/>
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
	$("editSectionOrHazardInfo").observe("click", function(){
		showEditor("sectionOrHazardInfo", 2000,'true');
	});
	$("editInterestOnPremises").observe("click", function(){
		showEditor("interestOnPremises", 500,'true');
	});
	$("editLimitOfLiability").observe("click", function(){
		showEditor("limitOfLiability", 500,'true');
	});
	
}catch(e){
	showErrorMessage("Claim Information - Casualty Item Information", e);
}
</script>