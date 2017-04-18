<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="benInfoMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Beneficiary Details</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="groBenInfo" name="groBenInfo" style="margin-left: 5px;">Show</label>
				<label id="loadBenInfo" name="loadBenInfo" style="margin-left: 5px; display: none;">Loading...</label>
			</span>
		</div>
	</div>
	<div id="benInfoDiv" name="benInfoDiv" class="sectionDiv" style="margin: 0px; display: none;">
		&nbsp;
	</div>
</div>	
<script type="text/javascript">

function refreshBenInfo(param){
	try{
		var infoDiv = $("groBenInfo").up("div", 1).next().readAttribute("id");
		Effect.toggle(infoDiv, "blind", {
			duration: .3,
			afterFinish: function () {
				if ($("groBenInfo").innerHTML == "Hide" && param){
					getClaimItemBenInfo();
				}
			}	
		});
	}catch(e){
		showErrorMessage("refreshBenInfo", e);
	}
}

$("groBenInfo").observe("click", function(){
	if (nvl(objCLMItem.selItemIndex,null) == null && $("groBenInfo").innerHTML == "Show"){
		showMessageBox("Please select item first.", "I");
		return false;
	}

	if (changeTag == 1 && Number(objCLMItem.selItemIndex) >= 0){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}
	
	if ($("groBenInfo").innerHTML == "Show"){
		$("groBenInfo").innerHTML = "Hide";
	}else{
		$("groBenInfo").innerHTML = "Show";
		
	}
	
	if (checkBeneficiaryChanges()){
		refreshBenInfo(false);
	}else{
		refreshBenInfo(true);
	}
});
</script>