<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: ${width}px;" tabindex="${tabIndex }" id="${listId }" name="${listName }" class="${className }">
	<option value="" claimId="" adviceId=""></option>
	<c:forEach var="advice" items="${listValues}">
		<option value="${advice.adviceSequenceNumber}" claimId="${advice.claimId }" adviceId="${advice.adviceId }">${advice.adviceSequenceNumber}</option>
	</c:forEach>
</select>