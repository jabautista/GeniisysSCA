<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="roadMapMainDiv" name="roadMapMainDiv" class="sectionDiv" style="border: none;">
	<div id="roadMapDiv" name="roadMapDiv" style="margin: 20px 0px; margin-left:20px; width: 40%; float: left;">
		<canvas id="roadmapCanvasLayer1" height="440" width="160"
				style="z-index: 2; left: 20px; top: 50px;">
			Your Browser does not support the html5 canvas element.
		</canvas>
		<div id="roadMapCanvasLabelDiv" name="roadMapCanvasLabelDiv" style="height: 20px; text-align: center;">
			<label id="roadMapCanvasLabel" name="roadMapCanvasLabel" style="width:160px; text-align: center; font-weight: bold; margin-top: 5px;"></label>
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
	
	setRoadMapFromParStatus(par, wpolbas, "N", moduleId, userId);

</script>