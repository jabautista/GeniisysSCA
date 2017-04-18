<div>
	<table style="width:1000;margin:20px auto 5px auto;">
		<tr id="row1">
			<td class="rightAligned" style="width:90px;padding-right: 5px;">Risk No</td>
			<td colspan="6"><input type="text" id="txtFireRiskNo" style="width:70px;margin-right:5px;" readonly="readonly"/>Risk Item No<input type="text" id="txtFireRiskItemNo" style="width:70px; padding-left: 5px;" readonly="readonly"/></td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Item No</td>
			<td colspan="5">
				<input type="text" id="txtFireItemNo" style="width:70px;margin-right:5px;" readonly="readonly"/>
				<input type="text" id="txtFireItemTitle" name="txtFireItemTitle" style="width:613px;" readonly="readonly"/>
			</td>
			
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Assignee</td>
			<td colspan="3">
				<input type="text" id="txtFireAssignee" style="width:98%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width:100px;padding-right: 5px;">Date</td>
			<td style="width:250px;">
				<input type="text" id="txtFireToDate" style="width:45%;margin-right:1px;" readonly="readonly"/>
				<input type="text" id="txtFireFromDate" style="width:45%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Type</td>
			<td colspan="3">
				<input type="text" id="txtFireType" style="width:98%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Location1</td>
			<td>
				<input type="text" id="txtFireLocation1" style="width:95%" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Province</td>
			<td>
				<input type="text" id="txtFireProvince" style="width:95%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width:70px;padding-right: 5px;">City</td>
			<td>
				<input type="text" id="txtFireCity" style="width:95%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Location2</td>
			<td>
				<input type="text" id="txtFireLocation2"style="width:95%" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">District</td>
			<td>
				<input type="text" id="txtFireDistrict" style="width:95%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Block</td>
			<td>
				<input type="text" id="txtFireBlock" style="width:95%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Location3</td>
			<td>
				<input type="text" id="txtFireLocation3" style="width:95%" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">EQ Zone</td>
			<td colspan="3">
				<input type="text" id="txtFireEqZone" style="width:98%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">LAT</td>
			<td>
				<input type ="text" id="txtFireLatitude" name="txtFireLatitude" style="width:95%" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Typhoon Zone</td>
			<td colspan="3">
				<input type="text" id="txtFireTyphoonZone" style="width:98%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">LONG</td>
			<td>
				<input type ="text" id="txtFireLongitude" name="txtFireLongitude" style="width:95%" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Flood Zone</td>
			<td colspan="3">
				<input type="text" id="txtFireFloodZone" style="width:98%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Front Boundary</td>
			<td>
				<div id="fireFrontBounderyDiv" name="fireFrontBounderyDiv" style="float: left; width: 243px; border: 1px solid gray; height: 22px;">
					<textarea style="float: left; height: 16px; width: 217px; margin-top: 0; border: none;" id="txtFireFrontBoundery" name="txtFireFrontBoundery" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewFireFrontBoundery"/>
				</div>
				<!-- <input type="text" id="txtFireFrontBoundery" style="width:95%" readonly="readonly"/> -->
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Tariff Zone</td>
			<td>
				<input type="text" id="txtFireTariffZone" style="width:95%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Tariff Code</td>
			<td>
				<input type="text" id="txtFireTariffCode" style="width:95%" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Right Boundary</td>
			<td>
				<div id="fireRightBounderyDiv" name="fireRightBounderyDiv" style="float: left; width: 243px; border: 1px solid gray; height: 22px;">
					<textarea style="float: left; height: 16px; width: 217px; margin-top: 0; border: none;" id="txtFireRightBoundery" name="txtFireRightBoundery" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewFireRightBoundery"/>
				</div>
				<!-- <input type="text" id="txtFireRightBoundery" style="width:95%" readonly="readonly"/> -->
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;" vertical-align=middle>Construction
			<td colspan="3">
			<textArea style="float: left; width:185px; height: 47px; resize: none; margin-top: 2px; margin-left:0px;" id="txtFireConstructionDesc" readonly="readonly"></textArea>
				<div id="fireConstructionRemarksDiv" name="fireConstructionRemarksDiv" style="width: 201px; border: 1px solid gray; height: 53px; margin-left: 197px; margin-top:2px;">
				<textarea style="float: left; height: 47px; width:193px; margin-top: 0px; border: none;" id="txtFireConstructionRemarks" name="txtFireConstructionRemarks" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; margin-top:-52px; float: right;" alt="Edit" id="viewFireConstructionRemarks"/>
				</div>
				<!-- <textArea style="width:345px; resize: none;" id="txtFireConstructionRemarks" readonly="readonly"></textArea> -->
			</td>
			<td class="rightAligned" style="padding-right: 5px; padding-top:6px; vertical-align:top;">Rear Boundary
			<table style="width:100px; height:1px; margin: auto; margin-left:64px; margin-top:9px;">
					<tr>
						<td class="rightAligned" style="padding-top: 5px; width:16px;" >Left Boundary</td>
					</tr>
			</table>
			</td>
			</td>
			<td>
				<div id="fireRearBounderyDiv" name="fireRearBounderyDiv" style="float: left; width: 243px; border: 1px solid gray; height: 22px;">
					<textarea style="float: left; height: 16px; width: 217px; margin-top: 0; border: none" id="txtFireRearBoundery" name="txtFireRearBoundery" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewFireRearBoundery"/>
				</div>
				<!-- <input type="text" id="txtFireRearBoundery" style="width:95%" readonly="readonly"/> -->
				<table style="margin-top: 25px; width: 245px; margin-left:-2px;">
					<tr>
						<td>
							<div id="fireLeftBounderyDiv" name="fireLeftBounderyDiv" style="float: left; width: 243px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 14px; width: 230px; margin-top: 0; border: none" id="txtFireLeftBoundery" name="txtFireLeftBoundery" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right; margin-top:-19px;" alt="Edit" id="viewFireLeftBoundery"/>
							</div>
						</td>
					</tr>
				</table>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Occupancy</td>
			<td colspan="3">
				<textArea style="width:98%; height: 47px; resize: none; margin-top:2px;" id="txtFireOccupancyDesc" readonly="readonly"></textArea>
			</td>
			<td colspan="2">
				<div id="fireOccupancyRemarksDiv" name="fireOccupancyRemarksDiv" style="float: left; width: 414px; border: 1px solid gray; height: 53px;">
					<textarea style="float: left; height: 47px; width: 380px; margin-top: 0; border: none;" id="txtFireOccupancyRemarks" name="txtFireOccupancyRemarks" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewFireOccupancyRemarks"/>
				</div>
				<!-- <textArea style="width:345px; resize: none;" id="txtFireOccupancyRemarks" readonly="readonly"></textArea> -->
			</td>	
		</tr>
	</table>

