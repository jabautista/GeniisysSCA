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
	<div style="padding: 10px; height: 315px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
		<jsp:include page="/pages/underwriting/reInsurance/createRiPlacement/subPages/searchPreviousRiAjaxResult.jsp"></jsp:include>
	</div>
	
	<div id="divB" align="center" style="margin-right: 0;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnCancel" class="button" value="Cancel" style="width: 60px;" />
	</div>
</div>
<script type="text/javascript">
	//searchPreviousRiModal(1); //marco - GENQA 5256 - 01.04.2016

	//when CANCEL button click
	$("btnCancel").observe("click", function (){
		//Modalbox.hide();
		previousRiListOverlay.close();
	});
</script>