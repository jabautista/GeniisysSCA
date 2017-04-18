<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="packAdditionalInformationMainDiv" name="packAdditionalInformationMainDiv" style="display: none;">
	<c:forEach var="line" items="${packLines}">
		<c:if test="${line.lineCd eq 'FI' or line.menuLineCd eq 'FI'}">
			<div id="packAdditionalInfoFI" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/quoteFireItemInfoAdditional.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'MC' or line.menuLineCd eq 'MC'}">
			<div id="packAdditionalInfoMC" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/quoteMotorItemInfoAdditional.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'AC' or line.menuLineCd eq 'AC'}">
			<div id="packAdditionalInfoAC" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/accidentAdditionalInformation.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'AV' or line.menuLineCd eq 'AV'}">
			<div id="packAdditionalInfoAV" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/aviationAdditionalInformation.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'CA' or line.menuLineCd eq 'CA'}">
			<div id="packAdditionalInfoCA" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/casualtyAdditionalInformation.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'EN' or line.menuLineCd eq 'EN'}">
			<div id="packAdditionalInfoEN" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/engineeringAdditionalInformation.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'MN' or line.menuLineCd eq 'MN'}">
			<div id="packAdditionalInfoMN" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/marineCargoAdditionalInformation.jsp"></jsp:include>
			</div>
		</c:if>
		<c:if test="${line.lineCd eq 'MH' or line.menuLineCd eq 'MH'}">
			<div id="packAdditionalInfoMH" name="packAdditionalInfo" style="display: none;">
				<jsp:include page="/pages/marketing/quotation/subPages/quotationInformation/marineHullAdditionalInformation.jsp"></jsp:include>
			</div>
		</c:if>
	</c:forEach>
</div>

<script type="text/javascript">
	
	($$("div#packAdditionalInformationMainDiv div:not([name='packAdditionalInfo'])")).invoke("show");
	($$("div#packAdditionalInfoAV div([name='vessels'])")).invoke("hide");

</script>