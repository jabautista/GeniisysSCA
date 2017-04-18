<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="instNoListDiv" style="padding: 10px; height: 370px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	<input type="hidden" id="issCd" value="${issCd}" />
	<input type="hidden" id="premSeqNo" value="${premSeqNo}" />
</div>
<script>
	reloadInstList(1, $F("issCd"), $F("premSeqNo"));
</script>