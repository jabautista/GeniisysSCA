<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="roadMapMainDiv" name="roadMapMainDiv" class="sectionDiv" style="border: none;">
	<div id="roadMapDiv" name="roadMapDiv" style="margin: 20px; width: 40%; float: left;">
		<canvas id="roadmapCanvasLayer" height="450" width="220" 
				style="z-index: 2; left: 20px; top: 40px;">
			Your Browser does not support the html5 canvas element.
		</canvas>
		<div id="packRoadMapCanvasLabelDiv" name="packRoadMapCanvasLabelDiv" style="height: 10px; text-align: center;">
			<label id="packRoadMapCanvasLabel" name="packRoadMapCanvasLabel" style="width:220px; text-align: center; font-weight: bold; margin-top: 5px;"></label>
		</div>
	</div>
	<jsp:include page="/pages/underwriting/roadMap/legend.jsp"></jsp:include>
</div>

<script type="text/javascript">
	
	$("cancelRoadMap").observe("click", function(){
		winRoadMap.close();
	});
	
	var par = JSON.parse('${jsonPAR}'.replace(/\\/g, '\\\\'));
	var wpolbas = JSON.parse('${jsonWPolbas}'.replace(/\\/g, '\\\\'));
	var userId = '${userId}';
	var moduleId = $("lblModuleId").getAttribute("moduleId");
	paramBBI = '${paramBBI}';
	clearObjectValues(objRoadMapAvail);

	setRoadMapFromParStatus(par, wpolbas, "Y", moduleId, userId);	
	
</script>