<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<content>
	<message>${message}</message>
	<premAmt>${premAmt }</premAmt>
	<tsiAmt>${tsiAmt }</tsiAmt>
	<annPremAmt>${annPremAmt }</annPremAmt>
	<annTsiAmt>${annTsiAmt }</annTsiAmt>
	
	<itemNosSize>${itemNosSize }</itemNosSize>
	<c:forEach var="itemNo" items="${itemNos }" varStatus="ctr">
		<itemNo${ctr.index }>${itemNo }</itemNo${ctr.index }>
	</c:forEach>
	
	<towing>${towing}</towing>
	<cocType>${cocType}</cocType>
	<plateNo>${plateNo}</plateNo>
</content>