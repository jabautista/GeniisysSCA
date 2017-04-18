<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<content>
	<!-- changed params to params2 based on the setAttribute in GIACPremDepositController : shan 11.04.2013 -->
	<lineCd>${params2.lineCd }</lineCd>
	<sublineCd>${params2.sublineCd }</sublineCd>
	<issCd>${params2.issCd }</issCd>
	<issueYy>${params2.issueYy }</issueYy>
	<polSeqNo>${params2.polSeqNo }</polSeqNo>
	<renewNo>${params2.renewNo }</renewNo>
	<assdNo>${params2.assdNo }</assdNo>
	<dspA150LineCd>${params2.dspA150LineCd }</dspA150LineCd>
	<riCd>${params2.riCd }</riCd>
	<riName>${params2.riName }</riName>
	<drvAssuredName>${params2.drvAssuredName }</drvAssuredName>
	<assuredName>${params2.assuredName }</assuredName>
	<parLineCd>${params2.parLineCd }</parLineCd>
	<parIssCd>${params2.parIssCd }</parIssCd>
	<parYy>${params2.parYy }</parYy>
	<parSeqNo>${params2.parSeqNo }</parSeqNo>
	<quoteSeqNo>${params2.quoteSeqNo }</quoteSeqNo>
	
	<msg>${params2.message }</msg>
</content>