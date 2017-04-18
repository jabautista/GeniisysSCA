<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="otherInformationDiv" name="otherInformationDiv">	
	<table align="center" width="659px;" border="0">
		<tr>
			<td class="rightAligned" style="width:187px;">Interest </td>
			<td class="leftAligned" >
				<input id="interestOnPremises" name="interestOnPremises" type="text" style="width: 357px;" maxlength="500"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Section/Hazard Information </td>
			<td class="leftAligned" >
				<input id="sectionOrHazardInfo" name="sectionOrHazardInfo" type="text" style="width: 357px;" maxlength="2000"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Conveyance </td>
			<td class="leftAligned" >
				<input id="conveyanceInfo" name="conveyanceInfo" type="text" style="width: 357px;" maxlength="60"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Property No. </td>
			<td class="leftAligned">
				<input id="propertyNo" name="propertyNo" type="text" style="width: 157px;" maxlength="30"/>
				<select  id="propertyNoType" name="propertyNoType" style="width: 196px;">
					<option value="" ></option>
					<option value="M" >Motor Number</option>
					<option value="S" >Serial Number</option>
				</select>
			</td>
		</tr>	
	</table>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
</script>	