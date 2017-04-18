<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select style="width: 92.5%;;" tabindex="15" id="engineSeries${aiItemNo}" name="engineSeries">
	<option value=""></option>
	<c:forEach var="es" items="${engineSeries}">
		<option value="${es.seriesCd}">${es.engineSeries}</option>
	</c:forEach>
</select>
<script>
	initializeAll();
	addStyleToInputs();
</script>