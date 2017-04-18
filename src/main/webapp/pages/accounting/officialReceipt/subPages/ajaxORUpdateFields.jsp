<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<content>
	<payor><![CDATA[${payor}]]></payor>
	<address1><![CDATA[${address1}]]></address1>
	<address2><![CDATA[${address2}]]></address2>
	<address3><![CDATA[${address3}]]></address3>
	<orDate><![CDATA[${orDate}]]></orDate>
	<orTag><![CDATA[${orTag}]]></orTag>
	<particulars><![CDATA[${particulars}]]></particulars>
	<tin><![CDATA[${tinNo}]]></tin>
	<gaccTranId><![CDATA[${gaccTranId}]]></gaccTranId>
</content>