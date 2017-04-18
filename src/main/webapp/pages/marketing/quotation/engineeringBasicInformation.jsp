<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Quotation Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="hideForm" name="gro" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>
<div id="engineeringBasicInformationMainDiv" name="engineeringBasicInformationMainDiv" style="margin-top: 1px;">
	<jsp:include page="subPages/engineeringBasicQuotationInfo.jsp"></jsp:include>
</div>
<script>
	initializeAll();
/* 	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		showQuotationListing();
	});  move by steven 10.02.2013*/
</script>
