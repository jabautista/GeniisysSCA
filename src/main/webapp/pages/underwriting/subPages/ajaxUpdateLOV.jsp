<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<content>
	<!-- GIPIS060 Motor Types -->
	<motorTypeListSize>${motorTypeListSize }</motorTypeListSize>
	<c:forEach var="motorTypes" items="${motorTypeList }" varStatus="ctr">
		<motorTypeCd${ctr.index }>${motorTypes.typeCd }</motorTypeCd${ctr.index }>
		<motorTypeDesc${ctr.index }>${motorTypes.motorTypeDesc }</motorTypeDesc${ctr.index }>
		<motorUnladenWt${ctr.index }>${motorTypes.unladenWt }</motorUnladenWt${ctr.index }>
	</c:forEach>
	
	<!-- GIPIS060 Subline Types -->
	<sublineTypeListSize>${sublineTypeListSize }</sublineTypeListSize>
	<c:forEach var="sublineTypes" items="${sublineTypeList }" varStatus="ctr">
		<sublineTypeCd${ctr.index }>${sublineTypes.sublineTypeCd }</sublineTypeCd${ctr.index }>
		<sublineTypeDesc${ctr.index }>${sublineTypes.sublineTypeDesc }</sublineTypeDesc${ctr.index }>
	</c:forEach>
</content>