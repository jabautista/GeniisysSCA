<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<table style="margin-top: 10px; width: 100%;">
	<tr>
		<td class="rightAligned" style="width: 25%;">
			PAR No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="parNo" class="leftAligned" type="text" name="parNo" style="width: 80%;" readonly="readonly" value="${pol.parNo}"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Assured Name
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="assdName" class="leftAligned" type="text" name="parNo" style="width: 80%;" readonly="readonly" value="${pol.assdName}"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Policy No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="policyNo" class="leftAligned" type="text" name="policyNo" style="width: 80%;" readonly="readonly" value="${pol.policyNo}"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Invoice No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<select id="invoiceNo" class="leftAligned" name="invoiceNo" style="width: 81%;"/>
				<option value=""></option>
				<c:forEach items="${invoiceListing}" var="inv" varStatus="ctr">
					<option value="${inv.invoice}">${inv.invoice}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Endorsement No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="endorsementNo" class="leftAligned" type="text" name="parNo" style="width: 80%;" readonly="readonly" value="${pol.endtNo}"/>
		</td>
	</tr>
	<tr>
		<td colspan="2"></td>
	</tr>
</table>
<div>
	<input type="hidden" id="packPolicyId" value="${pol.packPolicyId}">
	<input type="hidden" id="policyLineCd" value="${pol.lineCd}">
	<input type="hidden" id="sublineCd" value="${pol.sublineCd}">
	<input type="hidden" id="issCd" value="${pol.issCd}">
	<input type="hidden" id="issueYy" value="${pol.issueYy}">
	<input type="hidden" id="polSeqNo" value="${pol.polSeqNo}">
	<input type="hidden" id="renewNo" value="${pol.renewNo}">
	<input type="hidden" id="endtIssCd" value="${pol.endtIssCd}">
	<input type="hidden" id="endtYy" value="${pol.endtYy}">
	<input type="hidden" id="endtSeqNo" value="${pol.endtSeqNo}">
	<input type="hidden" id="policyId" value="${pol.policyId}">
	<input type="hidden" id="assdNo" value="${pol.assdNo}">
	<input type="hidden" id="endtType" value="${pol.endtType}">
	<input type="hidden" id="parId" value="${pol.parId}">
	<input type="hidden" id="noOfItems" value="${pol.noOfItems}">
	<input type="hidden" id="polFlag" value="${pol.polFlag}">
	<input type="hidden" id="packPol" value="${pol.packPol}">
	<input type="hidden" id="coInsuranceSw" value="${pol.coInsuranceSw}">
	<input type="hidden" id="billNotPrinted" value="${pol.billNotPrinted}">
	<input type="hidden" id="policyDsDtlExist" value="${pol.policyDsDtlExist}">
	<input type="hidden" id="endtTax" value="${pol.endtTax}">
	<input type="hidden" id="itmperilCount" value="${pol.itmperilCount}">
	<input type="hidden" id="compulsoryDeath" value="${pol.compulsoryDeath}">
	<input type="hidden" id="cocType" value="${pol.cocType}">
	<input type="hidden" id="extractId" value="0">
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="vShowField" value="${vShowField}">
	<input type="hidden" id="vAccSlip" value="${vAccSlip}">
	<input type="hidden" id="vMed" value="${vMed}">
	<input type="hidden" id="packPolFlag" value="${pol.packPolFlag}">
	<input type="hidden" id="withMc" value="${withMc}">
</div>