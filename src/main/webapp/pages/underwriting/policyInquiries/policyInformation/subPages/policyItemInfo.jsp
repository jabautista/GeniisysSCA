
<div id="policyItemInfoMainDiv" style="margin-top:10px;margin-bottom:10px;">
	<input type="hidden" id="hidItemOtherInfo"/>
	<div id="relatedItemInfoDiv" name="relatedItemInfoDiv" style="width:100%;height:175px;"></div>

	<div style="width:800px;margin:10px auto 20px auto;">
	
		<div style="width:720px;margin:0 0 0 60px;">
			<table width="720px" border="0">
				<tr id="trRow1ItemInfo">
					<td	id="tdRow1Column1ItemInfo" class="rightAligned" width="110px">Item No.</td>
					<!-- <td	id="tdRow1Column2ItemInfo" width="250px">
						<input type="text" id="txtItemNo" name="txtItemNo" style="width:97%;" readonly="readonly"/>
					</td> -->
					<td	id="tdRow1Column3ItemInfo" colspan="6">
					<input type="text" id="txtItemNo" name="txtItemNo" style="width:25%;" readonly="readonly"/>
						<input type="text" id="txtItemTitle" name="txtItemTitle" style="width:71.5%;" readonly="readonly"/>
					</td>
				</tr>
				
				<tr id="trRow2ItemInfo">
					<td	id="tdRow2Column1ItemInfo" class="rightAligned">Description</td>
					<td	id="tdRow2Column2ItemInfo" colspan="6">
						<div id="itemDescDiv" name="itemDescDiv" style="float: left; width: 619px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 593px; margin-top: 0; border: none;" id="txtItemDesc" name="txtItemDesc" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewItemDesc"/>
						</div>
						<!-- <input type="text" id="txtItemDesc" name="txtItemDesc" style="width:98.5%;" readonly="readonly"/> -->
					</td>
				</tr>
				
				<tr id="trRow3ItemInfo">
					<td	id="tdRow3Column1ItemInfo"></td>
					<td	id="tdRow3Column2ItemInfo" colspan="6">
						<div id="itemDescDiv2" name="itemDescDiv2" style="float: left; width: 619px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 593px; margin-top: 0; border: none;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewItemDesc2"/>
						</div>
						<!-- <input type="text" id="txtItemDesc2" name="txtItemDesc2" style="width:98.5%;" readonly="readonly"/> -->
					</td>
				</tr>
				<tr id="trRow4ItemInfo">
					<td id="tdRow4Column1ItemInfo" class="rightAligned">Sum Insured</td>
					<td id="tdRow4Column2ItemInfo" width="250px">
						<input type="text" id="txtSumInsured" name="txtSumInsured" style="width:96%; text-align: right;" readonly="readonly"/>
					</td>
					<td id="tdRow4Column4ItemInfo" class="rightAligned" width="95px">Premium</td>
					<td id="tdRow4Column2ItemInfo" colspan="2">
						<input type="text" id="txtPremium" name="txtPremium" style="width:95%; text-align: right;" readonly="readonly"/>
					</td>
				</tr>
				<tr id="trRow5ItemInfo">
					<td id="tdRow5Column1ItemInfo" class="rightAligned">Ann. Sum Insured</td>
					<td id="tdRow5Column2ItemInfo" width="250px">
						<input type="text" id="txtAnnSumInsured" name="txtAnnSumInsured" style="width:96%; text-align: right;" readonly="readonly"/>
					</td>
					<td id="tdRow5Column4ItemInfo" class="rightAligned"  width="95px">Ann. Premium</td>
					<td id="tdRow5Column2ItemInfo" colspan="2">
						<input type="text" id="txtAnnPremium" name="txtAnnPremium" style="width:95%; text-align: right;" readonly="readonly"/>
					</td>
				</tr>
				<tr id="trRow6ItemInfo">
					<td	id="tdRow6Column1ItemInfo" class="rightAligned">Currency</td>
					<td	id="tdRow6Column2ItemInfo"  width="250px">
						<input type="text" id="txtCurrencyDesc" name="txtCurrencyDesc" style="width:96%;" readonly="readonly"/>
					</td>
				
					<td	id="tdRow6Column4ItemInfo" class="rightAligned" style="width:95px;">Rate</td>
					<td	id="tdRow6Column5ItemInfo" width="150px">
						<input type="text" id="txtCurrencyRt" name="txtCurrencyRt" class="rate" style="width:95%; text-align: right;" readonly="readonly"/>
					</td>
					<td	id="tdRow6Column6ItemInfo" class="rightAligned">
						<input type="checkbox" id="chkSurchargeSw" name="chkSurchargeSw" value="Y" readonly="readonly" disabled="disabled"/>
					</td>
					<td id="tdRow6Column7ItemInfo" width="95px">
						W/ Surcharge
					</td>
				</tr>
				
				<tr id="trRow7ItemInfo">
					<td	id="tdRow7Column1ItemInfo" class="rightAligned">Coverage</td>
					<td	id="tdRow7Column2ItemInfo" width="250px">
						<input type="text" id="txtCoverageDesc" name="txtCoverageDesc" style="width:96%;" readonly="readonly"/>
					</td>
				
					<td	id="tdRow7Column4ItemInfo" class="rightAligned"></td>
					<td	id="tdRow7Column5ItemInfo">
						<input type="text" id="txtPackLineCd" name="txtPackLineCd" style="width:40%;" readonly="readonly"/>
						<input type="text" id="txtPackSubLineCd" name="txtPackSubLineCd" style="width:47%;" readonly="readonly"/>
					</td>
					<td	id="tdRow7Column6ItemInfo" class="rightAligned">
						<input type="checkbox" id="chkDiscountSw" name="chkDiscountSw" value="Y" readonly="readonly" disabled="disabled"/>
					</td>
					<td id="tdRow7Column7ItemInfo">
						W/ Discount
					</td>
				</tr>
			</table>
			
		</div>
			
		<div align="center" style="margin:30px auto 0 auto;width:625px;">
			<input id="btnItemAdditionalInfo" class="button" type="button" value="Additional Information" name="btnItemAdditionalInfo" style="width:31%;"/>
			<input id="btnItemAnnualizedAmounts" class="button" type="button" value="Annualized Amounts" name="btnItemAnnualizedAmounts" style="width:31%;"/>
			<input id="btnItemOtherItemInfo" class="button" type="button" value="Other Information" name="btnOtherItemInfo" style="width:31%;"/>			
		</div>
	</div>
	
	
	
