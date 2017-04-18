<div id="policyClaimsMainDiv" style="width:700px;margin:20px auto 10px auto;" >
	<div id="relatedClaimsDiv" name="relatedClaimsDiv" style="height:305px;"></div>
	<div align="center" style="margin-top:10px;padding:10px;">
		<input type="button" id="btnClaimInfo" name="btnClaimInfo" value="Claim Information" class="disabledButton"/>
		<input type="hidden" id="hidMenuLineCd" name="hidMenuLineCd" value="${menuLineCd}">
	</div>
</div>

<script>
//added by Kris 03.04.2013
	var moduleId = $F("hidModuleId"); 
	var gipis100path = "GICLClaimsController?action=getRelatedClaims&policyId="+$F("hidPolicyId");
	var gipis101path = "GIXXClaimsController?action=getGIXXRelatedClaims&extractId=" + $F("hidExtractId");
	objCLMGlobal.claimId = null;
	
	moduleId == "GIPIS101" ? $("btnClaimInfo").hide() : $("btnClaimInfo").show();
	
	function searchRelatedClaims(){
		new Ajax.Updater("relatedClaimsDiv", ( moduleId == "GIPIS101" ? gipis101path : gipis100path ) ,{  // modified by Kris 03.04.2013
			method:"get",
			evalScripts: true
		});
	}
	
	searchRelatedClaims();
	
	observeAccessibleModule(accessType.BUTTON, "GICLS260", "btnClaimInfo", 
		function(){
			if(nvl(objCLMGlobal.claimId, null) == null){
				showMessageBox("Please select claim record first.", "I");
			}else{
				objCLMGlobal.callingForm = "GIPIS100";
				//showClaimInformationMain("polMainInfoDiv"); //replaced by code below -- robert SR 21694 03.28.16
				showGIPIS100ClaimInfoListing(objCLMGlobal.claimId);
			}
		}
	);
	
	if($("lineCd") != null){
		$("lineCd").value = $("hidLineCd").value;
		$("menuLineCd").value = $("hidMenuLineCd").value;
	}
</script>