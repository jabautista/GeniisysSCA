<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select id="itemPeril" name="itemPeril" style="width: 218px;display:block;">
	<option value="0"/>Select...</option>
	<c:forEach var="perils" items="${perilListing}">
		<option value="${perils.perilCd}">${perils.perilName}</option>				
	</c:forEach>
</select>
