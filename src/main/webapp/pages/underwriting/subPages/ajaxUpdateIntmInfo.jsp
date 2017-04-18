<?xml version="1.0" encoding="UTF-8"?>
<%@ page contentType="text/xml" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<content>	
	<peril>
		<message>${message}</message>
		<premiumAmt>${pSharePremium }</premiumAmt>
		<varTaxAmt>${varTaxAmt }</varTaxAmt>
		<c:forEach var="peril" items="${pPerilCode }" varStatus="ctr">
			<perilCd${peril }>${peril }</perilCd${peril }>
			<premiumAmt${peril }>${pPremiumAmt[ctr.index] }</premiumAmt${peril }>
			<commissionRate${peril }>${pCommissionRate[ctr.index] }</commissionRate${peril }>
			<commissionAmt${peril }>${pCommissionAmt[ctr.index] }</commissionAmt${peril }>
			<wholdingTax${peril }>${pWholdingTax[ctr.index] }</wholdingTax${peril }>
			<netCommission${peril }>${pNetCommission[ctr.index] }</netCommission${peril }>
			<varRate${peril }>${varRate[ctr.index] }</varRate${peril }>			
		</c:forEach>
	</peril>
</content>