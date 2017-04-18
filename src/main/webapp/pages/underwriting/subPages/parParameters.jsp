<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>			
<form id="uwParParametersForm" name="uwParParametersForm">
	<input type="hidden" name="globalParId" 		id="globalParId" 		value="${parId}<c:if test="${empty parId}">0</c:if>"/>
	<input type="hidden" name="globalPolFlag" 		id="globalPolFlag" 		value="${polFlag}"/>
	<input type="hidden" name="globalAssignSw" 		id="globalAssignSw" 	value="${assignSw}"/>
	<input type="hidden" name="globalParStatus" 	id="globalParStatus" 	value="${parStatus}<c:if test="${empty parStatus}">0</c:if>"/>
	<input type="hidden" name="globalParSeqNo" 		id="globalParSeqNo" 	value="${parSeqNo}<c:if test="${empty parSeqNo}">0</c:if>"/>
	<input type="hidden" name="globalAssdNo" 	    id="globalAssdNo" 		value="${assdNo}"/>
	<input type="hidden" name="globalAssdName" 		id="globalAssdName" 	value="${assdName}"/>
	<input type="hidden" name="globalParYy" 	 	id="globalParYy" 		value="${parYy}"/>
	<input type="hidden" name="globalParType"  		id="globalParType" 		value="${parType}"/>
	<input type="hidden" name="globalRemarks"  		id="globalRemarks" 		value="${remarks}"/>
	<input type="hidden" name="globalUnderwriter" 	id="globalUnderwriter" 	value="${underwriter}"/>
	<input type="hidden" name="globalQuoteId" 		id="globalQuoteId" 		value="${quoteId}"/>
	<input type="hidden" name="globalParNo" 		id="globalParNo" 		value="${parNo}"/>
	<input type="hidden" name="globalPackParId" 	id="globalPackParId" 	value="${packParId}<c:if test="${empty packParId}">0</c:if>"/>
	<input type="hidden" name="globalPackParNo" 	id="globalPackParNo" 	value="${packParNo}"/>
	<input type="hidden" name="globalLineName" 		id="globalLineName" 	value="${lineName}" />
	<input type="hidden" name="globalLineCd" 		id="globalLineCd" 		value="${lineCd}" />
	<input type="hidden" name="globalSublineCd" 	id="globalSublineCd" 	value="${sublineCd}<c:if test="${empty sublineCd}">${gipiWPolbas.sublineCd}</c:if>"/>
	<input type="hidden" name="globalOpFlag" 		id="globalOpFlag" 		value="${opFlag}"/>
	<input type="hidden" name="globalIssCd" 		id="globalIssCd" 		value="${issCd}"/>
	<input type="hidden" name="globalQuoteSeqNo" 	id="globalQuoteSeqNo" 	value="${quoteSeqNo}"/>
	<input type="hidden" name="globalPackPolFlag" 	id="globalPackPolFlag" 	value="${packPolFlag}"/>
	<input type="hidden" name="globalRenewNo"		id="globalRenewNo"		value="${renewNo}"/>
	<input type="hidden" name="globalParSeqNoC"		id="globalParSeqNoC"	value="${parSeqNoC}"/>
	<input type="hidden" name="globalPolSeqNo"		id="globalPolSeqNo"	    value="${polSeqNo}"/>
	<input type="hidden" name="globalIssueYy"		id="globalIssueYy"	    value="${issueYy}"/>
	<input type="hidden" name="globalAddress1"		id="globalAddress1"	    value="${address1}"/>
	<input type="hidden" name="globalAddress2"		id="globalAddress2"	    value="${address2}"/>
	<input type="hidden" name="globalAddress3"		id="globalAddress3"	    value="${address3}"/>
	<input type="hidden" name="globalEndtPolicyId"		id="globalEndtPolicyId"	    value="${endtPolicyId}"/>
	<input type="hidden" name="globalEndtPolicyNo"		id="globalEndtPolicyNo"	    value="${endtPolicyNo}"/>
	<input type="hidden" name="globalIssueDate"			id="globalIssueDate"		value="<fmt:formatDate value="${issueDate}" pattern="MM-dd-yyyy HH:mm:ss" />" />
	<input type="hidden" name="globalExpiryDate"		id="globalExpiryDate"	    value="<fmt:formatDate value="${expiryDate}" pattern="MM-dd-yyyy HH:mm:ss" />"/>
	<input type="hidden" name="globalInceptDate"		id="globalInceptDate"		value="<fmt:formatDate value="${inceptDate}" pattern="MM-dd-yyyy HH:mm:ss" />"/>
	<input type="hidden" name="globalEffDate"			id="globalEffDate"	    	value="<fmt:formatDate value="${effDate}" pattern="MM-dd-yyyy HH:mm:ss" />"/>
	<input type="hidden" name="globalEndtExpiryDate"	id="globalEndtExpiryDate"	value="<fmt:formatDate value="${endtExpiryDate}" pattern="MM-dd-yyyy HH:mm:ss" />"/>
	<input type="hidden" name="globalShortRtPercent"	id="globalShortRtPercent" 	value="${shortRtPercent}"/>
	<input type="hidden" name="globalProvPremPct"		id="globalProvPremPct"  	value="${provPremPct}"/>
	<input type="hidden" name="globalCompSw"			id="globalCompSw"  			value="${compSw}"/>
	<input type="hidden" name="globalProvPremPct"		id="globalProvPremPct"  	value="${provPremPct}"/>
	<input type="hidden" name="globalProvPremTag"		id="globalProvPremTag"  	value="${provPremTag}"/>
	<input type="hidden" name="globalProrateFlag"		id="globalProrateFlag"  	value="${prorateFlag}"/>
	<input type="hidden" name="globalWithTariffSw"		id="globalWithTariffSw"  	value="${withTariffSw}"/>
	<input type="hidden" name="globalLineMotor"			id="globalLineMotor"  		value="${lineMotor}"/>
	<input type="hidden" name="globalLineFire"			id="globalLineFire"  		value="${lineFire}"/>
	<input type="hidden" name="globalCtplCd"			id="globalCtplCd" 			value="${ctplCd}"/>
	<input type="hidden" name="globalBackEndt"			id="globalBackEndt" 		value="${backEndt}"/>
	<input type="hidden" name="globalEndtTax"			id="globalEndtTax"	 		value="${endtTax}"/>
	<input type="hidden" name="globalMenuLineCd"		id="globalMenuLineCd"	 	value="${menuLineCd}"/>
	<input type="hidden" name="globalInvoiceTag"		id="globalInvoiceTag" 		value="${gipiInvoiceExist}"/>
	<input type="hidden" name="globalIssCdRI"			id="globalIssCdRI" 			value="${issCdRI}"/>  
