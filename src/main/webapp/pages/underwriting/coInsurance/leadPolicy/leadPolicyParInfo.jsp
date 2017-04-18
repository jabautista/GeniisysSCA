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
		<label id="lblParInfoTitle"><c:if test="${'Y' eq isPack}">Package </c:if>PAR Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="lpParInfoMainDiv" name="lpParInfoMainDiv">
	<div id="lpParInfo" name="lpParInfoTop" style="margin: 10px;">
		<table align="center" border="0">
			<tr>
				<td class="rightAligned" id="tdParNoLabel"><c:if test="${'Y' eq isPack}">Pack </c:if>PAR No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="parNo" name="parNo" readonly="readonly" value="${parNo}"/></td>
				<td id="assdTitle" name="assdTitle" class="rightAligned" width="100px">Assured Name</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${assdName}" /></td>					
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td class="rightAligned">
					<label id="lblAcctOf" style="float: right;">In Account Of</label>	
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 250px;" id="acctOfName" name="acctOfName" readonly="readonly" value="${acctOfName}" />
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javaScript">
	$("parNo").value = objUWParList.parNo;
	//$("assuredName").value = changeSingleAndDoubleQuotes(objUWParList.assdName); // replaced by: Nica 5.23.2013
	$("assuredName").value = unescapeHTML2(objUWParList.assdName);

	$("parNo").setAttribute("title", objUWParList.parNo);
	//$("assuredName").setAttribute("title", changeSingleAndDoubleQuotes(objUWParList.assdName));
	$("assuredName").setAttribute("title", unescapeHTML2(objUWParList.assdName)); // replaced by: Nica 5.23.2013
</script>
