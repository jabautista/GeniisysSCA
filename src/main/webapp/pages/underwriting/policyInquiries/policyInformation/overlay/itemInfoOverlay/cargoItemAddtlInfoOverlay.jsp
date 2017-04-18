<div>
	<table style="width:800;margin:20px auto 5px auto;">
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Item No</td>
			<td colspan="3">
				<input type="text" id="txtCargoItemNo" style="width:70px;margin-right:5px;" readonly="readonly"/><input type="text" id="txtCargoItemTitle" style="width:496px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Geog. Desc.</td>
			<td  style="width:250px;">
				<input type="text" id="txtCargoGeogDesc" style="width:95%;" readonly="readonly"/>
			</td>
			<td></td>
			<td style="width:250px;">
				<input id="listOfCarriersBtn" name="listOfCarriersBtn" type="button" class="button" value="List of Carriers" style="width:98%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Carrier</td>
			<td>
				<input type="text" id="txtCargoVesselName" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Voyage No.</td>
			<td>
				<input type="text" id="txtCargoVoyageNo" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Cargo Class</td>
			<td>
				<input type="text" id="txtCargoClassCd" style="width:70px;margin-right:5px;" readonly="readonly"/><input type="text" id="txtCargoClassDesc" style="width:155px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">LC No.</td>
			<td>
				<input type="text" id="txtCargoLcNo" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Cargo Type</td>
			<td>
				<input type="text" id="txtCargoTypeDesc" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">ETD</td>
			<td>
				<input type="text" id="txtCargoEtd" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Type of Packing</td>
			<td>
				<input type="text" id="txtCargoPackingMethod" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">ETA</td>
			<td>
				<input type="text" id="txtCargoEta" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">BL/AWB</td>
			<td>
				<input type="text" id="txtCargoBlAwb" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Print</td>
			<td>
				<input type="text" id="txtCargoPrintTag" style="width:50px;margin-right:5px;" readonly="readonly"/><input type="text" id="txtCargoPrintDesc" style="width:174px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Transhipment Origin</td>
			<td>
				<input type="text" id="txtCargoTranshipOrigin" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Origin</td>
			<td>
				<input type="text" id="txtCargoOrigin" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Transhipment Destination</td>
			<td>
				<input type="text" id="txtCargoTranshipDestination" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Destination</td>
			<td>
				<input type="text" id="txtCargoDestn" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="row10">
			<td class="rightAligned" style="padding-right: 5px;">Currency Short Name</td>
			<td>
				<input type="text" id="txtCargoShortName" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Currency Rate</td>
			<td>
				<input type="text" id="txtCargoInvCurrRt" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr id="row11">
			<td class="rightAligned" style="padding-right: 5px;">Invoice Value</td>
			<td>
				<input type="text" id="txtCargoInvoiceValue" style="width:95%;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Mark-up Rate</td>
			<td>
				<input type="text" id="txtCargoMarkupRate" style="width:95%;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Deductible/Remarks</td>
			<td colspan="3">
				<textArea id="txtCargoDeductText" style="width:97.9%; resize: none;" readonly="readonly"></textArea>
			</td>
		</tr>
	</table>

</div>
<div style="margin-top:10px;text-align:center">
	<input type="button" class="button" id="btnReturnFromCargoItemAddtlinfo" value="Return" style="width:18%"/>
	<input type="button" class="button" id="btnCargoItemDeductibles" value="Deductibles" style="width:18%"/>
	<input type="button" class="button" id="btnCargoItemPicOrVid" value="View Picture or Video" style="width:18%"/>