</div>
	
<script>
	//+"\thidItemType: " + $F("hidItemType")
	var moduleId = $F("hidModuleId");
	$("txtPackLineCd").hide();
	$("txtPackSubLineCd").hide();
	searchRelatedItemInfo();
	initializeAll();
	
	function searchRelatedItemInfo(){
		var gipis101Url = "GIXXItemController?action=getGIXXItemInfo&pageCalling=policyItemInfo&extractId="+ $F("hidExtractId");
		var gipis100Url = "GIPIItemMethodController?action=getRelatedItemInfo&pageCalling=policyItemInfo";
		
		new Ajax.Updater("relatedItemInfoDiv", moduleId == "GIPIS101" ? gipis101Url: gipis100Url ,{
		//new Ajax.Updater("relatedItemInfoDiv","GIPIItemMethodController?action=getRelatedItemInfo&pageCalling=policyItemInfo",{
			method:"get",
			evalScripts: true,
			parameters:{
				policyId : $F("hidPolicyId"),
				lineCd   : $F("hidLineCd"),
				issCd	 : $F("hidIssCd")
			}
		});
	}

	$("btnItemAdditionalInfo").observe("click", function(){
		if(nvl($F("txtItemNo"), "") == ""){
			showMessageBox("Please select item first.", "I");
			return false;
		}
		
		var objItem = new Object();
		objItem.itemNo = $F("txtItemNo");
		objItem.itemTitle = escapeHTML2($F("txtItemTitle"));
		
		if($("hidItemType").value == "mcType"){
			// if condition foro GIPIS101 added by Kris 02.08.2013
			if(moduleId == "GIPIS101") {
				overlayVehicleItemAdditionalInfo = Overlay.show(contextPath+"/GIXXVehicleController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXVehicleItemInfo",
						extractId 	: nvl($("hidItemExtractId").value,0),
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						mcItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 830,
					height: 340,
					draggable: true,
					showNotice : true
					
				});
			} else {
				overlayVehicleItemAdditionalInfo = Overlay.show(contextPath+"/GIPIVehicleController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getVehicleItemInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 825,
					height: 400,
					draggable: true,
					showNotice : true
				});
			}
		}else if($("hidItemType").value == "fiType"){
			if(moduleId == "GIPIS101"){
				overlayFireItemAdditionalInfo = Overlay.show(contextPath+"/GIXXFireItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXFireItemInfo",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						fiItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 900,
					height: 450,
					draggable: true,
					showNotice : true
				});
			} else {
				overlayFireItemAdditionalInfo = Overlay.show(contextPath+"/GIPIFireItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getFireItemInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 900,
					height: 500,
					draggable: true,
					showNotice : true
				});
			}
			
		}else if($("hidItemType").value == "enType"){
			if(moduleId == "GIPIS101"){
				overlayEngineeringItemAdditionalInfo = Overlay.show(contextPath+"/GIXXDeductiblesController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXEnDeductibles",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						enItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 700,
					height: 350,
					draggable: true,
					showNotice : true
				});
			} else {
				overlayEngineeringItemAdditionalInfo = Overlay.show(contextPath+"/GIPIDeductiblesController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getEnDeductibles",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						enItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 700,
					height: 350,
					draggable: true,
					showNotice : true
				});
			}
		}else if($("hidItemType").value == "mnType"){
			if(moduleId == "GIPIS101"){
				overlayCargoItemAdditionalInfo = Overlay.show(contextPath+"/GIXXCargoController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXCargoInfo",
						extractId	: nvl($("hidItemExtractId").value,0),
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						mnItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 900,
					height: 400,
					draggable: true,
					showNotice : true
				});
			} else{
				overlayCargoItemAdditionalInfo = Overlay.show(contextPath+"/GIPICargoController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getCargoInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 900,
					height: 500,
					draggable: true,
					showNotice : true
				});
			}			
		}else if($("hidItemType").value == "mhType"){
			if(moduleId == "GIPIS101"){
				overlayItemVesAdditionalInfo = Overlay.show(contextPath+"/GIXXItemVesController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXItemVesInfo",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						mhItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 800,
					height: 400,
					draggable: true,
					showNotice : true
				});
			} else {
				overlayItemVesAdditionalInfo = Overlay.show(contextPath+"/GIPIItemVesController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getItemVesInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 800,
					height: 400,
					draggable: true,
					showNotice : true
				});
			}
		}else if($("hidItemType").value == "caType"){
			if(moduleId == "GIPIS101") {
				overlayCasualtyItemAdditionalInfo = Overlay.show(contextPath+"/GIXXCasualtyItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXCasualtyItemInfo",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						caItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 650,
					height: 370,
					draggable: true,
					showNotice : true
				});
			} else {
				overlayCasualtyItemAdditionalInfo = Overlay.show(contextPath+"/GIPICasualtyItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getCasualtyItemInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 650,
					height: 400,
					draggable: true,
					showNotice : true
				});
			}
			
			
		}else if($("hidItemType").value == "avType"){
			if(moduleId == "GIPIS101"){ //added by Kris 03.04.2013 for GIPIS101
				overlayAviationItemAdditionalInfo = Overlay.show(contextPath+"/GIXXAviationItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXAviationItemInfo",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0),
						avItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 750,
					height: 310,
					draggable: true,
					showNotice : true
				});
			} else {
				overlayAviationItemAdditionalInfo = Overlay.show(contextPath+"/GIPIAviationItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getAviationItemInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 750,
					height: 310,
					draggable: true,
					showNotice : true
				});
			}
			
			
		}else if($("hidItemType").value == "acType"){
			if(moduleId == "GIPIS101"){ // added by Kris 2.27.2013
				overlayAccidentItemAdditionalInfo = Overlay.show(contextPath+"/GIXXAccidentItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXAccidentItem",
						extractId	: $F("hidItemExtractId"),
						itemNo		: nvl($("hidItemNo").value,0),
						acItem		: JSON.stringify(objItem)
					},
					title: "Additional Information",
					width: 700,
					height: 500,
					draggable: true,
					showNotice : true
				});
			} else {
				overlayAccidentItemAdditionalInfo = Overlay.show(contextPath+"/GIPIAccidentItemController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getAccidentItemInfo",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0) 
					},
					title: "Additional Information",
					width: 700,
					height: 500,
					draggable: true,
					showNotice : true
				});
			}			
		}
		
	});

	$("btnItemAnnualizedAmounts").observe("click", function(){
		overlayItemAnnualizedAmt = Overlay.show(contextPath+"/GIPIItemMethodController", {
			urlContent: true,
			urlParameters: {
				action 	 	: "showAnnualizedAmounts",
				policyId 	: nvl($("hidItemPolicyId").value,0),
				itemNo		: nvl($("hidItemNo").value,0) 
			},
			title: "Annualized Amounts",
			width: 300,
			height: 120,
			draggable: true
		});
		
	});
	$("btnItemOtherItemInfo").observe("click", function(){
		if($F("hidModuleId") == "GIPIS101"){ // kris 02.20.2013: added if condition for GIPIS101
			showAttachmentList();
		} else {
			overlayOtherInfo = Overlay.show(contextPath+"/GIPIItemMethodController", {
				urlContent: true,
				urlParameters: {
					action 	 	: "showOtherInfo",
					policyId 	: nvl($("hidItemPolicyId").value,0),
					itemNo		: nvl($("hidItemNo").value,0) 
				},
				title: "Other Information",
				width: 320,
				height: 140,
				draggable: true
			});
		}
	});
	
	
	// added by Kris 02.20.2013: methods for GIPIS101
	if($F("hidModuleId") == "GIPIS101"){
		//$("trRow5ItemInfo").innerHTML = "";
		$("trRow5ItemInfo").hide();
		$("btnItemAnnualizedAmounts").hide(); 
		$("txtCurrencyRt").style = "width:96%;";
		$("tdRow6Column6ItemInfo").hide();
		$("tdRow6Column7ItemInfo").hide();
		$("tdRow7Column6ItemInfo").hide();
		$("tdRow7Column7ItemInfo").hide();
		//$("chkDiscountSw").hide();
		$("btnItemOtherItemInfo").value = "View Picture or Video";
	}
	
	// bonok :: 10.13.2014
	$("viewItemDesc").observe("click", function(){
		showOverlayEditor("txtItemDesc", 4000, $("txtItemDesc").hasAttribute("readonly"));
	});
	
	$("viewItemDesc2").observe("click", function(){
		showOverlayEditor("txtItemDesc2", 4000, $("txtItemDesc2").hasAttribute("readonly"));
	});

</script>