<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select style="width: 92.5%;" tabindex="12" id="makeCd${aiItemNo}" name="makeCd">
	<option value=""></option>
	<c:forEach var="make" items="${makes}">
		<option value="${make.makeCd}">${make.make}</option>
	</c:forEach>
</select>
<script>
	initializeAll();
	addStyleToInputs();
	$("makeCd${aiItemNo}").observe("change", function ()	{
		new Ajax.Updater($("engineSeries${aiItemNo}").up("td", 0), contextPath+"/GIPIQuotationMotorCarController?action=filterEngineSeries", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function () {
				$("engineSeries${aiItemNo}").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
			parameters: {
			quoteId: 		$F("quoteId"),
			make: 			$F("makeCd${aiItemNo}"),
			carCompanyCd: 	$F("carCompany${aiItemNo}"),
			aiItemNo:		"${aiItemNo}"
		}
	 });
	});
</script>