<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div  id="fireItemSectionDiv" class="sectionDiv" style="border: 0px;">
	<div style="width: 100%;">
		<table border="0" style="margin-bottom: 10px;" align="center">
			<tr>
				<td class="rightAligned">Item</td>
				<td class="leftAligned">
					<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 173px;" readonly="readonly">
				</td>
				</td>
				<td class="rightAligned" style="width: 120px;">Description</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 255px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" ></td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 255px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency Rate</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
				</td>
				<td class="rightAligned" >Assignee</td>
				<td class="leftAligned"  >
					<input type="text" id="txtItemAssignee" name="txtItemAssignee" value="" style="width: 250px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Item Type</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspItemType" name="txtDspItemType" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Loss Date</td>
				<td class="leftAligned"  >
					<input type="text" id="txtItemLossDate" name="txtItemLossDate" value="" style="width: 250px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >District</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDistrictNo" name="txtDistrictNo" value="" style="width: 90px; float: left;" readonly="readonly">
					<label style="float: left; width: 62px; text-align: center; margin-top: 6px;">Block</label>
					<input type="text" id="txtBlockNo" name="txtBlockNo" value="" style="width: 90px; float: left;" readonly="readonly">
				</td>
				<td class="rightAligned" >Location</td>
				<td class="leftAligned"  >
					<input type="text" id="txtLocRisk1" name="txtLocRisk1" value="" style="width: 250px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >EQ Zone</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspEqZone" name="txtDspEqZone" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" ></td>
				<td class="leftAligned"  >
					<input type="text" id="txtLocRisk2" name="txtLocRisk2" value="" style="width: 250px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Typhoon Zone</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspTyphoon" name="txtDspTyphoon" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" ></td>
				<td class="leftAligned"  >
					<input type="text" id="txtLocRisk3" name="txtLocRisk3" value="" style="width: 250px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Flood Zone</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspFloodZone" name="txtDspFloodZone" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Boundary Front</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 255px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtFront" name="txtFront" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtFront" id="editTxtFront" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Tariff Zone</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspTariffZone" name="txtDspTariffZone" value="" style="width: 90px; float: left;" readonly="readonly">
					<label style="float: left; width: 62px; text-align: center; margin-top: 6px;">Tariff Cd</label>
					<input type="text" id="txtTarfCd" name="txtTarfCd" value="" style="width: 90px; float: left;" readonly="readonly">
				</td>
				<td class="rightAligned" >Right</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 255px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtRight" name="txtRight" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtRight" id="editTxtRight" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Occupancy</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspOccupancy" name="txtDspOccupancy" value="" style="width: 65px;" readonly="readonly">
					<input type="text" id="txtOccupancyRemarks" name="txtOccupancyRemarks" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Left</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 255px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtLeft" name="txtLeft" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtLeft" id="editTxtLeft" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Construction</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspConstruction" name="txtDspConstruction" value="" style="width: 65px;" readonly="readonly">
					<input type="text" id="txtConstructionRemarks" name="txtConstructionRemarks" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Rear</td>
				<td class="leftAligned">
					<div style="border: 1px solid gray; height: 20px; width: 255px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtRear" name="txtRear" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtRear" id="editTxtRear" />
					</div>
				</td>
			</tr>
		</table>
	</div>
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
			<td><input type="button" id="btnItemMortgagee"	name="btnItemMortgagee"   style="width: 100px;" class="disabledButton"	value="Mortgagee" /></td>
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
		
		$("btnItemMortgagee").observe("click", function(){
			var itemNo = $("txtItemNo").value;
			if(nvl(itemNo, "") == ""){
				showMessageBox("Please select an item first.", "I");
				return false;
			}
			
			overlayItemMortg = Overlay.show(contextPath+"/GICLMortgageeController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260ItemMortgagee",
								claimId : objCLMGlobal.claimId,
								itemNo: itemNo,
								ajax: 1},
				title: "Mortgagee",	
				id: "item_mortg_canvas",
				width: 600,
				height: 280,
				showNotice: true,
			    draggable: false,
			    closable: true
			});
		});
		
		$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
		$("editTxtItemDesc2").observe("click", function(){showEditor("txtItemDesc2", 2000, 'true');});
		$("editTxtFront").observe("click", function(){showEditor("txtFront", 2000, 'true');});
		$("editTxtLeft").observe("click", function(){showEditor("txtLeft", 2000, 'true');});
		$("editTxtRight").observe("click", function(){showEditor("txtRight", 2000, 'true');});
		$("editTxtLeft").observe("click", function(){showEditor("txtLeft", 2000, 'true');});
		$("editTxtRear").observe("click", function(){showEditor("txtRear", 2000, 'true');});
		
	}catch(e){
		showErrorMessage("Claim Information - Fire Item Information", e);
	}

</script>