<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<form id='uwParParametersForm' name='uwParParametersForm'>
	<input type='hidden' name='globalPackParId' 	id='globalPackParId' 	value="${packParId}<c:if test="${empty packParId}">0</c:if>"/>
	<input type="hidden" name="globalParSeqNo" 		id="globalParSeqNo" 	value="${parSeqNo}<c:if test="${empty parSeqNo}">0</c:if>"/>
	<input type='hidden' name='globalParStatus' 	id='globalParStatus' 	value="${parStatus}<c:if test="${empty parStatus}">0</c:if>"/>
	<input type='hidden' name='globalPackPolFlag' 	id='globalPackPolFlag' 	value="${packPolFlag}"/>
	<input type='hidden' name='globalPackAcceptNo' 	id='globalPackAcceptNo' 	value="${packAcceptNo}"/>
</form>

<script>
	objUWParList = JSON.parse('${jsonGIPIPackPARList}'.replace(/\\/g, '\\\\'));
	objGIRIPackWInPolbas = JSON.parse('${jsonGIRIPackWInPolBas}'.replace(/\\/g, '\\\\'));
	setGlobalParametersForPackPar(objUWParList);
	setPackParMenus(objUWGlobal.parStatus, objUWGlobal.lineCd, objUWGlobal.issCd); // temp muna galing par, palitan pag may basic na si ri pack
</script>