</div>
<script>
	var moduleId = $F("hidModuleId"); //added by Kris 03.07.2013
	
	try{
		var objCargoItemInfo = JSON.parse('${cargoItemInfo}'.replace(/\\/g, '\\\\'));
		var mnItem = JSON.parse('${mnItem}'.replace(/\\/g, '\\\\'));
		$("btnReturnFromCargoItemAddtlinfo").value = moduleId == "GIPIS101" ? "Return" : "Item Information";
		
		if(objCargoItemInfo != null){
			$("txtCargoGeogDesc").value				= unescapeHTML2(objCargoItemInfo.geogDesc);
			$("txtCargoVesselName").value			= unescapeHTML2(objCargoItemInfo.vesselName);
			$("txtCargoVoyageNo").value				= unescapeHTML2(objCargoItemInfo.voyageNo);
			$("txtCargoClassCd").value				= objCargoItemInfo.cargoClassCd;
			$("txtCargoClassDesc").value			= unescapeHTML2(objCargoItemInfo.cargoClassDesc);
			$("txtCargoLcNo").value					= unescapeHTML2(objCargoItemInfo.lcNo);
			$("txtCargoTypeDesc").value				= unescapeHTML2(objCargoItemInfo.cargoTypeDesc);
			$("txtCargoEtd").value					= objCargoItemInfo.stringEtd == null ? "" : objCargoItemInfo.stringEtd; //edited by MarkS 5.11.2016 SR-22217
			$("txtCargoPackingMethod").value		= unescapeHTML2(objCargoItemInfo.packMethod);
			$("txtCargoEta").value					= objCargoItemInfo.stringEta == null ? "" : objCargoItemInfo.stringEta;
			$("txtCargoBlAwb").value				= unescapeHTML2(objCargoItemInfo.blAwb);
			$("txtCargoPrintTag").value				= objCargoItemInfo.printTag;
			$("txtCargoPrintDesc").value			= unescapeHTML2(objCargoItemInfo.printDesc);
			$("txtCargoTranshipOrigin").value		= unescapeHTML2(objCargoItemInfo.transhipOrigin);
			$("txtCargoOrigin").value				= unescapeHTML2(objCargoItemInfo.origin);
			$("txtCargoTranshipDestination").value	= unescapeHTML2(objCargoItemInfo.transhipDestination);
			$("txtCargoDestn").value				= unescapeHTML2(objCargoItemInfo.destn);

			$("txtCargoShortName").value			= unescapeHTML2(objCargoItemInfo.shortName);
			$("txtCargoInvCurrRt").value			= objCargoItemInfo.invCurrRt;
			$("txtCargoInvoiceValue").value			= objCargoItemInfo.invoiceValue;
			$("txtCargoMarkupRate").value			= objCargoItemInfo.markupRate;
			$("txtCargoDeductText").value			= unescapeHTML2(objCargoItemInfo.deductText);
			
			// if condition for GIPIS101 added by Kris 03.07.2013
			if(moduleId == "GIPIS101"){
				$("txtCargoItemNo").value				= mnItem.itemNo;
				$("txtCargoItemTitle").value			= unescapeHTML2(mnItem.itemTitle);
				
				$("row10").hide();
				$("row11").hide();
			} else {
				$("txtCargoItemNo").value				= objCargoItemInfo.itemNo;
				$("txtCargoItemTitle").value			= unescapeHTML2(objCargoItemInfo.itemTitle);		
			}
			
			if(objCargoItemInfo.vesselCd == "MULTI" || objCargoItemInfo.multiCarrier == "yes"){ // modified by Kris 02.07.2013
				$("listOfCarriersBtn").enable();
			}
			else{
				$("listOfCarriersBtn").disable();
				$("listOfCarriersBtn").writeAttribute("class","disabledButton");
			}

		}

		$("btnReturnFromCargoItemAddtlinfo").observe("click", function(){
			overlayCargoItemAdditionalInfo.close();
		});

		$("btnCargoItemDeductibles").observe("click", function(){
			moduleId == "GIPIS101" ? getItemDeductibleList2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) :
									 getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));

		});
		$("listOfCarriersBtn").observe("click",function(){
			if(moduleId == "GIPIS101") {
				overlayListOfCarriers = Overlay.show(contextPath+"/GIXXVehicleController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXCargoCarrierTG",
						extractId 	: nvl($F("hidItemExtractId"), 0),
						itemNo		: nvl($F("hidItemNo"), 0)
					},
					title: "List of Carriers",
					width: 680,
					height: 300,
					draggable: true
				});
			} else {
				overlayListOfCarriers = Overlay.show(contextPath+"/GIPIVehicleController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getListOfCarriers",
						policyId 	: $F("hidItemPolicyId")
					},
					title: "List of Carriers",
					width: 680,
					height: 300,
					draggable: true
				});
			}
		});
		
		$("btnCargoItemPicOrVid").observe("click", function(){
			showAttachmentList();
		});
		
	}catch(e){
		showErrorMessage("Cargo Item", e);
	}

</script>
	
