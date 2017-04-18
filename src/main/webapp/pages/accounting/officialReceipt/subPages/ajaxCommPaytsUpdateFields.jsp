<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<content>
	<convertRate>${params.convertRate }</convertRate>
	<currencyCd>${params.currencyCd }</currencyCd>
	<iCommAmt>${params.iCommAmt }</iCommAmt>
	<iWtax>${params.iWtax }</iWtax>
	<currDesc>${params.currDesc }</currDesc>
	<defFgnCurr>${params.defFgnCurr }</defFgnCurr>
	<message>${params.message }</message>
</content>