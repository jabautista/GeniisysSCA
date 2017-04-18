<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select style="width: 132px;" tabindex="7" id="city${aiItemNo}" name="city">
	<option value=""></option>
	<c:forEach var="cityList" items="${cityList}">
		<option value="${cityList.cityCd}">${cityList.city}</option>
	</c:forEach>
</select>

<script>
	initializeAll();
	addStyleToInputs();
	$("city${aiItemNo}").observe("change", function ()	{
		new Ajax.Updater($("district${aiItemNo}").up("td", 0), contextPath+"/GIPIQuotationFireController?action=filterDistrictByProvinceByCity", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			onCreate: function (){
				//Ajax.Responders.unregister(quotationMainResponder);
				$("district${aiItemNo}").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
			},
			parameters: {
				province: 	$("province${aiItemNo}").options[$("province${aiItemNo}").selectedIndex].text,
				city: 		$("city${aiItemNo}").options[$("city${aiItemNo}").selectedIndex].text,
				fireItemNo:	"${aiItemNo}"
			},onComplete: function() {
				//Ajax.Responders.register(quotationMainResponder);
				   
			}
		});
	});	
</script>