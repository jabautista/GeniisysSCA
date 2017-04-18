<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mortgageeInfoMainDiv" style="float: left; width: 100%;">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Mortgagee Information</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="groMortgagee" name="groMortgagee" style="margin-left: 5px;">Show</label>
				<label id="loadMortgagee" name="loadMortgagee" style="margin-left: 5px; display: none;">Loading...</label>
			</span>
		</div>
	</div>
	<div id="mortgageeInfoDiv" name="mortgageeInfoDiv" class="sectionDiv" style="margin: 0px; display: none;">
		&nbsp;
	</div>
</div>
<script type="text/javascript">
	$("groMortgagee").observe("click", function(){
		if (nvl(objCLMItem.selItemIndex,null) == null && $("groMortgagee").innerHTML == "Show"){
			showMessageBox("Please select item first.", "I");
			return false;
		}
		//check any changes first
		if (nvl(itemGrid,null) instanceof MyTableGrid) observeChangeTagInTableGrid(itemGrid);
		if (nvl(perilGrid,null) instanceof MyTableGrid) observeChangeTagInTableGrid(perilGrid);
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "E");
			return false;
		}
		
		if ($("groMortgagee").innerHTML == "Show"){
			$("mortgageeInfoDiv").innerHTML = "";
			$("groMortgagee").hide();
			$("loadMortgagee").show();
			$("groMortgagee").innerHTML = "Hide";
		}else{
			$("groMortgagee").innerHTML = "Show";
		}
		var infoDiv = $("groMortgagee").up("div", 1).next().readAttribute("id");
		Effect.toggle(infoDiv, "blind", {
			duration: .3,
			afterFinish: function () {
				if ($("groMortgagee").innerHTML == "Hide"){
					getClmItemMortgagee($F("txtItemNo"));
				}
			}	
		});
	});
</script>