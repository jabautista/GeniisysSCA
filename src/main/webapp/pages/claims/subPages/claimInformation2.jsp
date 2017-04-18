<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Claim Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label>
			<input type="hidden" id="lineCd" name="lineCd">
		</span>
	</div>
</div>

<div class="sectionDiv" id="parInfoMainDiv" name="parInfoMainDiv">
	<div id="parInfo" name="parInfoTop" style="margin: 10px;">
		<table align="center" border="0">
			<tr>
				<td class="rightAligned">Claim Number</td>
				<td class="leftAligned">
					<div class="required" style="float: left; border: solid 1px gray; width: 257px; height: 20px;">
						<input id="claimNo" name="claimNo" type="text" style="width: 232px; border: none; background-color: transparent;" value="" readonly="readonly"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnClaimNo" name="btnClaimNo" alt="Go" />						
					</div>
				</td>
				<td id="lossCatTitle" name="lossCatTitle" class="rightAligned" width="100px">Loss Category</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="lossCat" name="lossCat" readonly="readonly" value="" /></td>					
			</tr>
			<tr>
				<td class="rightAligned">Policy Number</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="policyNo" name="policyNo" readonly="readonly" value=""/></td>
				<td class="rightAligned"><label id="lossDateTitle" style="float: right;">Loss Date</label></td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="lossDate" name="acctOfName" readonly="readonly" value="" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Assured</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value=""/></td>
				<td class="rightAligned"><input type="hidden" id="showClaimStat" name="showClaimStat" <c:choose><c:when test="${not empty showClaimStat}">value="Y"</c:when><c:otherwise>value="N"</c:otherwise></c:choose>></td>
				<td class="leftAligned"><label id="lblClaimStat" style="float: right; font-weight: bolder;">&nbsp;</label></td>
			</tr>
		</table>
	</div>
</div>