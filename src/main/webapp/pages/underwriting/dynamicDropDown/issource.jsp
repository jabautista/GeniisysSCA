<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<select id="isscd" name="isscd" style="width: 99%;" class="required">
	<option></option>
	<c:forEach var="issource" items="${issourceListing}">
		<option value="${issource.issCd}">${issource.issName}</option>				
	</c:forEach>
</select>

<script type="text/javaScript">

	$("isscd").observe("change",
			function(){
			$("vissCd").value = $("isscd").value;
	});
	
	if (($("selectedIssCd").value == "") || ($("selectedIssCd").value == null)){
		getIssCd("default");
	}
	else {
		getIssCd("selected");
	}
	
	function getIssCd(type){
		var issCd 		 = "";
		if (type == "default") {
			issCd = $("defaultIssCd").value;
		}
		else if (type == "selected") {
			issCd = $("selectedIssCd").value;
		}
		var issList		 = $("isscd");
		var index		 = 0;
		for (var j=0; j<issList.length; j++){
			if (issList.options[j].value == issCd){
				index = j;
			}
		}
		$("isscd").selectedIndex	= index;
		$("vissCd").value 			= issCd;
		
	}
</script>