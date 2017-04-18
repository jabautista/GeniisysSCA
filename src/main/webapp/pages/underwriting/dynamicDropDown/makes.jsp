<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select style="width: 92.5%;" tabindex="12" id="makeCd" name="makeCd">
	<option value=""></option>
	<c:forEach var="make" items="${makes}">
		<option value="${make.makeCd}">${make.make}</option>
	</c:forEach>
</select>
<script>
	initializeAll();
	addStyleToInputs();
	$("makeCd").observe("change", function ()	{		
		new Ajax.Updater($("engineSeries").up("td", 0),
			 contextPath+"/GIPIParMCItemInformationController?action=filterEngineSeries",
			 {
				evalScripts: true,
				asynchronous: true,
				method: "GET",
				onCreate: 
					function () {						
						$("engineSeries").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
				},
				parameters: {
					globalParId: $F("globalParId"),
					make: $F("makeCd"),
					carCompanyCd: $F("carCompany")
				}
			 });		 
	});
</script>