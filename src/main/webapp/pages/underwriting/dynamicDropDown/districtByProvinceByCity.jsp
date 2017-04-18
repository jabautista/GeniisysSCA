<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: ${width}px;" tabindex="9" id="district" name="district" class="required">
	<option value=""></option>
	<c:forEach var="districtList" items="${districtList}">
		<option value="${districtList.districtNo}">${districtList.districtNo}</option>
	</c:forEach>
</select>

<script>
	initializeAll();
	addStyleToInputs();
	$("district").observe("change", function ()	{
		new Ajax.Updater($("block").up("td", 0), contextPath+"/GIPIWFireItmController?action=filterBlock", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function () {
				$("block").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
			parameters: {
				globalParId : $F("globalParId"),
				province: $("province").options[$("province").selectedIndex].text,
				city: $("city").options[$("city").selectedIndex].text,
				district: $("district").options[$("district").selectedIndex].text,
				elementWidth : $("block").getWidth()
			}
		});
	});	
</script>
