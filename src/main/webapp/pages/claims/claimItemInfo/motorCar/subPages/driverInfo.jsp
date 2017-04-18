<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="driverInfoMainDiv" style="float: left; width: 100%;">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Driver Details</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="groDriverInfo" name="groDriverInfo" style="margin-left: 5px;">Show</label>
				<label id="loadDriverInfo" name="loadDriverInfo" style="margin-left: 5px; display: none;">Loading...</label>
			</span>
		</div>
	</div>
	<div id="driverInfoDtlsDiv" name="driverInfoDtlsDiv" class="sectionDiv" style="margin: 0px; display: none;">
		&nbsp;
	</div>
</div>
<script type="text/javascript">
	$("groDriverInfo").observe("click", function(){
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
		if ($("groDriverInfo").innerHTML == "Show"){
			$("driverInfoDtlsDiv").innerHTML = "";
			$("groDriverInfo").hide();
			$("loadDriverInfo").show();
			$("groDriverInfo").innerHTML = "Hide";
		}else{
			$("groDriverInfo").innerHTML = "Show";
		}
		
		var infoDiv = $("groDriverInfo").up("div", 1).next().readAttribute("id");
		Effect.toggle(infoDiv, "blind", {
			duration: .3,
			afterFinish: function () {
				if ($("groDriverInfo").innerHTML == "Hide"){
					objCLMGlobal.driverInfoPopulateSw = "Y";
					getClmDriverInfoDtls(objCLMGlobal.claimId);
				} else {
					objCLMGlobal.driverInfoPopulateSw = "N";
				}
			}	
		});
	});
</script>