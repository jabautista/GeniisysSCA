<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select style="width: ${width}px;" tabindex="12" id="risk" name="risk" class="required">
	<option value=""></option>
	<c:forEach var="riskList" items="${riskList}">
		<option value="${riskList.riskCd}">${riskList.riskDesc}</option>
	</c:forEach>
</select>