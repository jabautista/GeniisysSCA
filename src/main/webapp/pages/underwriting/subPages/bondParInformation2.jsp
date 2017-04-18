<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>PAR Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="parInfoMainDiv" name="parInfoMainDiv">
	<div id="parInfo" name="parInfo" style="margin: 10px;">
		<table align="center">
			<tr>
				<td class="rightAligned">PAR No.</td>
				<td class="leftAligned">
					<input type="text" style="width: 250px;" id="parNo" name="parNo" readonly="readonly" value=""/>
				</td>
				<td id="lblAssdTitle" class="rightAligned" width="100px">Assured Name</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="" /></td>					
			</tr>
		</table>
	</div>
</div>

<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	if(objUWGlobal.lineCd == "SU") $("lblAssdTitle").innerHTML = "Principal";
</script>
