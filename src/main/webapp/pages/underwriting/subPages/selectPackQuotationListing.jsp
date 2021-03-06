<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br/>
<div id="packQuotationListingDiv" name="packQuotationListingDiv" style="margin: 5px;">
	<div style="margin-top: 10px; width: 100%;" id="packQuotationListingTable" name="packQuotationListingTable">
		<div style="width: 100%;">
			<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
			<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>
		</div>
		<div id="selectPackQuotationListingDiv" name="selectPackQuotationListingDiv">
			<jsp:include page="/pages/underwriting/subPages/selectPackQuotationListingTable.jsp"></jsp:include>
		</div>
		<div id="selectedDiv" name="selectedDiv" style="display: none;">
			<input type="hidden" id="selectedPackQuoteId" 	name="selectedPackQuoteId"/>
			<input type="hidden" id="selectedIssCd" 		name="selectedIssCd"/>
			<input type="hidden" id="selectedLineCd" 		name="selectedLineCd"/>
			<input type="hidden" id="selectedSublineCd" 	name="selectedSublineCd"/>
			<input type="hidden" id="selectedQuotationYy" 	name="selectedQuotationYy"/>
			<input type="hidden" id="selectedQuotationNo" 	name="selectedQuotationNo"/>
			<input type="hidden" id="selectedProposalNo" 	name="selectedProposalNo"/>
			<input type="hidden" id="selectedAssdNo" 		name="selectedAssdNo"/>
			<input type="hidden" id="selectedAssdName"		name="selectedAssdName"/>
			<input type="hidden" id="selectedAssd"          name="selectedAssd"/>
			<input type="hidden" id="selectedAssdActiveTag"	name="selectedAssdActiveTag"/>
			<input type="hidden" id="selectedValidDate"		name="selectedValidDate"/>

		</div>
	</div>
</div>
<script type="text/javaScript">


	$("keyword").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			$("keyWord").value = $("keyword").value;
			goToPageNoSearchSpanFixed("selectPackQuotationListingDiv", "/GIPIPackQuoteController?ajax=1"+Form.serialize("createPackPARForm"), "filterPackQuoteListing", 1);
		}
	});
	
	$("go").observe("click", function () {
		$("keyWord").value = $("keyword").value;
		goToPageNoSearchSpanFixed("selectPackQuotationListingDiv", "/GIPIPackQuoteController?ajax=1"+Form.serialize("createPackPARForm"), "filterPackQuoteListing", 1);
	});

	$$("label[id='add']").each(function(lab) {
			lab.hide();
		}
	);
	
	$$("label[id='edit']").each(function(lab) {
			lab.hide();
		}
	);
	
	$$("label[id='delete']").each(function(lab) {
			lab.hide();
		}
	);
	
	$$("label[id='filter']").each(function(lab){
			lab.innerHTML = "OK";
		}
	);
	
	$("filter").observe("click", function(){
		if ("0" != $F("globalParId")){
			showMessageBox("Unable to update record ... permission denied.", "info");
		} else {
			checkIfValidDate();
		}
	});
	
	$("search").observe("click", function () {
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});
	
	//$("searchSpan").setStyle("margin-top: 1px; margin-right: 1em;");

	function clearPackParForm() {
		$("packLineCdSel").value	= "";
		$("packIssCd").value	= "";
		$("parSeqNo").value = "";
		$("assuredName").value = "";
		$("assuredNo").value = "";
	}

	var searchElement = $("search");
	var arr = searchElement.cumulativeOffset();
	$("searchSpan").setStyle("margin-top: 1px; margin-right: 1em; margin-left: "+(arr[0] - 450)+"px;");
</script>