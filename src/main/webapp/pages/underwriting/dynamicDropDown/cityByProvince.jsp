<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: ${width}px;" tabindex="7" id="city" name="city" class="required">
	<option value=""></option>
	<c:forEach var="cityList" items="${cityList}">
		<option value="${cityList.city}">${cityList.city}</option>
	</c:forEach>
</select>

<script>
	initializeAll();
	addStyleToInputs();
	$("city").observe("change", function ()	{
		new Ajax.Updater($("district").up("td", 0), contextPath+"/GIPIWFireItmController?action=filterDistrictByProvinceByCity", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function () {
				$("district").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
			parameters: {
				globalParId : $F("globalParId"),
				province: $("province").options[$("province").selectedIndex].text,
				city: $("city").options[$("city").selectedIndex].text,
				elementWidth : $("district").getWidth()
			}
		});
	});	
</script>