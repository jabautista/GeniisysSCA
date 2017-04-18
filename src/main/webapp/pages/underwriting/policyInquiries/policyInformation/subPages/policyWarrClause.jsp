
<div id="policyWarrClauseMainDiv" style="margin:10px auto 0px auto;">

	<div id="relatedWcInfoDiv" name="relatedWcInfoDiv"></div>
	
</div>
<script>
	var moduleId = $F("hidModuleId"); // added by Kris 03.01.2013 for GIPIS101	
	moduleId == "GIPIS101" ? searchRelatedWcInfo101() : searchRelatedWcInfo();
	
	function searchRelatedWcInfo(){
		new Ajax.Updater("relatedWcInfoDiv","GIPIPolwcController?action=getRelatedWcInfo&policyId="+$F("hidPolicyId"),{
			method:"get",
			evalScripts: true
		});
	}
	
	
	// function for GIPIS101
	function searchRelatedWcInfo101(){
		new Ajax.Updater("relatedWcInfoDiv","GIXXPolwcController?action=getGIXXRelatedWcInfo&extractId="+$F("hidExtractId"),{
			method:"get",
			evalScripts: true
		});
	}

</script>