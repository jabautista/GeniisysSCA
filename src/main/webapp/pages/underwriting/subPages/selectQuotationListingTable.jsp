<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="tableHeader" style="width: 100%;">
	<label style="width: 25%; text-align: center; margin-left: 56px;">Quotation No.</label>
	<label style="width: 15%; text-align: left; margin-left: 5px;">Assured No.</label>
	<label style="text-align: center; margin-left: 2px;">Assured Name</label>
</div>
<div id="quoteTableDiv" name="quoteTableDiv" class="tableContainer">
	<c:forEach var="quote" items="${quoteList}" varStatus="ctr">
		<div id="row${quote.quoteId}" name="row2" class="tableRow" style="width: 99.7%;">
			<label style="width: 25%; text-align: left; display: block; margin-left: 50px;">${quote.lineCd}-${quote.sublineCd}-${quote.issCd}-${quote.quotationYy}-${quote.quoteNo}-${quote.proposalNo}</label>
			<label style="width: 15%; text-align: left; display: block; margin-left: 10px;" title="${quote.assdNo}">${quote.assdNo}<c:if test="${empty quote.assdNo}">---</c:if></label>
   			<label style="text-align: left; display: block;" name="text">${quote.assdName}<c:if test="${empty quote.assdName}">---</c:if></label>
   			<input type="hidden" id="quoteId${quote.quoteId}"	name="quoteId"		value="${quote.quoteId}">
   			<input type="hidden" id="issCd${quote.quoteId}"		name="issCd"		value="${quote.issCd}">
   			<input type="hidden" id="lineCd${quote.quoteId}"	name="lineCd"		value="${quote.lineCd}">
   			<input type="hidden" id="sublineCd${quote.quoteId}"	name="sublineCd"	value="${quote.sublineCd}">
   			<input type="hidden" id="quotationYy${quote.quoteId}" name="quotationYy" value="${quote.quotationYy}">
   			<input type="hidden" id="quoteNo${quote.quoteId}"	name="quoteNo"		value="${quote.quoteNo}">
   			<input type="hidden" id="proposalNo${quote.quoteId}" name="proposalNo"	value="${quote.proposalNo}">
   			<input type="hidden" id="assdNo${quote.quoteId}"	name="assdNo"		value="${quote.assdNo}">
   			<input type="hidden" id="assdName${quote.quoteId}"	name="assdName"		value="${quote.assdName}">
   			<input type="hidden" id="assdActiveTag${quote.quoteId}"	name="assdActiveTag"		value="${quote.assdActiveTag}">
   			<input type="hidden" id="validDate${quote.quoteId}"	name="validDate"		value="${quote.validDate}">
		</div>
	</c:forEach>
</div>
<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
		
<script type="text/javaScript">

$$("div[name='row2']").each(
	function (row)	{
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
		
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});

		row.observe("dbclick", function() {
			turnQuoteToPAR(); 
			}
		);

		row.observe("click", function ()	{
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow"))	{
				try {
					$$("div[name='row2']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});

					
					var quoteId			= row.down("input", 0).value;
					var issCd			= row.down("input", 1).value;
					var	lineCd 			= row.down("input", 2).value;
					var sublineCd		= row.down("input", 3).value;
					var quotationYy		= row.down("input", 4).value;
					var	quoteNo 		= row.down("input", 5).value;
					var proposalNo		= row.down("input", 6).value;
					var assdNo			= row.down("input", 7).value;
					var assdName		= row.down("input", 8).value;
					var assdActiveTag	= row.down("input", 9).value;
					var validDate		= row.down("input", 10).value;

					$("selectedQuoteId").value = quoteId;
					$("selectedIssCd").value = issCd;
					$("selectedLineCd").value = lineCd;
					$("selectedSublineCd").value = sublineCd;
					$("selectedQuotationYy").value = quotationYy;
					$("selectedQuoteNo").value = quoteNo;
					$("selectedProposalNo").value = proposalNo;
					$("selectedAssdNo").value = assdNo;
					$("selectedAssdName").value = assdName;
					$("selectedAssdActiveTag").value = assdActiveTag;
					$("selectedValidDate").value = validDate;
					$("quoteId").value = quoteId;

				} catch (e){
					showErrorMessage("selectQuotationListingTable.jsp - click", e);
				}
			}
			else {
				
				$("selectedQuoteId").value = "";
				$("selectedIssCd").value = $("defaultIssCd").value;
				$("selectedLineCd").value = $("tempLineCd").value;
				$("selectedSublineCd").value = "";
				$("selectedQuotationYy").value = "";
				$("selectedQuoteNo").value = "";
				$("selectedProposalNo").value = "";
				$("selectedAssdNo").value = "";
				$("selectedAssdName").value = "";
				$("selectedAssdActiveTag").value = "";
				$("selectedValidDate").value = "";
				$("quoteId").value = "";
		}});

		row.observe("dblclick", function(){
			var quoteId			= row.down("input", 0).value;
			var issCd			= row.down("input", 1).value;
			var	lineCd 			= row.down("input", 2).value;
			var sublineCd		= row.down("input", 3).value;
			var quotationYy		= row.down("input", 4).value;
			var	quoteNo 		= row.down("input", 5).value;
			var proposalNo		= row.down("input", 6).value;
			var assdNo			= row.down("input", 7).value;
			var assdName		= row.down("input", 8).value;
			var assdActiveTag	= row.down("input", 9).value;
			var validDate		= row.down("input", 10).value;

			$("selectedQuoteId").value = quoteId;
			$("selectedIssCd").value = issCd;
			$("selectedLineCd").value = lineCd;
			$("selectedSublineCd").value = sublineCd;
			$("selectedQuotationYy").value = quotationYy;
			$("selectedQuoteNo").value = quoteNo;
			$("selectedProposalNo").value = proposalNo;
			$("selectedAssdNo").value = assdNo;
			$("selectedAssdName").value = assdName;
			$("selectedAssdActiveTag").value = assdActiveTag;
			$("selectedValidDate").value = validDate;
			$("quoteId").value = quoteId;
			checkIfValidDate();
		});
	}
);

$$("label[name='text']").each(function (label)	{
	if ((label.innerHTML).length > 60)	{
		label.update((label.innerHTML).truncate(60, "..."));
	}
});

if (!$("pager").innerHTML.blank()) {
	try {
		initializePagination("selectQuotationListingDiv", "/GIPIQuotationController?"+Form.serialize("creatPARForm"), "filterQuoteListing");
	} catch (e) {
		showErrorMessage("selectQuotationListingTable.jsp - pager", e);
	}
}

$("pager").setStyle("margin-top: 10px;");

</script>