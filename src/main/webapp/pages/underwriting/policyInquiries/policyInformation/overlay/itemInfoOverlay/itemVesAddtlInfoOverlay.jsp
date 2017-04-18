<div>
	<div>
		<table style="width:770px;margin:20px auto 5px auto;" cellspacing="2">
			<tr>
				<td class="rightAligned" style="width:120px; padding-right: 5px;">Item No.</td>
				<td colspan="6">
					<input type="text" id="txtItemVesItemNo" style="width:72px;margin-right:5px;" readonly="readonly"/><input type="text" id="txtItemVesItemTitle" style="width:547px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Vessel Name</td>
				<td colspan="3">
					<input type="text" id="txtItemVesVesselName" style="width:255px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" class="rightAligned" style="width:105px; padding-right: 5px;">Old Name</td>
				<td>
					<input type="text" id="txtItemVesVesseolOldName" style="width:255px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Vessel Type</td>
				<td colspan="3">
					<input type="text" id="txtItemVesVesTypeDesc" style="width:255px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Prop Type</td>
				<td>
					<input type="text" id="txtItemVesPropelSw" style="width:255px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Vessel Class</td>
				<td colspan="3">
					<input type="text" id="txtItemVesVesselClassDesc" style="width:255px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Hull Type</td>
				<td>
					<input type="text" id="txtItemVesHullDesc" style="width:255px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Registered Owner</td>
				<td colspan="3">
					<input type="text" id="txtItemVesRegOwner" style="width:255px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Place</td>
				<td>
					<input type="text" id="txtItemVesPlace" style="width:255px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Gross Tonnage</td>
				<td>
					<input type="text" id="txtItemVesGrossTonnage" style="width:80px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:80px; padding-right: 5px;">Ves. Length</td>
				<td>
					<input type="text" id="txtItemVesVesselLength" style="width:80px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:75px; padding-right: 5px;">Year Built</td>
				<td>
					<input type="text" id="txtItemVesVesselYearBuilt" style="width:80px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Net Tonnage</td>
				<td>
					<input type="text" id="txtItemVesNetTonnage" style="width:80px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Ves. Breadth</td>
				<td>
					<input type="text" id="txtItemVesVesselBreadth" style="width:80px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">No. of Crew</td>
				<td>
					<input type="text" id="txtItemVesNoOfCrew" style="width:80px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Deadweight</td>
				<td>
					<input type="text" id="txtItemVesDeadweight" style="width:80px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Ves. Depth</td>
				<td>
					<input type="text" id="txtItemVesVesselDepth" style="width:80px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Nationality</td>
				<td>
					<input type="text" id="txtItemVesNationality" style="width:80px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Drydock Place</td>
				<td colspan="3">
					<input type="text" id="txtItemVesDrydockPlace" style="width:255px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Drydock Date</td>
				<td>
					<input type="text" id="txtItemVesDrydockDate" style="width:255px;" readonly="readonly"/>
				</td>
			</tr>
			
			
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Deductible</td>
				<td colspan="3">
					<textArea id="txtItemVesDeductText" style="width:255px; resize: none;" readonly="readonly"></textArea>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Geographic Limit</td>
				<td>
					<textArea id="txtItemVesGeogLimit" style="width:255px; resize: none;" readonly="readonly"></textArea>
				</td>
			</tr>
		</table>
	</div>

	<div style="margin-top:10px;text-align:center">
		<input type="button" class="button" id="btnReturnFromItemVesAddtlinfo" value="Return" style="width:18%"/>
		<input type="button" class="button" id="btnItemVesDeductibles" value="Deductibles" style="width:18%"/>
		<input type="button" class="button" id="btnItemVesPicOrVid" value="View Picture or Video" style="width:18%"/>
	</div>

</div>
<script>
	initializeAll();
	var moduleId = $F("hidModuleId");
	
	try{		
		var objItemVesInfo = JSON.parse('${gipiItemVes}'.replace(/\\/g, '\\\\'));		
	}catch(e){}
	
	try {
		var mhItem = JSON.parse('${mhItem}'.replace(/\\/g, '\\\\'));
	} catch(e){}
	
	if(objItemVesInfo != null){
		if(objItemVesInfo.dryDate != null ){
			var dryDockDate = Date.parse(objItemVesInfo.dryDate);
		}
		
		if(moduleId == "GIPIS101"){
			$("txtItemVesItemNo").value				= mhItem.itemNo;
			$("txtItemVesItemTitle").value			= unescapeHTML2(mhItem.itemTitle);
		} else {
			$("txtItemVesItemNo").value				= objItemVesInfo.itemNo;
			$("txtItemVesItemTitle").value			= unescapeHTML2(objItemVesInfo.itemTitle);
		}
		
		
		$("txtItemVesVesselName").value			= unescapeHTML2(objItemVesInfo.vesselName);
		$("txtItemVesVesseolOldName").value		= unescapeHTML2(objItemVesInfo.vesselOldName);
		$("txtItemVesVesTypeDesc").value		= unescapeHTML2(objItemVesInfo.vesTypeDesc);
		$("txtItemVesPropelSw").value			= unescapeHTML2(objItemVesInfo.propelSwDesc);
		$("txtItemVesVesselClassDesc").value	= unescapeHTML2(objItemVesInfo.vessClassDesc);
		$("txtItemVesHullDesc").value			= unescapeHTML2(objItemVesInfo.hullDesc);
		$("txtItemVesRegOwner").value			= unescapeHTML2(objItemVesInfo.regOwner);
		$("txtItemVesPlace").value				= unescapeHTML2(objItemVesInfo.regPlace);

		$("txtItemVesGrossTonnage").value		= objItemVesInfo.grossTon;
		$("txtItemVesVesselLength").value		= objItemVesInfo.vesselLength;
		$("txtItemVesVesselYearBuilt").value	= objItemVesInfo.yearBuilt;
		$("txtItemVesNetTonnage").value			= objItemVesInfo.netTon;
		$("txtItemVesVesselBreadth").value		= objItemVesInfo.vesselBreadth;
		$("txtItemVesNoOfCrew").value			= objItemVesInfo.noCrew;
		$("txtItemVesDeadweight").value			= objItemVesInfo.deadWeight;
		$("txtItemVesVesselDepth").value		= objItemVesInfo.vesselDepth;
		$("txtItemVesNationality").value		= objItemVesInfo.crewNat;
		$("txtItemVesDrydockPlace").value		= unescapeHTML2(objItemVesInfo.dryPlace);

		$("txtItemVesDrydockDate").value		= objItemVesInfo.dryDate; // == null ? objItemVesInfo.dryDate : dryDockDate.format('mm-dd-yyyy');  // modified by Kris 02.07.2013
		$("txtItemVesDeductText").value			= unescapeHTML2(objItemVesInfo.deductText);
		$("txtItemVesGeogLimit").value			= unescapeHTML2(objItemVesInfo.geogLimit);
	
	}

	if(moduleId == "GIPIS101"){
		$("txtItemVesItemNo").value				= mhItem.itemNo;
		$("txtItemVesItemTitle").value			= mhItem.itemTitle;
	}else{
		$("btnReturnFromItemVesAddtlinfo").value = "Item Information";
	}
	
	$("btnReturnFromItemVesAddtlinfo").observe("click", function(){
		overlayItemVesAdditionalInfo.close();
	});
	
	$("btnItemVesDeductibles").observe("click", function(){
		moduleId == "GIPIS101" ? getItemDeductibleList2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) : 
								 getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));
	});
	
	$("btnItemVesPicOrVid").observe("click", function(){
		showAttachmentList();
	});
</script>