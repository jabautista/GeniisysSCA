<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: ${width}px;" tabindex="10" id="block" name="block" class="required">
	<option value=""></option>
	<c:forEach var="blockList" items="${blockList}">
		<option value="${blockList.blockId}">${blockList.blockNo}</option>
	</c:forEach>
</select>
<script>
	initializeAll();
	addStyleToInputs();

	$("block").observe("change", function ()	{
		new Ajax.Updater($("risk").up("td", 0), contextPath+"/GIPIWFireItmController?action=filterRisk", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function () {
				$("risk").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
			parameters: {
				globalParId : $F("globalParId"),
				block: $F("block"), //$("block").options[$("block").selectedIndex].text,
				elementWidth : $("risk").getWidth()				
			}
		});
	});	
</script>