</div>
<div style="margin-top:10px;text-align:center">
	<input type="button" class="button" id="btnReturnFromFireItemAddtlinfo" value="Return" style="width:18%"/>
	<input type="button" class="button" id="btnFireItemDeductibles" value="Deductibles" style="width:18%"/>
	<input type="button" class="button" id="btnFireItemMortgagee" value="Mortgagee" style="width:18%"/>
	<input type="button" class="button" id="btnFireItemPicOrVid" value="View Picture or Video" style="width:18%"/>
</div>
<script>
	initializeAll();
	var moduleId = $F("hidModuleId"); // added by Kris 03.05.2013
	var fiItem;
	try{
		if('${fiItem}' != "")
			fiItem = JSON.parse('${fiItem}');			
	}catch(e){
		showErrorMessage("JSONObjects", e);
	}
	
	try {
		var objFireItemInfo = JSON.parse('${fireItemInfo}'.replace(/\\/g, '\\\\'));
	} catch(e){}

	if(objFireItemInfo != null){
		// added by Kris 03.06.2013		
		if(moduleId == "GIPIS101"){
			$("txtFireType").value					= unescapeHTML2(objFireItemInfo.frItemDesc);
		} else {
			$("txtFireRiskNo").value				= objFireItemInfo.riskNo;
			$("txtFireRiskItemNo").value			= objFireItemInfo.riskItemNo;
			$("txtFireItemNo").value				= objFireItemInfo.itemNo;
			$("txtFireItemTitle").value				= unescapeHTML2(objFireItemInfo.itemTitle);
			$("txtFireType").value					= unescapeHTML2(objFireItemInfo.frItemDesc); //objFireItemInfo.frItemType;
		}
		
		
		$("txtFireAssignee").value				= unescapeHTML2(objFireItemInfo.assignee);
		$("txtFireToDate").value				= objFireItemInfo.toDate;
		$("txtFireFromDate").value				= objFireItemInfo.fromDate;
		
		$("txtFireLocation1").value				= unescapeHTML2(objFireItemInfo.locRisk1);
		$("txtFireProvince").value				= unescapeHTML2(objFireItemInfo.provinceDesc);
		
		$("txtFireCity").value					= unescapeHTML2(objFireItemInfo.city);
		$("txtFireLocation2").value				= unescapeHTML2(objFireItemInfo.locRisk2);
		$("txtFireDistrict").value				= unescapeHTML2(objFireItemInfo.districtNo);
		$("txtFireBlock").value					= unescapeHTML2(objFireItemInfo.blockNo);
		$("txtFireLocation3").value				= unescapeHTML2(objFireItemInfo.locRisk3);
		$("txtFireEqZone").value				= unescapeHTML2(objFireItemInfo.eqDesc);
		$("txtFireFrontBoundery").value			= unescapeHTML2(objFireItemInfo.front);
		$("txtFireTyphoonZone").value			= unescapeHTML2(objFireItemInfo.typhoonZoneDesc);
		$("txtFireRightBoundery").value			= unescapeHTML2(objFireItemInfo.right);
		$("txtFireFloodZone").value				= unescapeHTML2(objFireItemInfo.floodZoneDesc);

		$("txtFireRearBoundery").value			= unescapeHTML2(objFireItemInfo.rear);
		$("txtFireTariffZone").value			= unescapeHTML2(objFireItemInfo.tariffZoneDesc);
		$("txtFireTariffCode").value			= unescapeHTML2(objFireItemInfo.tarfCd);
		$("txtFireLeftBoundery").value			= unescapeHTML2(objFireItemInfo.left);
		$("txtFireConstructionDesc").value		= unescapeHTML2(objFireItemInfo.constructionDesc);
		$("txtFireConstructionRemarks").value	= unescapeHTML2(objFireItemInfo.constructionRemarks);
		$("txtFireOccupancyDesc").value			= unescapeHTML2(objFireItemInfo.occupancyDesc);
		$("txtFireOccupancyRemarks").value		= unescapeHTML2(objFireItemInfo.occupancyRemarks);
		$("txtFireLatitude").value					= unescapeHTML2(objFireItemInfo.latitude);
		$("txtFireLongitude").value					= unescapeHTML2(objFireItemInfo.longitude);

	}
	
	// for GIPIS101
	if(moduleId == "GIPIS101"){
		$("row1").hide();
		$("txtFireItemTitle").writeAttribute("style", "width:658px;");
		$("txtFireItemNo").value				= fiItem.itemNo;
		$("txtFireItemTitle").value				= unescapeHTML2(fiItem.itemTitle);
	}else{
		$("btnReturnFromFireItemAddtlinfo").value = "Item Information";
	}
	
	$("btnReturnFromFireItemAddtlinfo").observe("click", function(){
		overlayFireItemAdditionalInfo.close();
	});

	$("btnFireItemDeductibles").observe("click", function(){
		moduleId == "GIPIS101" ? getItemDeductibleList2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) :
								 getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));
	});

	$("btnFireItemMortgagee").observe("click", function(){
		moduleId == "GIPIS101" ? getItemMortgagees2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) :
								 getItemMortgagees(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));
	});
	
	$("btnFireItemPicOrVid").observe("click", function(){
		showAttachmentList();
	});
	
	// bonok :: 10.13.2014
	$("viewFireFrontBoundery").observe("click", function(){
		showOverlayEditor("txtFireFrontBoundery", 4000, $("txtFireFrontBoundery").hasAttribute("readonly"));
	});	
		
	$("viewFireRightBoundery").observe("click", function(){
		showOverlayEditor("txtFireRightBoundery", 4000, $("txtFireRightBoundery").hasAttribute("readonly"));
	});	
	
	$("viewFireRearBoundery").observe("click", function(){
		showOverlayEditor("txtFireRearBoundery", 4000, $("txtFireRearBoundery").hasAttribute("readonly"));
	});	
	
	$("viewFireLeftBoundery").observe("click", function(){
		showOverlayEditor("txtFireLeftBoundery", 4000, $("txtFireLeftBoundery").hasAttribute("readonly"));
	});
	
	$("viewFireConstructionRemarks").observe("click", function(){
		showOverlayEditor("txtFireConstructionRemarks", 4000, $("txtFireConstructionRemarks").hasAttribute("readonly"));
	});
	
	$("viewFireOccupancyRemarks").observe("click", function(){
		showOverlayEditor("txtFireOccupancyRemarks", 4000, $("txtFireOccupancyRemarks").hasAttribute("readonly"));
	});
	
</script>
	
