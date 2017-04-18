<div class="sectionDiv" id="itemListingTableGridSectionDiv" style="border: 0px;">
	<jsp:include page="/pages/claims/inquiry/claimInformation/itemInformation/itemInfoListing.jsp"></jsp:include>
</div>
<div  id="motorItemSectionDiv" class="sectionDiv" style="border: 0px;">
	<div style="width: 100%;">
		<table border="0" style="margin-bottom: 10px;" align="center">
			<tr>
				<td class="rightAligned" >Item</td>
				<td class="leftAligned"  style="width: 300px;">
					<input type="text" id="txtItemNo" name="txtItemNo" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtItemTitle" name="txtItemTitle" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Plate No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtPlateNo" name="txtPlateNo" value="" style="width: 90px; float: left;" readonly="readonly">
					
				</td>
				<td class="leftAligned" >Model Year</td>
				<td>
					<input type="text" id="txtModelYear" name="txtModelYear" value="" style="width: 86px; float: left;" readonly="readonly">		
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCurrencyCd" name="txtCurrencyCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtDspCurrencyDesc" name="txtDspCurrencyDesc" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Description</td>
				<td class="leftAligned" colspan="3" >
					<div style="border: 1px solid gray; height: 20px; width: 268px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 238px; border: none; height: 13px;" id="txtItemDesc" name="txtItemDesc" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc" id="editTxtItemDesc" />
					</div>
				</td>
			</tr>
			<tr> 
				<td class="rightAligned">Currency Rate</td>
				<td class="leftAligned">
					<input type="text" id="txtCurrencyRate" name="txtCurrencyRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
				</td>
				<td class="rightAligned" ></td>
				<td class="leftAligned" colspan="3" >
					<div style="border: 1px solid gray; height: 20px; width: 268px;">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 238px; border: none; height: 13px;" id="txtItemDesc2" name="txtItemDesc2" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtItemDesc2" id="editTxtItemDesc2" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Company</td>
				<td class="leftAligned">
					<input type="text" id="txtMotcarCompDesc" name="txtMotcarCompCd" value="" style="width: 250px; text-align: left;" readonly="readonly">
					<input type="hidden" id="txtMotcarCompCd" name="txtMotcarCompDesc" value="" style="width: 173px;" readonly="readonly" >
				</td>
				<td class="rightAligned" >Motor No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtMotorNo" name="txtMotorNo" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Make</td>
				<td class="leftAligned">
					<input type="text" id="txtMakeCdDesc" name="txtMakeCd" value="" style="width: 250px; text-align: left;" readonly="readonly">
					<input type="hidden" id="txtMakeCd" name="txtMakeCdDesc" value="" style="width: 173px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Serial No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtSerialNo" name="txtSerialNo" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline Type</td>
				<td class="leftAligned">
					<input type="hidden" id="txtSublineTypeCd" name="txtSublineTypeCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtSublineTypeDesc" name="txtSublineTypeDesc" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" >MV File No.</td>
				<td class="leftAligned" colspan="3" >
					<input type="text" id="txtMvFileNo" name="txtMvFileNo" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Basic Color</td>
				<td class="leftAligned">
					<input type="hidden" id="txtBasicColorCd" name="txtBasicColorCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtBasicColorDesc" name="txtBasicColorDesc" value="" style="width: 250px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Motor Type</td>
				<td class="leftAligned" colspan="3" >
					<input type="hidden" id="txtMotType" name="txtMotType" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtMotTypeDesc" name="txtMotTypeDesc" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Color</td>
				<td class="leftAligned">
					<input type="hidden" id="txtColorCd" name="txtColorCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtColor" name="txtColor" value="" style="width: 250px	;" readonly="readonly">
				</td>
				<td class="rightAligned" >Series</td>
				<td class="leftAligned" colspan="3" >
					<input type="hidden" id="txtSeriesCd" name="txtSeriesCd" value="" style="width: 65px; text-align: right;" readonly="readonly">
					<input type="text" id="txtEngineSeries" name="txtEngineSeries" value="" style="width: 263px;" readonly="readonly">
				</td>
			</tr>
			<tr> 
				<td class="rightAligned" id="lblAssignee">Assignee</td>
				<td class="leftAligned">
					<input type="text" id="txtItemAssignee" name="txtItemAssignee" value="" style="width: 250px; text-align: left;" readonly="readonly" >
				</td>
				<td class="rightAligned" >No. of Passengers</td>
				<td class="leftAligned"  >
					<input type="text" id="txtNoOfPass" name=""txtNoOfPass"" value="" style="width: 90px; float: left; " readonly="readonly"  class="rightAligned">
				</td>
				<td class="rightAligned" >Towing Limit</td>
				<td>
					<input type="text" id="txtTowing" name="txtTowing" class="money" value="" style="width: 86px; float: left;" readonly="readonly">		
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="motorCarDriverDetailsDiv" class="sectionDiv" style="border-bottom: 0px; border-left: 0px; border-right: 0px;">
	<table border="0" style="margin-top: 10px; margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned">Driver Name</td>
			<td class="leftAligned">
				<input type="text" id="txtDrvrName" name="txtDrvrName" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Driving Experience</td>
			<td class="leftAligned"  style="width: 118px;">
				<input type="text" id="txtDrvngExp" name="txtDrvngExp" value="" style="width: 90px; float: left;" class="integerNoNegative" readonly="readonly">
			</td>
			<td class="rightAligned">Age</td>
			<td>
				<input type="text" id="txtDrvrAge" name="txtDrvrAge" value="" style="width: 90px; float: left;" class="integerNoNegative" readonly="readonly">		
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 115px;">Occupation</td>
			<td class="leftAligned"  style="width: 290px;">
				<input type="text" id="txtDrvrOccCd" name="txtDrvrOccCd" value="" readonly="readonly" style="width: 65px;">
				<input type="text" id="txtDrvrOccDesc" name="txtDrvrOccDesc" value="" style="width: 173px;" readonly="readonly">
			</td>
			<td class="rightAligned" >Sex</td>
			<td class="leftAligned" colspan="3" >
				<input type="text" id="txtDrvrSex" name="txtDrvrSex" value="" readonly="readonly" style="width: 250px;">
			</td> 
		</tr>
		<tr>
			<td class="rightAligned">Address</td>
			<td class="leftAligned">
				<div style="border: 1px solid gray; height: 20px; width: 255px;">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" style="resize:none; width: 225px; border: none; height: 13px;" id="txtDrvrAdd" name="txtDrvrAdd" readonly="readonly"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="editTxtDrvrAdd" id="editTxtDrvrAdd" />
				</div>
			</td>
			
			<td class="rightAligned" >Nationality</td>
			<td class="leftAligned"  style="width: 300px;" colspan="3">
				<input type="text" id="txtNationalityCd" name="txtNationalityCd" value="" readonly="readonly" style="width: 65px;">
				<input type="text" id="txtNationalityDesc" name="txtNationalityDesc" value="" style="width: 173px;" readonly="readonly">
			</td> 
			
			
		</tr>
		<tr>
			<td class="rightAligned">Relation to Assured</td>
			<td class="leftAligned">
				<input type="text" id="txtRelation" name="txtRelation" value="" style="width: 250px;" readonly="readonly">
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
			<td><input type="button" id="btnMCEvalReport"	name="btnMCEvalReport"    style="width: 150px;" class="button"			value="MC Evaluation Report" /></td>
			<td><input type="button" id="btnPerilStatus"	name="btnPerilStatus"     style="width: 100px;" class="disabledButton"	value="Peril Status" /></td>
			<td><input type="button" id="btnThirdAdvParty"	name="btnThirdAdvParty"   style="width: 150px;" class="disabledButton"	value="Third/Adverse Party" /></td>
			<td><input type="button" id="btnViewPictures"   name="btnViewPictures"    style="width: 100px;" class="disabledButton"	value="View Pictures" /></td>
			<td><input type="button" id="btnItemMortgagee"	name="btnItemMortgagee"   style="width: 100px;" class="disabledButton"	value="Mortgagee" /></td>
		</tr>
	</table>			
