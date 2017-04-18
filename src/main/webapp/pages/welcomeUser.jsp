<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<div style="width: 78%; z-index: 500; position: relative; top: -64px; font-size: 10px; float: left; margin-left: 200px;">
	<c:if test="${not empty PARAMETERS['USER']}">
		<div id="moduleId" style="color: #fff; float: right; margin-right: 5px;"><label id="lblModuleId" moduleId=""></label></div><br/>	
		<c:if test="${PARAMETERS['USER'].misSw eq 'Y'}">
			<div id="database" style="color: #fff; float: right; margin-right: 5px;"><label id="lblDatabase"  database="${PARAMETERS['database']}">Database: ${PARAMETERS['database']}</label></div><br/>		
		</c:if>		
		<div id="dateAndTime" style="color: #fff; float: right; margin-right: 5px;"></div><br/>	
		<span style="float: right;" id="logoutSpan">
			<fmt:message key="l.main.welcome" bundle="${linkText}"/> ${PARAMETERS['USER'].username}<fmt:message key="l.main.exclaim" bundle="${linkText}"/> 
			<span id="logout" name="logout"><fmt:message key="l.main.logout" bundle="${linkText}" /></span>
		</span>		
		<script>
			$("logout").observe("click", logout);
			getServerDateAndTime();
			
			databaseName = "${PARAMETERS['database']}";
			itemTablegridSw = "${PARAMETERS['itemTablegridSw']}";
			endtBasicInfoSw = "${PARAMETERS['endtBasicInfoSw']}";
		</script>
	</c:if>	
</div>