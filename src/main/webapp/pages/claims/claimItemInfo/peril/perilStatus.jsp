<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perilStatusMainDiv" style="float: left; width: 100%;">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Peril Status</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="groPerilStatus" name="groPerilStatus" style="margin-left: 5px;">Show</label>
				<label id="loadPerilStatus" name="loadPerilStatus" style="margin-left: 5px; display: none;">Loading...</label>
			</span>
		</div>
	</div>
	<div id="perilStatusDiv" name="perilStatusDiv" class="sectionDiv" style="margin: 0px; display: none;">
		&nbsp;
	</div>
</div>	
<script type="text/javascript">
	$("groPerilStatus").observe("click", function(){
		if (nvl(objCLMItem.selItemIndex,null) == null && $("groPerilStatus").innerHTML == "Show"){
			showMessageBox("Please select item first.", "I");
			return false;
		}
		//check any changes first
		if (nvl(itemGrid,null) instanceof MyTableGrid){
			observeChangeTagInTableGrid(itemGrid);
			itemGrid.releaseKeys();
		}	
		if (nvl(perilGrid,null) instanceof MyTableGrid){
			observeChangeTagInTableGrid(perilGrid);
			perilGrid.releaseKeys();
		}
		
		if (changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "E");
			return false;
		}
		
		if ($("groPerilStatus").innerHTML == "Show"){
			$("perilStatusDiv").innerHTML = "";
			$("groPerilStatus").hide();
			$("loadPerilStatus").show();
			$("groPerilStatus").innerHTML = "Hide";
		}else{
			$("groPerilStatus").innerHTML = "Show";
		}
		var infoDiv = $("groPerilStatus").up("div", 1).next().readAttribute("id");
		Effect.toggle(infoDiv, "blind", {
			duration: .3,
			afterFinish: function () {
				if ($("groPerilStatus").innerHTML == "Hide"){
					getClmItemPerilStatus($F("txtItemNo"));
				}
			}	
		});
	});
</script>