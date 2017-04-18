<div id="div1" style="">
	<div id="div2" style="margin: 10px auto auto auto;width:850px;margin:10px auto 10px auto;">
		Enrollee&nbsp;&nbsp;
		<input type="text" id="txtEnrolleeCode" style="width:80px;" readonly="readonly"/>
		<input type="text" id="txtEnrolleeName" style="width:500px;" readonly="readonly"/>
	</div>


	<div id="accidentGrpItemsBeneficiaryDiv" style="height:160px;"></div>
	
	<div id="accidentItmperilBeneficiaryDiv" style="margin: 10px auto auto auto;height:160px;"></div>
	
	<div id="remarksDiv" style="margin: 10px auto auto auto;width:850px;margin:10px auto 10px auto;">
		Remarks:&nbsp;&nbsp;
		<input type="text" id="txtEnrolleeRemarks" style="width: 780px;" readonly="readonly" />
	</div>
	
	<div style="width:850px;margin:10px auto 10px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromAccidentGrpItemsBeneficiary" name="btnReturnFromAccidentGroupedItems" value="Ok" style="width:150px;"/>
	</div>
</div>


<script>

	var moduleId = $F("hidModuleId");

	//initialization
	var objEnrollee = JSON.parse('${enrollee}'.replace(/\\/g, '\\\\'));
	
	if (objEnrollee.enrolleeCode == undefined){
		$("txtEnrolleeCode").value = "";
	}else{
		$("txtEnrolleeCode").value = objEnrollee.enrolleeCode;
	}
	if (objEnrollee.enrolleeName == undefined){
		$("txtEnrolleeName").value = "";
	}else{
		$("txtEnrolleeName").value = unescapeHTML2(objEnrollee.enrolleeName);
	}
	
	if(moduleId == "GIPIS101"){
		searchGrpItemsBeneficiaries101();
		$("accidentItmperilBeneficiaryDiv").hide();		
		$("txtEnrolleeRemarks").value = unescapeHTML2(nvl(objEnrollee.enrolleeRemarks, ""));
	} else {
		searchGrpItemsBeneficiaries();
		searchItemperilBeneficiaries();
		$("remarksDiv").hide();
	}
	
	//button actions
	$("btnReturnFromAccidentGrpItemsBeneficiary").observe("click", function(){
		overlayAccidentGrpItemsBeneficiary.close();
	});
	//function definition
	function searchGrpItemsBeneficiaries(){
		new Ajax.Updater("accidentGrpItemsBeneficiaryDiv","GIPIGrpItemsBeneficiaryController?action=getAccidentGrpItemBeneficiaries",{
			method:"get",
			evalScripts: true,
			parameters: {
				policyId		:nvl($F("hidGroupedItemsPolicyId"),0),
				itemNo			:nvl($F("hidGroupedItemsItemNo"),0),
				groupedItemNo	:nvl($F("hidGroupedItemsGroupedItemNo"),0)

			}
		});
	}
	function searchItemperilBeneficiaries(){
		new Ajax.Updater("accidentItmperilBeneficiaryDiv","GIPIItmperilBeneficiaryController?action=getAccidentItemPerilBeneficiaries",{
			method:"get",
			evalScripts: true,
			parameters: {
				policyId		:nvl($F("hidGroupedItemsPolicyId"),0),
				itemNo			:nvl($F("hidGroupedItemsItemNo"),0),
				groupedItemNo	:nvl($F("hidGroupedItemsGroupedItemNo"),0)

			}
		});
	}
	
	
	
	// added by Kris 02.28.2013: function for GIPIS101
	function searchGrpItemsBeneficiaries101(){
		new Ajax.Updater("accidentGrpItemsBeneficiaryDiv","GIXXGrpItemsBeneficiaryController?action=getGIXXAccidentGrpItemsBeneficiary",{
			method:"get",
			evalScripts: true,
			parameters: {
				extractId		:nvl($F("hidGroupedItemsExtractId"),0),
				itemNo			:nvl($F("hidGroupedItemsItemNo"),0),
				groupedItemNo	:nvl($F("hidGroupedItemsGroupedItemNo"),0)

			}
		});
	}
	
</script>