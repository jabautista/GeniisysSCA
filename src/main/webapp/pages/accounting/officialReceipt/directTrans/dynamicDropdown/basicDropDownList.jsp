<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: ${width}px;" tabindex="${tabIndex }" id="${listId }" name="${listName }" class="${className }">
	<option value=""></option>
	<c:forEach var="listVal" items="${listValues}">
		<option value="${listVal}">${listVal}</option>
	</c:forEach>
</select>