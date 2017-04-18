<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="contentsDiv">
	<div style="padding: 10px; height: 370px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnLossAdviceOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnLossAdviceCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	searchLossAdviceModal(1,"");

	//when CANCEL button click
	$("btnLossAdviceCancel").observe("click", function (){
		Modalbox.hide();
	});
</script>