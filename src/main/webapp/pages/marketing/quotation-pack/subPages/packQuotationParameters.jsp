<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>		

<form id='mkQuotationParametersForm' name='mkQuotationParametersForm'>
	<input type='hidden' name='globalPackQuoteId' 	id='globalPackQuoteId' 	value="${packQuoteId}<c:if test="${empty packQuoteId}">0</c:if>"/>
	<input type='hidden' name='globalAssdName' 		id='globalAssdName' 	value="${assdName}"/>
	<input type='hidden' name='globalQuotationNo' 	id='globalQuotationNo' 	value="${quotationNo}"/>
	<input type='hidden' name='globalQuoteNo' 		id='globalQuoteNo' 		value="${quoteNo}"/>
</form>

<script type="text/javascript">
	try{
		objGIPIPackQuote = JSON.parse('${jsonGIPIPackQuote}'.replace(/\\/g, '\\\\'));
		objGIPIPackQuotations = JSON.parse('${jsonPackQuotations}'.replace(/\\/g, '\\\\'));
		setPackQuotationGlobalParameters(objGIPIPackQuote);
	}catch(e){
		showErrorMessage("packQuotationParameters.jsp", e);
	}	
</script>