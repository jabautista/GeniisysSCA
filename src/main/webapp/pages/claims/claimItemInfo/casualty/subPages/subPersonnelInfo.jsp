<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Personnel</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="casualtyPersonnelInfoDiv" name="casualtyPersonnelInfoDiv" class="sectionDiv" style="margin: 0px;" changeTagAttr="true">
	<div id="personnelCaOuterDiv" class="sectionDiv" style="border: none;">
		<div id="personnelCaInfoGrid" style="border: none; position: relative; padding-left: 50px; padding-right: 50px; padding-top: 20px; padding-bottom: 20px; width: 800px;">
			&nbsp;
		</div> 
	</div>	
</div>
