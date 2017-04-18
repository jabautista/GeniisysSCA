<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: 132px;" tabindex="10" id="block${aiItemNo}" name="block">
	<option value=""></option>
	<c:forEach var="blockList" items="${blockList}">
		<option value="${blockList.blockId}">${blockList.blockNo}</option>
	</c:forEach>
</select>
<script>
	initializeAll();
	addStyleToInputs();

	$("block${aiItemNo}").observe("change", function ()	{
		new Ajax.Updater($("risk${aiItemNo}").up("td", 0), contextPath+"/GIPIQuotationFireController?action=filterRisk", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function () {
				//Ajax.Responders.unregister(quotationMainResponder);
				$("risk${aiItemNo}").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
				
			},
			parameters: {
				block: $("block${aiItemNo}").options[$("block${aiItemNo}").selectedIndex].text,
				fireItemNo:	"${aiItemNo}"
			},
			onComplete: function() {
				//Ajax.Responders.register(quotationMainResponder);
				
			}
		});
	});	
</script>
