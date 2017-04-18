<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!--<input type="hidden" id="totalDisbursementAmount" 	 name="totalDisbursementAmount" value="disbursementAmount"/>-->
<input type="hidden" id="hidInputVatAmount" name="hidInputVatAmount" value="${inputVatAmount}" />
<input type="hidden" id="hidWithholdingTaxAmount" name="hidWithholdingTaxAmount" value="${withholdingTaxAmount}"/>
<input type="hidden" id="hidNetDisbursementAmount" name="hidNetDisbursementAmount" value="${netDisbursementAmount}"/>

<input type="hidden" id="totalNetDisbursementAmount" name="totalNetDisbursementAmount" value="${totalNetDisbursementAmount}"/>
<input type="hidden" id="totalInputVatAmount" name="totalInputVatAmount" value="${totalInputVatAmount}"/>
<input type="hidden" id="totalWithholdingTaxAmount" name="totalTaxWithholdingAmount" value="${totalWithholdingAmount}"/>
