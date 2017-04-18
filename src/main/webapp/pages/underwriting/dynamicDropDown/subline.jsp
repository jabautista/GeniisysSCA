<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select id="sublinecd" name="sublinecd" style="width: 99%;" class="required">
	<option></option>
	<c:forEach var="subline" items="${subLineListing}">
		<option value="${subline.sublineCd}">${subline.sublineName}</option>				
	</c:forEach>
</select>

<script type="text/javaScript">
$("sublinecd").observe("change",
	function() {
		$("sublineCd").value = $("sublinecd").value;
	}
);
</script>