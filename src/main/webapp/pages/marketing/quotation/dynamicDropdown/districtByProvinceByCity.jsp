<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: 132px;" tabindex="9" id="district${aiItemNo}" name="district">
	<option value=""></option>
	<c:forEach var="districtList" items="${districtList}">
		<option value="${districtList.districtNo}">${districtList.districtNo}</option>
	</c:forEach>
</select>

<script>
	initializeAll();
	addStyleToInputs();
	$("district${aiItemNo}").observe("change", function ()	{
		new Ajax.Updater($("block${aiItemNo}").up("td", 0), contextPath+"/GIPIQuotationFireController?action=filterBlock", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function () {
				Ajax.Responders.unregister(quotationMainResponder);
				$("block${aiItemNo}").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
			parameters: {
				province: 	$("province${aiItemNo}").options[$("province${aiItemNo}").selectedIndex].text,
				city: 		$("city${aiItemNo}").options[$("city${aiItemNo}").selectedIndex].text,
				district: 	$("district${aiItemNo}").options[$("district${aiItemNo}").selectedIndex].text,
				fireItemNo:		"${aiItemNo}"
			},onComplete: function() {
				Ajax.Responders.register(quotationMainResponder);
				   
			}
		});
	});	
</script>
