
<div>
	<table style="width:610px;margin:20px auto 5px auto;" cellspacing="3">
		<tr>
			<td class="rightAligned" style="width:120px; padding-right: 5px;">Item No. </td>
			<td style="width:400px;">
				<input type="text" id="txtCasualtyItemItemNo" style="width:70px;" readonly="readonly"/>
				<input type="text" id="txtCasualtyItemItemTitle" style="width:378px;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="rowLocation">
			<td class="rightAligned" style="padding-right: 5px;">Location </td>
			<td>
				<input type="text" id="txtCasualtyItemLocCode" style="width:70px;" readonly="readonly"/>
				<input type="text" id="txtCasualtyItemLocDesc" style="width:378px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td id="tdLocationOfRisk" class="rightAligned" style="padding-right: 5px;">Location Of Risk </td>
			<td>
				<input type="text" id="txtCasualtyItemLocation" style="width:460px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Section/Hazard</td>
			<td>
				<input type="text" id="txtCasualtyItemSectionHazardCode" style="width:70px;" readonly="readonly"/>
				<input type="text" id="txtCasualtyItemSectionHazardTitle" style="width:378px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Section/Hazard Info</td>
			<td>
				<input type="text" id="txtCasualtyItemSectionHazardInfo" style="width:460px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Interest</td>
			<td>
				<input type="text" id="txtCasualtyItemInterestOnPremises" style="width:460px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Capacity</td>
			<td>
				<input type="text" id="txtCasualtyItemCapacityCode" style="width:70px;" readonly="readonly"/>
				<input type="text" id="txtCasualtyItemCapacityName" style="width:378px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Liability</td>
			<td>
				<input type="text" id="txtCasualtyItemLimitOfLiability" style="width:460px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Conveyance</td>
			<td>
				<input type="text" id="txtCasualtyItemConveyanceInfo" style="width:460px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td id="tdCasualtyItemProperty" class="rightAligned" style="padding-right: 5px;">Property No.</td>
			<td>
				<input type="text" id="txtCasualtyItemPropertyNo" style="width:460px;" readonly="readonly"/>
			</td>
		</tr>
		
	</table>
</div>

<div style="margin-top:10px;text-align:center">
	<input type="button" class="button" id="btnReturnFromCasualtyItemAddtlinfo" value="Item Information" style="width:23%"/>
	<input type="button" class="button" id="btnCasualtyItemGroupItems" value="Group Items" style="width:23%"/>
	<input type="button" class="button" id="btnCasualtyItemDeductibles" value="Deductibles" style="width:23%"/>
	
</div>
<div style="margin-top:10px;text-align:center">
	<input type="button" class="button" id="btnCasualtyItemPersonnelInformation" value="Personnel Information" style="width:23%"/>
	<input type="button" class="button" id="btnCasualtyItemPicOrVid" value="View Picture or Video" style="width:23%"/>
</div>


