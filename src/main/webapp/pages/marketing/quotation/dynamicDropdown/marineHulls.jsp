<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<json:object>
	<json:array name="mHulls" var="m" items="${marineHulls}">
		<json:object>
			<json:property name="vesselName" 	value="${m.vesselCd}" />
			<json:property name="vesselFlag" 	value="${m.vesselName}" />
			<json:property name="vesselOldName" value="${m.vesselOldName}" />
			<json:property name="vesTypeCd" 	value="${m.vesTypeCd}" />
			<json:property name="vesTypeDesc" 	value="${m.vesTypeDesc}" />
			<json:property name="propelSw" 		value="${m.propelSw}" />
			<json:property name="hullTypeCd" 	value="${m.hullTypeCd}" />
			<json:property name="hullDesc" 		value="${m.hullDesc}" />
			<json:property name="grossTon" 		value="${m.grossTon}" />
			<json:property name="yearBuilt" 	value="${m.yearBuilt}" />
			<json:property name="vessClassCd" 	value="${m.vessClassCd}" />
			<json:property name="vessClassDesc" value="${m.vessClassDesc}" />
			<json:property name="vesselCd" 		value="${m.vesselCd}" />
			<json:property name="regOwner" 		value="${m.regOwner}" />
			<json:property name="regPlace" 		value="${m.regPlace}" />
			<json:property name="noCrew" 		value="${m.noCrew}" />
			<json:property name="netTon" 		value="${m.netTon}" />
			<json:property name="deadWeight" 	value="${m.deadWeight}" />
			<json:property name="crewNat" 		value="${m.crewNat}" />
			<json:property name="dryPlace" 		value="${m.dryPlace}" />
			<json:property name="dryDate" 		value="${m.dryDate}" />
			<json:property name="vesselLength" 	value="${m.vesselLength}" />
			<json:property name="vesselBreadth"	value="${m.vesselBreadth}" />
			<json:property name="vesselDepth" 	value="${m.vesselDepth}" />
		</json:object>
	</json:array>
</json:object>