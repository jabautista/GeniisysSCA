<div>
	<table style="width:720px;margin:20px auto 5px auto;">
		<tr>
			<td class="rightAligned" style="width:85px; padding-right: 5px;">Item No.</td>
			<td colspan="3">
				<input type="text" id="txtAviationItemItemNo" style="width:70px;" readonly="readonly"/>
				<input type="text" id="txtAviationItemItemTitle" style="width:530px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Aircraft Name </td>
			<td>
				<input type="text" id="txtAviationItemAircraftName" style="width:250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width:100px;padding-right: 5px;">Prev. Utilization </td>
			<td>
				<input type="text" id="txtAviationItemPrevUtil" style="width:250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Air Type </td>
			<td>
				<input type="text" id="txtAviationItemAirType" style="width:250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Est. Utilization </td>
			<td>
				<input type="text" id="txtAviationItemEstUtil" style="width:250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">RPC No. </td>
			<td>
				<input type="text" id="txtAviationItemRpcNo" style="width:250px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Fly Time </td>
			<td>
				<input type="text" id="txtAviationItemFlyTime" style="width:250px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Purpose </td>
			<td>
				<textArea id="txtAviationItemPurpose" style="width:250px; resize:none;" readonly="readonly"></textArea>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Qualification </td>
			<td>
				<textArea id="txtAviationItemQualification" style="width:250px; resize:none;" readonly="readonly"></textArea>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Excesses </td>
			<td>
				<textArea id="txtAviationItemExcesses" style="width:250px; resize:none;" readonly="readonly"></textArea>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Geography Limit </td>
			<td>
				<textArea id="txtAviationItemGeogLimit" style="width:250px; resize:none;" readonly="readonly"></textArea>
			</td>
		</tr>
	</table>
</div>
<div style="margin-top:10px;text-align:center">
	<input type="button" class="button" id="btnReturnFromAviationItemAddtlinfo" value="Item Information" style="width:150px;"/>
	<input type="button" class="button" id="btnAviationItemDeductibles" value="Deductibles" style="width:150px;"/>
	<input type="button" class="button" id="btnAviationItemPicOrVid" value="View Picture or Video" style="width:150px;"/>
</div>
<script>

	try{
		var moduleId = $F("hidModuleId"); 
		var avItem = JSON.parse('${avItem}'.replace(/\\/g, '\\\\')); //added by Kris 03.04.2013
		
		var objAviationItemInfo = JSON.parse('${aviationItemInfo}'.replace(/\\/g, '\\\\'));
		
		if(objAviationItemInfo != null){
			$("txtAviationItemItemNo").value			= objAviationItemInfo.itemNo;
			$("txtAviationItemItemTitle").value			= unescapeHTML2(objAviationItemInfo.itemTitle);
			$("txtAviationItemAircraftName").value		= unescapeHTML2(objAviationItemInfo.vesselName);
			$("txtAviationItemPrevUtil").value			= nvl(objAviationItemInfo.prevUtilHrs, "");
			$("txtAviationItemAirType").value			= unescapeHTML2(objAviationItemInfo.airDesc);
			$("txtAviationItemEstUtil").value			= nvl(objAviationItemInfo.estUtilHrs, "");
			$("txtAviationItemRpcNo").value				= nvl(objAviationItemInfo.rpcNo, "");
			$("txtAviationItemFlyTime").value			= nvl(objAviationItemInfo.totalFlyTime, "");
			$("txtAviationItemPurpose").value			= unescapeHTML2(objAviationItemInfo.purpose);
			$("txtAviationItemQualification").value		= unescapeHTML2(objAviationItemInfo.qualification);
			$("txtAviationItemExcesses").value			= unescapeHTML2(objAviationItemInfo.deductText);
			$("txtAviationItemGeogLimit").value			= unescapeHTML2(objAviationItemInfo.geogLimit);
		}
		
		if(moduleId == "GIPIS101"){
			$("txtAviationItemItemNo").value			= avItem.itemNo;
			$("txtAviationItemItemTitle").value			= avItem.itemTitle;
		}
		
		$("btnReturnFromAviationItemAddtlinfo").observe("click", function(){
			overlayAviationItemAdditionalInfo.close();
		});
		
		$("btnAviationItemDeductibles").observe("click", function(){
			// modified by Kris 03.04.2013
			moduleId == "GIPIS101" ? getItemDeductibleList2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) 
								   : getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));
		});
		
		$("btnAviationItemPicOrVid").observe("click", function(){
			showAttachmentList();
		});
		
	}catch(e){
		showErrorMessage("Aviation Item", e);
	}
	
</script>