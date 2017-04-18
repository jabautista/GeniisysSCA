<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="availmentsMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Availments</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="groAvailInfo" name="groAvailInfo" style="margin-left: 5px;">Show</label>
			</span>
		</div>
	</div>
	<div id="availInfoDiv" name="availInfoDiv" class="sectionDiv" style="margin: 0px; display: none;">
		&nbsp;
	</div>
</div>	
<script type="text/javascript">

function refreshAvailInfo(){
	try{
		var infoDiv = $("groAvailInfo").up("div", 1).next().readAttribute("id");
		Effect.toggle(infoDiv, "blind", {
			duration: .3,
			afterFinish: function () {
				if ($("groAvailInfo").innerHTML == "Hide"){
					getClaimAvailmentsInfo();
				}
			}	
		});
	}catch(e){
		showErrorMessage("refreshAvailInfo", e);
	}
}

$("groAvailInfo").observe("click", function(){
	if (nvl(objCLMItem.selItemIndex,null) == null && $("groAvailInfo").innerHTML == "Show"){
		showMessageBox("Please select item first.", "I");
		return false;
	}
	
	if ($("groAvailInfo").innerHTML == "Show"){
		$("groAvailInfo").innerHTML = "Hide";
	}else{
		$("groAvailInfo").innerHTML = "Show";
		
	}
	refreshAvailInfo();
});
</script>