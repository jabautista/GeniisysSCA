<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>			
<form id="uwEndtParParametersForm" name="uwEndtParParametersForm">
	<input type="hidden" name="globalEndtParId" 		id="globalEndtParId" 		value="${parId}<c:if test="${empty parId}">0</c:if>"/>
	<input type="hidden" name="globalEndtPolFlag" 		id="globalEndtPolFlag" 		value="${polFlag}"/>
	<input type="hidden" name="globalEndtAssignSw" 		id="globalEndtAssignSw" 	value="${assignSw}"/>
	<input type="hidden" name="globalEndtParStatus" 	id="globalEndtParStatus" 	value="${parStatus}<c:if test="${empty parStatus}">0</c:if>"/>
	<input type="hidden" name="globalEndtParSeqNo" 		id="globalEndtParSeqNo" 	value="${parSeqNo}<c:if test="${empty parSeqNo}">0</c:if>"/>
	<input type="hidden" name="globalEndtAssdNo" 	    id="globalEndtAssdNo" 		value="${assdNo}"/>
	<input type="hidden" name="globalEndtAssdName" 		id="globalEndtAssdName" 	value="${assdName}"/>
	<input type="hidden" name="globalEndtParYy" 	 	id="globalEndtParYy" 		value="${parYy}"/>
	<input type="hidden" name="globalEndtParType"  		id="globalEndtParType" 		value="${parType}"/>
	<input type="hidden" name="globalEndtRemarks"  		id="globalEndtRemarks" 		value="${remarks}"/>
	<input type="hidden" name="globalEndtUnderwriter" 	id="globalEndtUnderwriter" 	value="${underwriter}"/>
	<input type="hidden" name="globalEndtQuoteId" 		id="globalEndtQuoteId" 		value="${quoteId}"/>
	<input type="hidden" name="globalEndtParNo" 		id="globalEndtParNo" 		value="${parNo}"/>
	<input type="hidden" name="globalEndtPackParId" 	id="globalEndtPackParId" 	value="${packParId}<c:if test="${empty packParId}">0</c:if>"/>
	<input type="hidden" name="globalEndtPackParNo" 	id="globalEndtPackParNo" 	value="${packParNo}"/>
	<input type="hidden" name="globalEndtLineCd" 		id="globalEndtLineCd" 		value="${lineCd}" />
	<input type="hidden" name="globalEndtSublineCd" 	id="globalEndtSublineCd" 	value="${sublineCd}"/>
	<!--<input type="hidden" name="globalEndtOpFlag" 		id="globalEndtOpFlag" 		value="${opFlag}"/>-->
	<input type="hidden" name="globalEndtIssCd" 		id="globalEndtIssCd" 		value="${issCd}"/>
	<input type="hidden" name="globalEndtQuoteSeqNo" 	id="globalEndtQuoteSeqNo" 	value="${quoteSeqNo}"/>
	<input type="hidden" name="globalEndtPackPolFlag" 	id="globalEndtPackPolFlag" 	value="${packPolFlag}"/>
	<input type="hidden" name="globalEndtRenewNo"		id="globalEndtRenewNo"		value="${renewNo}"/>
	<input type="hidden" name="globalEndtParSeqNoC"		id="globalEndtParSeqNoC"	value="${parSeqNoC}"/>
	<input type="hidden" name="globalEndtPolSeqNo"		id="globalEndtPolSeqNo"	    value="${polSeqNo}"/>
	<input type="hidden" name="globalEndtIssueYy"		id="globalEndtIssueYy"	    value="${issueYy}"/>
	<input type="hidden" name="globalEndtPolicyId"		id="globalEndtPolicyId"	    value="${endtPolicyId}"/>
	<input type="hidden" name="globalEndtPolicyNo"		id="globalEndtPolicyNo"	    value="${endtPolicyNo}"/>
	<input type="hidden" name="globalExpiryDate"		id="globalExpiryDate"	    value="${expiryDate}"/>
	<input type="hidden" name="globalEndtInceptDate"	id="globalEndtInceptDate"	value="${inceptDate}"/>
	<input type="hidden" name="globalEndtEffDate"		id="globalEndtEffDate"	    value="${effDate}"/>
	<input type="hidden" name="globalEndtExpiryDate"	id="globalEndtExpiryDate"	value="${endtExpiryDate}"/>
	<input type="hidden" name="globalEndtShortRtPercent"	id="globalEndtShortRtPercent" value="${shortRtPercent}"/>
	<input type="hidden" name="globalEndtProvPremPct"	id="globalEndtProvPremPct"  value="${provPremPct}"/>
	<input type="hidden" name="globalEndtCompSw"		id="globalEndtCompSw"  		value="${compSw}"/>
	<input type="hidden" name="globalEndtProvPremPct"	id="globalEndtProvPremPct"  value="${provPremPct}"/>
	<input type="hidden" name="globalEndtProvPremTag"	id="globalEndtProvPremTag"  value="${provPremTag}"/>
	<input type="hidden" name="globalEndtProrateFlag"	id="globalEndtProrateFlag"  value="${prorateFlag}"/>
	<input type="hidden" name="globalWithTariffSw"		id="globalWithTariffSw"  	value="${withTariffSw}"/>
	<input type="hidden" name="globalLineMotor"			id="globalLineMotor"  		value="${lineMotor}"/>
	<input type="hidden" name="globalLineFire"			id="globalLineFire"  		value="${lineFire}"/>
	<input type="hidden" name="globalCtplCd"			id="globalCtplCd" 			value="${ctplCd}"/>
	<input type="hidden" name="globalBackEndt"			id="globalBackEndt" 		value="${backEndt}"/>
</form>
