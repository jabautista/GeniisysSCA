<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
  <div id="innerDiv" name="innerDiv">
     <label>Endt Additional Engineering Information</label> 
      <span class="refreshers" style="margin-top: 0;"> 
       <label name="gro" style="margin-left: 5px;">Hide</label> 
      </span>
  </div>
</div>
<div class="sectionDiv" id="endtEngineeringAdditionalInformationDiv">
	<div>
	<table width="60%" cellspacing="2" style="margin-left: 148px; margin-top: 20px;" border="0">
		<tr>
			<td class="rightAligned" width="20%">Subline</td>
			<td class="leftAligned" colspan="3"><input type="text" id="enSublineName" name="enSublineName" value="${enSublineName}" readonly="readonly" style="width: 94.5%;"/></td>
		</tr>
		<tr>
			<td class="rightAligned" width="25%">Inception Date</td>
			<td class="leftAligned" width="25%">
				<input type="text" id="enInceptDate" name="enInceptDate" readonly="readonly" value="${enInceptDate}"/>
			</td>
			<td class="rightAligned" width="20%">Issue Date</td>
			<td class="leftAligned" width="30%">
				<input type="text" id="enExpiryDate" name="enIssueDate" readonly="readonly" value="${enIssueDate}"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="25%">Expiry Date</td>
			<td class="leftAligned" width="25%">
				<input type="text" id="enInceptDate" name="enExpiryDate" readonly="readonly" value="${enExpiryDate}"/>
			</td>
			<td class="rightAligned" width="20%">Effectivity Date</td>
			<td class="leftAligned" width="30%">
				<input type="text" id="enExpiryDate" name="enEffectivityDate" readonly="readonly" value="${enEffectivityDate}"/>
			</td>
		</tr>
		<tr>
			<td style="height: 20px;"> </td>
		</tr>
	</table>
	</div>
	<table width="60%" cellspacing="2" style="margin-left: 148px;" border="0">
		<tr>
			<td class="rightAligned" width="24%"><label id="titleText" style="float: right;">Title</label></td>
			<td><input type="text" id="enTitle" style="width: 387px; margin-left: 3px;" /></td>
		</tr>
		<tr>
			<td class="rightAligned" width="24%"><label id="locationText" style="float: right;">Location</label></td>
			<td><input type="text" id="enLocation" style="width: 387px; margin-left: 3px;" /></td>
		</tr>
		<tr>
			<td class="rightAligned" width="24%"><label id="prompt1Text" style="float: right;">Prompt1</label></td>
			<td><input type="text" id="enPrompt1" style="width: 387px; margin-left: 3px;" /></td>
		</tr>
	</table>
	<table width="60%" cellspacing="2" style="margin-left: 148px; margin-bottom: 20px;" border="0">
		<tr>
			<td class="rightAligned" width="25.5%"><label id="titleText" style="float: right;">Prompt2</label></td>
			<td class="leftAligned" width="24.5%">
				<input type="text" id="enInceptDate" name="enExpiryDate" readonly="readonly" value="${enExpiryDate}"/>
			</td>
			<td class="rightAligned" width="20%"><label id="titleText" style="float: right;">Prompt4</label></td>
			<td class="leftAligned" width="30%">
				<input type="text" id="enExpiryDate" name="enEffectivityDate" readonly="readonly" value="${enEffectivityDate}"/>
			</td>
		</tr>
	</table>
</div>