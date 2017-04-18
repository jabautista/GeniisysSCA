<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Quotation Listing</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="packQuotationListingSectionDiv" name="packQuotationListingSectionDiv" class="sectionDiv" align="center">
	<div id="packQuotationListDiv" name="packQuotationListDiv" style="margin:10px; width: 800px;">
		<div id="quoteTableHeader" class="tableHeader">
			<label style="width: 230px;; text-align: left; margin-left: 5px;">Quotation No.</label>
			<label style="width: 120px;">Date Created</label>
			<label style="width: 120px;">Incept Date</label>
			<label style="width: 120px;">Expiry Date</label>
			<label style="width: 100px;">Days</label>
			<label style="width: 80px;">User Id</label>
		</div>
		<div id="packQuoteContainer" class="tableContainer">
			<c:forEach var="quote" items="${packQuoteList}">
				<div id="quoteRow${quote.quoteId}" class="tableRow" name="quoteRow" quoteId="${quote.quoteId}" lineCd="${quote.lineCd}" 
					 menuLineCd="${quote.menuLineCd}" sublineCd="${quote.sublineCd}" issCd="${quote.issCd}">
					<label style="width: 230px; text-align: left; margin-left: 5px;">${quote.quoteNo}</label>
					<label style="width: 120px; text-align: left;">${quote.acceptDt}</label>
					<label style="width: 120px; text-align: left;">${quote.inceptDate}</label>
					<label style="width: 120px; text-align: left;">${quote.expiryDate}</label>
					<label style="width: 100px; text-align: left;">${quote.elapsedDays} days</label>
					<label style="width: 80px; text-align: left;">${quote.underwriter}</label>
				</div>
			</c:forEach>
		</div>
	</div>
</div>

<script type="text/javascript">
	$$("div[name='quoteRow']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	});

	checkIfToResizeTable2("packQuoteContainer", "quoteRow");
</script>