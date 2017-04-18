<div>
	<div style="width:650px;margin:10px auto 15px auto;">
		<table style="width:650px;margin-top:10px;" cellspacing="1">
			<tr>
				<td class="rightAligned" style="width:95px; padding-right: 5px;">Item No.</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemItemNo" style="width:70px;" readonly="readonly"/>
					<input type="text" id="txtAccidentItemItemTitle" style="width:455px;" readonly="readonly"/>
				</td>
			</tr>
			<tr id="row2">
				<td class="rightAligned" style="padding-right: 5px;">Effectivity Date</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemEffFromDate" readonly="readonly"/>
					<input type="text" id="txtAccidentItemEffToDate" readonly="readonly"/>
				</td>
			</tr>
			<tr id="row3">
				<td class="rightAligned" style="padding-right: 5px;">Plan</td>
				<td>
					<input type="text" id="txtAccidentItemPlan" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:120px; padding-right: 5px;">Payment Mode</td>
				<td>
					<input type="text" id="txtAccidentItemPaymentMode" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div style="width:650px;margin:10px auto 15px auto;">
		<div id="" class="toolbar">
			<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Travel Information</center>
		</div>
		<table style="width:390px;margin-top:10px;">
			<tr>
				<td class="rightAligned" style="width:95px; padding-right: 5px;">Travel Dates</td>
				<td>
					<input type="text" id="txtAccidentItemTravelFromDate" readonly="readonly"/>
				</td>
				<td>
					<input type="text" id="txtAccidentItemTravelToDate" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Destination</td>
				<td colspan="2">
					<input type="text" id="txtAccidentItemDestination" style="width:276px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div style="width:650px;margin:10px auto 15px auto;">
		<div id="" class="toolbar">
			<center id="" style="margin:2.5px auto auto auto;font-weight:bold;">Personal Additional Information</center>
		</div>
		<table style="width:650px;margin-top:10px;">
			<tr>
				<td class="rightAligned" style="width:95px; padding-right: 5px;">No. of Persons</td>
				<td>
					<input type="text" id="txtAccidentItemNoOfPersons" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:120px; padding-right: 5px;">Birthday</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemBirthday" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Position</td>
				<td>
					<input type="text" id="txtAccidentItemPosition" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Status</td>
				<td colspan="3">
					<input type="text" id="txtAccidentItemStatus" style="width:200px;" readonly="readonly"/>
				</td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Salary</td>
				<td>
					<input type="text" id="txtAccidentItemSalary" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Age</td>
				<td>
					<input type="text" id="txtAccidentItemAge" style="width:70px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width:0px; padding-right: 5px;">Sex</td>
				<td>
					<input type="text" id="txtAccidentItemSex" style="width:70px;" readonly="readonly"/>
				</td>
			</tr>
			
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Salary Grade</td>
				<td>
					<input type="text" id="txtAccidentItemSalaryGrade" style="width:200px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Height</td>
				<td>
					<input type="text" id="txtAccidentItemHeight" style="width:70px;" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="padding-right: 5px;">Weight</td>
				<td>
					<input type="text" id="txtAccidentItemWeight" style="width:70px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<div style="margin-top:25px;text-align:center">
	<input type="button" class="button" id="btnReturnFromAccidentItemAddtlinfo" value="Item Information" style="width:150px;"/>
	<input type="button" class="button" id="btnAccidentItemDeductibles" value="Deductibles" style="width:150px;"/>
	<input type="button" class="button" id="btnAccidentItemPicOrVid" value="View Picture or Video" style="width:150px;"/>
</div>
<div style="margin-top:10px;text-align:center">
	<input type="button" class="button" id="btnAccidentItemGroupItems" value="Group Items" style="width:23%"/>
	<input type="button" class="button" id="btnAccidentItemBeneficiary" value="Beneficiary" style="width:23%"/>
