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
	<input type='hidden' name='globalPackAcceptNo' 	id='globalPackAcceptNo' 	value="${packAcceptNo}"/> <!-- added for ri - irwin -->
	<!-- added the following fields for handling global variables of a selected par in a pack par list (emman 07.15.2011) -->
	<!-- removed (emman 07.28.2011)	
	<input type='hidden' name='globalParId'			id='globalParId'		value=""/>
	<input type='hidden' name='globalLineCd'		id='globalLineCd'		value=""/>
	<input type='hidden' name='globalSublineCd'		id='globalSublineCd'	value=""/> -->
</form>

<script type="text/javaScript" defer="defer">

	objUWParList = JSON.parse('${jsonGIPIPackPARList}'.replace(/\\/g, '\\\\'));
	objGIPIWPolbas = JSON.parse('${jsonGIPIPackWPolbas}'.replace(/\\/g, '\\\\')); // if RI, objGIPIWPolbas is populated by jsonGIRIPackWInPolbas
	
	if(objGIPIWPolbas.issCd == 'RI' || objUWParList.issCd == 'RI'){
		objGIRIPackWInPolbas = JSON.parse('${jsonGiriPackWInPolbas}'.replace(/\\/g, '\\\\'));
	}else{
		clearObjectValues(objGIRIPackWInPolbas);
	}
	
	objGIPIWPackLineSubline = objGIPIWPolbas.gipiwPackLineSubline;
	setGlobalParametersForPackPar(objUWParList);
	objUWGlobal.sublineCd	= objGIPIWPolbas.sublineCd;
	objUWGlobal.issueYy		= objGIPIWPolbas.issueYy;
	objUWGlobal.polSeqNo	= objGIPIWPolbas.polSeqNo;
	objUWGlobal.renewNo		= objGIPIWPolbas.renewNo;
	objUWGlobal.polFlag		= objGIPIWPolbas.polFlag;
	if(objGIPIWPolbas != null){
		formatGIPIWPolbasDateColumns();
	}
	objUWGlobal.enablePackPost = '${enablePackPost}';
	setPackParMenus(objUWGlobal.parStatus, objUWGlobal.lineCd, objUWGlobal.issCd);
</script>
