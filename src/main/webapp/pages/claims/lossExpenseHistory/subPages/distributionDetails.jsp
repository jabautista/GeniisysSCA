<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Distribution Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="distDtlGro" name="gro" style="margin-left: 5px;">Show</label>
		</span>
	</div>
</div>
<div id="distDetailsMainDiv" name="distDetailsMainDiv" style="display: none;">
	<div class="sectionDiv" id="lossExpDsTableGridDiv" name="lossExpDsTableGridDiv" style="display: none;"></div>
	<div class="sectionDiv" id="lossExpRidsTableGridDiv" name="lossExpRidsTableGridDiv" style="display: none;"></div>
</div>
<script type="text/javascript">
try{
	
}catch(e){
	
}
</script>