</form>

<script type="text/javaScript" defer="defer">
	objUWParList = JSON.parse('${jsonGIPIPARList}'.replace(/\\/g, '\\\\'));
	objGIPIWPolbas = JSON.parse('${jsonGIPIWPolbas}'.replace(/\\/g, '\\\\'));
	objUWGlobal.isExistGipiWInvoice = ('${isExistGipiWInvoice}'); // "1" if exist else "0" gipi_winvoice_pkg.get_gipi_winvoice_exist2
	/*	if(nvl('${riFlag}', null) != null) {
		objGIRIWInPolbas = JSON.parse('${jsonGIRIWInPolbas}'.replace(/\\/g, '\\\\'));
	}*/
	// Added by		: mark jm 12.21.2010
	// Description	: update the date columns of gipi_wpolbas (apply the date format)	
	if(objGIPIWPolbas != null){
		objUWGlobal.formattedIssueDate = '${formattedIssueDate}'; // apollo cruz 09.11.2015 sr#19975
		formatGIPIWPolbasDateColumns();
	}
	objUWGlobal.enablePost = '${enablePost}'; // by bonok :: 08.29.2012 para pag may laman na ung gipi_wcomm_invoices saka mag eenable ung Post. 'Y' = enable 'N' = disable
	objUWGlobal.enableDist = '${enableDist}'; // by bonok :: 08.30.2012
	setParMenus(objUWParList.parStatus, objUWParList.lineCd, objUWParList.sublineCd, objUWParList.opFlag, objUWParList.issCd); // andrew - 03.02.2011 - added this function call to set par menus when updateParParameters function is called
</script>
