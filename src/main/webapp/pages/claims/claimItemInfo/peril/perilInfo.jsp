<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perilInfoMainDiv" style="margin-bottom:-1px; float: left; width: 100%;">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Peril Information</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="groPerilInfo" name="groPerilInfo" style="margin-left: 5px;">Show</label>
				<label id="loadPerilInfo" name="loadPerilInfo" style="margin-left: 5px; display: none;">Loading...</label>
			</span>
		</div>
	</div>
	<div id="perilInfoDiv" name="perilInfoDiv" class="sectionDiv" style="margin: 0px; display: none;">
		&nbsp;
	</div>
</div>	
<script type="text/javascript">

	function refreshPeril(param){
		try{
			var infoDiv = $("groPerilInfo").up("div", 1).next().readAttribute("id");
			Effect.toggle(infoDiv, "blind", {
				duration: .3,
				afterFinish: function () {
					if ($("groPerilInfo").innerHTML == "Hide" && param){
						getClmItemPeril($F("txtItemNo"));
					}
				}	
			});
		}catch(e){
			showErrorMessage("refreshPeril", e);
		}
	}

	$("groPerilInfo").observe("click", function(){
		if (nvl(objCLMItem.selItemIndex,null) == null && $("groPerilInfo").innerHTML == "Show"){
			showMessageBox("Please select item first.", "I");
			return false;
		}
		//check any changes first 
		//if (nvl(itemGrid,null) instanceof MyTableGrid) observeChangeTagInTableGrid(itemGrid);
		//check any changes first
		if (nvl(itemGrid,null) instanceof MyTableGrid){
			itemGrid.releaseKeys();
		}	
		if (nvl(perilGrid,null) instanceof MyTableGrid){
			observeChangeTagInTableGrid(perilGrid);
			perilGrid.releaseKeys();
		}
		if (changeTag == 1 && Number(objCLMItem.selItemIndex) >= 0){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}

		if ($("groPerilInfo").innerHTML == "Show"){
			if (!checkPerilChanges()){
				$("perilInfoDiv").innerHTML = "";
				$("loadPerilInfo").show();
				$("groPerilInfo").hide();
			}	
			$("groPerilInfo").innerHTML = "Hide";
		}else{
			$("groPerilInfo").innerHTML = "Show";
			
		}
		if (checkPerilChanges()){
			refreshPeril(false);
		}else{
			refreshPeril(true);
		}
	});
</script>