<script>
	var moduleId = $F("hidModuleId"); //added by Kris

	$("btnReturnFromCasualtyItemAddtlinfo").observe("click", function(){
		overlayCasualtyItemAdditionalInfo.close();
	});

	try{
		var caItem = JSON.parse('${caItem}');
		var objCasualtyItemInfo = JSON.parse('${gipiCasualtyItemInfo}'.replace(/\\/g, '\\\\'));
		
		if(objCasualtyItemInfo != null){
			
			$("txtCasualtyItemItemNo").value				= objCasualtyItemInfo.itemNo;
			$("txtCasualtyItemItemTitle").value				= unescapeHTML2(objCasualtyItemInfo.itemTitle);
			$("txtCasualtyItemLocCode").value				= objCasualtyItemInfo.locationCd;
			$("txtCasualtyItemLocDesc").value				= unescapeHTML2(objCasualtyItemInfo.locationDesc);
			$("txtCasualtyItemLocation").value				= unescapeHTML2(objCasualtyItemInfo.location);
			$("txtCasualtyItemSectionHazardCode").value		= objCasualtyItemInfo.sectionOrHazardCd;
			$("txtCasualtyItemSectionHazardTitle").value	= unescapeHTML2(objCasualtyItemInfo.sectionOrHazardTitle);
			$("txtCasualtyItemSectionHazardInfo").value		= unescapeHTML2(objCasualtyItemInfo.sectionOrHazardInfo);
			$("txtCasualtyItemInterestOnPremises").value	= unescapeHTML2(objCasualtyItemInfo.interestOnPremises);
			$("txtCasualtyItemCapacityCode").value			= objCasualtyItemInfo.capacityCd;
			$("txtCasualtyItemCapacityName").value			= unescapeHTML2(objCasualtyItemInfo.capacityName);
			$("txtCasualtyItemLimitOfLiability").value		= unescapeHTML2(objCasualtyItemInfo.limitOfLiability);
			$("txtCasualtyItemConveyanceInfo").value		= unescapeHTML2(objCasualtyItemInfo.conveyanceInfo);
			$("txtCasualtyItemPropertyNo").value			= unescapeHTML2(objCasualtyItemInfo.property);
			
			if(objCasualtyItemInfo.propertyNoType == "S"){
				$("tdCasualtyItemProperty").innerHTML	= 'Serial No.';
			}else if(objCasualtyItemInfo.propertyNoType == "M"){
				$("tdCasualtyItemProperty").innerHTML	= 'Motor No.';
			}else if(objCasualtyItemInfo.propertyNoType == "E"){
				$("tdCasualtyItemProperty").innerHTML	= 'Equipment No.';
			}else if(objCasualtyItemInfo.propertyNoType == "C"){
				$("tdCasualtyItemProperty").innerHTML	= 'Chassis No.';
			}else{
				$("tdCasualtyItemProperty").innerHTML	= 'Property No.';
			}
			
			if(moduleId == "GIPIS101"){
				$("txtCasualtyItemPropertyNo").value			= unescapeHTML2(objCasualtyItemInfo.propertyNo);			
			}
		}

		$("btnCasualtyItemDeductibles").observe("click", function(){
			//modified by Kris 03.05.2013 added condition for GIPIS101
			moduleId == "GIPIS101" ? getItemDeductibleList2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) : getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));
		});

		$("btnCasualtyItemGroupItems").observe("click", function(){
			if(moduleId == "GIPIS101"){
				overlayCasualtyGroupedItemsTable = Overlay.show(contextPath+"/GIXXGroupedItemsController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXCasualtyGroupedItems",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Grouped Items",
					width: 800,
					height: 350,
					draggable: true,
					showNotice: true
				  });
			} else {
				overlayCasualtyGroupedItemsTable = Overlay.show(contextPath+"/GIPIGroupedItemsController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getCasualtyGroupedItems",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Grouped Items",
					width: 800,
					height: 350,
					draggable: true,
					showNotice: true
				  });
			}
		});

		$("btnCasualtyItemPersonnelInformation").observe("click", function(){
			if(moduleId == "GIPIS101"){
				overlayCasualtyPersonnelInfoTable = Overlay.show(contextPath+"/GIXXCasualtyPersonnelController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXCasualtyPersonnelTG",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Personnel Information",
					width: 550,
					height: 220,
					draggable: true,
					showNotice: true
				  });
			} else {
				overlayCasualtyPersonnelInfoTable = Overlay.show(contextPath+"/GIPICasualtyPersonnelController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getCasualtyItemPersonnel",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Personnel Information",
					width: 550,
					height: 220,
					draggable: true,
					showNotice: true
				  });
			}
		});
		
		$("btnCasualtyItemPicOrVid").observe("click", function(){
			showAttachmentList();
		});
		
		// for GIPIS101
		if(moduleId == "GIPIS101"){
			$("rowLocation").hide();
			$("tdLocationOfRisk").innerHTML = "Location";		
			$("txtCasualtyItemItemNo").value				= caItem.itemNo;
			$("txtCasualtyItemItemTitle").value				= unescapeHTML2(caItem.itemTitle);
		}
		
	}catch(e){
		showErrorMessage("Casualty Item", e);
	}

</script>	