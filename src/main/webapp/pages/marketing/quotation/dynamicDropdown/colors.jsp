<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select style="width: 208px;" tabindex="14" id="colorCd${aiItemNo}" name="colorCd">
	<option value=""></option>
	<c:forEach var="color" items="${colors}">
		<option value="${color.colorCd}" bColor="${color.basicColor}" bCode="${color.basicColorCd}">${color.color}</option>
	</c:forEach>
</select>
<script>
	initializeAll();
	addStyleToInputs();

	$("colorCd${aiItemNo}").observe("change", function () {
		var bCode = $("colorCd${aiItemNo}").options[$("colorCd${aiItemNo}").selectedIndex].bCode;
		for (var i=0; i<$("basicColor${aiItemNo}").length; i++) {
			if ($("basicColor${aiItemNo}").options[i].value == bCode) {
				$("basicColor${aiItemNo}").selectedIndex = i;
			}
		}
	});
</script>