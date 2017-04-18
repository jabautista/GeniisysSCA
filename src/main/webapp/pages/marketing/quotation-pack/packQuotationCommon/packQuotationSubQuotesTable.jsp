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
	<div id="packQuotationTableDiv" name="packQuotationTableDiv" style="margin:10px; width: 800px;">
		<div id="packQuoteTableHeader" class="tableHeader">
			<label style="width: 270px;; text-align: left; margin-left: 5px;">Quotation No.</label>
			<label style="width: 200px;">Line Name</label>
			<label style="width: 300px;">Subline Name</label>
		</div>
		<div id="packQuoteTableContainer" class="tableContainer">
			<c:forEach var="quote" items="${packQuoteList}">
				<div id="quoteRow${quote.quoteId}" class="tableRow" name="quoteRow" quoteId="${quote.quoteId}" lineCd="${quote.lineCd}" 
					 menuLineCd="${quote.menuLineCd}" sublineCd="${quote.sublineCd}" issCd="${quote.issCd}">
					<label style="width: 270px; text-align: left; margin-left: 5px;">${quote.quoteNo}</label>
					<label style="width: 200px; text-align: left;">${quote.lineName}</label>
					<label style="width: 300px; text-align: left;">${quote.sublineName}</label>
				</div>
			</c:forEach>
		</div>
	</div>
</div>

<script type="text/javascript">
	$$("div[name='quoteRow']").each(function(row){
		loadRowMouseOverMouseOutObserver(row);
	});

	checkIfToResizeTable2("packQuoteTableContainer", "quoteRow");
</script>