</div>

<script type="text/javascript">
	try{
		initializeAccordion();
		
		$("editTxtItemDesc").observe("click", function(){showEditor("txtItemDesc", 2000, 'true');});
		$("editTxtItemDesc2").observe("click", function(){showEditor("txtItemDesc2", 2000, 'true');});
		$("editTxtDrvrAdd").observe("click", function(){showEditor("txtDrvrAdd", 2000, 'true');});
		
		$("btnPerilStatus").observe("click", function(){
			showGICLS260PerilStatus((objCLMGlobal.callingForm == "GICLS271" ? objCLMGlobal.lineCode : $("lineCd").value), $("txtItemNo").value);
		});
		
		$("btnThirdAdvParty").observe("click", function(){
			var itemNo = $("txtItemNo").value;
			if(nvl(itemNo, "") == ""){
				showMessageBox("Please select an item first.", "I");
				return false;
			}
			
			overlayThirdAdv = Overlay.show(contextPath+"/GICLMotorCarDtlController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260ThirdAdverseParty",
								claimId : objCLMGlobal.claimId,
								sublineCd: objCLMGlobal.sublineCd,
								itemNo: itemNo,
								ajax: 1},
				title: "Third/Adverse Party",	
				id: "third_adverse_canvas",
				width: 835,
				height: 290,
				showNotice: true,
			    draggable: false,
			    closable: true
			});
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
		
	}catch(e){
		showErrorMessage("Claim Information - Motor Car Item Information", e);
	}

	$("btnMCEvalReport").observe("click", function(){
		$("claimInfoMainDiv").hide();
		$("mcEvaluationReportInquiryDiv").show();
		showMcEvaluation();	
	});
</script>