</div>
<script>
	//var moduleId = '${moduleId}';
	var moduleId = $F("hidModuleId");
	
	try{
		var acItem = JSON.parse('${acItem}');
		var objAccidentItemInfo = JSON.parse('${accidentItemInfo}'.replace(/\\/g, '\\\\'));
		

		if(objAccidentItemInfo != null){

			$("txtAccidentItemItemNo").value			= objAccidentItemInfo.itemNo;
			$("txtAccidentItemItemTitle").value			= unescapeHTML2(objAccidentItemInfo.itemTitle);
			
			if(moduleId != "GIPIS101"){ // Kris 02.27.2013
				$("txtAccidentItemEffFromDate").value		= objAccidentItemInfo.effFromDate;
				$("txtAccidentItemEffToDate").value			= objAccidentItemInfo.effToDate;
				$("txtAccidentItemPlan").value				= objAccidentItemInfo.packageCd;
				$("txtAccidentItemPaymentMode").value		= objAccidentItemInfo.paytTerms;
			} else {			
				$("row2").hide();
				$("row3").hide();
			}
					
			$("txtAccidentItemNoOfPersons").value		= objAccidentItemInfo.noOfPersons;
			$("txtAccidentItemBirthday").value			= nvl(objAccidentItemInfo.dateOfBirth, "") != "" ? dateFormat(objAccidentItemInfo.dateOfBirth, "mm-dd-yyyy") : objAccidentItemInfo.dateOfBirth;
			$("txtAccidentItemPosition").value			= unescapeHTML2(objAccidentItemInfo.position);
			$("txtAccidentItemStatus").value			= unescapeHTML2(objAccidentItemInfo.status);
			$("txtAccidentItemSalary").value			= objAccidentItemInfo.monthlySalary;
			$("txtAccidentItemAge").value				= objAccidentItemInfo.age;
			$("txtAccidentItemSex").value				= unescapeHTML2(objAccidentItemInfo.sexDesc);
			$("txtAccidentItemSalaryGrade").value		= objAccidentItemInfo.salaryGrade;
			$("txtAccidentItemHeight").value			= unescapeHTML2(objAccidentItemInfo.height);
			$("txtAccidentItemWeight").value			= unescapeHTML2(objAccidentItemInfo.weight);
			$("txtAccidentItemDestination").value       = unescapeHTML2(objAccidentItemInfo.destination);
			$("txtAccidentItemTravelFromDate").value 	= objAccidentItemInfo.travelFromDate == null ? "" : dateFormat(objAccidentItemInfo.travelFromDate, "mm-dd-yyyy");
			$("txtAccidentItemTravelToDate").value 		= objAccidentItemInfo.travelToDate == null ? "" : dateFormat(objAccidentItemInfo.travelToDate, "mm-dd-yyyy");
		}
		
		if(moduleId == "GIPIS101"){
			$("txtAccidentItemItemNo").value			= acItem.itemNo;
			$("txtAccidentItemItemTitle").value			= unescapeHTML2(acItem.itemTitle);
		}

		$("btnReturnFromAccidentItemAddtlinfo").observe("click", function(){
			overlayAccidentItemAdditionalInfo.close();
		});
		
		$("btnAccidentItemDeductibles").observe("click", function(){
			moduleId == "GIPIS101" ? getItemDeductibleList2(nvl($("hidItemExtractId").value,0),nvl($("hidItemNo").value,0)) : getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0)) ;
//			getItemDeductibleList(nvl($("hidItemPolicyId").value,0),nvl($("hidItemNo").value,0));
		});

		$("btnAccidentItemGroupItems").observe("click", function(){
			if(moduleId == "GIPIS101"){
				overlayAccidentGroupedItemsTable = Overlay.show(contextPath+"/GIXXGroupedItemsController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXAccidentGroupedItems",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Grouped Items",
					width: 800,
					height: 420,
					draggable: true,
					showNotice: true
				  });
			} else {
				overlayAccidentGroupedItemsTable = Overlay.show(contextPath+"/GIPIGroupedItemsController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getAccidentGroupedItems",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Grouped Items",
					width: 800,
					height: 420,
					draggable: true,
					showNotice: true
				  });
			}
		});

		$("btnAccidentItemBeneficiary").observe("click", function(){
			if(moduleId == "GIPIS101"){
				overlayAccidentBeneficiaryTable = Overlay.show(contextPath+"/GIXXBeneficiaryController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getGIXXAccidentBeneficiaries",
						extractId 	: nvl($("hidItemExtractId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Beneficiaries",
					width: 800,
					height: 270,
					draggable: true,
					showNotice: true
				  });
			} else {
				overlayAccidentBeneficiaryTable = Overlay.show(contextPath+"/GIPIBeneficiaryController", {
					urlContent: true,
					urlParameters: {
						action 	 	: "getAccidentBeneficiaries",
						policyId 	: nvl($("hidItemPolicyId").value,0),
						itemNo		: nvl($("hidItemNo").value,0)
					},
					title: "Grouped Items",
					width: 800,
					height: 270,
					draggable: true,
					showNotice: true
				  });
			}
		});

		$("btnAccidentItemPicOrVid").observe("click", function(){
			showAttachmentList();
		});
		
	}catch(e){
		showErrorMessage("Accident Item", e);
	}

</script>